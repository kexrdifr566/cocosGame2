local RankLayer = class("RankLayer", function ()
	local RankLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return RankLayer
end)
local TAG={
	HttpHead.Rankju,
	HttpHead.Rankda,
	HttpHead.Rankji,
	HttpHead.Ranktu,
	HttpHead.Rankfu,
}
local TAGName={
	"局数",
	"赢分",
	"金币",
	"积分",
	"负分",
}
function RankLayer:ctor(_scene,groupCode)
	self.groupCode=groupCode
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Club/Layer/RankLayer.csb", self)
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

	self.bb={}
	for i = 1, 5 do
		local str =string.format("B_%d",i)
		self.bb[i]=self.bj:getChildByName(str)
		self.bb[i]:setTag(i)
		:addTouchEventListener(btcallback)
	end
	self.tb={}
	for i = 1, 3 do
		local str =string.format("B_%d",i+5)
		self.tb[i]=self.bj:getChildByName(str)
		self.tb[i]:setTag(i+10)
		:addTouchEventListener(btcallback)
	end
	self.PK=self.bj:getChildByName("PK")
	self.P=self.bj:getChildByName("P")

	-- self:selectB(1)
	-- self:selectT(1)
	self.setectRank=1
	self.setcetTime=1
	self.bb[1]:setEnabled(false)
	self.tb[1]:setEnabled(false)
	self:GetRank()
end
function RankLayer:onButtonClickedEvent(tag,ref)
    if tag == 100 then
        self:removeFromParent()
    elseif tag >=1 and tag <6 then
    	self:selectB(tag)
    elseif tag > 10 and tag <= 13 then
    	self:selectT(tag-10)
    end
end
function RankLayer:selectB(index)
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
	--隐藏该隐藏的按钮
	for k,v in pairs(self.tb) do
        v:setEnabled(true)
  	end

	self.setcetTime=1
	self.setectRank=index
	self.tb[1]:setEnabled(false)
	self:GetRank()
end
function RankLayer:selectT(index)
	if self.tb[index] ==nil then
		return
	end
	self.PK:removeAllChildren()
	for k,v in pairs(self.tb) do
		v:setEnabled(true)
        if k == index then
            v:setEnabled(false)
        end
	end
	self.setcetTime=index
	self:GetRank()
end
function RankLayer:initPK(data)
    self.PK:removeAllChildren()
	for k,v  in pairs(data) do
		local item=self.P:clone()
		if k >3 then
			item:getChildByName("I"):setVisible(false)
			item:getChildByName("T1"):setString(k)
		else
			item:getChildByName("T1"):setVisible(false)
			local str=string.format("Culb/rank/img_%d.png",k)
			item:getChildByName("I"):loadTexture(str)
		end
		item:getChildByName("T2"):setString(v.userName)
		item:getChildByName("T3"):setString(ExternalFun.showUserCode(v.userCode))
		item:getChildByName("T4"):setString(v.coin)
        local headbg=item:getChildByName("Image_1")
        --设置头像
        ExternalFun.createClipHead(headbg,v.userCode,v.logoUrl,60)
		self.PK:pushBackCustomItem(item)
	end
end

function RankLayer:GetRank()
	self.bj:getChildByName("T3"):setString(TAGName[self.setectRank])
	function Senddata(datas)
		self:initPK(datas)
	end
	local data={}
	data.groupCode=self.groupCode
	local lindate = os.date("%Y-%m-%d")
	if self.setcetTime == 1 then
		data.searchDate=ExternalFun.day_step(os.date("%Y-%m-%d"),0)
	elseif self.setcetTime == 2 then
		data.searchDate=ExternalFun.day_step(os.date("%Y-%m-%d"),-1)
	elseif self.setcetTime == 3 then
		data.searchDate=ExternalFun.day_step(os.date("%Y-%m-%d"),-2)
	end
	--发送
	httpnect.send(TAG[self.setectRank],data,Senddata)
end
return RankLayer

