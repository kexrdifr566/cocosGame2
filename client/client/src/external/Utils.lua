--
-- Created by IntelliJ IDEA.
-- User: LX
-- Date: 2017/4/10
-- Time: 16:33
-- To change this template use File | Settings | File Templates.--
local utils = {}
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local QueryExit = appdf.req(appdf.CLIENT_SRC.."app.views.layer.other.QueryDialog")

function utils.updateItemStatus(listview,item,height_,animal)

    item.lastsize = cc.size(item.width,item.height)
    item.height = height_
    listview:itemSizeChangeListener(item, item,item.lastsize,animal)
    local delta = item.height-item.lastsize.height
    print("updateItemStatus>>>>>",delta)
end

function utils.createWacthLayer(parent,limitmoney)
	local csbNode = ExternalFun.loadCSB("public/watchLayer.csb", parent)
	csbNode:getChildByName("Text_1"):setString("处于观战模式，需要"..limitmoney/appdf.bili..yl.UNIT.."即可参与游戏")
	local action = cc.CSLoader:createTimeline("public/watchLayer.csb")
	csbNode:runAction(action)
	action:gotoFrameAndPlay(0,95, true)
	return csbNode
end

function utils.createWaitLayer()
    local csbnode = cc.CSLoader:createNode("public/waitLayer.csb")
    csbnode:setPositionY(csbnode:getPositionY()-20)
	return csbnode
end

function device.getWinHeight()
    if device.platform == "android" then
        local ok, ret = native.callStaticMethod("Bridge","getAndroidWindowsHeight", nil, nil, "()I");
        if not ok then
            ret  = display.sizeInPixels.height
        else
            return ret
        end
    end
    return display.sizeInPixels.height
end


--==============================--
--desc:把秒数转化成时分秒
--time:2017-05-12 15:54:46
--@secs:秒数
--==============================--
function utils.formatTime(secs)
    local fmt, a, b
    if secs > 3600 then
        fmt = "%d小时%d分%d秒"
        a, b,c = math.floor(secs/3600), math.floor((secs/60)%60),secs%60
        if b == 0 then
            fmt = "%d小时"
        end
        return a,b,c
    end

    if secs > 60 then
        fmt = "%d分%d秒"
        a, b = math.floor(secs/60), secs%60
        if b == 0 then
            fmt = "%d分"
        end
       return 0,b,c
    else
        fmt = "%d秒"
        return 0,0,c or 0
       
    end
end


function utils.length(str)
    local cstr,count = string.gsub(str, "[^\128-\193]", "")
   print("utils.length ",string.len(str),"  /  ",cstr,string.len(cstr),count)
    return count--#(string.gsub(str,'[\128-\255][\128-\255]',' '))
end

--==============================--
--desc:验证码倒计时
--time:2017-05-10 15:42:46
--@cb:回调函数
--@name:名字
--@parent:父容器
--@color:颜色
--return 
--==============================--
function utils.sendVerificationCode(parent,name,cb)
     local sendVerificationBtn = cc.uiloader:seekNodeByName(parent,name) 
    sendVerificationBtn:onButtonClicked(function()
        sendVerificationBtn:setTouchEnabled(false)
        local waitTime = 59
        sendVerificationBtn:setButtonLabelColor(cc.c3b(222,222,222))
        sendVerificationBtn:setOpacity(200)
        parent:setInterval(function()
            sendVerificationBtn:setButtonLabelString("（"..waitTime.."）重新获取")
            waitTime = waitTime-1
            if waitTime == 0 then
                sendVerificationBtn:setButtonLabelString("发送验证码")
                sendVerificationBtn:setTouchEnabled(true)
                parent:clearInterval()
            end
        end,1)
    end)
end

--==============================--
--desc:排序输出table  针对开奖公告key 为string类型
--@t:table
--==============================--
function utils.pairsByKeys(t)
    local a = {}
    for n in pairs(t) do
    n = checkint(n)
     a[#a + 1] = n 
        
      end
    table.sort(a)
    local i = 0
    return function ()
        i = i + 1
        
        return a[i], t[checkString(a[i])]
    end
end


--==============================--
--desc:弹出到账提示
--moneynum:到账金额
--gettime:到账时间
--parent:父节点
--==============================--
function utils.showArrivalLayer(moneynum,cb,animtparent)
	
	local parent = cc.Director:getInstance():getRunningScene()
	animtparent = animtparent or parent
    local layer,CsbNode =  ExternalFun.loadRootCSB( "Shop/arrivalLayer.csb", parent)
    ExternalFun.FixCenterPosY(CsbNode)
	utils.playTipSound("sound/happyget.mp3")
	CsbNode:getChildByName("closebt_0"):addTouchEventListener(function (ref,type)
				if type == ccui.TouchEventType.ended then
					layer:removeFromParent()
					if cb then
						cb()
					end
					
					ref:setScale(1)	
				elseif type == ccui.TouchEventType.began then
					ref:setScale(yl.btscale)
					return true
				elseif type == ccui.TouchEventType.canceled then
					ref:setScale(1)					
				end
			end)
	local action = cc.CSLoader:createTimeline("Shop/arrivalLayer.csb");
	--action:setTimeSpeed(2)
    CsbNode:runAction(action)
	action:gotoFrameAndPlay(0,30, false)
	CsbNode:getChildByName("getmoneyText"):setString(moneynum.."金")
	local armat = CsbNode:getChildByName("ArmatureNode")
    
	local animation = armat:getAnimation()
	animation:setMovementEventCallFunc(function (arm, eventType, movmentID)
			if eventType == ccs. MovementEventType.start then
                    
			elseif eventType == ccs. MovementEventType.complete then
					--animation:gotoAndPlay(25)
                    animation:play("Animation1")
			elseif eventType == ccs. MovementEventType.loopComplete then
                      
			end
			
		end)

end

function utils.playTipSound(sname)
    if GlobalUserItem.bSoundAble then
       yl.soundEffect = AudioEngine.playEffect(sname)
    end
	
end
--==============================--
--desc:当用户在另外设备登录时登出游戏
--==============================--
function utils.loginOutGame()
      local _cb = function(response)
         game.UserDefault:set("username", "")
         display.switchScene("hall.SceneHall")
      end
         utils.gettoken(_cb)
end

function utils.moveInputSceneDistance()
    local curScene = cc.Director:getInstance():getRunningScene()
    local inputheight = curScene.targetExitField:getFontSize()*3 
    local buttonPosition = curScene.buttonPosition
    local posx, posy = buttonPosition.x,buttonPosition.y
    local deltaY = posy - game.keyheight/display.contentScaleFactor - game.virtulButtonHeight
    deltaY = deltaY >= 0 and 0 or -deltaY
    print("moveInputScene1111>>>>--------",display.contentScaleFactor,"  /  ",game.keyheight,"  /  ",posx," / ",deltaY,"  /buttonPosition.y",posy)
      local seq = transition.sequence({
        cc.MoveTo:create(ts or 0.1,cc.p(0, ( deltaY and deltaY > 0 ) and deltaY or 0)),
        cc.CallFunc:create(function( ... )
            print("curScene:runAction>>>>",deltaY, curScene.targetExitField)
            if  deltaY == 0  and  not tolua.isnull(curScene.targetExitField) then
                 curScene.targetExitField:didNotSelectSelf()
            end
            curScene.inrunAct =  false
        end)
    })
    curScene.inrunAct =  true
    curScene:runAction(seq)
end

--==============================--
--desc: 控制输入软键盘的偏移位置  触摸输入区域 关闭软键盘 并 恢复舞台位置
--time:2017-05-04 10:01:07
--@targetExitField: 目标输入栏
--@ts: 移动时间
--return 
--==============================--
function utils.moveInputScene(targetExitField,ts)
    local curScene = cc.Director:getInstance():getRunningScene()
    if  curScene.inrunAct and targetExitField  then
        print("moveInputScene inrunAct>>>>")
        return
    end
    if not tolua.isnull(curScene.maskSp) then
        curScene.maskSp:removeSelf()
    end

    local inputheight = targetExitField and targetExitField:getFontSize()*3 or 0
    local buttonPosition = targetExitField and  targetExitField:getParent():convertToWorldSpace(cc.p(targetExitField:getPosition())) or {x=0,y=0}
    local posx, posy = buttonPosition.x,buttonPosition.y
    -- game.virtulButtonHeight = device.getWinHeight() - display.height
    local deltaY = targetExitField and posy -(game.keyheight and game.keyheight/display.contentScaleFactor or display.cy) or 0
    deltaY = deltaY >= 0 and 0 or -deltaY

    print("moveInputScene1111>>>>******* ",game.keyheight,"  / ",display.cy,"  / ",display.sizeInPixels.height,"  / ",display.contentScaleFactor)
   
    if targetExitField then
        -- local posx, posy = targetExitField:getPosition()
        -- local buttonPosition = targetExitField:getParent():convertToWorldSpace(cc.p(posx, posy))
        curScene.targetExitField = targetExitField
        curScene.maskSp =  cc.ui.UIPushButton.new("common/toumi.png", {scale9 = true})
        curScene.maskSp:setButtonSize(display.width,display.height)
        curScene.maskSp:addTo(curScene,1000):center() 
         print("moveInputScene1111>>>>",display.contentScaleFactor,"  /  ",game.keyheight,"  /  ",posx," / ",deltaY,"  /buttonPosition.y",posy)
        -- if deltaY ~= 0 then
        --     curScene.maskSp:setPositionY(buttonPosition.y+display.cy+(inputheight or 80)/2)
        -- elseif targetExitField then
            curScene.maskSp:setPositionY(posy+display.cy+(inputheight or 80)/2)
            local maskSp2 = display.newScale9Sprite("common/toumi.png", 0,0, cc.size(display.width,display.height))
            maskSp2:addTo(curScene.maskSp):center() 
            maskSp2:setPosition(0,-display.height-(inputheight or 80)+5)
        -- end
        curScene.maskSp:onButtonPressed(function()
             utils.moveInputScene()
        end)
    end

    local seq = transition.sequence({
        cc.MoveTo:create(ts or 0.1,cc.p(0, ( deltaY and deltaY > 0 ) and deltaY or 0)),
        cc.CallFunc:create(function( ... )
            print("curScene:runAction>>>>",deltaY, curScene.targetExitField)
            if  deltaY == 0 and not targetExitField and  not tolua.isnull(curScene.targetExitField) then
                 curScene.targetExitField:didNotSelectSelf()
            end
            curScene.inrunAct =  false
        end)
    })
    curScene.inrunAct =  true
    curScene:runAction(seq)
end

function utils.lightEffects(parent,lightsp,mask,delaytime)
	if not lightsp or not mask then
		return
	end
	delaytime = delaytime or 0
	local clip = cc.ClippingNode:create()
	clip:setStencil(mask)
	clip:setAlphaThreshold(0)
	--clip:addChild(mask)
	local selfSize = mask:getContentSize()
	clip:setPosition(cc.p(selfSize.width * 0.5, selfSize.height * 0.5))
	parent:addChild(clip)
	clip:addChild(lightsp)
	local nodeSize = mask:getContentSize()
	local mt1 = cc.MoveTo:create(2,cc.p(nodeSize.width,0))
	
	local mt2 = cc.CallFunc:create(function()
		lightsp:setPosition(-nodeSize.width,0)
	end)
	local mt3 = cc.DelayTime:create(delaytime)
	local ac = cc.Sequence:create(mt1, mt2,mt3);
	lightsp:runAction(cc.RepeatForever:create(ac))
	return clip
end

--==============================--
-- 支付渠道配置
--==============================--
function utils.getChongzhiChenl(cb)
    local ostime = os.time()
    appdf.onHttpJsionTable(appdf.HTTP_URL .. "/interface","GET","route=getpaylist",function(jstable,jsdata)
        
        if type(sjstable) == "table" then
            local leftmenudata = sjstable["Table"]
			local itemdata = sjstable["Table1"]
			
			--过滤渠道列表
			local filterleftmenu = {}
			for _, v in pairs(leftmenudata) do
				if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or (cc.PLATFORM_OS_MAC == targetPlatform) then
					if (appConfigProxy._appStoreSwitch ~= 0) then
						if (yl.PAYMENT_APPLE ~= v.ID) then
							table.insert(filterleftmenu, v)
						end
					else
						if (yl.PAYMENT_APPSTORE_APPLE ~= v.ID) then
							table.insert(filterleftmenu, v)
						end
					end
				elseif (cc.PLATFORM_OS_ANDROID == targetPlatform) then
					if (yl.PAYMENT_APPLE ~= v.ID and yl.PAYMENT_APPSTORE_APPLE ~= v.ID) then
						table.insert(filterleftmenu, v)
					end
				else
					table.insert(filterleftmenu, v)
				end				
            end
            
			--过滤渠道列表数据
			local pricelist = {}
			for _, v in pairs(itemdata) do
				if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or (cc.PLATFORM_OS_MAC == targetPlatform) then
					if (appConfigProxy._appStoreSwitch ~= 0) then
						if (yl.PAYMENT_APPLE ~= v.QudaoID) then
							pricelist[v.QudaoID] = pricelist[v.QudaoID] or {}
							table.insert(pricelist[v.QudaoID], v.Limit)
						end
					else
						if (yl.PAYMENT_APPSTORE_APPLE ~= v.QudaoID) then
							pricelist[v.QudaoID] = pricelist[v.QudaoID] or {}
							table.insert(pricelist[v.QudaoID], v.Limit)
						end
					end
				elseif (cc.PLATFORM_OS_ANDROID == targetPlatform) then
					if (yl.PAYMENT_APPLE ~= v.QudaoID and yl.PAYMENT_APPSTORE_APPLE ~= v.QudaoID) then
						pricelist[v.QudaoID] = pricelist[v.QudaoID] or {}
						table.insert(pricelist[v.QudaoID], v.Limit)
					end
				else
					pricelist[v.QudaoID] = pricelist[v.QudaoID] or {}
					table.insert(pricelist[v.QudaoID], v.Limit)
				end
			end
			
			callback(filterleftmenu, pricelist)
        end

        if type(jstable) == "table" then
            cb(true,jstable)
        else
            cb(false)
        end
    end)
end

--==============================--
-- 代理充值
--==============================--
function utils.getAgentChongzhi(cb)
    local ostime = os.time()
    appdf.onHttpJsionTable(appdf.HTTP_URL .. "/interface","GET","route=getviprechargelist",function(jstable,jsdata)
        if type(jstable) == "table" then
			local code = jstable["code"]
			if tonumber(code) == 0 then
				local datax = jstable["data"]
				local msg = jstable["msg"]
				errmsg = ""
				if type(msg) == "string" then
					errmsg = msg
				end
				
				if datax then
					local valid = datax["valid"]
					if valid == true then
						local list = datax["list"]
						if type(list) == "table" then
							local agentRechargeList = {}
							for i=1,#list do
								local item = {}
								item.qq = tonumber(list[i]["QQ"])
								item.name = list[i]["ShowName"]
								item.wechat = list[i]["WeChat"]
								table.insert(agentRechargeList, item)
                            end
                            cb(true,agentRechargeList)
                            return
						end
					end
				end
			end
		end
        cb(false)
    end)
end

--==============================--
-- 我的玩家
--==============================--
function utils.getAgentChildList(page,cb)
    local ostime = os.time()
    local params = "route=GetAgentChildList&userid=" .. GlobalUserItem.dwUserID .. "&time=".. ostime .."&page="..page.. "&signature=".. GlobalUserItem:getSignature(ostime)
	appdf.onHttpJsionTable(appdf.HTTP_URL .. "/interface","GET",params,function(jstable,jsdata)
        if type(jstable) == "table" then
            cb(true,jstable)
        else
            cb(false)
        end
    end)
end

--==============================--
-- 我的直属玩家返利
--==============================--
function utils.getAgentMyChildRevenue(page,cb)
    local ostime = os.time()
    local params = "route=GetAgentRevenueList&userid=" .. GlobalUserItem.dwUserID .. "&time=".. ostime .."&page="..page.. "&signature=".. GlobalUserItem:getSignature(ostime)
	appdf.onHttpJsionTable(appdf.HTTP_URL .. "/interface","GET",params,function(jstable,jsdata)
        if type(jstable) == "table" then
            cb(true,jstable)
        else
            cb(false)
        end
    end)
end

--==============================--
-- 我的次级玩家返利
--==============================--
function utils.getAgentTwoChildRevenue(page,cb)
    local ostime = os.time()
    local params = "route=GetAgentTwoRevenueList&userid=" .. GlobalUserItem.dwUserID .. "&time=".. ostime .."&page="..page.. "&signature=".. GlobalUserItem:getSignature(ostime)
	appdf.onHttpJsionTable(appdf.HTTP_URL .. "/interface","GET",params,function(jstable,jsdata)
        if type(jstable) == "table" then
            cb(true,jstable)
        else
            cb(false)
        end
    end)
end

--==============================--
-- 我的推广数据
--==============================--
function utils.getTuiguangDetail(cb)
    local ostime = os.time()
	local params = "route=GetAgentFinanceNew&userid=" .. GlobalUserItem.dwUserID .. "&time=".. ostime .. "&signature=".. GlobalUserItem:getSignature(ostime)
    appdf.onHttpJsionTable(appdf.HTTP_URL .. "/interface","GET",params,function(jstable,jsdata)
        local msg = nil
        if type(jstable) == "table" then
            local data = jstable["data"]
            msg = jstable["msg"]
            if type(data) == "table" then
                local valid = data["valid"]
                if valid then
                    cb(true,data)
                end
                return
            end
        end

        cb(false,data)
    end)
end

--==============================--
-- 佣金提现
--==============================--
function utils.toGetPeofit(cb)
    local ostime = os.time()
	local params = "route=AgentBalance&userid=" .. GlobalUserItem.dwUserID .. "&time=".. ostime .. "&signature=".. GlobalUserItem:getSignature(ostime)
    appdf.onHttpJsionTable(appdf.HTTP_URL .. "/interface","GET",params,function(jstable,jsdata)
        local msg = nil
        if type(jstable) == "table" then
            local data = jstable["data"]
            msg = jstable["msg"]
            if type(data) == "table" then
                local valid = data["valid"]
                if valid then
                    cb(true,data)
                else
                    cb(false,msg)
                end
            end
        end

        
    end)
end

--==============================--
-- 获取公告
--==============================--
function utils.getNotice(cb)
    local m_tabSystemNotice = {}
    m_tabSystemNotice.noticelist = {}
    m_tabSystemNotice.emaillist = {}
    local ostime = os.time()
    local url = appdf.HTTP_URL .. "/interface?route=GetMobileRollNotice&userid=" .. GlobalUserItem.dwUserID .. "&time=".. ostime .. "&signature=".. GlobalUserItem:getSignature(ostime)        	
	appdf.onHttpJsionTable(url ,"GET","",function(jstable,jsdata)
		if type(jstable) == "table" then
			local data = jstable["data"]
            local msg = jstable["msg"]
            local valid = data["valid"]
			if type(data) == "table" and (nil ~= valid and true == valid) then
                local noticelist = data["notice"]
                local emaillist = data["email"]
				if type(noticelist)  == "table" then
					local listSize = #noticelist
					for i = 1, listSize do
                        local item = {}
                        item.title = noticelist[i].title
                        item.pop = noticelist[i].pop
                        item.scroll = noticelist[i].scroll
                        item.content = noticelist[i].content
                        item.date = noticelist[i].date
						table.insert(m_tabSystemNotice.noticelist, item)
                    end
                    
                end
                if type(emaillist)  == "table" then
					local listSize = #emaillist
					for i = 1, listSize do
                        local item = {}
                        item.idx = emaillist[i].id
                        item.title = emaillist[i].title
                        item.sender = emaillist[i].sender
                        item.content = emaillist[i].content
                        item.createtime = emaillist[i].date
                        item.status = emaillist[i].status
                        
						table.insert(m_tabSystemNotice.emaillist, item)
                    end
                end
                cb(true,m_tabSystemNotice)
                return
			end
        end
        cb(false)
    end)
end

--==============================--
-- 设置邮件已读状态
--==============================--
function utils.checkMobileEmail(emailID)
    local ostime = os.time()
    local url = appdf.HTTP_URL .. "/interface"
    appdf.onHttpJsionTable(url ,"GET","route=CheckMobileEmail&userid=" .. GlobalUserItem.dwUserID .."&emailID="..emailID.. "&time=".. ostime .. "&signature=".. GlobalUserItem:getSignature(ostime),function(sjstable,sjsdata)
    end)
end

--==============================--
-- 删除已读邮件
--==============================--
function utils.deleteMobileEmail()
    local ostime = os.time()
    local url = appdf.HTTP_URL .. "/interface"
    appdf.onHttpJsionTable(url ,"GET","route=DeleteMobileEmail&userid=" .. GlobalUserItem.dwUserID .. "&time=".. ostime .. "&signature=".. GlobalUserItem:getSignature(ostime),function(sjstable,sjsdata)
    end)
end

--==============================--
-- 获取用户剩余金币数
--==============================--
function utils.queryUserScoreInfo(cb)
    local ostime = os.time()
    local url = appdf.HTTP_URL .. "/interface"
    appdf.onHttpJsionTable(url ,"GET","route=GetScoreInfo&userid=" .. GlobalUserItem.dwUserID .. "&time=".. ostime .. "&signature=".. GlobalUserItem:getSignature(ostime),function(sjstable,sjsdata)
        
        if type(sjstable) == "table" then
            local data = sjstable["data"]
            if type(data) == "table" then
                local valid = data["valid"]
                if true == valid then
                    local score = tonumber(data["Score"]) or 0
                    cb(true,score)
                    return
                end
            end
        end

        cb(false)
    end)
end

--==============================--
-- 绑定提现账号(支付宝,银行卡)
--==============================--
function utils.bindWithdrawInfo(params,cb)
    appdf.onHttpJsionTable(appdf.HTTP_URL .. "/interface", "GET", params, function(jstable, jsdata)
        --dump(jstable,"绑定银行卡")
        local str="绑定失败,请稍后重新尝试"
        if type(jstable) == "table" then
            if nil ~= jstable.msg then
            --if jstable.data.valid then
                str=jstable.msg
                cb(jstable.data.valid,str)
                return
            end
        end
        cb(false,str)
    end )
end

--==============================--
-- 提交客服反馈
--==============================--
function utils.publishFeedback(content,cb)
    local ostime = os.time()
    content = appdf.encodeURI(content)
	local params = "route=PublishFeedback&userid=" .. GlobalUserItem.dwUserID .. "&content=".. content .. "&time=".. ostime .."&signature=".. GlobalUserItem:getSignature(ostime)
    appdf.onHttpJsionTable(appdf.HTTP_URL .. "/interface","GET",params,function(jstable,jsdata)
        if type(jstable) == "table" then
            if jstable.data.valid then
                cb(true)
                return
            end
        end
        cb(false,"提交失败,请检查")
    end )
end

--==============================--
-- 创建支付订单
--==============================--
function utils.CreatPayOrderID(params,cb)
    appdf.onHttpJsionTable(appdf.HTTP_URL .. "/interface", "GET", params, function(jstable, jsdata)
        if type(jstable) == "table" then
            local data = jstable["data"]
            if type(data) == "table" then
                if nil ~= data["valid"] and true == data["valid"] then
                    cb(true,data["OrderID"])
                    return
                end
            end
        end
        cb(false)
    end)
end

--==============================--
-- 用户兑换提现
--==============================--
function utils.applyCash(params,cb)
    appdf.onHttpJsionTable(appdf.HTTP_URL .. "/interface" ,"GET",params,function(jstable,jsdata)
        if type(jstable) == "table" then
            if jstable.data.valid then
                cb(true)
                return
            end
        end
        cb(false)
    end)
end

--==============================--
-- 获取用户兑换提现记录
--==============================--
function utils.queryUserCashList(cb)

    local function getStutas( param )
		if type(param) ~= "number" then
			return
		end
		
		if param == 0 or param > 3 then
			param = 1
		end
	
		local str1 = "正在处理"
		local str2 = "已提现"
		local str3 = "拒绝提现"
		local str4 = "等待付款"
		
		local switch = 
		{
			[1] = function( )
				return  str1
			end,

			[2] = function( )
				return  str2
			end,

			[3] = function( )
				return str3
			end,

			[4] = function( )
				return str4
			end

		}
	   local status = switch[param]
	   return status()
    end
    
    local ostime = os.time()
    local url = appdf.HTTP_URL .. "/interface"
    local params = "route=GetCashList&userid=" .. GlobalUserItem.dwUserID .. "&time=".. ostime .. "&signature=".. GlobalUserItem:getSignature(ostime)
    appdf.onHttpJsionTable(url ,"GET",params,function(sjstable,sjsdata)
        if type(sjstable) == "table" then
            local code = sjstable["code"]
			local recordArray = {}
			if tonumber(code) == 0 then
				local datax = sjstable["data"]
				if datax then
					local valid = datax["valid"]
					if valid == true then
						local listcount = datax["total"]
						local list = datax["list"]
						if type(list) == "table" then
							for i=1,#list do
								local item = {}
								item.ApplyDate = GlobalUserItem:getDateNumber(list[i]["ApplyDate"])
								item.OrderID = list[i]["OrderID"]
								item.SellMoney = list[i]["SellMoney"]
								item.Status = getStutas(list[i]["Status"])
								item.RejectReason = list[i]["RejectReason"]
								item.AccountType = list[i]["bType"]
								table.insert(recordArray,item)
							end
						end
					end
				end
            end
            
            cb(true,recordArray)
        else
            cb(false)
        end
    end)
end

--==============================--
-- 获取手机验证码
--==============================--
function utils.sendGetCode(phoneNumber,type,cb)
    local url = appdf.HTTP_URL .. "/Phone/GetMessage.aspx"
    local params=string.format( "Mobile=%s&Type=%d",phoneNumber,type)
    appdf.onHttpJsionTable(url,"POST",params,function(jstable,jsdata)
        if jstable and jstable.ref then
            if jstable.ref == "SUCCESS" then
                cb(true)
                return
            else
                cb(false,jstable.message)
                return
            end
        end
        cb(false,"发送失败,请检查网络")
    end)   
end

--修改密码
function utils.forgetPWD(phoneNumber, verifyCode, password, cb)
    local url = appdf.HTTP_URL .. "/interface/pwd"
    password = appdf.encodeURI(password)
    appdf.onHttpJsionTable(url ,"POST","&Mobile=" .. phoneNumber .. "&VerifyCode=" .. verifyCode .. "&PassWord=" .. password, function(jstable,jsdata)
        if jstable and jstable.ref then
        	if jstable.ref == "SUCCESS" then
                cb(true)
                return
			end
        end
        cb(false,"绑定失败,请重试")
    end)
end

--绑定账号
function utils.bindMobile(phoneNumber, verifyCode, password, machinelID,DevType, cb)
    local ostime = os.time()
    if password==nil then
        password=""
    end
    password = appdf.encodeURI(password)
    local url = appdf.HTTP_URL .. "/interface"
    local params = "route=BindAccounts&userid=" .. GlobalUserItem.dwUserID.."&Mobile="..phoneNumber.."&VerifyCode="..verifyCode.."&PassWord="..password.."&MachineID="..machinelID .."&DevType="..DevType.. "&time=".. ostime .. "&signa=".. GlobalUserItem:getSignature(ostime)
    print("绑定",url)
    appdf.onHttpJsionTable(url ,"GET",params,function(sjstable,sjsdata)
        print("绑定1",sjsdata)
        if type(sjstable) == "table" then
            if sjstable.data.valid then
                cb(true)
                return
            end
        end
        if sjstable==nil then
            cb(false,"未知错误")
        else
            cb(false,sjstable.msg)
        end
    end)
end

--绑定代理
function utils.bindAgents(spreaderID,cb)
    local ostime = os.time()
    local url = appdf.HTTP_URL .. "/interface"
    local params = "route=BindAgents&userid=" .. GlobalUserItem.dwUserID.."&spreaderid="..spreaderID.. "&time=".. ostime .. "&signa=".. GlobalUserItem:getSignature(ostime)
    appdf.onHttpJsionTable(url ,"GET",params,function(sjstable,sjsdata)
        if type(sjstable) == "table" then
            if sjstable.data.valid then
                cb(true)
                return
            end
        end
        cb(false,sjstable.msg)
    end)
end

--将文字变灰 用于支付宝账号 银行卡账号
-- defstr  缺省值
function utils:LabelSetString(lab,str,defstr)
	if not str or str == "" then
		lab:setString(defstr)
		lab:setOpacity(127)
		return 
	end
	lab:setString(str)
	lab:setOpacity(255)
end

function encodeURI(s)
    s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
    return string.gsub(s, " ", "+")
end

local function urlencodechar(char)
    return "%" .. string.format("%02X", string.byte(char))
end

function utils.checkAPPInstalled( selctType,customStr )
    local str
	local plat 
    if selctType == "wxpay" then
		plat = public.ThirdParty.WECHAT
		str = "微信未安装,无法进行微信支付,请安装后重试"
	elseif selctType == "alipay" then
		plat = public.ThirdParty.ALIPAY
		str = "支付宝未安装,无法进行支付宝支付,请安装后重试"
	elseif selctType == "alipayfixed" then
		plat = public.ThirdParty.ALIPAY
		str = "支付宝未安装,无法进行支付宝支付,请安装后重试"
	elseif selctType == "qqpay" then
		plat = public.ThirdParty.QQ
        str = "QQ未安装,无法进行QQ支付,请安装后重试"
    else
        return true
    end
    
	-- if customStr then
	-- 	str = customStr
	-- end
    --判断应用是否安装
    local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
    local isinstalled,msg = MultiPlatform:getInstance():isPlatformInstalled(plat)
    local curScene = cc.Director:getInstance():getRunningScene()
    -- showToast(curScene,"isinstalled>>>"..plat.." / "..tostring(isinstalled).." / "..tostring(msg or ""))
	if  str and not isinstalled  then
        --showToast(curScene, str, 2, cc.c4b(250,0,0,255))
		QueryExit:create(str, function (ok)
			if ok == true then
			end
		end)
		:addTo(curScene)
		
		return
    end
    return true
end


function utils.copyToTable( targetTb,sourceTb )
    for i,v in pairs(sourceTb) do
        -- print("copyToTable>>>",i,v)
        targetTb[i] = v
    end
end
function utils.getPayList(cb)
    local url = appdf.HTTP_URL .. "/interface"
    appdf.onHttpJsionTable(url ,"GET","route=getpayamounttype",function(jstable,jsdata)
        if type(jstable) == "table" then
            local data = jstable["data"]
            local valid = data["valid"]
            if type(data) == "table" and (nil ~= valid and true == valid) then
                local noticelist = data["records"]
                if type(noticelist)  == "table" then
                    cb(true,noticelist)
                end
                return
            end
        end
        cb(false)
    end)
end
function utils.getPayNumber(cb,index,Tid)
    local url = appdf.HTTP_URL .. "/interface"
    local str=string.format("route=getpayamount&type=%d&id=%d", index,Tid)
    appdf.onHttpJsionTable(url ,"GET",str,function(jstable,jsdata)
        if type(jstable) == "table" then
            local data = jstable["data"]
            local valid = data["valid"]
            if type(data) == "table" and (nil ~= valid and true == valid) then
                local noticelist = data["records"]
                if type(noticelist)  == "table" then
                    cb(true,noticelist)
                end
                return
            end
        end
        cb(false)
    end)
end
--获得反水的基础值
function utils.getCoat(cb)
    local ostime = os.time()
    local url = appdf.HTTP_URL .. "/interface"
    local params = "route=getreturngold&userid=" .. GlobalUserItem.dwUserID.."&time=".. ostime .. "&signa=".. GlobalUserItem:getSignature(ostime)
    appdf.onHttpJsionTable(url ,"GET",params,function(jstable,jsdata)
        if type(jstable) == "table" then
            local data = jstable["data"]
            local valid = data["valid"]
            if type(data) == "table" and (nil ~= valid and true == valid) then
                local noticelist = data["info"]
                if type(noticelist)  == "table" then
                    cb(true,noticelist)
                end
                return
            end
        end
        cb(false)
    end)
end
--领取返水值
function utils.getOutCoat(cb)
    local ostime = os.time()
    local url = appdf.HTTP_URL .. "/interface"
    local params = "route=proreturngold&userid=" .. GlobalUserItem.dwUserID.."&time=".. ostime .. "&signa=".. GlobalUserItem:getSignature(ostime)
    appdf.onHttpJsionTable(url ,"GET",params,function(jstable,jsdata)
        if type(jstable) == "table" then
            local data = jstable["data"]
            local valid = data["valid"]
            if type(data) == "table" and (nil ~= valid and true == valid) then
                local noticelist = data["info"]
                if type(noticelist)  == "table" then
                    cb(true,noticelist)
                end
                return
            end
        end
        cb(false)
    end)
end
--充值积分初始化
function utils.getPayBack(cb)
    local info={}
    local ostime = os.time()
    local url = appdf.HTTP_URL .. "/interface"
    local params = "route=getrechargerebateintegral&userid=" .. GlobalUserItem.dwUserID.."&time=".. ostime .. "&signa=".. GlobalUserItem:getSignature(ostime)
    appdf.onHttpJsionTable(url ,"GET",params,function(jstable,jsdata)
        if type(jstable) == "table" then
            local data = jstable["data"]
            local valid = data["valid"]
            if type(data) == "table" and (nil ~= valid and true == valid) then
                local noticelist = data["rules"]
                local noticeinfo = data["info"]
                if type(noticelist)  == "table" and  type(noticeinfo)  == "table" then
                    table.insert(info,noticelist)
                    table.insert(info,noticeinfo)
                    cb(true,info)
                end
                return
            end
        end
        cb(false)
    end)
end
--充值积分领取记录
function utils.getPayRecord(cb)
    local ostime = os.time()
    local url = appdf.HTTP_URL .. "/interface"
    local params = "route=getrechargerebateintegralrecords&userid=" .. GlobalUserItem.dwUserID.."&time=".. ostime .. "&signa=".. GlobalUserItem:getSignature(ostime)
    appdf.onHttpJsionTable(url ,"GET",params,function(jstable,jsdata)
        if type(jstable) == "table" then
            local data = jstable["data"]
            local valid = data["valid"]
            if type(data) == "table" and (nil ~= valid and true == valid) then
                local noticelist = data["records"]
                if type(noticelist)  == "table" then
                   cb(true,noticelist)
                end
                return
            end
        end
        cb(false)
    end)
end
--充值积分回馈领取地址
function utils.getPayScore(cb)
    local ostime = os.time()
    local url = appdf.HTTP_URL .. "/interface"
    local params = "route=receiverechargerebateintegral&userid=" .. GlobalUserItem.dwUserID.."&time=".. ostime .. "&signa=".. GlobalUserItem:getSignature(ostime)
    appdf.onHttpJsionTable(url ,"GET",params,function(jstable,jsdata)
        if type(jstable) == "table" then
            local data = jstable["data"]
            local valid = data["valid"]
            if type(data) == "table" and (nil ~= valid and true == valid) then
                local noticelist = data["info"]
                if type(noticelist)  == "table" then
                   cb(true,noticelist)
                end
                return
            end
        end
        cb(false)
    end)
end
--转盘界面初始化
function utils.getZpBack(cb)
    local info={}
    local ostime = os.time()
    local url = appdf.HTTP_URL .. "/interface"
    local params = "route=lotteryluckstart&userid=" .. GlobalUserItem.dwUserID.."&time=".. ostime .. "&signa=".. GlobalUserItem:getSignature(ostime)
    appdf.onHttpJsionTable(url ,"GET",params,function(jstable,jsdata)
        if type(jstable) == "table" then
            local data = jstable["data"]
            local valid = data["valid"]
            if type(data) == "table" and (nil ~= valid and true == valid) then
                --dump(data,"datadata")
                local noticelist = data["rules"]
                local noticeinfo = data["info"]
                if type(noticelist)  == "table" and  type(noticeinfo)  == "table" then
                    table.insert(info,noticelist)
                    table.insert(info,noticeinfo)
                    cb(true,info)
                end
                return
            end
        end
        cb(false)
    end)
end
return utils