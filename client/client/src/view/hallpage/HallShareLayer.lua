local HallShareLayer = class("HallShareLayer", function ()
	local HallShareLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return HallShareLayer
end)
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
local AnimationHelper = appdf.req(appdf.EXTERNAL_SRC .. "AnimationHelper")
local TAG={1,2,3,4}
function HallShareLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Layer/HallShareLayer.csb", self)
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
    self.bc=self.bj:getChildByName("B_C")
	self.bc:setTag(100)
	:addTouchEventListener(btcallback)
    
    self.bh=self.bj:getChildByName("B_P")
	self.bh:setTag(2)
	:addTouchEventListener(btcallback)
    
    self.bp=self.bj:getChildByName("B_H")
	self.bp:setTag(1)
	:addTouchEventListener(btcallback)
    
     self.qrNode=self.bj:getChildByName("bj")
    AnimationHelper.jumpInEx(self.bj, 1)
end
function HallShareLayer:onButtonClickedEvent(tag,ref)
    if tag == 100 then
        self:removeFromParent()
    elseif tag == 2 or tag == 1  then
        self.bh:setVisible(false)
        self.bc:setVisible(false)
        self.bp:setVisible(false)
        self:TargetShare(tag-1)
    end
end
--@parma[target] (0 无  1 朋友圈  2 微信好友  3 朋友圈和微信好友 4 面对面  5 朋友圈和面对面  6 微信好友和面对面  7 全部)
function HallShareLayer:TargetShare( target )
    local function sharecall( isok )
        if type(isok) == "string" and isok == "true" then
            self:runAction(cc.Sequence:create(cc.DelayTime:create(1.0),
                    cc.CallFunc:create(function()
                    showToast("分享成功", 2)
             end)))
        end
    end
    local url = public.url.."?"..public.yqm 
    local framesize = cc.Director:getInstance():getOpenGLView():getFrameSize()
    local scalew, scaleh= framesize.width/1334,framesize.height/750
    local area = cc.rect(110*scalew, 69*scaleh, 1000*scalew, 500*scaleh)--cc.rect(0, 0, framesize.width, framesize.height)
    local imagename = "grade_share.jpg"
    ExternalFun.popupTouchFilter(0, false)
    captureScreenWithArea(area, imagename, function(ok, savepath)
        ExternalFun.dismissTouchFilter()
        self.bh:setVisible(true)
        self.bc:setVisible(true)
        self.bp:setVisible(true)
            if ok then
                if nil ~= target then
                    showToast("截图成功", 2)
                    MultiPlatform:getInstance():shareToTarget(target, sharecall, "", "", url, savepath, "true")
                end            
            end
    end)
end
return HallShareLayer