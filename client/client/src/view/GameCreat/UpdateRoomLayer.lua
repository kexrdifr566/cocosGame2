local UpdateRoomLayer = class("UpdateRoomLayer", function ()
	local UpdateRoomLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return UpdateRoomLayer
end)
local CreatordzLayer =appdf.req(appdf.VIEW.."GameCreat.CreatordzLayer")
local CreatorcowLayer =appdf.req(appdf.VIEW.."GameCreat.CreatorcowLayer")
local CreatorsgLayer =appdf.req(appdf.VIEW.."GameCreat.CreatorsgLayer")
local CreatorsgbjhLayer =appdf.req(appdf.VIEW.."GameCreat.CreatorsgbjhLayer")
local CreatorDcowLayer =appdf.req(appdf.VIEW.."GameCreat.CreatorDcowLayer")
local CreatbrLayer = appdf.req(appdf.VIEW.."GameCreat.CreatbrLayer")
local AnimationHelper = appdf.req(appdf.EXTERNAL_SRC .. "AnimationHelper")
function UpdateRoomLayer:ctor(_scene,data)
    EventMgr.registerEvent(self,"UpdateRoomLayer")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Club/ClubPage.plist")
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Club/RoomLayer/Room_UpdateLayer.csb", self)
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
	
    self.bj:getChildByName("C")
    :setTag(1)
    :addTouchEventListener(btcallback)
    self.gameLayer=nil
    -- self.setcetGame=1
    -- self.cowkind=1
    -- self.sangongkind=1
    -- self:cxroomzdf(1)
    -- self.t1:setString("5")
    -- self.t2:setString("请输入房间名称")
    self.data =data 
    self:inint()
    AnimationHelper.jumpInEx(self.bj, 1)
end
function UpdateRoomLayer:inint()
    --dump(self.data,"桌子信息")
    
    self.bj:getChildByName("gamename"):setString(self.data.roomTypeValue)
    self.t1:setString(self.data.choushuiRatio)
    self.t2:setString(self.data.roomTitle)
    if tonumber(self.data.roomType) == 3 then   --三公模式
        self.sangongkind=tonumber(self.data.sangongMs)
    elseif tonumber(self.data.roomType) == 2 then  --牛牛模式
        self.cowkind=tonumber(self.data.niuniuLx)
    end
    self.setcetGame=tonumber(self.data.roomType)
    self:cxroomzdf(self.setcetGame)
end
function UpdateRoomLayer:onButtonClickedEvent(tag,ref)
    --print("创建房间界面按下"..tag)
    if tag == 100 then
        EventMgr.removeEvent("UpdateRoomLayer")
        self:removeFromParent()
    elseif tag == 1 then
        self:CreatorRoom()
    end
end
function UpdateRoomLayer:selecgame(index)
    self.setcetGame=index
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
    if  Layer then
        self.gameLayer=Layer
        self.gameLayer:setPosition(200,70)
        self.gameLayer:Update(self.data)
    end

    --self:cxroomzdf(index)
end
function UpdateRoomLayer:cxroomzdf(index)
    local roomType = public.game.dezhou
    if index == tonumber(public.game.cow) then
       roomType=public.game.cow
    elseif index == tonumber(public.game.sangong) then
        roomType=public.game.sangong
    elseif index == tonumber(public.game.sangongbi) then
        roomType=public.game.sangongbi
    elseif index == tonumber(public.game.dcow) then
       roomType=public.game.dcow
    else
        self:selecgame(tonumber(public.game.brgame))
        return
    end
    
    local data={}
    data.roomType=roomType
	--发送俱乐部列表
	st.send(HallHead.roomzdf,data)
end
function UpdateRoomLayer:selecsgkind(index)
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
function UpdateRoomLayer:selecniukind(index)
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
function UpdateRoomLayer:message(code,data)
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
    end
    if code == HallHead.cjctupdate or code ==  HallHead.cjcowwf
           or code ==  HallHead.roomzss  then        --创建层
        if self.gameLayer and self.gameLayer.message then
            self.gameLayer:message(data,code)
        end
    end
end
function UpdateRoomLayer:CreatorRoom()
    --print("修改房间")
    -- if  self.gameLayer and self.gameLayer.CreatorRoom then
    --     self.gameLayer:CreatorRoom()
    -- end
end
function  UpdateRoomLayer:checking()
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
function UpdateRoomLayer:SendCreatorRoom(data)
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
return UpdateRoomLayer