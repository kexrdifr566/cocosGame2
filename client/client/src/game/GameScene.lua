if not gst then
	appdf.req(appdf.NETCENT_SRC.."gst")
end
if not GameHead then
	appdf.req(appdf.GAME_SRC.."GameHead")
end

local WatchLayer=appdf.req(appdf.GAME_SRC.."public.WatchLayer")
local BagLayer =appdf.req(appdf.GAME_SRC.."brpublic.BagLayer")				--成员页面
local GameHuiGuLayer=appdf.req(appdf.GAME_SRC.."public.GameHuiGuLayer")
local LoadAtlas=appdf.req(appdf.GAME_SRC.."LoadAtlas")
local GameScene = class("GameScene", cc.load("mvc").ViewBase)
-- 进入场景而且过渡动画结束时候触发。
function GameScene:onEnterTransitionFinish()
	
	ExternalFun.playgameBackgroudAudio()    
	--print("GameScene进入场景而且过渡动画结束时候触发。")
    return self
end

-- 退出场景而且开始过渡动画时候触发。
function GameScene:onExitTransitionStart()
    
	--print("GameScene退出场景而且开始过渡动画时候触发。。")
    return self
end


function GameScene:onExit()
	ExternalFun.stopBackgroudMusic()
    LoadAtlas.unloading() 
    removebackgroundcallback()    
	--关闭现在连接
    gst.netclose()
	return self
end

-- 初始化界面
function GameScene:onCreate()
    --print("检查10")
    function Callback(code,data)
        if self.message then
            self:message(code,data)
        end
    end
    --初始化信息
    self:playerinint()
    
    showWait(10)
    gst.inint()
    gst.setCallback(Callback)
	--print("已经进入游戏场景")
	self:registerScriptHandler(function(eventType)
		if eventType == "enterTransitionFinish" then	-- 进入场景而且过渡动画结束时候触发。
			self:onEnterTransitionFinish()
		elseif eventType == "exitTransitionStart" then	-- 退出场景而且开始过渡动画时候触发。
			self:onExitTransitionStart()
		elseif eventType == "exit" then
			self:onExit()
		end
	end)

	setbackgroundcallback(function (bEnter)
		if type(self.onBackgroundCallBack) == "function" then
			self:onBackgroundCallBack(bEnter)
		end
	end)
    
	showWait(10)
    --添加资源
    -- cc.SpriteFrameCache:getInstance():addSpriteFrames("Game/Cards.plist")
    --     ---添加资源
    -- cc.SpriteFrameCache:getInstance():addSpriteFrames("Game/Public.plist")
    --加载图集
    LoadAtlas.Loading()
	--延迟发送进入游戏
	self.tableinfo=public.gettableinfo(public.roomCode)
	--print("进入的游戏为====》"..public.entergame)
	if public.entergame == public.game.dezhou then                  --德州游戏
		if not DzHead then
			appdf.req(appdf.GAME_SRC.."DzHead")
		end
        self.beginmessage=DzHead.bgame 
		local dzLayer=appdf.req(appdf.GAME_SRC.."dz.dzLayer")
		self.gameLayer=dzLayer:create(self)
	elseif public.entergame == public.game.cow then                 --牛牛游戏
		if not CowHead then
			appdf.req(appdf.GAME_SRC.."CowHead")
		end
         self.beginmessage=CowHead.bgame 
		local cowLayer=appdf.req(appdf.GAME_SRC.."cow.cowLayer")
		self.gameLayer=cowLayer:create(self)
    elseif public.entergame == public.game.dcow then                 --牛牛游戏
		if not DcowHead then
			appdf.req(appdf.GAME_SRC.."DcowHead")
		end
         self.beginmessage=DcowHead.bgame 
		local cowLayer=appdf.req(appdf.GAME_SRC.."cow.DcowLayer")
		self.gameLayer=cowLayer:create(self)
    elseif public.entergame==public.game.sangong then               --三公游戏
        if not SgHead then
			appdf.req(appdf.GAME_SRC.."SgHead")
		end
         self.beginmessage=SgHead.bgame 
		local sgLayer=appdf.req(appdf.GAME_SRC.."sg.sgLayer")
		self.gameLayer=sgLayer:create(self)
    elseif public.entergame==public.game.sangongbi then               --三公比金花游戏
        if not SgbjhHead then
			appdf.req(appdf.GAME_SRC.."SgbjhHead")
		end
         self.beginmessage=SgbjhHead.bgame 
		local sgbjhLayer=appdf.req(appdf.GAME_SRC.."sg.sgbjhLayer")
		self.gameLayer=sgbjhLayer:create(self)
    elseif public.entergame == public.brgame.sangong then           --百人三公
        self.brgame=true                                            --百人房间标识
        if not BaiRenHead then
			appdf.req(appdf.GAME_SRC.."BaiRenHead")
		end
		local brsgLayer=appdf.req(appdf.GAME_SRC.."brsg.brsgLayer")
		self.gameLayer=brsgLayer:create(self)
    elseif public.entergame == public.brgame.cow    then               --百人牛牛
        self.brgame=true                                            --百人房间标识
        if not BaiRenHead then
			appdf.req(appdf.GAME_SRC.."BaiRenHead")
		end
		local brcowLayer=appdf.req(appdf.GAME_SRC.."brcow.brcowLayer")
		self.gameLayer=brcowLayer:create(self)
    elseif public.entergame == public.brgame.longhu   then        --龙虎斗
        self.brgame=true                                            --百人房间标识
        if not BaiRenHead then
			appdf.req(appdf.GAME_SRC.."BaiRenHead")
		end
		local brlhdLayer=appdf.req(appdf.GAME_SRC.."brlhd.brlhdLayer")
		self.gameLayer=brlhdLayer:create(self)
    elseif public.entergame == public.brgame.shenshou   then        --斗神兽
        self.brgame=true                                            --百人房间标识
        if not BaiRenHead then
			appdf.req(appdf.GAME_SRC.."BaiRenHead")
		end
		local brdssLayer=appdf.req(appdf.GAME_SRC.."brdss.brdssLayer")
		self.gameLayer=brdssLayer:create(self)
    elseif public.entergame == public.brgame.baoma   then        --斗神兽
        self.brgame=true                                            --百人房间标识
        if not BaiRenHead then
			appdf.req(appdf.GAME_SRC.."BaiRenHead")
		end
		local brbcbmLayer=appdf.req(appdf.GAME_SRC.."brbcbm.brbcbmLayer")
		self.gameLayer=brbcbmLayer:create(self)
	end

	if self.gameLayer then
		self:add(self.gameLayer)
	end
    --print("检查11")
end
function GameScene:getTableinfo()
	--桌子等信息
	return self.tableinfo
end
function GameScene:getplayercont()
	--桌子等信息
	return self.tableinfo.limitUserNum
end
function GameScene:getTableminCoin()
	--获取桌子基础分
	return self.tableinfo.minCoin
end
--初始化信息
function GameScene:playerinint()
	self.users={} --记录桌子上面的所有玩家
    self.Gzusers={} --观战已准备玩家数据
    self.Gzchiar=0
  	self.zindex = nil --记录自己的座位号
	self.gameLayer = nil
    self.brgame=false
    self.beginmessage=nil
end
--消息处理
function GameScene:message(code,data)
    if code == -1 then
        self.users={}
        return
    end
    if public.gamebacktime >=30 then --长时间从后台不切过来。则不走这条路
        return
    end
   --dump(data,"服务端发来的消息"..code)
    if code == GameHead.Userlist then
       --dump(data,"玩家列表操作"..code)
        --玩家列表操作
        self:Userlist(data.zt,data.users,data.userCode,data.online)
         --观战种玩家列表操作
        if data.users_zt then
            self:GzUserlist(data.zt,data.users_zt)
        end
        return
    elseif code == GameHead.GzUserlist then
        --观战种玩家列表操作
        self:GzUserlist(data.zt,data.users)
        return
    elseif code == HallHead.tuichu then
        QueryExit("您的账号在别的地方登陆了,请核实!", function (ok)
                self:qiehuan()
         end,true)
        return
    elseif code == GameHead.ingame  then --其他玩家进入或者自己进入游戏。则保存所有玩家
        --自动准备
         --dump(data,"所有数据"..GameHead.ingame)
        if public.regame then 
            public.regame=false
            gst.send(GameHead.zbgame,nil)  
        end
    elseif code == self.beginmessage then
        --dump(data,"开始数据"..code)
        self.Gzusers={}
        self:Userlist("all",data.upusers)
	elseif code == GameHead.close then
		public.initgame()
        public.entergame=0
        public.setGameTalbeinfo()
        display.removeUnusedSpriteFrames()
		self:getApp():enterSceneEx(appdf.VIEW.."HallScene","FADE",0.2)
		return
    --打开观战层
    elseif code == GameHead.swatchplayer then
        local watchlayer=self.gameLayer:getChildByName("watch") 
        if watchlayer and watchlayer.inint then
            watchlayer:inint(data)
        end
        return
     --打开观战层
    elseif code == GameHead.huigu then
        local layer =self.gameLayer:getChildByName("HuiGuLayer")
        if layer ==nil then
            layer =GameHuiGuLayer:create(self)
            layer:setName("HuiGuLayer")
            self.gameLayer:add(layer) 
        end
        if layer and layer.inint then
            layer:inint(data)
            layer:setVisible(true)
        end
        return
    elseif code == GameHead.continue then
        
        public.regame=true
        ExternalFun.pauseMusic()
        gst.netclose()
        
  
        --设置进入桌子信息
        if data.port ==nil or data.host == nil then
            showToast("抢座失败",1)
            --performWithDelay(self,function ()
                self:closeGame(true)
        --end,1.2)
            return
        end
              --清理断线重连数据
        public.setGameTalbeinfo(data.roomInfo)
    	public.entergame 	=  data.roomType
		public.roomCode  	=  data.roomCode
		public.port         =  data.port
		public.host         =  data.host
    	--self:getApp():enterSceneEx(appdf.GAME_SRC.."GameScene","FADE",0.2)
        
        if self.gameLayer and self.gameLayer.bj  then
            local endlayer=self.gameLayer.bj:getChildByName("GameEndLayer")
            if  endlayer then
                endlayer:removeFromParent()
            end
        end
        
        showWait(10)
        gst.netclose()
        gst.inint()
        return
    --百人场钱包更新金币用
    elseif code == GameHead.Upcoin then
        if self.gameLayer and self.gameLayer.updateMyScore then
            self.gameLayer:updateMyScore(data.gameCoin)
        end
    elseif code == HallHead.cjcowwf then
        if  self.gameLayer and self.gameLayer.top and self.gameLayer.top:getChildByName("WanfaLayer") then
            self.gameLayer.top:getChildByName("WanfaLayer"):updatecow(data)
        end
        return
	end
    
	if self.gameLayer and self.gameLayer.message then
		self.gameLayer:message(code,data)
	end
end

--切换后台
function GameScene:onBackgroundCallBack(bEnter)
    if bEnter == true then
        
        public.gamebacktime=os.time()-self.isbacktime
        print("self.tickder===>"..public.gamebacktime)
        if public.gamebacktime >=30 then
            if self.gameLayer and self.gameLayer.reGame then
                self.gameLayer:reGame(true) ---初始化界面
            end
            showWait(10)
            gst.netclose()
            gst.inint()
        else
            gst.reconnet()
        end            
    else
        gst.Intobackground()
        self.isbacktime=os.time()
    end
 
end
function GameScene:closeGame(bl)
    --如果是斗牛另做处理
    if public.entergame ==public.game.dcow then
        local data={} 
        data.roomCode=public.roomCode
        gst.send(GameHead.close,data)
        return
    end
    
	if bl then
		public.initgame()
		public.entergame=0
        public.setGameTalbeinfo()
        local data={} 
        data.roomCode=public.roomCode
        gst.send(GameHead.close,data)
    	self:getApp():enterSceneEx(appdf.VIEW.."HallScene","FADE",0.2)
    	return
	end
    
    local netstate=gst.gamecoon[#gst.gamecoon]:getReadyState()
    
    if netstate ==1 then
        
        QueryExit("确认退出游戏吗？", function (ok)
            if ok == true then
                public.initgame()
                public.entergame=0
                public.setGameTalbeinfo()
                local data={} 
                data.roomCode=public.roomCode
                gst.send(GameHead.close,data)
                self:getApp():enterSceneEx(appdf.VIEW.."HallScene","FADE",0.2)
                return
            end
        end,true)
    else
        self:closeGame(true)
    end
end
function GameScene:Open()
    if  self.gameLayer then
        local layer =WatchLayer:create(self)
            :setName("watch")
        self.gameLayer:add(layer)
    end
end
function GameScene:OpenBagLayer()
     if  self.gameLayer then
         local clubinfo= public.getclubinfo(public.enterclubid)
        local layer =BagLayer:create(self,clubinfo)
        self.gameLayer:add(layer)
    end
end
function GameScene:ReGame()
    print("发送继续游戏")
    self.tableinfo=public.gettableinfo(public.roomCode)
    local sdata={}
	sdata.roomCode=self.tableinfo.roomCode
    sdata.roomType=self.tableinfo.roomType
    gst.send(GameHead.continue,sdata)
end
function GameScene:GzUserlist(zt,users)
    if zt =="c" then                            --添加玩家列表
        if #users ~= 0 then
             --更新玩家列表
            for k,v in pairs(users) do
                table.insert(self.Gzusers,v)
            end
            --更新整个玩家数据
            for k,v in pairs(self.Gzusers) do
                local chairID=self:getotherchair(math.abs(v.chair+self.Gzchiar)) 
                
                if self.gameLayer and self.gameLayer.player and self.gameLayer.player.inintplayer and v.userCode ~= public.userCode then 
                    self.gameLayer.player:inintplayer(chairID,v)
                end
            end
        end   
    elseif zt == "all" then
        self.Gzusers={}
        for k,v in pairs(users) do
            table.insert(self.Gzusers,v)
        end
        --更新整个玩家数据
        for k,v in pairs(self.Gzusers) do
            local chairID=self:getotherchair(math.abs(v.chair+self.Gzchiar))
            if self.gameLayer and self.gameLayer.player and self.gameLayer.player.inintplayer and v.userCode ~= public.userCode then --观战人为自己则不显示
                self.gameLayer.player:inintplayer(chairID,v)
            end
         end
    elseif zt == "d" then                       --删除玩家
        for a,b in pairs(users) do
             for k,v in pairs(self.Gzusers) do
                if v.userCode ==b.userCode then
                    local chairID=self:getotherchair(math.abs(v.chair+self.Gzchiar))
                    --print("删除玩家"..chairID.." Usercode= "..b.." ")
                    if self.gameLayer and self.gameLayer.player and self.gameLayer.player.deplayer and chairID >0 then
                        self.gameLayer.player:deplayer(chairID)
                    end
                    table.remove(self.Gzusers,k)
                end
            end
        end
    end
    --dump(self.users,"新的玩家列表")
end
function GameScene:Userlist(zt,users,Usercode,online)
    if zt =="c" then                            --添加玩家列表
        if #users ~= 0 then
             --更新玩家列表
            for k,v in pairs(users) do
                table.insert(self.users,v)
            end
           self.zindex = nil
            --更新自己的位置
            local isme=false
            for k,v in pairs(self.users) do
                if v.userCode == public.userCode then
                    self.zindex = v.chair
                    isme = true
                end
            end
            if isme~= false then
                 --只要玩家列表有变动就全部初始化
                if self.gameLayer and self.gameLayer.reGame then
                    self.gameLayer:reGame(true) ---初始化界面
                end
            end
            --更新整个玩家数据
            for k,v in pairs(self.users) do
                local chairID=self:getotherchair(v.chair)
                if self.gameLayer and self.gameLayer.player and self.gameLayer.player.inintplayer and chairID >0 then
                    self.gameLayer.player:inintplayer(chairID,v)
                end
            end
        end   
    elseif zt == "u" then                       --更改玩家状态（只是在线于不在线）
        for k,v in pairs(self.users) do
            if v.userCode ==Usercode then               --是否在线
                v.online=online
                local chairID=self:getchairindex(Usercode)
                if self.gameLayer and self.gameLayer.player and self.gameLayer.player.uponline and chairID >0 then
                    self.gameLayer.player:uponline(chairID,online)
                end
            end
        end
    elseif zt == "all" then
        self.users={}
        self.zindex = nil
        for k,v in pairs(users) do
            table.insert(self.users,v)
            if v.userCode == public.userCode then
                self.zindex = v.chair
            end
        end
         --只要玩家列表有变动就全部初始化
        if self.gameLayer and self.gameLayer.reGame then
            self.gameLayer:reGame(true) ---初始化界面
        end
        --更新整个玩家数据
        for k,v in pairs(self.users) do
            local chairID=self:getotherchair(v.chair)
            if self.gameLayer and self.gameLayer.player and self.gameLayer.player.inintplayer and chairID >0 then
                self.gameLayer.player:inintplayer(chairID,v)
            end
         end
    elseif zt == "d" then                       --删除玩家
        for a,b in pairs(users) do
             for k,v in pairs(self.users) do
                if v.userCode ==b.userCode then
                                       
                    local chairID=self:getchairindex(v.userCode)
                    --print("删除玩家"..chairID.." Usercode= "..b.." ")
                    if self.gameLayer and self.gameLayer.player and self.gameLayer.player.deplayer and chairID >0 then
                        self.gameLayer.player:deplayer(chairID)
                    end
                    table.remove(self.users,k)
                    ---如果是自己更新一下标识
                    if v.userCode == public.userCode then
                        self.zindex = nil
                    end
                end
            end
        end
    end
    --dump(self.users,"新的玩家列表")
end
function GameScene:UpusersCoin(userCode,Coin)
    for k,v in pairs(self.users) do
        if v.userCode ==userCode then
            v.gamecoin=Coin
        end
    end
end
function GameScene:getAllUsers()
	return self.users
end
--获取自己的座位号
function  GameScene:getMechair()
	return self.zindex
end
--获取单独玩家信息
function GameScene:getchairinfo(userCode)
	local userinfo = nil
	for k,v in pairs(self.users) do
		if userCode == v.userCode then
			userinfo=v
		end
	end
    return userinfo

end
--获取知道昵称获取单独玩家椅子
function GameScene:getchairindex(userCode)
	local viewid = -1
	for k,v in pairs(self.users) do
		if userCode == v.userCode then
			viewid=self:getotherchair(v.chair)
		end
	end
    return viewid

end
--获取椅子
function GameScene:getotherchair(chair)
    if chair ==-1 then
       return -1 
    end
	local viewid = nil
	if not self.zindex then
		viewid = chair+1
	else
    	viewid = chair - self.zindex +1
    	if viewid <= 0 then
        	viewid=viewid + self.tableinfo.limitUserNum
		end
	end
    return viewid
end
--获取该椅子商玩家的性别
function GameScene:getchairSex(chair)
    for k,v in pairs(self.users) do
		if chair == v.chair then
			return v.sexValue
		end
	end
    return "0"
end
--按照userCode来取性别
function GameScene:getuserCodeSex(Code)
    for k,v in pairs(self.users) do
		if Code == v.userCode then
			return v.sexValue
		end
	end
    return "0"
end
function GameScene:qiehuan()
	public.initgame()
    public.shouci=true
    cc.UserDefault:getInstance():setIntegerForKey("login_type",0)
    self:getApp():enterSceneEx(appdf.CLIENT_SRC.."view.LogonScene",nil,0.2)
end
return GameScene
