local joinroomLayer = class("joinroomLayer", function ()
	local joinroomLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return joinroomLayer
end)
local TAG={1,2,3,4}
function joinroomLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Layer/joinroomLayer.csb", self)
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
    for i=0,9 do
        local str =string.format("B_%d",i)
        self.bj:getChildByName(str)
        :setTag(i)
        :addTouchEventListener(btcallback)
    end
    self.Alindex=0 
    self.AL={}
    for i=1,6 do
        local str =string.format("AL_%d",i)
        self.AL[i]= self.bj:getChildByName(str)
    end
    
    self.bj:getChildByName("B_delete")
	:setTag(21)
	:addTouchEventListener(btcallback)
    
    self.bj:getChildByName("B_reInput")
	:setTag(22)
	:addTouchEventListener(btcallback)
end
function joinroomLayer:onButtonClickedEvent(tag,ref)
    if tag == 100 then
        self:removeFromParent()
    elseif tag <10  then
        self:isnumber(tag)
    elseif tag ==21 then
        self:isnumber(nil,true)
    elseif tag == 22 then
        self:isnumber(nil,nil,true)
    end
end
function joinroomLayer:isnumber(num,del,reInput)
    if reInput then
        self.Alindex=0 
        for i=1,6 do
            self.AL[i]:setString("")
        end
        return
    end
    if del then
        if self.Alindex > 0 then 
            self.AL[self.Alindex]:setString("")
            self.Alindex=self.Alindex-1
        end
        return
    end
    if self.Alindex <= 6 then
        self.Alindex=self.Alindex+1
        self.AL[self.Alindex]:setString(num)
        if self.Alindex == 6 then
            self:GetFindRoom()
        end
    end
end
--查询是否再房间内
function joinroomLayer:GetFindRoom()
    -- function Senddata(datas)
    --     if datas.msg then
    --         showToast(datas.msg,2)
    --     else
    --         self.scene:GetLockRoomRes(datas)
    --     end
    -- end
    -- local str = ""
    -- for i=1,6 do
    --     str=str..self.AL[i]:getString()
    -- end
    
    -- local data={}
    -- data.userCode=public.userCode
    -- data.roomCode=str
    --发送
    -- httpnect.send(HttpHead.findroom,data,Senddata)
end
return joinroomLayer

