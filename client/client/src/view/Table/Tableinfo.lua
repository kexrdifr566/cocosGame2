local Tableinfo = class("Tableinfo", function ()
	local Tableinfo =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return Tableinfo
end)
local AnimationHelper = appdf.req(appdf.EXTERNAL_SRC .. "AnimationHelper")
local TAG={1,2,3,4}
function Tableinfo:ctor(_scene,data)
    EventMgr.registerEvent(self,"Tableinfo")
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Club/RoomLayer/Room_tableinfo.csb", self)
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
    self.bj:getChildByName("B_C")
	:setTag(100)
	:addTouchEventListener(btcallback)
	self.bj:getChildByName("Enter")
	:setTag(1)
	:addTouchEventListener(btcallback)
    
    self.bj:getChildByName("Guanzhan")
	:setTag(4)
	:addTouchEventListener(btcallback)
    
    self.bj:getChildByName("Edit")
	:setTag(2)
	:addTouchEventListener(btcallback)
    
     self.bj:getChildByName("diss")
	:setTag(3)
	:addTouchEventListener(btcallback)
    
    local clubinfo=public.getclubinfo(public.enterclubid)
    if clubinfo.groupRoleCode  == public.culbCode.qunzhu 
            or clubinfo.groupRoleCode  == public.culbCode.fuqunzhu then  --只有群主才可
                self.bj:getChildByName("Edit"):setVisible(true)
                self.bj:getChildByName("diss"):setVisible(true)
            else
                self.bj:getChildByName("Edit"):setVisible(false)
                self.bj:getChildByName("diss"):setVisible(false)
    end
	self.playerlist=self.bj:getChildByName("playerlist")
    self.player=self.bj:getChildByName("player")
    self.data=data
    self.i1=self.bj:getChildByName("I1")
    self.i2=self.bj:getChildByName("I2")
    self.tableplayer={}
    self.niuniuPx=nil
    AnimationHelper.jumpInEx(self.bj, 1)
end
function Tableinfo:inint(data)
    self:inindatai(data)
    self:inindatais(data)
end
function Tableinfo:inindatai(data)
    local str=""
    --玩法
    self.bj:getChildByName("T"):setString(data.roomTitle)
    self.bj:getChildByName("T"):setVisible(false)
    str=data.roomTypeValue
    if data.roomType == public.game.cow  then
        str=str.."-"..public.cowwf[tonumber(data.niuniuLx)]
    elseif data.roomType == public.game.sangong then
        str=str.."-"..public.sgwf[data.sangongMs]--data.sangongMs
    end
    self.i1:getChildByName("t1"):setString(str)
    --人数
    if data.limitUserNum  then
        str=data.limitUserNum
        self.i1:getChildByName("t2"):setString(str)
    else
        self.i1:getChildByName("t2"):setVisible(false)
        self.i1:getChildByName("b2"):setVisible(false)
    end
     --局数
    if data.innings  then
        str=data.nowInningIndex.."/"..data.innings
        self.i1:getChildByName("t4"):setString(str)
    else
        self.i1:getChildByName("t4"):setVisible(false)
        self.i1:getChildByName("b4"):setVisible(false)
    end
    --最低分数
    self.i1:getChildByName("t3"):setString(data.minCoin)
    --淘汰
    self.i1:getChildByName("t5"):setString(data.leaveCoin)
end
function Tableinfo:inindatais(data)
    --dump(data,"桌子信息###")
    local str=""
    if data.roomType == public.game.dezhou then
        --游戏玩法
        str="满"..data.canStartUserNum.."人开桌   自动弃牌"..data.autoplay.."秒"
        self.i2:getChildByName("t1"):setString(str)
        --房间规则
        str="底注:"..data.baseCoin.."  小盲注:"..data.jm
        self.i2:getChildByName("t2"):setString(str)
        --特殊规则
        if data.ztjr =="1" then
            str="中途可加入"
        else
            str="中途不可加入"
        end
        self.i2:getChildByName("t3"):setString(str)
        self.i2:getChildByName("b4"):setVisible(false)
        self.i2:getChildByName("t4"):setVisible(false)
        
    elseif data.roomType == public.game.cow then
        self:getTeshu()
        --游戏玩法
        str="满"..data.canStartUserNum.."人开桌   "
      
        if data.niuniuTz ==0 then
            str=str.."不可推注   "
        else
            str=str.."推注:"..data.niuniuTz.."倍   "
        end
        str=str..public.cow.tfanbei[data.betDouble].."   "
        str=str..public.cow.wanglai[tonumber(data.niuniuLaizi)+1]
        self.i2:getChildByName("t1"):setString(str)
        --房间规则
        str="底注:"..data.baseCoin.."-"..(data.baseCoin*5).."分  最大抢庄:"..data.niuniuQiangZhuang.."倍  倍率:"..data.betRatio..
        "   抢庄分数:"..data.qiangzhuangCoin
        self.i2:getChildByName("t2"):setString(str)
        --特殊规则
        if data.ztjr =="1" then
            str="中途可加入  "
        else
            str="中途不可加入  "
        end
        local x,y=string.find(data.niuniuGjxx,'3')
        if x then
            str=str.."禁止搓牌  "
        else
            str=str.."可以搓牌  "
        end
        self.i2:getChildByName("t3"):setString(str)
        --特殊玩法
        str=public.cow.fanbei[tonumber(data.niuniuWf)]
        self.i2:getChildByName("t4"):setString(str)
        self.niuniuPx =cjson.decode(data.niuniuPx)--特殊规则
    elseif data.roomType == public.game.sangong then
        --游戏玩法
        str="满"..data.canStartUserNum.."人开桌   发牌"
        if data.mingpai == 1 then
            str=str.." 暗一张"
        else
            str=str.." 全暗"
        end
        self.i2:getChildByName("t1"):setString(str)
        --房间规则
        str="底注:"..data.baseCoin.."  最高下注:"..data.sangongZdfs.."  抢庄分数:"..data.qiangzhuangCoin
        self.i2:getChildByName("t2"):setString(str)
        --特殊规则
        if data.ztjr =="1" then
            str="中途可加入"
        else
            str="中途不可加入"
        end
        self.i2:getChildByName("t3"):setString(str)
        
        self.i2:getChildByName("b4"):setVisible(false)
        self.i2:getChildByName("t4"):setVisible(false)
    elseif data.roomType == public.game.sangongbi then
        --游戏玩法
        str="满"..data.canStartUserNum.."人开桌   发牌"
        if data.mingpai == 1 then
            str=str.." 暗一张"
        else
            str=str.." 全暗"
        end
        self.i2:getChildByName("t1"):setString(str)
        --房间规则
        str="底注:"..data.baseCoin.."  最高下注:"..data.sangongZdfs.."  抢庄分数:"..data.qiangzhuangCoin
        self.i2:getChildByName("t2"):setString(str)
        --特殊规则
        if data.ztjr =="1" then
            str="中途可加入"
        else
            str="中途不可加入"
        end
        self.i2:getChildByName("t3"):setString(str)
        
        --self.i2:getChildByName("b4"):setVisible(false)
        str="至尊X8倍 大三公X7倍 小三公X6倍 混三公X5倍 9点X4倍 8点X3倍 7点X2倍 \n豹子X6倍 顺金X5倍 金花X4倍 顺子X3倍 对子X2倍 散牌X1倍"
        self.i2:getChildByName("t4"):setString(str)
    elseif data.roomType == public.game.dcow then
        self:getTeshu()
        --游戏玩法
        str="满"..data.canStartUserNum.."人开桌"
        self.i2:getChildByName("t1"):setString(str)
        --房间规则
        str="首庄锅底:"..data.douNiuGd.."分  持庄局数:"..data.douNiuZjcj.."局  闲家下注:"..(data.douNiuXzxz*100).."%"
        self.i2:getChildByName("t2"):setString(str)
        --特殊规则
        if data.ztjr =="1" then
            str="中途可加入"
        else
            str="中途不可加入"
        end
        self.i2:getChildByName("t3"):setString(str)
        
        str=public.dcow.fanbei[tonumber(data.niuniuWf)]
        self.i2:getChildByName("t4"):setString(str)
        self.niuniuPx =cjson.decode(data.niuniuPx)--特殊规则
    else
        str=public.brwf.moshi[data.brMs].."  上庄需要"..data.kzfs
        self.i2:getChildByName("t1"):setString(str)
        self.i2:getChildByName("b2"):setVisible(false)
        self.i2:getChildByName("b3"):setVisible(false)
        self.i2:getChildByName("b4"):setVisible(false)
        self.i2:getChildByName("t2"):setVisible(false)
        self.i2:getChildByName("t3"):setVisible(false)
        self.i2:getChildByName("t4"):setVisible(false)
    end
end
--牛牛和斗公牛
function Tableinfo:getTeshu()
    local data={}
    data.niuniuWf=1
        --发送俱乐部列表
    st.send(HallHead.cjcowwf,data)
end
function Tableinfo:ininUsers(data)
    if data ==nil then
        return
    end
    local biandong=false
    if #data == 0 and #self.tableplayer ~= 0 then
        biandong = true
    end
    for k,v in pairs(data) do
        if self.tableplayer[k] == nil then
            biandong = true
            break
        end
        if self.tableplayer[k].userCode ~= v.userCode then
            biandong = true
            break
        end
    end
    
    if biandong == false  then
        return
    end
    self.playerlist:removeAllChildren()
    --dump(data,"桌子玩家信息"..#self.tableplayer)
    for k,v in pairs(data) do
        local item=self.player:clone()
        item:setVisible(true)
        local headbg=item:getChildByName("head")
        if v.userLogo then
        --设置头像  
            ExternalFun.createClipHead(headbg,v.userCode,v.userLogo,67)
        end
        if v.logoUrl then
        --设置头像  
            ExternalFun.createClipHead(headbg,v.userCode,v.logoUrl,67)
        end
        -- if v.userName then
        --     item:getChildByName("Text_1")
        -- end
        self.playerlist:pushBackCustomItem(item)
    end
    self.tableplayer =data
end
function Tableinfo:getTalberoomcode()
    return self.data.roomCode
end
function Tableinfo:message(code,data)
   if  code ==  HallHead.cjcowwf then
       --dump(self.niuniuPx,"ddd")
       local str=self.i2:getChildByName("t4"):getString()
       if next(self.niuniuPx) ~=nil  then
           for k,v in pairs(self.niuniuPx) do
               for a,b in pairs(data) do
                   if v==b.code then
                       str =str.." "..b.value.."X"..b.bs
                   end
               end
           end
       end
       self.i2:getChildByName("t4"):setString(str)
   end
end
function Tableinfo:onButtonClickedEvent(tag,ref)
    if tag == 100 then
        EventMgr.removeEvent("Tableinfo")
        self:removeFromParent()
    elseif tag == 1 then
        self.scene:enterClubRoom(self.data.roomCode,self.data.roomType)
        self.bj:getChildByName("Enter"):setEnabled(false)
    elseif tag == 4 then
        self.scene:enterClubRoom(self.data.roomCode,self.data.roomType,true)
        self.bj:getChildByName("Guanzhan"):setEnabled(false)
    elseif tag == 2 then
        self.scene:openUpdateRoom(self.data)
    elseif tag == 3 then
        local data={}
        local clubinfo = public.getclubinfo(public.enterclubid)
        data.groupCode=clubinfo.groupCode
        data.roomCode=self.data.roomCode
        data.userCode=public.userCode
        st.send(HallHead.jsroom,data)
         self.bj:getChildByName("diss"):setEnabled(false)
    end
end
return Tableinfo

