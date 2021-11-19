local kefuLayer = class("kefuLayer", function ()
	local kefuLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return kefuLayer
end)
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
local TAG={1,2,3,4}
function kefuLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Layer/kefuLayer.csb", self)
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
	self.bj:getChildByName("B_Q")
	:setTag(100)
	:addTouchEventListener(btcallback)
	self.bj:getChildByName("B_F")
	:setTag(1)
	:addTouchEventListener(btcallback)
	self.bj:getChildByName("T"):setString(public.kfwx)
end
function kefuLayer:onButtonClickedEvent(tag,ref)
    if tag == 100 then
        self:removeFromParent()
    elseif tag == 1 then
    	local ret, msg = MultiPlatform:copyToClipboard(public.kfwx)
		if ret == true then
			showToast("复制成功!", 1)
		else
			showToast( msg or "复制失败", 1, cc.c3b(250, 0, 0))
		end
    end
end
return kefuLayer
