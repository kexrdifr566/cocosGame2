local BrRuleLayer = class("BrRuleLayer", function ()
	local BrRuleLayer =  display.newLayer()
	return BrRuleLayer
end)
function BrRuleLayer:ctor(_scene,index)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Game/brpublicLayer/BrRuleLayer.csb", self)
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
    if index == 1 then
        self.bj:getChildByName("gui1"):setVisible(true)
        self.bj:getChildByName("gui2"):setVisible(false)
        self.bj:getChildByName("gui4"):setVisible(false)
    elseif index == 2 then
        self.bj:getChildByName("gui1"):setVisible(false)
        self.bj:getChildByName("gui2"):setVisible(true)
        self.bj:getChildByName("gui4"):setVisible(false)
    elseif index == 4 then
        self.bj:getChildByName("gui1"):setVisible(false)
        self.bj:getChildByName("gui2"):setVisible(false)
        self.bj:getChildByName("gui4"):setVisible(true)
    end
end
function BrRuleLayer:savebj()
	cc.UserDefault:getInstance():setIntegerForKey(self.gamebj, self.bjindex)

	self.scene:changebj()
	showToast("保存配置成功！",1)
end

function BrRuleLayer:onButtonClickedEvent(tag,ref)
    if tag == 100 then
		self:removeFromParent()
	elseif tag == 1 then
		self:savebj()
	elseif tag >10 and tag <20 then
		self:selectbbj(tag-10)
    end
end
function BrRuleLayer:selectcb(index)
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
function BrRuleLayer:selectbbj(index)
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
return BrRuleLayer

