local brbcbmLayer = class("brbcbmLayer", function ()
	local brbcbmLayer =  display.newLayer()
	return brbcbmLayer
end)
local BrSettingLayer=appdf.req(appdf.GAME_SRC.."brpublic.BrSettingLayer")
local BrPlayerListLayer=appdf.req(appdf.GAME_SRC.."brpublic.BrNPlayerListLayer")

local TrendLayer=appdf.req(appdf.GAME_SRC.."brlhd.BrlhdTrendLayer")
local BrRuleLayer=appdf.req(appdf.GAME_SRC.."brpublic.BrRuleLayer")
local BrdzjListLayer=appdf.req(appdf.GAME_SRC.."brpublic.BrdzjListLayer")
local BrmzjListLayer=appdf.req(appdf.GAME_SRC.."brpublic.BrmzjListLayer")
local beilv={5,5,40,30,20,10,5,5}
--{2,1,8,7,6,5,4,3}
function brbcbmLayer:ctor(_scene)

	self:playerinint()
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Game/brLayer/brbcbmLayer.csb", self)
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
                   -- ref:setScale(1)
                end
                self:onButtonClickedEvent(ref:getTag(),ref)
            elseif type == ccui.TouchEventType.began then
                if ref:getTag() <=50 or ref:getTag()>= 60 then 
                   -- ref:setScale(public.btscale)
                end
                return true
            elseif type == ccui.TouchEventType.canceled then
                if ref:getTag() <=50 or ref:getTag()>= 60 then 
                   -- ref:setScale(1)
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
    self.gameim=self.pai:getChildByName("time")
    
     --中间区域按钮
    self.QY={}
    for i=1,8 do
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
        -- BAN:getChildByName("Image"):setVisible(false)
        BAN:setEnabled(false)
        self.CM[i]=BAN
	end
    
    --牌
    self.Card={}
    for i=0,31 do
		self.Card[i]=self.pai:getChildByName(string.format("p%d",i))
	end
    --富豪榜
    self.p_l=self.player:getChildByName("p_l")
    --神算子
    self.p_r=self.player:getChildByName("p_r")
    --庄的列表
    self.p_t=self.player:getChildByName("p_t")
    --隐藏赢的动画
    self.action:setVisible(true)
    self.Trendnodelist={}
    self.Trendlist =self.down:getChildByName("Trendlist")
    self.Trendlist:setScrollBarEnabled(false)
    self.Trendp =self.down:getChildByName("Trendp")
    --自己信息
    self.ziji=self.player:getChildByName("zj")
    self:updateMyScore()                --更新自己的分数
	self:changebj()                     --更换背景
    self:changcmbl()                    --更换筹码比例
	self:reGame(true)                   --重置桌面信息

end
-- function brbcbmLayer:changcmbl()
--     local tableinfo=public.gettableinfo(public.roomCode)
--     if tableinfo.cmbl == 1 then
--         self.couma={1,10,50,100,500,1000}
--         for k,v in pairs(self.CM) do
--             local str =string.format("b%d.png",self.couma[k])
--             v:loadTextureNormal(str,ccui.TextureResType.plistType)
--             v:loadTexturePressed(str,ccui.TextureResType.plistType)
--             str =string.format("bh%d.png",self.couma[k])
--             v:loadTextureDisabled(str,ccui.TextureResType.plistType)
--         end
--     else
--          self.couma={10,50,100,500,1000,2000}
--     end
-- end
function brbcbmLayer:changcmbl()
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
function brbcbmLayer:changebj()
	-- local bjindex = cc.UserDefault:getInstance():getIntegerForKey("BRLHDBJ", 1)
	-- local str = string.format("Game/brlhd/bj%d.png",bjindex)
	-- self.bj:setBackGroundImage(str)
end
function brbcbmLayer:reGame(bol) 				   -----------重置界面
    self:stopAllActions()
    self.KeTou:setString("0")
    self.YiTou:setString("0")
    self.B_xutou:setEnabled(false)
    self.coumaLayer:removeAllChildren()
    self:settingcouma(false)
    --牌及牌型隐藏
    for k ,v in pairs(self.Card) do
        v:setVisible(false)
        v:stopAllActions()
    end
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
    self.m_fJettonTime = 2
    self.OtherTou={}
    self.blinkPos = {}
    self.actionhua=nil
    --self:killotherTou()    
end
function brbcbmLayer:playerinint()
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
    self.zongzhulist={0,0,0,0,0,0,0,0}             --总住列表
    self.Metouzhulist={0,0,0,0,0,0,0,0}             --总住列表
    self.XutouChouma={0,0,0,0,0,0,0,0}             --续投筹码
    self.isXiazhu=false
    self.KeTouScore=0
    self.YiTouScore=0
    self.OtherTou={}
    self.brMs = 1
    self.szfs = 0
    self.actionhua=nil
    	--金币列表
	self.m_coumaList = {{}, {}, {}, {},{}, {}, {}, {}}
end
-- function brbcbmLayer:SelectChouma(index)
--     --筹码已经选中
--     if self.SelChouma == index then
--         return
--     end
--     self.SelChouma=index
--     for k,v in pairs(self.CM) do
--         if index==k then
--             v:getChildByName("Image"):setVisible(true)
--         else
--             v:getChildByName("Image"):setVisible(false)
--         end
--     end
-- end
-- function brbcbmLayer:settingcouma(ble)
--         --筹码不可用状态
--     for k,v in pairs(self.CM) do
--         v:setEnabled(ble)
--     end
--     if ble == true then
--         self.CM[self.SelChouma]:getChildByName("Image"):setVisible(ble)
--     else
--         for k,v in pairs(self.CM) do
--             v:getChildByName("Image"):setVisible(ble)
--         end
--     end
-- end
function brbcbmLayer:SelectChouma(index)
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
function brbcbmLayer:settingcouma(ble)
        --筹码不可用状态
    for k,v in pairs(self.CM) do
        v:setEnabled(ble)
    end
end
function brbcbmLayer:onButtonClickedEvent(tag,ref)
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
        -- local layer =TrendLayer:create(self)
        -- layer:setName("TrendLayer")
        -- self:add(layer)
        self.scene:OpenBagLayer()
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
        --self.scene:OpenBagLayer()
        --self:blinkAllAnimat(0,math.random(0,31))
    end    
end
function brbcbmLayer:panduanXia(tag)
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
function brbcbmLayer:pushBet(index)
     local quyu={}
        for i=1,#self.QY do
            quyu[i]=0
        end
        --设置金额下注
        quyu[index]=self.couma[self.SelChouma]
        --传值
        local data ={}
    	data.actionCode =BaiRenHead.action[1]
    	data.betDetail = quyu
    	gst.send(BaiRenHead.Tcode,data)
        for k,v in pairs(self.QY) do
            v:setEnabled(false)
        end
        performWithDelay(self,function ()
                self:setXiaZhuQY() 
        end,0.2)
end
function brbcbmLayer:addToRootLayer(node, zorder)
	if nil == node then
		return
	end
	self.bj:addChild(node)
	node:setLocalZOrder(zorder or 0)
end
function brbcbmLayer:setXiaZhuQY(ble)
    for k,v in pairs(self.QY) do
        v:setEnabled(ble and ble or self.statusXia)
	end
end
function brbcbmLayer:KillGameClock()
    if self._ClockFun ~=nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._ClockFun)
        self._ClockFun =nil
    end
    self._ClockTime = 0
    self.gameim:setVisible(false)
end
function brbcbmLayer:SetGameClock(time,roomStatus)
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
    if BaiRenHead.Gamestatus.jiesuan == roomStatus and self.actionhua==nil then
        self.gameim:setVisible(false) 
    end
    self.gameim:getChildByName("T"):setString(str)
    self.gameim:getChildByName("Atlsa"):setString(self._ClockTime)
    --添加时间机制
    self._ClockFun = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
            if  self.OnClockUpdata then
                self:OnClockUpdata(roomStatus)
            end
            end,1,false)
end
function brbcbmLayer:OnClockUpdata(roomStatus)
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
    elseif BaiRenHead.Gamestatus.jiesuan == roomStatus and self.actionhua then
        self.gameim:setVisible(true) 
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
function brbcbmLayer:OnClockOtherTou()
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
                        performWithDelay(self,function ()
                            self:onSendPlaceJettonChip(k,beginspos,targetscore,count)
                        end,ftime) 
                    end
                end               
            end
        end
        table.remove(self.OtherTou,1)
    end
end
function brbcbmLayer:OtherTouzhu()
   
        --添加时间机制
    self._OtherClockFun = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
        if  self.OnClockOtherTou then
            self:OnClockOtherTou()
        end
    end,0.05,false)
end
function brbcbmLayer:killotherTou()
    self.OtherTou={}
    if self._OtherClockFun ~=nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._OtherClockFun)
        self._OtherClockFun =nil
    end
end
--设置庄和下庄按钮
function brbcbmLayer:setZhuangBtn(isbanker,isstatus,isend)
    local str={"bm_btn_sz.png","bm_btn_xz.png","bm_btn_qx.png","bm_btn_qx2.png"}
    if self.brMs ~= 1 then      --多庄
        str={"bm_btnz_sz.png","bm_btnz_sq.png","bm_btnz_qx.png","bm_btnz_qx2.png"}
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
     
    self.B_z:loadTextureNormal(btnskin,ccui.TextureResType.plistType)
    self.B_z:loadTexturePressed(btnskin,ccui.TextureResType.plistType)
    self.B_z:loadTextureDisabled(btnskin,ccui.TextureResType.plistType)
    self.B_z:setVisible(true)
   
    local layer=self:getChildByName("zhuangListLayer")
    if layer and layer.setZhuangBtn then
        layer:setZhuangBtn(isbanker,self.isQuxiao == true and true or nil,isend)
    end
end
--------------------------------------------------------------消息层-----------------------------------------------------

function brbcbmLayer:message(code,data)
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
                -- for i=1,2 do
                --     self:showCard(i,data.brJoinDetail.areaCards[i],data.brJoinDetail.areaPxList[i]) 
                -- end
            else
                performWithDelay(self,function ()
                    -- for i=1,2 do
                    --     self:showCard(i,data.brJoinDetail.areaCards[i],data.brJoinDetail.areaPxList[i]) 
                    -- end
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
        self.m_coumaList = {{}, {}, {}, {},{}, {}, {}, {}}
        --更新区域总住等筹码 
        self.zongzhulist={0,0,0,0,0,0,0,0}              --总住
        self.XutouChouma=self.Metouzhulist
        self.Metouzhulist={0,0,0,0,0,0,0,0}             --续投
        
        self.KeTouScore=data.bankerAccountBance
        self.YiTouScore=0
        self:PlayGameXiaZhuAction(1)
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
        self.statusXia=false            --是否可以下注
        self.isXiazhu=false
        self.isZhuang=(data.isbanker == "1")             --是否是庄家
        self:settingcouma(false)
        self.B_xutou:setEnabled(false)
        self.actionhua=nil
        self:blinkAllAnimat(data)   --结果动画
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
function brbcbmLayer:blinks()
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
function brbcbmLayer:gameHis(data,ble)
    -- do somethings
    --
    if ble then
        self.Trendlist:removeAllChildren()
        self.Trendnodelist={}
        for k,v in pairs(data) do
            local item=self.Trendp:clone()
            --设置头像
            local shopcar=v.car%8
            local str=string.format("bm_tb_%d.png",self:getCar(shopcar+1))
            item:getChildByName("t"):ignoreContentAdaptWithSize(true)
            item:getChildByName("t"):loadTexture(str,ccui.TextureResType.plistType)
            self.Trendnodelist[k]=item
            self.Trendlist:pushBackCustomItem(item)
            if k ~= #data then
                item:getChildByName("new"):setVisible(false) 
            end
        end
    else
        local index=#(self.Trendlist:getItems())
        local str=string.format("bm_tb_%d.png",self:getCar(data+1))
        local item=self.Trendp:clone()
        item:getChildByName("t"):ignoreContentAdaptWithSize(true)
        item:getChildByName("t"):loadTexture(str,ccui.TextureResType.plistType)
        if index == 13 then
            for i=1,12 do
                self.Trendnodelist[i]=self.Trendnodelist[i+1]
            end   
            self.Trendnodelist[index]=item
        else
            self.Trendnodelist[index+1]=item
        end
        if index == 13 then
            self.Trendlist:removeItem(1)
            table.remove(self.Trendnodelist,1)
        end        
        self.Trendlist:pushBackCustomItem(item)
        --去除新的标志
        print("self.Trendlist"..#self.Trendnodelist)
        for k,v in pairs(self.Trendnodelist) do
            if k ~=#self.Trendnodelist and v:getChildByName("new") then
                v:getChildByName("new"):setVisible(false) 
            end
        end
    end
    self.Trendlist:jumpToBottom()
end
function brbcbmLayer:UpdateTouAndsKe()
    self.YiTou:setString(ExternalFun.numberTrans(self.YiTouScore))
    self.KeTou:setString(ExternalFun.numberTrans(self.KeTouScore))
end

function brbcbmLayer:showcoumaMove()
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
function brbcbmLayer:getPlayerGetPos(userCode)
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
function brbcbmLayer:showEnd(node,changescore,ying,isZhuang,isYou)
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
	    
     -- if ying then
     --        if ying ==1 then
     --            ExternalFun.playSoundEffect("win",true)
     --        else
     --             ExternalFun.playSoundEffect("lose",true)
     --        end
     -- end

end
function brbcbmLayer:onSendPlaceJettonChip(tag,beginpos,betIdx,goldnum,ftime)
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
function brbcbmLayer:getRandPos(nodeArea)
    if nodeArea ==self.QY[1] or nodeArea ==self.QY[2] or nodeArea ==self.QY[3] or nodeArea ==self.QY[4] then
        local beginpos = cc.p(nodeArea:getPositionX() - 70, nodeArea:getPositionY() +10)
        if nodeArea ==self.QY[2] or nodeArea ==self.QY[4] then
            beginpos = cc.p(nodeArea:getPositionX() - 70, nodeArea:getPositionY() -25)
        end
        local offsetx = math.random()
        local offsety = math.random()
        return cc.p(beginpos.x + offsetx * 140, beginpos.y + offsety * 60)
    else
        local beginpos = cc.p(nodeArea:getPositionX() - 70, nodeArea:getPositionY() - 50)
        local offsetx = math.random()
        local offsety = math.random()
        return cc.p(beginpos.x + offsetx * 140, beginpos.y + offsety * 100)
    end
end

--获取移动动画
--inorout,0表示加速飞出,1表示加速飞入
--isreverse,0表示不反转,1表示反转
-- function brbcbmLayer:getMoveAction(beginpos, endpos, callback, rtime, bScale, inorout, isreverse)
	
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
function brbcbmLayer:QuyuScoreUpdate(isMe,RoundBet)
    for k,v in pairs(RoundBet) do
        if v ~= 0 then
            self.zongzhulist[k]=self.zongzhulist[k]+v
            self:UpdateQuYuScore()
            if isMe then
                self.XutouChouma={0,0,0,0,0,0,0,0}             --续投筹码
                self.B_xutou:setEnabled(false)
                self.Metouzhulist[k]=self.Metouzhulist[k]+v
                self:UpdateQuYuMeScore()
            end
        end
	end
end
function brbcbmLayer:UpdateQuYuScore()
    for k,v in pairs(self.zongzhulist) do
        if v ~= 0 then
            local bb=self.QY[k]
            bb:getChildByName("T1"):setString(v)
            bb:getChildByName("T1"):setVisible(true)
        end
	end
end
function brbcbmLayer:UpdateQuYuMeScore()
    for k,v in pairs(self.Metouzhulist) do
        if v ~= 0 then
            local bb=self.QY[k]
            bb:getChildByName("T2"):setString("自己:"..v)
            bb:getChildByName("T2"):setVisible(true)
        end
	end
end
--更新庄家列表
function brbcbmLayer:updateZhuanglist(data)
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
function brbcbmLayer:updateFuhaolist(data)
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
function brbcbmLayer:updateSuanzilist(data)
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
function brbcbmLayer:updateMyScore(score)
    if score then
        self.ziji:getChildByName("T2"):setString(ExternalFun.numberTrans(score))
    else
        self.ziji:getChildByName("T1"):setString(public.userName)
        local head=self.ziji:getChildByName("head")
        ExternalFun.createClipHead(head,public.userCode,public.logoUrl,70) 
    end
end
function  brbcbmLayer:blinkAllAnimat(data)
	for k, v in pairs(self.Card) do
        v:setVisible(true)
        local act = cc.Sequence:create(
		cc.FadeIn:create(0.01),
		cc.FadeOut:create(0.4)
		)
		local act2 = cc.CallFunc:create(function ()
            if k == #self.Card then
                --print("动画播放完毕")
                self:startAnimation(data)
			end
		end)
		v:runAction(cc.Sequence:create(act,act,act,act,act2))
    end
    ExternalFun.playSoundEffect("br/bc/bcbm_start",true)
 --        ExternalFun.playSoundEffect("br/bc/countdown_3",true,nil,"wav")
	-- 	performWithDelay(self,function ()
	-- 		ExternalFun.playSoundEffect("br/bc/countdown_2",true,nil,"wav")
	-- 	end,0.4)
	-- 	performWithDelay(self,function ()
	-- 		ExternalFun.playSoundEffect("br/bc/countdown_1",true,nil,"wav")
	-- 	end,1.0)
	
 --    performWithDelay(self,function ()
	-- 		ExternalFun.playSoundEffect("br/bc/countdown_go",true,nil,"wav")
	-- end,1.4)
end
local StartType = 1
local EndType = 2
local halfWayType = 3
local Game_TAG_COUNT = 32
--local temp=0
function brbcbmLayer:startAnimation(data)
    if data.lastCar==nil or data.Car ==nil then
        return
    end
    --temp=temp+1
    local Begscrolltag=data.lastCar
    --print("Begscrolltag"..temp)
    local shoptag=data.Car
	local tbStarttime = {0.4,0.4,0.4 ,0.3, 0.3, 0.2}
	local tbEndtime = { 0.5, 0.4, 0.3}
	local lightStandTime = 0.4 --光圈fadeout的时间
	local curjumpcount = Begscrolltag   --
	local iskeepScroll = true
	local slowcount = -1
	local fastcount = 1
	local endtiemCount = #tbEndtime
	local cango = false
	local scorlltime = 0.03 --4
	local scorlType = StartType
	self.scorlType = 0
	ExternalFun.playSoundEffect("br/bc/bcbm_run",true)
    local function countDown(dt)
        local scorlltag = curjumpcount
        local mod1 = math.fmod( scorlltag, Game_TAG_COUNT) 
        local seclectsp = self.Card[mod1]
        -- ExternalFun.playSoundEffect( "br/pressed",true)
        seclectsp:setVisible(true)
        local act = cc.Sequence:create(
            cc.FadeIn:create(0.01),
            cc.FadeOut:create(lightStandTime),	
            cc.CallFunc:create(function (node)
            end))
        local act2 = true
        curjumpcount = curjumpcount + 1
        if not iskeepScroll then
            iskeepScroll = true
            local tempslowcount = shoptag - #tbEndtime 
            slowcount = tempslowcount > 0 and tempslowcount or Game_TAG_COUNT + tempslowcount
            if slowcount ==32 then
                slowcount=0
            end
            print("2222fastcount"..fastcount .."  mod1=="..mod1.."  slowcount=="..slowcount)
        end
        if fastcount <= #tbStarttime then
            --启动
            scorlType = StartType
            self:customschedule(seclectsp,countDown,tbStarttime[fastcount])
            fastcount = fastcount + 1
            --cango=true
        elseif slowcount ~= -1 and (mod1 == slowcount or cango) then
             print("fastcount"..fastcount .."  mod1=="..mod1.."  slowcount=="..slowcount)
            --减速
            if endtiemCount == 3 then
                scorlType = EndType
                ExternalFun.playSoundEffect("br/bc/bcbm_end",true)
            end
            cango = true
            if tbEndtime[endtiemCount] then
                self:customschedule(seclectsp,countDown,tbEndtime[endtiemCount])
            end
     
            if endtiemCount == 0 then
                act2 = nil
            end
            endtiemCount = endtiemCount - 1
        else
            scorlType = halfWayType
            self:customschedule(seclectsp,countDown,scorlltime)
        end
        --self:ChangeRunningType(scorlType)
        self.scorlType = scorlType
        if act2  then
            seclectsp:runAction(cc.Sequence:create(act) )
        else
            local callback1 = cc.CallFunc:create(function ()
                performWithDelay(self,function ()
                    self:showlast(data)
                end,0.2)
            end)

            local playsoundCallback = cc.CallFunc:create(function ()
                --ExternalFun.playSoundEffect("animate"..(self.Target+1 ).."")
            end) 
            local swn = cc.Spawn:create(cc.Sequence:create(cc.DelayTime:create(0.6),playsoundCallback),cc.Blink:create(2,3))
            local addludanCallback = cc.CallFunc:create(function ()
                --显示结果
                self:showGoldToArea(shoptag)
                
            end)
            seclectsp:runAction(cc.Sequence:create(act,cc.FadeIn:create(0.01),swn,addludanCallback,callback1) )
        end
    end
    local ttime = 5.7
	self:customschedule(self,countDown,0.01)
	performWithDelay(self,function ()
		iskeepScroll = false
	end,ttime)	
end
function brbcbmLayer:customschedule(node, callback, delay)
    local delay = cc.DelayTime:create(delay)
    local sequence = cc.Sequence:create(delay, cc.CallFunc:create(callback))
    node:runAction(sequence)
    return sequence
end
--飞结果
function brbcbmLayer:showGoldToArea(shoptag)
    local x,y=self.Card[shoptag]:getPosition()
    local bpos = cc.p(x,y)
    x,y=self.Trendlist:getPosition()
    x=x+#self.Trendnodelist*51+23
    local pos = cc.p(x,y)
    local shopcar=shoptag%8
    local str=string.format("br/bc/animate%d",self:getCar(shopcar+1))
    ExternalFun.playSoundEffect(str,true)
    local str =string.format("bm_tb_%d.png",self:getCar(shopcar+1))
    local puke = CCSpriteFrameCache:getInstance():getSpriteFrame(str)
    local pgold =  CCSprite:createWithSpriteFrame(puke)
    self.coumaLayer:addChild(pgold)
    pgold:setPosition(bpos)
    pgold:stopAllActions()
	pgold:setVisible(true)
	local move = ExternalFun.getMoveBezierAction(bpos,pos,40,0.4)
	pgold:runAction(cc.Sequence:create(cc.DelayTime:create(0.05), move,cc.CallFunc:create(
	function()
		pgold:removeFromParent()
        self:gameHis(shopcar)
        self.blinkPos[1]=self:getCar(shopcar+1)
        self:blinks()
        self.actionhua=true
	end
	)
	))
end
--最后结果
function brbcbmLayer:showlast(data)
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
end
--通杀OR通配
function brbcbmLayer:PlayGameXiaZhuAction(atype)
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
function brbcbmLayer:getCar(index)
    local cars={2,1,8,7,6,5,4,3}
    return cars[index]
end
return brbcbmLayer

