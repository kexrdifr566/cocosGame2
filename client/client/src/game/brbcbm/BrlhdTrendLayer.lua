local BrlhdTrendLayer = class("BrlhdTrendLayer", function ()
	local BrlhdTrendLayer =  display.newLayer()
	return BrlhdTrendLayer
end)
function BrlhdTrendLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadziRootCSB("Game/brLayer/BrlhdTrendLayer.csb", self)
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
    self.ditu=self.bj:getChildByName("ditu")
    self.ditu:setVisible(false)
    self.pd=self.bj:getChildByName("Pd")
    self.pd:setScrollBarEnabled(false)
    self.pkd=self.bj:getChildByName("pkd")
    self.sView=self.bj:getChildByName("sView")
    self.pd:setScrollBarEnabled(false)
    gst.send(BaiRenHead.Trend,nil)
end

function BrlhdTrendLayer:onButtonClickedEvent(tag,ref)
    if tag == 100 then
		self:removeFromParent()
    end
end
function BrlhdTrendLayer:inint(data)
    --dump(data,"录单内容")
    if data == nil then
        data={}
    end
    self:intd1(data)
    self:intd2(data)
    self:intd3(data)
end
function BrlhdTrendLayer:intd1(data)
    local longlist=0
    local zongshu=0
    for k,v in pairs(data) do
        if v.lossOrWinChair == -1 then
            longlist=longlist+1
            zongshu=zongshu+1
        end
        if v.lossOrWinChair == 1 then
            zongshu=zongshu+1
        end
    end
    print("总数位"..zongshu .." 龙的个数位"..longlist)
    --计算百分比
    local integer, decimal = math.modf(longlist*100/zongshu)
    local baifenbi=0
    --留一个取值范围
    if integer< 10 then
        baifenbi=10
    elseif integer >90 then
        baifenbi=90
    else
        baifenbi=integer
    end
    self.ditu:getChildByName("b1"):setContentSize(6*baifenbi,46)
    self.ditu:getChildByName("b2"):setContentSize(6*(100-baifenbi),46)
    self.ditu:getChildByName("b1"):getChildByName("t"):setString(integer.."%")
    self.ditu:getChildByName("b1"):getChildByName("t"):setPositionX(6*baifenbi/2)
    self.ditu:getChildByName("b2"):getChildByName("t"):setString((100-integer).."%")
    self.ditu:getChildByName("b2"):getChildByName("t"):setPositionX(6*(100-baifenbi)/2)
    self.ditu:setVisible(true)
end
function BrlhdTrendLayer:intd2(data)
    self.pd:removeAllChildren()
    local str={"Game/brlhd/px3.png","Game/brlhd/px1.png","Game/brlhd/px2.png"}
    for k,v in pairs(data) do
        local item=self.pkd:clone()
        item:getChildByName("T"):loadTexture(str[v.lossOrWinChair+2])
        self.pd:pushBackCustomItem(item)
    end
    self.pd:jumpToPercentHorizontal(100);
end
function BrlhdTrendLayer:intd3(data)
    self.sView:removeAllChildren()
    local str={"Game/brlhd/h3.png","Game/brlhd/h1.png","Game/brlhd/h2.png"}
    local x=0
    local y=0
    local gudingy=261
    local gey=40
    local gex=49
    --记录上一行的个数
    local juluy=0
    local oldwin=nil
    for k,v in pairs(data) do
        local item=self.pkd:clone()
        item:getChildByName("T"):loadTexture(str[v.lossOrWinChair+2])
        if oldwin == v.lossOrWinChair then
            if y==6 then
                x=x+1
            else
                y=y+1
            end
        else
            x=x+1
            y=0
        end
        item:setPosition(cc.p(gex*(x-1),gudingy-(40*y)))
        self.sView:addChild(item)
        oldwin=v.lossOrWinChair
    end
    self.pd:jumpToPercentHorizontal(100);
end
return BrlhdTrendLayer

