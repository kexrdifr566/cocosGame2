CC_F = 0
CC_M = 1
CC_H = 2
CC_T = 3
local CardLayer = class("CardLayer", function ()
	local CardLayer =  display.newLayer()
	return CardLayer
end)
local playerCount=0
function CardLayer:ctor(scene,number)
	self.scene=scene
	if number < 4 or number >10 or number ==7 or number == 9 then
		showToast("房间人数错误！",1)
		return
	end
	playerCount=number

	local rootLayer, csbNode = ExternalFun.loadzRootCSB("Game/dzLayer/CardLayer.csb", self)
	for i = 6, 10 do
		if i ~=	7 and i ~= 9 and i ~= number then
			local card=string.format("%dCard",i)
			csbNode:getChildByName(card):removeFromParent()
		end
	end
	local card=string.format("%dCard",number)
	--玩家手里拍
	self.pcard={}
	self.cardLayer=csbNode:getChildByName(card)
	self.pcm={}
	self.ppx={}
	for i=1,number do
		local card1=self.cardLayer:getChildByName(string.format("P_%d_1",i))
		local card2=self.cardLayer:getChildByName(string.format("P_%d_2",i))
		self.pcard[i]={card1,card2}
		self.pcm[i]=self.cardLayer:getChildByName(string.format("m%d",i))
		self.ppx[i]=self.cardLayer:getChildByName(string.format("px%d",i))
	end

	self.zCard={}
	self.zCardLayer=csbNode:getChildByName("ZCard")
	for i=1,5 do
		self.zCard[i]=self.zCardLayer:getChildByName(string.format("P_%d",i))
	end
	--默认最后一位就是总注
	self.pcm[playerCount+1]=csbNode:getChildByName("Zm")
	self.pcm[playerCount+1]:setVisible(false)
	self.counts=0
end
function CardLayer:reGame()
	self:stopAllActions()
    --隐藏牌
	for k,v in pairs(self.pcard) do
		v[1]:setVisible(false)
		v[2]:setVisible(false)
	end
	--隐藏筹码
	for k,v in pairs(self.pcm) do
		v:setVisible(false)
	end
	--隐藏牌型
	for k,v in pairs(self.ppx) do
		v:setVisible(false)
	end
	--隐藏中间的牌
	for k,v in pairs(self.zCard) do
		self:setCardBack(v)
		v:setVisible(false)
	end
	self.counts=0
end
--更新桌面总注
function CardLayer:updatezongzhu(score)
	self.pcm[playerCount+1]:getChildByName("T"):setString(score)
	self.pcm[playerCount+1]:setVisible(true)
end
--更新玩家低注
function CardLayer:updateplayercoin(index,score)
	if self.pcard[index][1]:isVisible() then
		self.pcm[index]:getChildByName("T"):setString(score)
		self.pcm[index]:setVisible(true)
	end
end
function CardLayer:changebj()
	local pkindex=cc.UserDefault:getInstance():getIntegerForKey("DZPK", 1)
	local str=string.format("poker_bg%d.png",pkindex)
	for k,v in pairs(self.pcard) do
        --print(k)
		v[1]:loadTexture(str,ccui.TextureResType.plistType)
		v[2]:loadTexture(str,ccui.TextureResType.plistType)
	end
	--中间的牌
	for k,v in pairs(self.zCard) do
		v:loadTexture(str)
	end
end
function CardLayer:upplayerpaixing(index)
	local str=string.format("yqp.png")
	self.ppx[index]:setSpriteFrame(str)
	self.ppx[index]:setVisible(true)
end
--更新玩家低注
function CardLayer:updataMeCard(cards)
	self:upCard(self.pcard[1][1],cards[1].suit,cards[1].rank,true)
	self:upCard(self.pcard[1][2],cards[2].suit,cards[2].rank,true)
	self.pcard[1][1]:setVisible(true)
	self.pcard[1][2]:setVisible(true)
end
function CardLayer:updataAllCard(index,cards,pxValue)
	if cards[1] and cards[2] then
		self:upCard(self.pcard[index][1],cards[1].suit,cards[1].rank,false)
		self:upCard(self.pcard[index][2],cards[2].suit,cards[2].rank,false)
		self.pcard[index][1]:setVisible(true)
		self.pcard[index][2]:setVisible(true)
		local str=string.format("img_dzpx_b%d.png",pxValue)
		self.ppx[index]:setSpriteFrame(str)
		self.ppx[index]:setVisible(true)
	end
end
--牌显示出来。但是背景
function CardLayer:pushonCard(index)
	self:setCardBack(self.pcard[index][1])
	self:setCardBack(self.pcard[index][2])
	self.pcard[index][1]:setVisible(true)
	self.pcard[index][2]:setVisible(true)
end
--更新扑克牌
function CardLayer:upCard(card,huase,shuzhi,me)
	card:removeAllChildren()
	local str=string.format("card_%d_%d.png",(huase+1),shuzhi)
    local puke = CCSpriteFrameCache:getInstance():getSpriteFrame(str)
    local shuzhi =  CCSprite:createWithSpriteFrame(puke)
    shuzhi:setScale(0.5)
	--shuzhi:move(14,66)
    shuzhi:move(72/2,99/2)
	shuzhi:addTo(card)
end
--更新扑克牌
function CardLayer:upzCard(card,huase,shuzhi,index)
	card:removeAllChildren()
	local str=string.format("card_%d_%d.png",(huase+1),shuzhi)
    local puke = CCSpriteFrameCache:getInstance():getSpriteFrame(str)
    local shuzhi =  CCSprite:createWithSpriteFrame(puke)
    shuzhi:move(72/2,99/2)
    shuzhi:setScale(0.5)
	shuzhi:addTo(card)
	local str=string.format("img_gong%d.png",index)
    local puke = CCSpriteFrameCache:getInstance():getSpriteFrame(str)
    local shuzhi =  CCSprite:createWithSpriteFrame(puke)
	shuzhi:move(46,72)
	shuzhi:addTo(card)
end
--设置牌背景
function CardLayer:setCardBack(card)
	card:removeAllChildren()
	card:setVisible(true)
end
--设置中间牌全显示出来
function CardLayer:onCenterCard(cards)

	local function afterCall()
		for k,v in pairs (cards) do
			local counts=k+self.counts
			self:upzCard(self.zCard[counts],v.suit,v.rank,counts)
		end
		self.counts=self.counts+#cards
	end

	local detime=0
	for i = 1,#cards do
		self.zCard[i+self.counts]:setVisible(true)
		local x1,y1=self.zCard[i+self.counts]:getPosition()
		self.zCard[i+self.counts]:setPosition(display.width*3/4,display.height*3/4)
		self.zCard[i+self.counts]:runAction(cc.Sequence:create(cc.DelayTime:create(detime),
        cc.CallFunc:create(function()
                    --card:setVisible(true)
				ExternalFun.playSoundEffect("fapai",true)
				--card:setLocalZOrder(100)
                end),cc.MoveTo:create(0.1, cc.p(x1, y1))))
		detime =detime+0.08
		if i ==#cards then
			local ceshi=cc.CallFunc:create(afterCall)
			self.zCard[i+self.counts]:runAction(cc.Sequence:create(cc.DelayTime:create(detime+0.5),ceshi))
		end
	end
end

--发牌
function CardLayer:sendCard(cards)           --发牌
	self:pushonCard(1)						 --设置自己牌的背景

	local function afterCall()
		if cards[1] and cards[2] then
			self:updataMeCard(cards)
		end
    end
    local detime=0
	for i = 1,playerCount do
		if self.pcard[i][1]:isVisible() then
			self.pcard[i][1]:stopAllActions()
			self.pcard[i][2]:stopAllActions()
			local x1,y1=self.pcard[i][1]:getPosition()
			local x2,y2=self.pcard[i][2]:getPosition()
			self.pcard[i][1]:setPosition(display.width/2,display.height/2)
			self.pcard[i][2]:setPosition(display.width/2,display.height/2)
			self.pcard[i][1]:runAction(cc.Sequence:create(cc.DelayTime:create(detime),cc.CallFunc:create(function()
                    --card:setVisible(true)
				ExternalFun.playSoundEffect("fapai",true)
				--card:setLocalZOrder(100)
                end),cc.MoveTo:create(0.1, cc.p(x1, y1))))
			if i==1 then
				local ceshi=cc.CallFunc:create(afterCall)
				local ceshi2=cc.MoveTo:create(0.1, cc.p(x2, y2))
				self.pcard[i][2]:runAction(cc.Sequence:create(cc.DelayTime:create(detime+0.03),ceshi2,cc.DelayTime:create(0.3),ceshi))
			else
				self.pcard[i][2]:runAction(cc.Sequence:create(cc.DelayTime:create(detime+0.03),cc.MoveTo:create(0.1, cc.p(x2, y2))))
			end
			detime =detime+0.08
		end
	end
end
return CardLayer

