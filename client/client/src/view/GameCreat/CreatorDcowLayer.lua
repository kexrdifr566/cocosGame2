local CreatorDcowLayer = class("CreatorDcowLayer", function ()
	local CreatorDcowLayer =  display.newLayer()
	return CreatorDcowLayer
end)
function CreatorDcowLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadzRootCSB("Club/RoomLayer/Room_CrDcowLayer.csb", self)
    local btcallback = function (ref, type)
        if type == ccui.TouchEventType.ended then
            ExternalFun.playClickEffect()
			--ref:setScale(1)
			self:onButtonClickedEvent(ref:getTag(),ref)
		elseif type == ccui.TouchEventType.began then
			--ref:setScale(public.btscale)
			return true
		elseif type == ccui.TouchEventType.canceled then
			--ref:setScale(1)
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
        if i~= 2 then
            btn:addTouchEventListener(btcallback)
        end
        self.BB[i]=btn
    end
    
    self.gjBB={}
    for i=1,3 do
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
    self.wfBB={}
    for i=1,2 do
        local str=string.format("W%d",i)
        local btn=csbNode:getChildByName(str)
        btn:setTag(i+20)
        btn:addTouchEventListener(btcallback)
        self.wfBB[i]=btn
    end
    local btn=self.P:getChildByName("BB")
    btn:setTag(101)
    btn:addTouchEventListener(btcallback)
    --人数列表
	self.renshulist=ExternalFun.BtnList(self.BB[1],public.dcow.renshu,function (index) self:onrenshu(index) end)
	self.renshulist:setVisible(false)
    self:addChild(self.renshulist)
    --庄家持局
    self.zjcjlist=ExternalFun.BtnList(self.BB[3],public.dcow.zjcj,function (index) self:onzjcj(index) end)
    self.zjcjlist:setVisible(false)
    self:addChild(self.zjcjlist)
    
    --升庄锅底 
    self.szgdlist=ExternalFun.BtnList(self.BB[4],public.dcow.szgd,function (index) self:onszgd(index) end)
	self.szgdlist:setVisible(false)
    self:addChild(self.szgdlist)
    
    --升庄次数 
    self.szcslist=ExternalFun.BtnList(self.BB[5],public.dcow.szgd,function (index) self:onszcs(index) end)
	self.szcslist:setVisible(false)
    self:addChild(self.szcslist)
    
    --有无花牌
    self.Huapailist=ExternalFun.BtnList(self.BB[6],public.dcow.hpxz,function (index) self:onHuapai(index) end)
    self.Huapailist:setVisible(false)
    self:addChild(self.Huapailist)
    --抽水模式
	self.choushuilist=ExternalFun.BtnList(self.BB[7],public.choushuims,function (index) self:onchoushuilist(index) end)
	self.choushuilist:setVisible(false)
	self:addChild(self.choushuilist)
    --最低人数列表    
    self.zdrenshulist=ExternalFun.BtnList(self.BB[8],public.dcow.bgrenshu,function (index) self:onzdrenshu(index) end)
	self.zdrenshulist:setVisible(false)
	self:addChild(self.zdrenshulist)
    --闲家离开
    self.xjlklist=ExternalFun.BtnList(self.BB[9],public.dcow.xjlk,function (index) self:onxjlk(index) end)
    self.xjlklist:setVisible(false)
    self:addChild(self.xjlklist)
    --闲家下注
    self.xjxzlist=ExternalFun.BtnList(self.BB[10],public.dcow.xjxz,function (index) self:onxjxz(index) end)
    self.xjxzlist:setVisible(false)
    self:addChild(self.xjxzlist)
    
    --发牌
    self.fpailist=ExternalFun.BtnList(self.BB[12],public.dcow.fapai,function (index) self:onfapai(index) end)
    self.fpailist:setVisible(false)
    self:addChild(self.fpailist)
    
    local kuang=csbNode:getChildByName("SZGD")
    --界面初始化
    self.SZGD = ExternalFun.cteartTFtwo(kuang:getChildByName("BQ"),kuang,"请输入锅底",true,nil,nil,20)
    kuang=csbNode:getChildByName("CYFS")
    self.CYFS = ExternalFun.cteartTFtwo(kuang:getChildByName("BQ"),kuang,"请输入参与分数",true,nil,nil,20)
    kuang=csbNode:getChildByName("TT")
    self.TTF = ExternalFun.cteartTFtwo(kuang:getChildByName("BQ"),kuang,"请输入淘汰分数",true,nil,nil,20)
    
    --界面初始化
    self:inint()
end

function CreatorDcowLayer:inint()
    self.renshu=public.dcow.renshu[1]
    self.BB[1]:getChildByName("T"):setString(self.renshu.."人")
    self.zjcj=public.dcow.zjcj[1]
    self.BB[3]:getChildByName("T"):setString(self.zjcj.."局")
    self.szgd=public.dcow.szgd[1]
    self.BB[4]:getChildByName("T"):setString(self.szgd.."倍")
    self.szcs=public.dcow.szcs[1]
    self.BB[5]:getChildByName("T"):setString(self.szcs.."次")
    self.huapai=1
    self.BB[6]:getChildByName("T"):setString(public.dcow.hpxz[1])
    self.choushuims=1
    self.BB[7]:getChildByName("T"):setString(public.choushuims[self.choushuims])
    self.zdrenshu=public.dcow.bgrenshu[1]
    self.BB[8]:getChildByName("T"):setString("满"..self.zdrenshu.."开")
    self.xjlk=public.dcow.xjlk[1]
    self.BB[9]:getChildByName("T"):setString(self.xjlk.."局")
    self.xjxz=public.dcow.xjxz[1]
    self.BB[10]:getChildByName("T"):setString(self.xjxz.."%")
    self.fapai=1
    self.BB[12]:getChildByName("T"):setString(public.dcow.fapai[self.fapai])
    self.wfBB[1]:setEnabled(false)  --默认选择经典玩法
    self.selectTeshu=1
    self.teshuguize={}                   --特殊规则
    self.teshuQr={}                     --特殊确认
    self.teshuBB={}
    self:selectText(self.selectTeshu)
    self:selectB(1)                 --选择
    self.BB[11]:getChildByName("T"):setString(public.dcow.teshu[1])
    self.gaoji={true,true,true} --高级选项
    self.upteshuguize={}
    self.zhongtu=1
    self:update()
end
function CreatorDcowLayer:onrenshu(index)
    if self.huapai==0 then
        return
    end
    self.renshu=public.dcow.renshu[index]
    self.BB[1]:getChildByName("T"):setString(self.renshu.."人")
end
function CreatorDcowLayer:onzjcj(index)
    self.zjcj=public.dcow.zjcj[index]
    self.BB[3]:getChildByName("T"):setString(self.zjcj.."局")
end
function CreatorDcowLayer:onzdrenshu(index)
    --print("最低人数"..index)
    self.zdrenshu=public.dcow.bgrenshu[index]
    self.BB[8]:getChildByName("T"):setString("满"..self.zdrenshu.."开")
end
function CreatorDcowLayer:onszgd(index)
    self.szgd=public.dcow.szgd[index]
    self.BB[4]:getChildByName("T"):setString(self.szgd.."倍")
end
function CreatorDcowLayer:onszcs(index)
    self.szcs=public.dcow.szcs[index]
    self.BB[5]:getChildByName("T"):setString(self.szcs.."次")
end
function CreatorDcowLayer:onHuapai(index)
    --print("低分"..index)
    if index == 1 then
        self.huapai=1
    else
         self:onrenshu(1)
         self.huapai=0
    end
    self.BB[6]:getChildByName("T"):setString(public.dcow.hpxz[index])
end
function CreatorDcowLayer:onxjlk(index)
    self.xjlk=public.dcow.xjlk[index]
    self.BB[9]:getChildByName("T"):setString(self.xjlk.."局")
end
function CreatorDcowLayer:onchoushuilist(index)
    print("模式"..index)
    self.choushuims=index
    local str=public.choushuims[index]
    self.BB[7]:getChildByName("T"):setString(str)
end
function CreatorDcowLayer:onxjxz(index)
    --print("推注"..index)
    self.xjxz=public.dcow.xjxz[index]
    self.BB[10]:getChildByName("T"):setString(self.xjxz.."%")
end
function CreatorDcowLayer:onfapai(index)
    --print("发牌"..index)
    self.fapai=index
    self.BB[12]:getChildByName("T"):setString(public.dcow.fapai[index])
end
function CreatorDcowLayer:onButtonClickedEvent(tag,ref)
   --print("界面按下"..tag)
    if tag == 101 then
        self:setBBtext()
        self.P:setVisible(false)
    elseif tag == 100 then
        self.renshulist:setVisible(false)
        self.zjcjlist:setVisible(false)
        self.zdrenshulist:setVisible(false)
        self.szgdlist:setVisible(false)
        self.szcslist:setVisible(false)
        self.Huapailist:setVisible(false)
        self.xjlklist:setVisible(false)
        self.xjxzlist:setVisible(false)
        self.choushuilist:setVisible(false)
        self.fpailist:setVisible(false)
    elseif tag == 1 then
         self.renshulist:setVisible(true)
    elseif tag == 3 then
         self.zjcjlist:setVisible(true)
    elseif tag == 4 then
         self.szgdlist:setVisible(true)
    elseif tag == 5 then
         self.szcslist:setVisible(true)
    elseif tag == 6 then
         self.Huapailist:setVisible(true)
    elseif tag == 7 then
        self.choushuilist:setVisible(true)
    elseif tag == 8 then
         self.zdrenshulist:setVisible(true) 
    elseif tag == 9 then
        self.xjlklist:setVisible(true)
    elseif tag == 10 then
        self.xjxzlist:setVisible(true)
    elseif tag == 11 then
        self.P:setVisible(true)
    elseif tag == 12 then
        self.fpailist:setVisible(true)
    elseif tag == 21 or tag == 22 then
        self:selectB(tag-20)
    elseif tag >30 and tag < 40 then
        self:selectGJ(tag-30)
    elseif tag >40 and tag <50 then
        self:selectText(tag-40)

    end
end
function CreatorDcowLayer:selectText(index)
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
    self.BB[11]:getChildByName("T"):setString(public.cow.teshu[index])
end
function CreatorDcowLayer:selectGJ(index)
    self.gaoji[index] = not self.gaoji[index]

    for k,v in pairs(self.gaoji) do
        self.gjBB[k]:setBright(v)
    end
    
    if index == 2 then          --高级选项 中途可进不可进
        if self.gaoji[index] then
            self.zhongtu=1
        else
            self.zhongtu =0
        end
    end   
end
function CreatorDcowLayer:update()
    --self.P:setVisible(true)
    if #self.teshuguize == 0 then
         
        local data={}
        data.niuniuWf=self.wanfa
        --发送俱乐部列表
        st.send(HallHead.cjcowwf,data)
    end
end
-- function CreatorDcowLayer:upScore()
--     local data={}
--     data.roomType=public.game.cow
-- 	--发送俱乐部列表
-- 	st.send(HallHead.cjctupdate,data)
-- end
-- function CreatorDcowLayer:upzzs()
--     local data={}
--     data.roomType=public.game.cow
--     data.limitUserNum=self.renshu
-- 	--发送俱乐部列表
-- 	st.send(HallHead.cjctupdate,data)
-- end
function CreatorDcowLayer:message(data,code)
   -- dump(data,"data")
    if code == HallHead.cjcowwf then
        local pk=self.P:getChildByName("P"):removeAllChildren()
        if data == nil then
            return
        end
        self.teshuguize=data                   --特殊规则
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
                        it:setString(player.value.."X"..player.bs.."倍")
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
        local str="最低"..data.minCoin.."分"
        self.csbNode:getChildByName("B10"):getChildByName("T"):setString(str)
        self.csbNode:getChildByName("T"):setString(data.zss)
    end  
end
function CreatorDcowLayer:setBBtext()
    local str =""
    if self.selectTeshu == 0 then
        for k,v in pairs(self.teshuQr) do       --选中项目
            if v then
                str=str..self.teshuguize[k].value.." "
            end
        end
        self.BB[11]:getChildByName("T"):setString(str)
    end
end
function CreatorDcowLayer:selectB(index)
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
    self.csbNode:getChildByName("BB"):getChildByName("T"):setString(public.dcow.fanbei[self.wanfa])
end
function CreatorDcowLayer:setTeshu(index,ble)
    if ble == 1 then                --不选
        for k,v in pairs(self.teshuQr) do
           self.teshuQr[k]=false
        end
        for k,v in pairs(self.teshuBB) do
            v:setBright(true)
        end
    elseif ble == 2 then              --全选
        for k,v in pairs(self.teshuQr) do
            self.teshuQr[k]=true
        end
        for k,v in pairs(self.teshuBB) do
            v:setBright(false)
        end
    elseif ble == 0 then
        self.teshuQr[index] = not self.teshuQr[index]
        local xuanze=0
        for k,v in pairs(self.teshuQr) do       --选中项目
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
function CreatorDcowLayer:getTeshu()
    local data ={}
    if self.selectTeshu == 0 then
        for k,v in pairs(self.teshuQr) do       --选中项目
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
function CreatorDcowLayer:updateTeshu()
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
        for k,v in pairs(self.teshuQr) do       --选中项目
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
function CreatorDcowLayer:Update(data)
    self.renshu=data.limitUserNum
    self.BB[1]:getChildByName("T"):setString(self.renshu.."人")
    
    self.zjcj=data.douNiuZjcj
    self.BB[3]:getChildByName("T"):setString(self.zjcj.."局")
    
    self.szgd=data.douNiuSzGdbs
    self.BB[4]:getChildByName("T"):setString(self.szgd.."倍")
    self.huapai=tonumber(data.douNiuHp)
    self.BB[6]:getChildByName("T"):setString(public.dcow.hpxz[self.huapai+1])
    self.szcs=data.douNiuSzCs
    self.BB[5]:getChildByName("T"):setString(self.szcs.."次")
    self.zdrenshu=data.canStartUserNum
    self.BB[8]:getChildByName("T"):setString("满"..self.zdrenshu.."开")
    self.xjlk=data.douNiuXjklk
    self.BB[9]:getChildByName("T"):setString(self.xjlk.."局")
    self.xjxz=data.douNiuXzxz*100
    self.BB[10]:getChildByName("T"):setString(self.xjxz.."%")
    self.fapai=data.douNiuMingan
    self.BB[12]:getChildByName("T"):setString(public.dcow.fapai[self.fapai])
    --特殊规则
    self.upteshuguize=cjson.decode(data.niuniuPx)
    
    self.choushuims=data.choushuiMs
    self.BB[7]:getChildByName("T"):setString(public.choushuims[self.choushuims])
    self.SZGD:setString(data.douNiuGd)
    self.CYFS:setString(data.minCoin)
    self.TTF:setString(data.leaveCoin)
    self:selectB(tonumber(data.niuniuWf))                 --选择
    self.wfBB[tonumber(data.niuniuWf)]:setEnabled(false)  --默认选择经典玩法
    -- self.TTQ:setString(data.qiangzhuangCoin)
    -- self.TTC:setString(data.minCoin)
    -- self.TTF:setString(data.leaveCoin)
    -- local gaoji=string.gsub(data.niuniuGjxx, ",", "")
    -- local k=string.len(gaoji)
    -- for i=1,k do
    --     self:selectGJ(tonumber(string.sub(gaoji,i,i)))
    -- end
end
function CreatorDcowLayer:checking()
    local t1=tonumber(self.SZGD:getString())
    local t2 =tonumber(self.CYFS:getString())
    local t3 =tonumber(self.TTF:getString())
    if t3 ==nil  then
        showToast("请输入淘汰分数",2)
        return
    end
    if t1 ==nil  then
        showToast("请输入锅底",2)
        return
    end
    if t2 ==nil  then
        showToast("请输入参与分数",2)
        return
    end
    if t1<50  then
        showToast("锅底必须大于50",2)
        return
    end
    return  true
end
function CreatorDcowLayer:CreatorRoom()
    local t1=tonumber(self.SZGD:getString())
    local t2 =tonumber(self.CYFS:getString())
    local t3 =tonumber(self.TTF:getString())
    local data={}
        --限制人数
        data.limitUserNum=self.renshu
        --持庄局数
        data.douNiuZjcj=self.zjcj
        --升庄锅底倍数
        data.douNiuSzGdbs=self.szgd
        --升庄次数
        data.douNiuSzCs =self.szcs
        --抽水模式
        data.choushuiMs =self.choushuims
        --最低人数
        data.canStartUserNum=self.zdrenshu
        --闲家离开
        data.douNiuXjklk=self.xjlk
        --闲家下注
        data.douNiuXzxz=self.xjxz/100
        --花牌
        data.douNiuHp=self.huapai
        --发牌
        data.douNiuMingan=self.fapai
        --中途可进不可进
        data.ztjr=self.zhongtu
        --高级（搓牌，中途，GPS）
        for k,v in pairs(self.gaoji) do
            if not v then
                str=str..k..","
            end
        end
        data.niuniuGjxx=str
        --游戏类型
        data.roomType=public.game.dcow
        --锅底
        data.douNiuGd= t1
        --淘汰分数
        data.leaveCoin = t3
        --参与分数
        data.minCoin = t2
        data.niuniuWf=self.wanfa
        data.baseCoin=t1
        -- data.limitUserNum=self.renshu
        -- 
        -- data.niuniuTz=self.tuizhu
        data.niuniuPx=self:getTeshu()
        -- 
        -- data.minCoin = t2
        -- local str=""
        -- data.leaveCoin = t3
        self.scene:SendCreatorRoom(data)
end

return CreatorDcowLayer