local CreatorRoomLayer = class("CreatorRoomLayer", function ()
	local CreatorRoomLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return CreatorRoomLayer
end)
local CreatordzLayer =appdf.req(appdf.VIEW.."GameCreat.CreatordzLayer")
local CreatorcowLayer =appdf.req(appdf.VIEW.."GameCreat.CreatorcowLayer")
local CreatorsgLayer =appdf.req(appdf.VIEW.."GameCreat.CreatorsgLayer")

function CreatorRoomLayer:ctor(_scene,clubinfo)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Club/Layer/CreatorRoomLayer.csb", self)
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
    --按钮列表
    self.p=self.bj:getChildByName("P")
    self.p:setSwallowTouches(false)
    self.p:setTouchEnabled(false)
    self.B1=self.bj:getChildByName("B1")
    self.B2=self.bj:getChildByName("B2")
    self.wf=self.bj:getChildByName("wf")
    self.wf:setVisible(true)
    self.bj:getChildByName("C"):setVisible(false)
    --:setTag(1)
    --:addTouchEventListener(btcallback)
    
    self.gameLayer=nil
    self.setcetGame=1
    self.cowkind=1
    self.sangongkind=1
    self:selecgame(1)

end
--初始化游戏列表按钮
function CreatorRoomLayer:inintBtnList()
    self.p:removeAllChildren()
    for k,v in pairs(public.GameList.gamename) do
        local item=self.B1:clone()
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
                    self:selecgame(index)
                end
           elseif type == ccui.TouchEventType.began then
               ref:setScale(public.btscale)
               return true
           elseif type == ccui.TouchEventType.canceled then
               ref:setScale(1)
           end
       end
        item:setTitleText(v)
        item:setTag(k)
        item:addTouchEventListener(btcallback)
        self.p:pushBackCustomItem(item)
        if self.setcetGame==2 and k ==2 then
            self.BB={}
            for i,j in pairs(public.cowwf) do
                local itemm=self.B2:clone()
                itemm:setTitleText(j)
                itemm:setTag(10+i)
                itemm:addTouchEventListener(btcallback)
                self.p:pushBackCustomItem(itemm)
                self.BB[i]=itemm
                self.cowkind=1
                if i == self.cowkind then
                    itemm:setEnabled(false)
                    itemm:setColor(cc.c3b(255,255,0))
                else
                    itemm:setTitleColor(cc.c3b(255,255,255))
                    itemm:setColor(cc.c3b(255,255,255))
                end
            end
        elseif self.setcetGame==3 and k ==3 then
            self.BBB={}
            for i,j in pairs(public.sgwf) do
                local itemm=self.B2:clone()
                itemm:setTitleText(j)
                itemm:setTag(20+i)
                itemm:addTouchEventListener(btcallback)
                self.p:pushBackCustomItem(itemm)
                self.BBB[i]=itemm
                self.sangongkind=1
                if i == self.sangongkind then
                    itemm:setEnabled(false)
                    itemm:setColor(cc.c3b(255,255,0))
                else
                    itemm:setTitleColor(cc.c3b(255,255,255))
                    itemm:setColor(cc.c3b(255,255,255))
                end
            end
        else
            self.cowkind=1
            self.sangongkind=1
        end
        if self.setcetGame == k then
            item:setEnabled(false)
        else
            item:setEnabled(true)
        end
    end
end
function CreatorRoomLayer:onButtonClickedEvent(tag,ref)
    --print("创建房间界面按下"..tag)
    if tag == 100 then
        self:removeFromParent()
    elseif tag == 1 then
        --self:CreatorRoom()
    elseif tag >10 and tag<=20 then
        self:selecgame(tag-10)
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
        self.wf:addChild(Layer)
    elseif index == tonumber(public.game.cow) then
        Layer=CreatorcowLayer:create(self)
        self.wf:addChild(Layer)
    elseif index == tonumber(public.game.sangong) then
        Layer=CreatorsgLayer:create(self)
        self.wf:addChild(Layer)
    end
    self.gameLayer=Layer

end
function CreatorRoomLayer:selecsgkind(index)
    self.sangongkind=index
    for k,v in pairs(self.BBB) do
        if self.sangongkind == k then
            v:setEnabled(false)
            v:setTitleColor(cc.c3b(255,255,0))
            v:setColor(cc.c3b(255,255,0))
        else
            v:setEnabled(true)
            v:setTitleColor(cc.c3b(255,255,255))
            v:setColor(cc.c3b(255,255,255))
        end
    end
end
function CreatorRoomLayer:selecniukind(index)
    self.cowkind=index
    for k,v in pairs(self.BB) do
        if self.cowkind == k then
            v:setEnabled(false)
            v:setTitleColor(cc.c3b(255,255,0))
            v:setColor(cc.c3b(255,255,0))
        else
            v:setEnabled(true)
            v:setTitleColor(cc.c3b(255,255,255))
            v:setColor(cc.c3b(255,255,255))
        end
    end
end
return CreatorRoomLayer