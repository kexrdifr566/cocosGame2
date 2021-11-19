local DcowLayer = class("DcowLayer", function ()
	local DcowLayer =  display.newLayer()
	return DcowLayer
end)
local playerLayer=appdf.req(appdf.GAME_SRC.."cow.playerLayer")
local CardLayer=appdf.req(appdf.GAME_SRC.."cow.CardLayer")
local RubCardLayer = appdf.req(appdf.GAME_SRC.."cow.RubCardLayer")
local GameEndLayer=appdf.req(appdf.GAME_SRC.."public.GameEndLayer")
local TopLayer=appdf.req(appdf.GAME_SRC.."public.TopLayer")
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
function DcowLayer:ctor(_scene)
    ExternalFun.registerNodeEvent(self)
    self.gamestutus= false			--游戏状态
	self:playerinint()
    
    self:registerScriptHandler(function(eventType)
		if eventType == "enterTransitionFinish" then	-- 进入场景而且过渡动画结束时候触发。
			self:onEnterTransitionFinish()
		elseif eventType == "exitTransitionStart" then	-- 退出场景而且开始过渡动画时候触发。
			self:onExitTransitionStart()
		elseif eventType == "exit" then
			self:onExit()
		end
	end)
    
	self.scene=_scene
	--获取房间人数
	PlayC=self.scene:getplayercont()
    
    local rootLayer, csbNode = ExternalFun.loadRootCSB("Game/cowLayer/DcowLayer.csb", self)
	self.bj=csbNode:getChildByName("bj")
    local btcallback = function (ref, type)
        
		if type == ccui.TouchEventType.ended then
    --         if ref:getTag()< 30 or ref:getTag() > 40 then 
				-- ref:setScale(1)
    --         end
				ExternalFun.playClickEffect()
			self:onButtonClickedEvent(ref:getTag(),ref)
		elseif type == ccui.TouchEventType.began then
    --         if ref:getTag()< 30 or ref:getTag() > 40 then               --抛出下注按钮变化
				-- ref:setScale(public.btscale)
    --         end
			return true
		elseif type == ccui.TouchEventType.canceled then
    --         if ref:getTag()< 30 or ref:getTag() > 40 then 
				-- ref:setScale(1)
    --         end
		end
	end 
	--下方操作
	self.down=self.bj:getChildByName("down")
	self.down:setLocalZOrder(ZO.T)

	self.wait=self.bj:getChildByName("wait")
	self.wait:setVisible(false)

    --self.BB={}                          --抢庄按钮
    self.ht=self.down:getChildByName("h")
    local function sliderFunC(sender, tType)
		if tType == ccui.SliderEventType.percentChanged then
            self:setHdVolume(sender:getPercent())
		end
    end
    self.ht:getChildByName("Slider"):addEventListenerSlider(sliderFunC)
	for i=1,4 do
		local bb=string.format("B_%d",i)
		local BAN=self.ht:getChildByName(bb)
		BAN:setTag(i+10)
	    BAN:addTouchEventListener(btcallback)
        --self.BB[i]=BAN
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
    
	self.B_z=self.down:getChildByName("B_z")--准备
	self.B_z:setTag(21)
	self.B_z:addTouchEventListener(btcallback)
    self.B_z:setVisible(false)

	self.B_k=self.down:getChildByName("B_k")--庄
	self.B_k:setTag(22)
	self.B_k:addTouchEventListener(btcallback)
	--游戏提示
	self.gameim=self.down:getChildByName("Im")
    self.T=self.down:getChildByName("T")
    self.T:setVisible(false)
    --游戏内庄提示
	self.ztishi=self.down:getChildByName("tishi")
    local btn= self.ztishi:getChildByName("Bq")
    btn:setTag(1)
    btn:addTouchEventListener(btcallback)
    local btn= self.ztishi:getChildByName("Bf")
    btn:setTag(2)
    btn:addTouchEventListener(btcallback)
    --奖池分数
    self.jcd=self.down:getChildByName("zd")
    self.jcd:getChildByName("T"):setString(0)
	--初始化用户
	self.player = playerLayer:create(self,PlayC)
	self:addToRootLayer(self.player,ZO.P)

	--初始化扑克
	self.Card = CardLayer:create(self,PlayC)
	self:addToRootLayer(self.Card,ZO.C)

	self.top =TopLayer:create(self)
	self:addToRootLayer(self.top,ZO.T)
	self:changebj()
	self:reGame()                   --重置桌面信息
	self:topinint(1)
    --明3暗2or全暗
    local tableinfo=public.gettableinfo(public.roomCode)
    self.douNiuMingan=tableinfo.douNiuMingan
end
function DcowLayer:setHdVolume(baifenbi)
    -- do somethings
    local jiandu=math.floor(self.h_max/100*baifenbi)+self.h_min
    
    if jiandu > self.h_max then
        jiandu=self.h_max
    end
    self.ht:getChildByName("Slider"):getChildByName("Image"):getChildByName("T"):setString(jiandu)
    self.ht:getChildByName("Slider"):getChildByName("Image"):setPositionX(370/100*baifenbi) 
    --print("滑动"..baifenbi.." "..self.h_max.."  "..self.h_min)
end
function DcowLayer:setHt(min,max)
   self.ht:getChildByName("Slider"):setPercent(0)
    self.ht:getChildByName("Slider"):getChildByName("Image"):setPositionX(0) 
    self.h_min=min
    self.h_max=max
    self.ht:getChildByName("Slider"):getChildByName("Image"):getChildByName("T"):setString(min)
end
function DcowLayer:onEnterTransitionFinish()
    --print("状态已完成")
end

function DcowLayer:onExit()
	return self
end

function DcowLayer:changebj()
	local bjindex = cc.UserDefault:getInstance():getIntegerForKey("DCOWBJ", 1)
	local str = string.format("Game/public/shezhi/bj%d.png",bjindex)
    
	self.bj:setBackGroundImage(str)
	self.Card:changebj()
end
function DcowLayer:reGame(bol) 				   -----------重置界面
    self:stopAllActions()
	self.player:reGame(bol)                   --玩家信息
	self.Card:reGame()                     --重置下注和牌的信息
	self:noShowBB() 					   --隐藏操纵按钮
    self.ztishi:setVisible(false)
	self.B_k:setVisible(false)
	self:playerinint()
    self.betFlag = 0
    self.TishiBtn= nil
	--self.xiaojie:setVisible(false)
	self.gameim:setVisible(false)
    self:showBP(false,false)                --隐藏对牌的操作
    self:KillGameClock()                    --关闭游戏提示
    --self.jcd:setVisible(false )
    if self:getChildByName("layerCuoCard3D") then                       --清理搓牌层
        self:getChildByName("layerCuoCard3D"):removeFromParent()
    end
    
end
function DcowLayer:playerinint()
	
	self.banker=0					--庄
	self.betCoin=0					--加注分数
    self.betFlag = 0                --推注标识
	self.poolCoin =0                --奖池分数
	self.gendaodi = false
	self.raiseCoinSettings={}		--加注情况
    self.LastCard={}                --最后一张牌数据
    self.AllCard={}                 --翻牌的数据
    self.Px=nil                     --牌型
    self.niuNiuBs=nil               --牛牛牌型倍数
    self.DoublebetCoins={}
    self.TZbetCoins={}
    self.betCoins={}
end
function DcowLayer:topinint(jushu)
    self.top:updateT(jushu)
	self.top:updcowjushu(jushu)
end
function DcowLayer:onButtonClickedEvent(tag,ref)
	--print("操作"..tag )
    if tag <3 then
        self:seletTishi(tag)
    elseif tag > 10 and tag <=16  then  --玩家的操作。
        local action = tag ==13 and 8 or 6
    	local data ={}
		data.actionCode =DcowHead.action[action]
        if tag == 14 then --射门
            data.betBs= self.ht:getChildByName("Slider"):getChildByName("Image"):getChildByName("T"):getString()
        elseif tag == 13 then --滑动下注
            data.betBs = self.ht:getChildByName("B_2"):getChildByName("T"):getString()
        elseif tag == 12 then --下注按钮2
            data.betBs=self.ht:getChildByName("B_2"):getChildByName("T"):getString()
        elseif tag == 11 then--下注按钮1
            data.betBs=self.ht:getChildByName("B_1"):getChildByName("T"):getString()
        end
    	gst.send(DcowHead.Tcode,data)
    elseif tag == 18 then
        self:openCard(true)
   	elseif tag == 19 then                       --跟到底
        self:openCard(false)
    elseif tag == 21 then                       ---准备按钮
    	gst.send(GameHead.zbgame,nil)
    	--self.B_z:setVisible(false)
    elseif tag == 22 then                       --开始按钮
    	local senddata={}
    	gst.send(GameHead.zk,nil)
    	self.B_k:setVisible(false)
    elseif tag >= 31 and tag <= 34 then   		--加注操作
    	local add =tonumber(ref:getChildByName("T"):getString())
    	local data ={}
    	data.actionCode =DcowHead.action[2]
    	data.betBs = add
        data.betFlag =self.betFlag
    	gst.send(DcowHead.Tcode,data)
    elseif tag ==41 then
        --翻倍更新下注
        --print("推注更新下注")
        self:showxiazhu(self.TZbetCoins)               --显示下注 
        self.betFlag=1
    elseif tag == 46 then
        --print("翻倍更新下注")
        self:showxiazhu(self.DoublebetCoins)            --显示下注 
    elseif tag == 42 then                               --不推注
        self.betFlag=2
        self:showxiazhu(self.betCoins)
    elseif tag == 47 then
        self:showxiazhu(self.betCoins)
	end
end
function DcowLayer:seletTishi(tag)
       
    local action =nil       
    if tag == 1 then
        if self.TishiBtn== "0" then
            action=DcowHead.action[2] --同意上庄
        elseif self.TishiBtn == "1" then
            action=DcowHead.action[3] --同意下庄
        elseif self.TishiBtn == "2" then
            action=DcowHead.action[4] --同意下庄
        end
    else
        if self.TishiBtn ==  "2" then
            action=DcowHead.action[5] --不同意下庄
        else
            action=DcowHead.action[1] --同意不上庄
        end
    end
    if action then
        local data ={}
    	data.actionCode =action
    	gst.send(DcowHead.Tcode,data)
    end
end
function DcowLayer:addToRootLayer(node, zorder)
	if nil == node then
		return
	end
	self.bj:addChild(node)
	node:setLocalZOrder(zorder or 0)
end
function DcowLayer:noShowBB()
 --    for k,v in pairs(self.BB) do
	-- 	v:setVisible(false)				   									--清楚所有控制按钮
	-- end
    self.ht:setVisible(false)
    self.raiseCoinSettings={}
end
function DcowLayer:showBP(cuo,kai)                                           --显示搓牌OR开牌
        --搓牌
    self.BP[1]:setVisible(cuo)
    self.BP[2]:setVisible(kai)
end
function DcowLayer:showbeishu(data)                                          --显示抢庄
    
    -- self.BB[1]:setVisible(true)
    -- for k,v in pairs(data) do
    --     if v < 5  then
    --         self.BB[v+1]:setVisible(true)
    --         self.BB[v+1]:getChildByName("count"):setString(v)
    --     end
    -- end
end

function DcowLayer:showxiazhu(data)                                          --显示下注
    -- for k,v in pairs(self.BJ) do
    --     v:setVisible(false)
    -- end
    -- for k,v in pairs(data) do
    --     self.BJ[k]:setVisible(true)
    --     self.BJ[k]:setScale(0.8)
    --     self.BJ[k]:getChildByName("T"):setString(v)
    -- end
end
function DcowLayer:getbankview()                                              --获取庄现在得位置
	return self.scene:getotherchair(self.banker)
end

function DcowLayer:openCard(isCuo)
    local str=string.format("Game/new_card_heng/card_%d_%d.png",(self.LastCard.suit+1),self.LastCard.rank) 
    local strdian=string.format("Game/new_card_hengyoudian/card_%d_%d.png",(self.LastCard.suit+1),self.LastCard.rank)     
    local szBack=string.format("Game/new_card_heng/poker_bg%d.png",self.Card.cardback)
    local callFuncEnd = function()
        --print("动画彻底结束")
        local Sex= self.scene:getchairSex(self.scene:getMechair())
        self.Card:showCard(1,self.AllCard,self.Px,Sex,self.niuNiuBs,self.LastCard)
        self:showBP(false,false)
        local data ={}
    	data.actionCode =DcowHead.action[7]
    	gst.send(DcowHead.Tcode,data)
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
function DcowLayer:showGoldToAreaWithID(beganviewid,endviewid)
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
function DcowLayer:KillGameClock()
    if self._ClockFun ~=nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._ClockFun)
        self._ClockFun =nil
    end
    self._ClockTime = 0
    self.gameim:setVisible(false)
end
function DcowLayer:SetGameClock(time,index)
    self:KillGameClock()
    local str=''
    if index == 1 then
        str="等待玩家上庄"
    elseif index ==2 then
        str="等待玩家下注"
    elseif index ==3 then
        str="等待玩家开牌"
    elseif index ==4 then
        str="等待游戏开始"
    end
    self._ClockTime = time
    self.timeindex=index
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
function DcowLayer:OnClockUpdata()
    self._ClockTime=self._ClockTime-1
    if self.gameim:isVisible() and self._ClockTime >=0 then
        self.gameim:getChildByName("T2"):setString(self._ClockTime)
    elseif self.gameim:isVisible()  and self._ClockTime==-1 then
        self:KillGameClock()
    end
    
end
---  继承关系--------- 座位
--获取自己的座位号
function  DcowLayer:getMechair()
	return self.scene:getMechair()
end
--用自己的座位号计算其他的人座位号
function  DcowLayer:getotherchair(index)
	return self.scene:getotherchair(index)
end
--用用户ID 来算出他的座位号
function DcowLayer:getchairindex(UserCode)
	return self.scene:getchairindex(UserCode)
end
--------------------------------------------------------------消息层-----------------------------------------------------
function DcowLayer:showTishi(index)
  
    self.TishiBtn=index 
    if index == "0" then
        self.ztishi:getChildByName("Im"):loadTexture("xzsz.png",ccui.TextureResType.plistType)
    elseif index == "1" then
        self.ztishi:getChildByName("Im"):loadTexture("xzxz.png",ccui.TextureResType.plistType)
    elseif index == "2" then
        self.ztishi:getChildByName("Im"):loadTexture("xzszz.png",ccui.TextureResType.plistType)
    end
     self.ztishi:setVisible(true)
end
function DcowLayer:message(code,data)
   --ExternalFun.dump(data,"斗牛牛界面消息："..code)
    --gameStatus =1 空闲 =2 等待玩家进入  ==3 玩家已经够了.确认开始 4 游戏开始 5小结 6 大结算 21 抢庄.22 下注  23 摊牌
	if code == GameHead.ingame  then   						--进入房间消息
        self:reGame() ---初始化界面
        self.top:uptableid(data.tableId)
        --初始化游戏模式
        -- self.gamestutus=data.playing
    	self.banker = data.bankerChairForQiangZhuang
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
        --设置庄的位置
        if self.banker ~=-1 then
            local bankerindex=self.scene:getotherchair(self.banker)
            self.player:upbankplayer(bankerindex)
        end
        
		if  self.gameStatus == "3" and data.bankerChairForKsyx and data.bankerChairForKsyx == self.scene:getMechair() then
			self.B_k:setVisible(true)
		end
		--显示局数
		self.top:updcowjushu(data.dangQianQuanShu)
        
        --显示翻牌阶段和结算阶段--第五张
        if self.gameStatus ~="1" and self.gameStatus ~="2" and self.gameStatus ~="3" then
            for k,v in pairs(data.users) do 				 									--显示出来牌
                local otherindex=self.scene:getotherchair(v.chair)
                self.Card:pushonCard(otherindex)
            end
            --如果是抢庄模式或者是小结阶段
            if self.gameStatus =="5" and self.gameStatus == "23" then  
                for k,v in pairs(data.users) do
                    local otherindex=self.scene:getotherchair(v.chair)
                    if v.cards and #v.cards~= 0 and self.scene:getMechair() then
                        self.Card:showCard(otherindex,v.cards,v.px,nil,v.niuNiuBs,v.lastCards,self.gameStatus == "5")
                    end
                end
            end
            --  if MoShi == "1" then  
                for k,v in pairs(data.users) do
                    local otherindex=self.scene:getotherchair(v.chair)
                    if v.cards and #v.cards~= 0 and self.scene:getMechair() and otherindex == 1 and self.douNiuMingan=="1" then
                        self.Card:showCard(otherindex,v.cards,v.px,nil,v.niuNiuBs,v.lastCards)
                    end
                end
        end
        ----显示抢庄和下注情况
        for k,v in pairs(data.users) do
            local otherindex=self.scene:getotherchair(v.chair)
            if v.qiangZhuangBs then
                self.player:showqzbs(otherindex,v.qiangZhuangBs)
            end
            if v.xiaZhuBs then
                self.Card:updateplayercoin(otherindex,v.xiaZhuBs) 								--更新玩家桌子总注
            end
        end
        ---------显示各种按钮数据
        if self.scene:getMechair() then
            --显示抢庄倍数按钮
            if self.gameStatus == "21" then
                for k,v in pairs(data.users) do
                    local otherindex=self.scene:getotherchair(v.chair)
                    if otherindex == 1 and v.qiangZhuangBs ==nil then
                         self:showbeishu(data.qiangZhuangBs)
                    end
                end
            end
            --显示下注倍数按钮
            if self.gameStatus == "22" and self.banker~= self.scene:getMechair() then
                for k,v in pairs(data.users) do
                    local otherindex=self.scene:getotherchair(v.chair)
                    if otherindex == 1 and v.xiaZhuBs ==nil then
                        self:showxiazhu(data.xiaZhuBs)               --显示下注
                        self.betCoins=data.xiaZhuBs
                    end
                end
            end
        end
          --设置显示等待读秒
        local Seconds=data.waitForActionSeconds 
        if Seconds>0 then                              
            if self.gameStatus == "21" then
                self:SetGameClock(Seconds,1)
            elseif self.gameStatus == "22" then
                self:SetGameClock(Seconds,2)            
            elseif self.gameStatus == "23" then
                self:SetGameClock(Seconds,3)
            end
        end
	--更新玩家位置
	elseif code == GameHead.zbgame  then 						 						---准备消息
		if data.userCode == public.userCode then									--自己准备
			self.B_z:setVisible(false)
			self.wait:setVisible(false)
		end
    elseif code == GameHead.ztjoinplayer then
        self.wait:setVisible(false)
        self.B_z:setVisible(false)
        showToast("等待下局自动开始游戏",1)
	--删除玩家位置
	elseif code == GameHead.zkts then                     							--提示庄开启游戏按钮
    	self.B_k:setVisible(true)
    --阶段提示
    elseif code == DcowHead.nocice then
        self:reGame() 
        self:noShowBB()        
        if data.chairIndex == self.scene:getMechair() then
            self:showTishi(data.xunZhuang)
        else
            self.ztishi:setVisible(false)
        end
        --倒计时
        self:SetGameClock(data.remainTime,1)

    --操作已完成
    elseif code == DcowHead.Tcode then
        if data.chairIndex == self.scene:getMechair() then
            self.ztishi:setVisible(false)
        end
    elseif code == DcowHead.bgame then                     							--开始游戏界面
        self:reGame() 
        self:noShowBB()
        self.ztishi:setVisible(false)
        -- if self.scene:getMechair()  then            --判断是否已经开始游戏。用于退出房间
        --     self.gamestutus=false
        -- else
        --     self.gamestutus=false
        -- end
        self.banker=data.bankerIndex                 --保存庄家
        --设置庄家头像
        local bankerindex=self.scene:getotherchair(self.banker)
        self.player:upbankplayer(bankerindex)
    	                                 							--重置界面
        for k,v in pairs(data.users) do 				 									--显示出来牌
            local otherindex=self.scene:getotherchair(v.chair)
            self.Card:pushonCard(otherindex)
        end
         local call = function()
            if self.scene:getMechair() and self.banker ~= self.scene:getMechair() then
                self.sheMenJe=data.sheMenJe
                self.ht:getChildByName("B_1"):getChildByName("T"):setString(data.maxBetCoin)
                self.ht:getChildByName("B_2"):getChildByName("T"):setString(data.sheMenJe)
                self:setHt(data.maxBetCoin,data.sheMenJe)
                self.ht:setVisible(true)  
            end
         end 
                
        --更新自己手中的牌
        self.Card:sendThree(data.users,self.douNiuMingan=="1",call) ---sfmp 1为明牌 0为非明牌
        --更新奖池
        self.jcd:getChildByName("T"):setString(data.sumPoolCoin)
        --倒计时
        self:SetGameClock(data.remainTime,2)
        --显示局数
		self.top:updcowjushu(data.dangQianQuanShu)
        --桌面显示局数
        self.T:setString("第"..data.inningIndex.."/"..data.douNiuZjcj.."局")
        self.T:setVisible(true)
		--显示盲注
    elseif code == DcowHead.tqiang  then          --抢庄结果
        local index=self.scene:getotherchair(data.chairIndex)
        if  data.chairIndex== self.scene:getMechair() then
            self:noShowBB()                              --隐藏叫庄按钮
        end
        -------------------显示庄的倍数
        self.player:showqzbs(index,data.qiangZhuangBs)
        --显示标识
        self.player:upplayertz(index,data.qiangZhuangBs==0 and 2 or 3)
    elseif code == DcowHead.tqiangres    then             --叫庄的最后结果
        self:KillGameClock()
        self:noShowBB()                                  --隐藏叫庄按钮 
        self.banker=data.bankerUserChair                 --保存庄家
        local bankerChair=self.scene:getotherchair(data.bankerUserChair)
        local call = function()
                        --要显示倒计时的地方
            if self.scene:getMechair() and data.bankerUserChair ~=  self.scene:getMechair() then
                --显示倍数
                self:showxiazhu(data.betCoins)               --显示下注
                self.betCoins=data.betCoins
            end
            if data.tzUserCode then
                --推注标识
                for k,v in pairs(data.tzUserCode) do
                    local chair=self.scene:getchairindex(v)
                    self.player:upplayertz(chair,1)
                end
            end
            self:SetGameClock(data.remainTime,2)
        end 
        local qiangs={}
        for k,v in pairs(data.qiangZhuangInfo) do
            local index =self.scene:getotherchair(v)
            table.insert(qiangs,index)
           -- print("抢庄的玩家"..index)
        end
        --设置庄
        --self.player:setBankerUser(bankerChair,qiangs,call)
        --去掉标识
        self.player:colseplayertz()
        
    elseif code ==DcowHead.tcodexz       then            --显示玩家下注
        if data.chairIndex == self.scene:getMechair() then
            self:noShowBB()                              --隐藏下注按钮
        end
        local besChair=self.scene:getotherchair(data.chairIndex)
        self.player:upplayertzc(besChair)
        self.Card:updateplayercoin(besChair,data.bs) 								--更新玩家桌子总注
        self.scene:UpusersCoin(data.UserCode,data.wanJiaJinBi)                      --更新玩家列表里面的金币
        self.player:upScoreplayer(besChair,data.wanJiaJinBi)                        --更新玩家身上金币
        if data.betFlag ~= 0 then
            self.player:upplayertz(besChair,data.betFlag == 1 and 5 or 4)
        end
        --显示射门
        if data.sheMen =="1" then
            self.player:setshemen(besChair)                        --更新玩家身上金币
            ExternalFun.playSoundEffect("shemen",true)
        end
         
    elseif code ==DcowHead.tcodexzres       then            --显示玩家下注最终
        self:KillGameClock()
        self:noShowBB()
        --隐藏推注标识
        self.player:colseplayertz()
        local call = function()
            --要显示倒计时的地方
            if self.scene:getMechair() then
                self:showBP(true,true)                              --显示搓牌和不搓牌
            end
            self:SetGameClock(data.remainTime,3)
        end 
                                                            --明牌抢庄
            if self.scene:getMechair() then                  --按牌直接显示出牌
                local Cards={}
                for i=1,4 do
                    Cards[i]=data.orgCards[i]
                end
                self.Card:openCard(1,Cards,4)
            end
            
        call()

        self.LastCard=data.lastCard             --最后一张牌
        self.AllCard=data.pxCards               --排序后的牌
        self.Px=data.px                         --牌型
        self.niuNiuBs=data.niuNiuBs
        self.player:colseplayertz()
        self.player:upcuopai(0,true)
    elseif code == DcowHead.showp then                          --玩家翻牌
        self:noShowBB()
        local index =self.scene:getotherchair(data.userChair)  --操作得玩家
        local Sex= self.scene:getchairSex(data.userChair)
		self.Card:showCard(index,data.pxCards,data.px,Sex,data.niuNiuBs,data.lastCards)  
        if self.scene:getMechair() and self.scene:getMechair() ==data.userChair then
            self:showBP(false,false)
        end
        self.player:upcuopai(index,false)
	elseif code == DcowHead.smallend then 
		self:noShowBB()
        self:KillGameClock()
        self:showBP(false,false)
        self.player:upcuopai(0,false)
        if self:getChildByName("layerCuoCard3D") then                       --清理搓牌层
            self:getChildByName("layerCuoCard3D"):removeFromParent()
        end
		for k,v in pairs(data.data) do 											--更新玩家手中的牌及牌型
            local chair=self.scene:getotherchair(v.userChair)
            local Sex= self.scene:getchairSex(v.userChair)
            ExternalFun.dump(v.lastCard,"the last")
            self.Card:showCard(chair,v.pxCards,v.pxList,Sex,v.niuNiuBs,v.lastCard,true)
			self.scene:UpusersCoin(v.userCode,v.gameCoin)                      --更新玩家列表里面的金币
            --self.player:upScoreplayer(chair,v.gameCoin) 
            if v.userChair ==self.scene:getMechair() then
                if v.coin <0 then
                    self.player:DshowEnd(chair,v.coin,v.gameCoin,-1)
                else
                    self.player:DshowEnd(chair,v.coin,v.gameCoin,1)
                end
            else
                self.player:DshowEnd(chair,v.coin,v.gameCoin)
            end
            performWithDelay(self,function ()
                   self.player:upScoreplayer(chair,v.gameCoin) 
                   self.jcd:getChildByName("T"):setString(data.sumPoolCoins)
                end,2)            
        end

        performWithDelay(self,function ()
            -- if self.scene:getMechair() and self.banker == self.scene:getMechair() then            --判断是否已经开始游戏。用于退出房间
            --     self.gamestutus=true
            -- else
            --     self.gamestutus=false
            -- end
            self:SetGameClock(5,4)
        end,data.remainTime-5)
    elseif code == DcowHead.renshubuzu then
        showToast("人数不足,游戏重新开始！",3)
        self.gamestutus=false
        -- self:reGame(true)
        -- self.B_z:setVisible(true)
        -- self.wait:setVisible(true)       
	elseif code == DcowHead.bigend then
		local layer=GameEndLayer:create(self,data)
        layer:setName("GameEndLayer")
		self:addToRootLayer(layer,ZO.J)
	elseif code == DcowHead.nobgame then
		local tableinfo=public.gettableinfo(public.roomCode)
		if #data.users < tableinfo.canStartUserNum then
			showToast("玩家小于最少开局人数，请稍等",1)
		end
	end
end

return DcowLayer

