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
    --????????????
    self:SendChareHead()    
end

--??????????????????????????????
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
    ExternalFun.print("????????????????????????"..public.tabv1pcen) 
end
--????????????????????????
function TableLayer:SetPerTableview(mun)
    if mun then
        self.Tableview:jumpToPercentHorizontal(mun); --??????
    else
        self.Tableview:jumpToPercentHorizontal(public.tabv1pcen); --??????
    end
    --???????????????????????????
    --self:SendChareHead()
end
--??????????????????
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
--??????????????????
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
            if v.zdcj ~= "0" then                 -- ALL ?????????????????????
                table.insert(self.ShowTableList,v)
            end
        end
    elseif self.SelectGameType == "BAIREN"  then         --????????????
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
    --????????????
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
                --print("????????????"..qishi)
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
    --??????????????????
    zong=pux*(2*pu)+baix*(2*bai)
    ----ExternalFun.print("???????????????"..zong) 
    self.Tableview:setInnerContainerSize(cc.size(zong,480))
    
end
--??????
function TableLayer:message(code,data)
    if code == HallHead.getroominfo then            --????????????????????????
        --??????????????????????????????
        self:UpTableUsers(data)
    elseif code == HallHead.Addtable then           --????????????
       self:AddTable(data)
    elseif code == HallHead.sctable then            --????????????
       self:DelTable(data)
    elseif code == HallHead.hqtalbe then            --?????????????????????
       self:UpTable(data)
    end   
end
function TableLayer:UpTableUsers(data)
    
    local tmplist=data
        for k,v in pairs(tmplist) do
            local chare=false
            for a,b in pairs(self.chairPlayerList) do --??????????????????
                if b.roomCode ==v.roomCode then
                    for d,e in pairs(v.userList) do         --????????????
                        if e.status == "c" then
                            ---??????????????????
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
                                    table.remove(self.chairPlayerList[a].userList,d)  --???????????????????????????
                                    break
                                end
                            end
                        end
                    end
                    for d,e in pairs(v.bankerList) do        --????????????
                        if e.status == "c" then
                            ---??????????????????
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
                                    table.remove(self.chairPlayerList[a].bankerList,d)  --???????????????????????????
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
    --????????????
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
--????????????
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
    ExternalFun.dump(users,"????????????")
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
                    --ExternalFun.print(rmcd.."??????????????????.chairIndex=="..v.chairIndex)
                    break
                else
                    --ExternalFun.print(rmcd.."????????????chairIndex=="..v.chairIndex)
                end
                 --ExternalFun.print("????????????"..v.status)
                if v.status == "c" then
                    if tablenode:getChildByTag(120+index) and tablenode:getChildByTag(120+index):getChildByName("head"):getChildByName(v.userCode) then
                        --ExternalFun.print("????????????????????????????????????")
                    else
                        --ExternalFun.print("?????????????????????"..v.userCode)
                        if tablenode:getChildByTag(120+index) then
                            tablenode:getChildByTag(120+index):removeFromParent(true);
                        end
                        local chair=self.chair:clone()
                        if v.userLogo or v.logoUrl then
                            local headbg=chair:getChildByName("head")
                            --????????????
                            if(v.logoUrl)then
                                --ExternalFun.print(rmcd.."????????????=="..v.logoUrl)
                                ExternalFun.createClipHead(headbg,v.userCode,v.logoUrl,67);
                            end
                            if(v.userLogo)then
                                --ExternalFun.print(rmcd.."????????????=="..v.userLogo)
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
            --??????????????????
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
                            --print("????????????????????????????????????")
                        else
                            --print("?????????????????????"..v.userCode)
                            if tablenode:getChildByTag(220+i) then
                                tablenode:getChildByTag(220+i):removeFromParent(true);
                            end
                            local chair=self.chair:clone()
                            if v.userLogo or v.logoUrl then
                                local headbg=chair:getChildByName("head")
                                --????????????
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
--????????????
function TableLayer:UpTable(data)
    
    --??????????????????????????????
    local temlistnew=data
    for k,v in pairs(self.TableList) do
        for key,val in pairs(temlistnew) do
            if v.roomCode == val.roomCode then
                table.remove(temlistnew,key)
            end
        end
    end
    --??????????????????
    for key,val in pairs(temlistnew) do
        ----ExternalFun.print("???????????????"..val.roomCode) 
        table.insert(self.TableList,val)--???key???????????????table????????????????????????
        if public.isBrGame(val.roomType) == true then --???????????????????????????
            local tableNode=self:CreTable(val,1)
            val.tableNode=tableNode
            table.insert(self.TableBaiList,val)
        else
             local tableNode=self:CreTable(val,2)
             val.tableNode=tableNode
             table.insert(self.TablePuList,val)
        end    
    end
    --???????????????
    if #temlistnew ~=0 then
        --self:GetPerTableview()
        self:DrawTableview()
        self.scene:uptableTitle(public.TableTitle)
        self:SeletTable(self.SelectGameType,public.TableTitle)
        self:SetPerTableview()
    end
end
--????????????
function TableLayer:CreTable(data,tabletype)                 
    local TableNode=nil

    if tabletype == 1 then
            --????????????
        TableNode=self.table_bai:clone()
        self:uptable_bai(TableNode,data)
    else
            --????????????
        TableNode=self.table_pu:clone()
        self:uptable_pu(TableNode,data)
    end
    TableNode:setPositionY(-1000)
    TableNode:setVisible(false)
    self.Tableview:addChild(TableNode)
    return TableNode
end
--????????????
function TableLayer:AddTable(data)
    if data ==nil then
        --ExternalFun.print("??????????????????") 
        return 
    end
    --????????????
    local chongfu =false
    for k,v in pairs (self.TableList) do
        if v.roomCode ==data.roomCode then
            return              --??????????????????.??????????????????
        end
    end
       
    if public.isBrGame(data.roomType) == true then --???????????????????????????
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
                --???????????????
                self.scene:uptableTitle(self.TableTitle)
            end
        end
    else
        local tableNode=self:CreTable(data,2)
        data.tableNode=tableNode
            --??????????????????
        local index=1
        for k,v in pairs(self.TableList) do
            if v.zdcj =="0" and public.isBrGame(v.roomType) == false  then
                index=k
                break
            end
        end
        table.insert(self.TableList,index,data)
            --??????????????????
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
                --??????????????????
            table.insert(self.ShowTableList,index,data)
            self:GetPerTableview()
            self:DrawTableview()
            self:SetPerTableview()
                --???????????????
            self.scene:uptableTitle(self.TableTitle)
        end
    end
    
end  
--????????????
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
        --ExternalFun.print("??????????????????") 
        return
    end
    --??????????????????
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
    --ExternalFun.dump(self.ShowTableList,"?????????") 
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
    --ExternalFun.dump(self.ShowTableList,"?????????") 
    --?????????????????????????????????????????????
    if sctable == true then
        if self.SelectGameType == "ALL" and data.zdcj ~= "0" then
            --self:DrawTableview()
            self:GetPerTableview()
            self:DrawTableview()
            self:SetPerTableview()
        elseif sctable == true  then
            if self.SelectGameType =="BAIREN" and public.isBrGame(deltableinfo.roomType) == true then --???????????????
                local haiyou=true
                if self.TableTitle ~= nil then                              --????????????????????????
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
                if self.TableTitle ~= nil then                               --????????????????????????
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
    
   ---???????????????????????????
    for k,v in pairs(self.chairPlayerList) do
        if v.roomCode == data.roomCode then
            table.remove(self.chairPlayerList,k)
        end
    end
    
end
function TableLayer:uptable_pu(tablenode,data) --????????????UI,???????????????????????????.
    local gamekind= tonumber(data.roomType)
    --???????????????????????????
    local str =string.format("putong%d_%d.png",data.limitUserNum,gamekind)
    tablenode:getChildByName("table"):loadTexture(str,ccui.TextureResType.plistType)
    local str=public.GameList.gamename[tonumber(data.roomType)]
    tablenode:getChildByName("T"):setString(str)
    local niuniulz=""
    --??????
    if data.roomType == public.game.dezhou then
        
        local str = data.jm.."??????"--public.dezhouType(data)
        tablenode:getChildByName("T_3"):setString(str)
        str =string.format("??????:%d???",data.baseCoin)
        tablenode:getChildByName("T_8"):setString(str)
        tablenode:getChildByName("B"):setVisible(false)
    --??????
    elseif  data.roomType == public.game.cow then
        tablenode:getChildByName("B"):setVisible(false)
        local str = public.cowwf[tonumber(data.niuniuLx)]
        tablenode:getChildByName("T_3"):setString(str)
        str =string.format("??????:%d???",data.baseCoin)
        tablenode:getChildByName("T_8"):setString(str)
    elseif  data.roomType == public.game.dcow then
        tablenode:getChildByName("B"):setVisible(false)
        local str = "??????"
        tablenode:getChildByName("T_3"):setString(str)
        str =string.format("??????:%d???",data.baseCoin)
        tablenode:getChildByName("T_8"):setString(str)
    elseif data.roomType == public.game.sangong then
        tablenode:getChildByName("B"):setVisible(false)
        
        local str = "????????????"
        if data.sangongMs == 2 then
            str = "?????????"
        end
        tablenode:getChildByName("T_3"):setString(str)
        
        str =string.format("??????:%d???",data.baseCoin)
        tablenode:getChildByName("T_8"):setString(str)
    elseif data.roomType == public.game.sangongbi then
        tablenode:getChildByName("B"):setVisible(false)
        
        local str = "????????????"
        
        tablenode:getChildByName("T_3"):setString(str)
        
        str =string.format("??????:%d???",data.baseCoin)
        tablenode:getChildByName("T_8"):setString(str)
    end
    tablenode:getChildByName("T_9"):setString(data.roomTitle) --????????????
    --------------?????????????????????
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
                QueryExit("????????????????????????", function (ok)
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
    --????????????
    if clubinfo.groupRoleCode  == public.culbCode.qunzhu 
            or clubinfo.groupRoleCode  == public.culbCode.fuqunzhu then  --??????????????????
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
    
    ----dump(data,"????????????")
    tablenode:getChildByName("T_1"):setString(public.brwf.gamename[tonumber(data.roomType)-13])
    local str =public.brwf.moshi[data.brMs]
    tablenode:getChildByName("T_2"):setString(str)
    if data.kzfs then
        tablenode:getChildByName("T_3"):setString("????????????:"..data.kzfs)
    end
    local str =string.format("bairen_%d.png",tonumber(data.roomType)-13)
    tablenode:getChildByName("table"):loadTexture(str,ccui.TextureResType.plistType)
	local btcallback = function (ref, type)
		if type == ccui.TouchEventType.ended then
			ExternalFun.playClickEffect()
			--ref:setScale(1)
			ExternalFun.playClickEffect()
			if ref:getTag() == 1 then
				--print("????????????")
                local userList={}
                for k,v in pairs(self.chairPlayerList) do
                    if v.roomCode == data.roomCode then
                        userList=v.userList
                    end
                end
                self.scene:entertableinfo(data,userList)
                
            elseif ref:getTag() == 2 then
                QueryExit("????????????????????????", function (ok)
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
    --????????????
	if clubinfo.groupRoleCode  == public.culbCode.qunzhu 
            or clubinfo.groupRoleCode  == public.culbCode.fuqunzhu then  --??????????????????
		tablenode:getChildByName("B"):setVisible(true)
        :setTag(2)
        :addTouchEventListener(btcallback)
    else
         tablenode:getChildByName("B"):setVisible(false)       
	end
    
	tablenode:setTag(1)
  	tablenode:addTouchEventListener(btcallback)
end

--?????????????????????
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
 --??????????????????
function TableLayer:SeletTable(SelectGameType,TableTitle)
    local touxiang=false
    
    self.SelectGameType=SelectGameType
   
    self.TableTitle=TableTitle
    
    --????????????????????????
    if  self.chushi== true then
        public.TableTitle=TableTitle
    end
    --ExternalFun.print("??????????????????"..self.SelectGameType)
    self:DrawTableview()
    self:SetPerTableview(0)

end
--?????????????????????
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
    --??????
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
--??????????????????????????????
function  TableLayer:GetUserList(roomCode)
    local userList={}
    for k,v in pairs(self.chairPlayerList) do
        if v.roomCode == roomCode then
            userList=v.userList
        end
    end
    return userList
end
--??????????????????????????????
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