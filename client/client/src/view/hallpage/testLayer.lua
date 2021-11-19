local testLayer = class("testLayer", function ()
	local testLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return testLayer
end)
local LuaTcpSocket=appdf.req(appdf.NETCENT_SRC ..".LuaTcpSocket")
local scheduler = cc.Director:getInstance():getScheduler()
local TAG={1,2,3,4}
function testLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Layer/testLayer.csb", self)
	self.bj=csbNode:getChildByName("Panel_1")
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
	for i = 1, 5 do 
		local str =string.format("Button_%d",i)
		self.bb[i]=self.bj:getChildByName(str)
		self.bb[i]:setTag(i)
		:addTouchEventListener(btcallback)
	end
          local socket = require "socket.core"
        self.newlink =socket.tcp()
        self.newlink:settimeout(0)--异步模式
    --self._socket = CClientSocket:createSocket(onConnectStatus)
end
function testLayer:onConnectStatus(pData)
           
            --print(pData)
            showToast(pData,1)
   
	if self.newlink then
		---self.newlink:close()
       -- self:stopTickScheduler()
	end
end
function testLayer:onButtonClickedEvent(tag,ref)
    --print("按下",tag)
    if tag == 1 then
        -- self._socket:setwaittime(0)
        -- if self._socket:connectSocket("114.215.153.170",7002) == true then
        --     --print("连接成功过")
        -- end
        -- self.gameSocket = LuaTcpSocket:new():init()
        -- self.gameSocket:setConnectCallback(self.onConnectStatus)
        -- self.gameSocket:connect("114.215.153.170", 7002)

        
        local succ,zhuangtai= self.newlink:connect("114.215.153.170", 7002)
        --print (succ,zhuangtai)
        -- if succ == 1 then
        --     self:tick()
        -- end
    elseif tag == 4 then
        --print("发送登陆消息")
        -- local data = {}
        -- data.userCode=public.userCode
        -- data.token =public.webtoken
        -- local strData = json.encode(data)
        -- self._socket:sendData(pData)
         local data = {}
                    data.userCode=public.userCode
                    data.token =public.webtoken
                    local strData = json.encode(data)
                    self.newlink:send(strData)
                    --print("发送数据为"..strData) 
        self.newlink:settimeout(1)--异步模式
         self:tick()
     elseif tag == 2 then
                 local data = {}
            data.bizCode = 999999
            local strData = json.encode(data)
            self.newlink:send(strData)
            
            self:tick()
     elseif tag == 3 then
         self.newlink:close()
         self:stopTickScheduler()
     elseif tag == 5 then
         self:setVisible(false)
    end
end
function testLayer:stopTickScheduler()
	if self.tickScheduler ~= nil then
		scheduler:unscheduleScriptEntry(self.tickScheduler)
	end
	self.tickScheduler = nil
end
function testLayer:tick()
    --print("设置接收数据")
	self.tickScheduler = scheduler:scheduleScriptFunc(function ( dt )
		--if self.status == NET_STATUS.connected then
			local chunck, status, partial = self.newlink:receive("*a")
			--print("chunck",type(chunck),chunck) --nil	nil
			--print("status",type(status),status)  --string	timeout
			--print("partial",type(status),partial) --string  len=0
 
 
			if status and status ~= "timeout" then
				--print("net status",status)
				--print("chunck",chunck)
				--print("partial",partial)
				-- self:disconnect(NET_STATUS.lostConnection)
                showToast("连接已断开从连接",1)
                self:stopTickScheduler()
				return
			end
 
			if ( chunck and #chunck == 0 ) or ( partial and #partial == 0 ) then
				-- --print("no data return 111")
				return
			end
 
			if partial and #partial > 0 then
				self:onConnectStatus(partial)
			end
			
 
	end,1,false)
end
 


return testLayer
