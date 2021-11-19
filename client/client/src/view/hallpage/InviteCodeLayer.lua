local InviteCodeLayer = class("InviteCodeLayer", function ()
	local InviteCodeLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return InviteCodeLayer
end)
local TAG={1,2,3,4}
function InviteCodeLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Layer/InviteCodeLayer.csb", self)
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
end
function InviteCodeLayer:onButtonClickedEvent(tag,ref)
    if tag == 100 then
        self:removeFromParent()
    end
end
return InviteCodeLayer