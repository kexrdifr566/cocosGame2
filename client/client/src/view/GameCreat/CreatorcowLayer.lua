local CreatorcowLayer = class("CreatorcowLayer", function ()
	local CreatorcowLayer =  display.newLayer()
	return CreatorcowLayer
end)
function CreatorcowLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadzRootCSB("Club/RoomLayer/Room_CrcowLayer.csb", self)
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
    
    csbNode:getChildByName("P")
    :setTag(100)
    :addTouchEventListener(btcallback)
    
    self.P=csbNode:getChildByName("PB")
    self.P:setVisible(false)
    self.BB={}
    for i=1,12 do
        local str=string.format("B%d",i)
        local btn=csbNode:getChildByName(str)
        btn:setTag(i)
        if (i<10 or i==11 or i==12) and i ~=2 then
            btn:addTouchEventListener(btcallback)
        end
        self.BB[i]=btn
    end
    
    self.wfBB={}
    for i=1,2 do
        local str=string.format("W%d",i)
        local btn=csbNode:getChildByName(str)
        btn:setTag(i+20)
        btn:addTouchEventListener(btcallback)
        self.wfBB[i]=btn
    end
    self.gjBB={}
    for i=1,5 do
        local str=string.format("G%d",i)
        local btn=csbNode:getChildByName(str)
        btn:setTag(i+30)
        btn:addTouchEventListener(btcallback)
        self.gjBB[i]=btn
    end
    self.teBB={}
    for i=1,2 do
        local str=string.format("B%d",i)
        local btn=self.P:getChildByName(str)
        btn:setTag(i+40)
        btn:addTouchEventListener(btcallback)
        self.teBB[i]=btn
    end
    
    self.B88 =csbNode:getChildByName("B88")
    self.B88:setTag(88)
    self.B88:addTouchEventListener(btcallback)


    local btn=self.P:getChildByName("BB")
    btn:setTag(101)
    btn:addTouchEventListener(btcallback)
    --????????????
	self.renshulist=ExternalFun.BtnList(self.BB[1],public.cow.renshu,function (index) self:onrenshu(index) end)
	self.renshulist:setVisible(false)
    self:addChild(self.renshulist)
    --????????????
    self.jushulist=ExternalFun.BtnList(self.BB[2],public.cow.jushu,function (index) self:onjushu(index) end)
    self.jushulist:setVisible(false)
    self:addChild(self.jushulist)
    --????????????
    self.zhifulist=ExternalFun.BtnList(self.BB[3],public.cow.zhifu,function (index) self:onzhifu(index) end)
    self.zhifulist:setVisible(false)
    self:addChild(self.zhifulist)
    --??????????????????    
    self.zdrenshulist=ExternalFun.BtnList(self.BB[4],public.cow.bgrenshu,function (index) self:onzdrenshu(index) end)
	self.zdrenshulist:setVisible(false)
	self:addChild(self.zdrenshulist)
    --??????
    self.wanglailist=ExternalFun.BtnList(self.BB[5],public.cow.wanglai,function (index) self:onwanglai(index) end)
	self.wanglailist:setVisible(false)
    self:addChild(self.wanglailist)
    --????????????
    self.difenlist=ExternalFun.BtnList(self.BB[6],public.cow.difen,function (index) self:ondifen(index) end)
    self.difenlist:setVisible(false)
    self:addChild(self.difenlist)
    --??????
    self.qiangzhuanglist=ExternalFun.BtnList(self.BB[7],public.cow.zqz,function (index) self:onqiangzhang(index) end)
    self.qiangzhuanglist:setVisible(false)
    self:addChild(self.qiangzhuanglist)
    --??????
    self.tuizhutuilist=ExternalFun.BtnList(self.BB[8],public.cow.tuizhu,function (index) self:ontuizhu(index) end)
    self.tuizhutuilist:setVisible(false)
    self:addChild(self.tuizhutuilist)
    --??????
    self.beilvlist=ExternalFun.BtnList(self.BB[11],public.cow.beilv,function (index) self:onlielv(index) end)
    self.beilvlist:setVisible(false)
    self:addChild(self.beilvlist)
    
    --??????
    self.tfanbeilist=ExternalFun.BtnList(self.BB[12],public.cow.tfanbei,function (index) self:ontfanbei(index) end)
    self.tfanbeilist:setVisible(false)
    self:addChild(self.tfanbeilist)
    
        --??????
	self.choushuilist=ExternalFun.BtnList(self.B88,public.choushuims,function (index) self:onchoushuilist(index) end)
	self.choushuilist:setVisible(false)
	self:addChild(self.choushuilist)
   
    self.TQ=csbNode:getChildByName("TQ")
    self.BQ=csbNode:getChildByName("BQ")
    --???????????????
    self.TTQ = ExternalFun.cteartTFtwo(self.BQ:getChildByName("BQ"),self.BQ,"?????????????????????",true,nil,nil,20)
    local btn=csbNode:getChildByName("BBB")
    self.TTC = ExternalFun.cteartTFtwo(btn:getChildByName("BQ"),btn,"?????????????????????",true,nil,nil,20)
    local btn=csbNode:getChildByName("TT")
    self.TTF = ExternalFun.cteartTFtwo(btn:getChildByName("BQ"),btn,"?????????????????????",true,nil,nil,20)
    --???????????????
    if  self.scene.cowkind == 1 or self.scene.cowkind == 3 then
        self.TQ:setVisible(true)
        self.BQ:setVisible(true)
    else
        self.TQ:setVisible(false)
        self.BQ:setVisible(false) 
    end
    
    --???????????????
    self:inint()
end
function CreatorcowLayer:qiangzhuang()
    if  self.scene.cowkind == 1 or self.scene.cowkind == 3 then
        self.TQ:setVisible(true)
        self.BQ:setVisible(true)
    else
        self.TQ:setVisible(false)
        self.BQ:setVisible(false) 
    end
end
function CreatorcowLayer:inint()
    self.renshu=public.cow.renshu[1]
    self.BB[1]:getChildByName("T"):setString(self.renshu.."???")
    self.jushu=public.cow.jushu[1]
    self.BB[2]:getChildByName("T"):setString(self.jushu.."???")
    self.zhifu=1 ---1???????????????
    self.BB[3]:getChildByName("T"):setString(public.cow.zhifu[1])
    self.zdrenshu=public.cow.bgrenshu[1]
    self.BB[4]:getChildByName("T"):setString("???"..self.zdrenshu.."???")
    self.wanglai=0
    self.BB[5]:getChildByName("T"):setString(public.cow.wanglai[1])
    self.difen=public.cow.difen[1]
    self.BB[6]:getChildByName("T"):setString(self.difen.."-"..(self.difen*5).."???")
    self.zqz=public.cow.zqz[1]
    self.BB[7]:getChildByName("T"):setString(self.zqz.."???")
    self.tuizhu=0
    self.BB[8]:getChildByName("T"):setString(public.cow.tuizhu[1])
    self.beilv=public.cow.beilv[1]
    self.BB[11]:getChildByName("T"):setString(self.beilv.."???")
    
    self.tfanbei=1
    self.BB[12]:getChildByName("T"):setString(public.cow.tfanbei[1])
    self.selectTeshu=1
    self.teshuguize={}                   --????????????
    self.teshuQr={}                     --????????????
    self.teshuBB={}
    self:selectText(self.selectTeshu)
    self.BB[9]:getChildByName("T"):setString(public.cow.teshu[1])
    self:selectB(1)                 --??????
    self.wfBB[1]:setEnabled(false)  --????????????????????????
    self.gaoji={true,true,true,true,true} --????????????
    self.upteshuguize={}
    self.choushuims=1
    self.B88:getChildByName("T"):setString(public.choushuims[self.choushuims])

    self:upzzs()
    self.zhongtu=1
    self:upzuidi(1)
    self:update()
end
function CreatorcowLayer:onrenshu(index)
    --print("????????????"..index)
    self.renshu=public.cow.renshu[index]
    self.BB[1]:getChildByName("T"):setString(self.renshu.."???")
    self:upzzs()
end
function CreatorcowLayer:onjushu(index)
    --print("??????"..index)
    self.jushu=public.cow.jushu[index]
    self.BB[2]:getChildByName("T"):setString(self.jushu.."???")
    self:upzzs()
end
function CreatorcowLayer:onzhifu(index)
    --print("??????"..index)
    if index== 1 then
        self.zhifu=1
    else
        self.zhifu=2
    end
    self.BB[3]:getChildByName("T"):setString(public.cow.zhifu[index])
end
function CreatorcowLayer:onzdrenshu(index)
    --print("????????????"..index)
    self.zdrenshu=public.cow.bgrenshu[index]
    self.BB[4]:getChildByName("T"):setString("???"..self.zdrenshu.."???")
end
function CreatorcowLayer:onwanglai(index)
    --print("??????"..index)
    self.wanglai=index-1
    self.BB[5]:getChildByName("T"):setString(public.cow.wanglai[index])
end
function CreatorcowLayer:ondifen(index)
    --print("??????"..index)
    self.difen=public.cow.difen[index]
    self.BB[6]:getChildByName("T"):setString(self.difen.."-"..(self.difen*5).."???")
    self:upzuidi(index)
    self:upzzs()
end
function CreatorcowLayer:upzuidi(index)
  local str =public.cow.zuidi[index]
  if str then
    str="??????"..str.."???"
    self.BB[10]:getChildByName("T"):setString(str)
  end
end
function CreatorcowLayer:onqiangzhang(index)
    --print("??????"..index)
    self.zqz=public.cow.zqz[index]
    self.BB[7]:getChildByName("T"):setString(self.zqz.."???")
end
function CreatorcowLayer:ontfanbei(index)
    --print("??????"..index)
    self.tfanbei=index
    self.BB[12]:getChildByName("T"):setString(public.cow.tfanbei[index])
end
function CreatorcowLayer:onchoushuilist(index)
    print("??????"..index)
    self.choushuims=index
    local str=public.choushuims[index]
    self.B88:getChildByName("T"):setString(str)
end
function CreatorcowLayer:ontuizhu(index)
    --print("??????"..index)
    local str=""
    if index == 1 then
        self.tuizhu=0
        str=public.cow.tuizhu[1]
    else
        self.tuizhu=public.cow.tuizhu[index]
        str=self.tuizhu.."???"
    end
    self.BB[8]:getChildByName("T"):setString(str)
end
function CreatorcowLayer:onlielv(index)
    --print("??????"..index)
    self.beilv=public.cow.beilv[index]
    self.BB[11]:getChildByName("T"):setString(self.beilv.."???")
end
function CreatorcowLayer:onButtonClickedEvent(tag,ref)
   --print("????????????"..tag)
    if tag == 101 then
        self:setBBtext()
        self.P:setVisible(false)
    elseif tag == 100 then
        self.renshulist:setVisible(false)
        self.jushulist:setVisible(false)
        self.zhifulist:setVisible(false)
        self.zdrenshulist:setVisible(false)
        self.wanglailist:setVisible(false)
        self.difenlist:setVisible(false)
        self.qiangzhuanglist:setVisible(false)
        self.tuizhutuilist:setVisible(false)
        self.tfanbeilist:setVisible(false)
        self.beilvlist:setVisible(false)
    elseif tag == 1 then
         self.renshulist:setVisible(true)
    elseif tag == 2 then
         self.jushulist:setVisible(true)
    elseif tag == 3 then
         self.zhifulist:setVisible(true)
    elseif tag == 4 then
         self.zdrenshulist:setVisible(true)
    elseif tag == 5 then
         self.wanglailist:setVisible(true)
    elseif tag == 6 then
         self.difenlist:setVisible(true)
    elseif tag == 7 then
        self.qiangzhuanglist:setVisible(true)
    elseif tag == 8 then
        self.tuizhutuilist:setVisible(true)
    elseif tag == 9 then
        self:update()
        self.P:setVisible(true)
    elseif tag == 11 then
        self.beilvlist:setVisible(true)
    elseif tag == 12 then
        self.tfanbeilist:setVisible(true)
    elseif tag == 21 or tag == 22 then
        self:selectB(tag-20)
    elseif tag >30 and tag < 40 then
        self:selectGJ(tag-30)
    elseif tag >40 and tag <50 then
        self:selectText(tag-40)
    elseif tag == 88 then
        self.choushuilist:setVisible(true)
    end
end
function CreatorcowLayer:selectText(index)
    if self.teBB[index] ==nil then
        return
    end
    for k,v in pairs(self.teBB) do
        v:setEnabled(true)
        if k == index then
         v:setEnabled(false)
        end
    end
    self.selectTeshu=index
    self:setTeshu(0,self.selectTeshu)
    self.BB[9]:getChildByName("T"):setString(public.cow.teshu[index])
end
function CreatorcowLayer:selectGJ(index)
    self.gaoji[index] = not self.gaoji[index]

    for k,v in pairs(self.gaoji) do
        self.gjBB[k]:setBright(v)
    end
    
    if index == 4 then          --???????????? ?????????????????????
        if self.gaoji[index] then
            self.zhongtu=1
        else
            self.zhongtu =0
        end
    end   
end
function CreatorcowLayer:selectB(index)
	if self.wfBB[index] ==nil then
		return
	end
    for k,v in pairs(self.wfBB) do
	    v:setEnabled(true)
        if k == index then
         v:setEnabled(false)
        end
    end
    self.wanfa=index
    self.csbNode:getChildByName("BB"):getChildByName("T"):setString(public.cow.fanbei[self.wanfa])
end
function CreatorcowLayer:update()
    --self.P:setVisible(true)
    if #self.teshuguize == 0 then
         
        local data={}
        data.niuniuWf=self.wanfa
        --?????????????????????
        st.send(HallHead.cjcowwf,data)
    end
end
function CreatorcowLayer:upScore()
    local data={}
    data.roomType=public.game.cow
    data.baseCoin=self.difen
	--?????????????????????
	st.send(HallHead.cjctupdate,data)
end
function CreatorcowLayer:upzzs()
    local data={}
    data.roomType=public.game.cow
    data.limitUserNum=self.renshu
    data.baseCoin=self.difen
    data.roomzss=self.jushu
	--?????????????????????
	st.send(HallHead.cjctupdate,data)
end
function CreatorcowLayer:message(data,code)
   -- dump(data,"data")
    if code == HallHead.cjcowwf then
        local pk=self.P:getChildByName("P"):removeAllChildren()
        if data == nil then
            return
        end
        self.teshuguize=data                   --????????????
        self.teshuBB={}
        self.teshuQr={}
        local btcallback = function (ref, type)
            if type == ccui.TouchEventType.ended then
                    ExternalFun.playClickEffect()
                    ref:setScale(1)
                    local index=ref:getTag()
                    self:setTeshu(index,0)
            elseif type == ccui.TouchEventType.began then
                   ref:setScale(public.btscale)
                   return true
            elseif type == ccui.TouchEventType.canceled then
                   ref:setScale(1)
            end
        end
        local geshu=4
        local counts=math.ceil(#data/geshu)
        for i=1,counts do
            local item =self.P:getChildByName("PK"):clone()
            for j =1,geshu do
                local name=string.format("Text_%d",j)
                local it=item:getChildByName(name)
                local player= data[(i-1)*geshu+j]
                local str=string.format("F%d",j)
                if player ~= nil then
                    if player.value or player.bs then
                        it:setString(player.value.."X"..player.bs.."???")
                        local bb=item:getChildByName(str)
                        bb:setTag((i-1)*geshu+j)
                        bb:addTouchEventListener(btcallback)
                        self.teshuBB[(i-1)*geshu+j]=bb
                        self.teshuQr[(i-1)*geshu+j]=false
                    end
                else
                    it:setVisible(false)
                    item:getChildByName(str):setVisible(false)
                end
            end
            pk:pushBackCustomItem(item)
        end
        self:updateTeshu()
    elseif code == HallHead.cjctupdate then
        -- local str="??????"..data.minCoin.."???"
        -- self.csbNode:getChildByName("B10"):getChildByName("T"):setString(str)
        self.csbNode:getChildByName("T"):setString(data.zss)
    elseif code == HallHead.roomzss then
        local str="AA??????("..data.zss.."??????)"
        if  self.zhifu == 1 then
            str="????????????("..data.zss.."??????)"
        end
        self.csbNode:getChildByName("B3"):getChildByName("T"):setString(str)
    end  
end
function CreatorcowLayer:setBBtext()
    local str =""
    if self.selectTeshu == 0 then
        for k,v in pairs(self.teshuQr) do       --????????????
            if v then
                str=str..self.teshuguize[k].value.." "
            end
        end
        self.BB[9]:getChildByName("T"):setString(str)
    end
end
function CreatorcowLayer:setTeshu(index,ble)
    if ble == 1 then                --??????
        for k,v in pairs(self.teshuQr) do
           self.teshuQr[k]=false
        end
        for k,v in pairs(self.teshuBB) do
            v:setBright(true)
        end
    elseif ble == 2 then              --??????
        for k,v in pairs(self.teshuQr) do
            self.teshuQr[k]=true
        end
        for k,v in pairs(self.teshuBB) do
            v:setBright(false)
        end
    elseif ble == 0 then
        self.teshuQr[index] = not self.teshuQr[index]
        local xuanze=0
        for k,v in pairs(self.teshuQr) do       --????????????
            if v then
                xuanze=xuanze+1
                 self.teshuBB[k]:setBright(false)
            else
                 self.teshuBB[k]:setBright(true)
            end
        end
        if xuanze==0 then
            self:selectText(1)
        elseif xuanze == #self.teshuQr then
            self:selectText(2)
        else
            for k,v in pairs(self.teBB) do
                v:setBright(true)
                v:setEnabled(true)
            end
            self.selectTeshu=0
        end
    end
end
function CreatorcowLayer:getTeshu()
    local data ={}
    if self.selectTeshu == 0 then
        for k,v in pairs(self.teshuQr) do       --????????????
            if v then
                table.insert(data,self.teshuguize[k].code)
            end
        end
    elseif self.selectTeshu == 2 then
        for k,v in pairs(self.teshuguize) do
            table.insert(data,v.code)
        end
    end
    return data
end
function CreatorcowLayer:updateTeshu()
    if next(self.upteshuguize) ==nil  then
        self.selectTeshu = 1
        self:selectText(self.selectTeshu)
        --self:setTeshu(index,self.selectTeshu)
    elseif #self.upteshuguize==#self.teshuguize then
        self.selectTeshu = 2
        self:selectText(self.selectTeshu)
        --self:setTeshu(index,self.selectTeshu)
    else
        self.selectTeshu =0
        for k,v in pairs(self.upteshuguize) do
            for a,b in pairs(self.teshuguize) do
                if  v ==b.code then
                    self.teshuQr[a]=true
                end
            end
        end
        for k,v in pairs(self.teshuQr) do       --????????????
            if v then
                 self.teshuBB[k]:setBright(false)
            else
                 self.teshuBB[k]:setBright(true)
            end
        end
        self:setBBtext()
    end
    --self:setTeshu(index,self.selectTeshu)
end
function CreatorcowLayer:Update(data)
    self.renshu=data.limitUserNum
    self.BB[1]:getChildByName("T"):setString(self.renshu.."???")
    self.jushu=data.innings
    self.BB[2]:getChildByName("T"):setString(self.jushu.."???")
    self.zdrenshu=data.canStartUserNum
    self.BB[4]:getChildByName("T"):setString("???"..self.zdrenshu.."???")
    self.wanglai=data.niuniuLaizi
    self.BB[5]:getChildByName("T"):setString(public.cow.wanglai[self.wanglai+1])
    self.difen=data.baseCoin
    self.BB[6]:getChildByName("T"):setString(self.difen.."-"..(self.difen*5).."???")
    self.zqz=data.niuniuQiangZhuang
    self.BB[7]:getChildByName("T"):setString(self.zqz.."???")
    self.tuizhu=data.niuniuTz
    self.BB[8]:getChildByName("T"):setString(self.tuizhu.."???")
    self.beilv=data.betRatio
    self.BB[11]:getChildByName("T"):setString(self.beilv.."???")
    --????????????
    self.upteshuguize=cjson.decode(data.niuniuPx)
    
    self.tfanbei=data.betDouble
    self.BB[12]:getChildByName("T"):setString(public.cow.tfanbei[self.tfanbei])
    self:selectB(tonumber(data.niuniuWf))                 --??????
    self.wfBB[tonumber(data.niuniuWf)]:setEnabled(false)  --????????????????????????
    self.choushuims=data.choushuiMs
    self.B88:getChildByName("T"):setString(public.choushuims[self.choushuims])
    self.TTQ:setString(data.qiangzhuangCoin)
    self.TTC:setString(data.minCoin)
    self.TTF:setString(data.leaveCoin)
        --???????????????
    if  self.scene.cowkind == 1 or self.scene.cowkind == 3 then
        self.TQ:setVisible(true)
        self.BQ:setVisible(true)
    else
        self.TQ:setVisible(false)
        self.BQ:setVisible(false) 
    end
    local gaoji=string.gsub(data.niuniuGjxx, ",", "")
    
    local k=string.len(gaoji)
    for i=1,k do
        self:selectGJ(tonumber(string.sub(gaoji,i,i)))
    end
end
function CreatorcowLayer:checking()
    local t1=tonumber(self.TTQ:getString())
    local t2 =tonumber(self.TTC:getString())
    local t3 =tonumber(self.TTF:getString())
    if t3 ==nil  then
        showToast("?????????????????????",2)
        return
    end
    
    if t2 ==nil  then
        showToast("?????????????????????",2)
        return
    end
    if (self.scene.cowkind == 1 or self.scene.cowkind == 3) and t1==nil  then
        showToast("?????????????????????",2)
        return
    end
    if t2 < self.difen  then
        showToast("???????????????????????????",2)
        return
    end
    if (self.scene.cowkind == 1 or self.scene.cowkind == 3) and t1 < self.difen  then
        showToast("???????????????????????????",2)
        return
    end
    return  true
end
function CreatorcowLayer:CreatorRoom()
    local t1=tonumber(self.TTQ:getString())
    local t2 =tonumber(self.TTC:getString())
    local t3 =tonumber(self.TTF:getString())
    -- print("????????????==???"..self.scene.cowkind)
    -- print("????????????==???"..self.wanfa)
    -- print("????????????==???"..self.renshu)
    -- print("????????????==???"..self.jushu)
    -- print("????????????==???"..public.cow.zhifu[self.zhifu])
    -- print("??????????????????==???"..self.zdrenshu)
    -- print("????????????==???"..public.cow.wanglai[self.wanglai+1])
    -- print("????????????==???"..self.difen)
    -- print("??????????????????==???"..self.zqz)
    -- print("????????????==???"..self.tuizhu)
    -- print("??????????????????==???"..self.selectTeshu)
    -- dump(self.gaoji,"??????????????????")
    local data={}
        data.niuniuLx=self.scene.cowkind
        data.niuniuWf=self.wanfa
        data.limitUserNum=self.renshu
        data.canStartUserNum=self.zdrenshu
        data.innings=self.jushu
        data.niuniuLaizi=self.wanglai
        data.baseCoin=self.difen
        data.niuniuQiangZhuang=self.zqz
        data.niuniuTz=self.tuizhu
        data.roomType=public.game.cow
        data.ztjr=self.zhongtu
        data.betRatio =self.beilv
        data.betDouble=self.tfanbei
        data.niuniuPx=self:getTeshu()
        data.choushuiMs =self.choushuims
        data.minCoin = t2
        data.qiangzhuangCoin = self.scene.cowkind ~= 2 and t1 or 0
        local str=""
        for k,v in pairs(self.gaoji) do
            if not v then
                str=str..k..","
            end
        end
        data.niuniuGjxx=str
        data.leaveCoin = t3
        self.scene:SendCreatorRoom(data)
end

return CreatorcowLayer