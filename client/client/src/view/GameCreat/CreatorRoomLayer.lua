local CreatorRoomLayer = class("CreatorRoomLayer", function ()
	local CreatorRoomLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return CreatorRoomLayer
end)
local CreatordzLayer =appdf.req(appdf.VIEW.."GameCreat.CreatordzLayer")
local CreatorcowLayer =appdf.req(appdf.VIEW.."GameCreat.CreatorcowLayer")
local CreatorsgLayer =appdf.req(appdf.VIEW.."GameCreat.CreatorsgLayer")
local CreatorsgbjhLayer =appdf.req(appdf.VIEW.."GameCreat.CreatorsgbjhLayer")
local CreatorDcowLayer =appdf.req(appdf.VIEW.."GameCreat.CreatorDcowLayer")
local CreatbrLayer = appdf.req(appdf.VIEW.."GameCreat.CreatbrLayer")
local AnimationHelper = appdf.req(appdf.EXTERNAL_SRC .. "AnimationHelper")
function CreatorRoomLayer:ctor(_scene,clubinfo)
    EventMgr.registerEvent(self,"CreatorRoomLayer")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Club/ClubPage.plist")
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Club/RoomLayer/Room_CreatorLayer.csb", self)
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
    local t1=self.bj:getChildByName("Image1")
    self.t1 = ExternalFun.cteartTFtwo(t1:getChildByName("Image"),t1,"5",true,nil,nil,28)
    
    local t2=self.bj:getChildByName("Image2")
     self.t2 = ExternalFun.cteartTFtwo(t2:getChildByName("Image"),t2,"请输入房间名称",nil,nil,nil,28)
	
    
    --按钮列表
    self.p=self.bj:getChildByName("P")
    self.p:setSwallowTouches(false)
    self.p:setTouchEnabled(false)
    self.p:setScrollBarEnabled(false)
    self.B1=self.bj:getChildByName("B1")
    self.B2=self.bj:getChildByName("B2")
    self.bj:getChildByName("C")
    :setTag(1)
    :addTouchEventListener(btcallback)
    self.gameLayer=nil
    self.setcetGame=1
    self.cowkind=1
    self.sangongkind=1
    self:cxroomzdf(1)
    self.t1:setString("5")
    self.t2:setString("请输入房间名称")
    AnimationHelper.jumpInEx(self.bj, 1)
end
--初始化游戏列表按钮
function CreatorRoomLayer:inintBtnList()
    self.p:removeAllChildren()
    for k,v in pairs(public.GameList.gamename) do
        if k ~= 6 then 
            
        local item=self.B1:clone()
        item:setVisible(true)
        --local str =string.format("入场最低%d分",data.minCoin)
        item:getChildByName("Text"):setString(v)
        local btcallback = function (ref, type)
            if type == ccui.TouchEventType.ended then
                ExternalFun.playClickEffect()
                ref:setScale(1)
                local index=ref:getTag()
                if index >10 and index < 20 then
                    self:selecniukind(index-10)
                elseif index >20 then
                    self:selecsgkind(index-20)
                else
                    self:cxroomzdf(index)
                end
           elseif type == ccui.TouchEventType.began then
               ref:setScale(public.btscale)
               return true
           elseif type == ccui.TouchEventType.canceled then
               ref:setScale(1)
           end
       end
        --item:setTitleText(v)
        item:setTag(k)
        item:addTouchEventListener(btcallback)
        self.p:pushBackCustomItem(item)
        if self.setcetGame==2 and k ==2 then
            self.BB={}
            for i,j in pairs(public.cowwf) do
                local itemm=self.B2:clone()
                itemm:setVisible(true)
                itemm:loadTextureNormal("qiangzhuang.png",ccui.TextureResType.plistType)
                itemm:loadTexturePressed("qiangzhuang1.png",ccui.TextureResType.plistType)
                itemm:loadTextureDisabled("qiangzhuang1.png",ccui.TextureResType.plistType)
                itemm:setTag(10+i)
                itemm:addTouchEventListener(btcallback)
                self.p:pushBackCustomItem(itemm)
                self.BB[i]=itemm
                self.cowkind=1
                if i == self.cowkind then
                    itemm:setEnabled(false)
                    --itemm:setColor(cc.c3b(255,255,0))
                else
                   -- itemm:setTitleColor(cc.c3b(255,255,255))
                    --itemm:setColor(cc.c3b(255,255,255))
                end
            end
        elseif self.setcetGame==3 and k ==3 then
            self.BBB={}
            for i,j in pairs(public.sgwf) do
                local itemm=self.B2:clone()
                itemm:setVisible(true)
                if i ==  1 then
                itemm:loadTextureNormal("qiangzhuang.png",ccui.TextureResType.plistType)
                itemm:loadTexturePressed("qiangzhuang1.png",ccui.TextureResType.plistType)
                itemm:loadTextureDisabled("qiangzhuang1.png",ccui.TextureResType.plistType)
                else
                    itemm:loadTextureNormal("dxtongchi1.png",ccui.TextureResType.plistType)
                    itemm:loadTexturePressed("dxtongchi.png",ccui.TextureResType.plistType)
                    itemm:loadTextureDisabled("dxtongchi.png",ccui.TextureResType.plistType)
                end
                --itemm:setTitleText(j)
                itemm:setTag(20+i)
                itemm:addTouchEventListener(btcallback)
                self.p:pushBackCustomItem(itemm)
                self.BBB[i]=itemm
                self.sangongkind=1
                if i == self.sangongkind then
                    itemm:setEnabled(false)
                    --itemm:setColor(cc.c3b(255,255,0))
                else
                    --itemm:setTitleColor(cc.c3b(255,255,255))
                    --itemm:setColor(cc.c3b(255,255,255))
                end
            end
        else
            self.cowkind=1
            self.sangongkind=1
        end
        if self.setcetGame == k then
            item:setEnabled(false)
            item:getChildByName("Text"):setColor(cc.c3b(255,255,255))
            
        else
            item:setEnabled(true)
            item:getChildByName("Text"):setColor(cc.c3b(114,69,21))
        end
        end
    end
end
function CreatorRoomLayer:onButtonClickedEvent(tag,ref)
    --print("创建房间界面按下"..tag)
    if tag == 100 then
        EventMgr.removeEvent("CreatorRoomLayer")
        self:removeFromParent()
    elseif tag == 1 then
        self:CreatorRoom()
    elseif tag >10 and tag<=20 then
        self:cxroomzdf(tag-10)
    end
end
function CreatorRoomLayer:selecgame(index)
    self.setcetGame=index
    self:inintBtnList(index)
    if self.gameLayer then
        self.gameLayer:removeFromParent()
    end
    local Layer=nil
    if index == tonumber(public.game.dezhou) then
        Layer=CreatordzLayer:create(self)
        self.bj:addChild(Layer)
    elseif index == tonumber(public.game.cow) then
        Layer=CreatorcowLayer:create(self)
        self.bj:addChild(Layer)
    elseif index == tonumber(public.game.sangong) then
        Layer=CreatorsgLayer:create(self)
        self.bj:addChild(Layer)
    elseif index == tonumber(public.game.sangongbi) then
        Layer=CreatorsgbjhLayer:create(self)
        self.bj:addChild(Layer)
    elseif index == tonumber(public.game.dcow) then
        Layer=CreatorDcowLayer:create(self)
        self.bj:addChild(Layer)
    else
        Layer=CreatbrLayer:create(self)
        self.bj:addChild(Layer)
    end
    self.gameLayer=Layer
    self.gameLayer:setPosition(304,92)
   self.t1:setString("5")
    self.t2:setString("请输入房间名称")
    --self:cxroomzdf(index)
end
function CreatorRoomLayer:cxroomzdf(index)
    local roomType = public.game.dezhou
    if index == tonumber(public.game.cow) then
       roomType=public.game.cow
    elseif index == tonumber(public.game.sangong) then
        roomType=public.game.sangong
    elseif index == tonumber(public.game.sangongbi) then
        roomType=public.game.sangongbi
    elseif index == tonumber(public.game.dcow) then
        roomType=public.game.dcow
    elseif index == tonumber(public.game.brgame) then
        self:selecgame(tonumber(public.game.brgame))
        return
    end
    
    local data={}
    data.roomType=roomType
	--发送俱乐部列表
	st.send(HallHead.roomzdf,data)
end
function CreatorRoomLayer:selecsgkind(index)
    self.sangongkind=index
    for k,v in pairs(self.BBB) do
        if self.sangongkind == k then
            v:setEnabled(false)
        else
            v:setEnabled(true)
        end
    end
    if self.gameLayer.qiangzhuang then
        self.gameLayer:qiangzhuang()
    end
end
function CreatorRoomLayer:selecniukind(index)
    self.cowkind=index
    for k,v in pairs(self.BB) do
        if self.cowkind == k then
            v:setEnabled(false)
        else
            v:setEnabled(true)
        end
    end
    if self.gameLayer.qiangzhuang then
        self.gameLayer:qiangzhuang()
    end
end
function CreatorRoomLayer:message(code,data)
    if code == HallHead.roomzdf then
        --dump(data,"房间最低分")
        if data.roomType == public.game.cow then
            public.cow.difen=data.df
            public.cow.zuidi=data.zdfs
        elseif data.roomType == public.game.sangong then
            public.sangong.difen=data.df
            public.sangong.zgxiazhu={}
            for k,v in pairs(data.df) do
                public.sangong.zgxiazhu[k]=v*10
            end
            public.sangong.zuidi=data.zdfs 
        elseif data.roomType == public.game.sangongbi then
            public.sangongbi.difen=data.df
            public.sangongbi.zgxiazhu={}
            for k,v in pairs(data.df) do
                public.sangongbi.zgxiazhu[k]=v*10
            end
            public.sangongbi.zuidi=data.zdfs  
        end 
        self:selecgame(tonumber(data.roomType))
    elseif code == HallHead.cjroom then
		showToast("创建房间成功!",1)
    end
    if code == HallHead.cjctupdate or code ==  HallHead.cjcowwf 
           or code ==  HallHead.roomzss then        --创建层
        if self.gameLayer and self.gameLayer.message then
            self.gameLayer:message(data,code)
        end
    end
end
function CreatorRoomLayer:CreatorRoom()
    if  self.gameLayer and self.gameLayer.CreatorRoom then
        if self.gameLayer:checking() then
            self.gameLayer:CreatorRoom()
        end
    end
    self.bj:getChildByName("C"):setEnabled(false)
    performWithDelay(self,function ()
        if self then
            self.bj:getChildByName("C"):setEnabled(true)
        end
    end,3)
      
end
function  CreatorRoomLayer:checking()
    local it1 = tonumber(self.t1:getString())
	local it2 =string.gsub(self.t2:getString()," ","")
    if  it1 ==nil   then
		showToast("请输入抽水比例",1)
		return
	end
	if  it2 ==nil  then
		showToast("请输入房间名称",1)
		return
	end

	if  it1 >= 100 or it1 < 0 then
		showToast("抽水比例设置错误",1)
		return
	end
	if string.len(it2) < 4 or string.len(it2)> 24 then
		showToast("房间名称不能少于6位或多于12位",2)
		return
	end
    return true
end
function CreatorRoomLayer:SendCreatorRoom(data)
    if self:checking() then
        if next(data) ~=nil then 
            local clubinfo=public.getclubinfo(public.enterclubid)
            local sddata=data
            sddata.groupCode=clubinfo.groupCode
            sddata.roomTitle=self.t2:getString()
            sddata.choushuiRatio=self.t1:getString()
            st.send(HallHead.cjroom,sddata)
        end
    end
end
return CreatorRoomLayer