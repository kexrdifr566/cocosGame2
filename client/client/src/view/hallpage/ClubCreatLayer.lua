local ClubCreatLayer = class("ClubCreatLayer", function ()
	local ClubCreatLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return ClubCreatLayer
end)
local AnimationHelper = appdf.req(appdf.EXTERNAL_SRC .. "AnimationHelper")
function ClubCreatLayer:ctor(_scene,index)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Layer/ClubCreatLayer.csb", self)
	self.bj=csbNode:getChildByName("bj")
    local btcallback = function (ref, type)
		if type == ccui.TouchEventType.ended then
			ExternalFun.playClickEffect()
			ref:setScale(1)
			self:onButtonClickedEvent(ref:getTag(),ref)
		elseif type == ccui.TouchEventType.began then
			ref:setScale(public.btscale)
			return true
		elseif type == ccui.TouchEventType.canceled then
			ref:setScale(1)
		end
	end
    self.b={}
	self.b[1]=self.bj:getChildByName("B_1")
	self.b[1]:setTag(1)
	:addTouchEventListener(btcallback)
	self.b[2]=self.bj:getChildByName("B_2")
	self.b[2]:setTag(2)
    :addTouchEventListener(btcallback)
    self.p={}
	self.p[1]=self.bj:getChildByName("P_1")
	self.p[2]=self.bj:getChildByName("P_2")

    self.bj:getChildByName("B_C")
	:setTag(100)
	:addTouchEventListener(btcallback)

	--P1
	-- local editHanlder = function(event,editbox)
 --        self:onEditEvent(event,editbox)
 --    end

	local I2=self.p[1]:getChildByName("T")
	self.ttt = ExternalFun.cteartTF(I2,"俱乐部名称",nil,nil)
	self.ttt:addTo(self.p[1])

	self.p[1]:getChildByName("B")
	:setTag(11)
	:addTouchEventListener(btcallback)

    --P2
    self.p[2]:getChildByName("B")
	:setTag(12)
	:addTouchEventListener(btcallback)
	self.T=self.p[2]:getChildByName("T")
	self.T:setString("")

    self.p[2]:getChildByName("B")
	:setTag(12)
	:addTouchEventListener(btcallback)
    --数字键盘
    self.p[2]:getChildByName("IN"):getChildByName("0")
	:setTag(20)
	:addTouchEventListener(btcallback)
    self.p[2]:getChildByName("IN"):getChildByName("1")
	:setTag(21)
	:addTouchEventListener(btcallback)
    self.p[2]:getChildByName("IN"):getChildByName("2")
	:setTag(22)
	:addTouchEventListener(btcallback)
    self.p[2]:getChildByName("IN"):getChildByName("3")
	:setTag(23)
	:addTouchEventListener(btcallback)
    self.p[2]:getChildByName("IN"):getChildByName("4")
	:setTag(24)
	:addTouchEventListener(btcallback)
    self.p[2]:getChildByName("IN"):getChildByName("5")
	:setTag(25)
	:addTouchEventListener(btcallback)
    self.p[2]:getChildByName("IN"):getChildByName("6")
	:setTag(26)
	:addTouchEventListener(btcallback)
    self.p[2]:getChildByName("IN"):getChildByName("7")
	:setTag(27)
	:addTouchEventListener(btcallback)
    self.p[2]:getChildByName("IN"):getChildByName("8")
	:setTag(28)
	:addTouchEventListener(btcallback)
    self.p[2]:getChildByName("IN"):getChildByName("9")
	:setTag(29)
	:addTouchEventListener(btcallback)
    self.p[2]:getChildByName("IN"):getChildByName("SET")
	:setTag(30)
	:addTouchEventListener(btcallback)
    self.p[2]:getChildByName("IN"):getChildByName("DEL")
	:setTag(31)
	:addTouchEventListener(btcallback)
	--初始化界面
	self:onButtonClickedEvent(index,nil)
    AnimationHelper.jumpInEx(self.bj, 1)
end
function ClubCreatLayer:onButtonClickedEvent(tag,ref)
	--print("创建俱乐部界面按钮"..tag)
    if tag == 100 then
        -- local data={}
        -- data.userCode=public.userCode
        --发送俱乐部列表
        -- st.send(HallHead.cxculb,data) 
        self:removeFromParent()
    elseif  tag == 1 or tag == 2 then
    	ExternalFun.selectBandP(self.b,self.p,tag)
    	self.ttt:setText("")
    	self.T:setString("")
    elseif tag == 11 then--发送创建俱乐部
    	self:sendone()
    elseif tag == 12 then --发送加入俱乐部消息
        self:sendtwo()
    elseif tag >= 20 and tag <= 31 then
    	self:setNun(tag-20)
    end
end
function ClubCreatLayer:setNun(index)
	local number= self.T:getString()
    if index >= 0 and index < 10 then
        number=number..index
        if #number >8 then
            showToast("请正确输入俱乐部邀请码",1)
            return
        end
    elseif index == 10 then
    	number=""
   	elseif index == 11 then
   		number=string.sub(number, 1, -2)
    end
    self.T:setString(number)
end
function ClubCreatLayer:onEditEvent(event,editbox)
    -- local src = editbox:getText()
    -- if event == "began" then
    --     self.ttt = string.len(src) ~= 0
    -- elseif event == "changed" then
    --     self.ttt = string.len(src) ~= 0
    -- end
end
function ClubCreatLayer:sendtwo()
	function Senddata(datas)
		--showToast("申请成功,请等待处理!",1)
        local data={}
        data.userCode=public.userCode
        --发送俱乐部列表
        st.send(HallHead.cxculb,data) 
	end
	local data={}
	data.userCode=public.userCode
	data.userName=public.userName
	data.yqm=self.T:getString()
	--发送
	httpnect.send(HttpHead.JoinCulb,data,Senddata)
	--showWait(10)
end
function ClubCreatLayer:sendone()
 --    if public.createGroupZs == nil then
 --        showToast("您没有权限，请联系客服！",1)
 --        return
 --    end
	-- if public.zsCoin < public.createGroupZs then
	-- 	showToast("钻石不够。请检查！",1)
 --        return
	-- end
	local chatstr = self.ttt:getText()
	chatstr = string.gsub(chatstr, " " , "")
    if ExternalFun.stringLen(chatstr) > 33  then
        showToast("输入昵称过长",1)
    	return
    end
    if ExternalFun.stringLen(chatstr) ==nil or ExternalFun.stringLen(chatstr) < 2  then
		showToast("输入昵称太短",1)
    	return
    end
    --判断emoji
    if ExternalFun.isContainEmoji(chatstr) then
        showToast(self, "昵称内容包含非法字符,请重试", 2)
        return
    end

    --敏感词过滤
    if true == ExternalFun.isContainBadWords(chatstr) then
        showToast(self, "昵称内容包含敏感词汇!", 2)
        return
    end

	if "" ~= chatstr then
		local data={}
		data.groupValue=chatstr
		data.userCode=public.userCode
		data.userName=public.userName
		st.send(HallHead.cjculb,data)
		--showWait()
	end
end
return ClubCreatLayer
