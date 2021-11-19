local TxianLayer = class("TxianLayer", function ()
	local TxianLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return TxianLayer
end)
local AnimationHelper = appdf.req(appdf.EXTERNAL_SRC .. "AnimationHelper")
local TAG={1,2,3,4}
function TxianLayer:ctor(_scene,clubinfo)
	self.scene=_scene
	self._clubinfo = clubinfo
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Club/Layer/TxianLayer.csb", self)
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
    self.bb={}
	for i = 1, 3 do
		local str =string.format("B_%d",i)
		self.bb[i]=self.bj:getChildByName(str)
		self.bb[i]:setTag(i)
		:addTouchEventListener(btcallback)
        self.bb[i]:getChildByName("Text"):setColor(cc.c3b(114,69,21))
        if i==1 then
            self.bb[i]:setEnabled(false)
            self.bb[i]:getChildByName("Text"):setColor(cc.c3b(255,255,255))
        end
	end
    self.bj:getChildByName("B4")
    :setTag(30)
	:addTouchEventListener(btcallback)
    self.p1=self.bj:getChildByName("P1")
    self.p2=self.bj:getChildByName("P2")
    self.p3=self.bj:getChildByName("P3")
    self.p4=self.bj:getChildByName("P4")
    
    self.btnbd=self.p1:getChildByName("B2")
    self.btnbd:setTag(8)
        :setVisible(false)
		:addTouchEventListener(btcallback)
    
    self.btngh=self.p1:getChildByName("B5")
    self.btngh:setTag(9)
        :setVisible(false)
		:addTouchEventListener(btcallback)
    local t1=self.p4:getChildByName("Image1")
	self.t41 = ExternalFun.cteartTFtwo(t1:getChildByName("Image"),t1,"请输入银行卡账号",false,nil,nil,35,true)
    
    local t1=self.p4:getChildByName("Image2")
	self.t42 = ExternalFun.cteartTFtwo(t1:getChildByName("Image"),t1,"请输入银行名称",false,nil,nil,35)
    
    local t1=self.p4:getChildByName("Image3")
	self.t43 = ExternalFun.cteartTFtwo(t1:getChildByName("Image"),t1,"请输入持卡人姓名",false,nil,nil,35)
    
    local t1=self.p4:getChildByName("Image4")
	self.t44 = ExternalFun.cteartTFtwo(t1:getChildByName("Image"),t1,"开户行省份",false,nil,nil,35)
    
    local t1=self.p4:getChildByName("Image5")
	self.t45 = ExternalFun.cteartTFtwo(t1:getChildByName("Image"),t1,"开户行城市",false,nil,nil,35)
    
    local t1=self.p4:getChildByName("Image6")
	self.t46 = ExternalFun.cteartTFtwo(t1:getChildByName("Image"),t1,"请输入开户行名称",false,nil,nil,35)
    
    self.p4:getChildByName("B_C")
        :setTag(7)
		:addTouchEventListener(btcallback)
    self.p4:getChildByName("B1")
        :setTag(6)
		:addTouchEventListener(btcallback)
    self.p1:getChildByName("B3")
        :setTag(5)
		:addTouchEventListener(btcallback)

    
    local t1=self.p1:getChildByName("Image2")
	self.tt = ExternalFun.cteartTFtwo(t1:getChildByName("Image"),t1,"请输入提取金额",false,nil,nil,35)
    
    self.bj:getChildByName("T"):setString(self._clubinfo.gameCoin)
    self.bj:getChildByName("B_C")
	:setTag(100)
	:addTouchEventListener(btcallback)
    self:inint()
    AnimationHelper.jumpInEx(self.bj, 1)
end
function TxianLayer:yinhangka(data)
    print("未绑定银行卡信息".. type(data))
   if type(data) ~= "userdata" and data.yhkKh then
       self.bangding=true
       self.BDXX=data
       self.btngh:setVisible(true)
       self.btnbd:setVisible(false)
       local Tz =self.p1:getChildByName("Tz"):setString(data.yhkKh)
   elseif type(data) == "userdata" then
       self.bangding=false
       local Tz =self.p1:getChildByName("Tz"):setString("未绑定银行卡信息")
       self.btnbd:setVisible(true)
       self.btngh:setVisible(false)
   end
end
function TxianLayer:inint()
    self.select=0
    self.bangding=false
    self.p2:setVisible(false)
    self.p3:setVisible(false)
    self.p4:setVisible(false)
    self:sendData()
    self.BDXX={}
    self.kefuulr=""
    self:huoqudizhi()
end
function TxianLayer:huoqudizhi()
    
    function Senddata(datas)
        self.kefuulr=datas.kf
    end
    local data ={}
    data.groupCode=self._clubinfo.groupCode
    
    httpnect.send(HttpHead.groupKf,data,Senddata)
end
function TxianLayer:onButtonClickedEvent(tag,ref)
    --print("选择"..tag)
    if tag == 100 then
        self.scene:upCoin()
        self:removeFromParent()
    elseif tag >=1 and tag < 4 then
    	self:selectB(tag)
    elseif tag == 5 then
        if self:checkingf() then
            self.select=1
            self:sendData()
        end
    elseif tag == 6 then
        if self:checking() then
            self.select=3
            self:sendData()
        end
    elseif tag  == 7 then
        self.p4:setVisible(false)
        self.p1:setVisible(true)
    elseif tag == 30 then
        if self.kefuulr ~="" then
            cc.Application:getInstance():openURL(self.kefuulr)
        else
            showToast("客服未设置!",2)
        end
    elseif tag == 8  or tag == 9 then
        if self.bangding then
            self.t41:setString(self.BDXX.yhkKh)
            self.t42:setString(self.BDXX.yhkMc)
            self.t43:setString(self.BDXX.yhkXm)
            self.p4:setVisible(true)
            self.p1:setVisible(false)
            self.p2:setVisible(false)
            self.p3:setVisible(false)
        else
            self.t41:setString("请输入银行卡账号")
            self.t42:setString("请输入银行名称")
            self.t43:setString("请输入持卡人姓名")
            self.p4:setVisible(true)
            self.p1:setVisible(false)
            self.p2:setVisible(false)
            self.p3:setVisible(false)
        end
    end
end
function TxianLayer:checkingf()
    local str = tonumber(self.tt:getString())
    if str ==nil  then
        showToast("请输入提款金额",1)
        return
    end
    if  string.len(str) < 1  then
		showToast("提款金额输入错误",1)
		return
    elseif  str > self._clubinfo.gameCoin  and str <=0 then
		showToast("身上金额不足",1)
		return
	end
    
    return true
end
function TxianLayer:checking()
    local str = tonumber(self.t41:getString())
    local str1 = self.t42:getString()
    local str2 = self.t43:getString()
    local str3 = self.t44:getString()
    local str4 = self.t45:getString()
    local str5 = self.t46:getString()
    if str ==nil then
        showToast("请输入银行卡号",1)
		return
    end
    if str1 ==nil then
        showToast("请输入银行名称",1)
		return
    end
    if str2 ==nil then
        showToast("请输入持卡人姓名",1)
		return
    end
    if str3 ==nil then
        showToast("请输入银行所在省份",1)
		return
    end
    if str4 ==nil then
        showToast("请输入银行所在城市",1)
		return
    end
    if str5 ==nil then
        showToast("请输入开户行",1)
		return
    end
    if  string.len(str) < 16 or string.len(str) > 21  then
		showToast("银行卡账号输入错误",1)
		return
    elseif  string.len(str1) < 1  then
		showToast("银行名称输入错误",1)
		return
    elseif  string.len(str2) < 1  then
		showToast("持卡人姓名输入错误",1)
		return
    elseif  string.len(str3) < 1  then
		showToast("银行所在省份输入错误",1)
		return
    elseif  string.len(str4) < 1  then
		showToast("银行所在城市输入错误",1)
		return
     elseif  string.len(str5) < 1  then
		showToast("开户行名称输入错误",1)
		return
	end
    
    return true
end
function TxianLayer:selectB(index)
	if self.bb[index] ==nil then
		return
	end
	for k,v in pairs(self.bb) do
		v:setEnabled(true)
        v:getChildByName("Text"):setColor(cc.c3b(114,69,21))
        if k == index then
            v:setEnabled(false)
            v:getChildByName("Text"):setColor(cc.c3b(255,255,255))
        end
	end
    if index ~= 3 then
        self.select=index
    else
        self.select=2
    end
    self.p4:setVisible(false)
    if index ==1 then
        self.p1:setVisible(true)
        self.p2:setVisible(false)
        self.p3:setVisible(false)
        --self.t1:setText("")
    elseif index == 2 then
        self.p1:setVisible(false)
        self.p2:setVisible(true)
        self.p3:setVisible(false)
    elseif index ==3 then
        self.p1:setVisible(false)
        self.p2:setVisible(false)
        self.p3:setVisible(true)
        self:sendData()
    end
   
end
function TxianLayer:inintp(data)
    --dump(data,"提现数据")
    local p=self.p3:getChildByName("P")
    p:removeAllChildren()
    
    for k,v in pairs(data) do
        local item=self.p3:getChildByName("pk"):clone()
        item:getChildByName("T1"):setString(v.createTime)
        item:getChildByName("T2"):setString(v.txje)
        local str=""
        if v.status == "DD" then
            str="等待"
        elseif v.status == "TG" then
            str="通过"
        elseif v.status == "JJ" then
            str="拒绝"
        elseif v.status == "SX" then
            str="失效"
        end
        item:getChildByName("T3"):setString(str)
        p:pushBackCustomItem(item)
    end
end
function TxianLayer:sendData()
    function Senddata(datas)
       --dump(datas,"多都多")
        if self.select==0 then
            self.select=1
            self:yinhangka(datas)
        elseif self.select == 1 then
            local gameCoin = tonumber(self.bj:getChildByName("T"):getString()) --tonumber(self.tt:getText())
            self.bj:getChildByName("T"):setString(gameCoin)
            showToast("申请提交成功",2)
            self.tt:setText("")
        elseif self.select == 2 then
            self:inintp(datas)
        elseif self.select == 3 then
            showToast("提交成功",2)
            self.p4:setVisible(false)
            self.p1:setVisible(true)
            self.select =0
            self:sendData()
        end
    end
    local httpurl ={HttpHead.ticxbd,HttpHead.tixian,HttpHead.tijilu,HttpHead.tibangding}
    --print("选择"..self.select)
    local url=httpurl[self.select+1]
    local data ={}
    data.userCode = public.userCode
    data.groupCode=self._clubinfo.groupCode
    if self.select == 3 then
        data.yhkKh=self.t41:getString()
        data.yhkMc=self.t42:getString()
        data.yhkXm=self.t43:getString()
        
        data.yhkSf=self.t44:getString()
        data.yhkCs=self.t45:getString()
        data.yhkHmc=self.t46:getString()
    elseif self.select == 1 then
        local str = tonumber(self.tt:getString())
        data.txje=str
    end
    httpnect.send(url,data,Senddata)
end
return TxianLayer

