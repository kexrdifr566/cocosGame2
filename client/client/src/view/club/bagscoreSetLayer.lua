 local bagscoreSetLayer = class("bagscoreSetLayer", function ()
	local bagscoreSetLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return bagscoreSetLayer
 end)
local AnimationHelper = appdf.req(appdf.EXTERNAL_SRC .. "AnimationHelper")
function bagscoreSetLayer:ctor(_scene,data)
	self.scene=_scene
    self.data = data
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Club/Layer/bagscoreSet.csb", self)
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
	self.bj:getChildByName("Bq")
	:setTag(101)
	:addTouchEventListener(btcallback)
	self.bj:getChildByName("Bs")
	:setTag(102)
	:addTouchEventListener(btcallback)
	self.SB={}
	for i = 1, 13 do
		local str =string.format("B_%d",i)
		self.SB[i]=self.bj:getChildByName(str)
		self.SB[i]:setTag(i)
		:addTouchEventListener(btcallback)
	end
	
    self.BB=self.bj:getChildByName("B1")
    self:upscore()
    self:rescore()
    AnimationHelper.jumpInEx(self.bj, 1)
end
function bagscoreSetLayer:upscore()
    self.bj:getChildByName("T1"):setString(public.userName)
	self.bj:getChildByName("T2"):setString("ID:"..public.userCode)
    self.bj:getChildByName("ziji"):getChildByName("T2"):setString(self.data.userQianbao)
    self.BB:getChildByName("T2"):setString(self.data.jzje)
    local headbg=self.bj:getChildByName("H")
    --设置头像
    ExternalFun.createClipHead(headbg,public.userCode,public.logoUrl,67)
end
function bagscoreSetLayer:rescore()
    self.BB:getChildByName("T3"):setString(0) 
    self.BB:getChildByName("T4"):setString("-0") 
end
function bagscoreSetLayer:onButtonClickedEvent(tag,ref)
	if tag == 100 then
		--更新自己的数据
        self.scene.select=0
        self.scene:sendData()
        self.scene.back=true
        self.scene:selectB(2)
		self:removeFromParent()
	elseif tag > 20 and tag <= 23 then
		--self:selectT(tag-20)
	elseif tag >=1 and tag <= 13 then
        if tag == 10 then
            tag=0
        end
		self:changescore(tag)
	elseif tag == 101 then
		self:rescore()
	elseif tag == 102 then
        self:send()
    end
end
function bagscoreSetLayer:changescore(num)
    --print("num"..num)
    local absscore =math.abs(tonumber(self.BB:getChildByName("T4"):getString()))
    local de=false  --是否删除
    if num == 13 then
        de=true
    end
    
    local scoreso =0
    --判断是否删除
    if de then
        if absscore < 10 then
            scoreso=0
        else
            scoreso =math.floor(absscore/10)
        end
    else
        scoreso = absscore*10+num
    end
    
    local score =tonumber(self.BB:getChildByName("T2"):getString())
    if score < scoreso then
        showToast("捐赠分分数不足！",1)
        return
    end
    self.BB:getChildByName("T3"):setString(scoreso)
    self.BB:getChildByName("T4"):setString("-"..scoreso)
end
function bagscoreSetLayer:send()
    local biansocre=math.abs(tonumber(self.BB:getChildByName("T4"):getString()))
    if biansocre <=0 then
         showToast("转出分必须大于0！",1)
        return
    end
    function Senddata(datas)
        showToast("转出成功！",2)
        self.data.userQianbao=self.data.userQianbao+biansocre
        self.data.jzje=self.data.jzje-biansocre
        self:upscore()
        self:rescore()
    end
    local url=HttpHead.qbjzfzc
    local data={}
    data.userCode=public.userCode
    data.groupCode=public.enterclubid
    data.je=biansocre
    httpnect.send(url,data,Senddata)
end

return bagscoreSetLayer

