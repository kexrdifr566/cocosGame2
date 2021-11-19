local CreatbrLayer = class("CreatbrLayer", function ()
	local CreatbrLayer =  display.newLayer()
	return CreatbrLayer
end)
function CreatbrLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadzRootCSB("Club/RoomLayer/Room_CrbrLayer.csb", self)
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
    for i=1,6 do
        local str=string.format("B%d",i)
        local btn=csbNode:getChildByName(str)
        btn:setTag(i)
        if i ~= 4 and i ~=5  then
            btn:addTouchEventListener(btcallback)
        end
        self.BB[i]=btn
    end
    
    self.B88 =csbNode:getChildByName("B88")
    self.B88:setTag(88)
    self.B88:addTouchEventListener(btcallback)
    
    csbNode:getChildByName("P")
    :setTag(100)
    :addTouchEventListener(btcallback)
    --游戏
	self.gamelist=ExternalFun.BtnList(self.BB[1],public.brwf.gamename,function (index) self:ongamelist(index) end)
	self.gamelist:setVisible(false)
	self:addChild(self.gamelist)
    --模式
	self.moshilist=ExternalFun.BtnList(self.BB[2],public.brwf.moshi,function (index) self:onmoshilist(index) end)
	self.moshilist:setVisible(false)
	self:addChild(self.moshilist)
    
    --模式
	self.kailist=ExternalFun.BtnList(self.BB[3],public.brwf.kzscore,function (index) self:onkailist(index) end)
	self.kailist:setVisible(false)
	self:addChild(self.kailist)
    
    --模式
	self.cmbllist=ExternalFun.BtnList(self.BB[6],public.brwf.cmbl,function (index) self:oncmbllist(index) end)
	self.cmbllist:setVisible(false)
	self:addChild(self.cmbllist)
    
    --模式
	self.choushuilist=ExternalFun.BtnList(self.B88,public.choushuims,function (index) self:onchoushuilist(index) end)
	self.choushuilist:setVisible(false)
	self:addChild(self.choushuilist)
    
    self.zss=csbNode:getChildByName("T")
    self:inint()
end
function CreatbrLayer:inint()
    self.selgame=1
    self.BB[1]:getChildByName("T"):setString(public.brwf.gamename[self.selgame])
    self.moshi=1
    self.BB[2]:getChildByName("T"):setString(public.brwf.moshi[self.moshi])
    self.kzscore=public.brwf.kzscore[1]
    self.BB[3]:getChildByName("T"):setString(self.kzscore.."分")
    self.BB[4]:getChildByName("T"):setString(self.kzscore.."分")
    self.cmbl=1
    self.BB[6]:getChildByName("T"):setString(public.brwf.cmbl[self.cmbl])
    self.choushuims=1
    self.B88:getChildByName("T"):setString(public.choushuims[self.choushuims])
    self:getZss()
end
function CreatbrLayer:ongamelist(index)
    --print("game"..index)
    self.selgame=index
    local str =public.brwf.gamename[index]
    self.BB[1]:getChildByName("T"):setString(str)
    self:getZss()
end
function CreatbrLayer:onmoshilist(index)
    --print("模式"..index)
    self.moshi=index
    local str=public.brwf.moshi[index]
    self.BB[2]:getChildByName("T"):setString(str)
end
function CreatbrLayer:onkailist(index)
    self.kzscore=public.brwf.kzscore[index]
    --print("分数选择"..self.kzscore)
    self.BB[3]:getChildByName("T"):setString(self.kzscore.."分")
    self.BB[4]:getChildByName("T"):setString(self.kzscore.."分")
end
function CreatbrLayer:oncmbllist(index)
    self.cmbl=index
    self.BB[6]:getChildByName("T"):setString(public.brwf.cmbl[index])
end
function CreatbrLayer:onchoushuilist(index)
    --print("模式"..index)
    self.choushuims=index
    local str=public.choushuims[index]
    self.B88:getChildByName("T"):setString(str)
end


function CreatbrLayer:onButtonClickedEvent(tag,ref)
   --print("界面按下"..tag)
    if tag == 100 then
        self.gamelist:setVisible(false)
        self.moshilist:setVisible(false)
        self.kailist:setVisible(false)
        self.choushuilist:setVisible(false)
        self.cmbllist:setVisible(false)
    elseif tag == 1 then
         self.gamelist:setVisible(true)
    elseif tag == 2 then
         self.moshilist:setVisible(true)
    elseif tag == 3 then
         self.kailist:setVisible(true)
    elseif tag == 6 then
         self.cmbllist:setVisible(true)
    elseif tag == 88 then
        self.choushuilist:setVisible(true)
    end
end

function CreatbrLayer:message(data,code)
  --dump(data,"消息层"..code)
    if code ==HallHead.cjctupdate then
        self.zss:setString(data.zss)
    end
end
function CreatbrLayer:checking()
    return  true
end
function CreatbrLayer:CreatorRoom()
    local selectGame=public.brgamecode[self.selgame]   --选择游戏
    local data={}
    data.brMs=self.moshi
    data.kzfs=self.kzscore
    data.roomType = selectGame
    data.choushuiMs =self.choushuims
    data.cmbl=self.cmbl
   --创建房间
    self.scene:SendCreatorRoom(data)
end
--获取钻石数目
function CreatbrLayer:getZss()
    local data={}
    data.roomType=public.brgamecode[self.selgame]
	--发送俱乐部列表
	st.send(HallHead.cjctupdate,data)
end
function CreatbrLayer:Update(data)
    self.selgame=tonumber(data.roomType)-13
    self.BB[1]:getChildByName("T"):setString(public.brwf.gamename[self.selgame])
    self.moshi=data.brMs
    self.BB[2]:getChildByName("T"):setString(public.brwf.moshi[self.moshi])
    self.kzscore=data.kzfs
    self.BB[3]:getChildByName("T"):setString(self.kzscore.."分")
    self.BB[4]:getChildByName("T"):setString(self.kzscore.."分")
    self.cmbl=data.cmbl
    if self.cmbl == nil or self.cmbl == 0 then
        self.cmbl=2
    end
    self.BB[6]:getChildByName("T"):setString(public.brwf.cmbl[self.cmbl])
    self.choushuims=data.choushuiMs
    print("抽水模式"..self.choushuims)
    self.B88:getChildByName("T"):setString(public.choushuims[self.choushuims])
end

return CreatbrLayer