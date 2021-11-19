local NoticeLayer = class("NoticeLayer", function ()
	local NoticeLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return NoticeLayer
end)
local AnimationHelper = appdf.req(appdf.EXTERNAL_SRC .. "AnimationHelper")
local TAG={1,2,3,4}
function NoticeLayer:ctor(_scene,clubinfo)
	self.scene=_scene
	self._clubinfo = clubinfo
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Club/Layer/NoticeLayer.csb", self)
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
	self.bj:getChildByName("B_1")
	:setTag(1)
	:addTouchEventListener(btcallback)
	self.bj:getChildByName("B_2")
	:setTag(2)
	:addTouchEventListener(btcallback)
	self.T=self.bj:getChildByName("T")

 	self.TF = ccui.EditBox:create(self.T:getContentSize(), ccui.Scale9Sprite:create())
		:setPosition(self.T:getPosition())
		:setFontSize(self.T:getFontSize())
		:setFontName("font/FZY4JW.TTF")
		:setFontColor(cc.c3b(159, 138, 118))
		:addTo(self.bj)
	self.TF:setVisible(false)
	if clubinfo.groupRoleCode  == public.culbCode.qunzhu or clubinfo.groupRoleCode  == public.culbCode.fuqunzhu  then  
		self.bj:getChildByName("B_1"):setVisible(true)
		self.bj:getChildByName("B_2"):setVisible(true)
    else
        self.bj:getChildByName("B_1"):setVisible(false)
		self.bj:getChildByName("B_2"):setVisible(false)
	end
	self.T:setString("")
	self:getNotice()
     AnimationHelper.jumpInEx(self.bj, 1)
end
function NoticeLayer:inindata(notice)
	self.T:setVisible(true)
	self.TF:setVisible(false)
	self.T:setString(notice)
	self.TF:setText(notice)
end
function NoticeLayer:getNotice()
	function Senddata(datas)
        if datas and datas.notice then
            self:inindata(datas.notice)
        end
	end
	local data={}
	data.groupCode=self._clubinfo.groupCode
	--发送
	httpnect.send(HttpHead.GetClubNotice,data,Senddata)
end
function NoticeLayer:upNotice()
	function Senddata(datas)
		self:getNotice()
	end
	local data={}
	data.groupCode=self._clubinfo.groupCode
	data.notice = self.TF:getText()
	--发送
	httpnect.send(HttpHead.UpClubNotice,data,Senddata)
end
function NoticeLayer:onButtonClickedEvent(tag,ref)
    if tag == 100 then
        self:removeFromParent()
    elseif tag == 1 then
    	self.T:setVisible(false)
    	self.TF:setText(self.T:getString())
    	self.TF:setVisible(true)
    elseif tag == 2 then
    	self:upNotice()
    end
end
return NoticeLayer

