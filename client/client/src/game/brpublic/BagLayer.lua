local BagLayer = class("BagLayer", function ()
	local BagLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return BagLayer
end)
local TAG={1,2,3,4}
function BagLayer:ctor(_scene,clubinfo)
	self.scene=_scene
	self._clubinfo = clubinfo
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Game/brpublicLayer/BagLayer.csb", self)
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
    self.bb={}
	for i = 1, 4 do
		local str =string.format("B_%d",i)
		self.bb[i]=self.bj:getChildByName(str)
		self.bb[i]:setTag(i)
		:addTouchEventListener(btcallback)
	end
    self.p1=self.bj:getChildByName("P1")
    self.p2=self.bj:getChildByName("P2")
    self.p3=self.bj:getChildByName("P3")
    for i = 1, 8 do
		local str =string.format("B%d",i)
		local bb =self.p1:getChildByName(str)
		bb:setTag(i+10)
		:addTouchEventListener(btcallback)
	end
    self.node1 =self.p1:getChildByName("Node1")
    self.node2 =self.p1:getChildByName("Node2")
    local t1=self.node1:getChildByName("Image")
	self.t1 = ExternalFun.cteartTFtwo(t1:getChildByName("Image"),t1,"请输入金额",true,nil,nil,35)
    local t2=self.node2:getChildByName("Image1")
	self.t2 = ExternalFun.cteartTFtwo(t2:getChildByName("Image"),t2,"请输入金额",true,nil,nil,35)   
    local t2=self.node2:getChildByName("Image2")
	self.t21 = ExternalFun.cteartTFtwo(t2:getChildByName("Image"),t2,"请输入取款密码",true,nil,nil,35)
    
    self.node1:getChildByName("B")
        :setTag(21)
        :addTouchEventListener(btcallback)
    
    self.node2:getChildByName("B")
        :setTag(22)
        :addTouchEventListener(btcallback)
    
    self.bj:getChildByName("P3"):getChildByName("B")
        :setTag(31)
        :addTouchEventListener(btcallback)
    self.bj:getChildByName("B_C")
	:setTag(100)
	:addTouchEventListener(btcallback)

    
    local t1=self.p3:getChildByName("T_1")
	self.t31 = ExternalFun.cteartTF(t1,"请输入原密码",nil,nil,true,35)
	self.t31:addTo(self.p3)
    local t1=self.p3:getChildByName("T_2")
	self.t32 = ExternalFun.cteartTF(t1,"请输入新密码",nil,nil,true,35)
	self.t32:addTo(self.p3)
    local t1=self.p3:getChildByName("T_3")
    self.t33 = ExternalFun.cteartTF(t1,"确认新密码",nil,nil,true,35)
	self.t33:addTo(self.p3)
    self:inint()
end
function BagLayer:inintjinbi(data)
    --dump(data,"1背包数据")
    self.p1:getChildByName("T1"):setString(data.gameCoin)
    self.p1:getChildByName("T2"):setString(data.userQianbao)
end
function BagLayer:inint()
    self.select=0
    self.p1:setVisible(true)
    self.p2:setVisible(false)
    self.p3:setVisible(false)
    self.node1:setVisible(false)
    self:sendData()
end
function BagLayer:onButtonClickedEvent(tag,ref)
    --print("选择"..tag)
    if tag == 100 then
        self:removeFromParent()
    elseif tag >=1 and tag < 5 then
    	self:selectB(tag)
    elseif tag >10 and tag <20 then
        if self.select ==1 then
            self.t1:setString(ref:getChildByName("Text_0"):getString())
        elseif self.select == 2 then
            self.t2:setString(ref:getChildByName("Text_0"):getString())
        end
    elseif tag > 20 and tag <30 then
        if self:checking() then
            self:sendData()
        end
    elseif tag ==  31 then
        if self:checkingmima() then
            self:sendData()
        end
    end
end
function BagLayer:checkingmima()
  
    local t1=self.t31:getString()
    local t2=self.t32:getString()
    local t3=self.t33:getString()
    if t1==nil then
		showToast("请输入原密码",2)
		return
	end
    if t2==nil then
		showToast("请输入新密码",2)
		return
	end
    if t3==nil  then
		showToast("请确认密码",2)
		return
	end
    if t2 ~= t3 then
        showToast("新密码和确认密码不一致",2)
		return
    end
	if string.len(t1) < 6 or string.len(t1)> 12
        or string.len(t2) < 6 or string.len(t2)> 12 
        or string.len(t3) < 6 or string.len(t3)> 12 then
		showToast("密码长度不能少于6位或多于12位",2)
		return
    end
       
    return true
end
function BagLayer:checking()
    if self.select == 1 then    --存
        local jinbi=tonumber(self.p1:getChildByName("T1"):getString())
        local t=tonumber(self.t1:getString())

        if t ==nil then
            showToast("请输入存款金额",2)
            return
        elseif t > jinbi then
            showToast("携带金额不足",2)
            return
        end
    elseif self.select == 2 then  --取
        local jinbi=tonumber(self.p1:getChildByName("T2"):getString())
        local t=tonumber(self.t2:getString())
        local t1=self.t21:getString()
        if t==nil then
            showToast("请输入取款金额",2)
            return
        elseif t > jinbi then
            showToast("背包金额不足",2)
            return
        end
        if t1==nil  then
            showToast("请输入密码",2)
            return
        end
        if string.len(t1) < 6 or string.len(t1)> 12 then
            showToast("输入密码不对,请重新输入",2)
            return
        end
    end
    return true
end
function BagLayer:selectB(index)
	if self.bb[index] ==nil then
		return
	end
	for k,v in pairs(self.bb) do
		v:setEnabled(true)
        if k == index then
            v:setEnabled(false)
        end
	end
    self.select=index
    
    if index ==1 then
        self.p2:setVisible(false)
        self.p1:setVisible(true)
        self.p3:setVisible(false)
        self.node1:setVisible(true)
        self.node2:setVisible(false)
        self.t1:setText("")
    elseif index == 2 then
        self.p2:setVisible(false)
        self.p3:setVisible(false)
        self.p1:setVisible(true)
        self.node1:setVisible(false)
        self.node2:setVisible(true)
        self.t2:setText("")
        self.t21:setText("")
    elseif index ==3 then
        self.p2:setVisible(true)
        self.p1:setVisible(false)
        self.p3:setVisible(false)
        self:sendData()
    elseif index ==4 then
        self.t33:setText("")
        self.t32:setText("")
        self.t31:setText("")
        self.p2:setVisible(false)
        self.p1:setVisible(false)
        self.p3:setVisible(true)
    end
   
end
function BagLayer:inintp(data)
    --dump(data,"2背包数据")
    local p=self.p2:getChildByName("P")
    p:removeAllChildren()
    for k,v in pairs(data) do
        local item=self.p2:getChildByName("pk"):clone()
        item:getChildByName("T1"):setString(v.createTime)
        item:getChildByName("T2"):setString(v.lx)
        item:getChildByName("T3"):setString(v.je)
        p:pushBackCustomItem(item)
    end
end
function BagLayer:sendData()
    function Senddata(datas)
        if self.select==0 then
            self.select=2
            self:inintjinbi(datas)
        elseif self.select == 1 then
            local jinbi=tonumber(self.p1:getChildByName("T1"):getString())
            local bjinbi=tonumber(self.p1:getChildByName("T2"):getString())
            local t=tonumber(self.t1:getString())
            self.p1:getChildByName("T1"):setString(jinbi-t)
            self.p1:getChildByName("T2"):setString(bjinbi+t)
        elseif self.select == 2 then
            local jinbi=tonumber(self.p1:getChildByName("T1"):getString())
            local bjinbi=tonumber(self.p1:getChildByName("T2"):getString())
            local t=tonumber(self.t2:getString())
            self.p1:getChildByName("T1"):setString(jinbi+t)
            self.p1:getChildByName("T2"):setString(bjinbi-t)
        elseif self.select == 3 then
            self:inintp(datas)
        elseif self.select == 4 then
            self.t33:setText("")
            self.t32:setText("")
            self.t31:setText("")
            showToast("修改密码成功!",2)
        end
    end
    local httpurl ={HttpHead.qbchaxun,HttpHead.qbzuanru,HttpHead.qbzuanchu,HttpHead.qbjilu,HttpHead.qbmima}
    local url=httpurl[self.select+1]
    local data ={}
    data.userCode = public.userCode
    data.groupCode=self._clubinfo.groupCode
    if self.select == 1 then
        data.je=self.t1:getString()
    elseif self.select == 2 then
        data.je=self.t2:getString()
        data.qianbaoMima=self.t21:getString()
    elseif self.select == 4 then
        data.qianbaoMima=self.t32:getString()
        data.yQianbaoMima=self.t31:getString()
    end
    httpnect.send(url,data,Senddata)
end
return BagLayer

