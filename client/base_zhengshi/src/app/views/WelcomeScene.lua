--[[
	欢迎界面
			2015_12_03 C.P
	功能：本地版本记录读取，如无记录，则解压原始大厅及附带游戏
--]]

local WelcomeScene = class("WelcomeScene", cc.load("mvc").ViewBase)

local ClientUpdate = appdf.req(appdf.BASE_SRC .. "app.controllers.ClientUpdate")
local QueryDialog = appdf.req("base.src.app.views.QueryDialog")
local PopWait = appdf.req("base.src.app.views.PopWait")

local CURRENT_INDEX = 1
local config_path = appdf.req("config_path")
local URL_REQUEST_LIST = config_path[appdf.isTest and 2 or 1]
CURRENT_INDEX = math.random( 1,2 )
local URL_REQUEST = URL_REQUEST_LIST[CURRENT_INDEX] or URL_REQUEST_LIST[1]
local WS_URL = config_path[appdf.isTest and 4 or 3]
local EXTRA_CMD_KEY = "extra_command_version"
local localver = cc.UserDefault:getInstance():getIntegerForKey(EXTRA_CMD_KEY, 0)

--全局toast函数(ios/android端调用)
cc.exports.g_NativeToast = function (msg)
	local runScene = cc.Director:getInstance():getRunningScene()
	if nil ~= runScene then
		showToastNoFade(runScene, msg, 2)
	end
end

--平台
local targetPlatform = cc.Application:getInstance():getTargetPlatform()

function WelcomeScene:onCreate()
	--初始化变量
    self._updateQueue = {}
    self._updateIndex = 1
	cc.SimpleAudioEngine:getInstance():stopMusic()

	-- 登录界面显示版本信息
	self.apptiplab = cc.Label:createWithSystemFont("", "Arial", 20)
	:setTextColor(cc.c3b(255,255,90))
	:setAnchorPoint(cc.p(0,0))
	:move(10,0)
	:addTo(self,10)

	--无版本信息或不对应 解压自带ZIP
	local sp_patch = "loginLayer_1.png"

	self:addBackground(sp_patch)
	--self:cachePublicRes()

	--提示文本
	self._txtTips = cc.Label:createWithSystemFont("", "Arial", 24)
		:setTextColor(cc.c3b(255,250,95))
		:setAnchorPoint(cc.p(0.5,0.5))
		:move(appdf.WIDTH/2,180)
		:addTo(self,10)

	--进度条
    self._loadingBg = cc.Sprite:create("loading_bg.png")
                        :setPosition(appdf.WIDTH / 2, 104)
                        :addTo(self)
    self._loadingBar = cc.Sprite:create("loading.png")
                        :setAnchorPoint(0, 0)
                        :setPosition(0, 0)
    self._loadingLayout = ccui.Layout:create()
                            :setClippingEnabled(true)
                            :setContentSize(self._loadingBar:getContentSize())
                            :setAnchorPoint(cc.p(0, 0.5))
                            :setPosition((appdf.WIDTH - self._loadingBar:getContentSize().width) / 2, 104)
                            :addChild(self._loadingBar)
                            :addTo(self)
    self._txtProgress = cc.Label:createWithSystemFont("100%", "Arial", 24)
		                    :setTextColor(cc.WHITE)
		                    :enableOutline(cc.c4b(0,0,0,255), 1)
		                    :move(appdf.WIDTH / 2, 104)
		                    :addTo(self)	

    --隐藏进度条
    self:showProgressBar(false)
	
	---读取本地版本渠道信息
	appdf.BASE_C_RESVERSION = self:getApp()._version:getResVersion()  or appdf.BASE_C_RESVERSION
	appdf.BASE_C_VERSION = self:getApp()._version:getHostVersion()  or appdf.BASE_C_VERSION
	appdf.channelId = checkint(self:getApp()._version:getChannelID()  or appdf.channelId)

	--self._popWait = PopWait:create(self):show(self,"请稍候！")
	--无版本信息或不对应 解压自带ZIP
    local nResversion = tonumber(self:getApp()._version:getResVersion())
	if nil == nResversion then
	 	self:unZipApp()
	else
	    --版本同步
	    self:httpNewVersion()
	end

	self.apptiplab:setString("当前版本:" .. localver.."."..appdf.BASE_C_RESVERSION.."."
		..appdf.channelId..(appdf.isTest and "-test" or ""))
end

function WelcomeScene:addBackground( sp_patch )
	--display.height=650
	if cc.FileUtils:getInstance():isFileExist(sp_patch) then
		local ba_sp = display.newSprite(sp_patch)
		ba_sp:setPosition(cc.p(display.width/2,display.height))
		ba_sp:setAnchorPoint(cc.p(0.5,1))
		local size = ba_sp:getContentSize()
		ba_sp:setScale(display.width/size.width)
		self.ba_sp = ba_sp
		self:addChild(ba_sp,0)
	end
end


--解压客户端
function WelcomeScene:unZipApp()

    if cc.PLATFORM_OS_WINDOWS == targetPlatform then
        self:httpNewVersion()
        return
    end

	if self._unZip == nil then --大厅解压
		-- 状态提示
		self._txtTips:setString("请稍候...")
		self._unZip = 0
		--解压
		local dst = device.writablePath
		unZipAsync(cc.FileUtils:getInstance():fullPathForFilename("client.zip"),dst,function(result)
				self:unZipApp()
			end)
	else 			-- 解压完成
		self._unZip = nil
		--更新本地版本号
		self:getApp()._version:setResVersion(appdf.BASE_C_RESVERSION)
        --设置自带游戏版本号（苹果因为要审核，所以必须要自带游戏，这里设置自带游戏默认版本号）

		--解压完了请求服务器配置
	    self:httpNewVersion()
	end
end

--更新客户端
function WelcomeScene:updateApp()

    QueryDialog:create("有新的版本，是否现在下载升级？              需要先删除原安装包再下载安装。",function(bConfirm)
	        if bConfirm == true then
				--更新前先清理所有缓存
				cc.FileUtils:getInstance():removeDirectory(cc.FileUtils:getInstance():getWritablePath())
				cc.Application:getInstance():openURL(self:getApp()._serverConfig.pack_downloadUrl)
		    else
			    os.exit(0)
	        end
	    end)
	    :addTo(self)
end

--更新资源
function WelcomeScene:updateRes()
	local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if #self._updateQueue == 0  or cc.PLATFORM_OS_WINDOWS == targetPlatform then 
        --进入客户端
        self:enterClient()
    else
        --下载当前项
        local config = self._updateQueue[self._updateIndex]
        self._update = ClientUpdate:create(config.newfileurl, config.dst, config.src, config.downurl)
		self._update:upDateClient(self)
    end
end

--显示进度条
function WelcomeScene:updateProgressBar(percent)
    
    if self._loadingBar:isVisible() == false then
        self:showProgressBar(true)
    end
    
    local contentSize = self._loadingBar:getContentSize()

    self._loadingLayout:setContentSize(contentSize.width * percent / 100, contentSize.height)
    self._txtProgress:setString(math.ceil(percent) .. "%")
end

--隐藏进度条
function WelcomeScene:showProgressBar(isShow)
    
    self._loadingBg:setVisible(isShow)
    self._loadingBar:setVisible(isShow)
    self._loadingLayout:setVisible(isShow)
    self._txtProgress:setVisible(isShow)
end

--进入客户端
function WelcomeScene:enterClient()

	--重置大厅与游戏
	for k ,v in pairs(package.loaded) do
		if k ~= nil then 
			if type(k) == "string" then
				if string.find(k,"plaza.") ~= nil or string.find(k,"game.") ~= nil then
					package.loaded[k] = nil
				end
			end
		end
	end	
	
	--场景切换
    self:runAction(cc.Sequence:create(
			--cc.DelayTime:create(1),
			cc.CallFunc:create(function()
				self:getApp():enterSceneEx(appdf.CLIENT_SRC.."view.LogonScene",nil,0)
			end)
	))	
end

--------------------------------------------------------------------------------------------------------------------
-- ClientUpdate 回调

--下载开始
function WelcomeScene:onUpdateBegin(count)
    
    if count == 0 then 
        return
    end
    local config = self._updateQueue[self._updateIndex]
    if config.isBase then
        --需要重启客户端s
        self._needRestart = true
        --显示状态
        self._txtTips:setString("更新主程序资源...")
    elseif config.isClient then
        --显示状态
        self._txtTips:setString("更新大厅资源...")
    end
end

--下载进度
function WelcomeScene:onUpdateProgress(sub, msg, mainpersent)
    --更新进度条
    self:updateProgressBar(mainpersent)
end

--下载结果
function WelcomeScene:onUpdateResult(result,msg,updateSize)
    if result == true then
        local config = self._updateQueue[self._updateIndex]
		if config.isBase then
			if updateSize ~= nil and updateSize == 0 then
				self._needRestart = false
			end
        end

        --下载下一项
        if self._updateIndex < #self._updateQueue then
            self._updateIndex = self._updateIndex + 1
            self:updateRes()
        else --下载完成
            --隐藏进度条
            self:showProgressBar(false)
			--更新本地大厅版本
			cc.UserDefault:getInstance():setIntegerForKey(EXTRA_CMD_KEY, self._newResVersion)
			self:getApp()._version:setResVersion(self._newResVersion)
            if self._needRestart then
                --重启客户端
                QueryDialog:create("本次更新需要重启才能生效，请重新启动客户端",function(bConfirm)
			        os.exit(0)
	            end, nil, QueryDialog.QUERY_SURE)
	            :addTo(self)
            else
                --进入登录界面
                self:enterClient()
            end
        end
    else

    	--重试询问
		QueryDialog:create("("..self._update:getUpdateFileName()..")".. msg.."\n是否重试？",function(bReTry)
				if bReTry == true then
					self:updateRes()
				else
					os.exit(0)
				end
			end)
			:addTo(self)
    end
end

--------------------------------------------------------------------------------------------------------------------
--请求服务器配置
function WelcomeScene:httpNewVersion()

	self._txtTips:setString("获取服务器信息...")
	local this = self
	--数据解析
	local vcallback = function(datatable)
	 	local succeed = false
	 	local msg = "网络获取失败！"

	 	if type(datatable) == "table" then
            local databuffer = datatable["data"]
            if databuffer then
            	succeed=true
	 		    	--dump(databuffer,"读取网络配置")
					this:getApp()._serverConfig = databuffer
					--设置网关
                    appdf.LOGONSERVER = URL_REQUEST
					appdf.HTTP_URL = URL_REQUEST
					appdf.WS_URL = WS_URL
					this:initClientUpdate(databuffer["zyVersion"])
            end
	 	end
        if succeed then --成功
			this:httpNewVersionCallBack(true)
        else  --失败
			--提示重试
			if not this.checkip then  --域名切换成ip 重新请求一次
				this.checkip = true
				local url_req = appdf.replaceHostbyIP(URL_REQUEST)
				if url_req then
					--URL_REQUEST = url_req
					this:httpNewVersion()
					return
				end
			end
            this:httpNewVersionCallBack(false,"获取版本信息失败")
        end
	end

    local typeID = (device.platform == "ios" and 2 or platform == "windows" and 3 or 1) --1.ios 2.android
    local url=URL_REQUEST..string.format("/gameCenter/check/getVersion?appType=%d",typeID)
    print("获取版本号"..url)
	appdf.onHttpJsionTable(url,"get","",vcallback)
end

--初始化大厅更新
function WelcomeScene:initClientUpdate(nNewV)
	local nCurV = tonumber(self:getApp()._version:getResVersion()) or appdf.BASE_C_RESVERSION
	nNewV = tonumber(nNewV)
	self._newResVersion = nNewV
	if nNewV and nCurV then
		if nNewV > nCurV then
             --更新目录
             local updatefolders = { "base", "client" }
             for i = 1, #updatefolders do
                local folder = updatefolders[i]
                local updateConfig = {}

                updateConfig.isBase = (folder == "base")
				updateConfig.isClient = (folder == "client")
                --dump(self:getApp()._serverConfig,"fff")
				local cfg = self:getApp()._serverConfig.appurl
				local updateurl = cfg
	 		    updateConfig.newfileurl = updateurl.."/" .. folder .. "/res/filemd5List.json"
			    updateConfig.downurl = updateurl .. "/"
                if cc.PLATFORM_OS_WINDOWS == targetPlatform then
                    updateConfig.dst = device.writablePath .. "download/"
                    updateConfig.src = device.writablePath .. "download/" .. folder .. "/res/filemd5List.json"
                else
                    updateConfig.dst = device.writablePath
			        updateConfig.src = device.writablePath .. folder .. "/res/filemd5List.json"
                end

	 		    table.insert(self._updateQueue, updateConfig)
             end
		end
	end		
end


--服务器版本返回
function WelcomeScene:httpNewVersionCallBack(result,notRetry)
    --获取失败
    if not result then
		self.checkip = false
		CURRENT_INDEX = CURRENT_INDEX + 1
		URL_REQUEST = URL_REQUEST_LIST[CURRENT_INDEX] or URL_REQUEST
		if CURRENT_INDEX > #URL_REQUEST_LIST then
			CURRENT_INDEX = 1
		elseif URL_REQUEST and not notRetry then
			self:httpNewVersion()
			return
		end
		self._txtTips:setString("")
		self:showRequestFailed()
    else
		self._txtTips:setString("OK")
		--判断是否需要重新下载完整App
		local cfg = self:getApp()._serverConfig
		if tonumber(cfg.version) and tonumber(cfg.version) > appdf.BASE_C_VERSION  and device.platform ~= "windows" then --
			--更新客户端
			self:updateApp()
		else
			--更新资源
			self:updateRes()
		end
    end
end

--请求失败
function WelcomeScene:showRequestFailed( ... )
	local msg = "正在连接服务器，请稍后！"
	QueryDialog:create(msg,function(bReTry,tag)
		if bReTry == true then
			self:httpNewVersion()
		elseif tag == QueryDialog.BT_DOWNLOAD then
			local url = cc.UserDefault:getInstance():getStringForKey("weburl",office_url)
			cc.Application:getInstance():openURL(url)
		else
			os.exit(0)
		end
	end,nil,nil,true)
	:setCanTouchOutside(false)
	:addTo(self,10)
end

return WelcomeScene
