local brdssLayer = class("brdssLayer", function ()
	local brdssLayer =  display.newLayer()
	return brdssLayer
end)
local BrSettingLayer=appdf.req(appdf.GAME_SRC.."brpublic.BrSettingLayer")
local BrPlayerListLayer=appdf.req(appdf.GAME_SRC.."brpublic.BrNPlayerListLayer")

local TrendLayer=appdf.req(appdf.GAME_SRC.."brdss.BrssTrendLayer")
local BrRuleLayer=appdf.req(appdf.GAME_SRC.."brpublic.BrRuleLayer")
local BrdzjListLayer=appdf.req(appdf.GAME_SRC.."brpublic.BrdzjListLayer")
local BrmzjListLayer=appdf.req(appdf.GAME_SRC.."brpublic.BrmzjListLayer")
local beilv={13,13,13,13}
function brdssLayer:ctor(_scene)

	self:playerinint()

	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Game/brLayer/brdssLayer.csb", self)
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
				
                if ref:getTag() <=50 or ref:getTag()>= 60 then 
                    ExternalFun.playClickEffect()
                    ref:setScale(1)
                end
                self:onButtonClickedEvent(ref:getTag(),ref)
            elseif type == ccui.TouchEventType.began then
                if ref:getTag() <=50 or ref:getTag()>= 60 then 
                    ref:setScale(public.btscale)
                end
                return true
            elseif type == ccui.TouchEventType.canceled then
                if ref:getTag() <=50 or ref:getTag()>= 60 then 
                    ref:setScale(1)
                end
		end
	end
    
    --上面按钮
    for i=1,4 do
		local bb=string.format("b%d",i)
		local BAN=self.top:getChildByName(bb)
		BAN:setTag(i)
	    BAN:addTouchEventListener(btcallback)
	end
        --记录两个消息
    local tableinfo=public.gettableinfo(public.roomCode)
    ExternalFun.dump(tableinfo,"tableinfo")
    self.brMs=tableinfo.brMs
    self.kzfs=tableinfo.kzfs
    local zhuannode=nil 
    if self.brMs ==  1  then   --独庄模式
        zhuangNode = self.top:getChildByName("Dz")
        self.top:getChildByName("Dz"):setVisible(true)
        self.top:getChildByName("Ddz"):setVisible(false)
        self.top:getChildByName("Dz"):getChildByName("T3"):setString("上庄需要:"..tableinfo.kzfs.."分")
    elseif self.brMs == 2 then --多人上庄模式
        zhuangNode = self.top:getChildByName("Ddz")
        self.top:getChildByName("Dz"):setVisible(false)
        self.top:getChildByName("Ddz"):setVisible(true)
    end
    --显示上庄等按钮
    if zhuangNode then
        self.B_z=zhuangNode:getChildByName("b_z")
        self.B_z:setVisible(false)
        self.B_z:setTag(5)
	    :addTouchEventListener(btcallback)
        self.zhuangNode=zhuangNode
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
    for i=1,4 do
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
    for i=1,5 do
		self.Card[i]=self.pai:getChildByName(string.format("p%d",i))
        self.Cardpoint[i]={x=self.Card[i]:getPositionX(),y=self.Card[i]:getPositionY()}
	end
    
    self.Paixing={}
    --牌型
    for i=1,5 do
		local paixing=string.format("px%d",i)
		self.Paixing[i]=self.pai:getChildByName(paixing)
	end
    --富豪榜
    self.p_l=self.player:getChildByName("p_l")
    --神算子
    self.p_r=self.player:getChildByName("p_r")
    --庄的列表
    self.p_t=self.player:getChildByName("p_t")
    --隐藏赢的动画
    self.action:setVisible(true)
    --动画
    self.GameActionB=self.action:getChildByName("B")
    self.Trendnodelist={}
    self.Trendlist =self.top:getChildByName("Trendlist")
    self.Trendp =self.top:getChildByName("Trendp")
    --自己信息
    self.ziji=self.player:getChildByName("zj")
    self:updateMyScore()                --更新自己的分数
	self:changebj()                     --更换背景
    self:changcmbl()                    --更换筹码比例
	self:reGame(true)                   --重置桌面信息

end
function brdssLayer:changcmbl()
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
function brdssLayer:changebj()
	local bjindex = cc.UserDefault:getInstance():getIntegerForKey("BRDSSBJ", 1)
	local str = string.format("Game/brdss/bj%d.png",bjindex)
	self.bj:setBackGroundImage(str)
end
function brdssLayer:reGame(bol) 				   -----------重置界面
    self:stopAllActions()
    self.KeTou:setString("0")
    self.YiTou:setString("0")
    self.B_xutou:setEnabled(false)
    self.coumaLayer:removeAllChildren()
    self:settingcouma(false)
    --牌及牌型隐藏
    for k ,v in pairs(self.Card) do
        v:setVisible(false)
    end

    for k ,v in pairs(self.Paixing) do
        v:setVisible(false)
    end
    self.GameActionB:setVisible(false)
    --清理牌资源
    self:setCardBack(false)
    
    --清理区域下注情况
    for k,v in pairs(self.QY)  do
        local bb=v
        bb:getChildByName("T1"):setString("0")
        bb:getChildByName("T1"):setVisible(false)
        bb:getChildByName("T2"):setString("0")
        bb:getChildByName("T2"):setVisible(false)
        bb:getChildByName("g"):setVisible(false)
        bb:getChildByName("g"):stopAllActions()
	end
    
    if bol then
        --富豪榜and神算子
        for i=1,6 do
            local bb=string.format("p%d",i)
            self.p_l:getChildByName(bb):setVisible(false)
            self.p_r:getChildByName(bb):setVisible(false)
        end
         --庄家榜
        -- self.p_t:removeAllChildren()
        --下庄按钮
        --self.B_xiazhuang:setVisible(false)
        self.B_Allp:getChildByName("T"):setString("0人")
        --选中筹码
        self:SelectChouma(1)
        --重置游戏记录
        self.Trendlist:removeAllChildren()
        self.Trendnodelist={}
    end
    self.statusXia=false            --是否可以下注
    self.isZhuang=false             --是否是庄家
    self.isQuxiao=false  ---2是取消申请状态 --状态(1是玩家,2是庄,3是等待上庄)
    self.isXiazhu=false             --是否是下注玩家
    self:setXiaZhuQY()
    --时间
    self.gameim:setVisible(false)
     self.xiazhuStatus=false
    self:KillGameClock()                    --关闭游戏提示
    self.m_fJettonTime =2
    self.OtherTou={}
    self.blinkPos = {}
    --self:killotherTou()    
end
function brdssLayer:playerinint()
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
    self.isQuxiao=false             --是不是取消状态
    self.zongzhulist={0,0,0,0}             --总住列表
    self.Metouzhulist={0,0,0,0}             --总住列表
    self.XutouChouma={0,0,0,0}             --续投筹码
    self.isXiazhu=false
    self.KeTouScore=0
    self.YiTouScore=0
    self.OtherTou={}
    self.brMs = 1
    self.szfs = 0
    	--金币列表
	self.m_coumaList = {{}, {}, {}, {}}
end
function brdssLayer:SelectChouma(index)
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
function brdssLayer:settingcouma(ble)
        --筹码不可用状态
    for k,v in pairs(self.CM) do
        self.CM[k]:setEnabled(ble)
    end
end
function brdssLayer:onButtonClickedEvent(tag,ref)
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
   
    elseif tag == 2 then                --录单
        local layer =TrendLayer:create(self)
        layer:setName("TrendLayer")
        self:add(layer)
    elseif tag == 3 then                 --设置界面
        
        local layer =BrSettingLayer:create(self)
        self:add(layer)
    elseif tag == 4 then
        local layer =BrRuleLayer:create(self,4)
        self:add(layer)
    elseif tag == 5 then                --上庄按钮
        if  self.brMs ==  1 then        --独庄模式
            local layer =BrdzjListLayer:create(self)
            layer:setZhuangBtn(self.isZhuang,self.isQuxiao ==true and true or nil)
            layer:setName("zhuangListLayer")
            self:add(layer)
        else
            local layer =BrmzjListLayer:create(self)
            layer:setZhuangBtn(self.isZhuang,self.isQuxiao ==true and true or nil)
            layer:setName("zhuangListLayer")
            self:add(layer)
        end
        local data ={}
    	gst.send(BaiRenHead.UpdateZhuanglist)
    elseif tag == 6 then                --下庄按钮
        data={}
    	data.actionCode =BaiRenHead.action[3]
    	gst.send(BaiRenHead.Tcode,data)
    elseif tag == 7 then                --下庄按钮
        data={}
    	data.actionCode =BaiRenHead.action[4]
    	gst.send(BaiRenHead.Tcode,data)
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
function brdssLayer:panduanXia(tag)
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
function brdssLayer:pushBet(index)
     local quyu={}
        for i=1,4 do
            quyu[i]=0
        end
        --设置金额下注
        quyu[index]=self.couma[self.SelChouma]
        --传值
        local data ={}
    	data.actionCode =BaiRenHead.action[1]
    	data.betDetail = quyu
    	gst.send(BaiRenHead.Tcode,data)
        for i=1,4 do
            self.QY[i]:setEnabled(false)
        end
        performWithDelay(self,function ()
                self:setXiaZhuQY() 
        end,0.2)
end
function brdssLayer:addToRootLayer(node, zorder)
	if nil == node then
		return
	end
	self.bj:addChild(node)
	node:setLocalZOrder(zorder or 0)
end


--设置牌背景
function brdssLayer:setCardBack(isVisib)
    for k,v in pairs(self.Card) do
        v:removeAllChildren()
        v:setVisible(isVisib)
	end
end
function brdssLayer:setXiaZhuQY(ble)
    for k,v in pairs(self.QY) do
        v:setEnabled(ble and ble or self.statusXia)
	end
end
function brdssLayer:KillGameClock()
    if self._ClockFun ~=nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._ClockFun)
        self._ClockFun =nil
    end
    self._ClockTime = 0
    self.gameim:setVisible(false)
end
function brdssLayer:SetGameClock(time,roomStatus)
    self:KillGameClock()
    local str=''
    if BaiRenHead.Gamestatus.kongxian == roomStatus then                   
        str="空闲时间"  
        self.xiazhuStatus=false
        elseif BaiRenHead.Gamestatus.kaishi == roomStatus then
        str="请下注"
            self.xiazhuStatus=true
        elseif BaiRenHead.Gamestatus.jiesuan == roomStatus then
        str="清算时间"
             self.xiazhuStatus=false
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
function brdssLayer:OnClockUpdata(roomStatus)
    self._ClockTime=self._ClockTime-1
    if roomStatus ==BaiRenHead.Gamestatus.kaishi then
        if self._ClockTime ==0 then 
             self:PlayGameAction(2)
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
function brdssLayer:sendCard()
       
    local delaytime = 0.05
    local paitime =0
    local donghuaindex=0
    self:setCardBack(true)
    for i=1,5 do
            donghuaindex=donghuaindex+1          
--for j = 1, 1 do
                local card = nil
                card=self.Card[i]
                local x,y=self.Cardpoint[i]
                card:stopAllActions()
                card.idx=1                                  --设置牌的个数
                local toScale = 0.38
                local Bezieract = ExternalFun.sendcardBezier(0.18,cc.p(display.width/2,display.height/2+200),self.Cardpoint[i],40)
                card:setPosition(display.width/2,display.height/2)
                card:runAction(cc.Sequence:create(cc.DelayTime:create(delaytime * 1+(donghuaindex-1)*0.1),
                cc.CallFunc:create(function()
                end),
                Bezieract))
  --          end
            self:runAction(cc.Sequence:create(cc.DelayTime:create(paitime),
                    cc.CallFunc:create(
                    function()
                        ExternalFun.playSoundEffect("fapai",true)
                    end
                )))
            paitime=paitime+0.10     
    end
end
-- function brdssLayer:OnClockOtherTou()
--     if  next(self.OtherTou) ~=nil and  self.xiazhuStatus == true then
--         local xiazhu={}
--         local xiazhuci=0
--         for i=1,#self.OtherTou[1].roundBet do
--             xiazhu[i]=0
--         end
--         --计算下注区域个数
--         for k,v in pairs(self.OtherTou[1].roundBet) do
--             if v ~=0 then
--                 xiazhuci=xiazhuci+1
--             end
--         end
--         local isxiazhu=true
--         --如果三门同时下注
--         if xiazhuci >1 then
--             isxiazhu=false
--             local yuqugeshu=math.random(xiazhuci)
--             --随机次数
--             local linci=0
--             for k ,v in pairs(self.OtherTou[1].roundBet) do
--                 if linci < yuqugeshu then
--                     if math.random(3) ==1 and v~=0 then --判断下注
--                         xiazhu[k]=v
--                         self.OtherTou[1].roundBet[k]=0
--                         linci=linci+1
--                         break
--                     end
--                 end
--             end
--             --如果区域都是0的情况则补充区域下注情况
--             if linci==0 then
--                 for k,v in pairs(self.OtherTou[1].roundBet) do
--                     if v ~=0  then
--                         xiazhu[k]=v
--                         self.OtherTou[1].roundBet[k]=0
--                         break
--                     end
--                 end   
--             end
--         end
--         if isxiazhu == true then
--             xiazhu=self.OtherTou[1].roundBet
--         end
--         for k,v in pairs(xiazhu) do
--             if v ~= 0 then
--                 local beginspos=self:getPlayerGetPos(self.OtherTou[1].userCode)
--                 local count = 0
--                 local left = 0
--                 local score=v
--                 for i = #self.couma, 1, - 1 do
--                     local targetscore = self.couma[i]
--                     if score >= targetscore then
--                         count = math.floor(score / targetscore)
--                         left = score % targetscore
--                         score = left
--                         if count > 10 then
--                             count = 10
--                         end
--                          self:onSendPlaceJettonChip(k,beginspos,targetscore,count)
--                     end
--                 end               
--             end
--         end
--         if isxiazhu == true then
--             table.remove(self.OtherTou,1)
--         end
--     end
-- end
function brdssLayer:OnClockOtherTou()
    if  next(self.OtherTou) ~=nil and  self.xiazhuStatus == true  then
        local data =self.OtherTou[1]
        local ftime=0
        for k,v in pairs(data.roundBet) do
            if v ~= 0 then
                ftime=ftime+0.02
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
function brdssLayer:OtherTouzhu()
   
        --添加时间机制
    self._OtherClockFun = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
        if  self.OnClockOtherTou then
            self:OnClockOtherTou()
        end
    end,0.05,false)
end
function brdssLayer:killotherTou()
    self.OtherTou={}
    if self._OtherClockFun ~=nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._OtherClockFun)
        self._OtherClockFun =nil
    end
end
--开牌
function brdssLayer:GetOpenAction(card,cards)
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
function brdssLayer:showCard(index,cards,paixing)			 		--显示完整牌
	--for k,v in pairs(cards) do
		local pai=self.Card[index]
		pai:setVisible(true)
            local str=string.format("card_%d_%d.png",(cards[1].suit+1),cards[1].rank)
            local puke = CCSpriteFrameCache:getInstance():getSpriteFrame(str)
            local shuzhi =  CCSprite:createWithSpriteFrame(puke)
		shuzhi:move(72,98.5)
		shuzhi:addTo(pai)
    --end
    --显示牌型
    if paixing then
        self:showCardType(index,paixing)
    end
end
function brdssLayer:showCardType(index,cardtype)
    self.Paixing[index]:setVisible(true)
    self.Paixing[index]:getChildByName("T"):setString("X"..cardtype)
    -- local str=string.format("br/sg/%d",cardtype)
    -- ExternalFun.playSoundEffect(str,true)
    -- end
end
--设置庄和下庄按钮
function brdssLayer:setZhuangBtn(isbanker,isstatus,isend)
    local str={"Game/brpublic/brnui/btn_gsz.png","Game/brpublic/brnui/btn_gxz.png","Game/brpublic/brnui/btn_gq.png","Game/brpublic/brnui/btn_gq2.png"}
    if self.brMs ~= 1 then      --多庄
        str={"Game/brpublic/brnui/sqsz.png","Game/brpublic/brnui/sqzz.png","Game/brpublic/brnui/qxsq.png","Game/brpublic/brnui/qxsq2.png"}
    end
    local btnskin=str[1]
    if isstatus then
        btnskin=str[3]
        self.isQuxiao=true
    elseif isbanker ==true then
        btnskin=str[2]
    end
    if isend then
        btnskin=str[4]
        self.B_z:setEnabled(false)
    else
        self.B_z:setEnabled(true)
    end
     
    self.B_z:loadTextureNormal(btnskin)
    self.B_z:loadTexturePressed(btnskin)
    self.B_z:loadTextureDisabled(btnskin)
    self.B_z:setVisible(true)
   
    local layer=self:getChildByName("zhuangListLayer")
    if layer and layer.setZhuangBtn then
        layer:setZhuangBtn(isbanker,self.isQuxiao == true and true or nil,isend)
    end
end
--------------------------------------------------------------消息层-----------------------------------------------------

function brdssLayer:message(code,data)
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
        --self.B_quxiao:setVisible(false)
        
        if BaiRenHead.Gamestatus.kongxian == data.roomStatus then                   
         --空闲时期   
        elseif BaiRenHead.Gamestatus.kaishi == data.roomStatus then
         --下注时期
            --显示牌(并设置牌的背景)
            self:setZhuangBtn(data.isbanker == "1")
            self.isZhuang=(data.isbanker == "1")             --是否是庄家
            self.KeTouScore=data.brJoinDetail.bankerAccountBalance
            self:UpdateTouAndsKe()
            
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
             --启动投注计时器
 
        elseif BaiRenHead.Gamestatus.jiesuan == data.roomStatus then
         --结算时期
            --牌及牌型显示
            if data.remainSeconds < 6 then
                for i=1,5 do
                    self:showCard(i,data.brJoinDetail.areaCards[i],data.brJoinDetail.areaPxList[i]) 
                end
            else
                for i=1,5 do
                    --for a=1,3 do
                        self.Card[i]:setVisible(true)
                --end
                end
                performWithDelay(self,function ()
                    for i=1,5 do
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
        ExternalFun.dump(data.brJoinDetail.gameHis,"历史记录")
        self:gameHis(data.brJoinDetail.gameHis,true)
    elseif code == BaiRenHead.UpdateUserlist then
        --更新富豪榜
        self:updateFuhaolist(data.fhuser)
        --更新神算子
        self:updateSuanzilist(data.ssuser)
    elseif code == BaiRenHead.UpdateZhuanglist then
        local layer=self:getChildByName("zhuangListLayer")
        if layer and layer.inint then
            layer:inint(data)
        end
        self:updateZhuanglist(data.bankeruser)
    elseif code == BaiRenHead.Zhuang then
        if data.actionCode=="2" or data.actionCode == "3" then         --上庄成功
            self:setZhuangBtn(self.isbanker,true)
        elseif data.actionCode == "4" then
            self:setZhuangBtn(self.isbanker,nil,true)
        end
    elseif code == BaiRenHead.Wxiazhu then
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
     --游戏空闲
    elseif code ==BaiRenHead.GameKong then
        self:reGame(false)  
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
        self:reGame()                      --重置界面
         --金币列表
        self.m_coumaList = {{}, {}, {}, {}}
        --更新区域总住等筹码 
        self.zongzhulist={0,0,0,0}              --总住
        self.XutouChouma=self.Metouzhulist
        self.Metouzhulist={0,0,0,0}             --续投
        
        self.KeTouScore=data.bankerAccountBance
        self.YiTouScore=0
        self:PlayGameAction(1)
        self:UpdateTouAndsKe()

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
                --发牌
        self:sendCard()
        --开牌
        local delaytime=1
        for i = 1, 5 do
            performWithDelay(self,function ()
                self:showCard(i,data.areasCardsInfo[i].cards,data.areasCardsInfo[i].px)   
            end,delaytime)
            delaytime=delaytime+0.8
        end
        --庄家回收金币
        performWithDelay(self,function ()
             self:showcoumaMove()   
        end,4.6)
        
        --通赢或者同输动画
        local xstype=3
        if data.areasCardsInfo[1].winFlag and data.areasCardsInfo[1].winFlag ==data.areasCardsInfo[2].winFlag 
            and data.areasCardsInfo[2].winFlag ==data.areasCardsInfo[3].winFlag and data.areasCardsInfo[3].winFlag ==data.areasCardsInfo[4].winFlag then
            if data.areasCardsInfo[1].winFlag == -1 then
                xstype=3
            else
                xstype=4
            end
            performWithDelay(self,function ()
                self:PlayGameTAction(xstype) 
            end,5)
        end
        --金币飞的动画
        --self:showGoldToAreaWithMe(data.winOrLoss,data.bankerWinOrLoss)
        
         performWithDelay(self,function () 
                --计算输赢区域并显示
                for i=1,4 do
                    if data.areasCardsInfo[i].winFlag == 1 then
                        table.insert(self.blinkPos, i)
                    end
                end
                self:blinks()
                --显示输赢金币
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
                    if k <5 then
                         local bb=string.format("p1_%d",k)
                        local Pnode=self.player:getChildByName(bb)
                        if v.loseOrWinCoin ~= 0 then
                            self:showEnd(Pnode,v.loseOrWinCoin)
                        end
                    end
                end
                for k,v in pairs(data.ssList) do
       
                    if k <5 then
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
                --更新记录
                local winorlose={}
                for k,v in pairs(data.areasCardsInfo) do
                    table.insert(winorlose,v.winFlag)
                end
                self:gameHis(winorlose)
         end,5.5)
         

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
function brdssLayer:blinks()
	local delaytime = 0.5
	for i = 1, table.nums(self.blinkPos) do
		local idx = self.blinkPos[i]
		local betbg = self.QY[idx]:getChildByName("g")
		betbg:setVisible(true)
		betbg:setOpacity(0)
		local act = cc.Sequence:create(
		cc.FadeIn:create(0.5),
		cc.FadeOut:create(0.5)
		)
		local act11 = cc.DelayTime:create(2.5)
		local act2 = cc.CallFunc:create(function ()
			
		end)
		betbg:runAction(
		cc.Sequence:create(
		act, act, act,act11,act2
		)
		)
	end
	--reset
	self.blinkPos = {}
end
-------------------------------------------------------------消息相应层
function brdssLayer:gameHis(data,ble)
    -- do somethings
    --
    if ble then
        self.Trendlist:removeAllChildren()
        self.Trendnodelist={}
        for k,v in pairs(data) do
            local item=self.Trendp:clone()
            local str={"Game/brdss/d_x.png","Game/brdss/d_z.png"}
            --设置头像
  
            item:getChildByName("t1"):loadTexture(str[v.lossOrWinList[1] ==1 and 2 or 1])
            item:getChildByName("t2"):loadTexture(str[v.lossOrWinList[2] ==1 and 2 or 1])
            item:getChildByName("t3"):loadTexture(str[v.lossOrWinList[3] ==1 and 2 or 1])
            item:getChildByName("t4"):loadTexture(str[v.lossOrWinList[4] ==1 and 2 or 1])
            if k ==#data then
                item:getChildByName("g"):setVisible(true)
            else
                item:getChildByName("g"):setVisible(false)
            end
            self.Trendnodelist[k]=item
            self.Trendlist:pushBackCustomItem(item)
        end
    else
        local index=#self.Trendnodelist
       
        local item=self.Trendp:clone()
        local str={"Game/brdss/d_x.png","Game/brdss/d_z.png"}
        --设置头像
        item:getChildByName("t1"):loadTexture(str[data[1] ==1 and 2 or 1])
        item:getChildByName("t2"):loadTexture(str[data[2] ==1 and 2 or 1])
        item:getChildByName("t3"):loadTexture(str[data[3] ==1 and 2 or 1])
        item:getChildByName("t4"):loadTexture(str[data[4] ==1 and 2 or 1])
        --如果是五倍得时候
        if index == 6 then
            for i=1,5 do
                self.Trendnodelist[i]=self.Trendnodelist[i+1]
            end   
            self.Trendnodelist[index]=item
        else
            self.Trendnodelist[index+1]=item
        end
        for k,v in pairs(self.Trendnodelist) do
            if k ==#self.Trendnodelist then
                    v:getChildByName("g"):setVisible(true)
                else
                    v:getChildByName("g"):setVisible(false)
            end
        end  
        if index == 6 then
            self.Trendlist:removeItem(1)
        end        
        self.Trendlist:pushBackCustomItem(item)
        
    end
end
function brdssLayer:UpdateTouAndsKe()
    self.YiTou:setString(ExternalFun.numberTrans(self.YiTouScore))
    self.KeTou:setString(ExternalFun.numberTrans(self.KeTouScore))
end
function brdssLayer:showGoldToAreaWithMe(winOrLoss,bankerWinOrLoss)
    local detime=5
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
function brdssLayer:showGoldToAreaWithID(beganviewid,endviewid)
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

function brdssLayer:showcoumaMove()
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
function brdssLayer:getPlayerGetPos(userCode)
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
function brdssLayer:showEnd(node,changescore,ying,isZhuang,isYou)
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
function brdssLayer:onSendPlaceJettonChip(tag,beginpos,betIdx,goldnum,ftime)
    if self.xiazhuStatus == false then
        return
    end
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
		--local pgold = cc.Sprite:create(img)
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
function brdssLayer:getRandPos(nodeArea)
	local beginpos = cc.p(nodeArea:getPositionX() - 100, nodeArea:getPositionY() - 100)
	local offsetx = math.random()
	local offsety = math.random()
	return cc.p(beginpos.x + offsetx * 200, beginpos.y + offsety * 180)
end

--获取移动动画
--inorout,0表示加速飞出,1表示加速飞入
--isreverse,0表示不反转,1表示反转
-- function brdssLayer:getMoveAction(beginpos, endpos, callback, rtime, bScale, inorout, isreverse)
	
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
function brdssLayer:PlayGameAction(atype)
    self.GameActionB:setVisible(true)
    local anilist={"ani_dss_ksxz","ani_dss_tzxz"}
    local animation=self.GameActionB:getAnimation()
    local SoundEffect={"br/begin","br/shop","br/tchi","br/tpei"}
    ExternalFun.playSoundEffect( SoundEffect[atype],true)
    animation:play(anilist[atype])
	animation:setMovementEventCallFunc(function (arm, eventType, movmentID)
			if eventType == ccs. MovementEventType.start then
                    
			elseif eventType == ccs. MovementEventType.complete then
                self.GameActionB:setVisible(false)
                    
			elseif eventType == ccs. MovementEventType.loopComplete then
			end
	end)
end
function brdssLayer:PlayGameTAction(atype)
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
function brdssLayer:QuyuScoreUpdate(isMe,RoundBet)
    for k,v in pairs(RoundBet) do
        if v ~= 0 then
            self.zongzhulist[k]=self.zongzhulist[k]+v
            self:UpdateQuYuScore()
            if isMe then
                self.XutouChouma={0,0,0,0}             --续投筹码
                self.B_xutou:setEnabled(false)
                self.Metouzhulist[k]=self.Metouzhulist[k]+v
                self:UpdateQuYuMeScore()
            end
        end
	end
end
function brdssLayer:UpdateQuYuScore()
    for k,v in pairs(self.zongzhulist) do
        if v ~= 0 then
            local bb=self.QY[k]
            bb:getChildByName("T1"):setString(v)
            bb:getChildByName("T1"):setVisible(true)
        end
	end
end
function brdssLayer:UpdateQuYuMeScore()
    for k,v in pairs(self.Metouzhulist) do
        if v ~= 0 then
            local bb=self.QY[k]
            bb:getChildByName("T2"):setString("自己:"..v)
            bb:getChildByName("T2"):setVisible(true)
        end
	end
end
--更新庄家列表
function brdssLayer:updateZhuanglist(data)
    --区分单人模式
    if self.brMs ==1 then
        if next(data) ~=nil and data then
            local v= data[1]
            local head=self.zhuangNode:getChildByName("head")
            ExternalFun.createClipHead(head,v.userCode,v.logoUrl,70)
            self.zhuangNode:getChildByName("T1"):setString(v.userName)
            local a , b = math.modf(v.gameCoin)
            self.zhuangNode:getChildByName("T2"):setString(a)
        else
            self.zhuangNode:getChildByName("head"):removeAllChildren()
            self.zhuangNode:getChildByName("T1"):setString("无人上庄")
            self.zhuangNode:getChildByName("T2"):setString("")
        end
    --区分多人坐庄模式
    elseif self.brMs == 2 then
        for i=1,6 do
            local player=self.zhuangNode:getChildByName(string.format("p%d",i))
            if data[i] and data then
                local v= data[i]
                local head=player:getChildByName("head")
                ExternalFun.createClipHead(head,v.userCode,v.logoUrl,70)
                player:getChildByName("T1"):setString(v.precent)
            else
                player:getChildByName("head"):removeAllChildren()
                player:getChildByName("T1"):setString("无人")
            end
        end
    end
    self.zhuanglist=data
end
--更新富豪榜
function brdssLayer:updateFuhaolist(data)
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
function brdssLayer:updateSuanzilist(data)
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
function brdssLayer:updateMyScore(score)
    if score then
        self.ziji:getChildByName("T2"):setString(ExternalFun.numberTrans(score))
    else
        self.ziji:getChildByName("T1"):setString(public.userName)
        local head=self.ziji:getChildByName("head")
        ExternalFun.createClipHead(head,public.userCode,public.logoUrl,70) 
    end
end
return brdssLayer

