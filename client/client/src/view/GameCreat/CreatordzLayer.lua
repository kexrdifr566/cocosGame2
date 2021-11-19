local CreatordzLayer = class("CreatordzLayer", function ()
	local CreatordzLayer =  display.newLayer()
	return CreatordzLayer
end)
function CreatordzLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadzRootCSB("Club/RoomLayer/Room_CrdzLayer.csb", self)
	--self.bj=csbNode:getChildByName("bj")
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
    self.csbNode=csbNode
    self.BB={}
    for i=1,8 do
        local str=string.format("B%d",i)
        local btn=csbNode:getChildByName(str)
        btn:setTag(i)
        if i ~= 7 and  i~= 3 then
            btn:addTouchEventListener(btcallback)
        end
        self.BB[i]=btn
    end
    csbNode:getChildByName("P")
    :setTag(100)
    :addTouchEventListener(btcallback)
    
    self.B88 =csbNode:getChildByName("B88")
    self.B88:setTag(88)
    self.B88:addTouchEventListener(btcallback)
    
    --人数列表
	self.renshulist=ExternalFun.BtnList(self.BB[1],public.dezhou.renshu,function (index) self:onrenshu(index) end)
	self.renshulist:setVisible(false)
	self:addChild(self.renshulist)
    
    --最低人数列表    
    self.zdrenshulist=ExternalFun.BtnList(self.BB[2],public.dezhou.bgrenshu,function (index) self:onzdrenshu(index) end)
	self.zdrenshulist:setVisible(false)
	self:addChild(self.zdrenshulist)
    
    --局数选择   
    self.jushulist=ExternalFun.BtnList(self.BB[3],public.dezhou.jushu,function (index) self:onjushu(index) end)
	self.jushulist:setVisible(false)
	self:addChild(self.jushulist)
    --支付列表   
    self.zhifulist=ExternalFun.BtnList(self.BB[4],public.dezhou.zhifu,function (index) self:onzhifu(index) end)
	self.zhifulist:setVisible(false)
	self:addChild(self.zhifulist)
    
    --盲注列表   
    self.mangzhulist=ExternalFun.BtnList(self.BB[6],public.dezhou.mangzhu,function (index) self:onmangzhu(index) end)
	self.mangzhulist:setVisible(false)
	self:addChild(self.mangzhulist)
    --弃牌列表  
    self.qipailist=ExternalFun.BtnList(self.BB[8],public.dezhou.qipai,function (index) self:onqipai(index) end)
	self.qipailist:setVisible(false)
	self:addChild(self.qipailist)
    
        --模式
	self.choushuilist=ExternalFun.BtnList(self.B88,public.choushuims,function (index) self:onchoushuilist(index) end)
	self.choushuilist:setVisible(false)
	self:addChild(self.choushuilist)
    
    --低分列表  
    self.difenlist=ExternalFun.BtnList(self.BB[5],public.dezhou.difen,function (index) self:ondifen(index) end)
	self.difenlist:setVisible(false)
    self:addChild(self.difenlist)
    self.zhongtub={}
    self.gpsb={}
    for i=11,14 do
        local str=string.format("B%d",i)
        local btn=csbNode:getChildByName(str)
        btn:setTag(i)
        btn:addTouchEventListener(btcallback)
        if i < 13 then
            self.zhongtub[i-10]=btn
        else
            table.insert(self.gpsb,btn)
        end
    end
    local btn=csbNode:getChildByName("TT")
    self.TTF = ExternalFun.cteartTFtwo(btn:getChildByName("BQ"),btn,"请输入淘汰分数",true,nil,nil,20)
    local btn=csbNode:getChildByName("DF")
    self.DF = ExternalFun.cteartTFtwo(btn:getChildByName("BQ"),btn,"请输入底分",true,nil,nil,20)
    local btn=csbNode:getChildByName("CYF")
    self.CYF = ExternalFun.cteartTFtwo(btn:getChildByName("BQ"),btn,"请输入参与分数",true,nil,nil,20)
    --界面初始化
    self:inint()
    self:updatescore()
end
function CreatordzLayer:inint()
    self.renshu=public.dezhou.renshu[1]
    self.zdrenshu=public.dezhou.bgrenshu[1]
    self.jushu=public.dezhou.jushu[1]
    self.zhifu=1 ---1为房主支付
    self.mangzhu=public.dezhou.mangzhu[1]
    self.qipai=public.dezhou.qipai[1]
    self.difen=public.dezhou.difen[1]
    self.canyu=6
    self.zhongtu= 1  --可以中途加入
    self.gps    = 1 --开启GPS
    self.BB[1]:getChildByName("T"):setString(self.renshu.."人")
    self.BB[2]:getChildByName("T"):setString("满"..self.zdrenshu.."人开")
    self.BB[3]:getChildByName("T"):setString(self.jushu.."局")
    self.BB[4]:getChildByName("T"):setString(public.dezhou.zhifu[1])
    self.BB[5]:getChildByName("T"):setString(self.difen.."底分")
    self.BB[6]:getChildByName("T"):setString(self.mangzhu.."盲")
    self.BB[8]:getChildByName("T"):setString(self.qipai.."秒")
    self.zhongtub[1]:setEnabled(false)
    self.gpsb[1]:setEnabled(false)
    self.choushuims=1
    self.B88:getChildByName("T"):setString(public.choushuims[self.choushuims])
    
    self:update()
end
function CreatordzLayer:update()
    local data={}
    data.baseCoin=self.difen
    data.inings =self.jushu
    data.jm     = self.mangzhu
    data.limitUserNum = self.renshu
    data.roomType = public.game.dezhou
	--发送俱乐部列表
	st.send(HallHead.cjctupdate,data)
end
function CreatordzLayer:onrenshu(index)
    --print("人数选择"..index)
    self.renshu=public.dezhou.renshu[index]
    self.BB[1]:getChildByName("T"):setString(self.renshu.."人")
    self:update()
end
function CreatordzLayer:onchoushuilist(index)
    --print("模式"..index)
    self.choushuims=index
    local str=public.choushuims[index]
    self.B88:getChildByName("T"):setString(str)
end

function CreatordzLayer:onzdrenshu(index)
    --print("最低人数"..index)
    self.zdrenshu=public.dezhou.bgrenshu[index]
    self.BB[2]:getChildByName("T"):setString("满"..self.zdrenshu.."开")
end
function CreatordzLayer:onjushu(index)
    --print("局数"..index)
    self.jushu=public.dezhou.jushu[index]
    self.BB[3]:getChildByName("T"):setString(self.jushu.."局")
    self:update()
end
function CreatordzLayer:onzhifu(index)
    --print("支付"..index)
    if index== 1 then
        self.zhifu=1 
    else
        self.zhifu=2
    end
    self.BB[4]:getChildByName("T"):setString(public.dezhou.zhifu[index])
end
function CreatordzLayer:onmangzhu(index)
    --print("盲注"..index)
    self.mangzhu=public.dezhou.mangzhu[index]
    self.BB[6]:getChildByName("T"):setString(self.mangzhu.."盲")
    self:update()
end
function CreatordzLayer:onqipai(index)
    --print("弃牌"..index)
    self.qipai=public.dezhou.qipai[index]
    self.BB[8]:getChildByName("T"):setString(self.qipai.."秒")
end
function CreatordzLayer:ondifen(index)
    --print("低分"..index)
    self.difen=public.dezhou.difen[index]
    self.BB[5]:getChildByName("T"):setString(self.difen.."底分")
    self:update()
end
function CreatordzLayer:onButtonClickedEvent(tag,ref)
   --print("界面按下"..tag)
    if tag == 100 then
         self.renshulist:setVisible(false)
        self.zdrenshulist:setVisible(false)
         self.jushulist:setVisible(false)
        self.zhifulist:setVisible(false)
         self.difenlist:setVisible(false)
        self.mangzhulist:setVisible(false)
        self.qipailist:setVisible(false)
    elseif tag == 1 then
         self.renshulist:setVisible(true)
    elseif tag == 2 then
         self.zdrenshulist:setVisible(true)
    elseif tag == 3 then
         self.jushulist:setVisible(true)
    elseif tag == 4 then
         self.zhifulist:setVisible(true)
    elseif tag == 5 then
         self.difenlist:setVisible(true)
    elseif tag == 6 then
         self.mangzhulist:setVisible(true)
    elseif tag == 8 then
        self.qipailist:setVisible(true)
    elseif tag == 11 or tag == 12 then
        self:selectB(tag-10)
    elseif tag == 13 or tag == 14 then
        self:selectT(tag-12)
    elseif tag == 88 then
        self.choushuilist:setVisible(true)
    end
end
function CreatordzLayer:selectB(index)
	if self.zhongtub[index] ==nil then
		return
	end
    for k,v in pairs(self.zhongtub) do
	    v:setEnabled(true)
        if k == index then
         v:setEnabled(false)
        end
    end
    if index == 1 then
        self.zhongtu=1
    else
        self.zhongtu=0
    end
end
function CreatordzLayer:selectT(index)
	if self.gpsb[index] ==nil then
		return
	end
	for k,v in pairs(self.gpsb) do
	    v:setEnabled(true)
        if k == index then
         v:setEnabled(false)
        end
	end
end
function CreatordzLayer:message(data,code)
    if code ==HallHead.cjctupdate then
        self:updatescore(data.minCoin,data.zss)
    end
end
function CreatordzLayer:updatescore(Coin,zss)
    self.csbNode:getChildByName("T"):setString(zss)
    if Coin then
        local str="最低"..Coin.."分"
        self.BB[7]:getChildByName("T"):setString(str)
    end
end
function CreatordzLayer:Update(data)
    
    self.renshu=data.limitUserNum
    self.zdrenshu=data.canStartUserNum
    self.jushu=data.innings
    self.zhifu=1 ---1为房主支付
    self.mangzhu=data.jm
    self.qipai=data.autoplay
    self.difen=data.baseCoin
    self.BB[1]:getChildByName("T"):setString(self.renshu.."人")
    self.BB[2]:getChildByName("T"):setString("满"..self.zdrenshu.."开")
    self.BB[3]:getChildByName("T"):setString(self.jushu.."局")
    self.BB[4]:getChildByName("T"):setString(public.dezhou.zhifu[1])
    self.BB[5]:getChildByName("T"):setString(self.difen.."底分")
    self.BB[6]:getChildByName("T"):setString(self.mangzhu.."盲")
    self.BB[8]:getChildByName("T"):setString(self.qipai.."秒")
    self.TTF:setString(data.leaveCoin)
    self.DF:setString(data.difen)
    self.CYF:setString(data.minCoin)
    local ztjr=tonumber(data.ztjr)
    if ztjr == 1 then
        self:selectB(1)
    else
        self:selectB(2)
    end
    self.choushuims=data.choushuiMs
    self.B88:getChildByName("T"):setString(public.choushuims[self.choushuims])
    self:update()
end
function CreatordzLayer:checking()
    local t1 =tonumber(self.DF:getString())
    if t1 ==nil  then
        showToast("请输入底分",2)
        return
    end
    local t2 =tonumber(self.CYF:getString())
    if t2 ==nil  then
        showToast("请输入参与分数",2)
        return
    end
    
    local t3 =tonumber(self.TTF:getString())
    if t3 ==nil  then
        showToast("请输入淘汰分数",2)
        return
    end
    return  true
end

function CreatordzLayer:CreatorRoom()
    local t1 =tonumber(self.DF:getString())
    local t2 =tonumber(self.CYF:getString())
    local t3 =tonumber(self.TTF:getString())
    local data={}
    data.autoplay=self.qipai
    data.baseCoin =t1--self.difen
    data.canStartUserNum     = self.zdrenshu
    data.innings = self.jushu
    data.jm      = self.mangzhu
    data.limitUserNum = self.renshu
    data.roomType = public.game.dezhou
    data.texaBigBlind  = 2
    data.ztjr=self.zhongtu
    data.choushuiMs =self.choushuims
    data.minCoin = t2
    data.leaveCoin = t3
   --创建房间
   --st.send(HallHead.cjroom,data)
    self.scene:SendCreatorRoom(data)
end

return CreatordzLayer