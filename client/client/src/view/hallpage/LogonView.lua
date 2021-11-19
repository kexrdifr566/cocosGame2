local LogonView = class("LogonView", function ()
	local logonView =  display.newLayer()
	return logonView
end)

local phoneLogon = appdf.req(appdf.VIEW.."hallpage.phoneLogon")
local checkLayer = appdf.req(appdf.VIEW.."hallpage.checkLayer")
 local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
--按钮定义
LogonView.Phone 	=	1
LogonView.Wx		=	2
LogonView.Xy		=	3
LogonView.XyB       =   4

LogonView.ceshi     =   20

function LogonView:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Layer/loginLayer.csb", self)
	self.bj=csbNode:getChildByName("bj")

	--self.bj:setPercentage(100)
		
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
	--微信登陆
	self.bj:getChildByName("B_wx")
	:setTag(LogonView.Wx)
	:addTouchEventListener(btcallback)

	--手机登陆
	self.bj:getChildByName("B_sj")
	:setTag(LogonView.Phone)
	:addTouchEventListener(btcallback)
	--协议按钮
	-- self.bj:getChildByName("Button_1")
	-- :setTag(LogonView.Xy)
	-- :addTouchEventListener(btcallback)

    --协议选中按钮
	self.bj:getChildByName("CheckBox")
	:setTag(LogonView.XyB)
	:addTouchEventListener(btcallback)
	self.xieyi=true
    --动画
    --local point={} point.x=640 point.y=535 
    --local point=self.bj:getPosition()
    if device.platform ~= "windows" then
        ExternalFun.addSpineWithCustomNode("Atlas/Login/logo",self.bj,"animation",cc.p(self.bj:getChildByName("d_logo_1"):getPosition()),false)
    end
    
    self.ceshi=self.bj:getChildByName("ceshi")
    self.ceshi:setVisible(device.platform == "windows")--device.platform == "windows"
    
    for i=1,20 do
        local bb=string.format("cb%d",i)
        self.ceshi:getChildByName(bb)
        :setTag(LogonView.ceshi+i-1)
        :addTouchEventListener(btcallback)
    end
    self.loginData={}
    self.machineId=cc.UserDefault:getInstance():getStringForKey("login_MachineId","")
    if self.machineId =="" then
        self.machineId=ExternalFun.Rnd_Number(40)
    end
    self:AutoLogin()
end
function LogonView:onButtonClickedEvent(tag,ref)
	--print("登陆界面按下："..tag)
	local layer =nil
	if tag == LogonView.Phone then
        layer=phoneLogon:create(self)
	elseif tag == LogonView.Wx then
		self:thirdPartyLogin()
	elseif tag == LogonView.Xy then
		self:agreelayer()
    elseif tag == LogonView.XyB then
    	if ref:isSelected() then
    		self.xieyi=false
    	else
    		self.xieyi=true
    	end
    elseif tag >= LogonView.ceshi then
        self:testLogin(tag-LogonView.ceshi)
        return
	end
	if layer and tag ~= LogonView.XyB then
		self:add(layer)
	end
end
function LogonView:testLogin(index)
    if device.platform == "windows" then
        function Senddata(datas)
            if self.enterClient then
                self:enterClient(datas)
            end
        end
        -- local testdata={"11111111111","22222222222","33333333333","44444444444","55555555555",
        -- "66666666666","44444444444","55555555555","66666666666","17700000001"}
        local testdata=17700000010+index
        local data={}
        data.pswd="123123"
        data.tel=testdata
        data.type=2
        if device.platform == "windows" then 
             self.machineId = "WFmPw6MMlwMnlPN4heXckZgnSA5G129M5eicvsf"
        end
        --data.groupCode=MultiPlatform:getInstance():groupCode()
        data.machineId  =  self.machineId 
        httpnect.send(HttpHead.phonelogin,data,Senddata)
        -- local str = ExternalFun.Rnd_Number(40)
        -- ExternalFun.print(str)
    end
end
function LogonView:sendLogon(Uid,Name,HeahUrl,sex)
          
	function Senddata(datas)
		self:enterClient(datas)
	end
	local data={}
	data.openid=Uid
	data.wxImgUrl=HeahUrl
    data.userName=Name
    data.sex=sex
	data.type=1
    --data.groupCode=MultiPlatform:getInstance():groupCode()
    data.machineId=self.machineId
    -- end
	--发送
	httpnect.send(HttpHead.phonelogin,data,Senddata)
    --保存数据
    self.loginData=data
end
function LogonView:sendPhoneLogon(tel,pswd)
    
	function Senddata(datas)
		self:enterClient(datas)
	end
	local data={}
	data.pswd=pswd
	data.tel=tel
	data.type=2
    
    data.machineId=self.machineId
    --data.groupCode=MultiPlatform:getInstance():groupCode()
    --end
	--发送
	httpnect.send(HttpHead.phonelogin,data,Senddata)
        --保存数据
    self.loginData=data
end
function LogonView:SaveLogon()

	if self.loginData.type then
        cc.UserDefault:getInstance():setIntegerForKey("login_type",self.loginData.type)
        if self.loginData.type == 1 then       -- 微信登陆
            cc.UserDefault:getInstance():setStringForKey("login_wxid",self.loginData.openid)
            cc.UserDefault:getInstance():setStringForKey("login_wxImgUrl",self.loginData.wxImgUrl)
            cc.UserDefault:getInstance():setStringForKey("login_wxuserName",self.loginData.userName)
            cc.UserDefault:getInstance():setStringForKey("login_wxsex",self.loginData.sex)
            cc.UserDefault:getInstance():setStringForKey("login_MachineId",self.machineId)
        elseif self.loginData.type == 2 then   --手机登陆
            cc.UserDefault:getInstance():setStringForKey("login_phtel",self.loginData.tel)
            cc.UserDefault:getInstance():setStringForKey("login_phpswd",self.loginData.pswd)
            cc.UserDefault:getInstance():setStringForKey("login_MachineId",self.machineId)
        end
    end
end
function LogonView:AutoLogin()
    local logintype=cc.UserDefault:getInstance():getIntegerForKey("login_type",0)

    if logintype == 1 then
        local Uid = cc.UserDefault:getInstance():getStringForKey("login_wxid")
        local HeahUrl = cc.UserDefault:getInstance():getStringForKey("login_wxImgUrl")
        local Name = cc.UserDefault:getInstance():getStringForKey("login_wxuserName")
        local sex = cc.UserDefault:getInstance():getStringForKey("login_wxsex")
        self.machineId=cc.UserDefault:getInstance():getStringForKey("login_MachineId")
        self:sendLogon(Uid,Name,HeahUrl,sex)
    elseif  logintype == 2 then
        local tel= cc.UserDefault:getInstance():getStringForKey("login_phtel",self.loginData.tel)
        local pswd= cc.UserDefault:getInstance():getStringForKey("login_phpswd",self.loginData.pswd)
        self.machineId=cc.UserDefault:getInstance():getStringForKey("login_MachineId")
        self:sendPhoneLogon(tel,pswd)
    end
end
function LogonView:enterClient(data)
    -- dump(data,"登陆")
    if data.code == "-1" then
        local layer=checkLayer:create(self,data,self.machineId)
        self:add(layer)
    else
        public.initdata(data)
        --保存登陆数据
        self:SaveLogon()
        --
        self.scene:enterClient()
    end
end
function LogonView:agreelayer()
	local btcallback = function (ref, type)
		if type == ccui.TouchEventType.ended then
			ExternalFun.playClickEffect()
			ref:setScale(1)
			if self:getChildByName("agreelayer") then
				self:getChildByName("agreelayer"):removeFromParent()
			end
			--agreelayer:removeFromParent()
		elseif type == ccui.TouchEventType.began then
			ref:setScale(public.btscale)
			return true
		elseif type == ccui.TouchEventType.canceled then
			ref:setScale(1)
		end
	end
	local agreelayer =ExternalFun.loadCSB("Layer/AgreeLayer.csb", self )
	agreelayer:setName("agreelayer")
	--协议按钮
	agreelayer:getChildByName("bj"):getChildByName("B_C")
	:addTouchEventListener(btcallback)
end
function LogonView:thirdPartyLogin()
    local function loginCallBack ( param )
        
		if type(param) == "string" and string.len(param) > 0 then
			local ok, datatable = pcall(function()
				return cjson.decode(param)
			end)
			if ok and type(datatable) == "table" then
               
				local account = datatable["unionid"] or ""
				local nick = datatable["screen_name"] or ""
				local szHeadUrl = datatable["profile_image_url"] or ""
				local gender = datatable["gender"] or ""
                if gender == nil or gender=="男" then
                    gender=0
                else
                    gender=1
                end
                self:sendLogon(account,nick,szHeadUrl,gender)
			end
		end
	end
    --平台判定
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
		MultiPlatform:getInstance():thirdPartyLogin(public.ThirdParty.WECHAT, loginCallBack)
	else
		showToast("不支持的登录平台 ==> " .. targetPlatform, 2)
	end
end
return LogonView