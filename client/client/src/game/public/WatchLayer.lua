local WatchLayer = class("WatchLayer", function ()
	local WatchLayer =  display.newLayer()
	return WatchLayer
end)
local TAG={1,2,3,4}
function WatchLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadziRootCSB("Game/publicLayer/WatchLayer.csb", self)
	self.bj=csbNode:getChildByName("bj")
    local btcallback = function (ref, type)
		if type == ccui.TouchEventType.ended then
			ExternalFun.playClickEffect()
			ref:setScale(1)
			self:onButtonClickedEvent(ref:getTag(),ref)
		elseif type == ccui.TouchEventType.began then
            if ref:getTag() ~= 100 then
                ref:setScale(public.btscale)
            end
			return true
		elseif type == ccui.TouchEventType.canceled then
			ref:setScale(1)
		end
	end
    csbNode:getChildByName("P")
    :setTag(100)
    :addTouchEventListener(btcallback)
    self.bj:getChildByName("B_C")
	:setTag(100)
	:addTouchEventListener(btcallback)
    
    self.pk=self.bj:getChildByName("PK")
    self.P=self.bj:getChildByName("P")
    --showToast("打开观战人！",1)
    --获取数据
    gst.send(GameHead.watchplayer,nil)
end
function WatchLayer:inint(data)
    --dump(data,"初始化观看人界面")
	self.pk:removeAllChildren()
    if data == nil then
        return
    end
    local counts=math.ceil(#data/3)
	for i=1,counts do
		local item =self.P:clone()
		for j =1,3 do
			local name=string.format("P%d",j)
			local it=item:getChildByName(name)
			local player= data[(i-1)*3+j]
			if player ~= nil then
				it:getChildByName("T1"):setString(player.userName)
				it:getChildByName("T2"):setString("ID:"..ExternalFun.showUserCode(player.userCode))
                local headbg=it:getChildByName("head")
				--设置头像
                ExternalFun.createClipHead(headbg,player.userCode,player.logoUrl,70)
			else
				it:setVisible(false)
			end
		end
		self.pk:pushBackCustomItem(item)
    end
end
function WatchLayer:onButtonClickedEvent(tag,ref)
    if tag == 100 then
        self:removeFromParent()
    end
end
return WatchLayer

