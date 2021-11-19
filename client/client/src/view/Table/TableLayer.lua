 local TableLayer = class("TableLayer", function ()
	local TableLayer =  display.newLayer()
	return TableLayer
end)
local table6point={cc.p(30,176),cc.p(34,102),cc.p(132,78),cc.p(244,78), cc.p(340,102),cc.p(342,176)}
local table8point={cc.p(90,210),cc.p(30,176),cc.p(34,102),cc.p(132,78),cc.p(244,78), cc.p(340,102),cc.p(342,176),cc.p(282,210)}
local table10point={cc.p(90,210),cc.p(30,176),cc.p(34,102),cc.p(95,78),cc.p(158,78), cc.p(220,78),cc.p(280,78), cc.p(340,102),cc.p(342,176),cc.p(282,210)}
local table12point={cc.p(54,318),cc.p(54,250),cc.p(64,172),cc.p(126,126),cc.p(196,106), cc.p(266,106),
    cc.p(340,106), cc.p(408,106),cc.p(478,126),cc.p(542,172),cc.p(552,250),cc.p(552,318)}
local tableZpoint={cc.p(180,388),cc.p(240,388), cc.p(300,388),cc.p(360,388), cc.p(420,388)}
local pux=188
local baix=275
function TableLayer:ctor(_scene)
    self:registerScriptHandler(function(state)
        if state == "enter" then
        elseif state == "exit" then
            self:onExit_()
        elseif state == "enterTransitionFinish" then
            self:onEnterTransitionFinish_()
        elseif state == "cleanup" then
            self:onCleanup_()
        end
    end)
	self.scene=_scene
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Club/ClubTable.plist")
	local rootLayer, csbNode = ExternalFun.loadzRootCSB("Club/Layer/TableLayer.csb", self)
	self.Tableview=csbNode:getChildByName("Tableview")
    self.Tableview:setScrollBarEnabled(false)
    self.table_bai=csbNode:getChildByName("table_bai")
    self.table_pu=csbNode:getChildByName("table_pu")
    self.chair=csbNode:getChildByName("chair")
    self.TableList={}
    self.TablePuList={}
    self.TableBaiList={}
    self.ShowTableList={}
    self.chairPlayerList={}
    self.SelectGameType="ALL"
    self.TableTitle=nil
     self.chushi=false
    local function scrollviewEvent(sender,eventType)
       --print("ccccccccccc"..eventType)
        if eventType == 12 then
            self:SendChareHead()
        end
    end
    self.Tableview:addEventListenerScrollView(scrollviewEvent)
end
function TableLayer:onExit_()
    self:GetPerTableview()
end
function TableLayer:onCleanup_()
    self:GetPerTableview()
end
function TableLayer:onEnterTransitionFinish_()
    
    if public.ingametype ~= 0 then
        self.scene:uptableTitle(public.TableTitle)
        if public.TableTitle then
            self:SeletTable(self.SelectGameType,public.TableTitle)
        end
    end
     self.chushi=true
    self:SetPerTableview()
    --获取头像
    self:SendChareHead()    
end

--获取桌子列表的百分比
function TableLayer:GetPerTableview()
    public.tabv1pcen=0
    local pcen = 0
    local lxy= self.Tableview:getInnerContainer()
    local sw1=lxy:getContentSize().width 
    local sw2=self.Tableview:getContentSize().width
    local w = sw1 - sw2
    local x,y=lxy:getPosition()
    if w ~= 0 then
        pcen=(100/w)*x
    end
    pcen=math.abs(pcen)
    if(pcen~=pcen)then
        pcen=100
    end
    public.tabv1pcen =pcen
    ExternalFun.print("获取桌子的百分比"..public.tabv1pcen) 
end
--设置桌子的百分比
function TableLayer:SetPerTableview(mun)
    if mun then
        self.Tableview:jumpToPercentHorizontal(mun); --水平
    else
        self.Tableview:jumpToPercentHorizontal(public.tabv1pcen); --水平
    end
    --改变的时候获取头像
    --self:SendChareHead()
end
--获取最新头像
function TableLayer:SendChareHead()
    local dat={};
    local tl1=self:GetShowTable();
    if #tl1~=0 then 
        local str=""
        for k,v in pairs(tl1) do
            str=str..v..","
        end
        --ExternalFun.print("GetHead="..str)
        str=string.sub(str,0,string.len(str)-1);
        dat.roomCode=str;
        st.send(HallHead.getroominfo,dat);
    end
end
--绘制桌子列表
function TableLayer:DrawTableview()
    for k,v in pairs (self.ShowTableList) do
        if v.tableNode then
            v.tableNode:setPositionY(-1000)
            v.tableNode:setVisible(false)
        end
    end
    self.ShowTableList={}
    if  self.SelectGameType=="ALL" then
        for k,v in pairs (self.TablePuList) do
            if v.zdcj ~= "0" then                 -- ALL 界面不显示母桌
                table.insert(self.ShowTableList,v)
            end
        end
    elseif self.SelectGameType == "BAIREN"  then         --百人绘画
        for k,v in pairs (self.TableBaiList) do
            if self.TableTitle then
                if  self.TableTitle ==v.roomTitle then
                    table.insert(self.ShowTableList,v)
                end
            else
                table.insert(self.ShowTableList,v)
            end
        end
    else
        for k,v in pairs (self.TablePuList) do
            if self.SelectGameType == v.roomType then
                --ExternalFun.dump(v,"22newlist")
                if self.TableTitle  then
                    if  self.TableTitle ==v.roomTitle then
                        table.insert(self.ShowTableList,v)
                    end
                else
                    table.insert(self.ShowTableList,v)
                end
            end
        end
    end
    --ExternalFun.dump(self.ShowTableList,"ShowTableList")
    --开始绘制
    local x = 1
    local y = 1
    local yy = 1
    local pu = 0
    local bai= 0
    local zong=0
    for k,v in pairs(self.ShowTableList) do
        --ExternalFun.dump(v,"ShowTableList")
        if public.isBrGame(v.roomType) == false then
            v.tableNode:setPosition(cc.p(pux*(2*y-1),x==1 and 360 or 120))
            v.tableNode:setVisible(true)
            if x==2 then
                y=y+1
                x=1
                pu=pu+1
            else
                x=x+1
            end
        else
            if x == 2 then
                pu=pu+1
                x=1
            end
            local qishi=0
            if pu ~= 0 then
                qishi=pux*(2*pu)
                --print("初始距离"..qishi)
            end
            v.tableNode:setPosition(cc.p(qishi+baix*(2*yy-1),240))
            v.tableNode:setVisible(true)
            if public.isbaoma ==false then
                if v.roomType ==public.brgame.baoma then
                    v.tableNode:setVisible(false)
                    bai=bai-2
                    yy=yy-2
                end
            end
            bai=bai+1
            yy=yy+1
        end
    end
    if x == 2 then
        pu=pu+1
        x=1
    end
    --记录移动范围
    zong=pux*(2*pu)+baix*(2*bai)
    ----ExternalFun.print("总移动范围"..zong) 
    self.Tableview:setInnerContainerSize(cc.size(zong,480))
    
end
--消息
function TableLayer:message(code,data)
    if code == HallHead.getroominfo then            --更新桌子上的玩家
        --通知服务端已收到消息
        self:UpTableUsers(data)
    elseif code == HallHead.Addtable then           --添加桌子
       self:AddTable(data)
    elseif code == HallHead.sctable then            --删除桌子
       self:DelTable(data)
    elseif code == HallHead.hqtalbe then            --初始化桌子列表
       self:UpTable(data)
    end   
end
function TableLayer:UpTableUsers(data)
    
    local tmplist=data
        for k,v in pairs(tmplist) do
            local chare=false
            for a,b in pairs(self.chairPlayerList) do --记录玩家数据
                if b.roomCode ==v.roomCode then
                    for d,e in pairs(v.userList) do         --玩家列表
                        if e.status == "c" then
                            ---防止重复数据
                            local chuli=false
                                for f,h in pairs(b.userList) do
                                    if e.userCode == h.userCode then
                                        self.chairPlayerList[a].userList[f]=e
                                        chuli=true
                                    end
                                end
                                if chuli == false then
                                    table.insert(self.chairPlayerList[a].userList,e)
                                end
                        elseif e.status == "d" then
                            for f,h in pairs(b.userList) do
                                if e.userCode == h.userCode then
                                    table.remove(self.chairPlayerList[a].userList,d)  --找到该玩家进行删除
                                    break
                                end
                            end
                        end
                    end
                    for d,e in pairs(v.bankerList) do        --庄家列表
                        if e.status == "c" then
                            ---防止重复数据
                            local chuli=false
                            for f,h in pairs(b.bankerList) do
                                if e.userCode == h.userCode then
                                    self.chairPlayerList[a].bankerList[f]=e
                                    chuli=true
                                end
                            end
                            if chuli == false then
                                if self.chairPlayerList[a].bankerList ==nil then
                                    self.chairPlayerList[a].bankerList={}
                                end
                                table.insert(self.chairPlayerList[a].bankerList,e)
                                 
                            end
                        elseif e.status == "d" then
                            for f,h in pairs(b.bankerList) do
                                if e.userCode == h.userCode then
                                    table.remove(self.chairPlayerList[a].bankerList,d)  --找到该玩家进行删除
                                    break
                                end
                            end
                        end
                    end
                    chare=true
                    break
                end
            end
            if chare == false then
                table.insert(self.chairPlayerList,v)
            end
        end
    --绘画玩家
    for k,v in pairs(data) do
        self:DrawTablechair(v)
    end
            
    local str=""
    for k,v in pairs(data) do
        str=str..v.roomCode..","
    end
    str=string.sub(str,0,string.len(str)-1);
    local dat={}
    dat.roomCode=str;
    st.send(HallHead.xiaoxipd,dat);
end
--绘画玩家
function TableLayer:DrawTablechair(users)
   
    local tablenode=nil;local limitUserNum=12;local nont=nil;local rmcd=users.roomCode;
    
    local roomType =nil
    local bairen =false
    for k,v in pairs(self.TableList) do
        if v.roomCode==rmcd then
            tablenode=v.tableNode;
            if v.limitUserNum then
                 limitUserNum=v.limitUserNum;
            end
            roomType=v.roomType
            break
        end
    end
    if public.isBrGame(roomType) == true then
        limitUserNum=12;
        bairen=true
    end
    ExternalFun.dump(users,"玩家信息")
    if(tablenode==nil)then
        return;
    end
    local tablepoint={};

        if limitUserNum == 6 then
            tablepoint=table6point
        elseif limitUserNum == 8 then
            tablepoint=table8point
        elseif limitUserNum == 10 then
            tablepoint=table10point
        elseif limitUserNum == 12 then
            tablepoint=table12point
        else
            limitUserNum=12
            tablepoint=table12point
        end
            for k,v in pairs(users.userList) do
                local index=v.chairIndex+1
                if index <1  or index>limitUserNum then
                    --ExternalFun.print(rmcd.."玩家坐位出错.chairIndex=="..v.chairIndex)
                    break
                else
                    --ExternalFun.print(rmcd.."玩家坐位chairIndex=="..v.chairIndex)
                end
                 --ExternalFun.print("玩家状态"..v.status)
                if v.status == "c" then
                    if tablenode:getChildByTag(120+index) and tablenode:getChildByTag(120+index):getChildByName("head"):getChildByName(v.userCode) then
                        --ExternalFun.print("该玩家已经存在无需再创建")
                    else
                        --ExternalFun.print("该玩家头像变动"..v.userCode)
                        if tablenode:getChildByTag(120+index) then
                            tablenode:getChildByTag(120+index):removeFromParent(true);
                        end
                        local chair=self.chair:clone()
                        if v.userLogo or v.logoUrl then
                            local headbg=chair:getChildByName("head")
                            --设置头像
                            if(v.logoUrl)then
                                --ExternalFun.print(rmcd.."玩家头像=="..v.logoUrl)
                                ExternalFun.createClipHead(headbg,v.userCode,v.logoUrl,67);
                            end
                            if(v.userLogo)then
                                --ExternalFun.print(rmcd.."玩家头像=="..v.userLogo)
                                ExternalFun.createClipHead(headbg,v.userCode,v.userLogo,67);
                            end
                        end
                        if v.userName then
                            chair:getChildByName("T"):setString(v.userName)
                        end
                        if v.nickname then
                            chair:getChildByName("T"):setString(v.nickname)
                        end
                        chair:setPosition(tablepoint[index])
                        tablenode:addChild(chair)
                        chair:setTag(120+index);
                     end    
                 elseif v.status == "d" then
                    if tablenode:getChildByTag(120+index) then
                        tablenode:getChildByTag(120+index):removeFromParent(true);
                    end
                end 
            end
        --end
        if bairen == true then
            for k,v in pairs (self.chairPlayerList) do
                if v.roomCode == users.roomCode then
                    users.bankerList=v.bankerList
                end
            end
            --更新庄家座位
            local one= (#users.bankerList==1) and true or nil
            for i = 1 , 5 do 
                if users.bankerList ==nil or next(users.bankerList) ==nil then
                    if tablenode:getChildByTag(220+i) then
                        tablenode:getChildByTag(220+i):removeFromParent(true);
                    end
                else
                    if users.bankerList[i] == nil then
                        if tablenode:getChildByTag(220+i) then
                            tablenode:getChildByTag(220+i):removeFromParent(true);
                        end
                    else
                        local v=users.bankerList[i]
                        if tablenode:getChildByTag(220+i) and tablenode:getChildByTag(220+i):getChildByName("head"):getChildByName(v.userCode) then
                            --print("该庄家已经存在无需再创建")
                        else
                            --print("该庄家头像变动"..v.userCode)
                            if tablenode:getChildByTag(220+i) then
                                tablenode:getChildByTag(220+i):removeFromParent(true);
                            end
                            local chair=self.chair:clone()
                            if v.userLogo or v.logoUrl then
                                local headbg=chair:getChildByName("head")
                                --设置头像
                                if(v.logoUrl)then
                                    ExternalFun.createClipHead(headbg,v.userCode,v.logoUrl,67);
                                end
                                if(v.userLogo)then
                                    ExternalFun.createClipHead(headbg,v.userCode,v.userLogo,67);
                                end
                            end
                            if v.userName then
                                chair:getChildByName("T"):setString(v.userName)
                            end
                            if v.nickname then
                                chair:getChildByName("T"):setString(v.nickname)
                            end
                            if one then
                                chair:setPosition(tableZpoint[3])
                            else
                                chair:setPosition(tableZpoint[i])
                            end
                            tablenode:addChild(chair)
                            chair:setTag(220+i);
                        end
                    end
                end
            end
        end  
end
--更新桌子
function TableLayer:UpTable(data)
    
    --发过来的列表中去重复
    local temlistnew=data
    for k,v in pairs(self.TableList) do
        for key,val in pairs(temlistnew) do
            if v.roomCode == val.roomCode then
                table.remove(temlistnew,key)
            end
        end
    end
    --添加新的数据
    for key,val in pairs(temlistnew) do
        ----ExternalFun.print("添加新数据"..val.roomCode) 
        table.insert(self.TableList,val)--将key插入到新的table，构成最终的结果
        if public.isBrGame(val.roomType) == true then --不是百人房间创建层
            local tableNode=self:CreTable(val,1)
            val.tableNode=tableNode
            table.insert(self.TableBaiList,val)
        else
             local tableNode=self:CreTable(val,2)
             val.tableNode=tableNode
             table.insert(self.TablePuList,val)
        end    
    end
    --有没有变动
    if #temlistnew ~=0 then
        --self:GetPerTableview()
        self:DrawTableview()
        self.scene:uptableTitle(public.TableTitle)
        self:SeletTable(self.SelectGameType,public.TableTitle)
        self:SetPerTableview()
    end
end
--创建桌子
function TableLayer:CreTable(data,tabletype)                 
    local TableNode=nil

    if tabletype == 1 then
            --百人桌子
        TableNode=self.table_bai:clone()
        self:uptable_bai(TableNode,data)
    else
            --普通桌子
        TableNode=self.table_pu:clone()
        self:uptable_pu(TableNode,data)
    end
    TableNode:setPositionY(-1000)
    TableNode:setVisible(false)
    self.Tableview:addChild(TableNode)
    return TableNode
end
--添加桌子
function TableLayer:AddTable(data)
    if data ==nil then
        --ExternalFun.print("添加桌子无效") 
        return 
    end
    --重复标识
    local chongfu =false
    for k,v in pairs (self.TableList) do
        if v.roomCode ==data.roomCode then
            return              --属于重复桌子.不进行下去了
        end
    end
       
    if public.isBrGame(data.roomType) == true then --不是百人房间创建层
        table.insert(self.TableList,data)
        local tableNode=self:CreTable(data,1)
        data.tableNode=tableNode
        table.insert(self.TableBaiList,data)
        if  self.SelectGameType=="BAIREN" then --self.SelectGameType=="ALL" or 
            table.insert(self.ShowTableList,data)
            self:GetPerTableview()
            self:DrawTableview()
            self:SetPerTableview()
            if self.SelectGameType=="BAIREN" then
                --更新小类别
                self.scene:uptableTitle(self.TableTitle)
            end
        end
    else
        local tableNode=self:CreTable(data,2)
        data.tableNode=tableNode
            --更新所有列表
        local index=1
        for k,v in pairs(self.TableList) do
            if v.zdcj =="0" and public.isBrGame(v.roomType) == false  then
                index=k
                break
            end
        end
        table.insert(self.TableList,index,data)
            --更新普通列表
        index=1
        for k,v in pairs(self.TablePuList) do
            if v.zdcj =="0"  then
                index=k
                break
            end
        end
        table.insert(self.TablePuList,index,data) 
            
        index =1 
        for k,v in pairs(self.ShowTableList) do
            if v.zdcj =="0" and public.isBrGame(v.roomType) == false  then
                index=k
                break
            end
        end
        if ( self.SelectGameType=="ALL" and data.zdcj ~= "0" ) or self.SelectGameType == data.roomType  then
                --更新显示列表
            table.insert(self.ShowTableList,index,data)
            self:GetPerTableview()
            self:DrawTableview()
            self:SetPerTableview()
                --更新小类别
            self.scene:uptableTitle(self.TableTitle)
        end
    end
    
end  
--删除桌子
function TableLayer:DelTable(data)
    local isshanchu=true
    local deltableinfo={}
    for k,v in pairs(self.TableList) do
        if v.roomCode ==data.roomCode then
            deltableinfo=v
            table.remove(self.TableList,k)
            isshanchu=nil
            break
        end
    end
    if isshanchu then
        --ExternalFun.print("删除桌子无效") 
        return
    end
    --删除列表信息
    if public.isBrGame(deltableinfo.roomType) == true then
        for k,v in pairs(self.TableBaiList) do
            if v.roomCode ==deltableinfo.roomCode then
                table.remove(self.TableBaiList,k)
                break
            end
        end
    else
        for k,v in pairs(self.TablePuList) do
            if v.roomCode ==deltableinfo.roomCode then
                table.remove(self.TablePuList,k)
                break
            end
        end
    end
    --ExternalFun.dump(self.ShowTableList,"删除前") 
    local sctable=false
    for k,v in pairs(self.ShowTableList) do
        if v.roomCode ==deltableinfo.roomCode then
            if v.tableNode then
                v.tableNode:removeFromParent()
                v.tableNode=nil
            end
            table.remove(self.ShowTableList,k)
            sctable=true
            break
        end
    end
    --ExternalFun.dump(self.ShowTableList,"删除后") 
    --判断是否是全部如果全部更新桌子
    if sctable == true then
        if self.SelectGameType == "ALL" and data.zdcj ~= "0" then
            --self:DrawTableview()
            self:GetPerTableview()
            self:DrawTableview()
            self:SetPerTableview()
        elseif sctable == true  then
            if self.SelectGameType =="BAIREN" and public.isBrGame(deltableinfo.roomType) == true then --百人的特别
                local haiyou=true
                if self.TableTitle ~= nil then                              --判定分类还有没有
                     for k,v in pairs(self.ShowTableList) do
                        if v.roomTitle ==deltableinfo.roomTitle then
                            haiyou=nil
                            break
                        end
                    end
                end
                
                self:GetPerTableview()
                self:DrawTableview()
                self.scene:uptableTitle(public.TableTitle)
                self:SeletTable(self.SelectGameType,public.TableTitle)
                self:SetPerTableview()
                
            elseif self.SelectGameType ~="BAIREN" and deltableinfo.roomType == self.SelectGameType then
                local haiyou=true
                if self.TableTitle ~= nil then                               --判定分类还有没有
                     for k,v in pairs(self.ShowTableList) do
                        if v.roomTitle ==deltableinfo.roomTitle then
                            haiyou=nil
                            break
                        end
                    end
                end
                
                self:GetPerTableview()
                self:DrawTableview()
                self.scene:uptableTitle(public.TableTitle)
                self:SeletTable(self.SelectGameType,public.TableTitle)
                self:SetPerTableview()
            end
        end
    end
    
   ---清理无用得玩家信息
    for k,v in pairs(self.chairPlayerList) do
        if v.roomCode == data.roomCode then
            table.remove(self.chairPlayerList,k)
        end
    end
    
end
function TableLayer:uptable_pu(tablenode,data) --新版桌子UI,去掉复杂的数据显示.
    local gamekind= tonumber(data.roomType)
    --先判断是否是百人场
    local str =string.format("putong%d_%d.png",data.limitUserNum,gamekind)
    tablenode:getChildByName("table"):loadTexture(str,ccui.TextureResType.plistType)
    local str=public.GameList.gamename[tonumber(data.roomType)]
    tablenode:getChildByName("T"):setString(str)
    local niuniulz=""
    --德州
    if data.roomType == public.game.dezhou then
        
        local str = data.jm.."盲注"--public.dezhouType(data)
        tablenode:getChildByName("T_3"):setString(str)
        str =string.format("底分:%d分",data.baseCoin)
        tablenode:getChildByName("T_8"):setString(str)
        tablenode:getChildByName("B"):setVisible(false)
    --牛牛
    elseif  data.roomType == public.game.cow then
        tablenode:getChildByName("B"):setVisible(false)
        local str = public.cowwf[tonumber(data.niuniuLx)]
        tablenode:getChildByName("T_3"):setString(str)
        str =string.format("底分:%d分",data.baseCoin)
        tablenode:getChildByName("T_8"):setString(str)
    elseif  data.roomType == public.game.dcow then
        tablenode:getChildByName("B"):setVisible(false)
        local str = "上庄"
        tablenode:getChildByName("T_3"):setString(str)
        str =string.format("锅底:%d分",data.baseCoin)
        tablenode:getChildByName("T_8"):setString(str)
    elseif data.roomType == public.game.sangong then
        tablenode:getChildByName("B"):setVisible(false)
        
        local str = "自由抢庄"
        if data.sangongMs == 2 then
            str = "大吃小"
        end
        tablenode:getChildByName("T_3"):setString(str)
        
        str =string.format("底分:%d分",data.baseCoin)
        tablenode:getChildByName("T_8"):setString(str)
    elseif data.roomType == public.game.sangongbi then
        tablenode:getChildByName("B"):setVisible(false)
        
        local str = "自由抢庄"
        
        tablenode:getChildByName("T_3"):setString(str)
        
        str =string.format("底分:%d分",data.baseCoin)
        tablenode:getChildByName("T_8"):setString(str)
    end
    tablenode:getChildByName("T_9"):setString(data.roomTitle) --房间标题
    --------------初始化桌子界面
    local btcallback = function (ref, type)
        if type == ccui.TouchEventType.ended then
            ExternalFun.playClickEffect()
            --ref:setScale(1)
            ExternalFun.playClickEffect()
            if ref:getTag() == 1 then
                local userList={}
                for k,v in pairs(self.chairPlayerList) do
                    if v.roomCode == data.roomCode then
                        userList=v.userList
                    end
                end
                self.scene:entertableinfo(data,userList)
                
            elseif ref:getTag() == 2 then
                QueryExit("确认删除桌子吗？", function (ok)
                if ok == true then
                    local sdata={}
                    sdata.roomCode=data.roomCode
                    sdata.userCode=public.userCode
                    st.send(HallHead.jlbscf,sdata)
                end
                end,true)
                
            end
        end
    end
    local clubinfo=public.getclubinfo(public.enterclubid)
    --隐藏按钮
    if clubinfo.groupRoleCode  == public.culbCode.qunzhu 
            or clubinfo.groupRoleCode  == public.culbCode.fuqunzhu then  --只有群主才可
        tablenode:getChildByName("B"):setVisible(true)
        :setTag(2)
        :addTouchEventListener(btcallback)
    else
                tablenode:getChildByName("B"):setVisible(false)
    end
    
    tablenode:setTag(1)
    tablenode:addTouchEventListener(btcallback)
end
function TableLayer:uptable_bai(tablenode,data)
    
    ----dump(data,"百人桌子")
    tablenode:getChildByName("T_1"):setString(public.brwf.gamename[tonumber(data.roomType)-13])
    local str =public.brwf.moshi[data.brMs]
    tablenode:getChildByName("T_2"):setString(str)
    if data.kzfs then
        tablenode:getChildByName("T_3"):setString("上庄分数:"..data.kzfs)
    end
    local str =string.format("bairen_%d.png",tonumber(data.roomType)-13)
    tablenode:getChildByName("table"):loadTexture(str,ccui.TextureResType.plistType)
	local btcallback = function (ref, type)
		if type == ccui.TouchEventType.ended then
			ExternalFun.playClickEffect()
			--ref:setScale(1)
			ExternalFun.playClickEffect()
			if ref:getTag() == 1 then
				--print("点击桌子")
                local userList={}
                for k,v in pairs(self.chairPlayerList) do
                    if v.roomCode == data.roomCode then
                        userList=v.userList
                    end
                end
                self.scene:entertableinfo(data,userList)
                
            elseif ref:getTag() == 2 then
                QueryExit("确认删除桌子吗？", function (ok)
                if ok == true then
                    local sdata={}
                    sdata.roomCode=data.roomCode
                    sdata.userCode=public.userCode
                    st.send(HallHead.jlbscf,sdata)
                end
                end,true)
                
			end
		elseif type == ccui.TouchEventType.began then
			--ref:setScale(public.btscale)
			return false
        elseif type ==ccui.TouchEventType.moved then
		elseif type == ccui.TouchEventType.canceled then
		end
	end
    local clubinfo=public.getclubinfo(public.enterclubid)
    --隐藏按钮
	if clubinfo.groupRoleCode  == public.culbCode.qunzhu 
            or clubinfo.groupRoleCode  == public.culbCode.fuqunzhu then  --只有群主才可
		tablenode:getChildByName("B"):setVisible(true)
        :setTag(2)
        :addTouchEventListener(btcallback)
    else
         tablenode:getChildByName("B"):setVisible(false)       
	end
    
	tablenode:setTag(1)
  	tablenode:addTouchEventListener(btcallback)
end

--获取显示的桌子
function TableLayer:GetShowTable()
    local str={}    
    for k,v in pairs(self.ShowTableList) do
        if v.tableNode then
            local x,y=v.tableNode:getPosition();
            local xy=v.tableNode:convertToWorldSpace(cc.p(x,y));
            
            local bianyi=440
            if public.isBrGame(v.roomType) == true then
                bianyi=490
            end
            local lxy= self.Tableview:getInnerContainer()
            local xx,yy=lxy:getPosition()
           
            local newpost=xx+xy.x
            --ExternalFun.print(xy.x.."===sy.x===="..xx.."   newpost=="..newpost.." "..v.roomType)
            if(newpost>=-100 and newpost<=2600) and (v.zdcj ~= "0" or public.isBrGame(v.roomType) == true) then
                table.insert(str,v.roomCode)
            end
        end
    end
    if #str == 0 then
    end
    return str
end
 --过滤桌子信息
function TableLayer:SeletTable(SelectGameType,TableTitle)
    local touxiang=false
    
    self.SelectGameType=SelectGameType
   
    self.TableTitle=TableTitle
    
    --记录当前选中标题
    if  self.chushi== true then
        public.TableTitle=TableTitle
    end
    --ExternalFun.print("选择游戏类型"..self.SelectGameType)
    self:DrawTableview()
    self:SetPerTableview(0)

end
--获取桌子的名字
function TableLayer:GetTableTitles()               
        -- do somethings
    local linshititles={}
    if self.SelectGameType == "ALL" then
    elseif self.SelectGameType =="BAIREN" then
        for k,v in pairs(self.TableBaiList) do
            table.insert(linshititles,v)--v.roomTitle
        end
    else
        for k,v in pairs(self.TablePuList) do
            if self.SelectGameType == v.roomType and v.zdcj=="0" then
                table.insert(linshititles,v)--.roomTitle
            end
        end
    end
    local Titles={}
    local len = #linshititles
    local temp={}
    --排序
    if self.SelectGameType =="BAIREN" then
        for  i = 1,len-1 do
            for j = 1,len-i do
                if tonumber(linshititles[j].roomType)>tonumber(linshititles[j+1].roomType) then
                    temp= linshititles[j+1]
                    linshititles[j+1]= linshititles[j]
                    linshititles[j]= temp
                end
            end
        end
    else  
        for  i = 1,len-1 do
            for j = 1,len-i do
                if linshititles[j].baseCoin>linshititles[j+1].baseCoin then
                    temp= linshititles[j+1]
                    linshititles[j+1]= linshititles[j]
                    linshititles[j]= temp
                end
            end
        end
    end
    for k,v in pairs(linshititles) do
         table.insert(Titles,v.roomTitle)--.roomTitle
    end
    return Titles
end
--获取桌子上的玩家数据
function  TableLayer:GetUserList(roomCode)
    local userList={}
    for k,v in pairs(self.chairPlayerList) do
        if v.roomCode == roomCode then
            userList=v.userList
        end
    end
    return userList
end
--获取桌子上的玩家数据
function  TableLayer:GettableUsersList(roomCode)
    local userList={}
    for k,v in pairs(self.chairPlayerList) do
        if v.roomCode == roomCode then
            userList=v
        end
    end
    return userList
end

return TableLayer