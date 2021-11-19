st =st or {}
st.conn={}
--st.callback=nil
st.newcn=nil
st.oldcn={}
st.hs=public.TICK_COUNTS
st.tickder=nil
st.sendlast={}
function st.inint()
	local url =string.format("ws://%s:%s%s?userCode=%s&token=%s",HallHead.ws,HallHead.port,HallHead.url,public.userCode,public.webtoken)
    local cn =cc.WebSocket:create(url) 
    ExternalFun.print("st.url:"..url)
    cn:registerScriptHandler(st.open,cc.WEBSOCKET_OPEN)
    cn:registerScriptHandler(st.message,cc.WEBSOCKET_MESSAGE)
    cn:registerScriptHandler(st.close,cc.WEBSOCKET_CLOSE)
    cn:registerScriptHandler(st.neterror,cc.WEBSOCKET_ERROR)
    table.insert(st.conn,cn)
    --记录最新连接
    st.newcn=cn   
    
end
function st.sedheat()
    if #st.oldcn ~= 0 then
        ExternalFun.print("ts--连接个数为"..#st.oldcn)
        for k,v in pairs(st.oldcn) do
            v:close()
        end
    end
	local data = {}
    data.bizCode = 999999
    local strData = json.encode(data)
    --发送心跳
    if st.newcn then
       st.newcn:sendString(strData)
    end 
end
function st.open(strData)
    ExternalFun.print("st.open")
    st.hs = public.TICK_COUNTS
    --关闭原来心跳
    if st.tickder then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(st.tickder)
    end
    dissWait()    
    function Sendheat()
    	if  st.hs == 0 then
    		--关闭现在连接
    		showWait(10)
            st.netclose()
    		st.inint()
    	else
    		st.hs= st.hs-1
    		st.sedheat()
    	end
    end
    --添加心跳机制
    st.tickder = cc.Director:getInstance():getScheduler():scheduleScriptFunc(Sendheat,public.SOCKET_TICK_TIME,false)
    for k,v in pairs(st.oldcn) do
        v:close()
    end
    
    if public.enterclubid ~= "0" then --游戏中返回出来打开俱乐部
        local data={}
        data.groupCode=public.enterclubid 
        st.send(HallHead.inculb,data)
    else
        ----获取大厅公告
        local data={}
        data.userCode=public.userCode 
        st.send(HallHead.GGnotice,data) 
        --获取砖石数码
        local data ={}
        data.userCode=public.userCode
        st.send(HallHead.upzuanshi,data)
        
        local curScene = cc.Director:getInstance():getRunningScene()
        local HallScene = curScene:getChildByName("HallScene")
        if HallScene then
            local duanxianLayer =HallScene.duanxianLayer
            if HallScene.duanxianLayer and HallScene.duanxianLayer:isVisible()  then
                HallScene.duanxianLayer:setVisible(false)
                HallScene:OpenHallScene()                
            end
        end
        --补发
        if st.sendlast[1] and st.sendlast[2] then
            st.send(st.sendlast[1],st.sendlast[2])
            st.sendlast={}
        end
    end

end
--设置返回数据
-- function st.setCallback(Callback)
--     st.callback=Callback
-- end
function st.message(strData)    
	if strData == 1 or strData =='1' then
		if st.hs == 0 then
			dissWait()--关闭等待窗口
		end
		st.hs = public.TICK_COUNTS --重置连接次数
        return
	end
    dissWait()
    if strData == nil then
        return
    end
    local Mdata=cjson.decode(strData)
    --dump(Mdata,"===")
    if Mdata["code"] == "0"  then
        local code = Mdata["bizCode"]
        local data = Mdata["data"]
        EventMgr.dispatchEvent(code,data)
        --st.callback(code,data)
    elseif Mdata["code"] == "-1" then
        showToast(Mdata["value"],1)
    else
        -- sprint("大厅服务消息不正确")
    end
end
--服务器或者以外关闭连接。重新连接
function st.close(strData)
    
    -- dump(st.conn,strData)
    -- dump(st.oldcn,st.newcn)
    for k,v in pairs(st.oldcn) do
        if v:getReadyState() == 3 then
            for a,b in pairs(st.conn) do
                if v ==b then
                    table.remove(st.conn,a)
                end
            end
            table.remove(st.oldcn,k)
        end
    end
    
    if st.newcn and st.newcn:getReadyState() ~= 1 and public.entergame == 0 then  --如果是最新连接有问题提示重新连接
        performWithDelay(self,function ()
                ExternalFun.print("大厅链接已经断开"..os.date("%c"))
                if st.newcn and st.newcn:getReadyState() ~= 1 and public.entergame == 0 then
                    st.netclose()
                    st.inint()
                end
                return
        end,3)
    end
end
function st.chargenet()
    if st.newcn then
        st.netclose()
    end
end
--连接错误
function st.neterror()
    QueryExit("大厅网络断开重新连接？", function (ok)
			if ok == true then
                st.netclose()
				st.inint()
			end
		end,true)
    
end
--程序给关闭
function st.netclose()
    if st.newcn then
        st.newcn:close()
        table.insert(st.oldcn,st.newcn)
        st.newcn=nil
    end
    if st.tickder then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(st.tickder)
    end
end
function st.send(code,data)
    --判断是否连接
    if st.newcn and st.newcn:getReadyState() ~= 1 then
        showWait(30)
        st.netclose()
        st.inint()
        st.sendlast[1]=code
        st.sendlast[2]=data
        return
    end
    local senddata={}
    senddata.bizCode=code
    if data then
        senddata.data=data
    end
    local strData = json.encode(senddata)
    if st.newcn then
       st.newcn:sendString(strData)
       ExternalFun.print("ts send"..strData.."       time: "..os.date("%c"))
    end
end