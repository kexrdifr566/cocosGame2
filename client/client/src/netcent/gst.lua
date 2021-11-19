gst =gst or {}
gst.gamecoon={}
gst.callback=nil
gst.newcn=nil
gst.oldcn={}
gst.hs=public.TICK_COUNTS
gst.tickder=nil
gst.intoback=false
gst.chushi=false
--getReadyState (0,1,2,3)--同==打开---正在断开---已经断开了
function gst.inint()
	local url =string.format("ws://%s:%s%s?roomCode=%s&groupCode=%s&token=%s",
        public.host,public.port,HallHead.gameurl,public.roomCode,public.enterclubid,public.webtoken)
    ExternalFun.print("gameurl:"..url)
    local cn=cc.WebSocket:create(url)
    -- 注册回调以上的函数
    
    cn:registerScriptHandler(gst.open,cc.WEBSOCKET_OPEN)
    cn:registerScriptHandler(gst.message,cc.WEBSOCKET_MESSAGE)
    cn:registerScriptHandler(gst.close,cc.WEBSOCKET_CLOSE)
    cn:registerScriptHandler(gst.neterror,cc.WEBSOCKET_ERROR)
    table.insert(gst.gamecoon,cn)
     --记录最新连接
    gst.newcn=cn 
    gst.chushi=false
end
function gst.sedheat()
     -- --print("game 心跳".."       时间: "..os.date("%c", os.time()))
     if #gst.oldcn ~= 0 then
        ExternalFun.print("ts--连接个数为"..#gst.oldcn)
        for k,v in pairs(gst.oldcn) do
            v:close()
        end
    end
    
	local data = {}
    data.bizCode = 999999
    local strData = json.encode(data)
    if gst.newcn then
        gst.newcn:sendString(strData)
    end
end
function gst.open()
    ExternalFun.print("game.open")
    gst.hs = public.TICK_COUNTS
    public.gamebacktime=1
    --关闭以前心跳
    if gst.tickder then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(gst.tickder)
    end
    dissWait()--关闭等待窗口
    --启动心跳
    function Sendheat()
        if gst.intoback== true then
            return
        end
    	if  gst.hs == 0 then
    		--关闭现在连接
    		showWait(10)
            gst.netclose()
    		gst.inint()
    	else
    		 gst.hs= gst.hs-1
    		gst.sedheat()
    	end
    end
    --添加心跳机制
    gst.tickder = cc.Director:getInstance():getScheduler():scheduleScriptFunc(Sendheat,public.SOCKET_TICK_TIME,false)
    --添加删除信息表
    --gst.callback(-1)
    performWithDelay(self,function ()
		if gst.chushi==false then
            gst.send(GameHead.ingame,nil)--发送进入游戏
        end
	end,1)	
    --gst.send(GameHead.ingame,nil)--发送进入游戏
end
--设置返回数据
function gst.setCallback(Callback)
    gst.callback=Callback
end
function gst.message(strData)
    --心跳判断
    if strData == 1 or strData =='1' then
        if gst.hs == 0 then
            dissWait()--关闭等待窗口
        end
        gst.hs = public.TICK_COUNTS --重置连接次数
        return
    end
    --正常收到消息
    dissWait()
    local Mdata=cjson.decode(strData)
    if Mdata["code"] == "0"  and gst.callback then
        local code = Mdata["bizCode"]
        local data = Mdata["data"]
        ExternalFun.dump(data,code)
        if code == GameHead.ingame then
            gst.chushi=true
        end
        gst.callback(code,data)
    elseif Mdata["code"] == "-1"  and Mdata["data"]  then
        showToast(Mdata["data"],1)
    elseif Mdata["code"] == "-1" and Mdata["value"]  then
        showToast(Mdata["value"],1)
    else
        -- --print("游戏服务消息不正确")
    end
end
--服务器或者以外关闭连接。重新连接
function gst.close(strData)
    
    -- dump(gst.gamecoon,strData)
    -- dump(gst.oldcn,gst.newcn)
    for k,v in pairs(gst.oldcn) do
        if v:getReadyState() == 3 then
            for a,b in pairs(gst.gamecoon) do
                if v ==b then
                    table.remove(gst.gamecoon,a)
                end
            end
            table.remove(gst.oldcn,k)
        end
    end
     if gst.newcn and gst.newcn:getReadyState() ~= 1 and public.entergame ~= 0 then  --如果是最新连接有问题提示重新连接
        performWithDelay(self,function ()
                if gst.newcn and gst.newcn:getReadyState() ~= 1 and public.entergame ~= 0 then
                    gst.netclose()
                    gst.inint()
                end
                return
        end,3)
    end    
end
--连接错误
function gst.neterror()
    ExternalFun.print("客户端请求错误!!!")
   
end
--程序给关闭
function gst.netclose()
     print("game.netclose")
    if gst.newcn then
        gst.newcn:close()
        table.insert(gst.oldcn,gst.newcn)
        gst.newcn=nil
    end
    if gst.tickder then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(gst.tickder)
    end
   -- gst.gamecoon={}
end
function gst.send(code,data)
        --判断是否连接
    if gst.newcn and gst.newcn:getReadyState() ~= 1 then
        showWait(30)
        gst.netclose()
        gst.inint()
        return
    end
    
    local senddata={}
    senddata.bizCode=code
    if data then
        senddata.data=data
    end
    local strData = json.encode(senddata)
    
    if gst.newcn then
        gst.newcn:sendString(strData)
    end
    ExternalFun.print("gst send"..strData.."       time: "..os.date("%c"))
end
function gst.reconnet()
    gst.intoback=false
    gst.hs = public.TICK_COUNTS
    if gst.newcn and gst.newcn:getReadyState() ~= 1 and public.entergame ~= 0 then  --如果是最新连接有问题提示重新连接
        gst.netclose()
        gst.inint()
    end
    for k,v in pairs(gst.oldcn) do
        if v:getReadyState() == 3 then
            for a,b in pairs(gst.gamecoon) do
                if v ==b then
                    table.remove(gst.gamecoon,a)
                end
            end
            table.remove(gst.oldcn,k)
        end
    end
end
function gst.Intobackground()
    gst.intoback=true
end
