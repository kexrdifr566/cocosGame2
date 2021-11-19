CC_F = 0
CC_M = 1
CC_H = 2
CC_T = 3

local CardLayer = class("CardLayer", function ()
	local CardLayer =  display.newLayer()
	return CardLayer
end)
local playerCount=0
local defScale = 0.5  --发牌初始大小
local mycardScale = 0.7 --我的牌大小
local OtherCardScale = 0.35 --其他人的牌的大小
local th5pot=cc.p(124,172)

function CardLayer:ctor(scene,number)
	self.scene=scene
	if number < 4 or number >10 or number ==7 or number == 9 then
		showToast("房间人数错误！",1)
		return
	end
	playerCount=number

	local rootLayer, csbNode = ExternalFun.loadzRootCSB("Game/cowLayer/CardLayer.csb", self)
	for i = 6, 10 do
		if i ~=	7 and i ~=	9 and  i ~= number then
			local card=string.format("%dCard",i)
			csbNode:getChildByName(card):removeFromParent()
		end
	end
	local card=string.format("%dCard",number)
	--玩家手里拍
	self.pcard={}
	self.cardLayer=csbNode:getChildByName(card)
	self.pcm={}
    self.cardxy={}
	for i=1,number do
		local pp=string.format("P%d",i)
		local card1=self.cardLayer:getChildByName(pp.."1")
		local card2=self.cardLayer:getChildByName(pp.."2")
		local card3=self.cardLayer:getChildByName(pp.."3")
		local card4=self.cardLayer:getChildByName(pp.."4")
		local card5=self.cardLayer:getChildByName(pp.."5")
		self.pcard[i]={card1,card2,card3,card4,card5}
		self.pcm[i]=self.cardLayer:getChildByName(string.format("m%d",i))
        self.cardxy[i]={card1:getPositionX(),card2:getPositionX(),card3:getPositionX(),card4:getPositionX(),card5:getPositionX(),
        card1:getPositionY(),card2:getPositionY(),card3:getPositionY(),card4:getPositionY(),card5:getPositionY()}
	end

	--默认最后一位就是总注
	csbNode:getChildByName("zm"):setVisible(false)
    --动画列表
    self.Arm={}
    --创建动画
    self:createArm(number)
end
function CardLayer:reGame()
	--隐藏牌
    self:stopAllActions()
	for k,v in pairs(self.pcard) do
		for i=1,5 do
			v[i]:setVisible(false)
			v[i]:stopAllActions()
			v[i]:removeAllChildren()
            v[i]:setPosition(self.cardxy[k][i],self.cardxy[k][i+5])
		end
	end
	--隐藏筹码
	for k,v in pairs(self.pcm) do
        
		v:setVisible(false)
	end
    --隐藏动画
	for k,v in pairs(self.Arm) do
        v:getChildByName("Node"):removeAllChildren()
		v:setVisible(false)
	end
end
--
function CardLayer:createArm(number)
    for i=1,number do
        local popnode = cc.CSLoader:createNode("Game/cowLayer/ActionLayer.csb")    
        local cardp={}
        cardp.x,cardp.y = self.cardxy[i][3],self.cardxy[i][3+5]
        popnode:setPosition(cardp.x,cardp.y-30)
        self.cardLayer:addChild(popnode)
        self.Arm[i]=popnode:getChildByName("Node")
        self.Arm[i]:getChildByName("bs"):setVisible(false)
        if i ~= 1 then
            self.Arm[i]:setScale(1)
        end
        self.Arm[i]:setVisible(false)
    end
end
--更新玩家低注
function CardLayer:updateplayercoin(index,score)
	if self.pcard[index][1]:isVisible() then
		self.pcm[index]:getChildByName("T"):setString(score)
		self.pcm[index]:setVisible(true)
	end
end
function CardLayer:changebj()
    local str ="COWPK"
    --local tableinfo=public.gettableinfo(public.roomCode)
    if public.entergame ~=public.game.cow then
        str ="DCOWPK"
    end
	local pkindex=cc.UserDefault:getInstance():getIntegerForKey("COWPK", 1)
	local str=string.format("poker_bg%d.png",pkindex)
	for k,v in pairs(self.pcard) do
		for i=1,5 do
			v[i]:loadTexture(str,ccui.TextureResType.plistType)
		end
	end
    self.cardback=pkindex
end

--设置牌背景
function CardLayer:setCardBack(card)
	card:removeAllChildren()
	card:setVisible(true)
end
--牌显示出来。但是背景
function CardLayer:pushonCard(index)
	self:setCardBack(self.pcard[index][1])
	self:setCardBack(self.pcard[index][2])
    self:setCardBack(self.pcard[index][3])
    self:setCardBack(self.pcard[index][4])
    self:setCardBack(self.pcard[index][5])
    for k,v in pairs(self.pcard[index]) do
        v:setVisible(true)
    end
end
function CardLayer:sendlast(callback)           --发最后一张牌
    local truep=0
    for i=1,playerCount do              --计算真实人数
        if self.pcard[i][1]:isVisible() then
            truep=truep+1
        end
    end
    local donghuaindex=0
    local iskaiP=0
    local delaytime = 0.05
    for i=1,playerCount do
        if self.pcard[i][1]:isVisible() then                --用扑克牌来判断是否有真实玩家
			self.pcard[i][5]:setVisible(true)
            donghuaindex=donghuaindex+1            
            local card = nil
            local cardp={}
            card=self.pcard[i][5]
            cardp.x,cardp.y = self.cardxy[i][5],self.cardxy[i][10]--self.pcard[i][j]:getPosition()
            card:stopAllActions()
            self:setCardBack(card)
            local toScale = i == 1 and mycardScale or OtherCardScale
            local Bezieract = ExternalFun.sendcardBezier(0.18,cc.p(display.width/2,display.height/2),cardp ,40)
            card:setScale(defScale)
            card:setPosition(display.width/2,display.height/2)
            card:runAction(cc.Sequence:create(cc.DelayTime:create(delaytime+(donghuaindex-1)*0.1),
            cc.CallFunc:create(function()
                    --card:setVisible(true)
				ExternalFun.playSoundEffect("fapai",true)
				--card:setLocalZOrder(100)
            end),
            Bezieract,
            cc.CallFunc:create(function( ... )
                card:setScale(toScale)
            end),
            cc.CallFunc:create(
                function( ref )
                    iskaiP=iskaiP+1
                    if iskaiP == truep  then
                        callback()
                    end
                end
                )))
            --delaytime=delaytime+0.1
        end
    end
end
function CardLayer:sendfive(cards,callback)
    local truep=0
    for i=1,playerCount do              --计算真实人数
        if self.pcard[i][1]:isVisible() then
            truep=truep+1
        end
    end
    --dump(cards,"pai")
    local delaytime = 0.05
    local paitime =0
    --发牌开始
    local iskaiP=0
    local donghuaindex=0
    for i=1,playerCount do
        if self.pcard[i][1]:isVisible() then                --用扑克牌来判断是否有真实玩家
            donghuaindex=donghuaindex+1           
            for j = 1, 5 do
                local card = nil
                local cardp={}
                card=self.pcard[i][j]
                cardp.x,cardp.y = self.cardxy[i][j],self.cardxy[i][j+5]--self.pcard[i][j]:getPosition()
                card:stopAllActions()
                self:setCardBack(card)
                card.idx=j                                  --设置牌的个数
       
                local toScale = i == 1 and mycardScale or OtherCardScale
                local Bezieract = ExternalFun.sendcardBezier(0.18,cc.p(display.width/2,display.height/2),cardp ,40)
                card:setScale(defScale)
                card:setPosition(display.width/2,display.height/2)
                card:runAction(cc.Sequence:create(cc.DelayTime:create(delaytime * j+(donghuaindex-1)*0.2),
                cc.CallFunc:create(function()
                    --card:setVisible(true)
				--ExternalFun.playSoundEffect("fapai",true)
				--card:setLocalZOrder(100)
                end),
                Bezieract,
                cc.CallFunc:create(function( ... )
                    card:setScale(toScale)
                end),
                cc.CallFunc:create(
                    function( ref )
                        if  ref.idx == 5 then
                             iskaiP=iskaiP+1
                            
                        end
                        if ref.idx == 5 and iskaiP == truep  then
                            ----dump(cards[i],i)
                            for k,v in pairs(cards) do
                                local tchair=self.scene:getotherchair(v.chair)
                                if tchair == 1 then
                                    self:openCard(tchair,v.cards,4)
                                end
                            end
                            callback()
                            -- performWithDelay(self,function ()
                            --     
                            -- end,1)
                        end
                    end
                )))
            end
            self:runAction(cc.Sequence:create(cc.DelayTime:create(paitime),
                    cc.CallFunc:create(
                    function()
                        ExternalFun.playSoundEffect("fapai",true)
                    end
                )))
            paitime=paitime+0.35  
        end
    end
end
function CardLayer:sendFour(cards,Isshow,callback)
    
    local truep=0
    for i=1,playerCount do              --计算真实人数
        if self.pcard[i][1]:isVisible() then
            truep=truep+1
        end
    end
    local yidongX=50                                            --横向移动多少
    
    function yidong()                                           --移动动画
        for i=1,playerCount do
            if self.pcard[i][1]:isVisible() then                --用扑克牌来判断是否有真实玩家
                for j = 1, 5 do
                    local card = nil
                    card=self.pcard[i][j]
                    card:runAction(cc.Sequence:create(cc.DelayTime:create(0.1),cc.MoveTo:create(0.1, cc.p(self.cardxy[i][j],self.cardxy[i][j+5])
                    ),
                    cc.CallFunc:create(
                    function()
                       card:stopAllActions()
                        if j ==5 then
                             for k,v in pairs(cards) do
                                local tchair=self.scene:getotherchair(v.chair) 
                                if tchair == 1 and self.scene:getMechair() then
                                    self:openCard(tchair,v.cards,4)
                                end
                             end
                        end
                       callback()
                    end
                )))
                end
            end
        end
    end
    local delaytime = 0.05
    local paitime =0
    --发牌开始
    local iskaiP=0
    local donghuaindex=0
    for i=1,playerCount do
        if self.pcard[i][1]:isVisible() then                --用扑克牌来判断是否有真实玩家
            donghuaindex=donghuaindex+1
			self.pcard[i][5]:setVisible(false)            
            for j = 1, 5 do
                local card = nil
                local cardp={}
                card=self.pcard[i][j]
                cardp.x,cardp.y = self.cardxy[i][j],self.cardxy[i][j+5]--self.pcard[i][j]:getPosition()
                if  Isshow then                                 --是否移动
                    cardp.x=cardp.x-yidongX                          --左移动10
                end
                if Isshow and i == 1 then
                    cardp.x=cardp.x-50*(j-1)
                end
                card:stopAllActions()
                self:setCardBack(card)
                card.idx=j                                  --设置牌的个数
       
                local toScale = i == 1 and mycardScale or OtherCardScale
                local Bezieract = ExternalFun.sendcardBezier(0.18,cc.p(display.width/2,display.height/2),cardp ,40)
                card:setScale(defScale)
                card:setPosition(display.width/2,display.height/2)
                card:runAction(cc.Sequence:create(cc.DelayTime:create(delaytime * j),--+(donghuaindex-1)*0.2),
                cc.CallFunc:create(function()
                    --card:setVisible(true)
				-- ExternalFun.playSoundEffect("fapai",true)
				--card:setLocalZOrder(100)
                end),
                Bezieract,
                cc.CallFunc:create(function( ... )
                    card:setScale(toScale)
                end),
                cc.CallFunc:create(
                    function( ref )
                        if  ref.idx == 5 then
                             iskaiP=iskaiP+1    
                        end
                        if ref.idx == 5 and iskaiP == truep and Isshow then
                             yidong()
                        elseif ref.idx == 5 and iskaiP == truep and Isshow ==false then
                            performWithDelay(self,function ()
                                callback()
                            end,1)
                        end
                    end
                )))
                --delaytime=delaytime+0.01    
            end
            self:runAction(cc.Sequence:create(cc.DelayTime:create(paitime),
                    cc.CallFunc:create(
                    function()
                        ExternalFun.playSoundEffect("fapai",true)
                    end
                )))
        end
    end
end

function CardLayer:GetOpenAction(card,cards)
	local duration =0.1
	local orbitFront = cc.OrbitCamera:create(duration, 1, 0, -270, -90, 0, 0)
	local orbitBack = cc.OrbitCamera:create(duration, 1, 0, 0, -90, 0, 0)
	return cc.TargetedAction:create(card, cc.Sequence:create(
		cc.Sequence:create(cc.Show:create(), orbitBack, cc.Hide:create(), 
			cc.TargetedAction:create(card, cc.Sequence:create(cc.Show:create(), orbitFront))),
			cc.CallFunc:create(function()
				local str=string.format("card_%d_%d.png",(cards.suit+1),cards.rank)
                local puke = CCSpriteFrameCache:getInstance():getSpriteFrame(str)
				local shuzhi =  CCSprite:createWithSpriteFrame(puke)
				shuzhi:move(72,98.5)
				shuzhi:addTo(card)
			end)))
end
function CardLayer:openCard(index,cards,idx)    --开牌
	for k,v in pairs(cards) do
        if k <= idx then
            local pai=self.pcard[index][k]
            local str=string.format("card_%d_%d.png",(v.suit+1),v.rank)
            local puke = CCSpriteFrameCache:getInstance():getSpriteFrame(str)
            local shuzhi =  CCSprite:createWithSpriteFrame(puke)
            shuzhi:move(72,98)
            shuzhi:addTo(pai)
            if self.scene.laiziCard and self.scene.laiziCard.rank  and v.rank == self.scene.laiziCard.rank then
                local puke = CCSpriteFrameCache:getInstance():getSpriteFrame("xlaizi.png")
				local sp =  CCSprite:createWithSpriteFrame(puke)
                --local sp = display.newSprite("xlaizi.png")
                sp:move(44,45)
                sp:addTo(pai)
            end
        end
	end
end
function CardLayer:showCard(index,cards,paixing,Sex,niuNiuBs,lastCards,show)			 		--显示完整牌
	for k,v in pairs(cards) do
		local pai=self.pcard[index][k]
		pai:setVisible(true)
		local str=string.format("card_%d_%d.png",(v.suit+1),v.rank)
        local puke = CCSpriteFrameCache:getInstance():getSpriteFrame(str)
        local shuzhi =  CCSprite:createWithSpriteFrame(puke)
		shuzhi:move(72,98)
		shuzhi:addTo(pai)

        if show and lastCards and lastCards.suit==v.suit and lastCards.rank==v.rank then
            local puke = CCSpriteFrameCache:getInstance():getSpriteFrame("5TH2.png")
            local sp =  CCSprite:createWithSpriteFrame(puke)
            sp:move(108,158)
            sp:addTo(pai)
            y=20
            if index ~= 1 then
                y=10
            end
            local movePathBy = cc.MoveBy:create(0,cc.p(0,y))
            pai:runAction(movePathBy)
        end
        
        --显示牌型
        if paixing then
            self:showCardType(index,paixing,Sex,niuNiuBs)
        end
	end
	-- if #cards == 4 then
	-- 	self.pcard[index][5]:setVisible(false)
	-- end
end
function CardLayer:showCardType(index,cardtype,Sex,niuNiuBs)
    if self.pcard[index][1]:isVisible() and self.Arm[index]:isVisible() == false then        --计算真实人数
        self.Arm[index]:setVisible(true)
        self.Arm[index]:getChildByName("bs"):setVisible(false)
        self.Arm[index]:getChildByName("by"):setVisible(false)
        local str=string.format("ani_n_%d",cardtype)
        ExternalFun.addSpineWithCustomNode("Game/cowLayer/Acion/aniz_nn",self.Arm[index]:getChildByName("Node"),str,cc.p(0,0),true)
        performWithDelay(self,function ()
            local str=string.format("f0_nn%d",cardtype)
            ExternalFun.playSoundEffect(str,false,Sex)
            if niuNiuBs then
                if cardtype ==0 then
                    self.Arm[index]:getChildByName("bs"):setString(niuNiuBs)
                    self.Arm[index]:getChildByName("bs"):setVisible(true)
                else
                    self.Arm[index]:getChildByName("by"):setString(niuNiuBs)
                    self.Arm[index]:getChildByName("by"):setVisible(true)
                end
            end
        end,0.6)
    end
end
--斗公牛
function CardLayer:sendThree(cards,Isshow,callback)
    
    local truep=0
    for i=1,playerCount do              --计算真实人数
        if self.pcard[i][1]:isVisible() then
            truep=truep+1
        end
    end
    local yidongX=50                                            --横向移动多少
    
    function yidong()                                           --移动动画
        for i=1,playerCount do
            if self.pcard[i][1]:isVisible() then                --用扑克牌来判断是否有真实玩家
                for j = 1, 5 do
                    local card = nil
                    card=self.pcard[i][j]
                    card:runAction(cc.Sequence:create(cc.DelayTime:create(0.1),cc.MoveTo:create(0.1, cc.p(self.cardxy[i][j],self.cardxy[i][j+5])
                    ),
                    cc.CallFunc:create(
                    function()
                       card:stopAllActions()
                        if j ==5 then
                             for k,v in pairs(cards) do
                                local tchair=self.scene:getotherchair(v.chair) 
                                if tchair == 1 and self.scene:getMechair() then
                                    self:openCard(tchair,v.cards,3)
                                end
                             end
                        end
                       callback()
                    end
                )))
                end
            end
        end
    end
    local delaytime = 0.05
    local paitime =0
    --发牌开始
    local iskaiP=0
    local donghuaindex=0
    for i=1,playerCount do
        if self.pcard[i][1]:isVisible() then                --用扑克牌来判断是否有真实玩家
            donghuaindex=donghuaindex+1
			self.pcard[i][5]:setVisible(false)            
            for j = 1, 5 do
                local card = nil
                local cardp={}
                card=self.pcard[i][j]
                cardp.x,cardp.y = self.cardxy[i][j],self.cardxy[i][j+5]--self.pcard[i][j]:getPosition()
                if  Isshow then                                 --是否移动
                    cardp.x=cardp.x-yidongX                          --左移动10
                end
                if Isshow and i == 1 then
                    cardp.x=cardp.x-50*(j-1)
                end
                card:stopAllActions()
                self:setCardBack(card)
                card.idx=j                                  --设置牌的个数
       
                local toScale = i == 1 and mycardScale or OtherCardScale
                local Bezieract = ExternalFun.sendcardBezier(0.18,cc.p(display.width/2,display.height/2),cardp ,40)
                card:setScale(defScale)
                card:setPosition(display.width/2,display.height/2)
                card:runAction(cc.Sequence:create(cc.DelayTime:create(delaytime * j),--+(donghuaindex-1)*0.2),
                cc.CallFunc:create(function()
                end),
                Bezieract,
                cc.CallFunc:create(function( ... )
                    card:setScale(toScale)
                end),
                cc.CallFunc:create(
                    function( ref )
                        if  ref.idx == 5 then
                             iskaiP=iskaiP+1    
                        end
                        if ref.idx == 5 and iskaiP == truep and Isshow then
                             yidong()
                        elseif ref.idx == 5 and iskaiP == truep and Isshow ==false then
                            performWithDelay(self,function ()
                                callback()
                            end,1)
                        end
                    end
                )))
                --delaytime=delaytime+0.01    
            end
            self:runAction(cc.Sequence:create(cc.DelayTime:create(paitime),
                    cc.CallFunc:create(
                    function()
                        ExternalFun.playSoundEffect("fapai",true)
                    end
                )))
        end
    end
end
return CardLayer

