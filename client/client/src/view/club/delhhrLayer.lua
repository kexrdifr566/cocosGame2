local delhhrLayer = class("delhhrLayer", function ()
	local delhhrLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return delhhrLayer
end)
local AnimationHelper = appdf.req(appdf.EXTERNAL_SRC .. "AnimationHelper")
function delhhrLayer:ctor(_scene)
    EventMgr.registerEvent(self,"delhhrLayer")
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Club/Layer/delhhr.csb", self)
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
	self.TF = ExternalFun.cteartTFtwo(t1:getChildByName("Image"),t1,"输入合伙人ID",false,nil,nil,35)


	self.P[1]:getChildByName("B")
	:setTag(1)
	:addTouchEventListener(btcallback)
	self.P[2]:getChildByName("B")
	:setTag(2)
	:addTouchEventListener(btcallback)

    AnimationHelper.jumpInEx(self.bj, 1)
end
function delhhrLayer:onButtonClickedEvent(tag,ref)
	if tag == 1 then
		if ExternalFun.checkTFIDtwo(self.TF) then
			local data={}
			local clubinfo = public.getclubinfo(public.enterclubid)
			data.userCode = self.TF:getString()
			data.groupCode=clubinfo.groupCode
			st.send(HallHead.cxculbwj,data)
		end
	elseif tag == 2 then
		function Senddata(datas)
			showToast("删除成功！",1)
			self.P[1]:setVisible(true)
			self.P[2]:setVisible(false)
			self.scene:selectPage(true)
		end
		local clubinfo = public.getclubinfo(public.enterclubid)
		local data={}
		data.groupCode=clubinfo.groupCode
		data.teamLeaderCode=self.teamLeaderCode
        data.createUserCode=public.userCode
		httpnect.send(HttpHead.dehhr,data,Senddata)
		
    elseif tag == 100 then
        EventMgr.removeEvent("delhhrLayer")
        self:removeFromParent()
    end
end
function delhhrLayer:message(code,data)
    if code == HallHead.cxculbwj then
	--dump(data,"创建合伙人界面")
        if data.inGroup == "true"  then
            if data.groupRoleCode == "0" then
                showToast("该玩家不是俱乐部合伙人",1)
                return
            end
            self.P[1]:setVisible(false)
            self.P[2]:setVisible(true)
            self.P[2]:getChildByName("T1"):setString(data.userName)
            self.P[2]:getChildByName("T2"):setString("ID:"..data.userCode)
            self.P[2]:getChildByName("T3"):setString(data.teamValue)
            self.teamLeaderCode=data.userCode
            local headbg=self.P[2]:getChildByName("H")
            --设置头像
            ExternalFun.createClipHead(headbg,data.userCode,data.logoUrl,67)
            self.TF:setString("输入合伙人ID")
        else 
            showToast("该玩家不在俱乐部里面！",1)
        end
    end
end
return delhhrLayer

