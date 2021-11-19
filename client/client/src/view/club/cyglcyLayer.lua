local cyglcyLayer = class("cyglcyLayer", function ()
	local cyglcyLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return cyglcyLayer
end)
local AnimationHelper = appdf.req(appdf.EXTERNAL_SRC .. "AnimationHelper")
function cyglcyLayer:ctor(_scene)
    EventMgr.registerEvent(self,"cyglcyLayer")
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Club/Layer/cyglcy.csb", self)
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
	self.pk=self.bj:getChildByName("PK")
	self.p=self.bj:getChildByName("P")
    AnimationHelper.jumpInEx(self.bj, 1)
end
function cyglcyLayer:onButtonClickedEvent(tag,ref)
    if tag == 100 then
         EventMgr:removeEvent("cyglcyLayer")
        self:removeFromParent()
    end
end
function cyglcyLayer:inint(data)
	self.pk:removeAllChildren()
    if data == nil then
        return
	end
	if #data == 0 then
		showToast("没有玩家!",1)
	end
    local counts=math.ceil(#data/4)
	for i=1,counts do
		local item =self.p:clone()
        item:setVisible(true)
		for j =1,4 do
			local name=string.format("p%d",j)
			local it=item:getChildByName(name)
			local player= data[(i-1)*4+j]
			if player ~= nil then
				it:getChildByName("Text_1"):setString(player.userName)
				it:getChildByName("Text_1_0"):setString("ID:"..player.userCode)
                --设置头像
                ExternalFun.createClipHead(it:getChildByName("head"),player.userCode,player.logoUrl,67)
			else
				it:setVisible(false)
			end
		end
		self.pk:pushBackCustomItem(item)
    end
end

function cyglcyLayer:message(code,data)
    if code == HallHead.cyxzcy then
        self:inint(data.result)
    end
end
return cyglcyLayer

