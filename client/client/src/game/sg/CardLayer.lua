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

function CardLayer:ctor(scene,number)
	self.scene=scene
	if number < 4 or number >10 or number ==7 or number == 9 then
		showToast("房间人数错误！",1)
		return
	end
	playerCount=number

	local rootLayer, csbNode = ExternalFun.loadzRootCSB("Game/sgLayer/CardLayer.csb", self)
	for i = 6, 10 do
		if i ~=	7 and i ~=	9 and i ~= number then
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
		self.pcard[i]={card1,card2,card3}
		self.pcm[i]=self.cardLayer:getChildByName(string.format("m%d",i))
        self.cardxy[i]={card1:getPositionX(),card2:getPositionX(),card3:getPositionX(),
        card1:getPositionY(),card2:getPositionY(),card3:getPositionY()}
	end

	--默认最后一位就是总注
	csbNode:getChildByName("zm"):setVisible(false)
    --动画列表
    self.Arm={}
    self.Paixing={}
    --创建动画
    self:createArm(number)
end
function CardLayer:reGame()
    self:stopAllActions()
	--隐藏牌
	for k,v in pairs(self.pcard) do
		for i=1,3 do
			v[i]:setVisible(false)
			v[i]:stopAllActions()
			v[i]:removeAllChildren()
            v[i]:setPosition(self.cardxy[k][i],self.cardxy[k][i+3])
		end
	end
	--隐藏筹码
	for k,v in pairs(self.pcm) do
		v:setVisible(false)
	end
    --隐藏动画
	for k,v in pairs(self.Arm) do
		v:setVisible(false)
	end
    
        --隐藏动画
	for k,v in pairs(self.Paixing) do
		v:setVisible(false)
	end
end
--
function CardLayer:createArm(number)
    for i=1,number do
        local popnode = cc.CSLoader:createNode("Game/sgLayer/ActionLayer.csb")    
        local cardp={}
        cardp.x,cardp.y = self.cardxy[i][2],self.cardxy[i][2+3]
        popnode:setPosition(cardp.x,cardp.y-30)
        self.cardLayer:addChild(popnode)
        self.Arm[i]=popnode:getChildByName("Armature")
        self.Arm[i]:setVisible(false)
        self.Paixing[i]=popnode:getChildByName("paixing")
        self.Paixing[i]:setVisible(false)
        if i~= 1 then
            self.Paixing[i]:setScale(0.55)
        end
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
    local str ="SGPK"
    local tableinfo=public.gettableinfo(public.roomCode)
    if tableinfo.roomType ~="3" then
        str ="SGBJHPK"
    end
	local pkindex=cc.UserDefault:getInstance():getIntegerForKey(str, 1)
	local str=string.format("poker_bg%d.png",pkindex)
	for k,v in pairs(self.pcard) do
		for i=1,3 do
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
end
function CardLayer:sendCard(cards,callback)
    
    local truep=0
    for i=1,playerCount do              --计算真实人数
        if self.pcard[i][1]:isVisible() then
            truep=truep+1
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
            for j = 1, 3 do
                local card = nil
                local cardp={}
                card=self.pcard[i][j]
                cardp.x,cardp.y = self.cardxy[i][j],self.cardxy[i][j+3]

                card:stopAllActions()
                self:setCardBack(card)
                card.idx=j                                  --设置牌的个数
       
                local toScale = i == 1 and mycardScale or OtherCardScale
                local Bezieract = ExternalFun.sendcardBezier(0.18,cc.p(display.width/2,display.height/2),cardp ,40)
                card:setScale(defScale)
                card:setPosition(display.width/2,display.height/2)
                card:runAction(cc.Sequence:create(cc.DelayTime:create(delaytime * j),--+(donghuaindex-1)*0.5),
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
                        if  ref.idx == 3 then
                             iskaiP=iskaiP+1
                        end
                        if ref.idx == 3 and iskaiP == truep then
                            local tableinfo=public.gettableinfo(public.roomCode)
                            for k,v in pairs(cards) do
                                local tchair=self.scene:getotherchair(v.chair) 
                                if tchair == 1 and tableinfo.mingpai==1 and self.scene:getMechair() then
                                    self:showCard(tchair,v.cards)
                                end
                            end
                            callback()
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
            --paitime=paitime+0.35     
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
function CardLayer:showCard(index,cards,paixing,Sex,isend,coinList)			 		--显示完整牌
	for k,v in pairs(cards) do
		local pai=self.pcard[index][k]
		pai:setVisible(true)
		local str=string.format("card_%d_%d.png",(v.suit+1),v.rank)
        local puke = CCSpriteFrameCache:getInstance():getSpriteFrame(str)
        local shuzhi =  CCSprite:createWithSpriteFrame(puke)
		shuzhi:move(72,98)
		shuzhi:addTo(pai)
	end
    --显示牌型
    if paixing then
        if public.entergame ==public.game.sangong then  --三公区别
            self:showCardType(index,paixing)
        else
            self:showBiCardType(index,paixing,Sex,isend,coinList)
        end
    end
end
function CardLayer:showCardType(index,cardtype)
    if self.pcard[index][1]:isVisible() and self.Arm[index]:isVisible() == false then        --计算真实人数
        self.Arm[index]:setVisible(true)
        local Animat=self.Arm[index]:getAnimation()
        local str=string.format("ani_sg_%d",cardtype)
        Animat:play(str)
        local str=string.format("br/sg/%d",cardtype)
        ExternalFun.playSoundEffect(str,true)
        ExternalFun.print("三公牌型"..cardtype)
    end
end
--三公比金花
function CardLayer:showBiCardType(index,cardtype,Sex,isend,coinList)
    --dump(coinList,"牌型")
    if self.pcard[index][1]:isVisible() and self.Paixing[index]:isVisible() == false then        --计算真实人数
        self.Paixing[index]:setVisible(true)
        self.Paixing[index]:getChildByName("pai_sg"):setVisible(true)
        self.Paixing[index]:getChildByName("pai_jh"):setVisible(false)
        self.Paixing[index]:getChildByName("jieguo"):setVisible(false)
        self.Paixing[index]:getChildByName("jia"):setVisible(false)
        self.Paixing[index]:getChildByName("jian"):setVisible(false)
        self.Paixing[index]:getChildByName("jia1"):setVisible(false)
        self.Paixing[index]:getChildByName("jian1"):setVisible(false)
        local str=string.format("px_sg_%d.png",cardtype[1])
        self.Paixing[index]:getChildByName("pai_sg"):loadTexture(str,ccui.TextureResType.plistType)
        str=string.format("sg_%d",cardtype[1])
        ExternalFun.playSoundEffect(str,false,Sex)
        performWithDelay(self,function ()
            local str=string.format("px_jh_%d.png",cardtype[2])
            self.Paixing[index]:getChildByName("pai_jh"):loadTexture(str,ccui.TextureResType.plistType)
            self.Paixing[index]:getChildByName("pai_jh"):setVisible(true)
            str=string.format("jh_%d",cardtype[2])
            if cardtype[2] ~=1 then
                ExternalFun.playSoundEffect(str,false,Sex)
            end
        end,0.4)
    end
        if isend == true then
            self.Paixing[index]:getChildByName("jieguo"):loadTexture("px_sy2.png",ccui.TextureResType.plistType)
            self.Paixing[index]:getChildByName("jieguo"):setVisible(true)
        elseif isend ==false then
            self.Paixing[index]:getChildByName("jieguo"):loadTexture("px_sy1.png",ccui.TextureResType.plistType)
            self.Paixing[index]:getChildByName("jieguo"):setVisible(true)
        end
    if coinList then
        for k,v in pairs(coinList) do
            local shuying=nil
            if k == 1 then
                if v >=0 then
                    shuying =self.Paixing[index]:getChildByName("jia")
                else
                    shuying =self.Paixing[index]:getChildByName("jian")
                end
            elseif k == 2 then
                    shuying =self.Paixing[index]:getChildByName("jia1")
                if v >=0 then
                else
                   shuying = self.Paixing[index]:getChildByName("jian1")
                end
            end
            if shuying then
                shuying:getChildByName("t"):setString(v)
                shuying:setVisible(true)
            end
        end
    end
end
return CardLayer

