local ClublistLayer = class("ClublistLayer", function ()
	local ClublistLayer =  display.newLayer(cc.c4b(0, 0, 0, 0))
	return ClublistLayer
end)
local HeadSprite = require(appdf.EXTERNAL_SRC .. "HeadSprite")
local TAG={1,2,3,4}
local AnimationHelper = appdf.req(appdf.EXTERNAL_SRC .. "AnimationHelper")
function ClublistLayer:ctor(_scene)
    EventMgr.registerEvent(self,"ClublistLayer")
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Layer/ClublistLayer.csb", self)
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
	self.bj:getChildByName("B_1")
	:setTag(1)
	:addTouchEventListener(btcallback)
    
    self.bj:getChildByName("B_2")
	:setTag(2)
	:addTouchEventListener(btcallback)

    self.bj:getChildByName("B_C")
	:setTag(100)
	:addTouchEventListener(btcallback)

    self.pk=self.bj:getChildByName("PK")
    self.P=self.bj:getChildByName("P")

    -- for i=1 ,30 do
    --     local item=self.P:clone()
    --     self.pk:pushBackCustomItem(item)
    -- end
    self:init()
        --     local height=self.Bottom:getContentSize().height
        -- ExternalFun.nodeMove(self.Bottom, cc.p(x,y-height),cc.p(x,y))
        
    local x,y=self.bj:getPosition()
    self.bj:setPosition(x+self.bj:getContentSize().width,y)
    AnimationHelper.moveOutTo( self.bj, 1, cc.p(x,y))
end
function ClublistLayer:init()
	showWait(10)
	local data={}
	data.userCode=public.userCode
	--发送俱乐部列表
	st.send(HallHead.cxculb,data)
end
--消息处理
function ClublistLayer:inintclub(data)
    self.pk:removeAllChildren()
	if #data ==0 then
		showToast("您尚为加入俱乐部！",1)
	end
	public.initclubinfo(data)
    for k,v in pairs(data) do
    	local btcallback = function (ref, type)
			if type == ccui.TouchEventType.ended then
				--ref:setScale(1)
				ExternalFun.playClickEffect()
				if ref:getTag() == 1 then
					self.scene:entergroup(v)
				elseif ref:getTag() ==  2 then
					local str =string.format("确认退出【%s】俱乐部吗？",v.groupValue)
					QueryExit(str, function (ok)
						if ok == true then
	                		local sdata={}
							sdata.groupCode=v.groupCode
							sdata.userCode=public.userCode
							st.send(HallHead.deculb,sdata)
                            --刷新俱乐部
                            --self.init()
						end
					end,false)
				end
			elseif type == ccui.TouchEventType.began then
				--ref:setScale(public.btscale)
				return true
			elseif type == ccui.TouchEventType.canceled then
				--ref:setScale(1)
			end
		end
        local item=self.P:clone()
        item:getChildByName("T_1"):setString(v.leaderValue)
        item:getChildByName("T_2"):setString("ID:"..v.leaderCode)
        item:getChildByName("T_3"):setString(v.groupValue)
        item:getChildByName("T_4"):setString(v.groupCode)
        item:getChildByName("T_5"):setString(v.chairnum)

        item:getChildByName("B_1"):setTag(2)
        item:getChildByName("B_1"):addTouchEventListener(btcallback)
        
        local headBg=item:getChildByName("head")
        --设置头像
        ExternalFun.createClipHead(headBg,v.leaderCode,v.leaderLogoUrl,67)
        
        --退出联盟按钮
		--if  v.leaderCode  == public.userCode then
			item:getChildByName("B_1"):setVisible(false)
        --end
        item:getChildByName("T_6"):setString(v.groupRoleValue)
        item:setTag(1)
        item:addTouchEventListener(btcallback)
        self.pk:pushBackCustomItem(item)
    end
end
function ClublistLayer:message(code,data)
    if code == HallHead.cxculb  then--创建俱乐部
        self:inintclub(data)
    elseif code == HallHead.deculb or code == HallHead.cjculb then --删除俱乐部并刷新列表
        self:init()
    elseif code ==  HallHead.inculb then --进入俱乐部
        self:onClose()
    end
end
--关闭层
function ClublistLayer:onClose()
    EventMgr.removeEvent("ClublistLayer")
    self:removeFromParent()
end
function ClublistLayer:onButtonClickedEvent(tag,ref)
	--print("创建界面按钮"..tag)
    if tag == 100 then
        --获取大厅公告
        local data={}
        data.userCode=public.userCode 
        st.send(HallHead.GGnotice,data)
        local data ={}
        data.userCode=public.userCode
        st.send(HallHead.upzuanshi,data) 
        function back(...)
            self:onClose()
        end
        local x,y=self.bj:getPosition()
        AnimationHelper.moveOutTo( self.bj, 0.8, cc.p(x+self.bj:getContentSize().width,y),back)        
        
    elseif  tag == 1 then
    	self.scene:onButtonClickedEvent(27,nil)
    elseif  tag == 2 then
    	self.scene:onButtonClickedEvent(29,nil)
    end
end
return ClublistLayer
