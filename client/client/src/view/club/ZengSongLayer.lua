local ZengSongLayer = class("ZengSongLayer", function ()
	local ZengSongLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return ZengSongLayer
end)
local AnimationHelper = appdf.req(appdf.EXTERNAL_SRC .. "AnimationHelper")
function ZengSongLayer:ctor(_scene)
    EventMgr.registerEvent(self,"ZengSongLayer")
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Club/Layer/ZengSongLayer.csb", self)
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
    self.bj:getChildByName("BC")
	:setTag(100)
	:addTouchEventListener(btcallback)
	self.P={}
	for i = 1, 2 do
		local str =string.format("P%d",i)
		self.P[i]=self.bj:getChildByName(str)
		if i == 2 then
			self.P[i]:setVisible(false)
		end
	end
	--查询ID
	local TF=self.P[1]:getChildByName("Image")
	self.TF = ExternalFun.cteartTFtwo(TF:getChildByName("Image"),TF:getChildByName("Image"),"请输入ID",true,nil,nil,35)

	--查询ID
	local TF=self.P[2]:getChildByName("Image")
	self.TF2 = ExternalFun.cteartTFtwo(TF:getChildByName("Image"),TF:getChildByName("Image"),"赠送金币数目",true,nil,nil,35)
    
    	--查询ID
	local TF=self.P[2]:getChildByName("Image1")
	self.TF3 = ExternalFun.cteartTFtwo(TF:getChildByName("Image"),TF:getChildByName("Image"),"请输入背包密码",nil,nil,nil,35)

	self.P[1]:getChildByName("B")
	:setTag(1)
	:addTouchEventListener(btcallback)
	self.P[2]:getChildByName("B")
	:setTag(2)
	:addTouchEventListener(btcallback)
     self.select=0
     self:sendData()
    AnimationHelper.jumpInEx(self.bj, 1)
end
function ZengSongLayer:onButtonClickedEvent(tag,ref)
    if tag == 1 then
        if ExternalFun.checkTFIDtwo(self.TF) then
			local data={}
			local clubinfo = public.getclubinfo(public.enterclubid)
			data.userCode = self.TF:getString()
			data.groupCode=clubinfo.groupCode
			st.send(HallHead.cxculbwj,data)
		end
    elseif tag == 2 then
        if self:checkfenceng() then
            self:sendData()
        end
    elseif tag == 100 then
        self.scene:upCoin()
        EventMgr.removeEvent("ZengSongLayer")
        self:removeFromParent()
    end
end
function ZengSongLayer:checkfenceng()
    local chatnum =tonumber(self.TF2:getString()) --TF:getString() --
    if chatnum ==nil  then
        showToast("请输入赠送金额",2)
        return
    end
    if chatnum > tonumber(self.P[2]:getChildByName("T3"):getString()) or chatnum  == 0  then
        showToast("赠送金额输入错误!",2)
        return
    end
    local t1=self.TF3:getString()
    if t1 == "" then
            showToast("请输入密码",2)
            return
        end
        if string.len(t1) < 6 or string.len(t1)> 12 then
            showToast("输入密码不对,请重新输入",2)
            return
        end
    return true
end
function ZengSongLayer:message(code,data)
	--dump(data,"赠送界面")
    if HallHead.cxculbwj == code then
        if data.inGroup == "true"  then
            self.P[1]:setVisible(false)
            self.P[2]:setVisible(true)
            self.P[2]:getChildByName("T1"):setString(data.userName)
            self.P[2]:getChildByName("T2"):setString(data.userCode)
            local headbg=self.P[2]:getChildByName("H")
            --设置头像
            ExternalFun.createClipHead(headbg,data.userCode,data.logoUrl,67)

            self.TF:setString("请输入ID")
        else 
            showToast("该玩家不在俱乐部里面！",1)
        end
    end
end
function ZengSongLayer:sendData()
	function Senddata(datas)
        if self.select==0 then
            self.select=1
            self.P[2]:getChildByName("T3"):setString(datas.userQianbao)
        else
            showToast("赠送成功!",2)
            self.TF2:setString("请赠送金币数目")
        end
    end
    local clubinfo = public.getclubinfo(public.enterclubid)
    local httpurl ={HttpHead.qbchaxun,HttpHead.youxiJbZs}
    local url=httpurl[self.select+1]
    local data ={}
    data.userCode = public.userCode
    data.groupCode=clubinfo.groupCode
    data.toUserCode=self.P[2]:getChildByName("T2"):getString()
    data.je=tonumber(self.TF2:getString())
    data.qianbaoMima =self.TF3:getString()

    httpnect.send(url,data,Senddata)
end
        
return ZengSongLayer

