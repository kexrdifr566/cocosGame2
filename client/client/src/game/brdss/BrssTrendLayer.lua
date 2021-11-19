local BrssTrendLayer = class("BrssTrendLayer", function ()
	local BrssTrendLayer =  display.newLayer()
	return BrssTrendLayer
end)
function BrssTrendLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadziRootCSB("Game/brLayer/BrssTrendLayer.csb", self)
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
	
    self.p=self.bj:getChildByName("Pd")
    self.pk=self.bj:getChildByName("pkd")
    gst.send(BaiRenHead.Trend,nil)
end

function BrssTrendLayer:onButtonClickedEvent(tag,ref)
    if tag == 100 then
		self:removeFromParent()
    end
end
function BrssTrendLayer:inint(data)
    --dump(data,"录单内容")
    if data == nil then
        data={}
    end
    self:intdss(data)
end
function BrssTrendLayer:intdss(data)
    self.p:removeAllChildren()
    local x,y=0
    for k,v  in pairs(data) do
		local item=self.pk:clone()
        local str={"Game/brpublic/brnui/b_fu.png","Game/brpublic/brnui/b_s.png"}
        --设置头像
        item:getChildByName("T1"):loadTexture(str[v.lossOrWinList[1] ==1 and 2 or 1])
        item:getChildByName("T2"):loadTexture(str[v.lossOrWinList[2] ==1 and 2 or 1])
        item:getChildByName("T3"):loadTexture(str[v.lossOrWinList[3] ==1 and 2 or 1])
        item:getChildByName("T4"):loadTexture(str[v.lossOrWinList[4] ==1 and 2 or 1])
        self.p:pushBackCustomItem(item)
    end
    -- if #data <14 then
    --     for i=1,(14-#data) do
    --         --设置头像
    --         local item=self.pk:clone()
    --         item:getChildByName("T1"):getChildByName("T"):setString("")
    --         item:getChildByName("T2"):getChildByName("T"):setString("")
    --         item:getChildByName("T3"):getChildByName("T"):setString("")
    --         item:getChildByName("T4"):getChildByName("T"):setString("")
    --         self.p:pushBackCustomItem(item)
            
    --     end
    -- end
    --self.p:jumpToPercentHorizontal(#data/14*100)
end
return BrssTrendLayer

