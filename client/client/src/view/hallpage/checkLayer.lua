local checkLayer = class("checkLayer", function ()
	local checkLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return checkLayer
end)
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
local TAG={1,2,3,4}
function checkLayer:ctor(_scene,data,machineId)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Layer/checkLayer.csb", self)
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
    self.bj:getChildByName("B_C")--:setVisible(false)
	:setTag(100)
	:addTouchEventListener(btcallback)
    self.iphone=data.tel
    self.userCode=data.userCode
    self.bfs=self.bj:getChildByName("B_YZ")
	self.bfs:setTag(1)
	self.bfs:addTouchEventListener(btcallback)
        
    self.bj:getChildByName("BB")
	:setTag(2)
	:addTouchEventListener(btcallback)
    
    self.bj:getChildByName("shouji"):getChildByName("T"):setString(self.iphone)
    local t1=self.bj:getChildByName("code")
    self.code=ExternalFun.cteartTFtwo(t1:getChildByName("image"),t1,"请输入验证码",true,nil,nil,35)
    self.bfs:getChildByName("miaoshu"):setVisible(false)
    self.machineId=machineId
end
function checkLayer:onButtonClickedEvent(tag,ref)
    if tag == 100 then
        if self.tickder then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.tickder)
        end
        self:removeFromParent()
    elseif tag == 1 then
        if self:chickingkuang(true) then
            self.select=1
            self:sendData()
        end
    elseif tag == 2 then
        if self:chickingkuang() then
            self.select=2
            self:sendData()
        end
    end
end
function checkLayer:chickingkuang(phone)
    if  phone then 
        return true
    end
    local code = tonumber(self.code:getString())
    if code == nil then
        showToast("请输入验证码",1)
		return
    end
	if  string.len(code) ~= 6 then
		showToast("验证码长度错误",1)
		return
	end
	return  true
end
function checkLayer:sendData()
    local MachineId=MultiPlatform:getMachineId()
    -- if MachineId == nil  then
    --     showToast("不支持的登录平台",5)
    --     return
    -- end
    
    function Senddata(datas)
		--dump(datas,"获取数据")
        if self.select == 1 then
            showToast("发送验证码成功,注意查收!",2)
            self.bfs:setEnabled(false)
            self.bfs:getChildByName("fasong"):setVisible(false)
            function Sendheat()
               self.times=self.times-1
               self.bfs:getChildByName("miaoshu"):setVisible(true)
               self.bfs:getChildByName("miaoshu"):setString(self.times)
               if self.times < 0 then
                   cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.tickder)
                   self.bfs:getChildByName("fasong"):setVisible(true)
                   self.bfs:setEnabled(true)
                   self.bfs:getChildByName("miaoshu"):setVisible(false)
               end
            end
            --添加读秒
            self.times=30
            self.bfs:getChildByName("miaoshu"):setVisible(true)
            self.bfs:getChildByName("miaoshu"):setString(self.times)
            self.tickder = cc.Director:getInstance():getScheduler():scheduleScriptFunc(Sendheat,1,false)
        elseif self.select == 2 then
            public.bindTelephone = "1"
            showToast("恭喜你切换登陆设备成功",2)
            self:onButtonClickedEvent(100,nil)
        end
	end
     
    local url={HttpHead.getphonecode,HttpHead.changeMac}
    local data={}
    data.telephone=self.iphone
    data.code =self.code:getString()
    data.userCode=self.userCode
    data.machineId=self.machineId

    httpnect.send(url[self.select],data,Senddata)
end
return checkLayer