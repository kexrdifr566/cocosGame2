local SettingLayer = class("SettingLayer", function ()
	local SettingLayer =  display.newLayer()
	return SettingLayer
end)
local beijing={ "DZBJ","COWBJ","SGBJ","","DCOWBJ","","SGBJHBJ"}
local puke = {"DZPK","COWPK","SGPK","","DCOWPK","","SGBJHPK"}
function SettingLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadzRootCSB("Game/publicLayer/SettingLayer.csb", self)
	self.bj=csbNode:getChildByName("bj")
        
    local btcallback = function (ref, type)
		if type == ccui.TouchEventType.ended then
			ExternalFun.playClickEffect()
			--ref:setScale(1)
			self:onButtonClickedEvent(ref:getTag(),ref)
		elseif type == ccui.TouchEventType.began then
			--ref:setScale(public.btscale)
			return true
		elseif type == ccui.TouchEventType.canceled then
			--ref:setScale(1)
		end
	end
    self.bj:getChildByName("B_C")
	:setTag(100)
	:addTouchEventListener(btcallback)
	
	self.p={}
	for i=1,2 do 
		local str=string.format("P%d",i)
		self.p[i]=self.bj:getChildByName(str)
		if i == 2 then
			self.p[i]:setVisible(false)
		end
	end
	self.p[1]:getChildByName("B")
	:setTag(3)
	:addTouchEventListener(btcallback)
	self.p[2]:getChildByName("B")
	:setTag(4)
	:addTouchEventListener(btcallback)
	self.p[2]:getChildByName("B"):setVisible(false)

	self.bb={}
	for i=1,2 do 
		local str=string.format("B_%d",i)
		self.bb[i]=self.bj:getChildByName(str)
		self.bb[i]:setTag(i)
		:addTouchEventListener(btcallback)
		if i == 1 then
			self.bb[i]:setEnabled(false)
        else
            self.bb[i]:setEnabled(true)
		end
	end
	local tableinfo=public.gettableinfo(public.roomCode)
	self.gamebj=beijing[tonumber(tableinfo.roomType)]
	self.gamepk=puke[tonumber(tableinfo.roomType)]

	self.bjindex=cc.UserDefault:getInstance():getIntegerForKey(self.gamebj, 1)
	self.bbj={}
	for i=1,4 do 
		local str=string.format("B_%d",i)
		self.bbj[i]=self.p[1]:getChildByName(str)
		self.bbj[i]:setTag(i+10)
		:addTouchEventListener(btcallback)
		if i == self.bjindex then
			self.bbj[i]:setEnabled(false)
        else
            self.bbj[i]:setEnabled(true)
		end
	end
	self.pkindex=cc.UserDefault:getInstance():getIntegerForKey(self.gamepk, 1)
	self.bbp={}
	for i=1,4 do 
		local str=string.format("B%d",i)
		self.bbp[i]=self.p[1]:getChildByName(str)
		self.bbp[i]:setTag(i+20)
		:addTouchEventListener(btcallback)
		if i == self.pkindex then
			self.bbp[i]:setEnabled(false)
        else
            self.bbp[i]:setEnabled(true)
		end
	end
	self:setbj()

	-------------------------------------------音乐音效设置
	self.cb={}
	for i=1,3 do 
		local str=string.format("C%d",i)
		self.cb[i]=self.p[2]:getChildByName(str)
		self.cb[i]:setTag(i+30)
		:addTouchEventListener(btcallback)
		if i == public.GameMusic then
			self.cb[i]:setSelected(true)
		else
			self.cb[i]:setSelected(false)
		end
	end
		
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
    local slider_bg = self.p[2]:getChildByName("S1")
    slider_bg:setTag(1)
    slider_bg:addEventListenerSlider(sliderFunC)
    slider_bg:setPercent(self.value_music)
    self.m_sliderBg = slider_bg

	-- 音效滑动
	self.value_effect = public.nSound
    local slider_effect = self.p[2]:getChildByName("S2")
    slider_effect:setTag(2)
    slider_effect:addEventListenerSlider(sliderFunC)
    slider_effect:setPercent(self.value_effect)
	self.m_sliderEffect = slider_effect
end
function SettingLayer:savebj()
	cc.UserDefault:getInstance():setIntegerForKey(self.gamebj, self.bjindex)
	cc.UserDefault:getInstance():setIntegerForKey(self.gamepk, self.pkindex)
	self.scene.scene:changebj()
	showToast("保存配置成功！",1)
end

function SettingLayer:setbj()
	--设置背景
	local str=string.format("Game/public/shezhi/bj%d.png",self.bjindex)
	self.p[1]:getChildByName("xiaoguo"):loadTexture(str)
	--设置扑克
	str=string.format("poker_bg%d.png",self.pkindex)  
	self.p[1]:getChildByName("xiaoguo"):getChildByName("I1"):loadTexture(str,ccui.TextureResType.plistType)
	self.p[1]:getChildByName("xiaoguo"):getChildByName("I2"):loadTexture(str,ccui.TextureResType.plistType)
end
function SettingLayer:onButtonClickedEvent(tag,ref)
    if tag == 100 then
		self:removeFromParent()
	elseif tag == 1 or tag == 2 then
		self:selectbb(tag)
	elseif tag == 3 then
		self:savebj()
	elseif tag == 4 then
	elseif tag >10 and tag <20 then
		self:selectbbj(tag-10)
	elseif tag >20 and tag <30 then
		self:selectbbp(tag-20)
	elseif tag>=30 and tag <= 40 then
		--print("按下"..tag)
		self:selectcb(tag-30)
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
	ExternalFun.setgameBackgroudMusic(index)
end
function SettingLayer:selectbbj(index)
	if self.bbj[index] ==nil then
		return
	end
	for k,v in pairs(self.bbj) do
		v:setEnabled(true)
        if k == index then
            v:setEnabled(false)
        end
	end
	self.bjindex=index
	self:setbj()
end
function SettingLayer:selectbbp(index)
	if self.bbp[index] ==nil then
		return
	end
	for k,v in pairs(self.bbp) do
		v:setEnabled(true)
        if k == index then
            v:setEnabled(false)
        end
	end
	self.pkindex=index
	self:setbj()
end
function SettingLayer:selectbb(index)
	if self.bb[index] ==nil then
		return
	end
	for k,v in pairs(self.bb) do
		v:setEnabled(true)
        if k == index then
            v:setEnabled(false)
        end
	end
	for k,v in pairs(self.p) do
		if index == k then
			v:setVisible(true)
		else
			v:setVisible(false)
		end
	end
end
return SettingLayer

