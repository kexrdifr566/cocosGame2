 local scoreSetLayer = class("scoreSetLayer", function ()
	local scoreSetLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return scoreSetLayer
 end)
local scoretype={"gameCoin","manageCoin","brokerageCoin"}
local AnimationHelper = appdf.req(appdf.EXTERNAL_SRC .. "AnimationHelper")
function scoreSetLayer:ctor(_scene,clubinfo)
    EventMgr.registerEvent(self,"scoreSetLayer")
    self.clubinfo = clubinfo
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Club/Layer/scoreSet.csb", self)
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
	self.bj:getChildByName("Bq")
	:setTag(101)
	:addTouchEventListener(btcallback)
	self.bj:getChildByName("Bs")
	:setTag(102)
	:addTouchEventListener(btcallback)
	self.SB={}
	for i = 1, 13 do
		local str =string.format("B_%d",i)
		self.SB[i]=self.bj:getChildByName(str)
		self.SB[i]:setTag(i)
		:addTouchEventListener(btcallback)
	end
    if self.clubinfo.groupRoleCode == public.culbCode.qunzhu or
       self.clubinfo.groupRoleCode ==  public.culbCode.fuqunzhu then
        self.SB[12]:setVisible(true)
    else
        self.SB[12]:setVisible(false)  
    end
	
    self.BB={}
	for i = 1, 3 do
		local str =string.format("B%d",i)
		self.BB[i]=self.bj:getChildByName(str)
		self.BB[i]:setTag(i+20)
		:addTouchEventListener(btcallback)
	end
	self.score={}
	self.BB[1]:getChildByName("T1"):setString("游戏分")
	self.BB[2]:getChildByName("T1"):setString("管理分")
	self.BB[3]:getChildByName("T1"):setString("赠送分")
	self.select = 1
	self:selectT(self.select)
	self:rescore()
	self.fu=false
    self.ziji =self.bj:getChildByName("ziji")
    self.isme=false
    self:upscore()
    --dump(self.clubinfo,"俱乐部")
     AnimationHelper.jumpInEx(self.bj, 1)
end
function scoreSetLayer:upscore()
    self.clubinfo= public.getclubinfo(public.enterclubid)
    --dump(clubinfo,"俱乐部信息")
    self.ziji:getChildByName("T2"):setString(self.clubinfo.gameCoin)
    self.ziji:getChildByName("T1"):setString(self.clubinfo.manageCoin)
    
    self.mescore={}
    self.mescore[1]=self.clubinfo.gameCoin
    self.mescore[2]=self.clubinfo.manageCoin
    self.mescore[3]=self.clubinfo.brokerageCoin
end
function scoreSetLayer:rescore()
	for k,v in pairs(self.BB) do
		v:getChildByName("T4"):setString(0) 
	end
end
function scoreSetLayer:selectT(index)
	if self.BB[index] ==nil then
		return
	end
	if self.score[self.select] ~= nil then
		self.BB[self.select]:getChildByName("T2"):setString(self.score[self.select])
		self.BB[self.select]:getChildByName("T3"):setString(self.score[self.select])
		self.BB[self.select]:getChildByName("T4"):setString(0)
	end
	for k,v in pairs(self.BB) do						--按钮选择
		v:setEnabled(true)
		v:getChildByName("I"):setColor(cc.c3b(255,255,255))
        if k == index then
			v:setEnabled(false)
			v:getChildByName("I"):setColor(cc.c3b(0,0,255))
        end
	end
	self.select = index
    if self.select ==3 then
        self.fu=true
        self.BB[self.select]:getChildByName("T4"):setString("-0")
    else
        self.fu=false
    end
end

function scoreSetLayer:inint(data)
	--dump(data,"玩家分数")
	self.score[1]=data.gameCoin
	self.score[2]=data.manageCoin
	self.score[3]=data.brokerageCoin
	self.toUserCode=data.userCode

	self.bj:getChildByName("T1"):setString(data.userName)
	self.bj:getChildByName("T2"):setString("ID:"..data.userCode)
	self.BB[1]:getChildByName("T2"):setString(data.gameCoin)
	self.BB[1]:getChildByName("T3"):setString(data.gameCoin)
	self.BB[2]:getChildByName("T2"):setString(data.manageCoin)
	self.BB[2]:getChildByName("T3"):setString(data.manageCoin)
	self.BB[3]:getChildByName("T2"):setString(data.brokerageCoin)
	self.BB[3]:getChildByName("T3"):setString(data.brokerageCoin)
    local headbg=self.bj:getChildByName("H")
    --设置头像
    ExternalFun.createClipHead(headbg,data.userCode,data.logoUrl,67)

	if  self.toUserCode ~= public.userCode then
		self.BB[3]:setVisible(false)
    else
        self.ziji:setVisible(false)
        self.isme=true
	end
    if data.groupRoleCode =="0" then
        self.BB[2]:setVisible(false)
    end
end
function scoreSetLayer:onButtonClickedEvent(tag,ref)
	if tag == 100 then
		--更新自己的数据
		local clubinfo = public.getclubinfo(public.enterclubid)
		local data={}
		data.userCode = public.userCode
		data.groupCode=clubinfo.groupCode
		st.send(HallHead.cxculbwj,data)
		--更新大厅的内容
		-- self.sceneself.scene:selectPage()
        local layer=self.scene:getChildByName("cyglLayer")
		if layer and layer.selectPage then
			layer:selectPage(true)
		end	
        local layer=self.scene:getChildByName("PlayerInfo")
		if layer and layer.inint then
			layer:inint()
		end	
        EventMgr.removeEvent("scoreSetLayer")
		self:removeFromParent()
	elseif tag > 20 and tag <= 23 then
		self:selectT(tag-20)
	elseif tag >=1 and tag <= 13 then
		self:changescore(tag)
	elseif tag == 101 then
		self:rescore()
		for k,v in pairs(self.BB) do
			self.BB[k]:getChildByName("T3"):setString(self.score[k])
		end
	elseif tag == 102 then
		local data={}
		local clubinfo = public.getclubinfo(public.enterclubid)
		data.groupCode=clubinfo.groupCode
		data.toUserCode =self.toUserCode
		data.rechargeCoins =tonumber(self.BB[self.select]:getChildByName("T4"):getString())
		data.coinType = scoretype[self.select]
		st.send(HallHead.scorecy,data)
		self:rescore()
		showWait(5)
    end
end
function scoreSetLayer:changescore(num)
    local de=false  --是否删除
	if num ==12 or ( num == 11 and self.select ==3 ) then
		self.fu=true
		self.BB[self.select]:getChildByName("T4"):setString("-0")
		self.BB[self.select]:getChildByName("T3"):setString(self.score[self.select])
		return
	elseif num == 11 then
		self.fu=false
		self.BB[self.select]:getChildByName("T4"):setString("0")
		self.BB[self.select]:getChildByName("T3"):setString(self.score[self.select])
		return
	elseif num == 13 then
		de=true
	elseif num == 10 then
		num =0
	end     
    local score =tonumber(self.BB[self.select]:getChildByName("T4"):getString())
    local absscore =math.abs(tonumber(self.BB[self.select]:getChildByName("T4"):getString()))
    
    local scoreso =0
    --判断是否删除
    if de then
        if absscore < 10 then
            scoreso=0
        else
            scoreso =math.floor(absscore/10)
        end
    else
        scoreso = absscore*10+num
    end
    --判断是否为负
    if self.fu then
         scoreso=-scoreso
    end
        
    if self.isme then
        local scoreme=self.mescore[self.select]
        --判断负数情况
        if self.fu then
            scoreme =self.mescore[self.select]
        else
            if self.select ==1 then
                scoreme =self.mescore[2]
            elseif self.select == 2 then
                scoreme =self.mescore[1]
            end
        end
        if self.select == 3 then
            if scoreso > 0  then
                showToast("赠送分修改错误！",1)
                return
            elseif  math.abs(scoreso)  > scoreme then
                showToast("赠送分不足！",1)
                return
            end
        elseif scoreme < math.abs(scoreso) then
             if  self.select == 1 then
                 if self.fu then
                    showToast("游戏分不足！",1)
                 else
                    showToast("管理分不足！",1)
                 end
                 return
             elseif self.select==2 then
                 if self.fu then
                    showToast("管理分不足！",1)
                 else
                    showToast("游戏分不足！",1)
                 end
                 return
             end     
        end
    else
        if self.select == 3 then
            showToast("修改分数项目错误！",1)
            return
        end
        
        if self.fu and self.score[self.select] < math.abs(scoreso) then
            showToast("该玩家的分数不足！",1)
            return
        elseif self.fu == false and  self.mescore[self.select] < math.abs(scoreso) then
            showToast("自己的分数不足！",1)
            return
        end
    end
    
    local jieguo=scoreso + self.score[self.select]
    self.BB[self.select]:getChildByName("T3"):setString(jieguo)
    self.BB[self.select]:getChildByName("T4"):setString(scoreso)

end
function scoreSetLayer:message(code,data)
	if code  ==HallHead.cxculbwj then
		self:inint(data)
	elseif code == HallHead.scorecy then
		self:rescore()
		showToast("分数更改成功",1)
		local clubinfo = public.getclubinfo(public.enterclubid)
		local data={}
		data.userCode = self.toUserCode
		data.groupCode=clubinfo.groupCode
		st.send(HallHead.cxculbwj,data)
    elseif code == HallHead.Upcoin then
        self:upscore()
	end
	
end
return scoreSetLayer

