local BrdzjListLayer = class("BrdzjListLayer", function ()
	local BrdzjListLayer =  display.newLayer()
	return BrdzjListLayer
end)
function BrdzjListLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Game/brpublicLayer/BrdzjListLayer.csb", self)
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
    self.bj:getChildByName("Text_1"):setString("上庄需要:".._scene.kzfs.."分")
    self.bj:getChildByName("Text_1_0"):setVisible(false)
    
    self.B_z=self.bj:getChildByName("B_S")
	self.B_z:setTag(1)
	:addTouchEventListener(btcallback)
    
    self.p=self.bj:getChildByName("Pd")
    self.pk=self.bj:getChildByName("pkd")
    
    self.status=1
	
end

function BrdzjListLayer:onButtonClickedEvent(tag,ref)
    if tag == 1 then
        local data ={}
		data.actionCode =BaiRenHead.action[self.status+1]
    	gst.send(BaiRenHead.Tcode,data)
    elseif tag == 100 then
		self:removeFromParent()
    end
end
function BrdzjListLayer:setZhuangBtn(isbanker,isstatus,isend)
    local str={"Game/brpublic/brnui/btn_sqs.png","Game/brpublic/brnui/btn_xz.png","Game/brpublic/brnui/btn_qx.png","Game/brpublic/brnui/btn_qx2.png"}
    local btnskin=str[1]
    if isstatus then
        btnskin=str[3]
        self.status=3
    elseif isbanker ==true then
        btnskin=str[2]
        self.status=2
    end
    if isend then
        btnskin=str[4]
        self.B_z:setEnabled(false)
    else
        self.B_z:setEnabled(true)
    end
    self.B_z:loadTextureNormal(btnskin)
    self.B_z:loadTexturePressed(btnskin)
    self.B_z:loadTextureDisabled(btnskin)
    self.B_z:setVisible(true)
end
function BrdzjListLayer:inint(data)
    ExternalFun.dump(data,"列表")
    self.p:removeAllChildren()
    for k,v  in pairs(data.sqBankeruser) do
		local item=self.pk:clone()
        --设置头像
        local head=item:getChildByName("head")
        ExternalFun.createClipHead(head,v.userCode,v.logoUrl,70)
         item:getChildByName("T1"):setString(v.userName)
         item:getChildByName("T2"):setString(ExternalFun.showUserCode(v.userCode))
         item:getChildByName("T3"):setString(ExternalFun.GetPreciseDecimal(v.gameCoin))
         item:getChildByName("A"):setString(k)
        self.p:pushBackCustomItem(item)
    end
end
return BrdzjListLayer

