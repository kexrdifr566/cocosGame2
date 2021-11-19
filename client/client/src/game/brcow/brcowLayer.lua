local brcowLayer = class("brcowLayer", function ()
	local brcowLayer =  display.newLayer()
	return brcowLayer
end)
local BrSettingLayer=appdf.req(appdf.GAME_SRC.."brpublic.BrSettingLayer")
local BrPlayerListLayer=appdf.req(appdf.GAME_SRC.."brpublic.BrPlayerListLayer")
local TrendLayer=appdf.req(appdf.GAME_SRC.."brpublic.BrTrendLayer")
local BrRuleLayer=appdf.req(appdf.GAME_SRC.."brpublic.BrRuleLayer")
local beilv={1,3,11,1,3,11,1,3,11}
function brcowLayer:ctor(_scene)

	self:playerinint()

	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Game/brLayer/brcowLayer.csb", self)
	self.bj=csbNode:getChildByName("bj")
    
    self.gamelay=self.bj:getChildByName("game")
    self.top=self.bj:getChildByName("top")
    self.down=self.bj:getChildByName("down")
    self.pai=self.bj:getChildByName("pai")
    self.player=self.bj:getChildByName("player")
    self.coumaLayer=self.bj:getChildByName("chouma")
    self.action=self.bj:getChildByName("action")
    local btcallback = function (ref, type)
		if type == ccui.TouchEventType.ended then 
				ref:setScale(1)
                if ref:getTag() <=50 or ref:getTag()>= 60 then 
                    ExternalFun.playClickEffect()
                end
			self:onButtonClickedEvent(ref:getTag(),ref)
		elseif type == ccui.TouchEventType.began then
				ref:setScale(public.btscale)
			return true
		elseif type == ccui.TouchEventType.canceled then 
				ref:setScale(1)
		end
	end
    
    --上面按钮
    for i=1,7 do
		local bb=string.format("b%d",i)
		local BAN=self.top:getChildByName(bb)
		BAN:setTag(i)
	    BAN:addTouchEventListener(btcallback)
        if i == 2 then
            self.B_shangzhuang=BAN
            self.B_shangzhuang:setVisible(false)
        elseif i == 5 then
            self.B_xiazhuang=BAN
            self.B_xiazhuang:setVisible(false)
        elseif i == 6 then
            self.B_quxiao=BAN
            self.B_quxiao:setVisible(false)
        end
	end
    
    --续投按钮
    self.B_xutou=self.down:getChildByName("b1")
    self.B_xutou:setTag(8)
    self.B_xutou:addTouchEventListener(btcallback)
    --续投按钮
    self.down:getChildByName("b2")
        :setTag(99)
        :addTouchEventListener(btcallback)
    --所有玩家按钮
    self.B_Allp=self.player:getChildByName("b")
    self.B_Allp:setTag(9)
    self.B_Allp:addTouchEventListener(btcallback)
    
    --房间号
    self.Roomnumber=self.top:getChildByName("T")
    self.Roomnumber:setString("")
    --self.Roomnumber:setVisible(false)
    
    self.KeTou=self.top:getChildByName("T1")
    self.YiTou=self.top:getChildByName("T2")
    self.gameim=self.top:getChildByName("time")
    
     --中间区域按钮
    self.QY={}
    for i=1,9 do
		local bb=string.format("b%d",i)
		local BAN=self.gamelay:getChildByName(bb)
		BAN:setTag(i+50)
	    BAN:addTouchEventListener(btcallback)
        self.QY[i]=BAN
        self.QY[i]:setEnabled(false)
	end
    

    --筹码层
    self.CM={}
    for i=1,5 do
		local bb=string.format("c%d",i)
		local BAN=self.down:getChildByName(bb)
		BAN:setTag(i+80)
	    BAN:addTouchEventListener(btcallback)
        self.CM[i]=BAN
	end
    
    --牌
    self.Card={}
    self.Cardpoint={}
    for i=1,4 do
		local card1=self.pai:getChildByName(string.format("p%d_1",i))
		local card2=self.pai:getChildByName(string.format("p%d_2",i))
        local card3=self.pai:getChildByName(string.format("p%d_3",i))
        local card4=self.pai:getChildByName(string.format("p%d_4",i))
        local card5=self.pai:getChildByName(string.format("p%d_5",i))
		self.Card[i]={card1,card2,card3,card4,card5}
        self.Cardpoint[i]={{x=card1:getPositionX(),y=card1:getPositionY()},{x=card2:getPositionX(),y=card2:getPositionY()}
            ,{x=card3:getPositionX(),y=card3:getPositionY()},{x=card4:getPositionX(),y=card4:getPositionY()}
            ,{x=card5:getPositionX(),y=card5:getPositionY()}}
	end
    
    self.Paixing={}
    --牌型
    for i=1,4 do
		local paixing=string.format("px%d",i)
		self.Paixing[i]=self.pai:getChildByName(paixing)
	end
    --富豪榜
    self.p_l=self.player:getChildByName("p_l")
    --神算子
    self.p_r=self.player:getChildByName("p_r")
    --庄的node
    self.zhuangNode=self.player:getChildByName("player")
    --庄的列表
    self.p_t=self.player:getChildByName("p_t")
    --隐藏赢的动画
    self.action:setVisible(true)
    --自己信息
    self.ziji=self.player:getChildByName("zj")
    self:updateMyScore()                --更新自己的分数
	self:changebj()                     --更换背景
    self:changcmbl()                    --更换筹码比例
	self:reGame(true)                   --重置桌面信息 
end
function brcowLayer:changcmbl()
    local tableinfo=public.gettableinfo(public.roomCode)
    if tableinfo.cmbl == 1 then
        self.couma={1,10,100,500,1000}
        for k,v in pairs(self.CM) do
            local str =string.format("cm%d.png",self.couma[k])
            v:loadTextureNormal(str,ccui.TextureResType.plistType)
            v:loadTexturePressed(str,ccui.TextureResType.plistType)
            str =string.format("cm%db.png",self.couma[k])
            v:loadTextureDisabled(str,ccui.TextureResType.plistType)
        end
    else
        self.couma={10,50,100,500,1000}
    end
end
function brcowLayer:changebj()
	local bjindex = cc.UserDefault:getInstance():getIntegerForKey("BRCOWBJ", 1)
	local str = string.format("Game/brpublic/brbj%d.png",bjindex)
	self.bj:setBackGroundImage(str)
end
function brcowLayer:reGame(bol) 				   -----------重置界面
    self:stopAllActions()
    self.KeTou:setString("可投注:0")
    self.YiTou:setString("已投注:0")
    self.B_xutou:setEnabled(false)
    self.coumaLayer:removeAllChildren()
    self:settingcouma(false)
    --牌及牌型隐藏
    for i=1,4 do
		for a=1,3 do
            self.Card[i][a]:setVisible(false)
        end
        self.Paixing[i]:setVisible(false)
	end
    --清理牌资源
    self:setCardBack(false)
    
    --清理区域下注情况
    for i=1,9 do
        local bb=self.QY[i]
        bb:getChildByName("T1"):setString("0")
        bb:getChildByName("T1"):setVisible(false)
        bb:getChildByName("T2"):setString("0")
        bb:getChildByName("T2"):setVisible(false)
	end
    
    if bol then
        --富豪榜and神算子
        for i=1,6 do
            local bb=string.format("p%d",i)
            self.p_l:getChildByName(bb):setVisible(false)
            self.p_r:getChildByName(bb):setVisible(false)
        end
         --庄家榜
        self.p_t:removeAllChildren()
        --下庄按钮
        self.B_xiazhuang:setVisible(false)
        self.B_Allp:getChildByName("T"):setString("0人")
        --选中筹码
        self:SelectChouma(1)
    end
    self.statusXia=false            --是否可以下注
    self.isZhuang=false             --是否是庄家
    self.isXiazhu=false             --是否是下注玩家
    self:setXiaZhuQY()
    self.xiazhuStatus=false
    --时间
    self.gameim:setVisible(false)
    self:KillGameClock()                    --关闭游戏提示
    self.m_fJettonTime =2
    self.OtherTou={}
    --self:killotherTou()    
end
function brcowLayer:playerinint()
	self.gamestutus= false			--游戏状态
    self.SelChouma=0                --选中筹码
    self.fuhaolist={}               --富豪表
    self.suanzilist={}              --神算子表
    self.zhuanglist={}              --庄家列表
    self.Myscore=0                  --自己的金币数目
    self.Times={}                   --所有阶段时间
    self.shangzhuangscore=0         --上庄分数
    self.statusXia=false            --是否可以下注
    self.isZhuang=false             --是否是庄家
    self.zongzhulist={0,0,0,0,0,0,0,0,0}             --总住列表
    self.Metouzhulist={0,0,0,0,0,0,0,0,0}             --总住列表
    self.XutouChouma={0,0,0,0,0,0,0,0,0}             --续投筹码
    self.isXiazhu=false
    self.KeTouScore=0
    self.YiTouScore=0
    self.OtherTou={}
    	--金币列表
	self.m_coumaList = {{}, {}, {}, {}, {}, {}, {}, {}, {}}
end
function brcowLayer:SelectChouma(index)
    --筹码已经选中
    if self.SelChouma == index then
        return
    end
    if self.SelChouma~= 0 then
        local posY = self.CM[self.SelChouma]:getPositionY()
        self.CM[self.SelChouma]:setPositionY(posY - 15)
    end
    local posY = self.CM[index]:getPositionY()
    self.CM[index]:setPositionY(posY + 15)
    self.SelChouma=index
end
function brcowLayer:settingcouma(ble)
        --筹码不可用状态
    for k,v in pairs(self.CM) do
        v:setEnabled(ble)
    end
end
function brcowLayer:onButtonClickedEvent(tag,ref)
	--print("操作"..tag )
    if tag == 1 then                    --退出游戏
        if self.isZhuang then
            showToast("庄家不允许退出游戏")
            return
        end
        if self.isXiazhu then
            showToast("您已经下注无法离开游戏!")
            return
        end
        self.scene:closeGame()
    elseif tag == 2 then                --上庄按钮
        if self.shangzhuangscore >self.Myscore then
            showToast("分数不足无法申请上庄",2)
            return
        end
        local data ={}
		data.actionCode =BaiRenHead.action[2]
    	gst.send(BaiRenHead.Tcode,data)
    elseif tag == 3 then                --录单
        local layer =TrendLayer:create(self)
        layer:setName("TrendLayer")
        self:add(layer)
    elseif tag == 4 then                 --设置界面
        
        local layer =BrSettingLayer:create(self)
        self:add(layer)
    elseif tag == 5 then                --下庄按钮
        data={}
    	data.actionCode =BaiRenHead.action[3]
    	gst.send(BaiRenHead.Tcode,data)
    elseif tag == 6 then                --下庄按钮
        data={}
    	data.actionCode =BaiRenHead.action[4]
    	gst.send(BaiRenHead.Tcode,data)
    elseif tag == 7 then
        local layer =BrRuleLayer:create(self,1)
        self:add(layer)
    elseif tag == 8 then                --续投按钮
        local isxu=false
        for k,v in pairs(self.XutouChouma) do
            if v~= 0 then
                isxu=true
                break;
            end
        end
        if isxu== false then
            self.B_xutou:setEnabled(false)
            return
        end
        self.B_xutou:setEnabled(false)
        data={}
    	data.actionCode =BaiRenHead.action[1]
    	data.betDetail = self.XutouChouma
    	gst.send(BaiRenHead.Tcode,data)
    elseif tag == 9 then       
        local layer =BrPlayerListLayer:create(self)
        layer:setName("BrPlayerListLayer")
        self:add(layer)
    elseif tag > 50 and tag <=60  then  --玩家的操作。
        -- if  self.statusXia=false            --是否可以下注
        -- self.isZhuang=(data.isbanker == "1")             --是否是庄家
        if self.isZhuang then
            showToast("庄家无法下注",1)
            return
        end
        if self.statusXia ==false then
            --showToast("现在未到下注时间",1)
            return
        end
        if self:panduanXia(tag-50) then
        --判断是否可以下注
            self:pushBet(tag-50)
        end
    elseif tag > 80 and tag <=90  then  --玩家的操作。
        self:SelectChouma(tag-80)
    elseif tag == 99 then
        self.scene:OpenBagLayer()
    end    
end
function brcowLayer:panduanXia(tag)
    local XzhuScore=self.couma[self.SelChouma]*beilv[tag]
    if self.Myscore < XzhuScore then
        showToast("自己金币不足不能下注!",2)
        return
    end
    if self.KeTouScore < XzhuScore then
        showToast("可投金币不足不能下注!",2)
        return
    end
    return true
end
--下注
function brcowLayer:pushBet(index)
     local quyu={}
        for i=1,9 do
            quyu[i]=0
        end
        --设置金额下注
        quyu[index]=self.couma[self.SelChouma]
        --传值
        local data ={}
    	data.actionCode =BaiRenHead.action[1]
    	data.betDetail = quyu
    	gst.send(BaiRenHead.Tcode,data)
        for i=1,9 do
            self.QY[i]:setEnabled(false)
        end
        performWithDelay(self,function ()
                self:setXiaZhuQY() 
        end,0.2)
end
function brcowLayer:addToRootLayer(node, zorder)
	if nil == node then
		return
	end
	self.bj:addChild(node)
	node:setLocalZOrder(zorder or 0)
end


--设置牌背景
function brcowLayer:setCardBack(isVisib)
    for k,v in pairs(self.Card) do
        for a,b in pairs(v) do
            b:removeAllChildren()
            b:setVisible(isVisib)
        end
	end
end
function brcowLayer:setXiaZhuQY(ble)
    for i=1,9 do
        self.QY[i]:setEnabled(ble and ble or self.statusXia)
	end
end
function brcowLayer:KillGameClock()
    if self._ClockFun ~=nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._ClockFun)
        self._ClockFun =nil
    end
    self._ClockTime = 0
    self.gameim:setVisible(false)
end
function brcowLayer:SetGameClock(time,roomStatus)
    self:KillGameClock()
    local str=''
    if BaiRenHead.Gamestatus.kongxian == roomStatus then                   
            str="空闲时间"  
            self.xiazhuStatus=false
        elseif BaiRenHead.Gamestatus.kaishi == roomStatus then
            str="请下注"
            self.xiazhuStatus=true
        elseif BaiRenHead.Gamestatus.jiesuan == roomStatus then
            self.xiazhuStatus=false
            str="清算时间"
    end
    self._ClockTime = time
    self.gameim:setVisible(true)    
    self.gameim:getChildByName("T"):setString(str)
    self.gameim:getChildByName("Atlsa"):setString(self._ClockTime)
    --添加时间机制
    self._ClockFun = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
            if  self.OnClockUpdata then
                self:OnClockUpdata(roomStatus)
            end
            end,1,false)
end
function brcowLayer:OnClockUpdata(roomStatus)
    self._ClockTime=self._ClockTime-1
    if roomStatus ==BaiRenHead.Gamestatus.kaishi then
        if self._ClockTime ==0 then 
             self:PlayGameXiaZhuAction(2)
             self.statusXia=false            --是否可以下注
             self:setXiaZhuQY()              --下注区域
             self:settingcouma(false)        --下注筹码
             self.B_xutou:setEnabled(false)  --续投按钮
        elseif  roomStatus ==BaiRenHead.Gamestatus.kaishi and self._ClockTime ==1 then
             self.xiazhuStatus=false
             self:killotherTou()
        end
    end
    -- if self._ClockTime == 0 then
    --     if roomStatus ==BaiRenHead.Gamestatus.kaishi then
           
    --     end
    -- end 
    if self.gameim:isVisible() and self._ClockTime >=0 then
        self.gameim:getChildByName("Atlsa"):setString(self._ClockTime)
    elseif self.gameim:isVisible()  and self._ClockTime==-1 then
        self:KillGameClock()
    end 
end
function brcowLayer:sendCard()
       
    local delaytime = 0.05
    local paitime =0
    local donghuaindex=0
    self:setCardBack(true)
    for i=1,4 do
            donghuaindex=donghuaindex+1          
            for j = 1, 5 do
                local card = nil
                card=self.Card[i][j]
                local x,y=self.Cardpoint[i][j]
                card:stopAllActions()
                card.idx=j                                  --设置牌的个数
                local toScale = 0.38
                local Bezieract = ExternalFun.sendcardBezier(0.18,cc.p(display.width/2,display.height/2+200),self.Cardpoint[i][j],40)
                card:setPosition(display.width/2,display.height/2)
                card:runAction(cc.Sequence:create(cc.DelayTime:create(delaytime * j+(donghuaindex-1)*0.2),
                cc.CallFunc:create(function()
                end),
                Bezieract))
            end
            self:runAction(cc.Sequence:create(cc.DelayTime:create(paitime),
                    cc.CallFunc:create(
                    function()
                       -- ExternalFun.playSoundEffect("fapai",true)
                    end
                )))
            paitime=paitime+0.15     
    end
end

function brcowLayer:OnClockOtherTou()
    if  next(self.OtherTou) ~=nil and  self.xiazhuStatus == true  then
        local data =self.OtherTou[1]
        local ftime=0
        for k,v in pairs(data.roundBet) do
            if v ~= 0 then
                ftime=ftime+0.05
                local beginspos=self:getPlayerGetPos(data.userCode)
                local count = 0
                local left = 0
                local score=v
                for i = #self.couma, 1, - 1 do
                    local targetscore = self.couma[i]
                    if score >= targetscore then
                        count = math.floor(score / targetscore)
                        left = score % targetscore
                        score = left
                        if count > 10 then
                            count = 10
                        end
                        --performWithDelay(self,function ()
                            self:onSendPlaceJettonChip(k,beginspos,targetscore,count)
                    --end,ftime) 
                    end
                end               
            end
        end
        table.remove(self.OtherTou,1)
    end
end
function brcowLayer:OtherTouzhu()
   
        --添加时间机制
    self._OtherClockFun = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
        if  self.OnClockOtherTou then
            self:OnClockOtherTou()
        end
    end,0.05,false)
end
function brcowLayer:killotherTou()
    self.OtherTou={}
    if self._OtherClockFun ~=nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._OtherClockFun)
        self._OtherClockFun =nil
    end
end
--开牌
function brcowLayer:GetOpenAction(card,cards)
	local duration =0.1
	local orbitFront = cc.OrbitCamera:create(duration, 1, 0, -270, -90, 0, 0)
	local orbitBack = cc.OrbitCamera:create(duration, 1, 0, 0, -90, 0, 0)
	return cc.TargetedAction:create(card, cc.Sequence:create(
		cc.Sequence:create(cc.Show:create(), orbitBack, cc.Hide:create(), 
			cc.TargetedAction:create(card, cc.Sequence:create(cc.Show:create(), orbitFront))),
			cc.CallFunc:create(function()
                local str=string.format("card_%d_%d.png",(cards.suit+1),cards.rank)
                local puke = CCSpriteFrameCache:getInstance():getSpriteFrame(str)
				local shuzhi =  CCSprite:createWithSpriteFrame(puke)
				shuzhi:move(72,98.5)
				shuzhi:addTo(card)
			end)))
end
--开牌
function brcowLayer:showCard(index,cards,paixing)			 		--显示完整牌
	for k,v in pairs(cards) do
		local pai=self.Card[index][k]
		pai:setVisible(true)
            local str=string.format("card_%d_%d.png",(v.suit+1),v.rank)
            local puke = CCSpriteFrameCache:getInstance():getSpriteFrame(str)
            local shuzhi =  CCSprite:createWithSpriteFrame(puke)
		shuzhi:move(72,98.5)
		shuzhi:addTo(pai)
	end
    --显示牌型
    if paixing then
        self:showCardType(index,paixing)
    end
end
function brcowLayer:showCardType(index,cardtype)
    self.Paixing[index]:setVisible(true)
    -- if self.pcard[index][1]:isVisible() and self.Arm[index]:isVisible() == false then        --计算真实人数
    --     self.Arm[index]:setVisible(true)
    local Animat=self.Paixing[index]:getAnimation()
    local str=string.format("br/cow/%d",cardtype)
     ExternalFun.playSoundEffect(str,true)
    if cardtype >=10 then
        cardtype=10
    end
    local str=string.format("ani_nn_%d",cardtype)
    Animat:play(str)

    -- end
end
--设置庄和下庄按钮
function brcowLayer:setZhuangBtn(isbanker)
    
    if isbanker  then
        self.B_xiazhuang:setVisible(true)
        self.B_shangzhuang:setVisible(false)
    else
        self.B_shangzhuang:setVisible(true)
        self.B_xiazhuang:setVisible(false)
    end
    self.B_quxiao:setVisible(false)
end
--------------------------------------------------------------消息层-----------------------------------------------------

function brcowLayer:message(code,data)
    --dump(data,"百人三公界面消息："..code)
	if code == GameHead.ingame  then   						--进入房间消息
        self:reGame(true)                                   --重置界面
        self.Roomnumber:setString("桌号:"..data.tableId) 
        --更新富豪榜
        self:updateFuhaolist(data.fHList)
        --更新神算子
        self:updateSuanzilist(data.ssList)
        --更新庄家列表
        if #data.bankerInfoList >0 then
            self:updateZhuanglist(data.bankerInfoList)
        end
        --更新总人数
        self.B_Allp:getChildByName("T"):setString(data.allUSerCount.."人")
        --更新自己的分数
        self.Myscore=data.accountBalance

        self:updateMyScore(self.Myscore)
        
        --保存上庄分数
        self.shangzhuangscore=data.kzfs
        --所有阶段时间
        self.Times=data.roomStatusMapInfoBR
        --设置上下庄按钮
        self:setZhuangBtn(data.isbanker == "1")
        self.B_quxiao:setVisible(false)
        
        if BaiRenHead.Gamestatus.kongxian == data.roomStatus then                   
         --空闲时期   
        elseif BaiRenHead.Gamestatus.kaishi == data.roomStatus then
         --下注时期
            --显示牌(并设置牌的背景)
            self:setZhuangBtn(data.isbanker == "1")
            self.isZhuang=(data.isbanker == "1")             --是否是庄家
            self.KeTouScore=data.brJoinDetail.bankerAccountBalance
            self:UpdateTouAndsKe()
            for i=1,4 do
                for a=1,5 do
                    self.Card[i][a]:setVisible(true)
                end
            end
            for k,v in pairs(data.userAreasBetDetails) do
                if v ~= 0 then
                    self.Myscore=self.Myscore-v 
                    self.isXiazhu=true
                    self:updateMyScore(self.Myscore)
                    local beginspos=self:getPlayerGetPos(data.userCode)
                    local count = 0
                    local left = 0
                    local score=v
                    --显示下注
                    for i = #self.couma, 1, - 1 do
                        local targetscore = self.couma[i]
                        if score >= targetscore then
                            count = math.floor(score / targetscore)
                            left = score % targetscore
                            score = left
                            if count > 10 then
                                count = 10
                            end
                             self:onSendPlaceJettonChip(k,beginspos,targetscore,count)
                        end
                    end
                end
            end
            if data.remainSeconds >=3 then
                self.statusXia=true 
                self:setXiaZhuQY()
                self:OtherTouzhu()
                --设置筹码亮
                self:settingcouma(data.isbanker ~= "1")
            end
            
        elseif BaiRenHead.Gamestatus.jiesuan == data.roomStatus then
         --结算时期
            --牌及牌型显示
            if data.remainSeconds < 6 then
                for i=1,4 do
                    self:showCard(i,data.brJoinDetail.areaCards[i],data.brJoinDetail.areaPxList[i]) 
                end
            else
                for i=1,4 do
                    for a=1,5 do
                        self.Card[i][a]:setVisible(true)
                    end
                end
                performWithDelay(self,function ()
                    for i=1,4 do
                        self:showCard(i,data.brJoinDetail.areaCards[i],data.brJoinDetail.areaPxList[i]) 
                    end
                end,2) 
            end
            
            self.isZhuang=(data.isbanker == "1")             --是否是庄家
        end
        --除了没庄情况开启时间倒计时
        if #data.bankerInfoList~=0 then
            self:SetGameClock(data.remainSeconds,data.roomStatus)
        end
        
    elseif code == BaiRenHead.UpdateUserlist then
        --更新富豪榜
        self:updateFuhaolist(data.fhuser)
        --更新神算子
        self:updateSuanzilist(data.ssuser)
    elseif code == BaiRenHead.UpdateZhuanglist then
        self:updateZhuanglist(data.bankeruser)
    elseif code == BaiRenHead.Zhuang then
        if data.actionCode=="2" or data.actionCode == "3" then         --上庄成功
            self.B_quxiao:setVisible(true)
            self.B_xiazhuang:setVisible(false)
            self.B_shangzhuang:setVisible(false)
        elseif data.actionCode == "4" then
            self.B_quxiao:setVisible(false)
        end
    elseif code == BaiRenHead.Wxiazhu then
        if self._OtherClockFun then
        self:QuyuScoreUpdate(data.userCode == public.userCode,data.roundBet)
        self.YiTouScore=data.userHasBetAll
        self.KeTouScore=data.bankerCanBetAll
        self:UpdateTouAndsKe()
    --判断是否是自己下注

            if data.userCode == public.userCode then
                for k,v in pairs(data.roundBet) do
                    self.Myscore=self.Myscore-v 
                end
                self.isXiazhu=true
                self:updateMyScore(self.Myscore)
                
                for k,v in pairs(data.roundBet) do
                    if v ~= 0 then
                        local beginspos=self:getPlayerGetPos(data.userCode)
                        local count = 0
                        local left = 0
                        local score=v
                        for i = #self.couma, 1, - 1 do
                            local targetscore = self.couma[i]
                            if score >= targetscore then
                                count = math.floor(score / targetscore)
                                left = score % targetscore
                                score = left
                                if count > 10 then
                                    count = 10
                                end
                                 self:onSendPlaceJettonChip(k,beginspos,targetscore,count)
                            end
                        end               
                    end
                end
            else
                table.insert(self.OtherTou,data)
            end
        end
     --游戏空闲
    elseif code ==BaiRenHead.GameKong then
        self:reGame()  
        -- self.statusXia=false            --是否可以下注
        -- self.isZhuang=(data.isbanker == "1")             --是否是庄家
        ---设置上下庄按钮
        self:setZhuangBtn(data.isbanker == "1")
        -- 更新自己的金币//应该是动画完成再更新
        self.Myscore= tonumber(data.accountBalance)
        self:updateMyScore(self.Myscore)
   
        -- self:settingcouma(false)
        -- self:KillGameClock()
        -- self:SetGameClock(self.Times[1],BaiRenHead.Gamestatus.kongxian)
    --游戏开始
    elseif code ==BaiRenHead.Gamestart then
        self:reGame(false)                      --重置界面
         --金币列表
        self.m_coumaList = {{}, {}, {}, {}, {}, {}, {}, {}, {}}
        --更新区域总住等筹码 
        self.zongzhulist={0,0,0,0,0,0,0,0,0}              --总住
        self.XutouChouma=self.Metouzhulist
        self.Metouzhulist={0,0,0,0,0,0,0,0,0}             --续投
        
        self.KeTouScore=data.bankerAccountBance
        self.YiTouScore=0
        self:PlayGameXiaZhuAction(1)
        self:UpdateTouAndsKe()
        --发牌
        self:sendCard()
        --设置上下庄按钮
        self.statusXia=true                             --是否可以下注
        self.isZhuang=(data.isbanker == "1")             --是否是庄家
        if self.isZhuang then
            self.statusXia=false
        end
        self:setXiaZhuQY()
        
        --判断续投是否开启
        for k,v in pairs(self.XutouChouma) do
            if v~=0 and self.isZhuang ~= true then
                self.B_xutou:setEnabled(true)
            end
        end
        self:setZhuangBtn(data.isbanker == "1")
        --设置筹码亮
        self:settingcouma(data.isbanker ~= "1")
        
        self:KillGameClock()
        self:SetGameClock(self.Times[2],BaiRenHead.Gamestatus.kaishi)
        --启动投注计时器
        self:OtherTouzhu()
    --游戏结束
    elseif code ==BaiRenHead.GameOver then
        --self:killotherTou()
        self.statusXia=false            --是否可以下注
        self.isXiazhu=false
        self.isZhuang=(data.isbanker == "1")             --是否是庄家
        self:settingcouma(false)
        self.B_xutou:setEnabled(false)
        --开牌
        local delaytime=0
        for i = 1, 4 do
            performWithDelay(self,function ()
                self:showCard(i,data.areasCardsInfo[i].cards,data.areasCardsInfo[i].px)   
            end,delaytime)
            delaytime=delaytime+0.8
        end
        --设置上下庄按钮
        -- self:setZhuangBtn(data.isbanker == "1")
        --庄家回收金币
        performWithDelay(self,function ()
             self:showcoumaMove()   
        end,2.6)
        
        --通赢或者同输动画
        local xstype=3
        if data.areasCardsInfo[1].winFlag and data.areasCardsInfo[1].winFlag ==data.areasCardsInfo[2].winFlag 
            and data.areasCardsInfo[2].winFlag ==data.areasCardsInfo[3].winFlag then
            if data.areasCardsInfo[1].winFlag == -1 then
                xstype=3
            else
                xstype=4
            end
            performWithDelay(self,function ()
                self:PlayGameTAction(xstype)  
            end,3)
        end
        --金币飞的动画
        --self:showGoldToAreaWithMe(data.winOrLoss,data.bankerWinOrLoss)
        
         performWithDelay(self,function ()  
                if  data.bankerWinOrLoss ~= 0 then
                    self:showEnd(self.p_t,data.bankerWinOrLoss,nil,true)
                end
                if  data.winOrLoss ~= 0 then
                    self:showEnd(self.ziji:getChildByName("T2"),data.winOrLoss,data.winOrLoss>0 and 1 or 0)
                end
                self:updateZhuanglist(data.bankerInfoList)
                self:updateFuhaolist(data.fHList)
                self:updateSuanzilist(data.ssList)
                for k,v in pairs(data.fHList) do
                    if k <4 then
                         local bb=string.format("p1_%d",k)
                        local Pnode=self.player:getChildByName(bb)
                        if v.loseOrWinCoin ~= 0 then
                            self:showEnd(Pnode,v.loseOrWinCoin)
                        end
                    end
                end
                for k,v in pairs(data.ssList) do
       
                    if k <4 then
                        local bb=string.format("p2_%d",k)
                        local Pnode=self.player:getChildByName(bb)
                        if v.loseOrWinCoin ~= 0 then
                            self:showEnd(Pnode,v.loseOrWinCoin,nil,nil,true)
                        end
                    end
                end
                --更新自己的金币//应该是动画完成再更新
                self.Myscore= tonumber(data.accountBalance)
                self:updateMyScore(self.Myscore)
         end,3.5)
         

                                      --测试用动画
        self:KillGameClock()
        self:SetGameClock(self.Times[3],BaiRenHead.Gamestatus.jiesuan)
    elseif   code ==BaiRenHead.OnLineUserlist then
        local newLayer=self:getChildByName("BrPlayerListLayer")
        if newLayer then
            newLayer:inint(data.allUser)
        end
    elseif code == BaiRenHead.Trend then
        local newLayer=self:getChildByName("TrendLayer")
        if newLayer then
            newLayer:inint(data)
        end
	end
end
-------------------------------------------------------------消息相应层

function brcowLayer:UpdateTouAndsKe()
    self.YiTou:setString("已投注:"..ExternalFun.numberTrans(self.YiTouScore))
    self.KeTou:setString("可投注:"..ExternalFun.numberTrans(self.KeTouScore))
end
function brcowLayer:showGoldToAreaWithMe(winOrLoss,bankerWinOrLoss)
    local detime=3
    local x,y =self.p_t:getPosition()
    local bankerheadpoint=cc.p(x,y)
    x,y = self.B_Allp:getPosition()
    local otherpoint=cc.p(x,y)
    x,y = self.ziji:getPosition()
    local mepoint=cc.p(x,y)
    if winOrLoss >0 then
        ExternalFun.playSoundEffect("brjb",true)
        if bankerWinOrLoss>0 then
            --庄赢 输我
            performWithDelay(self,function ()
                 --其他玩家金币飞到庄上
                self:showGoldToAreaWithID(otherpoint,bankerheadpoint)   
                performWithDelay(self,function ()
                 --其他玩家金币飞到庄上
                self:showGoldToAreaWithID(bankerheadpoint,mepoint)   
                end,0.4)
            end,detime)
            
        elseif bankerWinOrLoss< 0 then
            --庄输的少 玩家也输了
            if (-bankerWinOrLoss ) < winOrLoss then
                performWithDelay(self,function ()
                     --其他玩家金币飞到庄上
                    self:showGoldToAreaWithID(otherpoint,bankerheadpoint)   
                    performWithDelay(self,function ()
                     --其他玩家金币飞到庄上
                    self:showGoldToAreaWithID(bankerheadpoint,mepoint)   
                    end,0.4)
                end,detime)
            else
                --对于两个玩家庄都输了
                performWithDelay(self,function ()
                     --其他玩家金币飞到庄上
                    self:showGoldToAreaWithID(bankerheadpoint,otherpoint)   
                     --其他玩家金币飞到庄上
                    self:showGoldToAreaWithID(bankerheadpoint,mepoint)   
                end,detime)
            end
            
        end
    elseif winOrLoss<0 then
        if bankerWinOrLoss > 0 then
            --所有人都输了
            if bankerWinOrLoss > (-winOrLoss) then
                 --对于两个玩家庄都输了
                performWithDelay(self,function ()
                     --其他玩家金币飞到庄上
                    self:showGoldToAreaWithID(otherpoint,bankerheadpoint)   
                     --其他玩家金币飞到庄上
                    self:showGoldToAreaWithID(mepoint,bankerheadpoint)   
                end,detime)
            else
                performWithDelay(self,function ()
                     --其他玩家金币飞到庄上
                    self:showGoldToAreaWithID(mepoint,bankerheadpoint)   
                    performWithDelay(self,function ()
                     --其他玩家金币飞到庄上
                    self:showGoldToAreaWithID(bankerheadpoint,otherpoint)   
                    end,0.4)
                end,detime)
                
            end
        elseif bankerWinOrLoss < 0 then
            --自己输给庄.庄输给其他人
            performWithDelay(self,function ()
                     --其他玩家金币飞到庄上
                    self:showGoldToAreaWithID(mepoint,bankerheadpoint)   
                    performWithDelay(self,function ()
                     --其他玩家金币飞到庄上
                    self:showGoldToAreaWithID(bankerheadpoint,otherpoint)   
                    end,0.4)
            end,detime)
        end
    end
    -- do somethings
end
--飞金币动画
function brcowLayer:showGoldToAreaWithID(beganviewid,endviewid)
	local pos = endviewid
	local bpos = beganviewid
	for j = 1, 10 do
        local str ="coin_icon.png"
        local puke = CCSpriteFrameCache:getInstance():getSpriteFrame(str)
        local pgold =  CCSprite:createWithSpriteFrame(puke)
		self.coumaLayer:addChild(pgold)
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

function brcowLayer:showcoumaMove()
    local x,y =self.p_t:getPosition()
    local bankerheadpoint=cc.p(x,y)
    for k,v in pairs(self.m_coumaList) do
        if v~= 0 then
            local goldnum = #self.m_coumaList[k]
            --分十次飞行完成
            local cellnum = math.floor(goldnum / 10)
            if cellnum == 0 then
                cellnum = 1
            end
            local cellindex = 0
            local outnum = 0
            for i = goldnum, 1, - 1 do
                local pgold = self.m_coumaList[k] [i]
                table.remove(self.m_coumaList[k], i)
                outnum = outnum + 1
                local moveaction = ExternalFun.getMoveAction(cc.p(pgold:getPosition()), bankerheadpoint)
                pgold:runAction(cc.Sequence:create(cc.DelayTime:create(cellindex * 0.03), moveaction, cc.CallFunc:create(
                function()
                    pgold:removeSelf()
                end
                )))
            end
        end
    end
end
--判断位置
function brcowLayer:getPlayerGetPos(userCode)
    local x,y=0
    --自己的位置 
    if userCode == public.userCode then
        x,y=self.ziji:getPosition()
        return cc.p(x,y)
    else
        --富豪榜
        for i=1,4 do
            if self.fuhaolist[i] and self.fuhaolist[i].userCode == userCode then
                local Pp=string.format("p%d",i)
                x,y=self.p_l:getPosition()
                y=y+(4-i)*109+40
                return cc.p(x,y)
            end
        end
        --神算子榜
        for i=1,4 do
            if self.suanzilist[i] and self.suanzilist[i].userCode == userCode then
                local Pp=string.format("p%d",i)
                x,y=self.p_r:getPosition()
                y=y+(4-i)*109+40
                return cc.p(x,y)
            end
        end
        --其他玩家
        x,y=self.B_Allp:getPosition()
    end
    -- do somethings
    return cc.p(x,y)
end
function brcowLayer:showEnd(node,changescore,ying,isZhuang,isYou)
    changescore=ExternalFun.GetPreciseDecimal(changescore)
	local fontstr =nil
	if changescore >= 0 then
		fontstr = "Game/brpublic/num1.png"
	elseif changescore < 0 then
		fontstr = "Game/brpublic/num2.png"
	end
	local str="/"..math.abs(changescore)
	self.num=cc.LabelAtlas:create(str,fontstr,26, 32, string.byte("."))
	self.num:setAnchorPoint(0, 0.5)
    if isYou then
        self.num:setAnchorPoint(1, 0.5)
    end
    local x,y=node:getPosition()
    self.num:setPosition(cc.p(x,y))
    
	self.coumaLayer:add(self.num)
	local call = cc.CallFunc:create(function()
	end)
    local yx=35
    if isZhuang then
        yx=25
    end
	local moveBy = cc.MoveBy:create(0.4, cc.p(0, yx))
	local standby = cc.DelayTime:create(3)
	local fadeout = cc.FadeOut:create(0.5)

	local m_actShowScore = cc.Sequence:create(moveBy,standby,fadeout,call)
	self.num:runAction(m_actShowScore)
	    
     if ying then
            if ying ==1 then
                ExternalFun.playSoundEffect("win",true)
            else
                 ExternalFun.playSoundEffect("lose",true)
            end
     end

end
function brcowLayer:onSendPlaceJettonChip(tag,beginpos,betIdx,goldnum,ftime)
    local fun = function( ... )
		--if isme then
            ExternalFun.playSoundEffect("chouma",true)
    --end
	end
    for i = 1, goldnum do
        local img = string.format("bb%d.png",betIdx)
        local tableinfo=public.gettableinfo(public.roomCode)
        if tableinfo.cmbl == 1 then
            img =string.format("m%d.png",betIdx)
        end
		local puke = CCSpriteFrameCache:getInstance():getSpriteFrame(img)
		local pgold =  CCSprite:createWithSpriteFrame(puke)
		pgold.betIdx = betIdx
		pgold:setPosition(beginpos)
        pgold:setScale(0.6)
		self.coumaLayer:addChild(pgold)
		self.coumaLayer:setVisible(true)

		if i == 1 then
			local moveaction = ExternalFun.getMoveAction(beginpos, self:getRandPos(self.QY[tag]), fun, ftime, true)
			pgold:runAction(moveaction)
		else
			local offsettime = self.m_fJettonTime--math.min(self.m_fJettonTime, 2)
			local randnum = math.random() * offsettime
			pgold:setVisible(false)
			pgold:runAction(cc.Sequence:create(cc.DelayTime:create(randnum), cc.CallFunc:create(
			function()
				local moveaction = ExternalFun.getMoveAction(beginpos, self:getRandPos(self.QY[tag]), fun, ftime, true)
				pgold:setVisible(true)
				pgold:runAction(moveaction)
			end
			)))
		end
		
		table.insert(self.m_coumaList[tag], pgold)
	end
end
--获取随机显示位置
function brcowLayer:getRandPos(nodeArea)
	local beginpos = cc.p(nodeArea:getPositionX() - 140, nodeArea:getPositionY() - 35)
	local offsetx = math.random()
	local offsety = math.random()
	return cc.p(beginpos.x + offsetx * 280, beginpos.y + offsety * 45)
end

--获取移动动画
--inorout,0表示加速飞出,1表示加速飞入
--isreverse,0表示不反转,1表示反转
-- function brcowLayer:getMoveAction(beginpos, endpos, callback, rtime, bScale, inorout, isreverse)
	
-- 	inorout = inorout or 0
-- 	isreverse = isreverse or 0
-- 	rtime = rtime or 0
-- 	local dis =(endpos.x - beginpos.x) *(endpos.x - beginpos.x) +(endpos.y - beginpos.y) *(endpos.y - beginpos.y)
-- 	dis = math.sqrt(dis)
-- 	local ts = dis / 1500
-- 	if ts < 0.1 then
-- 		ts = 0.1
-- 	elseif ts > 0.3 then
-- 		ts = 0.3
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
-- 		local scaleact1 = cc.ScaleTo:create(0.1, 0.5)
-- 		local scaleact2 = cc.ScaleTo:create(0.1, 0.3)
-- 		local scaleact3 = cc.ScaleTo:create(0.1, 0.4)
-- 		table.insert(actions, scaleact1)
-- 		table.insert(actions, scaleact2)
-- 		table.insert(actions, scaleact3)
-- 	end
	
-- 	return cc.Sequence:create(actions)
	
-- end

--通杀OR通配
function brcowLayer:PlayGameTAction(atype)
    local str="animation"
    if atype ==4 then 
        str="animation2"
    end
    local SoundEffect={"br/tchi","br/tpei"}
    ExternalFun.playSoundEffect( SoundEffect[atype],true)
    local spine=ExternalFun.addSpineWithCustomNode("Game/brAction/newaction/tongsha_pei",self.action,str,cc.p(640,420),true) 
    spine:registerSpineEventHandler(function (event)
        performWithDelay(self,function ()
            spine:removeFromParent()
            end,0.2)
    end, sp.EventType.ANIMATION_COMPLETE)
end
--通杀OR通配
function brcowLayer:PlayGameXiaZhuAction(atype)
    local str="animation"
    if atype ==2 then 
        str="animation2"
    end
    local SoundEffect={"br/begin","br/shop"}
    ExternalFun.playSoundEffect( SoundEffect[atype],true)
        
    local spine=ExternalFun.addSpineWithCustomNode("Game/brAction/newaction/kaishitingzhi",self.action,str,cc.p(640,420),true) 
    spine:registerSpineEventHandler(function (event)
        performWithDelay(self,function ()
            spine:removeFromParent()
            end,0.2)
    end, sp.EventType.ANIMATION_COMPLETE)
end
function brcowLayer:QuyuScoreUpdate(isMe,RoundBet)
    for k,v in pairs(RoundBet) do
        if v ~= 0 then
            self.zongzhulist[k]=self.zongzhulist[k]+v
            self:UpdateQuYuScore()
            if isMe then
                self.XutouChouma={0,0,0,0,0,0,0,0,0}             --续投筹码
                self.B_xutou:setEnabled(false)
                self.Metouzhulist[k]=self.Metouzhulist[k]+v
                self:UpdateQuYuMeScore()
            end
        end
	end
end
function brcowLayer:UpdateQuYuScore()
    for k,v in pairs(self.zongzhulist) do
        if v ~= 0 then
            local bb=self.QY[k]
            bb:getChildByName("T1"):setString("总注:"..v)
            bb:getChildByName("T1"):setVisible(true)
        end
	end
end
function brcowLayer:UpdateQuYuMeScore()
    for k,v in pairs(self.Metouzhulist) do
        if v ~= 0 then
            local bb=self.QY[k]
            bb:getChildByName("T2"):setString("自己:"..v)
            bb:getChildByName("T2"):setVisible(true)
        end
	end
end
--更新庄家列表
function brcowLayer:updateZhuanglist(data)
    self.p_t:removeAllChildren()
   -- local isbanker=false
    for k,v  in pairs(data) do
		local item=self.zhuangNode:clone()
        --设置头像
        ExternalFun.createClipHead(item,v.userCode,v.logoUrl,70)
        local str =v.precent.."%"
        if v.precent == 0 then
            str ="等待上庄"
        end
        item:getChildByName("t"):setString(str)
        self.p_t:pushBackCustomItem(item)
        
        -- if v.userCode ==public.userCode then
        --    isbanker=true 
        -- end
        --更新按钮
       -- self:setZhuangBtn(isbanker)
    end
    --print("更新上庄数据")
end
--更新富豪榜
function brcowLayer:updateFuhaolist(data)
    local index =#data
    for i=1,6 do
        local bb=string.format("p%d",i)
        local Pnode=self.p_l:getChildByName(bb)
        if i>index then
            Pnode:setVisible(false)
        else
            if data[i] ~= self.fuhaolist[i] then
                local headbg=Pnode:getChildByName("h")
                --设置头像
                ExternalFun.createClipHead(headbg,data[i].userCode,data[i].logoUrl,70)
                Pnode:getChildByName("T"):setString(ExternalFun.numberTrans(data[i].gameCoin))
                Pnode:getChildByName("T"):setVisible(true)
            end
            Pnode:setVisible(true)
        end
    end
    self.fuhaolist = data
end
--更新神算子
function brcowLayer:updateSuanzilist(data)
    local index =#data
    for i=1,6 do
        local bb=string.format("p%d",i)
        local Pnode=self.p_r:getChildByName(bb)
        if i>index then
            Pnode:setVisible(false)
        else
            if data[i] ~= self.suanzilist[i] then
                local headbg=Pnode:getChildByName("h")
                --设置头像
                ExternalFun.createClipHead(headbg,data[i].userCode,data[i].logoUrl,70)
                Pnode:getChildByName("T"):setString(ExternalFun.numberTrans(data[i].gameCoin))
                Pnode:getChildByName("T"):setVisible(true)
            end
            Pnode:setVisible(true)
        end
    end
    self.suanzilist = data
end
--更新自己的金币
function brcowLayer:updateMyScore(score)
    if score then
        self.ziji:getChildByName("T2"):setString(ExternalFun.numberTrans(score))
    else
        self.ziji:getChildByName("T1"):setString(public.userCode)
        local head=self.ziji:getChildByName("head")
        ExternalFun.createClipHead(head,public.userCode,public.logoUrl,70) 
    end
end
return brcowLayer

