local HallScene = class("HallScene", cc.load("mvc").ViewBase)
--层
local BindLayer=appdf.req(appdf.VIEW..".hallpage.BindLayer")
local SettingLayer=appdf.req(appdf.VIEW..".hallpage.SettingLayer")
local CreatorRoomLayer=appdf.req(appdf.VIEW..".hallpage.CreatorRoomLayer")
local HallShareLayer=appdf.req(appdf.VIEW..".hallpage.HallShareLayer")
local InviteCodeLayer=appdf.req(appdf.VIEW..".hallpage.InviteCodeLayer")
local joinClubPopLayer=appdf.req(appdf.VIEW..".hallpage.joinClubPopLayer")
local joinroomLayer=appdf.req(appdf.VIEW..".hallpage.joinroomLayer")
local kefuLayer=appdf.req(appdf.VIEW..".hallpage.kefuLayer")
local messageLayer=appdf.req(appdf.VIEW..".hallpage.messageLayer")
local testLayer=appdf.req(appdf.VIEW..".hallpage.testLayer")
local noiceLayer=appdf.req(appdf.VIEW..".hallpage.noiceLayer")
local shimingLayer=appdf.req(appdf.VIEW..".hallpage.shimingLayer")
local wanfaPopLayer=appdf.req(appdf.VIEW..".hallpage.wanfaPopLayer")
local yaoqingLayer=appdf.req(appdf.VIEW..".hallpage.yaoqingLayer")
local HuoDongLayer=appdf.req(appdf.VIEW..".hallpage.HuoDongLayer")
--俱乐部层
local ClubCreatLayer=appdf.req(appdf.VIEW..".hallpage.ClubCreatLayer")
local ClublistLayer=appdf.req(appdf.VIEW..".hallpage.ClublistLayer")
local loadingCircleLayer=appdf.req(appdf.VIEW..".hallpage.loadingCircleLayer")                  --滚动层
local BroadcastLayer=appdf.req(appdf.VIEW..".hallpage.BroadcastLayer")                  --滚动层
--正宗的俱乐部界面
local ClubLayer=appdf.req(appdf.VIEW..".club.ClubLayer")
TAG=
{
	--上左到上右1到10
	--中间左到右 11到20
	--下左到右 21到30
}

-- 进入场景而且过渡动画结束时候触发。
function HallScene:onEnterTransitionFinish()
    self:GetLockRoom()
	ExternalFun.playPlazzBackgroudAudio()
	--print("HallScene进入场景而且过渡动画结束时候触发。")
    return self
end

-- 退出场景而且开始过渡动画时候触发。
function HallScene:onExitTransitionStart()
   
	--print("HallScene退出场景而且开始过渡动画时候触发。")
    return self
end


function HallScene:onExit()
    EventMgr.removeEvent("HallScene")
	ExternalFun.stopBackgroudMusic()
	return self
end

-- 初始化界面
function HallScene:onCreate()
    EventMgr.inint()    
	ExternalFun.registerNodeEvent(self)
    EventMgr.registerEvent(self,"HallScene")

	--加载csb资源
	local rootLayer, csbNode = ExternalFun.loadRootCSB( "Layer/HallLayer.csb", self )
    self:setName("HallScene")
	--除系统按钮以外所有按钮的方法
	local btcallback = function (ref, type)
		if type == ccui.TouchEventType.ended then
			ref:setScale(1)
			ExternalFun.playClickEffect()
			self:onButtonClickedEvent(ref:getTag(),ref)
		elseif type == ccui.TouchEventType.began then
			ref:setScale(public.btscale)
			return true
		elseif type == ccui.TouchEventType.canceled then
			ref:setScale(1)
		end
	end
	--系统按钮
	local btsyscallback = function (ref, type)
		if type == ccui.TouchEventType.ended then
			ref:setScale(1)
			ExternalFun.playClickEffect()
			self:onBsysClickedEvent(ref:getTag(),ref)
		elseif type == ccui.TouchEventType.began then
			ref:setScale(public.btscale)
			return true
		elseif type == ccui.TouchEventType.canceled then
			ref:setScale(1)
		end
	end
	--总控制
	self.bj = csbNode:getChildByName("bj")
	--上
	self.Top=self.bj:getChildByName("Top")
	--认证
	self.Top:getChildByName("B_R")
	:setTag(1)
    :setVisible(false)
	:addTouchEventListener(btcallback)
	--绑定手机
	self.Top:getChildByName("B_P")
	:setTag(2)
	:addTouchEventListener(btcallback)
	--添加砖石
	self.Top:getChildByName("B_L")
    :setTag(5)
	:addTouchEventListener(btcallback)
    self.Top:getChildByName("B_L"):setVisible(false)
    
	self.Top:getChildByName("B_F")
    --:setTag(3)
	--:addTouchEventListener(btcallback)
	--系统设置
	-- self.Top:getChildByName("B_MS")
	-- :setTag(3)
 --    :addTouchEventListener(btsyscallback)
  
	--系统菜单
	self.Menu=self.Top:getChildByName("Menu")
	self.Menu:setVisible(false)
	--系统按钮设置
	self.Menu:getChildByName("B_1")
	:setTag(1)
	:addTouchEventListener(btsyscallback)
	self.Menu:getChildByName("B_2")
	:setTag(2)
	:addTouchEventListener(btsyscallback)
	self.Menu:getChildByName("B_3")
	:setTag(3)
	:addTouchEventListener(btsyscallback)
	self.Menu:getChildByName("B_4")
	:setTag(4)
	:addTouchEventListener(btsyscallback)

    self.text_NickName=self.Top:getChildByName("text_NickName")
    self.text_ID=self.Top:getChildByName("text_ID")
    self.text_zs=self.Top:getChildByName("text_zs")
    self.headbg=self.Top:getChildByName("frameIcon")
	--中
	self.Middle =self.bj:getChildByName("Middle")

	self.Middle:getChildByName("B_C")
	:setTag(11)
	:addTouchEventListener(btcallback)
	self.Middle:getChildByName("B_J")
	:setTag(12)
	:addTouchEventListener(btcallback)

    --动画
    --ExternalFun.addSpineWithCustomNode("Atlas/hall/wodelianmeng",self.Middle:getChildByName("B_B"),"animation",cc.p(70,196),false)

	self.Middle:getChildByName("B_B")
	:setTag(13)
	:addTouchEventListener(btcallback)

    --ExternalFun.addSpineWithCustomNode("Atlas/hall/chuangjian",self.Middle:getChildByName("B_JL"),"animation",cc.p(90,120),false)

    self.Middle:getChildByName("B_JL")
	:setTag(13)
	:addTouchEventListener(btcallback)
    
    --ExternalFun.addSpineWithCustomNode("Atlas/hall/jiaru",self.Middle:getChildByName("B_JRL"),"animation",cc.p(70,196),false)

    self.Middle:getChildByName("B_JRL")
	:setTag(27)
	:addTouchEventListener(btcallback)


    --ExternalFun.addSpineWithCustomNode("Atlas/hall/npc",self.Middle,"newAnimation",cc.p(-300,-180),false)


	--下
	self.Bottom =self.bj:getChildByName("Bottom")
	self.Bottom:getChildByName("B_C")
	:setTag(21)
	:addTouchEventListener(btcallback)
	self.Bottom:getChildByName("B_R")
	:setTag(22)
	:addTouchEventListener(btcallback)
	self.Bottom:getChildByName("B_M")
	:setTag(23)
	:addTouchEventListener(btcallback)
    
    self.Bottom:getChildByName("B_MS")
	:setTag(3)
    :addTouchEventListener(btsyscallback)
    
	self.red=self.Bottom:getChildByName("B_M"):getChildByName("red")
	self.red:setVisible(false)
	self.Bottom:getChildByName("B_S")
	:setTag(24)
	:addTouchEventListener(btcallback)
	self.Bottom:getChildByName("B_L")
	:setTag(25)
	:addTouchEventListener(btcallback)
	self.Bottom:getChildByName("B_SHOP")
	:setTag(26)
	:addTouchEventListener(btcallback)
    
    --底部客服
    self.Bottom:getChildByName("B_K")
    :setTag(2)
	:addTouchEventListener(btsyscallback)
    --底部公告
    self.Bottom:getChildByName("B_G")
	:setTag(3)
	:addTouchEventListener(btcallback)
    
    --底部玩法
    self.Bottom:getChildByName("B_WF")
	:setTag(1)
	:addTouchEventListener(btsyscallback)
    
    self:inint()   

    --public.t_rlayer=rootLayer;
    if(public.outgame==1)then
        --public.t_rlayer:setVisible(false);
        public.outgame=2;
    end
    
    local logintype=cc.UserDefault:getInstance():getIntegerForKey("login_type",0)
    --活动界面
    -- if public.activity and public.activity ==  "1" then
    --     layer=HuoDongLayer:create(self)
    --     self:add(layer)
    -- end
    --自动弹出手机绑定页面
    if public.bindTelephone ~= "1" and logintype == 1 and public.shouci ==true then
        layer=BindLayer:create(self)
        self:add(layer)
    end
    self.duanxianLayer=self.bj:getChildByName("duanxian")
    self.duanxianLayer:setLocalZOrder(100000)
    self.duanxianLayer:setVisible(true)
    public.shouci=false
    self.enter=true
    performWithDelay(self,function ()
           if self.duanxianLayer:isVisible() then
               showToast("网络连接错误，正在重试！！！",3)
               st.inint()
           end
    end,20)
    --公告
    self._notify = self.bj:getChildByName("sp_trumpet_bg")
    local thumpetSize = self._notify:getContentSize()
    local bb=self._notify:getChildByName("bb")
    local trumpetPX, trumpetPY = bb:getPosition()
    local stencil  = display.newSprite()
	:setAnchorPoint(cc.p(0,0.5))
	stencil:setTextureRect(cc.rect(0,0,thumpetSize.width-50,thumpetSize.height))
    self._notifyClip = cc.ClippingNode:create(stencil)
	:setAnchorPoint(cc.p(0,0.5))
	self._notifyClip:setInverted(false)
	self._notifyClip:move(trumpetPX+18,trumpetPY+2)
	self._notifyClip:addTo(self._notify)
    self.BroadcastLayer = BroadcastLayer:create(self,self._notify)	
	self.BroadcastLayer:addTo(self._notifyClip)
    self._notify:setTouchEnabled(true)
    self._notify:setVisible(false)
    self._notify:setLocalZOrder(99999)
end

--查询是否再房间内
function HallScene:GetLockRoom()
    if public.shouci == false then
    end
    local intt=nil 
    function Senddata(datas)
        intt=true
         --进入游戏
        if datas.roomCode and  datas.roomCode ~="0" then
            public.newintclubinfo(datas.groupInfo)
            public.enterclubid = datas.groupInfo.groupCode
            self:enterGame(datas.gameinfo)
            return
        else
            --进入俱乐部
            st.inint() 
        end
    end
     --print("检查1")
    local data={}
    data.userCode=public.userCode
    --发送
    httpnect.send(HttpHead.lockroom,data,Senddata)
end
function HallScene:inint()
	if public.hasMessage == "1" then
		self.red:setVisible(true)
	end
	self:updateInfo()
end
function HallScene:OpenHallScene()
    if self.enter==true then
        --上
        local x,y=self.Top:getPosition()
        local height=self.Top:getContentSize().height
        ExternalFun.nodeMove(self.Top, cc.p(x,y+height),cc.p(x,y))
        --下
        local x,y=self.Bottom:getPosition()
        local height=self.Bottom:getContentSize().height
        ExternalFun.nodeMove(self.Bottom, cc.p(x,y-height),cc.p(x,y))
            --下
        ExternalFun.nodeScale(self.Middle)
        self.enter=false 
    end
end
function HallScene:updateInfo()
    self.text_NickName:setString(public.userName)
    self.text_ID:setString(ExternalFun.showUserCode(public.userCode))
    self.text_zs:setString(public.zsCoin)
    --设置头像
    ExternalFun.createClipHead(self.headbg,public.userCode,public.logoUrl,75)
    --ExternalFun.createClipHead(self.headbg,public.userCode,public.logoUrl,67) 
end
--除系统按钮以外的所有按钮的方法
function HallScene:onButtonClickedEvent(tag,ref)
	--print("大厅界面按下按钮："..tag)
	local layer =nil
	local name=""
	if tag == 1 then
        
  --       if public.rzStatus == "1" then
  --           showToast("你已经认证过了！",2)
  --           return
  --       end
		-- layer=shimingLayer:create(self)
	elseif tag == 2 then
        if public.bindTelephone == "1" then
            showToast("你已经绑定了手机号！",2)
            return
        end 
        local logintype=cc.UserDefault:getInstance():getIntegerForKey("login_type",0)
        if logintype ~= 1 then
            showToast("你不是微信账号登陆不能进行绑定！",2)
            return
        end 
        layer=BindLayer:create(self)
	elseif tag == 3  then
        layer=noiceLayer:create(self)
	elseif tag == 4 then
		--注册范围
	    self:registerTouchListener()
		self.Menu:setVisible(true)
    elseif tag == 5 then
        layer=HuoDongLayer:create(self)
	elseif tag == 11 then
		layer=CreatorRoomLayer:create(self)
	elseif tag == 12 then
		layer=joinroomLayer:create(self)
	elseif tag == 13 then
		--showToast("俱乐部功能暂时关闭！",2)
		layer=ClublistLayer:create(self)
	elseif tag == 21 then
		--showToast("绑定邀请码功能暂时关闭！",2)
		layer =yaoqingLayer:create(self)
	elseif tag == 22 then
		showToast("战绩功能暂时关闭！",2)
		--layer=phoneRes:create(self)
	elseif tag == 23 then
		layer=messageLayer:create(self)
		name="messageLayer"
	elseif tag == 24 then
		layer=HallShareLayer:create(self)
	elseif tag == 25 then
		--layer=kefuLayer:create(self)
        self:upkefu()
	elseif tag == 27 then
		layer=ClubCreatLayer:create(self,2)
		name="ClubCreatLayer"
    elseif tag == 29 then
		layer=ClubCreatLayer:create(self,1)
		name="ClubCreatLayer"
    elseif tag == 28 then
    	if self:getChildByName("ClubLayer") == nil then
    	local clubinfo = public.getclubinfo(public.enterclubid)
	    	if clubinfo == nil then
	    		showToast("进入俱乐部错误！",2)
	    		return
	    	end
			layer=ClubLayer:create(self,clubinfo)
	        name="ClubLayer"
    	end
	else
		showToast("该功能暂时关闭！",1)
	end
	if layer then
		if name ~= "" then
        	layer:setName(name)
    	end
		self:add(layer)
	end
end
function HallScene:upkefu(str)
    --print("客户端打开地aaaa址"..str)
    if public.kfurl == nil then
        public.kfurl=" "
    end
    local str=string.len(public.kfurl)
    if str > 10 then
        cc.Application:getInstance():openURL(public.kfurl)
    else
        local layer=kefuLayer:create(self)
        self:add(layer)
    end
end
function HallScene:openurl(str)
    print("客户端打开地址"..str)
     cc.Application:getInstance():openURL(str)
end
--系统按钮的方法
function HallScene:onBsysClickedEvent(tag,ref)
	--print("大厅系统界面按下按钮："..tag)

	local layer =nil

	if tag == 1 then
		layer=wanfaPopLayer:create(self)
	elseif tag == 2 then
        self:upkefu()
		--layer=kefuLayer:create(self)
	elseif tag == 3 then
		layer=SettingLayer:create(self)
	elseif tag == 4 then
		QueryExit("确认退出游戏吗？", function (ok)
			if ok == true then
                
				os.exit(0)
			end
		end,true)
	else
		showToast("该功能暂时关闭！",1)
	end

	if layer then
		self:add(layer)
	end
end
function HallScene:registerTouchListener()
    --注册触摸
	local function onTouchBegan( touch, event )
		return true
	end
	local function onTouchEndeddd( touch, event )
		local pos = self.Menu:convertToNodeSpace(touch:getLocation())
    	local rect =cc.rect(0,0,self.Menu:getContentSize().width,self.Menu:getContentSize().height)
		if cc.rectContainsPoint(rect, pos) then
			return true
    	end
    		self:unregisterTouchListener()
        	self.Menu:setVisible(false)
		return false
	end
	local listener = cc.EventListenerTouchOneByOne:create()
	self.listener = listener
	listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEndeddd,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.Menu)
end
-- 取消触摸
function HallScene:unregisterTouchListener()
    local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:removeEventListener(self.listener)
	self.listener = nil
end
---------------------------------------------------------------消息处理----------------------------------------------------
function HallScene:message(code,data)
	--print("处理服务端发来的消息"..code)
    -- dump(data,"处理服务端发来的消息")
    if code == HallHead.cxculb  then--创建俱乐部
        if public.enterclubid ~= "0" then
            public.initclubinfo(nil)
            public.initclubinfo(data)
            local datas={}
                datas.groupCode=public.enterclubid
                st.send(HallHead.inculb,datas)                
            return
        end
    elseif code == HallHead.GGnotice then       --公告显示
        if  data then
            self.BroadcastLayer:setNoticeData({{content=data}})
        end
    elseif code == HallHead.sqculb then
        showToast("您已经成功提交,等待审核！",2)
    elseif code == HallHead.intalbe or  code ==HallHead.tcculb or code == HallHead.outroom  then --进入游戏房间
        if code == HallHead.intalbe and data.roomInfo == nil then
            showToast("该桌子错误,无法进入!",1)
            return
        end
        local layer=self:getChildByName("ClubLayer")
    	if layer and layer.sendquitclub then
    		layer:sendquitclub()
    	end
        if code ==HallHead.tcculb or code == HallHead.outroom  then
            if public.entergame == "0" then --排除进游戏了把俱乐部关闭了。
    		public.enterclubid = "0"
            end
        end
        --进入游戏
        if code == HallHead.intalbe  then
            self:enterGame(data)
        end
    elseif code  == HallHead.xxculb then-- 申请俱乐部消息
		if #data  == 0 then
			self.red:setVisible(false)
		end
    elseif code ==  HallHead.inculb then --进入俱乐部
        local layer=self:getChildByName("ClubLayer")
        --创建俱乐部
        if layer== nil then
    	local clubinfo = public.getclubinfo(public.enterclubid)
	    	if clubinfo == nil then
	    		showToast("进入俱乐部错误！",2)
	    		return
	    	end
			layer=ClubLayer:create(self,clubinfo)
        	layer:setName("ClubLayer")
            if data.msg000000 then
                        layer:message(HallHead.hqtalbe,data.msg000000)
            end
                if data.msg000040 then
                    layer:message(HallHead.Upcoin,data.msg000040)
                end
                if data.msg000048 then
                    layer:message(HallHead.notice,data.msg000048)
                end
            self:add(layer)
        else
             if data.msg000000 then
                --dump(data.msg000000 ,"对消息")
                layer:message(HallHead.hqtalbe,data.msg000000)
             end
            if data.msg000040 then
                layer:message(HallHead.Upcoin,data.msg000040)
            end
            if data.msg000048 then
                layer:message(HallHead.notice,data.msg000048)
            end
        end
         
        local clubinfo = public.getclubinfo(public.enterclubid)
        local data998={}
        data998.groupCode=clubinfo.groupCode
        st.send(HallHead.inroom,data998);--后台需要调用998        
       
        --判断进联盟是否有活动消息
        if data.activity == "1" and public.active and layer and layer.openActivity then
            public.active=false
            layer:openActivity()
        end
        if layer then
            layer:openActivityBB(data.activity == "1")
        end
        
    elseif code ==HallHead.jsroom then
        showToast(data,3)
    elseif code == HallHead.quanxian then
        --dump(data,"权限修改")
        local layer=self:getChildByName("ClubLayer")
    	if layer  then
            QueryExit("您的权限已修改,重新登陆俱乐部!", function (ok)
                --if ok == true then
                   layer:onButtonClickedEvent(13,nil)
            --end
            end,true)
    	end
    elseif code == HallHead.upzuanshi then
       public.zsCoin= data.zsCoin 
       self:updateInfo()
    elseif code == HallHead.tuichu then
         QueryExit("您的账号在别的地方登陆了,请核实!", function (ok)
                self:qiehuan()
         end,true)
   	end
end
--切换登陆
function HallScene:qiehuan()
	public.initgame()
    public.shouci=true
    cc.UserDefault:getInstance():setIntegerForKey("login_type",0)
    self:getApp():enterSceneEx(appdf.CLIENT_SRC.."view.LogonScene",nil,0.2)
end

--进入俱乐部
function HallScene:entergroup(groupInfo)
    public.enterclubid = groupInfo.groupCode 
    if HallHead.ws ~=groupInfo.wss and HallHead.port ~=groupInfo.port then
        HallHead.ws=groupInfo.wss
        HallHead.port=groupInfo.port
        appdf.HTTP_URL="http://"..groupInfo.wss..":"..groupInfo.port.."/"
        st.chargenet()
        showWait(10)
        st.inint()
    else
        local data={}
        data.groupCode=public.enterclubid 
        st.send(HallHead.inculb,data)
    end
end
--进入游戏
function HallScene:enterGame(gameInfo)
    --print("检查3")
    self:stopAllActions()
    st.chargenet()
    public.setGameTalbeinfo(gameInfo.roomInfo)
    
    public.entergame 	=  gameInfo.roomType
    public.roomCode  	=  gameInfo.roomCode
    public.port         =  gameInfo.port
    public.host         =  gameInfo.host
    --print("检查4")
    self:getApp():enterSceneEx(appdf.GAME_SRC.."GameScene","FADE",0.2)
end

return HallScene
