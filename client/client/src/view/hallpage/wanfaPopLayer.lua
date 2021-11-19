local wanfaPopLayer = class("wanfaPopLayer", function ()
	local wanfaPopLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return wanfaPopLayer
end)
local TAG={1,2,3,4}
local AnimationHelper = appdf.req(appdf.EXTERNAL_SRC .. "AnimationHelper")
function wanfaPopLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Layer/wanfaPopLayer.csb", self)
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
    self.pListView=self.bj:getChildByName("pListView")
    self.pListView:setScrollBarEnabled(false)
    self.bb={}
	for i = 1, 11 do
		local str =string.format("B_%d",i)
		self.bb[i]=self.pListView:getChildByName(str)
		self.bb[i]:setTag(i)
		:addTouchEventListener(btcallback)
	end
    self.wf={}
    	for i = 1, 11 do
		local str =string.format("gui%d",i)
		self.wf[i]=self.bj:getChildByName(str)
	end
    self:selectB(1)
    AnimationHelper.jumpInEx(self.bj, 1)
end
function wanfaPopLayer:onButtonClickedEvent(tag,ref)
    if tag == 100 then
        self:removeFromParent()
    elseif tag >=1 and tag <12 then
    	self:selectB(tag)
    end
end
function wanfaPopLayer:selectB(index)
	if self.bb[index] ==nil then
		return
	end
	for k,v in pairs(self.bb) do
		v:setEnabled(true)
        v:getChildByName("Text"):setColor(cc.c3b(114,69,21))
        --setColor(v.lossOrWinList[2] ==1 and  cc.c3b(27,132,217) or cc.c3b(255,255,255))
        if k == index then
            v:setEnabled(false)
            v:getChildByName("Text"):setColor(cc.c3b(255,255,255))
        end
	end
    for k,v in pairs(self.wf) do
		v:setVisible(false)
        if k == index then
            v:setVisible(true)
        end
	end
end
return wanfaPopLayer