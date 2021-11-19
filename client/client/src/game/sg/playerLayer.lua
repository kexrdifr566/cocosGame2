local playerLayer = class("playerLayer", function ()
	local playerLayer =  display.newLayer()
	return playerLayer
end)
local playerCount=0
function playerLayer:ctor(scene,number)
	self.scene=scene
	if number < 4 or number >10 or number ==7 or number == 9 then
		showToast("房间人数错误！",1)
		return
	end
	playerCount=number

	local rootLayer, csbNode = ExternalFun.loadzRootCSB("Game/sgLayer/PlayerLayer.csb", self)
	for i = 6, 10 do
		if i ~=	7 and i ~=9 and  i ~= number then
			local player=string.format("P%d",i)
			csbNode:getChildByName(player):removeFromParent()
		end
	end
	local player=string.format("P%d",number)
	self.userLayer=csbNode:getChildByName(player)

	self.P={}
	for i =1,playerCount do
		local str=string.format("P%d",i)
		self.P[i]=self.userLayer:getChildByName(str)
		self.P[i]:setVisible(false)
	end
end
function playerLayer:reGame(bol)
    self:stopAllActions()
	for k,v in pairs(self.P) do
		v:getChildByName("zb"):setVisible(false) --隐藏准备状体
		v:getChildByName("z"):setVisible(false)	 --隐藏庄标识
		v:getChildByName("g"):setVisible(false)  --光
		v:getChildByName("L"):setVisible(false)  --转圈
		v:getChildByName("o"):setVisible(false)	 --离线状态
        v:getChildByName("qz"):setVisible(false) --抢庄倍数标识
        v:getChildByName("noq"):setVisible(false) --抢庄倍数标识
        v:getChildByName("c"):setVisible(false) --搓牌标识
        if v:getChildByName("num") then
            v:getChildByName("num"):removeFromParent()
        end
        if bol then
        	v:setVisible(false)
		end
	end
end
--玩家初始化
function playerLayer:inintplayer(index,data)
    self.P[index]:getChildByName("T1"):setString(data.userName)
    self.P[index]:getChildByName("T2"):setString(ExternalFun.numberTrans(data.gamecoin))
    local headbg=self.P[index]:getChildByName("head")
    --设置头像
    ExternalFun.createClipHead(headbg,data.userCode,data.logoUrl,70)
    self.P[index]:setVisible(true)
    if data.readyStatus then
		self:setplayerzb(index)
	end
end
--删除玩家
function playerLayer:deplayer(index)
    self.P[index]:getChildByName("T1"):setString("")
    self.P[index]:getChildByName("T2"):setString(0)
    local headbg=self.P[index]:getChildByName("head")
    --设置头像
    self.P[index]:setVisible(false)
end
--设置玩家准备
function playerLayer:setplayerzb(index)
    self.P[index]:getChildByName("zb"):setVisible(true)
end
--设置庄家
function playerLayer:upbankplayer(index)
    self.P[index]:getChildByName("z"):setVisible(true)
end
--更新玩家金币
function playerLayer:upScoreplayer(index,score)
    self.P[index]:getChildByName("T2"):setString(ExternalFun.numberTrans(score))
end
--------online
function playerLayer:uponline(index,ble)
    if index >=0 then
        self.P[index]:getChildByName("o"):setVisible(ble)
    end
end
function playerLayer:upcuopai(index,ble)
    if index ==0 then
        for k,v in pairs(self.P) do
            self.P[k]:getChildByName("c"):setVisible(ble)
        end
    else
       self.P[index]:getChildByName("c"):setVisible(ble) 
    end
end
--刷分其他人数据和分数
-- function playerLayer:upplayer(index,data,score,isBank,gameStatus)
-- 	if data and not self.P[index]:isVisible() then
-- 		self.P[index]:getChildByName("T1"):setString(data.userName)
--         print("玩家身上的金币数为"..data.gamecoin)
-- 		self.P[index]:getChildByName("T2"):setString(ExternalFun.numberTrans(data.gamecoin))
--         local headbg=self.P[index]:getChildByName("head")
--         --设置头像
--         ExternalFun.createClipHead(headbg,data.userCode,data.logoUrl,80)
-- 		self.P[index]:setVisible(true)
-- 	end
-- 	if score then
--           print("更新玩家身上的金币数为"..score)
-- 		self.P[index]:getChildByName("T2"):setString(ExternalFun.numberTrans(score))
-- 	end
-- 	if isBank then
-- 		self.P[index]:getChildByName("z"):setVisible(true)
-- 	end
-- 	if gameStatus then
-- 		self:setplayerzb(index)
-- 	end
-- end

----------------------显示读秒
function playerLayer:showG(index,time)
	self.P[index]:getChildByName("g"):setVisible(true)
	self.P[index]:getChildByName("L"):setVisible(true)
	local puke = CCSpriteFrameCache:getInstance():getSpriteFrame("tubiao2.png")
    local sp =  CCSprite:createWithSpriteFrame(puke)
	pp:setPosition(35,35)
	pp:setName("PP")
	self.P[index]:getChildByName("g"):add(pp)
	pp:setPercentage(100)
	pp:runAction(cc.Sequence:create(cc.ProgressTo:create(time, 0), cc.CallFunc:create(function()
	pp:removeFromParent()
    end)))
end
----------------------隐藏读秒
function playerLayer:hideG(index)
	self.P[index]:getChildByName("g"):setVisible(false)
	if self.P[index]:getChildByName("g"):getChildByName("PP") then
		self.P[index]:getChildByName("g"):getChildByName("PP"):stopAllActions()
		self.P[index]:getChildByName("g"):getChildByName("PP"):removeFromParent()
	end
	self.P[index]:getChildByName("L"):setVisible(false)
end
--显示出玩家的准备状态
function playerLayer:setplayerzb(index)
	self.P[index]:getChildByName("zb"):setVisible(true)
end
---定庄动画
function playerLayer:setBankerUser(wViewChairId,bankerList,xiazhuback)
    local callback = function()	
		--删除强庄标志
		for i = 1, playerCount do
			if i ~= wViewChairId and self.P[i]:isVisible() then
                self.P[i]:getChildByName("qz"):setVisible(false)
			end
		end
        self.P[wViewChairId]:getChildByName("z"):setVisible(true)
        self.P[wViewChairId]:getChildByName("L"):setVisible(true)
        --已经完成了叫庄过程
         --print("定为庄家的人为"..wViewChairId)
        xiazhuback()
	end

	if bankerList == nil then
		bankerList = {}
	end
	if #bankerList < 2 then
		callback()
	else
        ExternalFun.playSoundEffect("ranbanker",true)
        local trencounts=2
        if #bankerList ==2 then
            trencounts = 5 
        elseif #bankerList == 3 then
            trencounts = 4
        elseif #bankerList == 4 then
            trencounts = 3
        end
		local anitime = 0.07
		local acts = {}
		for j = 1, trencounts do
			for k,v in pairs(bankerList) do
                --print("显示庄"..v)
				local cc1 = cc.CallFunc:create(function() self.P[v]:getChildByName("L"):setVisible(true)
					
				end)
				local de1 = cc.DelayTime:create(anitime)
				local cc2 = cc.CallFunc:create(function() self.P[v]:getChildByName("L"):setVisible(false) end)
				local de2 = cc.DelayTime:create(anitime)
				
				table.insert(acts, cc1)
				table.insert(acts, de1)
				table.insert(acts, cc2)
				table.insert(acts, de2)
			end
		end
		local detime = trencounts *0.07 * #bankerList
		table.insert(acts, cc.DelayTime:create(detime))
		table.insert(acts, cc.CallFunc:create(function() 
			--print("setBankerUser>>>11")
			callback() 
		end))
		local seq = cc.Sequence:create(acts)
		self:runAction(seq)
	end
end
--显示出玩家的抢庄倍数
function playerLayer:showqzbs(index,bs)
    if  bs ~= 0 then
        local str=string.format("/%d",bs)
        self.P[index]:getChildByName("qz"):setString(str)
        self.P[index]:getChildByName("qz"):setVisible(true)
    elseif bs == 0 then
        self.P[index]:getChildByName("noq"):setVisible(true)
    end
    if bs < 6 then
        local str=string.format("cow/rate%d",bs)
        ExternalFun.playSoundEffect(str,true)
    end
end
--隐藏所有玩家准备状态
function playerLayer:notplayerzb()
end

function playerLayer:showEnd(index,changescore,gameCoin,ying)

	local fontstr =nil
	if changescore >= 0 then
		fontstr = "Game/public/num1.png"
	elseif changescore < 0 then
		fontstr = "Game/public/num2.png"
	end
	local str="/"..math.abs(changescore)
	local num=cc.LabelAtlas:create(str,fontstr,26, 32, string.byte("."))
	num:setAnchorPoint(0.5, 0.5)
	self.P[index]:add(num)
    num:setName("num")
	num:setPosition(cc.p(0,20))
	self.P[index]:setVisible(true)
	local call = cc.CallFunc:create(function( )
		--if not tolua.isnull(self.m_atlasScore) then
            
			--num:removeFromParent()
            
    --end
	end)
	local moveBy = cc.MoveTo:create(0.4, cc.p(0, 55))
	local standby = cc.DelayTime:create(3)
	local fadeout = cc.FadeOut:create(0.5)

	local m_actShowScore = cc.Sequence:create(moveBy,standby,fadeout,call)
	num:runAction(m_actShowScore)
	-- local bank=self.scene:getbankview()
	-- performWithDelay(self,function( ... )
 --        self:upScoreplayer(index,gameCoin)
	-- 	if bank ~= index and changescore < 0  then
	-- 		self.scene:showGoldToAreaWithID(cc.p(self.P[index]:getPosition()),cc.p(self.P[bank]:getPosition()))
 --            ExternalFun.playSoundEffect("fly_gold",true)
	-- 	end

	-- 	performWithDelay(self,function( ... )
	-- 		if bank ~= index and changescore > 0  then
	-- 			self.scene:showGoldToAreaWithID(cc.p(self.P[bank]:getPosition()),cc.p(self.P[index]:getPosition()))
 --                ExternalFun.playSoundEffect("fly_gold",true)
	-- 		end
	-- 	end,0.4)
       
	-- end,2)
     if ying then
            if ying ==1 then
                ExternalFun.playSoundEffect("win",true)
            else
                 ExternalFun.playSoundEffect("lose",true)
            end
        end
end

return playerLayer

