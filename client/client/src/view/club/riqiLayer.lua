local riqiLayer = class("riqiLayer", function ()
	local riqiLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return riqiLayer
end)
local TAG={1,2,3,4}
function riqiLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Club/Layer/riqiLayer.csb", self)
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
    self.bj:getChildByName("BC")
	:setTag(100)
	:addTouchEventListener(btcallback)
	local riqi =os.date("%Y-%m-%d")
	self.bb={}
	for i=1,7 do	
		local str =string.format("B%d",i)
		local btn =self.bj:getChildByName(str)
		btn:setTag(i)
		:addTouchEventListener(btcallback)
		local rili=ExternalFun.day_step(os.date("%Y-%m-%d"),1-i)
		btn:getChildByName("T"):setString(rili)
		self.bb[i]=btn
		self.bb[i]:setEnabled(true)
	end
end
function riqiLayer:onButtonClickedEvent(tag,ref)
    if tag == 100 then
		self:removeFromParent()
	else
		local riqi =self.bb[tag]:getChildByName("T"):getString()
		self.scene.riqi=riqi
		self.scene:reriqi()
		self.scene:GetBjdata()
		self:removeFromParent()
    end
end
return riqiLayer

