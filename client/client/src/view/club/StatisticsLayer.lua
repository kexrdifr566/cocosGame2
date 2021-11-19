local StatisticsLayer = class("StatisticsLayer", function ()
	local StatisticsLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return StatisticsLayer
end)
local riqiLayer=appdf.req(appdf.VIEW.."club.riqiLayer")
function StatisticsLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Club/Layer/StatisticsLayer.csb", self)
	self.bj=csbNode:getChildByName("bj")
	self.tc=csbNode:getChildByName("tc")
	self.xq=csbNode:getChildByName("xq")
	self.jutixq=csbNode:getChildByName("jutixq")
    local btcallback = function (ref, type)
		if type == ccui.TouchEventType.ended then
			ExternalFun.playClickEffect()
            if ref:getTag() ~=5 and ref:getTag() ~= 6 then
                ref:setScale(1)
            end
			self:onButtonClickedEvent(ref:getTag(),ref)
		elseif type == ccui.TouchEventType.began then
			if ref:getTag() ~= 105 and (ref:getTag() ~=5 and ref:getTag() ~= 6) then
				ref:setScale(public.btscale)
			end
			return true
		elseif type == ccui.TouchEventType.canceled then
			if ref:getTag() ~=5 and ref:getTag() ~= 6 then
                ref:setScale(1)
            end
		end
	end
	----------------------bj----------------------------s
	self.setbjTime=1
    self.bj:getChildByName("B_C")
	:setTag(100)
	:addTouchEventListener(btcallback)
	self.bj:getChildByName("B")
	:setTag(4)
	:addTouchEventListener(btcallback)
	self.bjBB={}
	for i = 1, 3 do
		local str =string.format("B%d",i)
		self.bjBB[i]=self.bj:getChildByName(str)
		self.bjBB[i]:setTag(i)
		:addTouchEventListener(btcallback)
	end
	self.bj:getChildByName("B_1")
	:setTag(5)
	:addTouchEventListener(btcallback)
	self.bj:getChildByName("B_2")
	:setTag(6)
	:addTouchEventListener(btcallback)
	self.bjpk=self.bj:getChildByName("PK")
	self.bjp=self.bj:getChildByName("P")
	local TF=self.bj:getChildByName("TF")
	self.TF = ExternalFun.cteartTF(TF,"输入ID",true,nil)
	self.TF:addTo(self.bj)

	self.back= self.bj:getChildByName("BH")
	self.back:setTag(7)
	:addTouchEventListener(btcallback)
	self.back:setVisible(false)

	-------------------------tc----------------------
	self.tc:getChildByName("B_C")
	:setTag(200)
	:addTouchEventListener(btcallback)
	self.tcBB={}
	for i = 1, 3 do
		local str =string.format("B%d",i)
		self.tcBB[i]=self.tc:getChildByName(str)
		self.tcBB[i]:setTag(i+100)
		:addTouchEventListener(btcallback)
	end
	self.tcBB[1]:setEnabled(false)
	self.tc:getChildByName("B")
	:setTag(104)
	:addTouchEventListener(btcallback)

	self.tcpk=self.tc:getChildByName("PK")
	self.ttcp=self.tc:getChildByName("PP")

	local TF=self.tc:getChildByName("TF")
	self.TF2 = ExternalFun.cteartTF(TF,"输入ID",true,nil)
	self.TF2:addTo(self.tc)

	-------------------------xq----------------------

	self.xq:getChildByName("B_C")
	:setTag(300)
	:addTouchEventListener(btcallback)


	self.jutixq:getChildByName("B_C")
	:setTag(400)
	:addTouchEventListener(btcallback)

	
	--初始化界面
	self.tc:setVisible(false)
	self.xq:setVisible(false)
	self.jutixq:setVisible(false)
	
	self.tableuser=public.userCode
	--table.insert(self.tableuser,public.userCode)

	self.riqi= os.date("%Y-%m-%d")
	self:reriqi()
	self.page =1
	self:selectbjBB(1)
	self.ble = false
	self.setcetTime= 1
    self.xqpage=1
end
function StatisticsLayer:reriqi()
	self.bj:getChildByName("B"):getChildByName("T1_0"):setString(self.riqi)
end
function StatisticsLayer:onButtonClickedEvent(tag,ref)
	print("界面按下"..tag)
    if tag == 100 then
        self:removeFromParent()
	elseif tag >= 1 and tag <=3 then
    	self:selectbjBB(tag)
	elseif tag == 4 then -- 打开时间层
		local layer =riqiLayer:create(self)
		self:add(layer)
	elseif tag == 5 then
		self:GetjtXq()
	elseif tag == 6 then
		if ExternalFun.checkTFID(self.TF) then
			self:GetBjdata(true)
		end
	elseif tag == 7 then
		self.tableuser=public.userCode
		self.page = 1
		self.back:setVisible(false)
		self:GetBjdata()
    --查询下级某个人的ID
   	----------------------------------------TC-------------------------------
   	elseif tag >= 101 and tag <=103 then
   		self:selectttBB(tag-100)
   	elseif tag == 104 then
   	elseif tag == 200 then
		self.tc:setVisible(false)
		for k,v in pairs(self.tcBB) do
			v:setEnabled(true)	
		end
		self.tcBB[1]:setEnabled(false)
	elseif tag== 300 then
		self.xq:setVisible(false)
	elseif tag == 400 then
		self.jutixq:setVisible(false)
    end
end
function StatisticsLayer:selectbjBB(index)
	if self.bjBB[index] ==nil then
		return
	end
	--self.PK:removeAllChildren()
	for k,v in pairs(self.bjBB) do
		v:setEnabled(true)
        if k == index then
            v:setEnabled(false)
        end
	end

	if index == 1 then
		self.riqi=ExternalFun.day_step(os.date("%Y-%m-%d"),0)
	elseif index == 2 then
		self.riqi=ExternalFun.day_step(os.date("%Y-%m-%d"),-1)
	elseif index == 3 then
		self.riqi=ExternalFun.day_step(os.date("%Y-%m-%d"),-2)
	end
	self:reriqi()
	self:GetBjdata()
end
function StatisticsLayer:GetXq(userCode)
	function Senddata(datas)
		self:initgxq(datas)
		self.xq:setVisible(true)
	end

	local clubinfo = public.getclubinfo(public.enterclubid)
	local data={}
	data.groupCode=clubinfo.groupCode
	data.userCode = userCode
	data.date=self.riqi
    data.page=self.xqpage
	--发送
	httpnect.send(HttpHead.tjwjxq,data,Senddata)
end
function StatisticsLayer:initgxq(data)

	self.xq:getChildByName("T1"):setString(data.userName.."("..data.userCode..")")
	self.xq:getChildByName("T2"):setString(data.data)
	self.xq:getChildByName("T3"):setString(data.gameCoin)
	self.xq:getChildByName("T4"):setString(data.brokerageCoin)
    local pk =self.xq:getChildByName("PK")
	local PP = self.xq:getChildByName("PP")
	pk:removeAllChildren()
	
	for k,v in pairs(data.datas) do
        --dump(v,"会员个人信息")
		local item=PP:clone()
		item:getChildByName("T1"):setString(v.createTime)
		item:getChildByName("T2"):setString(v.tableid)
		item:getChildByName("T3"):setString(data.scale)
		item:getChildByName("T4"):setString(v.brokerageCoin)
		pk:pushBackCustomItem(item)
	end
end
function StatisticsLayer:GetBjdata(ble,team)

	function Senddata(datas)
		if datas.myinfo and datas.teams then
		self:initbj( datas.myinfo)
		self:initbjdata( datas.teams)
		end
	end
	local clubinfo = public.getclubinfo(public.enterclubid)
	local userCode= self.tableuser
	if ble then
		userCode=self.TF:getText()
	end
	local data={}
	data.groupCode=clubinfo.groupCode
	data.userCode = userCode
	data.date=self.riqi
	--发送
	if team then
		httpnect.send(HttpHead.tjshouteam,data,Senddata)
	else
		httpnect.send(HttpHead.tjshou,data,Senddata)
	end
end
function StatisticsLayer:initbj(data)
	local str = data.userName.."("..data.userCode..")"
	self.tableuser =data.userCode 
	self.bj:getChildByName("T_1"):setString(str)
	str="总人数:"..data.wdrs
	self.bj:getChildByName("T_2"):setString(str)
	str="当日所得赠送分:"
	self.bj:getChildByName("T_4"):setString(str)
end
function StatisticsLayer:initbjdata(data)
	self.bjpk:removeAllChildren()
	--dump(data,"会员信息")
	for k,v in pairs(data) do
		local item=self.bjp:clone()
        local btcallback = function (ref, type)
			if type == ccui.TouchEventType.ended then
				ref:setScale(1)
				ExternalFun.playClickEffect()
				if ref:getTag() == 1 then
					self.page=2
					self.tableuser =v.userCode
					self:GetBjdata(nil,true)
				elseif ref:getTag() == 2 then
					self.setcetTime=1
					self:Gettcdata(v.userCode)
				elseif ref:getTag()  == 3 then
					self:GetXq(v.userCode)
	            end
			elseif type == ccui.TouchEventType.began then
				ref:setScale(public.btscale)
				return true
			elseif type == ccui.TouchEventType.canceled then
				ref:setScale(1)
	        end
	    end
        item:getChildByName("B_1")
        :setTag(1)
        :addTouchEventListener(btcallback)
        item:getChildByName("B_2")
        :setTag(2)
		:addTouchEventListener(btcallback)
		item:getChildByName("B_3")
		:setTag(3)
		:addTouchEventListener(btcallback)
		if self.page == 1 then
			item:getChildByName("B_3"):setVisible(false)
			
		else
			item:getChildByName("B_1"):setVisible(false)
			item:getChildByName("B_2"):setVisible(false)
		end
		
		item:getChildByName("T_1"):setString(v.userName)
		item:getChildByName("T_6"):setString("ID:"..v.userCode)
		item:getChildByName("T_2"):setString(v.wdrs)
		item:getChildByName("T_3"):setString(v.brokerageCoin)
		item:getChildByName("T_4"):setString(v.gameCoin)
		item:getChildByName("T_5"):setString(v.manageCoin)
        
        local headbg=item:getChildByName("head")
        --设置头像
        ExternalFun.createClipHead(headbg,v.userCode,v.logoUrl,67)

		self.bjpk:pushBackCustomItem(item)
	end
	if self.page == 1 then
		self.back:setVisible(false)
	else
		self.back:setVisible(true)
	end
end
function StatisticsLayer:selectttBB(index)
	if self.tcBB[index] ==nil then
		return
	end
	for k,v in pairs(self.tcBB) do
		v:setEnabled(true)
        if k == index then
            v:setEnabled(false)
        end
	end
	self.setcetTime=index
	self:Gettcdata()
end
function StatisticsLayer:Gettcdata(userCode)
	function Senddata(datas)
		self:inittc(datas)
		self.tc:setVisible(true)
	end
	if userCode then
		self.ttuserCode=userCode
	end
	local clubinfo = public.getclubinfo(public.enterclubid)
	local data={}
	data.groupCode=clubinfo.groupCode
	data.userCode = self.ttuserCode
	data.coinType ="manageCoin"
	local lindate = os.date("%Y-%m-%d")
	if self.setcetTime == 1 then
		data.date=ExternalFun.day_step(os.date("%Y-%m-%d"),0)
	elseif self.setcetTime == 2 then
		data.date=ExternalFun.day_step(os.date("%Y-%m-%d"),-1)
	elseif self.setcetTime == 3 then
		data.date=ExternalFun.day_step(os.date("%Y-%m-%d"),-2)
	end
	--发送
	httpnect.send(HttpHead.tjcx,data,Senddata)
end
function StatisticsLayer:inittc(data)
	self.tcpk:removeAllChildren()
	--dump(data,"会员信息")
	local addscore=0
	local jianscore = 0
	for k,v in pairs(data) do
		local item=self.ttcp:clone()
		item:getChildByName("T1"):setString(v.createTime)
		item:getChildByName("T2"):setString(v.userName)
		item:getChildByName("T3"):setString("ID:"..v.userCode)
        local headbg=item:getChildByName("I1")
        --设置头像
        ExternalFun.createClipHead(headbg,v.userCode,v.logoUrl,67)
        
		if v.rechargeCoins >= 0 then
			item:getChildByName("T6"):setColor(cc.c3b(239,97,18))
		else
			item:getChildByName("T6"):setColor(cc.c3b(0,187,27))
		end
		item:getChildByName("T6"):setString(v.rechargeCoins)
		
		--item:getChildByName("T7"):setString(v.createTime)
		if v.userCode == v.toUserCode then
			item:getChildByName("T7"):setString("游戏分")
		end
		if v.toUserCode  == v.userCode then
			if v.rechargeCoins >= 0 then
				item:getChildByName("T4"):setString("前:"..v.startgamecoin)
				item:getChildByName("T5"):setString("后:"..v.endgamecoin)
				item:getChildByName("T7"):setString("游戏分")
				item:getChildByName("j2"):setVisible(false)
				item:getChildByName("T11"):setString("前:"..v.startmanagecoin)
				item:getChildByName("T12"):setString("后:"..v.endmanagecoin)
			else
				item:getChildByName("T4"):setString("前:"..v.startmanagecoin)
				item:getChildByName("T5"):setString("后:"..v.endmanagecoin)
				item:getChildByName("T8"):setString("游戏分")
				item:getChildByName("j1"):setVisible(false)
				item:getChildByName("T11"):setString("前:"..v.startgamecoin)
				item:getChildByName("T12"):setString("后:"..v.endgamecoin)
			end
		else
			if v.rechargeCoins >= 0 then
				item:getChildByName("j1"):setVisible(false)
			else
				item:getChildByName("j2"):setVisible(false)
			end
			item:getChildByName("T4"):setString("前:"..v.startmanagecoin)
			item:getChildByName("T5"):setString("后:"..v.endmanagecoin)
			item:getChildByName("T11"):setString("前:"..v.tousercoinstart)
			item:getChildByName("T12"):setString("后:"..v.tousercoinend)
		end

		item:getChildByName("T9"):setString(v.toUserName)
		item:getChildByName("T10"):setString("ID:"..v.toUserCode)
        local headbg=item:getChildByName("I2")
        --设置头像
        ExternalFun.createClipHead(headbg,v.toUserCode,v.toUserlogoUrl,67)
		
		if v.rechargeCoins >= 0 then
			addscore=addscore+v.rechargeCoins
		else
			jianscore=jianscore+v.rechargeCoins
		end
		self.tcpk:pushBackCustomItem(item)
	end
	self.tc:getChildByName("T1"):setString("加管理分:"..addscore)
	self.tc:getChildByName("T2"):setString("减管理分:"..jianscore)
end
function StatisticsLayer:GetjtXq()
	function Senddata(datas)
		self:initxq(datas)
		self.jutixq:setVisible(true)
	end
	local clubinfo = public.getclubinfo(public.enterclubid)
	local data={}
	data.groupCode=clubinfo.groupCode
	data.userCode = self.tableuser
	data.date=self.riqi
	--发送
	httpnect.send(HttpHead.jtwjxq,data,Senddata)
end
function StatisticsLayer:initxq(data)
    --dump(data,"会员信息")
	self.jutixq:getChildByName("T1"):setString(data.userName.."("..data.userCode..")")
	self.jutixq:getChildByName("T2"):setString(data.date)
	self.jutixq:getChildByName("T3"):setString(data.allBrokerageCoin)
	self.jutixq:getChildByName("T4"):setString(data.gameBrokerageCoin)
	self.jutixq:getChildByName("T5"):setString(data.roleBrokerageCoin)
	local pk =self.jutixq:getChildByName("PK")
	local PP = self.jutixq:getChildByName("PP")
	pk:removeAllChildren()
	
	for k,v in pairs(data.datas) do
		local item=PP:clone()
		item:getChildByName("T1"):setString(v.fromUserRole) --(os.date("%Y-%m-%d %H:%M:%S",v.createTime/1000))
		item:getChildByName("T2"):setString(v.fromUserName)
		item:getChildByName("T3"):setString(v.fromUserCode)
		local str="下属"
		if v.fromType == "game" then
			str="成员"
		end
		item:getChildByName("T4"):setString(str)
		item:getChildByName("T5"):setString(v.brokerageCoin)
		pk:pushBackCustomItem(item)
	end
end
return StatisticsLayer

