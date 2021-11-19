local cjhhrLayer = class("cjhhrLayer", function ()
	local cjhhrLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return cjhhrLayer
end)
local AnimationHelper = appdf.req(appdf.EXTERNAL_SRC .. "AnimationHelper")
function cjhhrLayer:ctor(_scene,fencengbili)
    EventMgr.registerEvent(self,"cjhhrLayer")
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Club/Layer/cjhhr.csb", self)
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
	self.TF2 = ExternalFun.cteartTFtwo(TF:getChildByName("Image"),TF:getChildByName("Image"),"请输入分成比例",true,nil,nil,35)


	self.P[1]:getChildByName("B")
	:setTag(1)
	:addTouchEventListener(btcallback)
	self.P[2]:getChildByName("B")
	:setTag(2)
	:addTouchEventListener(btcallback)

	self.P[2]:getChildByName("B1")
	:setTag(3)
	:addTouchEventListener(btcallback)
	self.P[2]:getChildByName("B2")
	:setTag(4)
	:addTouchEventListener(btcallback)
    
    self.fcbl=fencengbili
	self.qbi	=	math.floor(fencengbili/2)
	self.hbi 	= 	fencengbili- self.qbi
    --分成比例调整 1级和多级不同
    self.zuidi = 5
    if self.fcbl ~= 100 then
        self.zuidi = 1
    end
    --可用分成比例
    self.P[2]:getChildByName("T4"):setString(self.fcbl)
    self.P[2]:getChildByName("T5"):setString(self.zuidi)
    AnimationHelper.jumpInEx(self.bj, 1)
end
function cjhhrLayer:onButtonClickedEvent(tag,ref)
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
			function Senddata(datas)
				showToast("创建成功！",1)
				self.TF2:setString("请输入分成比例")
				self.P[1]:setVisible(true)
				self.P[2]:setVisible(false)
				self.scene:selectPage(true)
			end
			local clubinfo = public.getclubinfo(public.enterclubid)
			local data={}
			data.createUserCode=public.userCode
			data.createUserValue=public.userName
			data.fcbl1=self.qbi
			data.fcbl2=self.hbi
			data.groupCode=clubinfo.groupCode
			data.teamLeaderCode=self.teamLeaderCode
			data.teamLeaderValue=self.teamLeaderValue
			data.teamValue=""
			httpnect.send(HttpHead.cjhhr,data,Senddata)
		end
	elseif tag == 3 or tag == 4 then
		self:gaibi(tag == 3)
	elseif tag == 100 then
        EventMgr.removeEvent("cjhhrLayer")
        self:removeFromParent()
    end
end
function cjhhrLayer:checkfenceng()
    local chatnum =tonumber(self.TF2:getString()) --TF:getString() --
    if chatnum ==nil  then
        showToast("请输入分成比例",2)
        return
    end
    if chatnum > (self.fcbl-self.zuidi) or chatnum< 1 then
        showToast("请输入正确得分成比例",2)
        return
    end
    self.qbi=self.fcbl-chatnum
    self.hbi = self.fcbl - self.qbi
    return true
end
function cjhhrLayer:gaibi(add)
	if add  then
		if self.qbi == (self.fcbl-self.zuidi)  then
			return
		end
		self.qbi= self.qbi+1
	else
		if self.qbi == self.zuidi then
			return
		end
		self.qbi = self.qbi-1
	end
	self.hbi = self.fcbl - self.qbi
	local str = self.qbi.."%".."/"..self.hbi.."%"
	self.P[2]:getChildByName("T3"):setString(str)
end
function cjhhrLayer:message(code,data)
	--dump(data,"创建合伙人界面")
    if code == HallHead.cxculbwj then
        if data.inGroup == "true"  then
            self.P[1]:setVisible(false)
            self.P[2]:setVisible(true)
            self.P[2]:getChildByName("T1"):setString(data.userName)
            self.P[2]:getChildByName("T2"):setString("ID:"..data.userCode)
            local str = self.qbi.."%".."/"..self.hbi.."%"
            self.P[2]:getChildByName("T3"):setString(str)
            self.teamLeaderCode=data.userCode
            self.teamLeaderValue=data.userName
            local headbg=self.P[2]:getChildByName("H")
            --设置头像
            ExternalFun.createClipHead(headbg,data.userCode,data.logoUrl,67)

            self.TF:setString("请输入ID")
        else 
            showToast("该玩家不在俱乐部里面！",1)
        end
    end
end
return cjhhrLayer

