local SettingLayer = class("SettingLayer", function ()
	local SettingLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return SettingLayer
end)
local phoneXiuGaiLayer = appdf.req(appdf.VIEW.."hallpage.phoneXiuGaiLayer")
local TAG={1,2,3,4}
local AnimationHelper = appdf.req(appdf.EXTERNAL_SRC .. "AnimationHelper")
function SettingLayer:ctor(_scene,ble)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Layer/SettingLayer.csb", self)
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
    self.bj:getChildByName("B_Q_0")
	:setTag(2)
	:addTouchEventListener(btcallback)
    
    self.bj:getChildByName("B_Q")
	:setTag(1)
	:addTouchEventListener(btcallback)

	local function sliderFunC(sender, tType)
		if tType == ccui.SliderEventType.percentChanged then
			if sender:getTag() ==1 then
				self.value_music = sender:getPercent()
				public.setMusicVolume(self.value_music)
			elseif sender:getTag() ==2 then
				self.m_sliderEffect = sender:getPercent()
				public.setEffectsVolume(self.m_sliderEffect)
			end
		end
	end
		
	-- 音乐滑动
	self.value_music = public.nMusic
	local slider_bg = self.bj:getChildByName("S_2")
	slider_bg:setTag(1)
	slider_bg:addEventListenerSlider(sliderFunC)
	slider_bg:setPercent(self.value_music)
	self.m_sliderBg = slider_bg
	-- 音效滑动
	self.value_effect = public.nSound
	local slider_effect =self.bj:getChildByName("S_1")
	slider_effect:setTag(2)
	slider_effect:addEventListenerSlider(sliderFunC)
	slider_effect:setPercent(self.value_effect)
	self.m_sliderEffect = slider_effect

	self.cb={}
	for i=1,3 do 
		local str=string.format("C%d",i)
		self.cb[i]=self.bj:getChildByName(str)
		self.cb[i]:setTag(i+10)
		:addTouchEventListener(btcallback)
		if i == public.HallMusic then
			self.cb[i]:setSelected(true)
		else
			self.cb[i]:setSelected(false)
		end
	end
    
    if ble then
        self.bj:getChildByName("B_Q"):setVisible(false)
        self.bj:getChildByName("B_Q_0"):setVisible(false) 
    end
    AnimationHelper.jumpInEx(self.bj, 1)
end
function SettingLayer:onButtonClickedEvent(tag,ref)
    if tag == 100 then
        self:removeFromParent()
    elseif tag ==1 then
        self.scene:qiehuan()
    elseif tag == 2 then
        if public.bindTelephone == "0" then
            showToast("您未绑定手机,不能使用该功能",2)
            return
        end
        local layer=phoneXiuGaiLayer:create(self)
        self:add(layer)
		
	elseif tag >=11 and tag <14 then
		self:selectcb(tag-10)
    end
end
function SettingLayer:selectcb(index)
	if self.cb[index]:isSelected() then
		self.cb[index]:setSelected(true)
		return
	end
	for k,v in pairs(self.cb) do
        if k ~= index then
			v:setSelected(false)
        end
	end
	ExternalFun.setPlazzBackgroudMusic(index)
end
return SettingLayer

