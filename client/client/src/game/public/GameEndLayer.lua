local GameEndLayer = class("GameEndLayer", function ()
	local GameEndLayer =  display.newLayer()
	return GameEndLayer
end)
local TAG={1,2,3,4}
function GameEndLayer:ctor(_scene,data)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadzRootCSB("Game/publicLayer/GameEndLayer.csb", self)
	self.bj=csbNode:getChildByName("bj")
    local btcallback = function (ref, type)
		if type == ccui.TouchEventType.ended then
			ExternalFun.playClickEffect()
			ref:setScale(1)
			self:onButtonClickedEvent(ref:getTag(),ref)
		elseif type == ccui.TouchEventType.began then
			ref:setScale(public.btscale)
			return true
		elseif type == ccui.TouchEventType.canceled then
			ref:setScale(1)
		end
	end
    self.bj:getChildByName("B_C")
	:setTag(100)
	:addTouchEventListener(btcallback)
	self.bj:getChildByName("B_C"):setVisible(false)
	self.bj:getChildByName("B1")
	:setTag(1)
	:addTouchEventListener(btcallback)
	self.bj:getChildByName("B1"):setVisible(false)
	self.bj:getChildByName("B2")
	:setTag(2)
	:addTouchEventListener(btcallback)
	self.bj:getChildByName("B3")
	:setTag(3)
	:addTouchEventListener(btcallback)
	self.p=self.bj:getChildByName("p")
    self.nodes={}
    for i=1,10 do
        local str = string.format("Node_%d",i)
        self.nodes[i]=self.bj:getChildByName(str)
    end
        
    if data then
        self:inint(data.users)
        self.bj:getChildByName("T1"):setString("房间号:"..data.tableId)
        self.bj:getChildByName("T2"):setString(data.roomTypeValue)
        self.bj:getChildByName("T3"):setString(data.time)
    end
    --self.bj:getChildByName("B2"):setVisible(false)
end
function GameEndLayer:inint(data)
        --dump(data,"人物信息")
    for k,v in pairs(data) do
            local item = self.p:clone()
            local headbg=item:getChildByName("head")
            ExternalFun.createClipHead(headbg,v.userCode,v.logoUrl,70)
            item:getChildByName("nickname"):setString(v.userName)
            item:getChildByName("gamecion"):setString("ID:"..ExternalFun.showUserCode(v.userCode))
            if v.endcoin >= 0 then
                local str=string.format("biaodi.png")
                --local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(str)
                --item:setSpriteFrame(frame)
                --item:loadTexture(str)
                item:getChildByName("shuyin"):loadTexture("jiesuan_j.png",ccui.TextureResType.plistType)
               -- item:loadTexture(str,ccui.TextureResType.plistType)
                item:getChildByName("shuying_2"):setString(v.endcoin)
                item:getChildByName("shuying_1"):setVisible(false)
            else
                local str=string.format("biaoer.png")
                item:getChildByName("shuyin"):loadTexture("jiesuan_.png",ccui.TextureResType.plistType)
                --item:loadTexture(str,ccui.TextureResType.plistType)
                --item:loadTexture(str)
                item:getChildByName("shuying_1"):setString(v.endcoin)
                item:getChildByName("shuying_2"):setVisible(false)
            end
            item:setPosition(0,0)
            self.nodes[k]:addChild(item)
    end
end
function GameEndLayer:inint_back(data)
	self.pk:removeAllChildren()
    if data == nil then
        return
    end
    local counts=math.ceil(#data/4)
	for i=1,counts do
		local item =self.P:clone()
		for j =1,4 do
			local name=string.format("I%d",j)
			local it=item:getChildByName(name)
			local player= data[(i-1)*4+j]
			if player ~= nil then
                --dump(player,"个人数据")
				it:getChildByName("T1"):setString(player.userName)
				it:getChildByName("T2"):setString("ID:"..player.userCode)
                    local headbg=it:getChildByName("Image")
                    --设置头像
                    ExternalFun.createClipHead(headbg,player.userCode,player.logoUrl,80)
				if player.endcoin > 0 then

					it:getChildByName("A2"):setString("/"..player.endcoin)
					it:getChildByName("A1"):setVisible(false)
				else
					player.endcoin=-player.endcoin
					it:getChildByName("A1"):setString("/"..player.endcoin)
					it:getChildByName("A2"):setVisible(false)
				end
			else
				it:setVisible(false)
			end
		end
		self.pk:pushBackCustomItem(item)
    end
end
function GameEndLayer:onButtonClickedEvent(tag,ref)
    if tag == 100 then
        self:removeFromParent()
    elseif tag == 2 then
		self.scene.scene:ReGame()
        --self.scene.scene:closeGame(true)
   	elseif tag == 3 then
    	self.scene.scene:closeGame(true)
    end
end
return GameEndLayer

