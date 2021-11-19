local ClubLayer = class("ClubLayer", function ()
	local ClubLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return ClubLayer
end)
local NoticeLayer =appdf.req(appdf.VIEW.."club.NoticeLayer")
local Tableinfo =appdf.req(appdf.VIEW.."Table.Tableinfo")
local RankLayer =appdf.req(appdf.VIEW.."club.RankLayer")
local StatisticsLayer =appdf.req(appdf.VIEW.."club.StatisticsLayer")
local CreatorRoomLayer =appdf.req(appdf.VIEW.."GameCreat.CreatorRoomLayer")
local UpdateRoomLayer =appdf.req(appdf.VIEW.."GameCreat.UpdateRoomLayer")
local cyglLayer = appdf.req(appdf.VIEW.."club.cyglLayer")
local cyglcyLayer =appdf.req(appdf.VIEW.."club.cyglcyLayer")				--成员页面
local yaoqingLayer=appdf.req(appdf.VIEW..".hallpage.yaoqingLayer")          --邀请界面
local NoGameLayer=appdf.req(appdf.VIEW..".hallpage.NoGameLayer")          --期待界面
local RecordLayer =appdf.req(appdf.VIEW.."club.RecordLayer")				--成员页面
local BagLayer =appdf.req(appdf.VIEW.."club.BagLayer")				--成员页面
local ChongzhiLayer =appdf.req(appdf.VIEW.."club.ChongzhiLayer")				--成员页面
local TxianLayer =appdf.req(appdf.VIEW.."club.TxianLayer")				--成员页面
local ZengSongLayer =appdf.req(appdf.VIEW.."club.ZengSongLayer")				--成员页面
local NewStatisticsLayer =appdf.req(appdf.VIEW.."club.NewStatisticsLayer")				--成员页面
local HeadSprite = appdf.req(appdf.EXTERNAL_SRC .. "HeadSprite")
local SettingLayer=appdf.req(appdf.VIEW..".hallpage.SettingLayer")
local HuoDongLayer=appdf.req(appdf.VIEW..".hallpage.HuoDongLayer")                  --活动层
local BroadcastLayer=appdf.req(appdf.VIEW..".hallpage.BroadcastLayer")                  --滚动层
local PlayerInfo =appdf.req(appdf.VIEW.."club.PlayerInfo")				--成员页面
local wjxyLayer =appdf.req(appdf.VIEW.."club.wjxyLayer")					--玩家详情
local TableLayer =appdf.req(appdf.VIEW.."Table.TableLayer")					--桌子层
function ClubLayer:ctor(_scene,clubinfo)
    
	ExternalFun.registerNodeEvent(self)
    EventMgr.registerEvent(self,"ClubLayer")
    
	self.scene=_scene
	self.clubinfo=clubinfo
	----dump(self.clubinfo,"进入俱乐部信息")
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Club/Layer/ClubLayer.csb", self)
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
    
    --上层
    self.Top=self.bj:getChildByName("up")
	self.Top:getChildByName("B_1")
	:setTag(1)
	:addTouchEventListener(btcallback)
	self.Top:getChildByName("B_2")
	:setTag(2)
	:addTouchEventListener(btcallback)
	self.Top:getChildByName("B_3")
	:setTag(3)
	:addTouchEventListener(btcallback)
	self.Top:getChildByName("B_4")
	:setTag(4)
	:addTouchEventListener(btcallback)
	self.Top:getChildByName("B_5")
	:setTag(5)
	:addTouchEventListener(btcallback)
	self.Top:getChildByName("B_6")
	:setTag(6)
	:addTouchEventListener(btcallback)
	self.Top:getChildByName("B_7")
	:setTag(7)
	:addTouchEventListener(btcallback)
    
    self.Top:getChildByName("B_j")
	:setTag(16)
	:addTouchEventListener(btcallback)
    
    
    if self.clubinfo.groupRoleCode  == public.culbCode.qunzhu or self.clubinfo.groupRoleCode  == public.culbCode.fuqunzhu  then  --只有群主才可以打开
        self.Top:getChildByName("B_7"):setVisible(true)
    else
        self.Top:getChildByName("B_7"):setVisible(false)
    end
    ExternalFun.addSpineWithCustomNode("Atlas/hall/xingguang",self.Top,"animation",cc.p(540,0),false)
    self.Top:getChildByName("B_8")
	:setTag(8)
	:addTouchEventListener(btcallback)
    
    self.Top:getChildByName("B_9")
	:setTag(9)
	:addTouchEventListener(btcallback)
    self.Top:getChildByName("B_9"):setVisible(false)
    --公告
    self._notify = self.Top:getChildByName("sp_trumpet_bg")
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
    self.Top:setZOrder(10000)
    --self._notify:setVisible(true)
    --下层

    self.Bottom =self.bj:getChildByName("down")
    self.Bottom:getChildByName("B_1")
	:setTag(11)
	:addTouchEventListener(btcallback)
	self.Bottom:getChildByName("B_2")
	:setTag(12)
	:addTouchEventListener(btcallback)
	self.Bottom:getChildByName("B_3")
	:setTag(13)
	:addTouchEventListener(btcallback)
    
    self.Bottom:getChildByName("B_15")
	:setTag(15)
	:addTouchEventListener(btcallback)
    
    self.Bottom:getChildByName("B_14")
	:setTag(14)
	:addTouchEventListener(btcallback)
    
    self.Bottom:getChildByName("B_15"):getChildByName("A"):getAnimation():play("ani_dtyl_2an_cz")
    self.Bottom:getChildByName("B_14"):getChildByName("A"):getAnimation():play("ani_dtyl_2an_tx")
    
    self.Bottom:getChildByName("B_4")
	:setTag(3)
	:addTouchEventListener(btcallback)

    self.Bottom:getChildByName("B_5")
	:setTag(2)
	:addTouchEventListener(btcallback)
    
    self.Bottom:getChildByName("B_6")
	:setTag(4)
	:addTouchEventListener(btcallback)
    
    self.Bottom:getChildByName("B_7")
	:setTag(6)
	:addTouchEventListener(btcallback)

    self.Bottom:getChildByName("B_8")
	:setTag(1)
	:addTouchEventListener(btcallback)
    
    self.Bottom:getChildByName("B_9")
	:setTag(5)
	:addTouchEventListener(btcallback)
        
    self.Bottom:getChildByName("B_10")
	:setTag(8)
	:addTouchEventListener(btcallback)
    --移动
    local move=true
    if self.clubinfo.groupRoleCode  == public.culbCode.qunzhu or self.clubinfo.groupRoleCode  == public.culbCode.fuqunzhu  then  --只有群主才可以打开
        move =false
    end
    --底下按钮移动
    for i = 4, 10 do
		local str =string.format("B_%d",i)
        local btn =self.Bottom:getChildByName(str)
        if move == true then
            --btn:setPositionX(50+133*(i-4))
            btn:setPositionX(50+100*(i-4));
        else
            --print(btn:getPositionX());
            --btn:setPositionX(250+100*(i-4))
        end
	end
    
    self.gamelist=self.bj:getChildByName("gamelist")
    self.gamelist:setScrollBarEnabled(false)
    self.tablebtn=self.bj:getChildByName("tablebtn")
    self.tabletype={}
    self.roomlist=self.bj:getChildByName("roomlist")
    self.roomlist:setScrollBarEnabled(false)
    self.roomlist:setVisible(false)
    self.gamelistg={}
    local GB=self.bj:getChildByName("GB")
    for k,v in pairs(public.GameList.gameicon) do
        local item=GB:clone()
        item:setTag(50+k)
        item:addTouchEventListener(btcallback)
        local str ="Atlas/game/"..v;
        local ico=cc.Sprite:create(str..".png");
        item:addChild(ico);
        ico:setPosition(cc.p(item:getContentSize().width/2,item:getContentSize().height/2));
        --ExternalFun.addSpineWithCustomNode(str,item:getChildByName("Image"),"animation",cc.p(71.5,52.5),false)
        local szico=cc.Sprite:create(str.."_s.png");
        local icog=item:getChildByName("g");
        icog:addChild(szico);
        szico:setPosition(cc.p(icog:getContentSize().width/2,icog:getContentSize().height/2));
        icog:setVisible(false);

        self.gamelist:pushBackCustomItem(item)
        self.gamelistg[k]=item;
    end
    self.gamelistg[1]:getChildByName("g"):setVisible(true) 
    
    self.bj:getChildByName("up"):getChildByName("B_C")
	:setTag(13)
	:addTouchEventListener(btcallback)
    --新建桌子层
    self.TableLayer=TableLayer:create(self)
    self.TableLayer:setPosition(cc.p(158,134.41))
    self.bj:addChild(self.TableLayer)
    
    self:init()
    self.SelectGameType=public.GameList.SetRoomType[1]
    self.SelectGameTable=1
    if public.ingametype ~= 0 then
        --self.SelectGameType=public.ingametype
        --更新桌子
        self:onButtonClickedEvent(public.ingametype,nil)
        --更新上次选中标题
        --self:uptableTitle(public.TableTitle)
    end


    if(public.sele_gamet and public.outgame)then
        if(public.sele_gamet and public.sele_gamet~="ALL")then
            for k,v in pairs(self.gamelistg) do
                if v:getTag() == public.sele_gamet then
                    self.SelectGameType=public.GameList.SetRoomType[public.sele_gamet-50];
                    v:getChildByName("g"):setVisible(true);
                else
                    v:getChildByName("g"):setVisible(false);
                end
            end
        end
    end
    
    self.Top:getChildByName("TT_3"):setString(ExternalFun.numberTrans(self.clubinfo.gameCoin))

    public.sele_gamet=nil;
        
end


function ClubLayer:init()
	--初始化自己的信息
	self.Top:getChildByName("TT_2"):setString(public.userCode)
	self.Top:getChildByName("TT_1"):setString(public.userName)
	--self.Bottom:getChildByName("T_3"):setString(ExternalFun.numberTrans(self.clubinfo.gameCoin))
    local headbg=self.Top:getChildByName("head")
    --设置头像
    ExternalFun.createClipHead(headbg,public.userCode,public.logoUrl,130)
	--初始化俱乐部信息down
	self.Top:getChildByName("T1"):setString("0")
	self.Top:getChildByName("T2"):setString("0")
	self.Top:getChildByName("T3"):setString("0")
	self.Top:getChildByName("T4"):setString("0")
	self.Top:getChildByName("T5"):setString(self.clubinfo.groupValue)
	self.Top:getChildByName("T6"):setString("ID:"..self.clubinfo.groupCode)
    self.Bottom:getChildByName("B_1"):setVisible(false)
	--隐藏按钮
	if self.clubinfo.groupRoleCode  == public.culbCode.qunzhu 
    or self.clubinfo.groupRoleCode  == public.culbCode.fuqunzhu  then  --只有群主才可
		self.Bottom:getChildByName("B_1"):setVisible(true)
	end
      
end
function ClubLayer:upCoin()
    local data={}
    data.userCode=public.userCode
	data.groupCode=self.clubinfo.groupCode
	st.send(HallHead.Upcoin,data)
end
function ClubLayer:uptoptable(data)
	local dz=0
	local nn=0
	local sg=0
	local sz=0
	for k,v in pairs(data) do
		if v.roomType == "1" then
			dz=dz+1
		end
	end
	self.Top:getChildByName("T1"):setString(nn)
	self.Top:getChildByName("T2"):setString(sz)
	self.Top:getChildByName("T3"):setString(sg)
	self.Top:getChildByName("T4"):setString(dz)
end
function ClubLayer:onEnterTransitionFinish()
    self:OpenHallScene()
    self.scene.duanxianLayer:setVisible(false)
end
function ClubLayer:onButtonClickedEvent(tag,ref)
	local layer =nil
	local name =""
	--print("俱乐部界面按下"..tag)
    if tag == 100 then
        public.ingametype =0
    	self:sendquitclub()
	elseif tag == 6 then
        layer=BagLayer:create(self,self.clubinfo)		
	elseif tag == 2 then
		if self.clubinfo.groupRoleCode ~= public.culbCode.huiyuan then
    		layer=cyglLayer:create(self,self.clubinfo,true)
            name="cyglLayer"
		else
			showToast("您没有权限!",1)
		end
	elseif tag  == 3 then
		layer=RecordLayer:create(self)
    elseif tag == 5 then--刷新桌子
        showWait(5)
    	local data={}
        local clubinfo = public.getclubinfo(public.enterclubid)
		data.groupCode=clubinfo.groupCode
		st.send(HallHead.hqtalbe,data)
	elseif tag == 4 then                    --邀请界面
		--layer=StatisticsLayer:create(self)
        layer=yaoqingLayer:create(self)
    elseif tag == 1 then
        layer=NewStatisticsLayer:create(self)
		--layer=SettingLayer:create(self,true)
    elseif tag == 7 then
		layer=NoticeLayer:create(self,self.clubinfo)
    elseif tag == 8 then
		layer=ZengSongLayer:create(self,self.clubinfo)
    elseif tag == 9 then  
        -- layer=HuoDongLayer:create(self)
        self:openActivity()
    elseif tag == 11 then
		layer=CreatorRoomLayer:create(self,self.clubinfo)
	elseif tag == 12 then
		self:quickGame()
    elseif tag == 13 then --返回 退出界面
        public.tabv1pcen=0;
        public.outgame=nil;
        public.sele_gamet=nil;
        
        if ref then
            self.scene:onButtonClickedEvent(13,nil)
        end
    	self:sendquitclub()
        public.enterclubid="0"
    elseif tag == 15 then
        layer=ChongzhiLayer:create(self,self.clubinfo)
    elseif tag == 16 then
        layer = wjxyLayer:create(self,public.userCode)
    elseif tag == 14 then
        layer=TxianLayer:create(self,self.clubinfo)
    elseif tag >= 50 and tag <=60 then
        for k,v in pairs(self.gamelistg) do
            if v:getTag() == tag then
                if public.outgame==3 then
                    public.tabv1pcen=0;
                    public.outgame=nil;
                end
                public.sele_gamet=v:getTag();
                v:getChildByName("g"):setVisible(true) 
                v:setEnabled(false)                   
            else
                v:setEnabled(true) 
                v:getChildByName("g"):setVisible(false)
            end 
        end
        if public.GameList.SetRoomType[tag-50] == nil then
            --showToast("游戏即将上线,敬请期待!",2)
             layer=NoGameLayer:create(self)
        else
            public.ingametype=tag
            self.SelectGameType=public.GameList.SetRoomType[tag-50]
            if 1 == (tag-50) then
                self.roomlist:setVisible(false)
            else
                self.roomlist:setVisible(true)
            end
            --更新桌子
            self.TableLayer:SeletTable(self.SelectGameType,nil)
            if self.SelectGameTable ~= "ALL" then
                self:uptableTitle()
            end
        end
	elseif tag == 101 then								--成员管理
		layer=cyglcyLayer:create(self,self.clubinfo)
	else
    	--showToast("该功能开发中！",1)
    end
    if layer then
		if name ~= "" then
        	layer:setName(name)
    	end
		self:add(layer)
	end
end
function ClubLayer:openActivity()
    --if  public.duanxian == nil  then 
        local layer=HuoDongLayer:create(self)
        self:add(layer)
    --end
end
function ClubLayer:openActivityBB(ble)
    self.Top:getChildByName("B_9"):setVisible(ble)
end
function ClubLayer:quickGame()
	----dump(public.entertable,"俱乐部桌子信息")
	local tableinfoto=nil
	for k,v in pairs(public.entertable) do
		if tableinfoto == nil then
			tableinfoto=v
		end
	end
    if tableinfoto ==nil then
        showToast("没有桌子可用!",1)
        return
    end
	self:enterClubRoom(tableinfoto.roomCode,tableinfoto.roomType)
end
function ClubLayer:entertableinfo(data,userList)
    local datas = {}
    datas.roomCode =data.roomCode
    st.send(HallHead.tableinfo,datas)
end
function ClubLayer:enterClubRoom(roomCode,roomType,join)

    local joinModel = 0 
    if  join then
        joinModel = 1
    end
	local sdata={}
	sdata.roomCode=roomCode
    sdata.roomType=roomType
    sdata.joinModel=joinModel
    st.send(HallHead.intalbe,sdata)
end
function ClubLayer:openUpdateRoom(data)
    local layer=UpdateRoomLayer:create(self,data)
    layer:setName("UpdateRoomLayer")
    self:add(layer)
end
--退出现有的俱乐部
function ClubLayer:sendquitclub()
	local data={}
    local clubinfo = public.getclubinfo(public.enterclubid)
	data.groupCode=clubinfo.groupCode
    st.send(HallHead.outroom,data)
    self:removeFromParent()    
	--退出现有俱乐部
end
--更新桌子信息
function ClubLayer:senduptable()
 --    local data = {}
 --    local clubinfo = public.getclubinfo(public.enterclubid)
	-- data.groupCode=clubinfo.groupCode
 --    st.send(HallHead.hqtalbe,data)
end
function ClubLayer:onExit()
    if self:getChildByName("Tableinfo") then
        EventMgr.removeEvent("Tableinfo")
    end
    EventMgr.removeEvent("ClubLayer")
	return self
end
--打开个人信息层
function ClubLayer:openPlayerInfo(userCode)
    --print("打开个人信息--->"..userCode)
    local layer=PlayerInfo:create(self,userCode)
    local name="PlayerInfo"
    layer:setName(name)
	self:add(layer)
end
--消息处理
function ClubLayer:message(code,data)
    --
    if code == HallHead.getroominfo or            --更新桌子上的玩家
         code == HallHead.Addtable or           --添加桌子
         code == HallHead.sctable or            --删除桌子
         code == HallHead.hqtalbe then            --初始化桌子列表
         self.TableLayer:message(code,data)
        return
    end 
    if code == HallHead.Upcoin then
        self.clubinfo.gameCoin=data.gameCoin
        self.clubinfo.manageCoin=data.manageCoin
        self.clubinfo.brokerageCoin=data.brokerageCoin
        --更新俱乐部里面的信息
        local clubinfo= public.getclubinfo(public.enterclubid)
        clubinfo.gameCoin=data.gameCoin
        clubinfo.manageCoin=data.manageCoin
        clubinfo.brokerageCoin=data.brokerageCoin
        
        self.Top:getChildByName("TT_3"):setString(ExternalFun.numberTrans(self.clubinfo.gameCoin))
    elseif code == HallHead.notice then
        --大厅公告
        if  data and data.notice then
            self.BroadcastLayer:setNoticeData({{content=data.notice}})
        end
    elseif HallHead.cxculbwj == code then
        if data.userCode == public.userCode then --更新自己分数
            self.Top:getChildByName("TT_3"):setString(ExternalFun.numberTrans(data.gameCoin))
		end
    elseif code == HallHead.tableinfo then
         local layer=Tableinfo:create(self,data)
        layer:setName("Tableinfo")
        local userList = self.TableLayer:GetUserList(data.roomCode)
        layer:ininUsers(userList)
        layer:inint(data)
        self:add(layer)
	end
end

function ClubLayer:uptableTitle(TableTitle)
    self.roomlist:removeAllChildren()
    local newbtnlist={}
    local newTitle=self.TableLayer:GetTableTitles()
    --防止该选中房间被清理
    if TableTitle then
        local iscunzai=false
        for k,v in pairs (newTitle) do
            if TableTitle ==v then
                iscunzai =true
                break
            end
        end
        if iscunzai == false then
            TableTitle=nil
            public.TableTitle=nil
        end
    end
     local btcallback = function (ref, type)
		if type == ccui.TouchEventType.ended then
			ExternalFun.playClickEffect()
			ref:setScale(1)
            if ref:getTag() == 0 then
                self.TableLayer:SeletTable(self.SelectGameType,nil)
            else 
                self.TableLayer:SeletTable(self.SelectGameType,ref:getName())
            end
            --self:senduptable()   
            --控制按钮是否可以点击
            for k,v in pairs(newbtnlist) do
                 v:setEnabled(true)
                 v:getChildByName("T"):enableOutline(cc.c4b(77,77,77,255),2)
            end
            ref:setEnabled(false)
            ref:getChildByName("T"):enableOutline(cc.c4b(159,19,0,255),2)
		elseif type == ccui.TouchEventType.began then
			ref:setScale(public.btscale)
		elseif type == ccui.TouchEventType.canceled then
			ref:setScale(1)
		end
	end
    if #newTitle ~= 0 then
        local item=self.tablebtn:clone()
        item:getChildByName("T"):setString("全部")
        item:setTag(0)
        item:setName("全部")
        if TableTitle then
            item:setEnabled(true)
            item:getChildByName("T"):enableOutline(cc.c4b(77,77,77,255),2)
        else
            item:setEnabled(false)
            item:getChildByName("T"):enableOutline(cc.c4b(159,19,0,255),2)
        end
        item:addTouchEventListener(btcallback)
        table.insert(newbtnlist,item)
        self.roomlist:pushBackCustomItem(item)
        local newname=newTitle
        local linname=nil
        for k,v in pairs(newTitle) do
            for a,b  in pairs(newname) do
                if v==b and k ~=a then
                    table.remove(newname,a)
                end
            end
        end

        for k,v in pairs(newname) do
            local item=self.tablebtn:clone();
            item:getChildByName("T"):setString(v)
            item:setTag(k)
            item:setName(v)
            if TableTitle and TableTitle ==v then
                item:setEnabled(false)
                item:getChildByName("T"):enableOutline(cc.c4b(159,19,0,255),2)
            else
                item:getChildByName("T"):enableOutline(cc.c4b(77,77,77,255),2)
            end
            item:addTouchEventListener(btcallback)
            self.roomlist:pushBackCustomItem(item)
            table.insert(newbtnlist,item)
        end
        
    end    
end

function ClubLayer:OpenHallScene()
    --if self.enter==true then
        --上
        local x,y=self.gamelist:getPosition()
        local width=self.gamelist:getContentSize().width
        ExternalFun.nodeMove(self.gamelist, cc.p(x-width,y),cc.p(x,y))
        local image=self.bj:getChildByName("Image_2")
        local x,y=image:getPosition()
        local width=image:getContentSize().width
        ExternalFun.nodeMove(image, cc.p(x-width,y),cc.p(x,y))
        --下
        local x,y=self.TableLayer:getPosition()
        local width=self.TableLayer:getContentSize().width
        ExternalFun.nodeMove(self.TableLayer, cc.p(x+width,y),cc.p(x,y))
        
        local x,y=self.roomlist:getPosition()
        local width=self.roomlist:getContentSize().width
        ExternalFun.nodeMove(self.roomlist, cc.p(x+width,y),cc.p(x,y))
    --end
end


return ClubLayer

