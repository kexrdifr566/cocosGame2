local phoneXiuGaiLayer = class("phoneXiuGaiLayer", function ()
	local phoneXiuGaiLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return phoneXiuGaiLayer
end)
local TAG={1,2,3,4}
function phoneXiuGaiLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Layer/PhoneXiuGaiLayer.csb", self)
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
    
    self.bfs=self.bj:getChildByName("B_YZ")
	self.bfs:setTag(1)
	self.bfs:addTouchEventListener(btcallback)
    
    self.bj:getChildByName("B_DL")
	:setTag(2)
	:addTouchEventListener(btcallback)
        

    local t1=self.bj:getChildByName("mima")
    self.mima=ExternalFun.cteartTFtwo(t1:getChildByName("image"),t1,"请输入密码",nil,nil,nil,35)
    local t1=self.bj:getChildByName("nichen")
    self.nichen=ExternalFun.cteartTFtwo(t1:getChildByName("image"),t1,"请输入确认密码",nil,nil,nil,35)
    local t1=self.bj:getChildByName("shouji")
    self.shouji=ExternalFun.cteartTFtwo(t1:getChildByName("image"),t1,"请输入绑定手机号",nil,true,nil,35)
    local t1=self.bj:getChildByName("code")
    self.code=ExternalFun.cteartTFtwo(t1:getChildByName("image"),t1,"请输入验证码",true,nil,nil,35)
    self.bfs:getChildByName("miaoshu"):setVisible(false)
end
-- function phoneXiuGaiLayer:onButtonClickedEvent(tag,ref)
--     if tag == 100 then
--         if self.tickder then
--             cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.tickder)
--         end
--         self:removeFromParent()
--     elseif tag == 1 then
--         if self:chickingkuang(true) then
--             self.select=1
--             self:sendData()
--         end
--     elseif tag == 2 then
--         if self:chickingkuang() then
--             self.select=2
--             self:sendData()
--         end
--     end
-- end
function phoneXiuGaiLayer:chickingkuang(phone)
    
    local shouji = tonumber(self.shouji:getString())
    if shouji == nil then
        showToast("请输入手机号",1)
		return
    end
	if  string.len(shouji) ~= 11 then
		showToast("手机号长度错误",1)
		return
	end
	local pos = string.find(shouji,"1")
	if  not pos or pos ~= 1 then
		showToast("手机号码错误",1)
		return
	end
    if phone then
        return  true
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
    local mima = self.mima:getString()
  --   if mima == nil then
  --       showToast("请输入密码",1)
		-- return
  --   end
	if  string.len(mima) < 6 or string.len(mima) >12 then
		showToast("密码长度不能少于6位或多于12位",2)
		return
	end
    local nichen =self.nichen:getString()
    if mima ~= nichen then
		showToast("两次输入密码不一样,请确认",2)
		return
	end
	return  true
end
-- function phoneXiuGaiLayer:sendData()
--     function Senddata(datas)
-- 		dump(datas,"获取数据")
--         if self.select == 1 then
--             showToast("发送验证码成功,注意查收!",2)
--             self.bfs:setEnabled(false)
--             self.bfs:getChildByName("fasong"):setVisible(false)
--             function Sendheat()
--                self.times=self.times-1
--                self.bfs:getChildByName("miaoshu"):setVisible(true)
--                self.bfs:getChildByName("miaoshu"):setString(self.times)
--                if self.times < 0 then
--                    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.tickder)
--                    self.bfs:getChildByName("fasong"):setVisible(true)
--                    self.bfs:setEnabled(true)
--                    self.bfs:getChildByName("miaoshu"):setVisible(false)
--                end
--             end
--             --添加读秒
--             self.times=30
--             self.bfs:getChildByName("miaoshu"):setVisible(true)
--             self.bfs:getChildByName("miaoshu"):setString(self.times)
--             self.tickder = cc.Director:getInstance():getScheduler():scheduleScriptFunc(Sendheat,1,false)
--         elseif self.select == 2 then
--             public.bindTelephone = "1"
--             showToast("恭喜你绑定手机成功",2)
--             self:onButtonClickedEvent(100,nil)
--         end
-- 	end
--     local url={HttpHead.getphonecode,HttpHead.bindTelphone}
--     local data={}
--     data.telephone=self.shouji:getString()
--     data.code =self.code:getString()
--     data.userCode=public.userCode
--     data.wxuuid =cc.UserDefault:getInstance():getStringForKey("login_wxid")
--     data.pssw=self.mima:getString()
--     httpnect.send(url[self.select],data,Senddata)
-- end
function phoneXiuGaiLayer:onButtonClickedEvent(tag,ref)
	function Senddata(datas)
        --dump(datas,"~~~")
		local str=""
		if self.sendtag ==1 then
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
		else
			showToast("密码修改成功!",2)
            self:onButtonClickedEvent(100)
		end
		--showToast(str,1)
	end

	local layer =nil
	if tag == 1 then
        if self:chickingkuang(true) then
            self.sendtag=1
            local data={}
            data.telephone=self.shouji:getString()
            httpnect.send(HttpHead.getphonecode,data,Senddata)
        end
	elseif tag == 2 then
        if self:chickingkuang() then
            local data={}
            data.code=self.code:getString()
            data.pswd=self.mima:getString()
            -- data.registBy=2
            data.telephone=self.shouji:getString()
            data.pw=self.nichen:getString()
            self.sendtag=2
            --发送
            httpnect.send(HttpHead.changePw,data,Senddata)
        end
	elseif tag == 100 then
        if self.tickder then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.tickder)
        end
 		self:removeFromParent()
	end
end

return phoneXiuGaiLayer