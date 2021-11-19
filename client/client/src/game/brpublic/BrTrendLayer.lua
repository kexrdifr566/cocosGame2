local BrTrendLayer = class("BrTrendLayer", function ()
	local BrTrendLayer =  display.newLayer()
	return BrTrendLayer
end)
function BrTrendLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadziRootCSB("Game/brpublicLayer/BrTrendLayer.csb", self)
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
    self.sg=self.bj:getChildByName("sg")
    self.cow=self.bj:getChildByName("cow")
    self.sg:setVisible(false)
    self.cow:setVisible(false)
    --获取数据
    gst.send(BaiRenHead.Trend,nil)
end

function BrTrendLayer:onButtonClickedEvent(tag,ref)
    if tag == 100 then
		self:removeFromParent()
    end
end
function BrTrendLayer:inint(data)
    --dump(data,"录单内容")
    if data == nil then
        data={}
    end
    if public.entergame == public.brgame.sangong then
        self.sg:setVisible(true)
        self:intsg(data)
        
   
    elseif public.entergame == public.brgame.cow then 
        self.cow:setVisible(true)
        self:intcow(data)
    end        
end
function BrTrendLayer:intsg(data)
    self.p:removeAllChildren()
    local x,y=0
    for k,v  in pairs(data) do
		local item=self.pk:clone()
        --设置头像
        item:getChildByName("T1"):getChildByName("T"):setString(v.pxList[1])
        item:getChildByName("T2"):getChildByName("T"):setString(v.pxList[2])
        item:getChildByName("T3"):getChildByName("T"):setString(v.pxList[3])
        item:getChildByName("T4"):getChildByName("T"):setString(v.pxList[4])
        item:getChildByName("T1"):getChildByName("Image"):setVisible(v.lossOrWinList[1] ==1)
        item:getChildByName("T1"):getChildByName("T"):setTextColor(v.lossOrWinList[1] ==1 and  cc.c3b(255,255,255) or cc.c3b(0,0,0))
        item:getChildByName("T2"):getChildByName("Image"):setVisible(v.lossOrWinList[2] ==1)
        item:getChildByName("T2"):getChildByName("T"):setTextColor(v.lossOrWinList[2] ==1 and  cc.c3b(255,255,255) or cc.c3b(0,0,0))
        item:getChildByName("T3"):getChildByName("Image"):setVisible(v.lossOrWinList[3] ==1)
        item:getChildByName("T3"):getChildByName("T"):setTextColor(v.lossOrWinList[3] ==1 and  cc.c3b(255,255,255) or cc.c3b(0,0,0))
        item:getChildByName("T4"):getChildByName("Image"):setVisible(v.lossOrWinList[4] ==1)
        item:getChildByName("T4"):getChildByName("T"):setTextColor(v.lossOrWinList[4] ==1 and  cc.c3b(255,255,255) or cc.c3b(0,0,0))
        self.p:pushBackCustomItem(item)
    end
    if #data <14 then
        for i=1,(14-#data) do
            --设置头像
            local item=self.pk:clone()
            item:getChildByName("T1"):getChildByName("T"):setString("")
            item:getChildByName("T2"):getChildByName("T"):setString("")
            item:getChildByName("T3"):getChildByName("T"):setString("")
            item:getChildByName("T4"):getChildByName("T"):setString("")
            self.p:pushBackCustomItem(item)
            
        end
    end
    --self.p:jumpToPercentHorizontal(#data/14*100)
end
function BrTrendLayer:intcow(data)
    self.p:removeAllChildren()
    local x,y=0
    for k,v  in pairs(data) do
		local item=self.pk:clone()
        --设置头像
         item:getChildByName("T1"):getChildByName("T"):setString(v.pxList[1])
         item:getChildByName("T2"):getChildByName("T"):setString(v.pxList[2])
         item:getChildByName("T3"):getChildByName("T"):setString(v.pxList[3])
         item:getChildByName("T4"):getChildByName("T"):setString(v.pxList[4])
        -- item:getChildByName("T1"):setColor(v.lossOrWinList[1] ==1 and  cc.c3b(27,132,217) or cc.c3b(255,255,255))
        -- item:getChildByName("T2"):setColor(v.lossOrWinList[2] ==1 and  cc.c3b(27,132,217) or cc.c3b(255,255,255))
        -- item:getChildByName("T3"):setColor(v.lossOrWinList[3] ==1 and  cc.c3b(27,132,217) or cc.c3b(255,255,255))
        -- item:getChildByName("T4"):setColor(v.lossOrWinList[4] ==1 and  cc.c3b(188,30,27) or cc.c3b(255,255,255))
        item:getChildByName("T1"):getChildByName("Image"):setVisible(v.lossOrWinList[1] ==1)
        item:getChildByName("T1"):getChildByName("T"):setTextColor(v.lossOrWinList[1] ==1 and  cc.c3b(255,255,255) or cc.c3b(0,0,0))
        item:getChildByName("T2"):getChildByName("Image"):setVisible(v.lossOrWinList[2] ==1)
        item:getChildByName("T2"):getChildByName("T"):setTextColor(v.lossOrWinList[2] ==1 and  cc.c3b(255,255,255) or cc.c3b(0,0,0))
        item:getChildByName("T3"):getChildByName("Image"):setVisible(v.lossOrWinList[3] ==1)
        item:getChildByName("T3"):getChildByName("T"):setTextColor(v.lossOrWinList[3] ==1 and  cc.c3b(255,255,255) or cc.c3b(0,0,0))
        item:getChildByName("T4"):getChildByName("Image"):setVisible(v.lossOrWinList[4] ==1)
        item:getChildByName("T4"):getChildByName("T"):setTextColor(v.lossOrWinList[4] ==1 and  cc.c3b(255,255,255) or cc.c3b(0,0,0))
        self.p:pushBackCustomItem(item)
    end
    if #data <14 then
        for i=1,(14-#data) do
            --设置头像
            local item=self.pk:clone()
            item:getChildByName("T1"):getChildByName("T"):setString("")
            item:getChildByName("T2"):getChildByName("T"):setString("")
            item:getChildByName("T3"):getChildByName("T"):setString("")
            item:getChildByName("T4"):getChildByName("T"):setString("")
            self.p:pushBackCustomItem(item)
            
        end
    end
    --self.p:jumpToPercentHorizontal(#data/14*100)
end
return BrTrendLayer

