local ChongzhiLayer = class("ChongzhiLayer", function ()
	local ChongzhiLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return ChongzhiLayer
end)
local ZZBase64 = {}
local AnimationHelper = appdf.req(appdf.EXTERNAL_SRC .. "AnimationHelper")
local TAG={1,2,3,4}
function ChongzhiLayer:ctor(_scene,clubinfo)
	self.scene=_scene
	self._clubinfo = clubinfo
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Club/Layer/ChongzhiLayer.csb", self)
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
    self.bb={}
	for i = 1, 2 do
		local str =string.format("B_%d",i)
		self.bb[i]=self.bj:getChildByName(str)
		self.bb[i]:setTag(i)
		:addTouchEventListener(btcallback)
        self.bb[i]:getChildByName("Text"):setColor(cc.c3b(114,69,21))
        if i==1 then
            self.bb[i]:setEnabled(false)
            self.bb[i]:getChildByName("Text"):setColor(cc.c3b(255,255,255))
        end
	end
    self.p1=self.bj:getChildByName("P1")
    self.p2=self.bj:getChildByName("P2")
    self.p3=self.bj:getChildByName("P3")
    for i = 1, 8 do
		local str =string.format("B%d",i)
		local bb =self.p1:getChildByName(str)
		bb:setTag(i+10)
		:addTouchEventListener(btcallback)
	end
    
    local t1=self.p1:getChildByName("Image1")
	self.t1 = ExternalFun.cteartTFtwo(t1,self.p1,"请输入真实姓名",nil,nil,nil,35)
        local t1=self.p1:getChildByName("Image2")
	self.t2 = ExternalFun.cteartTFtwo(t1,self.p1,"请输入存款金额",true,nil,nil,35)
    
    self.b1=self.p1:getChildByName("B_1")
    self.b1:setTag(21)
	self.b1:addTouchEventListener(btcallback)
    
    self.bj:getChildByName("BK")
    :setTag(30)
	:addTouchEventListener(btcallback)
    -- self.b2=self.p1:getChildByName("B_2")
    -- self.b2:setTag(22)
    -- self.b2:addTouchEventListener(btcallback)
    
    self.bj:getChildByName("B_C")
	:setTag(100)
	:addTouchEventListener(btcallback)
    self:inint()
    self:huoqudizhi()
    AnimationHelper.jumpInEx(self.bj, 1)
end
function ChongzhiLayer:inint()
    self.p2:setVisible(false)
    self.p3:setVisible(false)
    self.kefuulr=""
    --self.groupBili=1
   -- self.b2:setVisible(false)
end
function ChongzhiLayer:huoqudizhi()
    
    function Senddata(datas)
        self.kefuulr=datas.kf
        if tonumber(datas.groupBili) then
            --self.groupBili=tonumber(datas.groupBili)
            local str="本俱乐部金币充值比例为:("..datas.groupBili.."),即充值500到账"..500*tonumber(datas.groupBili).."金币"
            self.p1:getChildByName("T"):setString(str)
        end
    end
    local data ={}
    data.groupCode=self._clubinfo.groupCode
    
    httpnect.send(HttpHead.groupKf,data,Senddata)
end
function ChongzhiLayer:onButtonClickedEvent(tag,ref)
    --print("选择"..tag)
    if tag == 100 then
        self.scene:upCoin()
        self:removeFromParent()
    elseif tag >=1 and tag < 4 then
    	self:selectB(tag)
    elseif tag >10 and tag <20 then
        --self.t2:setString(ref:getTitleText())
        self.t2:setString(ref:getChildByName("Text_0"):getString())
    elseif tag == 21 then
        if self:checking() then
            self:openwebURL()
        end
    elseif tag == 30 then
        if self.kefuulr ~="" then
            cc.Application:getInstance():openURL(self.kefuulr)
        else
            showToast("客服未设置!",2)
        end
    end
end
function ChongzhiLayer:checking()
    local t=tonumber(self.t2:getString())
    if t==nil then
        showToast("请输入存款金额",2)
        return
    elseif t < 1 then
        showToast("充值金额不足",2)
        return
    end
    local t=self.t1:getString()
    if t=="" then
        showToast("请输入真实姓名",2)
        return
    end
    if t=="请输入真实姓名" then
        showToast("请输入真实姓名",2)
        return
    end
    return true
end
function ChongzhiLayer:selectB(index)
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
    
    self.select=index
    
    if index ==1 then
        self.p2:setVisible(false)
        self.p1:setVisible(true)
        self.t1:setVisible(true)
        self.t1:setString("请输入真实姓名")
        self.t2:setString("请输入存款金额")
    elseif index == 2 then
        self.p2:setVisible(true)
        self.p1:setVisible(false)
    end
   
end

function ChongzhiLayer:openwebURL()
    function Senddata(datas)
        showToast("打开充值界面")
    end
    local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
    local t=tonumber(self.t2:getString())
    local srcname=self.t1:getString()
    -- local config_path = appdf.req("config_path")
    -- local URL_REQUEST_LIST = config_path[appdf.isTest and 2 or 1]
    

    function encodeURI(s)
        s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
        return string.gsub(s, " ", "+")
    end
    local str="userCode="..public.userCode.."&czje="..t.."&zzrxm="..encodeURI(srcname).."&groupCode="..
        self._clubinfo.groupCode.."&userName="..encodeURI(public.userName).."&token="..public.webtoken  --..public.userName
    -- local urlstr=encodeURI(str)
    -- str=encodeURI(str)
    str=public.czurl.."/gameCenter/static/index1.html#/zfqr?"..str 
    print(str)
    cc.Application:getInstance():openURL(str)
    
end
ZZBase64.__code = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/',
};
ZZBase64.__decode = {}
for k,v in pairs(ZZBase64.__code) do
    ZZBase64.__decode[string.byte(v,1)] = k - 1
end

function ZZBase64.encode(text)
    local len = string.len(text)
    local left = len % 3
    len = len - left
    local res = {}
    local index  = 1
    for i = 1, len, 3 do
        local a = string.byte(text, i )
        local b = string.byte(text, i + 1)
        local c = string.byte(text, i + 2)
        -- num = a<<16 + b<<8 + c
        local num = a * 65536 + b * 256 + c
        for j = 1, 4 do
            --tmp = num >> ((4 -j) * 6)
            local tmp = math.floor(num / (2 ^ ((4-j) * 6)))
            --curPos = tmp&0x3f
            local curPos = tmp % 64 + 1
            res[index] = ZZBase64.__code[curPos]
            index = index + 1
        end
    end

    if left == 1 then
        ZZBase64.__left1(res, index, text, len)
    elseif left == 2 then
        ZZBase64.__left2(res, index, text, len)
    end
    return table.concat(res)
end

function ZZBase64.__left2(res, index, text, len)
    local num1 = string.byte(text, len + 1)
    num1 = num1 * 1024 --lshift 10
    local num2 = string.byte(text, len + 2)
    num2 = num2 * 4 --lshift 2
    local num = num1 + num2

    local tmp1 = math.floor(num / 4096) --rShift 12
    local curPos = tmp1 % 64 + 1
    res[index] = ZZBase64.__code[curPos]

    local tmp2 = math.floor(num / 64)
    curPos = tmp2 % 64 + 1
    res[index + 1] = ZZBase64.__code[curPos]

    curPos = num % 64 + 1
    res[index + 2] = ZZBase64.__code[curPos]

    res[index + 3] = "="
end

function ZZBase64.__left1(res, index,text, len)
    local num = string.byte(text, len + 1)
    num = num * 16

    local tmp = math.floor(num / 64)
    local curPos = tmp % 64 + 1
    res[index ] = ZZBase64.__code[curPos]

    curPos = num % 64 + 1
    res[index + 1] = ZZBase64.__code[curPos]

    res[index + 2] = "="
    res[index + 3] = "="
end

function ZZBase64.decode(text)
    local len = string.len(text)
    local left = 0
    if string.sub(text, len - 1) == "==" then
        left = 2
        len = len - 4
    elseif string.sub(text, len) == "=" then
        left = 1
        len = len - 4
    end

    local res = {}
    local index = 1
    local decode = ZZBase64.__decode
    for i =1, len, 4 do
        local a = decode[string.byte(text,i    )] 
        local b = decode[string.byte(text,i + 1)] 
        local c = decode[string.byte(text,i + 2)] 
        local d = decode[string.byte(text,i + 3)]

        --num = a<<18 + b<<12 + c<<6 + d
        local num = a * 262144 + b * 4096 + c * 64 + d

        local e = string.char(num % 256)
        num = math.floor(num / 256)
        local f = string.char(num % 256)
        num = math.floor(num / 256)
        res[index ] = string.char(num % 256)
        res[index + 1] = f
        res[index + 2] = e
        index = index + 3
    end

    if left == 1 then
        ZZBase64.__decodeLeft1(res, index, text, len)
    elseif left == 2 then
        ZZBase64.__decodeLeft2(res, index, text, len)
    end
    return table.concat(res)
end

function ZZBase64.__decodeLeft1(res, index, text, len)
    local decode = ZZBase64.__decode
    local a = decode[string.byte(text, len + 1)]
    local b = decode[string.byte(text, len + 2)]
    local c = decode[string.byte(text, len + 3)]
    local num = a * 4096 + b * 64 + c

    local num1 = math.floor(num / 1024) % 256
    local num2 = math.floor(num / 4) % 256
    res[index] = string.char(num1)
    res[index + 1] = string.char(num2)
end

function ZZBase64.__decodeLeft2(res, index, text, len)
    local decode = ZZBase64.__decode
    local a = decode[string.byte(text, len + 1)]
    local b = decode[string.byte(text, len + 2)]
    local num = a * 64 + b
    num = math.floor(num / 16)
    res[index] = string.char(num)
end
return ChongzhiLayer

