local shimingLayer = class("shimingLayer", function ()
	local shimingLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return shimingLayer
end)
local TAG={1,2,3,4}
function shimingLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Layer/shimingLayer.csb", self)
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
	self.bj:getChildByName("B_Q")
	:setTag(1)
	:addTouchEventListener(btcallback)

	local TF_iphone=self.bj:getChildByName("TF_1")
	self.xingming = ExternalFun.cteartTF(TF_iphone,"请输入真实姓名",nil,nil)
	self.xingming:addTo(self.bj)

	local TF_pass=self.bj:getChildByName("TF_2")
	self.IDCard = ExternalFun.cteartTF(TF_pass,"请输入身份证号",nil,nil)
	self.IDCard:addTo(self.bj)
end
function shimingLayer:onButtonClickedEvent(tag,ref)
    if tag == 100 then
    	self:removeFromParent()
    elseif tag == 1 then
    	if self:checkName(self.xingming:getText()) and self:checkID(self.IDCard:getText()) then
            function Senddata(datas)
                public.rzStatus = "1"
                showToast("您已经提成功认证！",1)
                self:removeFromParent()
            end
        	local data={}
			data.idCard=self.IDCard:getText()
			data.aliasName=self.xingming:getText()
			data.token=public.webtoken
			httpnect.send(HttpHead.UpUserinfo,data,Senddata)
        else
        	showToast("请认真检查！",1)
        end
    end
end
function shimingLayer:checkName(name)
	if  name == "" then
		return false
	end
	local filter = string.find(name, "^[a-zA-Z0-9@%.]+")
	if nil == filter then
		return true
	else
		return false
	end
	return true
end
function shimingLayer:checkID(id)
    local month_day = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
    local weight = { 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 }
    local check_code = { "1", "0", "X", "9", "8", "7", "6", "5", "4", "3", "2" }
    local year = tonumber(string.sub(id, 7, 10))
    local month = tonumber(string.sub(id, 11, 12))
    local day = tonumber(string.sub(id, 13, 14))
    local sum = 0
    if string.len(id) ~= 18 then
        return false
    end
    if not(tonumber(string.sub(id,1,6)) and year and month and day and string.match(string.sub(id,18), "[%dXx]")) then
        return false
    end

    if (year % 4 == 0 and year % 100 ~= 0) or year % 400 == 0 then month_day[2] = month_day[2] + 1 end
    if not ( year < 4000 and year > 1800 and month <= 12 and month > 0 and day <= month_day[month] and day > 0) then
        return false
    end
    for k, v in ipairs(weight) do
        sum = sum + string.sub(id,k,k) * v
    end
    if string.upper(string.sub(id, 18)) ~= check_code[sum % 11 + 1] then
        return false
    end
    return true
end
return shimingLayer
