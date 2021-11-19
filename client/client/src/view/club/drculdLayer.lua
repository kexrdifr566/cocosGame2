local drculdLayer = class("drculdLayer", function ()
	local drculdLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return drculdLayer
end)
local AnimationHelper = appdf.req(appdf.EXTERNAL_SRC .. "AnimationHelper")
function drculdLayer:ctor(_scene)
    EventMgr.registerEvent(self,"drculdLayer")
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Club/Layer/drculd.csb", self)
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
    self.bj:getChildByName("BC")
	:setTag(100)
	:addTouchEventListener(btcallback)
	self.bj:getChildByName("B")
	:setTag(1)
	:addTouchEventListener(btcallback)
	self.pk=self.bj:getChildByName("PK")
	self.p=self.bj:getChildByName("P")
	self.select =0 
     AnimationHelper.jumpInEx(self.bj, 1)
end
function drculdLayer:onButtonClickedEvent(tag,ref)
	if tag == 100 then
        EventMgr.removeEvent("drculdLayer")
		self:removeFromParent()
	elseif tag == 1 then
		if self.select == 0 then
			showToast("没有导入的俱乐部!",1)
			return
		end
		local data={}
		local clubinfo = public.getclubinfo(public.enterclubid)
		data.toGroupCode=clubinfo.groupCode
		data.fromGroupCode=self.groupCode[self.select]
		st.send(HallHead.drcycz,data)
    end
end
function drculdLayer:inint(data)
	self.pk:removeAllChildren()
    if data == nil then
        return
	end
	if #data == 0 then
		showToast("没有导入的俱乐部!",1)
		return
	end
	local btcallback = function (ref, type)
		if type == ccui.TouchEventType.ended then
			ExternalFun.playClickEffect()
			ref:setScale(1)
			self:selectBB(ref:getTag())
		elseif type == ccui.TouchEventType.began then
			ref:setScale(public.btscale)
			return true
		elseif type == ccui.TouchEventType.canceled then
			ref:setScale(1)
		end
	end
	self.BB={}
	self.groupCode={}
	for k,v in pairs(data) do
		local item =self.p:clone()
		item:getChildByName("T1"):setString(v.groupValue)
		item:getChildByName("T2"):setString("ID:"..v.groupCode)
		item:getChildByName("T3"):setString(v.roleValue)
		item:getChildByName("T4"):setString(v.wdrs)
		item:setTag(k)
		item:addTouchEventListener(btcallback)
		self.pk:pushBackCustomItem(item)
		self.BB[k]=item
		self.groupCode[k]=v.groupCode
	end
	self:selectBB(1)
end
function drculdLayer:selectBB(index)
	if self.BB[index] ==nil then
		return
	end
	for k,v in pairs(self.BB) do
		v:setEnabled(true)
        if k == index then
            v:setEnabled(false)
        end
	end
	self.select=index
end
function drculdLayer:message(code,data)
	if HallHead.drcycz == code  then
		showToast("操作成功",1)
		local datas = {}
		local clubinfo = public.getclubinfo(public.enterclubid)
		datas.groupCode=clubinfo.groupCode
		st.send(HallHead.drcy,datas)
		self.scene:selectPage(true)
	elseif HallHead.drcy == code then
		--dump(data,"导入界面")
		self:inint(data.teams)
	end
end
return drculdLayer

