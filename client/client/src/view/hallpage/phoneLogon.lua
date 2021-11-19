local phoneLogon = class("phoneLogon", function ()
	local phoneLogon =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return phoneLogon
end)
local phoneRes = appdf.req(appdf.VIEW.."hallpage.phoneRes")
local phoneXiuGaiLayer = appdf.req(appdf.VIEW.."hallpage.phoneXiuGaiLayer")
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
local TAG={1,2,3,4,5}
function phoneLogon:ctor(_scene)

	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Layer/phoneloginLayer.csb", self)
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
    --登陆
	self.bj:getChildByName("B_DL")
	:setTag(TAG[1])
	:addTouchEventListener(btcallback)
	--忘记密码
	self.bj:getChildByName("B_WJ")
	:setTag(TAG[2])
	:addTouchEventListener(btcallback)
	--清除按钮
	self.bj:getChildByName("B_QC")
	:setTag(TAG[3])
	:addTouchEventListener(btcallback)
    --关闭按钮
	self.bj:getChildByName("B_C")
	:setTag(TAG[4])
	:addTouchEventListener(btcallback)
    
        --关闭按钮
	self.bj:getChildByName("B_zc")
	:setTag(TAG[5])
	:addTouchEventListener(btcallback)

	local TF_iphone=self.bj:getChildByName("TF_iphone")
	self.TF_iphone = ExternalFun.cteartTF(TF_iphone,"请输入账号",nil,true,nil,35)
	self.TF_iphone:addTo(self.bj)

	local TF_pass=self.bj:getChildByName("TF_pass")
	self.TF_pass = ExternalFun.cteartTF(TF_pass,"请输入密码",nil,nil,true,35)
	self.TF_pass:addTo(self.bj)
    if device.platform == "windows" then
		self.TF_iphone:setText("13123456789")
		self.TF_pass:setText("123123")
	end

end
function phoneLogon:onButtonClickedEvent(tag,ref)
	--print("登陆界面按下："..tag)
	if tag == TAG[1] then
		if 	self:checking() then
			self:sendLogon()
		end
	elseif tag== TAG[2] then
        local layer=phoneXiuGaiLayer:create(self)
        self:add(layer)
	elseif tag == TAG[3] then
		self.TF_iphone:setText("")
		self.TF_pass:setText("")
	elseif tag == TAG[4] then
		self:removeFromParent()
    elseif tag == TAG[5] then
        local layer=phoneRes:create(self)
        self:add(layer)
	end
end
function phoneLogon:sendLogon()--实现登陆
    self.scene:sendPhoneLogon(self.TF_iphone:getText(),self.TF_pass:getText())
end
function phoneLogon:checking()
	if self.scene.xieyi == false then
		showToast("你未同意协议,不能登陆游戏！",1)
		return
	end
	local AccountStr = string.gsub(self.TF_iphone:getText()," ","")
	local inputPWDStr = string.gsub(self.TF_pass:getText()," ","")
	if inputPWDStr == "" or AccountStr == "" then
		showToast("手机号或密码不能为空或空格",1)
		return
	end

	if  string.len(AccountStr) ~= 11 then
		showToast("手机号长度错误",1)
		return
	end
	local pos = string.find(AccountStr,"1")
	if  not pos or pos ~= 1 then
		showToast("手机号码错误",1)
		return
	end
	if inputPWDStr == "" then
		showToast("密码不能为空或空格",2)
		return
	end
	if string.len(inputPWDStr) < 6 or string.len(inputPWDStr)> 12 then
		showToast("密码长度不能少于6位或多于12位",2)
		return
	end
	return  true
end

return phoneLogon