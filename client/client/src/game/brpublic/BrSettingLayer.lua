local BrSettingLayer = class("BrSettingLayer", function ()
	local BrSettingLayer =  display.newLayer()
	return BrSettingLayer
end)
local beijing={ "BRSGBJ","BRCOWBJ","BRLHDBJ","BRDSSBJ"}--,
function BrSettingLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Game/brpublicLayer/BrSettingLayer.csb", self)
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
	
	self.bj:getChildByName("BB")
	:setTag(1)
	:addTouchEventListener(btcallback)
	
	local tableinfo=public.gettableinfo(public.roomCode)
	self.gamebj=beijing[tonumber(tableinfo.roomType)-13]

	self.bjindex=cc.UserDefault:getInstance():getIntegerForKey(self.gamebj, 1)
	self.bbj={}
	for i=1,3 do 
		local str=string.format("B%d",i)
		self.bbj[i]=self.bj:getChildByName(str)
		self.bbj[i]:setTag(i+10)
		:addTouchEventListener(btcallback)
		if i == self.bjindex then
			self.bbj[i]:setEnabled(false)
            self.bbj[i]:getChildByName("C"):setSelected(true)
        else
            self.bbj[i]:getChildByName("C"):setSelected(false)
		end
	end
    local str={"Game/brpublic/brbj1.png","Game/brpublic/brbj2.png","Game/brpublic/brbj3.png"}
    if public.entergame == public.brgame.shenshou    then 
        str={"Game/brdss/bj1.png","Game/brdss/bj2.png","Game/brdss/bj3.png"}
    elseif public.entergame == public.brgame.longhu    then
        str={"Game/brlhd/bj1.png","Game/brlhd/bj2.png","Game/brlhd/bj3.png"}        
    end
    for k,v in pairs(self.bbj) do
        v:loadTextureNormal(str[k])
        v:loadTexturePressed(str[k])
        v:loadTextureDisabled(str[k])
    end
end
function BrSettingLayer:savebj()
	cc.UserDefault:getInstance():setIntegerForKey(self.gamebj, self.bjindex)

	self.scene:changebj()
	showToast("保存配置成功！",1)
end

function BrSettingLayer:onButtonClickedEvent(tag,ref)
    ExternalFun.print("按下"..tag)
    if tag == 100 then
		self:removeFromParent()
	elseif tag == 1 then
		self:savebj()
	elseif tag >10 and tag <20 then
		self:selectbbj(tag-10)
    end
end
function BrSettingLayer:selectcb(index)
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
function BrSettingLayer:selectbbj(index)
	if self.bbj[index] ==nil then
		return
	end
	for k,v in pairs(self.bbj) do
		v:setEnabled(true)
        if k == index then
            v:setEnabled(false)
            self.bbj[k]:getChildByName("C"):setSelected(true)
        else
            self.bbj[k]:getChildByName("C"):setSelected(false)
        end
	end
	self.bjindex=index
end
return BrSettingLayer

