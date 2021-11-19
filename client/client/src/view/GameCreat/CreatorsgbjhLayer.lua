local CreatorsgbjhLayer = class("CreatorsgbjhLayer", function ()
	local CreatorsgbjhLayer =  display.newLayer()
	return CreatorsgbjhLayer
end)
function CreatorsgbjhLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadzRootCSB("Club/RoomLayer/Room_CrsgbjhLayer.csb", self)
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
    for i=1,7 do
        local str=string.format("B%d",i)
        local btn=csbNode:getChildByName(str)
        btn:setTag(i)
        if  i==6 or i ==3  then
        else
            btn:addTouchEventListener(btcallback)
        end
        self.BB[i]=btn
    end
    csbNode:getChildByName("P")
    :setTag(100)
    :addTouchEventListener(btcallback)
    --人数列表
	self.renshulist=ExternalFun.BtnList(self.BB[1],public.sangongbi.renshu,function (index) self:onrenshu(index) end)
	self.renshulist:setVisible(false)
	self:addChild(self.renshulist)
    
    --最低人数列表    
    self.zdrenshulist=ExternalFun.BtnList(self.BB[2],public.sangongbi.bgrenshu,function (index) self:onzdrenshu(index) end)
	self.zdrenshulist:setVisible(false)
	self:addChild(self.zdrenshulist)
    
    --局数选择   
    self.jushulist=ExternalFun.BtnList(self.BB[3],public.sangongbi.jushu,function (index) self:onjushu(index) end)
	self.jushulist:setVisible(false)
	self:addChild(self.jushulist)
    --支付列表   
    self.zhifulist=ExternalFun.BtnList(self.BB[4],public.sangongbi.zhifu,function (index) self:onzhifu(index) end)
	self.zhifulist:setVisible(false)
	self:addChild(self.zhifulist)
    
        
    self.B88 =csbNode:getChildByName("B88")
    self.B88:setTag(88)
    self.B88:addTouchEventListener(btcallback)
    
            --模式
	self.choushuilist=ExternalFun.BtnList(self.B88,public.choushuims,function (index) self:onchoushuilist(index) end)
	self.choushuilist:setVisible(false)
	self:addChild(self.choushuilist)
    --下注注列表   
    self.zgxiazhulist=ExternalFun.BtnList(self.BB[7],public.sangongbi.zgxiazhu,function (index) self:onzgxiazhu(index) end)
	self.zgxiazhulist:setVisible(false)
	self:addChild(self.zgxiazhulist)
 --    --弃牌列表  
 --    self.qipailist=ExternalFun.BtnList(self.BB[8],public.sangongbi.qipai,function (index) self:onqipai(index) end)
	-- self.qipailist:setVisible(false)
	-- self:addChild(self.qipailist)
    
    --低分列表  
    self.difenlist=ExternalFun.BtnList(self.BB[5],public.sangongbi.difen,function (index) self:ondifen(index) end)
	self.difenlist:setVisible(false)
    self:addChild(self.difenlist)
    self.zhongtub={}
    self.gpsb={}
    self.Gmoshi={}
    self.Mpai={}
    for i=11,16 do
        local str=string.format("B%d",i)
        local btn=csbNode:getChildByName(str)
        btn:setTag(i)
        btn:addTouchEventListener(btcallback)
        if i < 13 then
            self.zhongtub[i-10]=btn
        elseif i < 15 then
            table.insert(self.gpsb,btn)
        else
            table.insert(self.Mpai,btn)
        end
    end
    self.TQ=csbNode:getChildByName("TQ")
    self.BQ=csbNode:getChildByName("BQ")
    --界面初始化
    self.TTQ = ExternalFun.cteartTFtwo(self.BQ:getChildByName("BQ"),self.BQ,"请输入抢庄分数",true,nil,nil,20)
    local btn=csbNode:getChildByName("BB")
    self.TTC = ExternalFun.cteartTFtwo(btn:getChildByName("BQ"),btn,"请输入参与分数",true,nil,nil,20)
    local btn=csbNode:getChildByName("TT")
    self.TTF = ExternalFun.cteartTFtwo(btn:getChildByName("BQ"),btn,"请输入淘汰分数",true,nil,nil,20)

    self:inint()
    self:updatescore()
end
function CreatorsgbjhLayer:inint()
    self.renshu=public.sangongbi.renshu[1]
    self.zdrenshu=public.sangongbi.bgrenshu[1]
    self.jushu=public.sangongbi.jushu[1]
    self.zhifu=1 ---1为房主支付
    self.zgxiazhu=public.sangongbi.zgxiazhu[1]
    -- self.qipai=public.sangongbi.qipai[1]
    self.mingpai=1
    self.moshi=1
    self.difen=public.sangongbi.difen[1]
    self.canyu=6
    self.zhongtu= 1  --可以中途加入
    self.gps    = 1 --开启GPS
    self.BB[1]:getChildByName("T"):setString(self.renshu.."人")
    self.BB[2]:getChildByName("T"):setString("满"..self.zdrenshu.."人开")
    self.BB[3]:getChildByName("T"):setString(self.jushu.."局")
    self.BB[4]:getChildByName("T"):setString(public.sangongbi.zhifu[1])
    self.BB[5]:getChildByName("T"):setString(self.difen.."底分")
    self.BB[7]:getChildByName("T"):setString(self.zgxiazhu.."下注")
    self.zhongtub[1]:setEnabled(false)
    self.gpsb[1]:setEnabled(false)
    self.Mpai[1]:setEnabled(false)
    self:upzuidi(1)    
    self.choushuims=1
    self.B88:getChildByName("T"):setString(public.choushuims[self.choushuims])
    
    self:update()
end

function CreatorsgbjhLayer:update()
    local data={}
    data.baseCoin=self.difen
    data.inings =self.jushu
    data.jm     = self.zgxiazhu
    data.limitUserNum = self.renshu
    data.roomType=public.game.sangongbi
	--发送俱乐部列表
	st.send(HallHead.cjctupdate,data)
end
function CreatorsgbjhLayer:onrenshu(index)
    --print("人数选择"..index)
    self.renshu=public.sangongbi.renshu[index]
    self.BB[1]:getChildByName("T"):setString(self.renshu.."人")
    self:update()
end
function CreatorsgbjhLayer:onzdrenshu(index)
    --print("最低人数"..index)
    self.zdrenshu=public.sangongbi.bgrenshu[index]
    self.BB[2]:getChildByName("T"):setString("满"..self.zdrenshu.."开")
end
function CreatorsgbjhLayer:onjushu(index)
    --print("局数"..index)
    self.jushu=public.sangongbi.jushu[index]
    self.BB[3]:getChildByName("T"):setString(self.jushu.."局")
    self:update()
end
function CreatorsgbjhLayer:onzhifu(index)
    --print("支付"..index)
    if index== 1 then
        self.zhifu=1 
    else
        self.zhifu=2
    end
    self.BB[4]:getChildByName("T"):setString(public.sangongbi.zhifu[index])
end
function CreatorsgbjhLayer:onzgxiazhu(index)
    --print("下注注"..index)
    self.zgxiazhu=public.sangongbi.zgxiazhu[index]
    self.BB[7]:getChildByName("T"):setString(self.zgxiazhu.."下注")
end
function CreatorsgbjhLayer:ondifen(index)
    --print("低分"..index)
    self.difen=public.sangongbi.difen[index]
    self.BB[5]:getChildByName("T"):setString(self.difen.."底分")
    --更新下注注

    --下注注1
    self.zgxiazhu=public.sangongbi.zgxiazhu[index]
    self.BB[7]:getChildByName("T"):setString(self.zgxiazhu.."下注")

    self:upzuidi(index)
    --更新
    self:update()
end
function CreatorsgbjhLayer:onButtonClickedEvent(tag,ref)
   --print("界面按下"..tag)
    if tag == 100 then
         self.renshulist:setVisible(false)
        self.zdrenshulist:setVisible(false)
        self.jushulist:setVisible(false)
         self.zhifulist:setVisible(false)
         self.difenlist:setVisible(false)
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
    elseif tag == 7 then
         self.zgxiazhulist:setVisible(true)
    -- elseif tag == 8 then
    --     self.qipailist:setVisible(true)
    elseif tag == 11 or tag == 12 then
        self:selectB(tag-10)
    elseif tag == 13 or tag == 14 then
        self:selectT(tag-12)
    elseif tag == 15 or tag == 16 then
        self:selectMoshi(tag-14)
    elseif tag == 88 then
        self.choushuilist:setVisible(true)
    end
end
function CreatorsgbjhLayer:onchoushuilist(index)
    --print("模式"..index)
    self.choushuims=index
    local str=public.choushuims[index]
    self.B88:getChildByName("T"):setString(str)
end
function CreatorsgbjhLayer:selectB(index)
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
function CreatorsgbjhLayer:upzuidi(index)
  -- local str =public.sangongbi.zuidi[index]
  -- if str then
  --   str="最高"..str.."分"
  --   self.BB[7]:getChildByName("T"):setString(str)
  -- end
end
function CreatorsgbjhLayer:selectT(index)
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
function CreatorsgbjhLayer:selectMoshi(index)
	if self.Mpai[index] ==nil then
		return
	end
	for k,v in pairs(self.Mpai) do
	    v:setEnabled(true)
        if k == index then
         v:setEnabled(false)
        end
	end
    self.mingpai=index
end


function CreatorsgbjhLayer:message(data,code)
    --dump(data,"data")
    self:updatescore(data.minCoin,data.zss)
end
function CreatorsgbjhLayer:updatescore(Coin,zss)
    if zss then
        self.csbNode:getChildByName("T"):setString(zss)
    end
    -- if Coin then
    --     local str="最低"..Coin.."分"
    --     self.BB[7]:getChildByName("T"):setString(str)
    -- end
end
function CreatorsgbjhLayer:Update(data)
    self.renshu=data.limitUserNum
    self.zdrenshu=data.canStartUserNum
    self.jushu=data.innings
    self.zhifu=1 ---1为房主支付
    self.zgxiazhu=data.sangongZdfs
    self.mingpai=data.mingpai
    self.difen=data.baseCoin
    self.zhongtu= tonumber(data.ztjr)  --可以中途加入
    self.BB[1]:getChildByName("T"):setString(self.renshu.."人")
    self.BB[2]:getChildByName("T"):setString("满"..self.zdrenshu.."人开")
    self.BB[3]:getChildByName("T"):setString(self.jushu.."局")
    self.BB[4]:getChildByName("T"):setString(public.sangongbi.zhifu[1])
    self.BB[5]:getChildByName("T"):setString(self.difen.."底分")
    self.BB[7]:getChildByName("T"):setString(self.zgxiazhu.."下注")
    
    self:selectB(self.zhongtu==0 and 2 or 1)
    self:selectMoshi(self.mingpai)
    self.choushuims=data.choushuiMs
    self.B88:getChildByName("T"):setString(public.choushuims[self.choushuims])
    self.TTQ:setString(data.qiangzhuangCoin)
    self.TTC:setString(data.minCoin)
    self.TTF:setString(data.leaveCoin)
    self:update()
end
function CreatorsgbjhLayer:checking()
    local t1=tonumber(self.TTQ:getString())
    local t2 =tonumber(self.TTC:getString())
    local t3 =tonumber(self.TTF:getString())
    if t2 ==nil  then
        showToast("请输入参与分数",2)
        return
    end
    if  t1==nil  then
        showToast("请输入抢庄分数",2)
        return
    end
    if t2 < self.difen  then
        showToast("请正确输入参与分数",2)
        return
    end
    if  t1 < self.difen  then
        showToast("请正确输入抢庄分数",2)
        return
    end
    if t3 ==nil  then
        showToast("请输入淘汰分数",2)
        return
    end
    return true
end
function CreatorsgbjhLayer:CreatorRoom()
    local t1=tonumber(self.TTQ:getString())
    local t2 =tonumber(self.TTC:getString())
    local t3 =tonumber(self.TTF:getString())
    local data={}
    data.sangongMs=1
    data.baseCoin =self.difen
    data.canStartUserNum     = self.zdrenshu
    data.innings = self.jushu
    data.sangongZdfs      = self.zgxiazhu
    data.limitUserNum = self.renshu
    data.roomType = public.game.sangongbi
    data.texaBigBlind  = 2
    data.ztjr=self.zhongtu
    data.mingpai=self.mingpai
    data.choushuiMs =self.choushuims
    data.minCoin = t2
    data.qiangzhuangCoin = t1 
    data.leaveCoin = t3
    
    self.scene:SendCreatorRoom(data)
end

return CreatorsgbjhLayer