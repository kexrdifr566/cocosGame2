local yaoqingLayer = class("yaoqingLayer", function ()
	local yaoqingLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return yaoqingLayer
end)
local AnimationHelper = appdf.req(appdf.EXTERNAL_SRC .. "AnimationHelper")
local TAG={1,2,3,4}
function yaoqingLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Layer/yaoqingLayer.csb", self)
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
    self.bj:getChildByName("BC")
	:setTag(100)
	:addTouchEventListener(btcallback)
    self.bj:getChildByName("Button")
	:setTag(2)
	:addTouchEventListener(btcallback)
    
    --self.shareye=csbNode:getChildByName("shareye")
    --self.shareye:setVisible(false)
    function Senddata(datas)
		self.bj:getChildByName("T"):setString(datas.yqm)
         self.yqm=datas.yqm
        --self.shareye:getChildByName("T"):setString(datas.yqm)
	end
    self.yqm=""
    local clubinfo = public.getclubinfo(public.enterclubid)
	local data={}
    data.userCode = public.userCode
	data.groupCode=clubinfo.groupCode
	
	httpnect.send(HttpHead.getCode,data,Senddata)
    AnimationHelper.jumpInEx(self.bj, 1) 
end
function yaoqingLayer:onButtonClickedEvent(tag,ref)
    if tag == 100 then
        self:removeFromParent()
    elseif tag == 2 then
        --self.shareye:setVisible(true)
        self:cjewm()
    end
end
function yaoqingLayer:cjewm()
    local save_file_name = "game_bole.png"
    local shareurl = appdf.SHARE_URL
    local save_file_path = cc.FileUtils:getInstance():getWritablePath()
    local codeSprite = cc.Sprite:create("Club/Public/erweima.png")--QrNode:createQrNode(shareurl, 600, 5, 1)
    local cachePoster = cc.Director:getInstance():getTextureCache():addImage("Public/shareye.png")
    local posterSprite = cc.Sprite:createWithTexture(cachePoster)
    local posterSize = posterSprite:getContentSize()
    local codeSize = codeSprite:getContentSize()
    local qrcSize =310 --1160
    local NewTFW =cc.Label:createWithTTF(self.yqm, "font/FZY4JW.TTF", 96)
    NewTFW:setAnchorPoint(0,0.5)
    codeSprite:setScale(qrcSize/codeSize.width)
    codeSprite:setPosition(posterSize.width/2,posterSize.height/2-114)--qrcSize/2)
    posterSprite:addChild(codeSprite)
    NewTFW:setPosition(posterSize.width/2-130,posterSize.height/2-500)
    posterSprite:addChild(NewTFW)
    NewTFW:setColor(cc.c3b(114,69,21))
    posterSprite:setPosition(posterSize.width/2,posterSize.height/2)
    posterSprite:retain()
    local render = cc.RenderTexture:create(posterSize.width,posterSize.height)
    render:addTo(self)
    render:beginWithClear(0, 0, 0, 0)
    render:setSprite(posterSprite)
    posterSprite:visit()
    render:endToLua()
    render:saveToFile(save_file_name, cc.IMAGE_FORMAT_PNG, true)
    local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform") 
    local ret, msg = MultiPlatform:saveImgToSystemGallery(save_file_path .. save_file_name, save_file_name)
        if ret == true then
            showToast("精美广告图已保存到您手机相册！", 5)
            posterSprite:setVisible(false)
        else
            showToast("图已保存到您手机相册！", 5)
            posterSprite:setVisible(false)
        end
end

return yaoqingLayer