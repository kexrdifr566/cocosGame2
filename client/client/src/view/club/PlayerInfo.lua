local PlayerInfo = class("PlayerInfo", function ()
	local PlayerInfo =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return PlayerInfo
end)
local wjxyLayer =appdf.req(appdf.VIEW.."club.wjxyLayer")					--玩家详情
local AnimationHelper = appdf.req(appdf.EXTERNAL_SRC .. "AnimationHelper")
function PlayerInfo:ctor(_scene,userCode)
    EventMgr.registerEvent(self,"PlayerInfo")
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Club/Layer/PlayerInfo.csb", self)
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
     self.bj:getChildByName("B_S")
	:setTag(1)
	:addTouchEventListener(btcallback)
    self.bj:getChildByName("B_SH")
	:setTag(2)
	:addTouchEventListener(btcallback)
     self.bj:getChildByName("B_SW")
	:setTag(3)
	:addTouchEventListener(btcallback)
     self.bj:getChildByName("B_qk")
	:setTag(5)
	:addTouchEventListener(btcallback)
     self.bj:getChildByName("B_jz")
	:setTag(4)
	:addTouchEventListener(btcallback)
    
    self.bj:getChildByName("B_jyjl")
	:setTag(6)
	:addTouchEventListener(btcallback)
    
    self.bj:getChildByName("B_DJ")
	:setTag(7)
	:addTouchEventListener(btcallback)
    self.bj:getChildByName("B_JD")
	:setTag(8)
	:addTouchEventListener(btcallback)
    
    
    self.bj:getChildByName("BC")
	:setTag(100)
	:addTouchEventListener(btcallback)
    self.userCode=userCode
    self.parentUserCode =nil
    self:inint()
     AnimationHelper.jumpInEx(self.bj, 1)
end
--关闭层
function PlayerInfo:onClose()
    EventMgr.removeEvent("PlayerInfo")
    self:removeFromParent()
end
function PlayerInfo:inint()
    -- 权限
    local clubinfo=public.getclubinfo(public.enterclubid)
   	if clubinfo.groupRoleCode  == public.culbCode.qunzhu 
            or clubinfo.groupRoleCode  == public.culbCode.fuqunzhu then  --只有群主才可
        self.bj:getChildByName("B_SH"):setVisible(true)
        self.bj:getChildByName("B_qk"):setVisible(true)
        self.bj:getChildByName("T_0"):setVisible(true)
        self.bj:getChildByName("T"):setVisible(true)
        self.bj:getChildByName("T_backcoin"):setVisible(true)
        self.bj:getChildByName("T_jzcoin"):setVisible(true)
        self.bj:getChildByName("T_backcoin"):setString(0)
        self.bj:getChildByName("T_jzcoin"):setString(0)
    else
        self.bj:getChildByName("B_SW"):setVisible(false)
        self.bj:getChildByName("B_SH"):setVisible(false)
        self.bj:getChildByName("B_qk"):setVisible(false)
        self.bj:getChildByName("T_0"):setVisible(false)
        self.bj:getChildByName("T"):setVisible(false)
        self.bj:getChildByName("T_backcoin"):setVisible(false)
        self.bj:getChildByName("T_jzcoin"):setVisible(false)
    end            
    local data = {}
    data.userCode =self.userCode 
    st.send(HallHead.grxx,data)
end
function PlayerInfo:inindata(data)
    self.userCode=data.userCode
    self.bj:getChildByName("T_Nime"):setString(data.userName)
    self.bj:getChildByName("T_Code"):setString("ID:"..data.userCode)
    self.bj:getChildByName("T_Shen"):setString("身份:"..data.groupRoleValue)
    if data.fcbl then
        self.bj:getChildByName("T_Fen"):setString("分成比例:"..data.fcbl)
    else
        self.bj:getChildByName("T_Fen"):setVisible(false)
    end
    local headbg=self.bj:getChildByName("head")
    ExternalFun.createClipHead(headbg,data.userCode,data.logoUrl,67)
    
    self.bj:getChildByName("T_gamecoin"):setString(data.gameCoin)
    self.bj:getChildByName("T_backcoin"):setString(data.userQianbao)
    self.bj:getChildByName("T_jzcoin"):setString(data.brokerageCoin)
    
    if data.parentUserCode then
        self.bj:getChildByName("T_Code_s"):setString("ID:"..data.parentUserCode)
        self.parentUserCode =data.parentUserCode
        self.bj:getChildByName("T_Nime_s"):setString(data.parentUserValue)
        local headbg=self.bj:getChildByName("head_s")
        ExternalFun.createClipHead(headbg,data.parentUserCode,data.parentUserLogoUrl,67)
        self.bj:getChildByName("T_Code_s"):setVisible(true)
        self.bj:getChildByName("T_Nime_s"):setVisible(true)
        self.bj:getChildByName("head_s"):setVisible(true)
        self.bj:getChildByName("head_ks"):setVisible(true)
        self.bj:getChildByName("B_S"):setVisible(true)
    else
        self.bj:getChildByName("T_Code_s"):setVisible(false)
        self.bj:getChildByName("T_Nime_s"):setVisible(false)
        self.bj:getChildByName("head_s"):setVisible(false)
        self.bj:getChildByName("head_ks"):setVisible(false)
        self.bj:getChildByName("B_S"):setVisible(false)
    end
    if data.freeze == 0 then
        self.bj:getChildByName("B_DJ"):setVisible(true)
        self.bj:getChildByName("B_JD"):setVisible(false)
    else
        self.bj:getChildByName("B_DJ"):setVisible(false)
        self.bj:getChildByName("B_JD"):setVisible(true)
    end
    local clubinfo=public.getclubinfo(public.enterclubid)
   	if clubinfo.groupRoleCode  == public.culbCode.qunzhu 
            or clubinfo.groupRoleCode  == public.culbCode.fuqunzhu then  --只有群主才可
        if data.groupRoleCode == public.culbCode.hehuoren then
            self.bj:getChildByName("B_SW"):setVisible(false)
            self.bj:getChildByName("B_SH"):setVisible(true)
        else
            self.bj:getChildByName("B_SH"):setVisible(false)
            self.bj:getChildByName("B_SW"):setVisible(true)
        end
    end
end
function PlayerInfo:onButtonClickedEvent(tag,ref)
	
    if tag == 100 then
        local layer=self.scene:getChildByName("cyglLayer")
        if layer and layer.selectPage then
            layer:selectPage(true)
        end	
        self:onClose()
    elseif tag == 1 then            --查看上级玩家
        if  self.parentUserCode ==public.userCode then
            showToast("不能查询我自己的上级",2)
            return
        end
        if self.parentUserCode then
            local data = {}
            data.userCode =self.parentUserCode 
            st.send(HallHead.grxx,data)
        end
    elseif tag == 3 then            --删除玩家
         local str =string.format("确定要删除玩家%s么？",self.userCode)
        QueryExit(str, function (ok)
            if ok == true then
                local clubinfo = public.getclubinfo(public.enterclubid)
                local data={}
                data.UserCode = self.userCode
                data.groupCode=clubinfo.groupCode
                st.send(HallHead.scxzcy,data)
            end
        end,false)
       
    elseif tag == 4 then            --打开设置界面
        local layer=self.scene:getChildByName("cyglLayer")
		if layer and layer.openscoreSetLayer then
			layer:openscoreSetLayer(self.userCode)
		end	
    elseif tag == 2 then
        function Senddata(datas)
			showToast("删除成功！",2)
			--self.scene:selectPage()
            local layer=self.scene:getChildByName("cyglLayer")
            if layer and layer.selectPage then
                layer:selectPage(true)
            end	
            self:onClose()
		end
     
        local str =string.format("确定要删除合伙人%s么？",self.userCode)
        QueryExit(str, function (ok)
            if ok == true then
                local clubinfo = public.getclubinfo(public.enterclubid)
                local data={}
                data.groupCode=clubinfo.groupCode
                data.teamLeaderCode=self.userCode
                data.createUserCode=public.userCode
                httpnect.send(HttpHead.dehhr,data,Senddata)
            end
        end,false)
       
    elseif tag == 5 then            --清理分数
        local str =string.format("确定要清理玩家%s的积分么？",self.userCode)
        QueryExit(str, function (ok)
            if ok == true then
                local data = {}
                data.userCode =self.userCode 
                st.send(HallHead.qlgrfs,data)
            end
        end,false)

     elseif tag == 6 then           --玩家详情
        local layer = wjxyLayer:create(self,self.userCode)  
        self:add(layer) 
     elseif tag == 7 or tag == 8 then
        local data = {}
        data.userCode =self.userCode 
        st.send(HallHead.djwj,data)
    end
end
function PlayerInfo:message(code,data)
    --dump(data,"返回消息"..code)
    if code == HallHead.grxx then
        self:inindata(data)
    elseif code == HallHead.qlgrfs then
        showToast("清理玩家分数成功!",1)
        local data = {}
        data.userCode =self.userCode 
        st.send(HallHead.grxx,data)
    elseif code == HallHead.djwj then
        if self.bj:getChildByName("B_DJ"):isVisible() then
            self.bj:getChildByName("B_DJ"):setVisible(false)
            self.bj:getChildByName("B_JD"):setVisible(true)
        else
            self.bj:getChildByName("B_DJ"):setVisible(true)
            self.bj:getChildByName("B_JD"):setVisible(false)
        end
    elseif HallHead.scxzcy == code then
        showToast("删除成功!!!",2)
        self:onClose()
    end
end
return PlayerInfo

