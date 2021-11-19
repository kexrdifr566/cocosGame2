local delwjLayer = class("delwjLayer", function ()
	local delwjLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return delwjLayer
end)
local AnimationHelper = appdf.req(appdf.EXTERNAL_SRC .. "AnimationHelper")
function delwjLayer:ctor(_scene)
    EventMgr.registerEvent(self,"delwjLayer")
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Club/Layer/delwj.csb", self)
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
    local t1=self.P[1]:getChildByName("Image")
	self.TF = ExternalFun.cteartTFtwo(t1:getChildByName("Image"),t1,"输入玩家ID",false,nil,nil,35)

	--按钮
	self.P[1]:getChildByName("B")
	:setTag(1)
	:addTouchEventListener(btcallback)
	self.P[2]:getChildByName("B")
	:setTag(2)
	:addTouchEventListener(btcallback)
    AnimationHelper.jumpInEx(self.bj, 1)
end
function delwjLayer:onButtonClickedEvent(tag,ref)
	if tag == 1 then				--查询按钮
		if ExternalFun.checkTFIDtwo(self.TF) then
			local data={}
			local clubinfo = public.getclubinfo(public.enterclubid)
			data.userCode = self.TF:getString()
			data.groupCode=clubinfo.groupCode
			st.send(HallHead.cxculbwj,data)
		end
	elseif  tag == 2 then			--删除按钮
		local data={}
		local clubinfo = public.getclubinfo(public.enterclubid)
		data.UserCode = self.userCode
		data.groupCode=clubinfo.groupCode
		st.send(HallHead.scxzcy,data)
	elseif tag == 100 then
        EventMgr.removeEvent("delwjLayer")
        self:removeFromParent()
    end
end
function delwjLayer:message(code,data)
	if code == HallHead.cxculbwj then
		--dump(data,"创建合伙人界面")
		if data.inGroup == "true"  then
			self.P[1]:setVisible(false)
			self.P[2]:setVisible(true)
			self.P[2]:getChildByName("T1"):setString(data.userName)
			self.P[2]:getChildByName("T2"):setString("ID:"..data.userCode)
            local headbg=self.P[2]:getChildByName("H")
            --设置头像
            ExternalFun.createClipHead(headbg,data.userCode,data.logoUrl,67)
			self.userCode=data.userCode
			self.TF:setString("输入玩家ID")
		else 
			showToast("该玩家不在俱乐部里面！",1)
		end
	elseif code == HallHead.scxzcy then
		showToast("删除玩家成功！",2)
		self.P[1]:setVisible(true)
		self.P[2]:setVisible(false)
		self.scene:selectPage(true)
	end
end
return delwjLayer

