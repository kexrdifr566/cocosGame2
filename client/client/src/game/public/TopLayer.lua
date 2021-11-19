local TopLayer = class("TopLayer", function ()
	local TopLayer =  display.newLayer()
	return TopLayer
end)
local SettingLayer=appdf.req(appdf.GAME_SRC.."public.SettingLayer")
local WanfaLayer=appdf.req(appdf.GAME_SRC.."public.WanfaLayer")
function TopLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadzRootCSB("Game/publicLayer/topLayer.csb", self)
	self.bj=csbNode:getChildByName("bj")
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
    self.bj:getChildByName("B_1")
    :setTag(1)
    :addTouchEventListener(btcallback)
    self.bj:getChildByName("B_2")
    :setTag(2)
    :addTouchEventListener(btcallback)
    self.image=self.bj:getChildByName("Image")
    self.image:setVisible(false)
    self.image:getChildByName("B_3")
    :setTag(100)
    :addTouchEventListener(btcallback)
    self.image:getChildByName("B_4")
    :setTag(3)
    :addTouchEventListener(btcallback)
    self.image:getChildByName("B_7")
    :setTag(7)
    :addTouchEventListener(btcallback)
    self.bj:getChildByName("B_5")
    :setTag(4)
    :addTouchEventListener(btcallback)
    
    self.bj:getChildByName("B_6")
    :setTag(6)
    :addTouchEventListener(btcallback)
    
    self.bj:getChildByName("T1"):setString("")
end
function TopLayer:updateT(jushu)
    local tableinfo=public.gettableinfo(public.roomCode)
    self.bj:getChildByName("T2"):setString(jushu)
    if  tableinfo.roomType ~= "5" then --斗公牛 不显示
        self.bj:getChildByName("T3"):setString("/"..tableinfo.innings)
    end
    local str = ""
    if tableinfo.roomType == "1" then
        str = "德州扑克 "
        str = str..public.dezhouType(tableinfo)
    elseif  tableinfo.roomType == "2" then
        str = "牛牛 "
    elseif  tableinfo.roomType == "3" then
        str = "三公 "
    elseif  tableinfo.roomType == "5" then
        str = "斗公牛 "
        --self.bj:getChildByName("T2"):setString(jushu)
        self.bj:getChildByName("T3"):setVisible(false)
    end
    self.bj:getChildByName("T4"):setString(str)
    -- dump(tableinfo,"tableinfo")
end
function TopLayer:uptableid(tableId)
    self.bj:getChildByName("T1"):setString(tableId)
end
--更新局数
function TopLayer:updcowjushu(jushu)
    if jushu then
        self.bj:getChildByName("T2"):setString(jushu)
        --self.bj:getChildByName("T3"):setVisible(true)
    end
end
function TopLayer:onButtonClickedEvent(tag,ref)
    if tag == 100 then
        if self.scene.gamestutus then
            showToast("游戏过程中,不能退出游戏！",1)
            return
        end
        self.scene.scene:closeGame()
    elseif tag == 2 then
        self.scene.scene:Open()
    elseif tag == 3 then
        local layer =SettingLayer:create(self)
        self:add(layer)
    elseif tag == 4 then
        gst.send(GameHead.huigu,nil)
    elseif tag == 7 then
        local tableinfo=public.gettableinfo(public.roomCode)
        local layer =WanfaLayer:create(self,tableinfo)
        layer:setName("WanfaLayer")
        self:add(layer)
    elseif tag == 6 then
        if self.image:isVisible() then
            self.image:setVisible(false)
            self.bj:getChildByName("B_6"):loadTextureNormal("zhankai.png",ccui.TextureResType.plistType)
            self.bj:getChildByName("B_6"):loadTexturePressed("zhankai.png",ccui.TextureResType.plistType)
            self.bj:getChildByName("B_6"):loadTextureDisabled("zhankai.png",ccui.TextureResType.plistType)
        else
            self.image:setVisible(true)
            self.bj:getChildByName("B_6"):loadTextureNormal("zhankai_1.png",ccui.TextureResType.plistType)
            self.bj:getChildByName("B_6"):loadTexturePressed("zhankai_1.png",ccui.TextureResType.plistType)
            self.bj:getChildByName("B_6"):loadTextureDisabled("zhankai_1.png",ccui.TextureResType.plistType)
        end
    end
end
return TopLayer

