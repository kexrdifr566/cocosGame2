local sgLayer = class("sgLayer", function ()
	local sgLayer =  display.newLayer()
	return sgLayer
end)
local playerLayer=appdf.req(appdf.GAME_SRC.."sg.playerLayer")
local CardLayer=appdf.req(appdf.GAME_SRC.."sg.CardLayer")
local GameEndLayer=appdf.req(appdf.GAME_SRC.."public.GameEndLayer")
local TopLayer=appdf.req(appdf.GAME_SRC.."public.TopLayer")
local RubCardLayer = appdf.req(appdf.GAME_SRC.."cow.RubCardLayer")
local PlayC=0
local enumTable = {
	"P", 			--用户层
	"C", 			--牌层
	"G", 			--金币层
	"T", 			--功能列表层
	"J",			--结算层
	"S",			--设置层
}
local ZO = ExternalFun.declarEnumWithTable(100, enumTable)
function sgLayer:ctor(_scene)
    self.gamestutus= false			--游戏状态
	self:playerinint()

	self.scene=_scene
	--获取房间人数
	PlayC=self.scene:getplayercont()

	local rootLayer, csbNode = ExternalFun.loadRootCSB("Game/sgLayer/sgLayer.csb", self)
	self.bj=csbNode:getChildByName("bj")

    local btcallback = function (ref, type)
        
		if type == ccui.TouchEventType.ended then
            if ref:getTag()< 30 or ref:getTag() > 40 then 
				ref:setScale(1)
            end
				ExternalFun.playClickEffect()
			self:onButtonClickedEvent(ref:getTag(),ref)
		elseif type == ccui.TouchEventType.began then
            if ref:getTag()< 30 or ref:getTag() > 40 then               --抛出下注按钮变化
				ref:setScale(public.btscale)
            end
			return true
		elseif type == ccui.TouchEventType.canceled then
            if ref:getTag()< 30 or ref:getTag() > 40 then 
				ref:setScale(1)
            end
		end
	end

	--下方操作
	self.down=self.bj:getChildByName("down")
	self.down:setLocalZOrder(ZO.T)

	self.wait=self.bj:getChildByName("wait")
	self.wait:setVisible(false)

    self.BB={}                          --抢庄按钮
	for i=1,6 do
		local bb=string.format("B%d",i)
		local BAN=self.down:getChildByName(bb)
		BAN:setTag(i+10)
	    BAN:addTouchEventListener(btcallback)
        self.BB[i]=BAN
	end
        
	self.B_z=self.down:getChildByName("B_z")--准备
	self.B_z:setTag(21)
	self.B_z:addTouchEventListener(btcallback)
    self.B_z:setVisible(false)

	self.B_k=self.down:getChildByName("B_k")--庄
	self.B_k:setTag(22)
	self.B_k:addTouchEventListener(btcallback)

	self.BJ={}                              --下注按钮
	for i=1,4 do
		local bb=string.format("B_%d",i)
		local BAN=self.down:getChildByName(bb)
		BAN:setTag(i+30)
	    BAN:addTouchEventListener(btcallback)
	    self.BJ[i]=BAN
	end
	--游戏提示
	self.gameim=self.down:getChildByName("Im")
	--初始化用户
	self.player = playerLayer:create(self,PlayC)
	self:addToRootLayer(self.player,ZO.P)

	--初始化扑克
	self.Card = CardLayer:create(self,PlayC)
	self:addToRootLayer(self.Card,ZO.C)

	self.top =TopLayer:create(self)
	self:addToRootLayer(self.top,ZO.T)
    
    self.ht=self.down:getChildByName("h")
    self.ht:getChildByName("B")
        :setTag(50)
        :addTouchEventListener(btcallback)
    local function sliderFunC(sender, tType)
		if tType == ccui.SliderEventType.percentChanged then
            self:setHdVolume(sender:getPercent())
		end
    end
    self.BP={}                          --搓牌按钮
    local ban =self.down:getChildByName("Bc")
    ban:setTag(18)
	ban:addTouchEventListener(btcallback)
    table.insert(self.BP,ban) 
    
    local ban =self.down:getChildByName("Bf")--翻牌按钮
    ban:setTag(19)
	ban:addTouchEventListener(btcallback)
    table.insert(self.BP,ban) 
        
    self.ht:getChildByName("Slider"):addEventListenerSlider(sliderFunC)
    self.coumaLayer=self.bj:getChildByName("chouma")
    self.chidi=self.bj:getChildByName("chidi")
	self:changebj()
	self:reGame()                   --重置桌面信息
	self:topinint(1)

	--self.B_z:setVisible(true)
    
end
function sgLayer:changebj()
	local bjindex = cc.UserDefault:getInstance():getIntegerForKey("SGBJ", 1)
	local str = string.format("Game/public/shezhi/bj%d.png",bjindex)
    
	self.bj:setBackGroundImage(str)
	self.Card:changebj()
end
function sgLayer:reGame(bol) 				   -----------重置界面
    self:stopAllActions()
	self.player:reGame(bol)                   --玩家信息
	self.Card:reGame()                     --重置下注和牌的信息
	self:noShowBB() 					   --隐藏操纵按钮
	self.B_k:setVisible(false)
	self:playerinint()
	self.gameim:setVisible(false)
    self:KillGameClock()                    --关闭游戏提示
    self:showBP(false,false)                --隐藏对牌的操作
    if self:getChildByName("layerCuoCard3D") then                       --清理搓牌层
        self:getChildByName("layerCuoCard3D"):removeFromParent()
    end
    self.coumaLayer:removeAllChildren()
    self.chidi:getChildByName("T"):setString("")
end
function sgLayer:playerinint()

	self.banker=-1					--庄
	self.betCoin=0					--加注分数
	self.poolCoin =0                --奖池分数
    self.h_min=0                    --滑轮最低
    self.h_max=0                    --滑轮最高
	self.gendaodi = false
	self.raiseCoinSettings={}		--加注情况
    self.LastCard={}                --最后一张牌数据
    self.AllCard={}                 --翻牌的数据
    self.Px=nil                     --牌型
    self.m_coumaList = {}
    self.m_fJettonTime = 0.05
end
function sgLayer:topinint(jushu)
	self.top:updateT(jushu)
end
function sgLayer:onButtonClickedEvent(tag,ref)
	--print("操作"..tag )
    if tag > 10 and tag <=16  then  --玩家的操作。
        local bs=0
        if tag ~= 11 then
           bs= tonumber(ref:getChildByName("count"):getString())
        end
    	local data ={}
		data.actionCode =SgHead.action[1]
		data.QiangZhuangBs=bs
    	gst.send(SgHead.Tcode,data)
    elseif tag == 21 then                       ---准备按钮
    	gst.send(GameHead.zbgame,nil)
    	--self.B_z:setVisible(false)
    elseif tag == 22 then                       --开始按钮
    	local senddata={}
    	gst.send(GameHead.zk,nil)
    	self.B_k:setVisible(false)
    elseif tag == 18 then
        self:openCard(true)
   	elseif tag == 19 then                       --跟到底
        self:openCard(false)
    elseif tag >= 31 and tag <= 34 then   		--加注操作
    	local add =tonumber(ref:getChildByName("T"):getString())
    	local data ={}
    	data.actionCode =SgHead.action[2]
    	data.betBs = add
    	gst.send(SgHead.Tcode,data)
    elseif tag  == 50 then
    	local data ={}
    	data.actionCode =SgHead.action[2]
    	data.betBs = self.ht:getChildByName("Slider"):getChildByName("Image"):getChildByName("T"):getString()
    	gst.send(SgHead.Tcode,data)
	end
end
function sgLayer:addToRootLayer(node, zorder)
	if nil == node then
		return
	end
	self.bj:addChild(node)
	node:setLocalZOrder(zorder or 0)
end
function sgLayer:noShowBB()
    for k,v in pairs(self.BB) do
		v:setVisible(false)				   									--清楚所有控制按钮
	end
    for k,v in pairs(self.BJ) do
		v:setVisible(false)				   									--清楚所有控制按钮
    end
    self.ht:setVisible(false)
       
    self.raiseCoinSettings={}
end
function sgLayer:showBP(cuo,kai)                                           --显示搓牌OR开牌
        --搓牌
    self.BP[1]:setVisible(cuo)
    self.BP[2]:setVisible(kai)
end
function sgLayer:showbeishu(data)                                          --显示抢庄
    
    self.BB[1]:setVisible(true)
    for k,v in pairs(data) do
        if v < 5  then
            self.BB[v+1]:setVisible(true)
            self.BB[v+1]:getChildByName("count"):setString(v)
        end
    end
end

function sgLayer:showxiazhu(data)                                          --显示下注
    for k,v in pairs(data) do
        self.BJ[k]:setVisible(true)
        --self.BJ[k]:setScale(0.8)
        self.BJ[k]:getChildByName("T"):setString(v)
    end
    if data then
        self:setHt(data[1],data[#data])
        self.ht:setVisible(true)  
    end        
end
function sgLayer:setHdVolume(baifenbi)
    -- do somethings
    local jiandu=math.floor(self.h_max/100*baifenbi)+self.h_min
    
    if jiandu > self.h_max then
        jiandu=self.h_max
    end
    self.ht:getChildByName("Slider"):getChildByName("Image"):getChildByName("T"):setString(jiandu)
    self.ht:getChildByName("Slider"):getChildByName("Image"):setPositionX(370/100*baifenbi) 
    --print("滑动"..baifenbi.." "..self.h_max.."  "..self.h_min)
end
function sgLayer:setHt(min,max)
   self.ht:getChildByName("Slider"):setPercent(0)
    self.ht:getChildByName("Slider"):getChildByName("Image"):setPositionX(0) 
    self.h_min=min
    self.h_max=max
    self.ht:getChildByName("Slider"):getChildByName("Image"):getChildByName("T"):setString(min)
end
function sgLayer:getbankview()                                              --获取庄现在得位置
	return self.scene:getotherchair(self.banker)
end
function sgLayer:openCard(isCuo)
    local str=string.format("Game/new_card_heng/card_%d_%d.png",(self.LastCard.suit+1),self.LastCard.rank)      
    local strdian=string.format("Game/new_card_hengyoudian/card_%d_%d.png",(self.LastCard.suit+1),self.LastCard.rank)     
    local szBack=string.format("Game/new_card_heng/poker_bg%d.png",self.Card.cardback)
    local callFuncEnd = function()
        --print("动画彻底结束")
        local Sex= self.scene:getchairSex(self.scene:getMechair())
        self.Card:showCard(1,self.AllCard,self.Px,Sex)
        self:showBP(false,false)
        local data ={}
    	data.actionCode =SgHead.action[3]
    	gst.send(SgHead.Tcode,data)
    end
    if isCuo then
        local layerCuoCard3D=RubCardLayer:create(szBack,strdian,str, display.width/2,display.height/2, callFuncEnd)
        layerCuoCard3D:setAnchorPoint(ccp(0.5, 0.5))
        layerCuoCard3D:setName("layerCuoCard3D")
        --print(" self.layerCuoCard3D".. layerCuoCard3D:getPositionX().." "..layerCuoCard3D:getPositionY())
        self:addChild(layerCuoCard3D)
    else
        callFuncEnd()
    end
end

--飞金币动画
function sgLayer:showGoldToAreaWithID(beganviewid,endviewid)
	local pos = endviewid

	local bpos = beganviewid

	for j = 1, 10 do
        local str ="coin_icon.png"
        local puke = CCSpriteFrameCache:getInstance():getSpriteFrame(str)
        local pgold =  CCSprite:createWithSpriteFrame(puke)
		self.bj:addChild(pgold,ZO.G)
		pgold:setPosition(bpos)
		pgold:stopAllActions()
		pgold:setVisible(true)
		local move = ExternalFun.getMoveBezierAction(bpos,pos,40,0.4)
		pgold:runAction(cc.Sequence:create(cc.DelayTime:create(0.05 * j), move,cc.CallFunc:create(
		function()
			pgold:removeFromParent()
		end
		)
		))
	end
end
function sgLayer:KillGameClock()
    if self._ClockFun ~=nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._ClockFun)
        self._ClockFun =nil
    end
    self._ClockTime = 0
    self.gameim:setVisible(false)
end
function sgLayer:SetGameClock(time,index)
    self:KillGameClock()
    local str=''
    if index == 1 then
        str="等待玩家叫庄"
    elseif index ==2 then
        str="等待玩家下注"
    elseif index ==3 then
        str="等待玩家翻牌"
    elseif index == 4 then
        str="游戏结算"
    end
    self._ClockTime = time
    self.gameim:setVisible(true)    
    self.gameim:getChildByName("T1"):setString(str)
    self.gameim:getChildByName("T2"):setString(self._ClockTime)
    --添加时间机制
    self._ClockFun = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
            if  self.OnClockUpdata then
                self:OnClockUpdata()
            end
            end,1,false)
end
function sgLayer:OnClockUpdata()
    self._ClockTime=self._ClockTime-1
    if self.gameim:isVisible() and self._ClockTime >=0 then
        self.gameim:getChildByName("T2"):setString(self._ClockTime)
    elseif self.gameim:isVisible()  and self._ClockTime==-1 then
        self:KillGameClock()
    end
    
end
---  继承关系--------- 座位
--获取自己的座位号
function  sgLayer:getMechair()
	return self.scene:getMechair()
end
--用自己的座位号计算其他的人座位号
function  sgLayer:getotherchair(index)
	return self.scene:getotherchair(index)
end
--用用户ID 来算出他的座位号
function sgLayer:getchairindex(UserCode)
	return self.scene:getchairindex(UserCode)
end
--------------------------------------------------------------消息层-----------------------------------------------------
--显示金币飞到庄家处
function sgLayer:showGoldTo(Tchair,coumalist)
	
	--print("showGoldToZ>>>>>>", cbArea)
	local goldnum = #coumalist
	if goldnum == 0 then
		return
	end
	--分十次飞行完成
	local cellnum = math.floor(goldnum / 10)
	if cellnum == 0 then
		cellnum = 1
	end
	local cellindex = 0
	local outnum = 0
	for i = goldnum, 1, - 1 do
		local pgold = coumalist[i]
		table.remove(coumalist, i)
		outnum = outnum + 1
		local moveaction = ExternalFun.getMoveAction(cc.p(pgold:getPosition()), cc.p(self.player.P[Tchair]:getPosition()))
		pgold:runAction(cc.Sequence:create(cc.DelayTime:create(cellindex * 0.03), moveaction, cc.CallFunc:create(
		function()
			pgold:removeSelf()
		end
		)))
	end
end
function sgLayer:onSendPlaceJettonChip(beginpos,betIdx,goldnum)
    local tableinfo=public.gettableinfo(public.roomCode)
    local  integer, decimal = math.modf(goldnum/tableinfo.baseCoin)
    if integer < 1 then
        integer=1
    elseif integer>10 then
        integer=10
    end
    ExternalFun.playSoundEffect("chouma",true)
    local fun = function( index )
		--if isme then
        if index ==1 then
            ExternalFun.playSoundEffect("chouma",true)
        end
    --end
	end
    for i = 1, integer do
        local str ="coin_icon.png"
        local puke = CCSpriteFrameCache:getInstance():getSpriteFrame(str)
        local pgold =  CCSprite:createWithSpriteFrame(puke)
		pgold.betIdx = betIdx
		pgold:setPosition(beginpos)
        pgold:setScale(1)
		self.coumaLayer:addChild(pgold)
		self.coumaLayer:setVisible(true)

		if i == 1 then
			local moveaction = ExternalFun.getMoveAction(beginpos, self:getRandPos(self.chidi), fun(i), 0, nil)
			pgold:runAction(moveaction)
		else
			local offsettime = self.m_fJettonTime--math.min(self.m_fJettonTime, 2)
			local randnum = math.random() * offsettime
			pgold:setVisible(false)
			pgold:runAction(cc.Sequence:create(cc.DelayTime:create(randnum), cc.CallFunc:create(
			function()
				local moveaction = ExternalFun.getMoveAction(beginpos, self:getRandPos(self.chidi), fun(i), 0, nil)
				pgold:setVisible(true)
				pgold:runAction(moveaction)
			end
			)))
		end
		
		table.insert(self.m_coumaList, pgold)
	end
end
--获取随机显示位置
function sgLayer:getRandPos(nodeArea)
	local beginpos = cc.p(nodeArea:getPositionX() - 160, nodeArea:getPositionY() - 90)
	local offsetx = math.random()
	local offsety = math.random()
	return cc.p(beginpos.x + offsetx * 320, beginpos.y + offsety * 120)
end
-- function sgLayer:getMoveAction(beginpos, endpos, callback, rtime, bScale, inorout, isreverse)
	
-- 	inorout = inorout or 0
-- 	isreverse = isreverse or 0
-- 	rtime = rtime or 0
-- 	local dis =(endpos.x - beginpos.x) *(endpos.x - beginpos.x) +(endpos.y - beginpos.y) *(endpos.y - beginpos.y)
-- 	dis = math.sqrt(dis)
-- 	local ts = dis / 1500
-- 	if ts < 0.2 then
-- 		ts = 0.1
-- 	elseif ts > 0.6 then
-- 		ts = 0.6
-- 	end
-- 	local act
-- 	local move = cc.MoveTo:create(ts, endpos)
-- 	if inorout == 0 then
-- 		act = cc.EaseOut:create(move, ts)
-- 	else
-- 		act = cc.EaseIn:create(move, ts)
-- 	end
	
-- 	local actions = {}
-- 	if rtime > 0 then
-- 		local ranmove = cc.MoveTo:create(rtime, cc.p(beginpos.x +(math.random() - 0.5) * 50, beginpos.y +(math.random() - 0.5) * 50))
-- 		table.insert(actions, ranmove)
-- 	end
-- 	table.insert(actions, act)
-- 	if callback then
-- 		local fun = cc.CallFunc:create(callback)
-- 		table.insert(actions, fun)
-- 	end
-- 	if bScale then
-- 		local scaleact1 = cc.ScaleTo:create(0.1, 1.3)
-- 		local scaleact2 = cc.ScaleTo:create(0.1, 1.2)
-- 		local scaleact3 = cc.ScaleTo:create(0.1, 1.1)
-- 		table.insert(actions, scaleact1)
-- 		table.insert(actions, scaleact2)
-- 		table.insert(actions, scaleact3)
-- 	end
	
-- 	return cc.Sequence:create(actions)
	
-- end
function sgLayer:getPlayerGetPos(Tchair)
    local x,y=0
    x,y =self.player.P[Tchair]:getPosition()
    return cc.p(x,y)
end
function sgLayer:message(code,data)
--dump(data,"三公界面消息："..code)
	if code == GameHead.ingame  then   						--进入房间消息
		self:reGame() ---初始化界面
        self.top:uptableid(data.tableId)
        --self.gameStatus 1空闲 2 等待玩家进入 3 玩家等待开始 4游戏开始 5 小结算  6 大结算. 24 三公抢庄 25 三公下注 26 摊牌
        --初始化游戏模式
        self.gamestutus=data.playing
    	self.banker = data.bankerChairForQiangZhuang
        if self.banker ~=-1 then
            local bankerindex=self.scene:getotherchair(self.banker)
            self.player:upbankplayer(bankerindex)
        end
    	--初始游戏状态
		self.gameStatus=data.gameStatus
		--初始化准备按钮
		if not self.scene:getMechair() then --是不是旁观的人
            if data.joinModel and data.joinModel == 1 then --观战的人永远都不能出现准备
                self.B_z:setVisible(false)
                self.wait:setVisible(true)
            else
                self.B_z:setVisible(true)
                self.wait:setVisible(true)
            end
		else
			self.B_z:setVisible(false)
			self.wait:setVisible(false)
		end
		for k,v in pairs(data.users) do 											--初始玩家信息
			local otherindex=self.scene:getotherchair(v.chair)
            if self.banker ==v.chair and v.qiangZhuangBs then
                --显示倍数
                self.player:showqzbs(otherindex,v.qiangZhuangBs)
            end
            --显示自己操作
            if v.wcBz == "0" and self.scene:getMechair() and self.scene:getMechair() ==v.chair and   self.gameStatus == "24" then
                --显示倍数
                self:showbeishu(data.qiangZhuangBs)
            elseif  v.wcBz == "0" and self.scene:getMechair() and self.scene:getMechair() ==v.chair and   self.gameStatus == "25" then 
                self:showxiazhu(data.xiaZhuBs)               --显示下注    
            end
		end
        if  self.gameStatus ~= "1" and self.gameStatus ~= "2" and self.gameStatus ~= "3" then
            for k,v in pairs(data.users) do
                local otherindex=self.scene:getotherchair(v.chair)
                local tableinfo=public.gettableinfo(public.roomCode)
                self.Card:pushonCard(otherindex)
                if v.cards and #v.cards~= 0  then
                    if  self.gameStatus == "5"  then
                        self.Card:showCard(otherindex,v.cards,v.px)
                    elseif  tableinfo.mingpai ==1 and self.scene:getMechair() then
                        self.Card:showCard(otherindex,v.cards,v.px)
                    elseif otherindex == 1 and self.scene:getMechair() and  self.gameStatus == "26" then
                        self.Card:showCard(otherindex,v.cards,v.px)
                    end
                end
            end
        end   
		if  self.gameStatus == "3" and data.bankerChairForKsyx and data.bankerChairForKsyx == self.scene:getMechair() then
			self.B_k:setVisible(true)
		end
		--显示局数
		self:topinint(data.inningIndex)
        
          --设置显示等待读秒
        local Seconds=data.waitForActionSeconds 
        if Seconds>0 then                              
            if self.gameStatus == "24" then
                self:SetGameClock(Seconds,1)
            elseif self.gameStatus == "25" then
                self:SetGameClock(Seconds,2)  
            elseif self.gameStatus == "26" then
                self:SetGameClock(Seconds,3) 
            elseif self.gameStatus == "5" then
                self:SetGameClock(Seconds,4) 
            end
        end
        if ( self.gameStatus == "25" or self.gameStatus == "26" or self.gameStatus == "5") and data.userHasBetAll  then  
            local str="总下注:"..data.userHasBetAll
            self.chidi:getChildByName("T"):setString(str)
            if data.userHasBetAll ~= 0 then
                for k,v in pairs (data.users) do
                     local besChair=self.scene:getotherchair(v.chair)
                    self.Card:updateplayercoin(besChair,v.xiaZhuBs) 								--更新玩家桌子总注
                    local beginspos=self:getPlayerGetPos(besChair)                              --获取位置
                    --显示加注动画
                    self:onSendPlaceJettonChip(beginspos,1,v.xiaZhuBs)
                end
            end
        end
          --self:setHt(1,1000)
	--更新玩家位置
	elseif code == GameHead.zbgame  then 						 						---准备消息
		if data.userCode == public.userCode then									--自己准备
			self.B_z:setVisible(false)
			self.wait:setVisible(false)
            --self.gamestutus=true
		end
    elseif code == GameHead.ztjoinplayer then
        self.wait:setVisible(false)
        self.B_z:setVisible(false)
        showToast("等待下局自动开始游戏",1)
	--删除玩家位置
	elseif code == GameHead.tcgame  then
	elseif code == GameHead.zkts then                     							--提示庄开启游戏按钮
    	self.B_k:setVisible(true)
    elseif code == SgHead.bgame then                     							--开始游戏界面
        if self.scene:getMechair()  then            --判断是否已经开始游戏。用于退出房间
            self.gamestutus=true
        end
    	self:reGame()                                    							--重置界面
		self.gameStatus = "4"
               
		--显示局数
		self:topinint(data.inningIndex)
        for k,v in pairs(data.users) do 				 									--显示出来牌
            local otherindex=self.scene:getotherchair(v.chair)
            self.Card:pushonCard(otherindex)
        end
        local tableinfo=public.gettableinfo(public.roomCode)
        
        if data.qiangZhuangOrXiaZhu =="1" then                                  --抢庄模式
            local call = function()
                --要显示倒计时的地方
                if self.scene:getMechair() then
                    --显示倍数
                    self:showbeishu(data.qiangZhuangBs)               --显示下注  
                end
                self:SetGameClock(data.qiangZhuangRemainSeconds,1)
            end
            self.Card:sendCard(data.users,call)  
        elseif  data.qiangZhuangOrXiaZhu =="2" then                               --直接定庄
            local call = function()
                if self.scene:getMechair()  then
                    --显示倍数
                    self:showxiazhu(data.betCoins)               --显示下注
                                    
                end
                self:SetGameClock(data.qiangZhuangRemainSeconds,2)
            end
            self.Card:sendCard(data.users,call) 
        elseif data.qiangZhuangOrXiaZhu ==nil then  --观战的人
            local call = function()
            end
            self.Card:sendCard(data.users,call)
        end
       

    elseif code == SgHead.tqiang  then          --抢庄结果
        local index=self.scene:getotherchair(data.chairIndex)
        if  data.chairIndex== self.scene:getMechair() then
            self:noShowBB()                              --隐藏叫庄按钮
        end
        -------------------显示庄的倍数
        self.player:showqzbs(index,data.qiangZhuangBs)
        
    elseif code == SgHead.tqiangres    then             --叫庄的最后结果
        self:KillGameClock()
        self:noShowBB()                                  --隐藏叫庄按钮 
        self.banker=data.bankerUserChair                 --保存庄家
        local bankerChair=self.scene:getotherchair(data.bankerUserChair)
        local qiangs={}
        for k,v in pairs(data.qiangZhuangInfo) do
            if v ~= 0 then
                local index =self.scene:getotherchair(v)
                table.insert(qiangs,index)
            end
        end
        local call = function()
            --要显示倒计时的地方
            if self.scene:getMechair() and data.bankerUserChair ~=  self.scene:getMechair() then
                --显示倍数
                self:showxiazhu(data.betCoins)               --显示下注                
            end
            self:SetGameClock(data.xiaZhuShiJian,2)
        end 
        --设置庄
        self.player:setBankerUser(bankerChair,qiangs,call)
        
        
    elseif code ==SgHead.tcodexz       then            --显示玩家下注
        if data.chairIndex == self.scene:getMechair() then
            self:noShowBB()                              --隐藏下注按钮
        end
        --userHasBetAll
        local besChair=self.scene:getotherchair(data.chairIndex)
        
        self.Card:updateplayercoin(besChair,data.bs) 								--更新玩家桌子总注
        local beginspos=self:getPlayerGetPos(besChair)                              --获取位置
        --显示加注动画
        self:onSendPlaceJettonChip(beginspos,1,data.bs)
        self.scene:UpusersCoin(data.UserCode,data.wanJiaJinBi)                      --更新玩家列表里面的金币
        self.player:upScoreplayer(besChair,data.wanJiaJinBi)                        --更新玩家身上金币
        local str="总下注:"..data.userHasBetAll
        self.chidi:getChildByName("T"):setString(str)
        
    elseif code ==SgHead.tcodexzres       then            --显示玩家下注最终
        self:KillGameClock()
        self:noShowBB() 
        --local call = function()
            --要显示倒计时的地方
            if self.scene:getMechair() then
                self:showBP(true,true)                              --显示搓牌和不搓牌
                local tableinfo=public.gettableinfo(public.roomCode)
                if tableinfo.mingpai ==2 then
                    local  cards={}
                    cards[1]=data.orgCards[1]
                    cards[2]=data.orgCards[2]
                    self.Card:showCard(1,cards)
                end
            end
            self:SetGameClock(data.remainTime,3)
        --end 
            
        -- for k,v in pairs(data.users) do 				 									--显示出来牌
        --     local otherindex=self.scene:getotherchair(v.chair)
        --     self.Card:pushonCard(otherindex)
        -- end
        --     self.Card:sendfive(data.users,call)               --发牌
       -- data.orgCards=
        self.LastCard=data.lastCard             --最后一张牌
        self.AllCard=data.pxCards               --排序后的牌
        self.Px=data.px                         --牌型
        self.player:upcuopai(0,true)
	elseif code == GameHead.online or code ==GameHead.noonline then
		-- local index =self.scene:getchairindex(data.userCode)  --操作得玩家
		-- self.player:uponline(index,code==GameHead.noonline)
    elseif code == SgHead.showp then                          --玩家翻牌
        local index =self.scene:getotherchair(data.userChair)  --操作得玩家
        local Sex= self.scene:getchairSex(data.userChair)
		self.Card:showCard(index,data.pxCards,data.px,Sex)  
        if self.scene:getMechair() and self.scene:getMechair() ==data.userChair then
            self:showBP(false,false)
        end
        self.player:upcuopai(index,false)
	elseif code == SgHead.smallend then 
        self:showBP(false,false)
		self:noShowBB()
        self:KillGameClock()
        self.player:upcuopai(0,false)
        if data.bankerChair then
            self.banker=data.bankerChair
        end
        for k,v in pairs(data.data) do 
            local chair=self.scene:getotherchair(v.userChair)
            self.Card:showCard(chair,v.pxCards,v.px)            
        end
        performWithDelay(self,function ()  
            for k,v in pairs(data.data) do 											--更新玩家手中的牌及牌型
                local chair=self.scene:getotherchair(v.userChair)
                self.scene:UpusersCoin(v.userCode,v.gameCoin)                      --更新玩家列表里面的金币
                --self.player:upScoreplayer(chair,v.gameCoin) 
                if chair ==self.scene:getMechair() then
                    if v.coin <0 then
                        self.player:showEnd(chair,v.coin,v.gameCoin,-1)
                    else
                        self.player:showEnd(chair,v.coin,v.gameCoin,1)
                    end
                else
                    self.player:showEnd(chair,v.coin,v.gameCoin)
                end	
                performWithDelay(self,function ()
                   self.player:upScoreplayer(chair,v.gameCoin) 
                end,2)
            end
         end,1.5)
        local Winplayer={} --判断赢家数目
        local wincoumalist=self.m_coumaList
        for k,v in pairs(data.data) do 											--更新玩家手中的牌及牌型
            local chair=self.scene:getotherchair(v.userChair)
                if v.coin > 0 then
                    table.insert(Winplayer,v)  
                end
            --end	
		end
        --显示收回筹码动画
       performWithDelay(self,function ()                    
            local wincoumalist={}       
            for k,v in pairs(Winplayer) do
                wincoumalist={}
                local  integer, decimal = math.modf(#self.m_coumaList/#Winplayer)
                local chair=self.scene:getotherchair(v.userChair)
                if  integer <1 then
                    self:showGoldTo(chair,self.m_coumaList)
                elseif k == #Winplayer then
                    self:showGoldTo(chair,self.m_coumaList)
                else
                    for i=1,integer do
                        wincoumalist[i]=self.m_coumaList[1]
                        table.remove(self.m_coumaList,1)
                    end
                    self:showGoldTo(chair,wincoumalist)
                end
            end 
             
        end,0.8)        
	elseif code == SgHead.bigend then
		local layer=GameEndLayer:create(self,data)
        layer:setName("GameEndLayer")
		self:addToRootLayer(layer,ZO.J)
	elseif code == SgHead.nobgame then
		-- self.scene.users = data.users
		-- self:reGame(true)
		-- for k,v in pairs(data.users) do 											--初始玩家信息
		-- 	local otherindex=self.scene:getotherchair(v.chair)
		-- 	self.player:upplayer(otherindex,v,nil,self.banker == v.chair,v.status == "5",v.online)
		-- end
		local tableinfo=public.gettableinfo(public.roomCode)
		if #data.users < tableinfo.canStartUserNum then
			showToast("玩家小于最少开局人数，请稍等",1)
		end
	end
end


return sgLayer

