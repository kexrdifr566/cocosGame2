local BrPlayerListLayer = class("BrPlayerListLayer", function ()
	local BrPlayerListLayer =  display.newLayer()
	return BrPlayerListLayer
end)
function BrPlayerListLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Game/brpublicLayer/BrPlayerListLayer.csb", self)
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
	
    self.p=self.bj:getChildByName("p")
    self.pk=self.bj:getChildByName("pk")
    
    --获取数据
    gst.send(BaiRenHead.OnLineUserlist,nil)
end

function BrPlayerListLayer:onButtonClickedEvent(tag,ref)
    if tag == 100 then
		self:removeFromParent()
    end
end
function BrPlayerListLayer:inint(data)
    self.p:removeAllChildren()
     for k,v  in pairs(data) do
		local item=self.pk:clone()
        --设置头像
        local head=item:getChildByName("head")
        ExternalFun.createClipHead(head,v.userCode,v.logoUrl,70)
         item:getChildByName("T1"):setString(v.userName)
         item:getChildByName("T2"):setString(ExternalFun.showUserCode(v.userCode))
         item:getChildByName("T3"):setString(v.betCount)
         item:getChildByName("T4"):setString(v.betCoins)
         item:getChildByName("T5"):setString(v.sl.."%")
         item:getChildByName("A"):setString(k)
        -- local str =v.precent.."%"
        -- if v.precent == 0 then
        --     str ="等待上庄"
        -- end
        -- item:getChildByName("t"):setString(str)
        self.p:pushBackCustomItem(item)
    end
end
return BrPlayerListLayer

