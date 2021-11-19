function showToast(message,delaytime,color)

	local curScene = cc.Director:getInstance():getRunningScene()
	delaytime = delaytime or 3
	color = nil

	local msgtype = type(message)
	if msgtype == "userdata" or msgtype == "table" then
		return
	end

	if message == ""  then
		return
	end

	local showMessage = message	
	local lab = nil
	local bg = ccui.ImageView:create("Public/tishikuang.png")

	lab = cc.Label:createWithTTF(showMessage, "font/FZY4JW.TTF", 30)
	lab:setName("toast_lab")
	bg:setScale9Enabled(true)
	local defultBgSize = cc.size(400,bg:getContentSize().height)
	bg:setContentSize(defultBgSize)
	lab:setTextColor(not color and cc.c4b(255,255,255,255) or color)
	lab:addTo(bg)
	bg:setPosition(display.width/2, display.height/2+50)
	curScene:addChild(bg,1000)
	if nil ~= lab and nil ~= bg then
		lab:setString(showMessage)
		lab:setTextColor(not color and cc.c4b(255,255,255,255) or color)
		local labSize = lab:getContentSize()

		if labSize.width > defultBgSize.width-10 then
			bg:setContentSize(cc.size(labSize.width+30, defultBgSize.height))
		end
		lab:move(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.5+6)
	end
	bg:runAction(cc.Sequence:create(
		cc.ScaleTo:create(0.2,1,1), cc.ScaleTo:create(0.1,1,1),cc.CallFunc:create(function()
			lab:setOpacity(255)
			end),
		cc.DelayTime:create(delaytime), 
		cc.Spawn:create(cc.FadeTo:create(0.25,0),cc.CallFunc:create(function()
			lab:runAction(cc.FadeTo:create(0.25,0))
			end))
	))
end
function showWait(datime)

	local curScene = cc.Director:getInstance():getRunningScene()
	local delaytime = 5
    if datime then
        delaytime=datime
    end
	local bg=display.newLayer(cc.c4b(0, 0, 0, 180))
	bg:setName("Wait")
	curScene:addChild(bg,1000)
	-- local popnode =ExternalFun.loadCSB("Layer/WaitNode.csb", bg )
	-- popnode:setPosition(display.width/2, display.height/2+50)
	-- local image=popnode:getChildByName("image")
	-- local rotate1 = cc.RotateBy:create(0.5,90)
	-- local rotate2 = cc.RotateBy:create(1.5,270)
	-- local seq = cc.Sequence:create(rotate1,rotate2)
	-- local repeatforever = cc.RepeatForever:create(seq)
	-- image:runAction(repeatforever)
    
    ExternalFun.addSpineWithCustomNode("Atlas/loading/loading",bg,"animation2",cc.p(display.width/2, display.height/2+50),false)

	--防止卡死
	performWithDelay(curScene, function ()
		if curScene:getChildByName("Wait") then
		 	curScene:getChildByName("Wait"):removeFromParent()
		end
		end,delaytime )
end
function dissWait()

	local curScene = cc.Director:getInstance():getRunningScene()
	if curScene:getChildByName("Wait") then
	 	curScene:getChildByName("Wait"):removeFromParent()
	end
end
function QueryExit(message,cb,cancel)

	local curScene = cc.Director:getInstance():getRunningScene()
	if curScene == nil  then
        return
    end
    if curScene:getChildByName("QueryExit") then
    	return
    end
	local bg=display.newLayer(cc.c4b(0, 0, 0, 180))
	bg:setName("QueryExit")
	curScene:addChild(bg,1000)
	local rootlayer,popnode =ExternalFun.loadRootCSB("Layer/TiShiLayer.csb", bg )
	--popnode:setPosition(display.width/2, display.height/2)
	local btcallback = function (ref, type)
		if type == ccui.TouchEventType.ended then
			ref:setScale(1)
			if ref:getTag() == 1 then
				cb(true)
			else
				cb(false)
			end
			if curScene:getChildByName("QueryExit") then
		 		curScene:getChildByName("QueryExit"):removeFromParent()
			end
		elseif type == ccui.TouchEventType.began then
			ref:setScale(public.btscale)
			return true
		elseif type == ccui.TouchEventType.canceled then
			ref:setScale(1)
		end
	end
	local bj=popnode:getChildByName("bj")
	local btcancel=bj:getChildByName("B_X")
	btcancel:setTag(2)
			:addTouchEventListener(btcallback)
	bj:getChildByName("B_C")
	:setTag(3)
	:addTouchEventListener(btcallback)
	local btsure=bj:getChildByName("B_R")
	btsure:setTag(1)
			:addTouchEventListener(btcallback)
	if cancel then
		local btsurey=btsure:getPositionY()
		btcancel:setVisible(false)
		btsure:move(bj:getContentSize().width * 0.5,btsurey)
	end
	if message then
		bj:getChildByName("T"):setFontSize(30)
		bj:getChildByName("T"):setString(message)
	end

end
function showToast2(context,message,delaytime,color)


	local showMessage = message	
	local tipbg = ccui.ImageView:create("popView/frame_1.png")
	
	tipbg:setAnchorPoint(0.5,0)
	tipbg:setScale9Enabled(true)
	local tipbgSize = tipbg:getContentSize()
	
	local bg_layout = ccui.Layout:create()
	bg_layout:setAnchorPoint(0,0)
	bg_layout:setContentSizei(cc.size(1334,425))
	bg_layout:setPosition(0,325)
	
	
	local lab = nil
	local listView = context:getChildByName("listView")
	local tipbg = ccui.ImageView:create("popView/frame_1.png")

	lab = cc.Label:createWithTTF(showMessage, "fonts/round_body.ttf", 24)
	lab:setName("toast_lab")
	lab:setOpacity(0)
	bg:setScaleY(0)
	bg:setScale9Enabled(true)
	bg:runAction(cc.Sequence:create(cc.ScaleTo:create(0.2,1,-1.2), cc.ScaleTo:create(0.1,1,-1),cc.CallFunc:create(function()
			lab:setOpacity(255)
			end),
		cc.DelayTime:create(delaytime), 
		cc.Spawn:create(cc.FadeTo:create(0.25,0),cc.CallFunc:create(function()
			lab:runAction(cc.FadeTo:create(0.25,0))
			end)), 
			cc.CallFunc:create(function()
				if listView then
					listView:removeLastItem()
					if #listView:getItems() == 0 then
						listView:removeFromParent()
					end
				end
			end)
		))
	
	local defultBgSize = cc.size(400,bg:getContentSize().height)
	bg:setContentSize(defultBgSize)

	
	lab:setTextColor(not color and cc.c4b(255,255,255,255) or color)
	lab:addTo(bg)

	if nil ~= lab and nil ~= bg then
		lab:setString(showMessage)
		lab:setTextColor(not color and cc.c4b(255,255,255,255) or color)
		local labSize = lab:getContentSize()		

		if labSize.width > defultBgSize.width-10 then
			lab:setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
			bg:setContentSize(cc.size(labSize.width+30, defultBgSize.height))
		end
		lab:move(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.5)
	end

	if not listView then
		listView = ccui.ListView:create()
		listView:setAnchorPoint(0.5,0)
		listView:setContentSize(cc.size(display.width,display.height/2+defultBgSize.height))
		listView:setPosition(display.width/2, display.height+defultBgSize.height)
		listView:setDirection(ccui.ScrollViewDir.vertical)
		listView:setGravity(ccui.ListViewGravity.centerHorizontal)
		listView:setBounceEnabled(true)
		listView:setItemsMargin(2)
		listView:setScrollBarEnabled(false)
		listView:setTouchEnabled(false)
		listView:setSwallowTouches(false)
		context:addChild(listView,100)
		listView:setName("listView")
		listView:setScaleY(-1)
	
	end
	listView:insertCustomItem(bg,0)

end
--不渐变形式toast(fadeto方法，在安卓调用的时候会导致底图不显示)
function showToastNoFade(context,message,delaytime,color)
	if (context == nil) or  (message == nil) or (delaytime<1) then
		return
	end

	local msgtype = type(message)
	if msgtype == "userdata" or msgtype == "table" then
		return
	end

	if message == "" then
		return
	end
	local showMessage = message	
	
	local bg = context:getChildByName("toast_bg")
	local lab = nil
	if bg then
		bg:stopAllActions()
		lab = bg:getChildByName("toast_lab")
	else
		bg = ccui.ImageView:create("General/frame_1.png")
		bg:move(appdf.WIDTH/2,appdf.HEIGHT/2)
		bg:addTo(context)
		bg:setName("toast_bg")
		bg:setScale9Enabled(true)		

		lab = cc.Label:createWithTTF(showMessage, "fonts/round_body.ttf", 24, cc.size(930,0))
		lab:setName("toast_lab")
		
		lab:setTextColor(not color and cc.c4b(255,255,255,255) or color)
		lab:addTo(bg)
	end

	if nil ~= lab and nil ~= bg then
		lab:setString(showMessage)
		lab:setTextColor(not color and cc.c4b(255,255,255,255) or color)
		bg:runAction(cc.Sequence:create(cc.DelayTime:create(delaytime), cc.RemoveSelf:create(true)))

		local labSize = lab:getContentSize()
		if labSize.height < 30 then
			lab:setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
			bg:setContentSize(cc.size(appdf.WIDTH, 64))
		else
			lab:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
			bg:setContentSize(cc.size(appdf.WIDTH, 64 + labSize.height))		
		end
		lab:move(appdf.WIDTH * 0.5, bg:getContentSize().height * 0.5)
	end
end