local linshi = class("linshi", function ()
	local linshi =  display.newLayer()
	return linshi
end)
function linshi:ctor()
	--加载csb资源
	local rootLayer, csbNode = ExternalFun.loadRootCSB( "Layer/HallLayer.csb", self )
	local btcallback = function (ref, type)
		if type == ccui.TouchEventType.ended then
			ref:setScale(1)
			self:onButtonClickedEvent(ref:getTag(),ref)
		elseif type == ccui.TouchEventType.began then
			ref:setScale(public.btscale)
			return true
		elseif type == ccui.TouchEventType.canceled then
			ref:setScale(1)
		end
	end
	--认证
	self.Top:getChildByName("B_R")
	:setTag(1)
	:addTouchEventListener(btcallback)

	-------------------------------------文字提示---------------------------
	showToast("该功能暂时关闭！",1)

	showToast("连接服务器失败",2,cc.c4b(250,0,0,255))

	-------------------------提示框--------------------------------------------
	QueryExit("确认退出游戏吗？", function (ok)
			if ok == true then
				os.exit(0)
			end
		end)
	---------------------------显示等待-----------------------------
	showWait(10)
	---------------------------取消等待-----------------------------
	dissWait()
	---------------------------------------------------------------
	--创建文本输入框 数字/手机号/密码
	local TF=self.P[1]:getChildByName("TF")
	self.TF = ExternalFun.cteartTF(TF,"输入玩家ID",true,nil)
	self.TF:addTo(self.P[1])
	-----------------------------------------格式化
    -- string.format("?token=%s&sign=%s",token,sign)
	                itemm:loadTextureNormal("qiangzhuang.png",ccui.TextureResType.plistType)
                itemm:loadTexturePressed("qiangzhuang1.png",ccui.TextureResType.plistType)
                itemm:loadTextureDisabled("qiangzhuang1.png",ccui.TextureResType.plistType)
       itemm:loadTexture(str,ccui.TextureResType.plistType)
	------------------------------------HTTP发送
    local str = string.format("Game/brpublic/brbj%d.png",bjindex)
	function Senddata(datas)
		public.rzStatus = "1"
		showToast("您已经提成功认证！",1)
		self:removeFromParent()
	end
	  local data={}
	  data.idCard=self.IDCard:getText()
	  data.aliasName=self.xingming:getText()
	  data.token=public.webtoken
	  httpnect.send(HttpHead.UpUserinfo,data,Senddata)
	------------------------------------websocket -------------------
	local sdata={}						--消息处理
	sdata.messageId=data.id
	sdata.acceptOrReject=ref:getTag()
	st.send(HallHead.xxcculb,sdata)

	--------------------------------------------------------------------
	----------------------------读写列表数据
	self.pk=removeAllChildren()
	for k,v in pairs(data) do
		local item = self.P:clone()
		self.pk:pushBackCustomItem(item)
	end
	--------------------------------------------------存储OR读取xml文本
	cc.UserDefault:getInstance():setIntegerForKey("DZBJ", 2)
	cc.UserDefault:getInstance():getIntegerForKey("DZBJ", 1)
	--------------------------------------------------------------------------------
    ---------------------------------------延迟开始
	performWithDelay(self,function ()
		ExternalFun.addArmatureWithCustomNode("hongheidazhan_paixingtexiao",parent)
	end,0.5)

    --------------------------------------------动画监控
    local animation = self.vsanimation:getAnimation()
	animation:play("Animation1")
	animation:setMovementEventCallFunc(function (arm, eventType, movmentID)
		if eventType == ccs. MovementEventType.start then
		elseif eventType == ccs. MovementEventType.complete then
                    self.colorlayer:setVisible(false)
		elseif eventType == ccs. MovementEventType.loopComplete then
		end
	end)
	--------------------------------------------时间流失动画
	self.progress = cc.ProgressTimer:create(display.newSprite("GameHall/bg.jpg"))
	--self.progress:setReverseDirection(true)
	self.progress:setPosition(640,360)
	self:add(self.progress)
	self.progress:setVisible(true)
	self.progress:setPercentage(100)
	self.progress:runAction(cc.Sequence:create(cc.ProgressTo:create(30, 0), cc.CallFunc:create(function()
    	self.progress:setVisible(false)
    	end)))
	--------------------------------------------------------------------
	-----------------------------添加按钮列表 ·4(⊙o⊙)4
	local listcallback = function (index)
			self:onListClickedEvent(index)
	end
	self.btnlist=ExternalFun.BtnList(self.tc:getChildByName("BT"),btn,listcallback)
	self.tc:addChild(self.btnlist)
	self.btnlist:setVisible(false)
	---------------------------------------------------
        local str ="coin_icon.png"
        local puke = CCSpriteFrameCache:getInstance():getSpriteFrame(str)
        local pgold =  CCSprite:createWithSpriteFrame(puke)
    
            local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(str)
        puke:setSpriteFrame(frame)
	--------------------------------------转化时间 OR 前几天--------------------------------------
    ExternalFun.addSpineWithCustomNode("Atlas/hall/wodelianmeng",self.Middle:getChildByName("B_B"),"animation",cc.p(70,196),false)
    puke:loadTexture(str,ccui.TextureResType.plistType)
	os.date("%Y-%m-%d %H:%M:%S",createTime/1000)  -- 转化时间
	data.date=ExternalFun.day_step(os.date("%Y-%m-%d"),0) --今天
	------------------------------------------------------------------------------------
	------------------
	self:removeFromParent()  ---从父节点把自己删除
	-------------------------
	self:removeAllChildren() --删除自己以及下面的所有节点
    
    local EventMgr=appdf.req(appdf.NETCENT_SRC..".EventMgr")              --分发层
    --添加事件
    EventMgr:registerEvent(self,"HallScene")
    EventMgr:removeEvent("ClublistLayer")
    local AnimationHelper = appdf.req(appdf.EXTERNAL_SRC .. "AnimationHelper")
    AnimationHelper.jumpInEx(self.bj, 1)
--关闭层
function ClublistLayer:onClose()
    EventMgr:removeEvent("ClublistLayer")

    self:removeFromParent()
end
function HallScene:message(code,data)
end

        --扩展目录
		appdf.EXTERNAL_SRC							= "client.src.external."
		--游戏目录
		appdf.GAME_SRC								= "client.src.game."
		--网络处理目录
		appdf.NETCENT_SRC                           = "client.src.netcent."
		--界面目录
		appdf.VIEW                           		= "client.src.view."
		--公用界面
		appdf.PUBLIC                           		= "client.src.public."
		--公用界面
		appdf.CLUB                           		= "client.src.club."
end

---时间动画


return linshi