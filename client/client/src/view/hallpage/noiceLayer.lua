local noiceLayer = class("noiceLayer", function ()
	local noiceLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return noiceLayer
end)
local AnimationHelper = appdf.req(appdf.EXTERNAL_SRC .. "AnimationHelper")
local ceshi={{t1="测试文本",t2="测试股测试测试测试！"}}
local TAG={1,2,3,4}
local get_listItem_pcen=function (hv,list1)
    local pcen=nil;
    if(hv==1)then --横
        local lxy= list1:getInnerContainer();
        local sw1=lxy:getContentSize().width ;
        local sw2=list1:getContentSize().width;
        local w = sw1 - sw2;
        local x,y=lxy:getPosition();
        pcen=(100/w)*x;
        pcen=math.abs(pcen);

        if(pcen~=pcen)then
            pcen=100;
        end
    elseif(hv==2)then--纵
        local lxy= list1:getInnerContainer();
        local sw1=lxy:getContentSize().height;
        local sw2=list1:getContentSize().height;
        local minY = sw1 - sw2;
        local h = - minY;
        local x,y=lxy:getPosition();
        pcen=(100/h)*y;
        if(pcen~=pcen)then
            pcen=100;
        end
    end

    return pcen;
end
function noiceLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Layer/noiceLayer.csb", self)
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
    self.pListView=self.bj:getChildByName("pListView")
	self.bb={}
	for i = 1, 5 do 
		local str =string.format("B_%d",i)
		self.bb[i]=self.pListView:getChildByName(str)
		self.bb[i]:setTag(i+10)
		:addTouchEventListener(btcallback)
	end
    self.wf={}
    	for i = 1, 5 do
		local str =string.format("gui%d",i)
		self.wf[i]=self.bj:getChildByName(str)
	end
	self:selectBandP(1)
  --  local function scrollviewEvent222(sender,eventType)
  --     print("dddddddddddddd"..eventType)
  -- --      --dump(eventType,"ddd")
  --      if eventType == ccui.TouchEventType.ended then
		-- local baifenbi=	get_listItem_pcen(1,self.sss)
  --          local  b = sender:getInnerContainer():getPositionY();
  --          local baifenbi=	get_listItem_pcen(2,self.sss)
  --            print("2百分比"..b.."  "..baifenbi)
  --         self.sss:jumpToPercentVertical(baifenbi); --水平
		-- elseif eventType == ccui.TouchEventType.began then
		-- 	return true
		-- elseif eventType == ccui.TouchEventType.canceled then
  --            local baifenbi=	get_listItem_pcen(2,self.sss)
  --           local  b = sender:getInnerContainer():getPositionY();
  --            print("3百分比"..b.."  "..baifenbi)
  --           self.sss:jumpToPercentVertical(baifenbi); 
		-- end
  --   end
  --  local function scrollviewEvent(sender,eventType)
  --      --print("ccccccccccc"..eventType)
  --       if eventType == 12 then
  --            local baifenbi=	get_listItem_pcen(2,self.sss)
  --            print("2百分比".."  "..baifenbi)
  --       end
  --  end
  --  self.sss= self.bj:getChildByName("gui1")
  --   self.sss:addEventListenerScrollView(scrollviewEvent)
   AnimationHelper.jumpInEx(self.bj, 1)
end
function  noiceLayer:selectBandP(index)

	if self.bb[index] ==nil then
		return
	end

	for k,v in pairs(self.bb) do
		v:setEnabled(true)
        v:getChildByName("Text"):setColor(cc.c3b(114,69,21))
        if k == index then
            v:setEnabled(false)
            v:getChildByName("Text"):setColor(cc.c3b(255,255,255))
        end
	end
    for k,v in pairs(self.wf) do
		v:setVisible(false)
        if k == index then
            v:setVisible(true)
        end
	end
	
end
--发送刷新消息列表
function noiceLayer:onButtonClickedEvent(tag,ref)
    if tag == 100 then
        self:removeFromParent()
    elseif tag <=20 and tag >=11 then
    	self:selectBandP(tag-10)
    end
end

return noiceLayer
