--
-- Author: zhong
-- Date: 2016-07-25 10:19:18
--
--游戏头像
local HeadSprite = class("HeadSprite", cc.Sprite)
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
--自定义头像存储规则
-- path/face/userid/custom_+customid.ry
--头像缓存规则
-- uid_custom_cusomid

local FACEDOWNLOAD_LISTENER = "face_notify_down"
local FACERESIZE_LISTENER = "face_resize_notify"
local URLREQUEST_LISTENER = "face_urlhttp_request"
local SYS_HEADSIZE = 132
--全局通知函数
cc.exports.g_FaceDownloadListener = function (ncode, msg, filename)
	local event = cc.EventCustom:new(FACEDOWNLOAD_LISTENER)
	event.code = ncode
	event.msg = msg
	event.filename = filename

	cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
end

cc.exports.g_FaceResizeListener = function(oldpath, newpath)
	local event = cc.EventCustom:new(FACERESIZE_LISTENER)
	event.oldpath = oldpath
	event.newpath = newpath

	cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
end
function HeadSprite:ctor(Usercode,headurl, headSize)
   
	self.m_spRender = nil
	self.m_downListener = nil
	self.m_resizeListener = nil
	self.m_httpUrlListener = nil
    -- self.m_onBackgroundEnterListener = cc.EventListenerCustom:create(appdf.CLIENT_NOTIFY,handler(self, self.onClientNotify))
    -- cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.m_onBackgroundEnterListener, self)
    --注册事件
	local function onEvent( event )
		if event == "exit" then
			self:onExit()
		elseif event == "enterTransitionFinish" then
			self:onEnterTransitionFinish()
        end
	end
	self:registerScriptHandler(onEvent)
    self:createHead(Usercode,headurl, headSize)
    
end
function HeadSprite:onClientNotify( event )
	local what = event.what
    local msg = event.msg
    if what == public.CLIENT_MSG_BACKGROUND_ENTER then
    	print("HeadSprite:onClientNotify 后台切换")
    	--self:updateHead( self.m_useritem )
    end
end
function HeadSprite:createHead(Usercode,headurl, headSize)
	--local sp = HeadSprite.new()
	self.m_headSize = SYS_HEADSIZE

	--创建裁剪
	local strClip = "Public/head.png"
	-- if nil ~= clippingfile then
	-- 	strClip = clippingfile
	-- end
	local clipSp  = cc.Sprite:create(strClip)

	self.m_spRender =cc.Sprite:create("Public/headd.png")
    self:getHeadSprite(Usercode,headurl)
	--if nil ~= clipSp then
		--裁剪
		local clip = cc.ClippingNode:create()
		clip:setStencil(clipSp)
		clip:setAlphaThreshold(0.05)
		clip:addChild(self.m_spRender)
		local selfSize = self:getContentSize()
		clip:setPosition(cc.p(selfSize.width * 0.5, selfSize.height * 0.5))
		self:addChild(clip)
        self:setScale(headSize/SYS_HEADSIZE)
		return self
	-- end
	-- return nil
end
function HeadSprite:createClipHead(Usercode,headurl, headSize)
	local sp = HeadSprite.new()
	sp.m_headSize = SYS_HEADSIZE

	--创建裁剪
	local strClip = "Public/head.png"
	-- if nil ~= clippingfile then
	-- 	strClip = clippingfile
	-- end
	local clipSp  = cc.Sprite:create(strClip)

	self.m_spRender =cc.Sprite:create("Public/headd.png")
    self:getHeadSprite(Usercode,headurl)
	--if nil ~= clipSp then
		--裁剪
		local clip = cc.ClippingNode:create()
		clip:setStencil(clipSp)
		clip:setAlphaThreshold(0.05)
		clip:addChild(self.m_spRender)
		local selfSize = sp:getContentSize()
		clip:setPosition(cc.p(selfSize.width * 0.5, selfSize.height * 0.5))
		sp:addChild(clip)
        sp:setScale(headSize/SYS_HEADSIZE)
		return sp
	-- end
	-- return nil
end
function HeadSprite:onExit( )
	if nil ~= self.listener then
		local eventDispatcher = self:getEventDispatcher()
		eventDispatcher:removeEventListener(self.listener)
		self.listener = nil
	end

	if nil ~= self.m_downListener then
		self:getEventDispatcher():removeEventListener(self.m_downListener)
		self.m_downListener = nil
	end

	if nil ~= self.m_resizeListener then
		self:getEventDispatcher():removeEventListener(self.m_resizeListener)
		self.m_resizeListener = nil
	end

	if nil ~= self.m_httpUrlListener then
		self:getEventDispatcher():removeEventListener(self.m_httpUrlListener)
		self.m_httpUrlListener = nil
	end

	-- if nil ~= self.m_onBackgroundEnterListener then
	-- 	self:getEventDispatcher():removeEventListener(self.m_onBackgroundEnterListener)
	-- 	self.m_httpUrlListener = nil
	-- end

end
function HeadSprite:getHeadSprite(Usercode, headurl)
    local this = self
    if  nil ~= headurl and string.len(headurl) > 0 then
        local filename = string.gsub(headurl, "[/.:+]", "") .. ".png"
        local framename = filename
		local path = device.writablePath .. "face/" .. Usercode
		local filepath = path .. "/" .. filename
		local bHave = self:haveCacheOrLocalFile(framename, filepath, false) 
		if bHave == false then
            --网络请求
			local url = headurl
			self:downloadFace(url, path, filename, function(downloadfile)
				local selffile = filename
               -- print(filepath)
				if selffile == downloadfile then
                    if  this.updateHeadByFrame then
                        this:updateHeadByFrame(filepath)
					end
            	end
			end)	
        end
    end
end
function HeadSprite:haveCacheOrLocalFile(framename, filepath)
	--判断是否有缓存
    --local this = self
    local path = filepath
	if cc.FileUtils:getInstance():isFileExist(path) then
        self:updateHeadByFrame(filepath)
        return true
    end
	return false
end
function HeadSprite:updateHeadByFrame(filepath)
    --print(filepath)
    self.m_spRender:setTexture(filepath)
end
--下载头像
function HeadSprite:downloadFace(url, path, filename, onDownLoadSuccess)
	local downloader = CurlAsset:createDownloader("g_FaceDownloadListener",url)			
	if false == cc.FileUtils:getInstance():isDirectoryExist(path) then
		cc.FileUtils:getInstance():createDirectory(path)
	end			

	local function eventCustomListener(event)
        if nil ~= event.filename and 0 == event.code then
        	if nil ~= onDownLoadSuccess 
        		and type(onDownLoadSuccess) == "function" 
        		and nil ~= event.filename 
        		and type(event.filename) == "string" then
        		onDownLoadSuccess(event.filename)
                --self.m_spRender:setTexture(event.filename)
        	end        	
        end
	end
	if nil ~= self.m_downListener then
		cc.Director:getInstance():getEventDispatcher():removeEventListener(self.m_downListener)
		self.m_downListener = nil
	end
	self.m_downListener = cc.EventListenerCustom:create(FACEDOWNLOAD_LISTENER,eventCustomListener)
	cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(self.m_downListener, 1)
	downloader:downloadFile(path, filename)
end
return HeadSprite