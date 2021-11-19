local messageLayer = class("messageLayer", function ()
	local messageLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return messageLayer
end)
local AnimationHelper = appdf.req(appdf.EXTERNAL_SRC .. "AnimationHelper")
-- local ceshi={{t1="测试文本",t2="测试股测试测试测试！"}}
local TAG={1,2,3,4}
function messageLayer:ctor(_scene)
    EventMgr.registerEvent(self,"messageLayer")
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Layer/messageLayer.csb", self)
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
    self.bj:getChildByName("B_C")
	:setTag(100)
	:addTouchEventListener(btcallback)
	self.neirong = self.bj:getChildByName("neirong")
	self.neirong:setVisible(false)
	self.neirong:getChildByName("B")
	:setTag(1)
	:addTouchEventListener(btcallback)
	self.T=self.neirong:getChildByName("T")
	self.PK=self.bj:getChildByName("PK")

	self.bb={}
	for i = 1, 4 do 
		local str =string.format("B%d",i)
		self.bb[i]=self.bj:getChildByName(str)
		self.bb[i]:setTag(i+10)
		:addTouchEventListener(btcallback)
	end

	self.P=self.bj:getChildByName("P")

	self:selectBandP(1)
    AnimationHelper.jumpInEx(self.bj, 1)
end
function  messageLayer:selectBandP(index)

	if self.bb[index] ==nil then
		return
	end

	self.PK:removeAllChildren()

	for k,v in pairs(self.bb) do
		v:setEnabled(true)
        if k == index then
            v:setEnabled(false)
        end
	end
	if index == 4 then
		self:sendlist()
	elseif index == 1 then
		--self:inintPK(ceshi)
	end
end
--发送刷新消息列表
function messageLayer:sendlist()
	showWait(5)
	local data={}
	data.curtPage=public.curtPage
	data.userCode=public.userCode
	st.send(HallHead.xxculb,data)
end
function messageLayer:onButtonClickedEvent(tag,ref)
    if tag == 100 then
        EventMgr.removeEvent("messageLayer")
        self:removeFromParent()
    elseif tag == 1 then
    	self.neirong:setVisible(false)
    elseif tag <=14 and tag >=11 then
    	self:selectBandP(tag-10)
    end
end
function messageLayer:inintPK(data)

	for k,v in pairs(data) do
		 local item=self.P:clone()
		 local btcallback = function (ref, type)
			if type == ccui.TouchEventType.ended then
				ExternalFun.playClickEffect()
				ref:setScale(1)
				ExternalFun.playClickEffect()
				if ref:getTag() == 1 then
					self.neirong:setVisible(true)
					self.T:setString(v.t2)
				end
			elseif type == ccui.TouchEventType.began then
				ref:setScale(public.btscale)
				return true
			elseif type == ccui.TouchEventType.canceled then
				ref:setScale(1)
			end
		end
		item:getChildByName("B1"):setVisible(false)
        item:getChildByName("B2"):setVisible(false)
		item:getChildByName("T"):setString(v.t1)

		item:setTag(1)
        :addTouchEventListener(btcallback)

		self.PK:pushBackCustomItem(item)
	end
end

function messageLayer:messages(data)
	self.PK:removeAllChildren()
	for k,v in pairs(data) do
		 local item=self.P:clone()
		 local btcallback = function (ref, type)
			if type == ccui.TouchEventType.ended then
				ref:setScale(1)
				ExternalFun.playClickEffect()
				if ref:getTag() == 1 then
					local sdata={}
					sdata.messageId=v.id
					sdata.acceptOrReject=1
					st.send(HallHead.xxcculb,sdata)
					--print("同意")
				elseif ref:getTag() ==  2 then
					--print("拒绝")
					local sdata={}
					sdata.messageId=v.id
					sdata.acceptOrReject=2
					st.send(HallHead.xxcculb,sdata)
				end
			elseif type == ccui.TouchEventType.began then
				ref:setScale(public.btscale)
				return true
			elseif type == ccui.TouchEventType.canceled then
				ref:setScale(1)
			end
		end
		item:getChildByName("B1")
        :setTag(1)
        :addTouchEventListener(btcallback)
        item:getChildByName("B2")
        :setTag(2)
        :addTouchEventListener(btcallback)

        item:getChildByName("T"):setString(v.message)
		self.PK:pushBackCustomItem(item)
	end
end
function messageLayer:message(code,data)
    if code  == HallHead.xxculb then
        self:messages(data)
    elseif  code  == HallHead.xxcculb then
        showToast("消息处理成功！",2)
        self:sendlist(data)
    end
end
return messageLayer
