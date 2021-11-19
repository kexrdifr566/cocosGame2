
if not public then
	appdf.req(appdf.PUBLIC.."public")
end
if not HttpHead then	appdf.req(appdf.PUBLIC.."HttpHead")
end
if not HallHead then
	appdf.req(appdf.PUBLIC.."HallHead")
end
if not httpnect then
	appdf.req(appdf.NETCENT_SRC.."httpnect")
end
if not st then
	appdf.req(appdf.NETCENT_SRC.."st")
end
if not EventMgr then
	appdf.req(appdf.NETCENT_SRC.."EventMgr")
end

appdf.req(appdf.EXTERNAL_SRC.."Toast")

--scheduler = require("framework.scheduler")

local LogonScene = class("LogonScene", cc.load("mvc").ViewBase)

local LogonView = appdf.req(appdf.VIEW..".hallpage.LogonView")

--全局处理lua错误
cc.exports.g_LuaErrorHandle = function ()
	cc.exports.bHandlePopErrorMsg = true
	if isDebug() then
		return true
	else
		return false
	end
end

--加载配置
function LogonScene.onceExcute()
	local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
    -- local 
    --配置微信
	MultiPlatform:getInstance():thirdPartyConfig(public.ThirdParty.WECHAT, public.WeChat)

 --    --配置支付宝
	-- MultiPlatform:getInstance():thirdPartyConfig(public.ThirdParty.ALIPAY, public.AliPay)
 --    	--配置竣付通
	-- MultiPlatform:getInstance():thirdPartyConfig(public.ThirdParty.JFT, public.JFT)
    --配置分享
	MultiPlatform:getInstance():configSocial(public.SocialShare)
    	--配置高德
	-- MultiPlatform:getInstance():thirdPartyConfig(public.ThirdParty.AMAP, public.AMAP)

end

LogonScene.onceExcute()


-- 进入场景而且过渡动画结束时候触发。
function LogonScene:onEnterTransitionFinish()
	--背景音乐
	--ExternalFun.playPlazzBackgroudAudio()
    
    return self
end

-- 退出场景而且开始过渡动画时候触发。
function LogonScene:onExitTransitionStart()
	self._backLayer:unregisterScriptKeypadHandler()
	self._backLayer:setKeyboardEnabled(false)
    return self
end

-- 初始化界面
function LogonScene:onCreate()
	--print("LogonScene:onCreate")
	local this = self
	self:registerScriptHandler(function(eventType)
		if eventType == "enterTransitionFinish" then	-- 进入场景而且过渡动画结束时候触发。
			this:onEnterTransitionFinish()
		elseif eventType == "exitTransitionStart" then	-- 退出场景而且开始过渡动画时候触发。
			this:onExitTransitionStart()
		elseif eventType == "exit" then
		end
	end)


	self._backLayer = display.newLayer()
		:addTo(self)
	self._backLayer:setKeyboardEnabled(true)
	--返回键事件
	self._backLayer:registerScriptKeypadHandler(function(event)
		if event == "backClicked" then
			-- if this._popWait == nit then
			-- 	this:onButtonClickedEvent(LogonScene.BT_EXIT)
			-- end
		end
	end)

	self._topLayer = display.newLayer()
	:addTo(self)

	self._txtTips = cc.Label:createWithTTF("当前版本:"..appdf.BASE_C_RESVERSION, "fonts/round_body.ttf", 18)
	:setTextColor(cc.c4b(255,255,255,255))
	:setAnchorPoint(cc.p(1,0))
	-- :setVisible(false)
	:enableOutline(cc.c4b(0,0,0,255), 1)
	:move(public.WIDTH-40,80)
	:addTo(self._topLayer)
	--创建登录界面
	self._logonView = LogonView:create(self)
		:addTo(self._backLayer)
	--读取配置
	public.LoadData()
    -- local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
    -- local str=MultiPlatform:getInstance():groupCode()
    -- if str then
    --     self._txtTips:setString(str)
    -- else
    --     self._txtTips:setString("没有获取到渠道号")
    -- end
end
--按钮事件
function LogonScene:onButtonClickedEvent(tag,ref)
	-- --退出按钮
	-- if tag == LogonScene.BT_EXIT then
	-- 	if self:getChildByTag(LogonScene.DG_QUERYEXIT) then
	-- 		return
	-- 	end
	-- 	QueryExit:create("确认退出游戏吗？", function (ok)
	-- 		if ok == true then
	-- 			os.exit(0)
	-- 		end
	-- 	end)
	-- 	:setTag(LogonScene.DG_QUERYEXIT)
	-- 	:addTo(self)
	-- end
end

function LogonScene:enterClient()
	--ExternalFun.stopBackgroudMusic()
	--进入游戏列表
    --启动计时器
    --进入场景
    self:getApp():enterSceneEx(appdf.VIEW.."HallScene","FADE",0.2)
    --
end

return LogonScene