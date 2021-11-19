local RecordLayer = class("RecordLayer", function ()
	local RecordLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return RecordLayer
end)
local TAG={HttpHead.getrecord,HttpHead.getshirecord,HttpHead.todayrecord,HttpHead.todaywjrecord,HttpHead.cxrecord
,HttpHead.getTeamUser,HttpHead.getGameGroupByTableID,HttpHead.getGameGroupByParams}
local AnimationHelper = appdf.req(appdf.EXTERNAL_SRC .. "AnimationHelper")
function RecordLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Club/Layer/RecordLayer.csb", self)
	self.bj1=csbNode:getChildByName("bj1")
	self.bj2=csbNode:getChildByName("bj2")
	self.bj3=csbNode:getChildByName("bj3")
    self.bj4=csbNode:getChildByName("bj4")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Game/Cards.plist")
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
	------------------------bj1 ---------------------------------------
    self.bj1:getChildByName("B_C")
	:setTag(100)
	:addTouchEventListener(btcallback)
	self.bj1:getChildByName("B1")
	:setTag(1)
	:addTouchEventListener(btcallback)
	self.bj1:getChildByName("B2")
	:setTag(2)
	:addTouchEventListener(btcallback)
	local TF=self.bj1:getChildByName("TF1")
	self.TF1 = ExternalFun.cteartTF(TF,"输入玩家ID",true,nil)
	self.TF1:addTo(self.bj1)
    
    self.Bp1=self.bj1:getChildByName("Bp1")
    self.yeshu=self.bj1:getChildByName("yeshu")
    self.yeshuz=self.bj1:getChildByName("yeshuz")
    self.Bp2=self.bj1:getChildByName("Bp2")
    self.yeshuzg=self.bj1:getChildByName("yeshuzg")
    self.Bp1:setTag(221)
	:addTouchEventListener(btcallback)
    
    self.Bp2:setTag(223)
	:addTouchEventListener(btcallback)
	-------------------------bj2 ---------------------------------------
	self.bj2:getChildByName("B2")
	:setTag(3)
	:addTouchEventListener(btcallback)

    
    self.bj2:getChildByName("B3")
	:setTag(4)
	:addTouchEventListener(btcallback)
    
    local image=self.bj2:getChildByName("Image")
     --界面初始化
    self.TT = ExternalFun.cteartTFtwo(image:getChildByName("Image"),image,"输入房间号",true,nil,nil,20)
    
    self.bj2:getChildByName("B4")
	:setTag(5)
	:addTouchEventListener(btcallback)
    local str={"房间号","玩家ID"}
        --抢庄
    self.Chalist=ExternalFun.BtnList(self.bj2:getChildByName("B4"),str,function (index) self:OnChalist(index) end)
    self.Chalist:setVisible(false)
    self:addChild(self.Chalist)
    self:OnChalist(1)
    
	self.bj2:getChildByName("B_C")
    :setTag(200)
	:addTouchEventListener(btcallback)
    
    self._Bp1=self.bj2:getChildByName("Bp1")
    self._yeshu=self.bj2:getChildByName("yeshu")
    self._yeshuz=self.bj2:getChildByName("yeshuz")
    self._Bp2=self.bj2:getChildByName("Bp2")
    self._yeshuzg=self.bj2:getChildByName("yeshuzg")
    self._Bp1:setTag(231)
	:addTouchEventListener(btcallback)
    
    self._Bp2:setTag(233)
	:addTouchEventListener(btcallback)
    
    local gamelist = self.bj2:getChildByName("gameList")
    gamelist:setScrollBarEnabled(false)
    self.gameBB={}
    self.gameBB[1]=gamelist:getChildByName("B1")
    self.gameBB[1]:setTag(101)
        :addTouchEventListener(btcallback)
    
    self.gameBB[2]=gamelist:getChildByName("B2")
        self.gameBB[2]:setTag(102)
        :addTouchEventListener(btcallback)
    self.gameBB[3]=gamelist:getChildByName("B3")
        self.gameBB[3]:setTag(103)
        :addTouchEventListener(btcallback)
     self.gameBB[5]=gamelist:getChildByName("B5")
        self.gameBB[5]:setTag(105)
        :addTouchEventListener(btcallback)
    self.gameBB[14]=gamelist:getChildByName("B14")
        self.gameBB[14]:setTag(114)
        :addTouchEventListener(btcallback)
    self.gameBB[15]=gamelist:getChildByName("B15")
        self.gameBB[15]:setTag(115)
        :addTouchEventListener(btcallback)
    self.gameBB[16]=gamelist:getChildByName("B16")
        self.gameBB[16]:setTag(116)
        :addTouchEventListener(btcallback)
    self.gameBB[17]=gamelist:getChildByName("B17")
        self.gameBB[17]:setTag(117)
        :addTouchEventListener(btcallback)
    self.gameBB[7]=gamelist:getChildByName("B7")
        self.gameBB[7]:setTag(107)
        :addTouchEventListener(btcallback)
    self.gameBB[18]=gamelist:getChildByName("B18")
        self.gameBB[18]:setTag(118)
        :addTouchEventListener(btcallback)
    
    self.tb={}
    for i = 1, 3 do
		local str =string.format("B_%d",i)
		self.tb[i]=self.bj2:getChildByName(str)
		self.tb[i]:setTag(i+120)
		:addTouchEventListener(btcallback)
        if i==1 then
            self.tb[i]:setEnabled(false)
        end
	end
    -------------------------bj2 ---------------------------------------
	self.bj3:getChildByName("B_C")
	:setTag(300)
	:addTouchEventListener(btcallback)
    
    self.bj4:getChildByName("B_C")
	:setTag(400)
	:addTouchEventListener(btcallback)
    --初始化UI
    self:ininui()
    
end
function RecordLayer:ininui()
    self.setcetTime=2
    --local clubinfo=public.getclubinfo(public.enterclubid)
    self.zjzj=true--clubinfo.groupRoleCode ==public.culbCode.huiyuan and true or nil
    if self.zjzj then
        self.page=2
        self.bj1:setVisible(false)
        self.bj2:setVisible(true)
        local pk =self.bj2:getChildByName("PK")
        pk:removeAllChildren()
        self.bj3:setVisible(false)
        self.bj4:setVisible(false)
        self.select=3 
    else
        self.page=1
        self.bj1:setVisible(true)
        self.bj2:setVisible(false)
        self.bj3:setVisible(false)
        self.bj4:setVisible(false)
        self.select=1
    end
    self.huiyuan=1
   
    self.selgame=1
	self.fanghao=0 
    self:guanbipage()    
    self:getdata()
    AnimationHelper.jumpInEx(self.bj2, 1)
end
function RecordLayer:OnChalist(index)
    local str={"房间号","玩家ID"}
    self.bj2:getChildByName("B4"):getChildByName("T"):setString(str[index])
    str={"输入房间号","输入玩家ID"}
    self.TT:setString(str[index])
    if index == 1 then
        self.bj2:getChildByName("B3"):setVisible(false)
        self.bj2:getChildByName("B2"):setVisible(true)
    else
        self.bj2:getChildByName("B2"):setVisible(false)
        self.bj2:getChildByName("B3"):setVisible(true)
    end
    self.Chalist:setVisible(false)
end
function RecordLayer:onButtonClickedEvent(tag,ref)
    print("asssss"..tag)
	if tag == 100 then
		if self.select ~=1 or self.huiyuan~=1 then
			self.select=1
            self.huiyuan=1
			self:getdata()
            self.bj1:getChildByName("B1"):setVisible(true)
		else
            cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("Game/Cards.plist")
            cc.Director:getInstance():getTextureCache():removeTextureForKey("Game/Cards.png")
            self:removeFromParent()
		end
	elseif tag == 1 then
        self.select = 2
        self.page=2
        self.bj2:setVisible(true)
        local pk =self.bj2:getChildByName("PK")
        pk:removeAllChildren()
		self:getdata()
    elseif tag == 2 then
        if ExternalFun.checkTFID(self.TF1) then
			self.huiyuan=self.TF1:getText()
			self.select=4
            self.page = 2 
            self.bj2:setVisible(true)
            local pk =self.bj2:getChildByName("PK")
            pk:removeAllChildren()
            self:getdata()
		end
	elseif tag == 3 then
        local chatnum =self.TT:getString()
        if tonumber(chatnum) ==nil  then
            showToast("输入房间号",2)
            return
        end
        if ExternalFun.stringLen(chatnum) ==nil or ExternalFun.stringLen(chatnum) < 4  then
            showToast("输入房间号不正确",1)
            return	
        end
		--if ExternalFun.checkTFIDtwo(self.TT) then
			self.select=7
            self.page = 2 
			self:getdata()
    --end
    elseif tag == 4 then
		if ExternalFun.checkTFIDtwo(self.TT) then
			self.select=8
            self.page = 2 
			self:getdata()
		end
    elseif tag == 5 then
        self.Chalist:setVisible(true)
    elseif  tag >220 and tag <224 then
        self.curtPage=self.curtPage+tag-222
        self:getdata() 
    elseif  tag >230 and tag <234 then
        self._curtPage=self._curtPage+tag-232
        self:getdata()  
	elseif tag == 200 then
        --查询自己战绩需要给页面关闭了
        if self.zjzj then
            self:removeFromParent()
            return
        end
        self.selgame=1
        self.gameBB[1]:setEnabled(false)
        self.gameBB[2]:setEnabled(true)
        self.gameBB[3]:setEnabled(true)
        self.gameBB[4]:setEnabled(true)
        self.gameBB[5]:setEnabled(true)
        self.gameBB[6]:setEnabled(true)
        self.gameBB[7]:setEnabled(true)
        self.gameBB[8]:setEnabled(true)
		self.bj2:setVisible(false)
        self.page=1
    elseif tag > 100 and tag < 120 then
        self:selectB(tag-100)
    elseif tag > 120 and tag < 130 then
        self:selectT(tag-120)
    elseif tag == 300 then
		self.bj3:setVisible(false)
        self.page=2
    elseif tag == 400 then
		self.bj4:setVisible(false)
        self.page=3
    end
end
function RecordLayer:selectT(index)
	if self.tb[index] ==nil then
		return
	end
	for k,v in pairs(self.tb) do
		v:setEnabled(true)
        if k == index then
            v:setEnabled(false)
        end
	end
	self.setcetTime=#self.tb-index
	self:getdata()
end
function RecordLayer:selectB(index)
	if self.gameBB[index] ==nil then
		return
	end
	for k,v in pairs(self.gameBB) do
        if v ~=nil then
            v:setEnabled(true)
            if k == index then
                v:setEnabled(false)
            end
        end
	end
	-- if index == 4 then
 --        self.selgame=15 
 --    elseif index ==5 then
 --        self.selgame = 14
 --    elseif index == 6 then
 --        self.selgame = 16
 --    elseif index == 7 then
 --        self.selgame = 17
 --    elseif index == 8 then
 --         self.selgame = 7
 --    else
 --        self.selgame = index
 --    end
    self.selgame=index
    self.select =3
    local pk =self.bj2:getChildByName("PK")
	pk:removeAllChildren()

    self:getdata()
end
function RecordLayer:guanbipage()
    self.curtPage=1
    self.Bp1:setVisible(false)
    self.yeshu:setVisible(false)
    self.yeshuz:setVisible(false)
    self.Bp2:setVisible(false)
    self.yeshuzg:setVisible(false)
    
    self._curtPage=1
    self._Bp1:setVisible(false)
    self._yeshu:setVisible(false)
    self._yeshuz:setVisible(false)
    self._Bp2:setVisible(false)
    self._yeshuzg:setVisible(false)
end
function RecordLayer:inint(data)
    print("self.select"..self.select)
	if self.select == 1 or self.select == 6 then
		self:inidata(data.result)
        if data.totalPage and data.totalPage >0  then
                self.Bp1:setVisible(true)
                if self.curtPage == 1 then
                    self.Bp1:setEnabled(false)
                else
                    self.Bp1:setEnabled(true)
                end
                self.Bp2:setVisible(true)
                if self.curtPage < data.totalPage then
                    self.Bp2:setEnabled(true)
                else
                    self.Bp2:setEnabled(false)
                end
                self.yeshu:setString(self.curtPage)
                self.yeshu:setVisible(true)
                
                self.yeshuz:setString(data.totalPage.."页")
                self.yeshuz:setVisible(true)
                
                self.yeshuzg:setString("总"..data.total.."条")
                self.yeshuzg:setVisible(true)
            end
	elseif self.select == 3 or self.select == 2 or self.select == 4 or self.select == 7  or self.select == 8 then
        local pk =self.bj2:getChildByName("PK")
        pk:removeAllChildren()
        if data.result == nil then
            return
        end
        if data.result[1] and data.result[1].roomType then
            if data.result[1].roomType == 14 or data.result[1].roomType == 15 then
                self:brinint(data.result)
            elseif data.result[1].roomType == 17 then
                self:brinint2(data.result)
            elseif data.result[1].roomType == 16 then
                self:brinint3(data.result)
            elseif data.result[2].roomType == 18 then
                self:brinint4(data.result)
            else
                self:ininju(data.result)
            end
            if data.totalPage and data.totalPage >0  then
                self._Bp1:setVisible(true)
                if self._curtPage == 1 then
                    self._Bp1:setEnabled(false)
                else
                    self._Bp1:setEnabled(true)
                end
                self._Bp2:setVisible(true)
                if self._curtPage < data.totalPage then
                    self._Bp2:setEnabled(true)
                else
                    self._Bp2:setEnabled(false)
                end
                self._yeshu:setString(self._curtPage)
                self._yeshu:setVisible(true)
                
                self._yeshuz:setString(data.totalPage.."页")
                self._yeshuz:setVisible(true)
                
                self._yeshuzg:setString("总"..data.total.."条")
                self._yeshuzg:setVisible(true)
            end
        end
		
    elseif self.select == 5 then
        self:ininxq(data)
	end
end
function RecordLayer:brinint(data)
	local pk =self.bj2:getChildByName("PK")
	local PP = self.bj2:getChildByName("BR")
	pk:removeAllChildren()
	for k,v in pairs(data) do
		local item=PP:clone()
        item:setVisible(true)
		item:getChildByName("B"):setVisible(false)
        local im = item:getChildByName("im")
		for i=1,10 do
            if v.betCoin[i] and i ~= 1 then
                local str=string.format("T%d",i)
                im:getChildByName(str):setString(v.betCoin[i])
            end
		end
        for i=1,10 do
            if v.loseOrWinCoin[i] then
                local str=string.format("T%d_0",i)
                im:getChildByName(str):setString(v.loseOrWinCoin[i])
                if v.loseOrWinCoin[i] > 0 then
                    im:getChildByName(str):setTextColor(cc.c3b(255,0,0))
                else
                    im:getChildByName(str):setTextColor(cc.c3b(0,174,255))
                end
            end
		end
		item:getChildByName("T1"):setString(v.roomTypeValue)
		item:getChildByName("T2"):setString("房间号:"..v.tableId)--string.sub(v.tableId,1,6))
		item:getChildByName("T3"):setString("局数:"..v.innings)
		item:getChildByName("T4"):setString(v.createTime)
		for a,b in pairs(v.cards) do
            local name=string.format("p%d_%d",v.roomType,a)
            local it=item:getChildByName(name)
            it:getChildByName("T3"):setString(v.cardsDesc[a])
            for e,f in pairs(b) do
                local name=string.format("p%d",e)
                local puke=it:getChildByName(name)
                local str=string.format("card_%d_%d.png",(f.suit+1),f.rank)
                puke:loadTexture(str,ccui.TextureResType.plistType)
            end
            it:setVisible(true)
		end
		pk:pushBackCustomItem(item)
	end
end
function RecordLayer:brinint4(data)
    ExternalFun.dump(data,"宝马记录")
	local pk =self.bj2:getChildByName("PK")
	local PP = self.bj2:getChildByName("BR3")
	pk:removeAllChildren()
	for k,v in pairs(data) do
		local item=PP:clone()
        item:setVisible(true)
		item:getChildByName("B"):setVisible(false)
        local im = item:getChildByName("im")
		for i=1,9 do
            if v.betCoin[i] and i ~= 1 then
                local str=string.format("T%d",i)
                im:getChildByName(str):setString(v.betCoin[i])
            end
		end
        for i=1,9 do
            if v.loseOrWinCoin[i] then
                local str=string.format("T%d_0",i)
                im:getChildByName(str):setString(v.loseOrWinCoin[i])
                if v.loseOrWinCoin[i] > 0 then
                    im:getChildByName(str):setTextColor(cc.c3b(255,0,0))
                else
                    im:getChildByName(str):setTextColor(cc.c3b(0,174,255))
                end
            end
		end
		item:getChildByName("T1"):setString(v.roomTypeValue)
		item:getChildByName("T2"):setString("房间号:"..v.tableId)--string.sub(v.tableId,1,6))
		item:getChildByName("T3"):setString("局数:"..v.innings)
		item:getChildByName("T4"):setString(v.createTime)
        function getCar(index)
            local cars={2,1,8,7,6,5,4,3}
            return cars[index]
        end
        function getCarname(index)
            local cars={"雷克","大众","兰博基尼", "法拉利", "玛莎拉蒂", "保时捷" , "宝马","奔驰"}
            return cars[index]
        end
        --设置头像
        local puke=item:getChildByName("p")
        local str=string.format("Club/record/bm_tb_%d.png",getCar(v.car+1))
        puke:loadTexture(str)
        item:getChildByName("T"):setString(getCarname(v.car+1))
		-- for a,b in pairs(v.cards) do
  --           local name=string.format("p%d_%d",v.roomType,a)
  --           local it=item:getChildByName(name)
  --           it:getChildByName("T3"):setString(v.cardsDesc[a])
  --           for e,f in pairs(b) do
  --               local name=string.format("p%d",e)
  --               local puke=it:getChildByName(name)
  --               local str=string.format("card_%d_%d.png",(f.suit+1),f.rank)
  --               puke:loadTexture(str,ccui.TextureResType.plistType)
  --           end
  --           it:setVisible(true)
		-- end
		pk:pushBackCustomItem(item)
	end
end
function RecordLayer:brinint3(data)
    ExternalFun.dump(data,"神兽记录")
	local pk =self.bj2:getChildByName("PK")
	local PP = self.bj2:getChildByName("BRLH")
	pk:removeAllChildren()
	for k,v in pairs(data) do
		local item=PP:clone()
        item:setVisible(true)
		item:getChildByName("B"):setVisible(false)
        local im = item:getChildByName("im")
		for i=1,5 do
            if v.betCoin[i] and i ~= 1 then
                local str=string.format("T%d",i)
                im:getChildByName(str):setString(v.betCoin[i])
            end
		end
        for i=1,5 do
            if v.loseOrWinCoin[i] then
                local str=string.format("T%d_0",i)
                im:getChildByName(str):setString(v.loseOrWinCoin[i])
                if v.loseOrWinCoin[i] > 0 then
                    im:getChildByName(str):setTextColor(cc.c3b(255,0,0))
                else
                    im:getChildByName(str):setTextColor(cc.c3b(0,174,255))
                end
            end
		end
		item:getChildByName("T1"):setString(v.roomTypeValue)
		item:getChildByName("T2"):setString("房间号:"..v.tableId)--string.sub(v.tableId,1,6))
		item:getChildByName("T3"):setString("局数:"..v.innings)
		item:getChildByName("T4"):setString(v.createTime)
		for a,b in pairs(v.cards) do
            local name=string.format("p%d_%d",v.roomType,a)
            local it=item:getChildByName(name)
            it:getChildByName("T3"):setString(v.cardsDesc[a])
            for e,f in pairs(b) do
                local name=string.format("p%d",e)
                local puke=it:getChildByName(name)
                local str=string.format("card_%d_%d.png",(f.suit+1),f.rank)
                puke:loadTexture(str,ccui.TextureResType.plistType)
            end
            it:setVisible(true)
		end
		pk:pushBackCustomItem(item)
	end
end
function RecordLayer:brinint2(data)
    ExternalFun.dump(data,"神兽记录")
	local pk =self.bj2:getChildByName("PK")
	local PP = self.bj2:getChildByName("BR2")
	pk:removeAllChildren()
	for k,v in pairs(data) do
		local item=PP:clone()
        item:setVisible(true)
		item:getChildByName("B"):setVisible(false)
        local im = item:getChildByName("im")
		for i=1,5 do
            if v.betCoin[i] and i ~= 1 then
                local str=string.format("T%d",i)
                im:getChildByName(str):setString(v.betCoin[i])
            end
		end
        for i=1,5 do
            if v.loseOrWinCoin[i] then
                local str=string.format("T%d_0",i)
                im:getChildByName(str):setString(v.loseOrWinCoin[i])
                if v.loseOrWinCoin[i] > 0 then
                    im:getChildByName(str):setTextColor(cc.c3b(255,0,0))
                else
                    im:getChildByName(str):setTextColor(cc.c3b(0,174,255))
                end
            end
		end
		item:getChildByName("T1"):setString(v.roomTypeValue)
		item:getChildByName("T2"):setString("房间号:"..v.tableId)--string.sub(v.tableId,1,6))
		item:getChildByName("T3"):setString("局数:"..v.innings)
		item:getChildByName("T4"):setString(v.createTime)
		for a,b in pairs(v.cards) do
            local name=string.format("p%d_%d",v.roomType,a)
            local it=item:getChildByName(name)
            it:getChildByName("T3"):setString(v.cardsDesc[a])
            for e,f in pairs(b) do
                local name=string.format("p%d",e)
                local puke=it:getChildByName(name)
                local str=string.format("card_%d_%d.png",(f.suit+1),f.rank)
                puke:loadTexture(str,ccui.TextureResType.plistType)
            end
            it:setVisible(true)
		end
		pk:pushBackCustomItem(item)
	end
end
--------------------------------显示局数-------------------------------
function RecordLayer:ininju(data)
	local pk =self.bj2:getChildByName("PK")
	local PP = self.bj2:getChildByName("PJ")
	pk:removeAllChildren()
	for k,v in pairs(data) do
		local item=PP:clone()
        item:setVisible(true)
		local btcallback = function (ref, type)
			if type == ccui.TouchEventType.ended then
				ExternalFun.playClickEffect()
				ref:setScale(1)
				if ref:getTag() == 1 then
				else
                    self.page =3
					self:inbj3(v)
					self.bj3:setVisible(true)
				end
			elseif type == ccui.TouchEventType.began then
				ref:setScale(public.btscale)
				return true
			elseif type == ccui.TouchEventType.canceled then
				ref:setScale(1)
			end
		end
		item:getChildByName("B1")
		:setTag(1)
		:addTouchEventListener(btcallback)
		item:getChildByName("B2")
		:setTag(2)
		:addTouchEventListener(btcallback)

		for i=1,10 do
			local str=string.format("R%d",i)
			item:getChildByName(str)
			:setVisible(false)
		end
		item:getChildByName("T1"):setString(v.roomTypeValue)
		item:getChildByName("T2"):setString("房间号:"..v.tableId)--string.sub(v.tableId,1,6))
		item:getChildByName("T3"):setString("局数:"..v.innings)
		item:getChildByName("T4"):setString(v.createTime)
		for a,b in pairs(v.users) do
			local str=string.format("R%d",a)
			local player =item:getChildByName(str)
			player:setVisible(true)
			player:getChildByName("T1"):setString(b.userName)
			player:getChildByName("T2"):setString("ID:"..ExternalFun.showUserCode(b.userCode))
			player:getChildByName("T3"):setString("")
            local headbg=player:getChildByName("head")
            --设置头像
            ExternalFun.createClipHead(headbg,b.userCode,b.logoUrl,67)
            --dump(b,a)
			if b.coin >=0 then
				player:getChildByName("T4"):setTextColor(cc.RED)
				
			else
				player:getChildByName("T4"):setTextColor(cc.GREEN)
			end
            
			player:getChildByName("T4"):setString(b.coin)
            
		end
		pk:pushBackCustomItem(item)
	end
end
--------------------------------显示局数-------------------------------
function RecordLayer:ininxq(data)
    --dump(data,"记录")
	local pk =self.bj4:getChildByName("PK")
	local PP = self.bj4:getChildByName("P")
	pk:removeAllChildren()
    local counts=math.ceil(#data/4)
    if counts > 0 then
        self.bj4:getChildByName("T3"):setVisible(false)
        self.bj4:getChildByName("T1"):setString("房号:"..data[1].tableId)
        self.bj4:getChildByName("T2"):setString("局数:"..data[1].innings)
        self.bj4:getChildByName("T4"):setString(data[1].roomTypeValue)
        if data[1].roomType == 3 or data[1].roomType == 7 then
            PP = self.bj4:getChildByName("P3")
        end
    end
    for i=1,counts do
        local item =PP:clone()
        item:setVisible(true)
        for j =1,4 do
            local name=string.format("i%d",j)
			local it=item:getChildByName(name)
			local player= data[(i-1)*4+j]
			if player ~= nil then
                --dump(player,"玩家信息")
				it:getChildByName("T1"):setString(player.userName)
				it:getChildByName("T2"):setString(player.coin)
                it:getChildByName("T3"):setString(player.pokerStr)
                if player.coin >=0 then
                    it:getChildByName("T2"):setTextColor(cc.RED)
				
                else
                    it:getChildByName("T2"):setTextColor(cc.GREEN)
                end
                for k,v in pairs(player.pokerArrC) do
                    local name=string.format("p%d",k)
                    local puke=it:getChildByName(name)
                    local str=string.format("card_%d_%d.png",(v.suit+1),v.rank)
                    puke:loadTexture(str,ccui.TextureResType.plistType)
                    if  player.laizi and  player.laizi.rank and player.laizi.rank==v.rank then
                        local sp = display.newSprite("Club/card/xlaizi.png")
                        -- sp:setScale(0.5)
                        sp:move(44,45)
                        sp:addTo(puke)
                    end
                end
                if player.banker and player.banker == 1 then
                    it:getChildByName("z"):setVisible(true)
                else
                    it:getChildByName("z"):setVisible(false)
                end
                if player.qiangZhuangBs  then
                    local qz=it:getChildByName("qz")
                    local str=string.format("Club/card/qx%d.png",player.qiangZhuangBs)
                    qz:loadTexture(str)
                    qz:setVisible(true)
                else
                    local qz=it:getChildByName("qz")
                    qz:setVisible(false)
                end
			else
				it:setVisible(false)
			end
        end
        pk:pushBackCustomItem(item)
    end
    
    self.bj4:setVisible(true)
end
function RecordLayer:inbj3(data)
	--dump(data,"记录情况")
	local pk =self.bj3:getChildByName("PK")
	local PP = self.bj3:getChildByName("P")
	pk:removeAllChildren()

	self.bj3:getChildByName("T1"):setString("房号:"..data.tableId)--string.sub(data.tableId,1,6))
	self.bj3:getChildByName("T2"):setVisible(false)
	self.bj3:getChildByName("T3"):setVisible(false)
	local counts=math.ceil(data.innings/4)
	for i=1,counts do
		local item=PP:clone()
        item:setVisible(true)
		for j =1,4 do
			local name=string.format("B%d",j)
			local it=item:getChildByName(name)
			local index = (i-1)*4+j
			local btcallback = function (ref, type)
				if type == ccui.TouchEventType.ended then
					ExternalFun.playClickEffect()
					ref:setScale(1)
					if ref:getTag() == 1 then
						self.select=5
                        self.page = 4
						self:getdata(data.tableId,index)
					end
				elseif type == ccui.TouchEventType.began then
					ref:setScale(public.btscale)
					return true
				elseif type == ccui.TouchEventType.canceled then
					ref:setScale(1)
				end
			end
			if index <= data.innings then
				it:getChildByName("T2"):setString(index)
				it:setVisible(true)
			else
				it:setVisible(false)
			end
			it:setTag(1)
			:addTouchEventListener(btcallback)
		end
		pk:pushBackCustomItem(item)
	end
end
--------------显示群-----------------------------------
function RecordLayer:inidata(data)
	local pk =self.bj1:getChildByName("PK")
	local PP = self.bj1:getChildByName("P")
	pk:removeAllChildren()
	for k,v in pairs(data) do
		local item=PP:clone()
        item:setVisible(true)
		local btcallback = function (ref, type)
			if type == ccui.TouchEventType.ended then
				ExternalFun.playClickEffect()
				ref:setScale(1)
				if ref:getTag() == 1 then
					self.huiyuan=v.userCode
                    self.select = 6
					self:getdata()
				else
					self.huiyuan=v.userCode
					self.select =3
                    self.page =2
                    local pk =self.bj2:getChildByName("PK")
                    pk:removeAllChildren()
                    self.bj2:setVisible(true)
					self:getdata()
				end
			elseif type == ccui.TouchEventType.began then
				ref:setScale(public.btscale)
				return true
			elseif type == ccui.TouchEventType.canceled then
				ref:setScale(1)
			end
		end
		item:getChildByName("B1")
		:setTag(1)
		:addTouchEventListener(btcallback)
		item:getChildByName("B2")
		:setTag(2)
		:addTouchEventListener(btcallback)
		item:getChildByName("T1"):setString(v.userName)
		item:getChildByName("T2"):setString("ID:"..ExternalFun.showUserCode(v.userCode))
		item:getChildByName("T3"):setString("总局数:"..v.innings)
        local headbg=item:getChildByName("head")
        --设置头像
        ExternalFun.createClipHead(headbg,v.userCode,v.logoUrl,67)
		if self.huiyuan == 1 then
			item:getChildByName("B1"):setVisible(true)
			item:getChildByName("B2"):setVisible(false)
		else
			item:getChildByName("B2"):setVisible(true)
			item:getChildByName("B1"):setVisible(false)
		end
		pk:pushBackCustomItem(item)
	end
end
function RecordLayer:getdata(roomID,innings)
	function Senddata(datas)
        --dump(datas,"获取数据")
        if self and self.inint then
            self:inint(datas)
        end
	end
	local clubinfo = public.getclubinfo(public.enterclubid)
	local data={}
	if roomID or innings then
		data.tableid = roomID
		data.innings=innings
	else
		data.groupCode=clubinfo.groupCode
		if self.huiyuan == 1 then
			data.userCode = public.userCode
		else
			data.userCode = self.huiyuan
		end
	end
    if self.select == 2 or self.select == 3 or self.select == 7 or self.select == 8 then
        data.roomType=self.selgame
    end
    if self.select == 7 then
        data.tableID=self.TT:getString()
    end
    
    if self.select == 8 then
        data.userCode=self.TT:getString()
    end
    local url =TAG[self.select]
    if self.bj2:isVisible() then
        data.curtPage =self._curtPage
    else
        data.curtPage =self.curtPage
    end
    if self.select == 3 or self.select == 8 then
        data.dateType=self.setcetTime-2
    end
	--发送
	httpnect.send(url,data,Senddata)
end

return RecordLayer

