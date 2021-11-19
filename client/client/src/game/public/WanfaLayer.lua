local WanfaLayer = class("WanfaLayer", function ()
	local WanfaLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return WanfaLayer
end)
function WanfaLayer:ctor(_scene,tableinfo)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadziRootCSB("Game/publicLayer/wanfaLayer.csb", self)
	self.bj=csbNode:getChildByName("bj")
    local btcallback = function (ref, type)
		if type == ccui.TouchEventType.ended then
			ExternalFun.playClickEffect()
			ref:setScale(1)
			self:onButtonClickedEvent(ref:getTag(),ref)
		elseif type == ccui.TouchEventType.began then
            if ref:getTag() ~= 100 then
                ref:setScale(public.btscale)
            end
			return true
		elseif type == ccui.TouchEventType.canceled then
			ref:setScale(1)
		end
	end
    csbNode:getChildByName("P")
    :setTag(100)
    :addTouchEventListener(btcallback)
    self.bj:getChildByName("B_C")
	:setTag(100)
	:addTouchEventListener(btcallback)
    self.bj:getChildByName("node_1"):setVisible(false)
    self.bj:getChildByName("node_2"):setVisible(false)
    self.bj:getChildByName("node_3"):setVisible(false)
    self.bj:getChildByName("node_5"):setVisible(false)
    self.bj:getChildByName("node_7"):setVisible(false)
    if tableinfo.roomType == public.game.dezhou then
        self:inintdz(tableinfo)
    elseif tableinfo.roomType == public.game.cow then
        self:inintcow(tableinfo)
    elseif tableinfo.roomType == public.game.sangong then
        self:inintsg(tableinfo)
    elseif tableinfo.roomType == public.game.sangongbi then
        self:inintsgbi(tableinfo)
    elseif tableinfo.roomType == public.game.dcow then
        self:inintdcow(tableinfo)
    end
end
--德州玩法介绍
function WanfaLayer:inintdz(data)
    dump(data,"tableinfo")
    local node=self.bj:getChildByName("node_1")
    node:getChildByName("T1"):setString(data.limitUserNum.."人")
    node:getChildByName("T2"):setString(data.canStartUserNum.."人")
    node:getChildByName("T3"):setString(data.innings.."局")
    node:getChildByName("T4"):setString(data.baseCoin.."分")
    node:getChildByName("T5"):setString(data.minCoin.."分")
    node:getChildByName("T6"):setString(data.leaveCoin.."分")
    node:getChildByName("T7"):setString(data.autoplay.."秒")
    node:getChildByName("T8"):setString(data.jm.."注")
    node:getChildByName("T9"):setString(data.roomTitle)
    local    str=""    
    if data.ztjr =="1" then
        str="中途可加入"
    else
        str="中途不可加入"
    end
    node:getChildByName("T10"):setString(str)
    node:setVisible(true)
end
--德州玩法介绍
function WanfaLayer:inintcow(data)
    dump(data,"tableinfo")
    local node=self.bj:getChildByName("node_2")
    node:getChildByName("T1"):setString(data.limitUserNum.."人")
    node:getChildByName("T2"):setString(data.canStartUserNum.."人")
    node:getChildByName("T3"):setString(data.innings.."局")
    node:getChildByName("T4"):setString(data.baseCoin.."-"..(data.baseCoin*5).."分")
    node:getChildByName("T5"):setString(data.minCoin.."分")
    node:getChildByName("T6"):setString(data.leaveCoin.."分")
    node:getChildByName("T7"):setString(data.niuniuWf== "1" and "经典玩法" or "点子玩法")
    node:getChildByName("T8"):setString(public.cow.wanglai[tonumber(data.niuniuLaizi)+1])
    node:getChildByName("T9"):setString(public.cow.tfanbei[data.betDouble])
    local str =""
    if data.niuniuTz ==0 then
        str="不可推注   "
    else
        str="推注:"..data.niuniuTz.."倍   "
    end
    node:getChildByName("T10"):setString(str)
    node:getChildByName("T11"):setString(data.qiangzhuangCoin.."分")
    node:getChildByName("T12"):setString(data.niuniuQiangZhuang.."倍")
    node:getChildByName("T13"):setString(data.betRatio)
    node:getChildByName("T14"):setString(data.roomTitle)
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
    node:getChildByName("T15"):setString(str)
    local    str=""    
    if data.ztjr =="1" then
        str="中途可加入"
    else
        str="中途不可加入"
    end
    node:getChildByName("T16"):setString(public.cow.fanbei[tonumber(data.niuniuWf)])
    node:setVisible(true)
    self.niuniuPx =cjson.decode(data.niuniuPx)--特殊规则
    --牛牛和斗公牛
    local data={}
    data.niuniuWf=1
        --发送俱乐部列表
    gst.send(HallHead.cjcowwf,data)
end
--德州玩法介绍
function WanfaLayer:inintsg(data)
    dump(data,"tableinfo")
    local node=self.bj:getChildByName("node_3")
    node:getChildByName("T1"):setString(data.limitUserNum.."人")
    node:getChildByName("T2"):setString(data.canStartUserNum.."人")
    node:getChildByName("T3"):setString(data.innings.."局")
    node:getChildByName("T4"):setString(data.baseCoin.."分")
    node:getChildByName("T5"):setString(data.minCoin.."分")
    node:getChildByName("T6"):setString(data.leaveCoin.."分")
    node:getChildByName("T7"):setString(data.sangongZdfs.."注")
    node:getChildByName("T9"):setString(data.roomTitle)
    local    str=""
    if data.mingpai == 1 then
        str=str.." 暗一张"
    else
        str=str.." 全暗"
    end
        
    if data.ztjr =="1" then
        str=str.." 中途可加入"
    else
        str=str.." 中途不可加入"
    end
    node:getChildByName("T10"):setString(str)
    node:setVisible(true)
end
--德州玩法介绍
function WanfaLayer:inintdcow(data)
    dump(data,"tableinfo")
    local node=self.bj:getChildByName("node_5")
    node:getChildByName("T1"):setString(data.limitUserNum.."人")
    node:getChildByName("T2"):setString(data.canStartUserNum.."人")
    --node:getChildByName("T3"):setString(data.innings.."局")
    node:getChildByName("T4"):setString(data.douNiuGd.."分")
    node:getChildByName("T5"):setString(data.minCoin.."分")
    node:getChildByName("T6"):setString(data.leaveCoin.."分")
    node:getChildByName("T7"):setString(data.niuniuWf== "1" and "经典玩法" or "点子玩法")
    node:getChildByName("T8"):setString(data.douNiuZjcj.."局")
    node:getChildByName("T9"):setString(data.douNiuSzGdbs.."倍")
    node:getChildByName("T10"):setString(data.douNiuSzCs.."次")
    node:getChildByName("T11"):setString(data.douNiuXjklk.."局")
    node:getChildByName("T12"):setString(data.douNiuXzxz)
    node:getChildByName("T13"):setString(data.betRatio)
    node:getChildByName("T14"):setString(data.roomTitle)
    if data.ztjr =="1" then
        str="中途可加入  "
    else
        str="中途不可加入  "
    end
    -- local x,y=string.find(data.niuniuGjxx,'3')
    -- if x then
    --     str=str.."禁止搓牌  "
    -- else
    --     str=str.."可以搓牌  "
    -- end
    node:getChildByName("T15"):setString(str)
    local    str=""    
    if data.ztjr =="1" then
        str="中途可加入"
    else
        str="中途不可加入"
    end
    node:getChildByName("T16"):setString(public.dcow.fanbei[tonumber(data.niuniuWf)])
    node:setVisible(true)
    self.niuniuPx =cjson.decode(data.niuniuPx)--特殊规则
    --牛牛和斗公牛
    local data={}
    data.niuniuWf=1
        --发送俱乐部列表
    gst.send(HallHead.cjcowwf,data)
end
function WanfaLayer:inintsgbi(data)
    dump(data,"tableinfo")
    local node=self.bj:getChildByName("node_7")
    node:getChildByName("T1"):setString(data.limitUserNum.."人")
    node:getChildByName("T2"):setString(data.canStartUserNum.."人")
    node:getChildByName("T3"):setString(data.innings.."局")
    node:getChildByName("T4"):setString(data.baseCoin.."分")
    node:getChildByName("T5"):setString(data.minCoin.."分")
    node:getChildByName("T6"):setString(data.leaveCoin.."分")
    node:getChildByName("T7"):setString(data.sangongZdfs.."注")
    node:getChildByName("T8"):setString(data.qiangzhuangCoin.."分")
    node:getChildByName("T9"):setString(data.roomTitle)
    local    str=""
    if data.mingpai == 1 then
        str=str.." 暗一张"
    else
        str=str.." 全暗"
    end
        
    if data.ztjr =="1" then
        str=str.." 中途可加入"
    else
        str=str.." 中途不可加入"
    end
    node:getChildByName("T10"):setString(str)
    str="至尊X8倍 大三公X7倍 小三公X6倍 混三公X5倍 9点X4倍 8点X3倍 7点X2倍 \n豹子X6倍 顺金X5倍 金花X4倍 顺子X3倍 对子X2倍 散牌X1倍"
    node:getChildByName("T11"):setString(str)
    node:setVisible(true)
end
function WanfaLayer:updatecow(data)
    local node=self.bj:getChildByName("node_2")
    if node:isVisible() ==false then
        node=self.bj:getChildByName("node_5")
    end
     local str=node:getChildByName("T16"):getString()
       if next(self.niuniuPx) ~=nil  then
           for k,v in pairs(self.niuniuPx) do
               for a,b in pairs(data) do
                   if v==b.code then
                       str =str.." "..b.value.."X"..b.bs
                   end
               end
           end
       end
       node:getChildByName("T16"):setString(str)
end
function WanfaLayer:onButtonClickedEvent(tag,ref)
    if tag == 100 then
        self:removeFromParent()
    end
end
return WanfaLayer

