local dzLayer = class("dzLayer", function ()
	local dzLayer =  display.newLayer()
	return dzLayer
end)
local playerLayer=appdf.req(appdf.GAME_SRC.."dz.playerLayer")
local CardLayer=appdf.req(appdf.GAME_SRC.."dz.CardLayer")
local xiaojieLayer=appdf.req(appdf.GAME_SRC.."dz.xiaojieLayer")
local GameEndLayer=appdf.req(appdf.GAME_SRC.."public.GameEndLayer")
local TopLayer=appdf.req(appdf.GAME_SRC.."public.TopLayer")
local PlayC=0
local PlayerTime=0
local enumTable = {
	"P", 			--用户层
	"C", 			--牌层
	"G", 			--金币层
	"T", 			--功能列表层
	"J",			--结算层
	"S",			--设置层
}
local ZO = ExternalFun.declarEnumWithTable(100, enumTable)
function dzLayer:ctor(_scene)

	self:playerinint()

	self.scene=_scene
	--获取房间人数
	PlayC=self.scene:getplayercont()

	local rootLayer, csbNode = ExternalFun.loadRootCSB("Game/dzLayer/dzLayer.csb", self)
	self.bj=csbNode:getChildByName("bj")

    local btcallback = function (ref, type)
		if type == ccui.TouchEventType.ended then
				ref:setScale(1)
				ExternalFun.playClickEffect()
			self:onButtonClickedEvent(ref:getTag(),ref)
		elseif type == ccui.TouchEventType.began then
				ref:setScale(public.btscale)
			return true
		elseif type == ccui.TouchEventType.canceled then
				ref:setScale(1)
		end
	end

	--下方操作
	self.down=self.bj:getChildByName("down")
	self.down:setLocalZOrder(ZO.T)

	self.wait=self.bj:getChildByName("wait")
	self.wait:setVisible(false)

    self.BB={}
	for i=1,7 do
		if i~= 2 then
			local bb=string.format("B_%d",i)
			local BAN=self.down:getChildByName(bb)
			BAN:setTag(i+10)
	        BAN:addTouchEventListener(btcallback)
	        self.BB[i]=BAN
    	end
	end
	self.B_z=self.down:getChildByName("B_z")--准备
	self.B_z:setTag(21)
	self.B_z:addTouchEventListener(btcallback)
    self.B_z:setVisible(false)

	self.B_k=self.down:getChildByName("B_k")--庄
	self.B_k:setTag(22)
	self.B_k:addTouchEventListener(btcallback)

	self.BJ={}
	for i=1,4 do
		local bb=string.format("B_1%d",i)
		local BAN=self.down:getChildByName(bb)
		BAN:setTag(i+30)
	    BAN:addTouchEventListener(btcallback)
	    self.BJ[i]=BAN
	end
    self.ht=self.down:getChildByName("h")
    self.ht:getChildByName("B")
    :setTag(50)
    :addTouchEventListener(btcallback)
    local function sliderFunC(sender, tType)
		if tType == ccui.SliderEventType.percentChanged then
            self:setHdVolume(sender:getPercent())
		end
    end
	--初始化用户
	self.player = playerLayer:create(self,PlayC)
	self:addToRootLayer(self.player,ZO.P)

	--初始化扑克
	self.Card = CardLayer:create(self,PlayC)
	self:addToRootLayer(self.Card,ZO.C)

	self.xiaojie =xiaojieLayer:create()
	self:addToRootLayer(self.xiaojie,ZO.J)
    --self.xiaojie:setVisible(true)
    
	self.top =TopLayer:create(self)
	self:addToRootLayer(self.top,ZO.T)
    self.ht:getChildByName("Slider"):addEventListenerSlider(sliderFunC)
	self:changebj()
	self:reGame()                   --重置桌面信息
	self:topinint(1)

	--测试动画
	-- local cards={{suit=2,rank=3},{suit=2,rank=3},{suit=2,rank=3}}
	-- performWithDelay(self,function ()
		-- self.Card:onCenterCard(cards)
	-- end,3)
    
    self.gamestutus= false			--游戏状态
end
function dzLayer:setHdVolume(baifenbi)
    -- do somethings
    local jiandu=math.floor(self.h_max/100*baifenbi)+self.h_min
    
    if jiandu > self.h_max then
        jiandu=self.h_max
    end
    self.ht:getChildByName("Slider"):getChildByName("Image"):getChildByName("T"):setString(jiandu)
    self.ht:getChildByName("Slider"):getChildByName("Image"):setPositionX(370/100*baifenbi) 
    --print("滑动"..baifenbi.." "..self.h_max.."  "..self.h_min)
end
function dzLayer:setHt(min,max)
   self.ht:getChildByName("Slider"):setPercent(0)
    self.ht:getChildByName("Slider"):getChildByName("Image"):setPositionX(0) 
    self.h_min=min
    self.h_max=max
    self.ht:getChildByName("Slider"):getChildByName("Image"):getChildByName("T"):setString(min)
end
function dzLayer:changebj()
	local bjindex = cc.UserDefault:getInstance():getIntegerForKey("DZBJ", 1)
	local str = string.format("Game/public/shezhi/bj%d.png",bjindex)
	self.bj:setBackGroundImage(str)
	self.Card:changebj()
end
function dzLayer:reGame(bol) 				   -----------重置界面
    self:stopAllActions()
	self.player:reGame(bol)                   --玩家信息
	self.Card:reGame()                     --重置下注和牌的信息
	self:noShowBB() 					   --隐藏操纵按钮
	-- self.B_z:setVisible(false)
	self.B_k:setVisible(false)
	self:playerinint()
	self.xiaojie:setVisible(false)
    
end
function dzLayer:playerinint()
	
	self.banker=0					--庄
	self.betCoin=0					--加注分数
	self.poolCoin =0                --奖池分数
    self.h_min=0                    --滑轮最低
    self.h_max=0                    --滑轮最高
	self.gendaodi = false
	self.raiseCoinSettings={}		--加注情况
end
function dzLayer:topinint(jushu)
	self.top:updateT(jushu)
end
function dzLayer:onButtonClickedEvent(tag,ref)
	--print("操作"..tag )
    if tag > 10 and tag < 17 and tag ~= 15 then  --玩家的操作。
    	local data ={}
    	data.actionCode =DzHead.action[tag-10]
    	gst.send(DzHead.tcode,data)
    elseif tag == 15 then                       --加注按钮
    	if self.BJ[1]:isVisible() then
    		for k,v in pairs(self.BJ) do
                v:setVisible(false)				   	--清楚所有控制按钮
			end
            self.ht:setVisible(false)
		else
			for k,v in pairs(self.raiseCoinSettings) do
				self.BJ[k]:getChildByName("T"):setString(v)
				self.BJ[k]:setVisible(true)				   	--清楚所有控制按钮
			end
            self.ht:setVisible(true)
    	end
   	elseif tag == 17 then                       --跟到底
    	if ref:isSelected() then
    		self.gendaodi = false
    	else
    		self.gendaodi = true
            local data ={}
            data.actionCode =DzHead.action[7]
            gst.send(DzHead.tcode,data)
    	end
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
    	data.actionCode =DzHead.action[5]
    	data.coin = add
    	gst.send(DzHead.tcode,data)
    elseif tag  == 50 then
    	local data ={}
        if self.ht:getChildByName("Slider"):getPercent()~=0 then
            data.actionCode =DzHead.action[5]
            data.coin = self.ht:getChildByName("Slider"):getChildByName("Image"):getChildByName("T"):getString()
        else
            data.actionCode =DzHead.action[3]
        end
    	gst.send(DzHead.tcode,data)
	end
end
function dzLayer:addToRootLayer(node, zorder)
	if nil == node then
		return
	end
	self.bj:addChild(node)
	node:setLocalZOrder(zorder or 0)
end
function dzLayer:noShowBB()
    for k,v in pairs(self.BB) do
		v:setVisible(false)				   									--清楚所有控制按钮
	end
    for k,v in pairs(self.BJ) do
		v:setVisible(false)				   									--清楚所有控制按钮
    end
    self.ht:setVisible(false)
    self.raiseCoinSettings={}
end

function dzLayer:getbankview()                                              --获取庄现在得位置
	return self.scene:getotherchair(self.banker)
end

--飞金币动画
function dzLayer:showGoldToAreaWithID(beganviewid,endviewid)
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

--------------------------------------------------------------消息层-----------------------------------------------------

function dzLayer:message(code,data)
	--print("德州界面消息："..code.."       时间: "..os.date("%c", os.time()))
    --dump(data,"德州界面收到消息 code="..code)
	if code == GameHead.ingame  then   						--进入房间消息
		self:reGame() ---初始化界面
        self.top:uptableid(data.tableId)
		--设置庄
    	self.banker = data.bankerIndex
    	--初始游戏状态
		self.gameStatus=data.gameStatus
        self.gamestutus=data.playing
		PlayerTime=data.waitForActionSeconds
		--初始化准备按钮
		if not self.scene:getMechair() then --是不是旁观的人
            if data.joinModel and data.joinModel == 1 then   --观战的人永远都不能出现准备
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
            --status 1:fold（弃牌） 2:auto bet（一跟到底） 3:all in（梭哈） 4.游戏中 5.已准备 7.观战 (6.离线， 弃用，这里不使用6)
			local otherindex=self.scene:getotherchair(v.chair)
            if otherindex == 1 and v.status =="2" then  --更新跟到底的状态
                self.gendaodi=true
            end
            self.BB[7]:setSelected(true)
            -- if v.status ~= 7 then           --如果玩家不是观战玩家 --更新位置
            --     self.player:upplayer(otherindex,v,nil,self.banker == v.chair,v.status == "5")
            -- end
		end
		if  self.gameStatus == "3" and self.banker == self.scene:getMechair() then
			self.B_k:setVisible(true)
		end
		---------------------------如果是空闲状态
		if self.gameStatus  ~= "1" and self.gameStatus ~= "2" and self.gameStatus ~= "3" then			--空闲玩家不需要更新界面情况
			if data.poolCoin then
				self.poolCoin = data.poolCoin											--更新桌面总注
				self.Card:updatezongzhu(self.poolCoin)
			end
			if data.betCoin then
				self.betCoin = data.betCoin			 									--更新桌面总注
				self.BB[3]:getChildByName("T"):setString(self.betCoin) 					--设置加注金额
			end
			--显示牌数据
			for k,v in pairs(data.users) do
				local otherindex=self.scene:getotherchair(v.chair)
				--dump(v.cards,"玩家牌的数据")
				if v.cards and #v.cards ~= 0 and v.userCode == public.userCode then
					self.Card:sendCard(v.cards)
					self.Card:updataMeCard(v.cards)
				else
					self.Card:pushonCard(otherindex)
				end
				if v.coins then
					self.Card:updateplayercoin(otherindex,v.coins)
				end
				--放弃状态
				if v.status =="1" then
					self.Card:upplayerpaixing(otherindex)
				end
				--离线状态
				if v.online ==false then
					self.player:uponline(otherindex,true)
				end
			end
			if data.acttingUserCode == public.userCode  then						--操作人是我则
                if data.acttingActions then
                    for k,v in pairs(data.acttingActions) do
                        local index = tonumber(v)
                        self.BB[index]:setVisible(true)
                    end
                end
			end
			----显示亮度
			if  data.acttingUserCode then
				local index =self.scene:getchairindex(data.acttingUserCode)  --操作得玩家
				self.player:showG(index,PlayerTime)
			end
			--显示中间牌
			if data.board then
				self.Card:onCenterCard(data.board)										--设置中间得牌
			end
			--注的筹码
			if data.raiseCoinSettings	then
				self.raiseCoinSettings=data.raiseCoinSettings								--玩家加注情况加注值
			end
			--显示盲注
			if data.bigBlindUserCode then
				local mangindex=self.scene:getchairindex(data.bigBlindUserCode)
				--print("大盲注座位号"..mangindex)
				self.player:showMang(mangindex,true)
			end
			if data.smallBlindUserCode then
				local mangindex=self.scene:getchairindex(data.smallBlindUserCode)
				--print("小盲注座位号"..mangindex)
				self.player:showMang(mangindex)
			end

		end
		--显示局数
		self:topinint(data.inningIndex)
        
        --判断是否开始游戏
        if inningIndex ==0 and self.gameStatus =="0" and self.scene:getMechair()  then            --判断是否已经开始游戏。用于退出房间
            self.gamestutus=true
        end
        -- self:setHt(1,100)
        -- self.ht:setVisible(true)
	--更新玩家位置
	elseif code == GameHead.zbgame  then 						 						---准备消息
		if data.userCode == public.userCode then									--自己准备
			self.B_z:setVisible(false)
			self.wait:setVisible(false)
           -- self.gamestutus=true
		-- 	if self.gameStatus =="1" or self.gameStatus =="2" or self.gameStatus=="3" then
		-- 		self:reGame(true)
		-- 		local users=self.scene.users
		-- 		for k,v in pairs(users) do 											--初始玩家信息
		-- 			local otherindex=self.scene:getotherchair(v.chair)
		-- 			self.player:upplayer(otherindex,v,nil,self.banker == v.chair,true)
		-- 		end
		-- 	end
		-- else
		-- 	local otherindex=self.scene:getotherchair(data.chair)
		-- 	self.player:upplayer(otherindex,data,nil,self.banker == data.chair,true)
		end
    elseif code == GameHead.ztjoinplayer then
        self.wait:setVisible(false)
        self.B_z:setVisible(false)
        showToast("等待下局自动开始游戏",1)
	--删除玩家位置
	elseif code == GameHead.tcgame  then
		-- self:reGame(true)
		-- local users=self.scene.users
		-- for k,v in pairs(users) do 											--初始玩家信息
		-- 	local otherindex=self.scene:getotherchair(v.chair)
		-- 	self.player:upplayer(otherindex,v,nil,self.banker == v.chair,true)
		-- end
	elseif code == GameHead.zkts then                     							--提示庄开启游戏按钮
    	self.B_k:setVisible(true)
    elseif code == DzHead.bgame then                     							--开始游戏界面
        
        
    	self:reGame()                                    							--重置界面
		self.gameStatus = "4"
        if self.scene:getMechair()  then            --判断是否已经开始游戏。用于退出房间
            self.gamestutus=true
        end
        
        self.gendaodi=false                                                         --每局一刷新跟到底按钮
        self.BB[7]:setSelected(false)
    
    	--设置庄
		self.banker = data.bankerIndex
		--local otherindex=self.scene:getotherchair(self.banker)
        --设置庄的位置
        if self.banker ~=-1 then
            local bankerindex=self.scene:getotherchair(self.banker)
            self.player:upbankplayer(bankerindex)
        end
        
		--更新庄家
		-- self.player:upplayer(otherindex,nil,nil,true,nil)
		local users=self.scene.users
		local minCoin = self.scene:getTableminCoin()
		for k,v in pairs(users) do 				 									--更新个人总注/更新牌
    		local otherindex=self.scene:getotherchair(v.chair)
    		self.Card:updateplayercoin(otherindex,minCoin)
			self.Card:pushonCard(otherindex)
    	end
		--更新自己手中的牌
		self.Card:sendCard(data.cards)
		--显示局数
		self:topinint(data.inningIndex)
		--显示盲注
		local mangindex=self.scene:getchairindex(data.bigBlindUserCode)
		self.player:showMang(mangindex,true)
		mangindex=self.scene:getchairindex(data.smallBlindUserCode)
		self.player:showMang(mangindex)
        
        --更新玩家身上的金币和列表中的金币
        -- for k,v in pairs(data.users)do        
        --     self.scene:UpusersCoin(v.userCode,v.gameCoin)                      --更新玩家列表里面的金币
        --     local besChair=self.scene:getotherchair(v.chair)
        --     self.player:upScoreplayer(besChair,v.gameCoin)                        --更新玩家身上金币
        -- end

	elseif code == DzHead.upscore then                     						--更新牌桌信息
		self:noShowBB()
		self.poolCoin = data.poolCoin					 							--奖池分数
		self.betCoin = data.betCoin			 										--更新桌面总注
    	self.Card:updatezongzhu(self.poolCoin)
		self.BB[3]:getChildByName("T"):setString(self.betCoin) 						--设置加注金额

		for k,v in pairs(data.users) do
			-- local chair =self.scene:getchairindex(v.userCode)
			-- self.Card:updateplayercoin(chair,v.coin) 								--更新玩家桌子总注
			-- self.player:upplayer(chair,nil,v.gameCoin)  						--更新玩家身上金币
            
            self.scene:UpusersCoin(v.userCode,v.gameCoin)                      --更新玩家列表里面的金币
            local besChair=self.scene:getchairindex(v.userCode)
            self.Card:updateplayercoin(besChair,v.coin) 
            self.player:upScoreplayer(besChair,v.gameCoin)                        --更新玩家身上金币
		end
	elseif code == DzHead.code then 
        self.xiaojie:setVisible(false)        --预防卡界面
		if data.userCode == public.userCode  then
			for k,v in pairs(data.actions) do
				local index = tonumber(v)
				self.BB[index]:setVisible(true)
			end											--跟到底一直显示
		end
		self.betCoin = data.betCoin
		self.BB[3]:getChildByName("T"):setString(self.betCoin)
        if  data.hlCoinSettings and  data.hlCoinSettings[2] then
            self:setHt(data.hlCoinSettings[1],data.hlCoinSettings[2])
        end
		self.raiseCoinSettings=data.raiseCoinSettings								--玩家加注情况加注值
		local index =self.scene:getchairindex(data.userCode)  --操作得玩家
        self.player:AllHideG()                                                      --隐藏所有玩家读秒
        --if index == -1 then
        self.player:showG(index,PlayerTime)                                         --显示玩家读秒
        --end
	elseif code == DzHead.tzcode then                                                --通知玩家已经操作完
		self.xiaojie:setVisible(false)        --预防卡界面
        self:noShowBB()
		if data.actionCode =="4" then                   							--放弃
			local chair = self.scene:getchairindex(data.userCode)
			self.Card:upplayerpaixing(chair)
		end
		local index =self.scene:getchairindex(data.userCode)  --操作得玩家
        if index ~= -1 then
            self.player:hideG(index)
        end
        -- action      =       {1,nil,3,4,5,6,7},                         --1:全押2.错误 3.跟进4.不跟5.加注6.让牌 7.跟到底"
        local str={"suoha","","gen","qi","jia","guo","gen"}
        local Sex= self.scene:getuserCodeSex(data.userCode)
        ExternalFun.playSoundEffect(str[tonumber(data.actionCode)],false,Sex)
	elseif code == DzHead.upzcard then 												--中间的牌
		self.Card:onCenterCard(data.cards)
	elseif code == GameHead.online or code ==GameHead.noonline then
		-- local index =self.scene:getchairindex(data.userCode)  --操作得玩家
		-- self.player:uponline(index,code==GameHead.noonline)
	elseif code == DzHead.smallend then 
		self:noShowBB()											--小结算
		for k,v in pairs(data.users) do 											--更新玩家手中的牌及牌型
			local chair =self.scene:getchairindex(v.userCode)
			self.Card:updataAllCard(chair,v.cards,v.pxValue)
			self.scene:UpusersCoin(v.userCode,v.gameCoin)                      --更新玩家列表里面的金币
            if chair ==self.scene:getMechair() then
                if v.endcoin <0 then
                    self.player:showEnd(chair,v.endcoin,v.gameCoin,-1)
                else
                    self.player:showEnd(chair,v.endcoin,v.gameCoin,1)
                end
            else
                self.player:showEnd(chair,v.endcoin,v.gameCoin)
            end	
		end
		if data.endHandType == "2" then
			performWithDelay(self,function( ... )
				self.xiaojie:inint(data)
				self.xiaojie:setVisible(true)
			end,5)
		end
	elseif code == DzHead.bigend then
		local layer=GameEndLayer:create(self,data)
        layer:setName("GameEndLayer")
		self:addToRootLayer(layer,ZO.J)
	elseif code == DzHead.nobgame then
		-- self.scene.users = data.users
		-- self:reGame(true)
		-- for k,v in pairs(data.users) do 											--初始玩家信息
		-- 	local otherindex=self.scene:getotherchair(v.chair)
  --           if v.status ~= 7 then           --如果玩家不是观战玩家 --更新位置
  --               self.player:upplayer(otherindex,v,nil,self.banker == v.chair,v.status == "5")
  --           end
		-- end
		local tableinfo=public.gettableinfo(public.roomCode)
		if #data.users < tableinfo.canStartUserNum then
			showToast("玩家小于最少开局人数，请稍等",1)
		end
    elseif code == GameHead.swatchplayer then
        local watchlayer=self.top:getChildByName("watch") 
        if watchlayer and watchlayer.inint then
            watchlayer:inint(data)
        end
	end
end

return dzLayer

