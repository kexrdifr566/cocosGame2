--[[
	询问对话框
		2016_04_27 C.P
	功能：确定/取消 对话框 与用户交互
]]

local QueryDialog = class("QueryDialog", function(msg,callback)
		local queryDialog = display.newLayer()
    return queryDialog
end)

--默认字体大小
QueryDialog.DEF_TEXT_SIZE 	= 32

--UI标识
QueryDialog.DG_QUERY_EXIT 	=  2
QueryDialog.BT_CANCEL		=  0
QueryDialog.BT_CONFIRM		=  1
QueryDialog.BT_GETFREE   = 3
QueryDialog.BT_ZHUCE  = 4

QueryDialog.BT_DOWNLOAD		=  5

-- 对话框类型
QueryDialog.QUERY_SURE 			= 1
QueryDialog.QUERY_SURE_CANCEL 	= 2

-- 进入场景而且过渡动画结束时候触发。
function QueryDialog:onEnterTransitionFinish()
    return self
end

-- 退出场景而且开始过渡动画时候触发。
function QueryDialog:onExitTransitionStart()
	self:unregisterScriptTouchHandler()
    return self
end

--窗外触碰
function QueryDialog:setCanTouchOutside(canTouchOutside)
	self._canTouchOutside = canTouchOutside
	return self
end

--msg 显示信息
--callback 交互回调
--txtsize 字体大小
function QueryDialog:ctor(msg, callback,bshowToPay,queryType,secondBtn)
	--queryType = queryType or QueryDialog.QUERY_SURE_CANCEL
	self._callback = callback
	self._canTouchOutside = true

	local this = self 
	self:setContentSize(appdf.WIDTH,appdf.HEIGHT)
	self:move(0,appdf.HEIGHT)

	--回调函数
	self:registerScriptHandler(function(eventType)
		if eventType == "enterTransitionFinish" then	-- 进入场景而且过渡动画结束时候触发。
			this:onEnterTransitionFinish()
		elseif eventType == "exitTransitionStart" then	-- 退出场景而且开始过渡动画时候触发。
			this:onExitTransitionStart()
		end
	end)

	--按键监听
	local  btcallback = function(ref, type)
        if type == ccui.TouchEventType.ended then
         	this:onButtonClickedEvent(ref:getTag(),ref)
        end
    end

	--区域外取消显示
	local  onQueryExitTouch = function(eventType, x, y)
		if not self._canTouchOutside then
			return true
		end

		if self._dismiss == true then
			return true
		end

		if eventType == "began" then
			local rect = this:getChildByTag(QueryDialog.DG_QUERY_EXIT):getBoundingBox()
        	if cc.rectContainsPoint(rect,cc.p(x,y)) == false then
				self:dismiss()
				if self._callback then
					self._callback(false)
				end
    		end
		end
    	return true
    end
	self:setTouchEnabled(true)
	-- self:registerScriptTouchHandler(onQueryExitTouch)

	-- if bshowToPay then
	-- 	display.newSprite("client/res/popView/topaytipsbg.png")
	-- 	:setTag(QueryDialog.DG_QUERY_EXIT)
	-- 	:move(appdf.WIDTH/2,375)
	-- 	:addTo(self)
		
	-- 	local closebtn = ccui.Button:create("client/res/public/dailix.png","client/res/public/dailix.png")
	-- 	:move(appdf.WIDTH/2+345 ,560 )
	-- 	:setTag(QueryDialog.BT_CANCEL)
	-- 	:addTo(self)
	-- 	closebtn:addTouchEventListener(btcallback)
		
	-- 	-- local freegouldcount = GlobalUserItem.channelconfig.almsnum - GlobalUserItem.TodayAlmsCount
		
	-- 	local offx = 0
	-- 	ccui.Button:create("client/res/public/gopay.png","public/gopay.png")
	-- 	:move(appdf.WIDTH/2 + offx , 280 )
	-- 	:setTag(QueryDialog.BT_CONFIRM)
	-- 	:addTo(self)
	-- 	:addTouchEventListener(btcallback)
		
	-- 	cc.Label:createWithSystemFont(msg , "Arial",32 )
	-- 	:setTextColor(cc.c4b(192,149,115,255))
	-- 	:setAnchorPoint(cc.p(0.5,0.5))
	-- 	:setDimensions(600, 180)
	-- 	:setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	-- 	:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	-- 	:move(appdf.WIDTH/2+10 ,420 )
	-- 	:addTo(self)
	-- else
		display.newSprite("base/res/tankuang.png")
		:setTag(QueryDialog.DG_QUERY_EXIT)
		:move(appdf.WIDTH/2,375)
		:addTo(self)
        
        display.newSprite("base/res/biaoti.png")
		:move(appdf.WIDTH/2,610)
		:addTo(self)
		self.surebtn=ccui.Button:create("base/res/sure_1.png","base/res/sure_1.png")
		self.surebtn:move(appdf.WIDTH/2 , 230+10 )
		:setTag(QueryDialog.BT_CONFIRM)
		:addTo(self)
		:addTouchEventListener(btcallback)

		local closebtn = ccui.Button:create("base/res/close.png","base/res/close.png")
		:move(appdf.WIDTH/2+375 ,515 )
		:setTag(QueryDialog.BT_CANCEL)
		:addTo(self)
		closebtn:addTouchEventListener(btcallback)

		cc.Label:createWithSystemFont(msg , "Arial",32 )
		:setTextColor(cc.c4b(0,0,0,255))
		:setAnchorPoint(cc.p(0.5,0.5))
		:setDimensions(600, 180)
		:setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
		:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		:move(appdf.WIDTH/2+10 ,410 )
		:addTo(self)
		if secondBtn then

			self.surebtn:setVisible(false)
			ccui.Button:create("base/res/surebtn1.png","base/res/surebtn1.png")
			:move(appdf.WIDTH/2+164 , 156 )
			:setTag(QueryDialog.BT_CONFIRM)
			:addTo(self)
			:addTouchEventListener(btcallback)

			ccui.Button:create("base/res/downbtn1.png","base/res/downbtn1.png")
			:move(appdf.WIDTH/2 - 164, 156)
			:setTag(QueryDialog.BT_DOWNLOAD)
			:addTo(self)
			:addTouchEventListener(btcallback)
		end
	-- end

	self._dismiss  = false
	self:setPosition(0,0)
	ExternalFun.playOpenLayerAnimation( self )
end

--按键点击
function QueryDialog:onButtonClickedEvent(tag,ref)
		if self._dismiss == true then
			return
		end
	--取消显示
	
	if tag == QueryDialog.BT_GETFREE then
		self:dismiss()
		if GlobalUserItem.accounttype == 0 then
			showToast(self,"注册成为正式账号后即可每日免费领取！",2)
			return
		end
		local allmoney = GlobalUserItem.lUserScore+GlobalUserItem.lUserInsure
		
		if allmoney >= GlobalUserItem.channelconfig.almslimit then
			showToast(self,"您今日还可领取"..((GlobalUserItem.channelconfig.almsnum - GlobalUserItem.TodayAlmsCount)).."次（金币不足"..GlobalUserItem.channelconfig.almslimit/appdf.bili.."时可领取）",2)
			return
		end	

		if GlobalUserItem.channelconfig.almsnum - GlobalUserItem.TodayAlmsCount == 0 then
			showToast(self,"今日免费金币已领完，请明日再来！",2)
			return
		end
		-- self:getParent()._LogonFrame:sendSocketData(protocol.CTRL_CLIENT_HALL,protocol.CXM_GETALMS)
		self:getParent():showPopWait()
	elseif tag == QueryDialog.BT_ZHUCE  then
		self:dismiss()
		self:getParent():openBindingLayer(yl.SCENE_BINDING,true)
	elseif tag == QueryDialog.BT_CONFIRM  then
		self:dismiss()
		if self._callback then
			self._callback(true)
		end
	elseif tag == QueryDialog.BT_DOWNLOAD  then
		if self._callback then
			self._callback(false,tag)
		end
	elseif tag == QueryDialog.BT_CANCEL  then
		self:dismiss()
		if self._callback then
			self._callback(false)
		end
	end
	

end

--取消消失
function QueryDialog:dismiss()
	self._dismiss = true
	local this = self
	self:stopAllActions()
	self:runAction(
		cc.Sequence:create(
			cc.DelayTime:create(0.02),
			cc.CallFunc:create(function()
					self:removeSelf()
				end)
			))	
	
end

return QueryDialog
