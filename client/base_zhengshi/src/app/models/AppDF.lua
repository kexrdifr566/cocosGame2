--[[
	常用定义
]]
appdf = appdf or {}
appdf.BASE_C_VERSION = 1 --@app_version
appdf.bili 									= 1.0 -- 还原 倍数(1000 原始)

--程序版本
appdf.BASE_C_RESVERSION =52 --@client_version
--屏幕高宽
appdf.WIDTH									= 1280
appdf.HEIGHT								= 720
appdf.g_scaleX                              = display.width / appdf.WIDTH      --X坐标的缩放比例值 added ycc
appdf.g_scaleY                              = display.height / appdf.HEIGHT    --Y坐标的缩放比例值 added ycc

appdf.BASE_SRC                              = "base.src."
appdf.CLIENT_SRC                            = "client.src."


--扩展目录
appdf.EXTERNAL_SRC							= "client.src.external."
--游戏目录
appdf.GAME_SRC								= "client.src.game."
--网络处理目录
appdf.NETCENT_SRC                           = "client.src.netcent."
--界面目录
appdf.VIEW                           		= "client.src.view."
--公用界面
appdf.PUBLIC                           		= "client.src.public."


appdf.channelId                             = 1
appdf.Ratio									= false

--下载信息
appdf.DOWN_PRO_INFO							= 1 									--下载进度
appdf.DOWN_COMPELETED						= 3 									--下载结果
appdf.DOWN_ERROR_PATH						= 4 									--路径出错
appdf.DOWN_ERROR_CREATEFILE					= 5 									--文件创建出错
appdf.DOWN_ERROR_CREATEURL					= 6 									--创建连接失败
appdf.DOWN_ERROR_NET		 				= 7 									--下载失败

appdf.CLIENT_NOTIFY 						= "__global_client_notify_event__" 		-- 客户端通知
--环境
--资源版本
appdf.isTest                                = false                                 --(false.发布 true.测试)
--是否苹果版本
appdf.APPSTORE_VERSION = false
--网关
appdf.SERVER_LIST = {}
--api
appdf.http_api = {}
appdf.WS_URL = {}

appdf.HTTP_URL = "http://127.0.0.1:96/"
appdf.SHARE_URL = "http://127.0.0.1:96/"
-- 当前地址索引
appdf.CURRENT_INDEX = 1
appdf.TOTAL_COUNT = #appdf.SERVER_LIST

-- 登陆地址
appdf.LOGONSERVER                       = appdf.SERVER_LIST[appdf.CURRENT_INDEX]

--编译码
appdf.VALIDATE 							= "11E9E77D-C628-4FD6-AC60-91A541DBD5C1" --@compilation


--设置网关
function appdf.setGate(gatelist,http_api)
    --网关
	appdf.SERVER_LIST = gatelist
	--api
	appdf.http_api = http_api

	-- 当前地址索引
	appdf.CURRENT_INDEX = 1
	appdf.TOTAL_COUNT = #appdf.SERVER_LIST
	appdf.HTTP_URL = http_api[1]
    appdf.SHARE_URL=appdf.HTTP_URL
	-- 登陆地址
	appdf.LOGONSERVER = appdf.SERVER_LIST[appdf.CURRENT_INDEX]
end

-- 获取域名对应的ip
function appdf.replaceHostbyIP(url_)
	if  device.platform ~= "ios" then
		-- return
	end
	local host = ""
	local strlist = string.split(url_,"/")
	if  string.find(string.lower(strlist[1]),"http")  then
		if strlist[2] == "" then
			host = strlist[3]
		else
			host = strlist[2]
		end
	else
		host = strlist[1]
	end
	if string.find( host,":")  then
		local hostlist = string.split(host,":")
		host = hostlist[1]
	end
	local socket = appdf.req("socket.core")
	local addrinfo, err = socket.dns.getaddrinfo(host)
	if addrinfo and addrinfo[1] and addrinfo[1].addr then
		local addr = addrinfo[1].addr
		if addr == "127.0.0.1" or addr == "0.0.0.0" then
			return 
		end
		return string.gsub(url_,host,addr)
	end
end

function appdf.req(path)
    if path and type(path) == "string" then
        return require(path)
    else
        print("require paht unknow")
    end
end

-- 字符分割
function appdf.split(str, flag)
	local tab = {}
	while true do

		local n = string.find(str, flag)
		if n then
			local first = string.sub(str, 1, n-1) 
			str = string.sub(str, n+1, #str) 
			table.insert(tab, first)
		else
			table.insert(tab, str)
			break
		end
	end
	return tab
end

-- 检测该字符串是否为空
function appdf.isNullString( targetStr )
	if not targetStr or type(targetStr) ~= "string" or  trim(targetStr) == ""  then
		return true
	end
end

--依据宽度截断字符
function appdf.stringEllipsis(szText, sizeE,sizeCN,maxWidth)
	--当前计算宽度
	local width = 0
	--截断位置
	local lastpos = 0
	--截断结果
	local szResult = "..."
	--完成判断
	local bOK = false
	 
	local i = 1
	 
	while true do
		local cur = string.sub(szText,i,i)
		local byte = string.byte(cur)
		if byte == nil then
			break
		end
		if byte > 128 then
			if width +sizeCN <= maxWidth - 3*sizeE then
				width = width +sizeCN
				 i = i + 3
				 lastpos = i+2
			else
				bOK = true
				break
			end
		elseif	byte ~= 32 then
			if width +sizeE <= maxWidth - 3*sizeE then
				width = width +sizeE
				i = i + 1
				lastpos = i
			else
				bOK = true
				break
			end
		else
			i = i + 1
			lastpos = i
		end
	end
	 
	 	if lastpos ~= 0 then
			szResult = string.sub(szText, 1, lastpos)
			if(bOK) then
				szResult = szResult.."..."
			end
		end
		return szResult
end

--依据宽度截断字符
function appdf.stringByEllipsis(szText, sizeE,sizeCN,maxWidth,replaceStr)
	--当前计算宽度
	local width = 0
	--截断位置
	local lastpos = 0
	--截断结果
	local szResult = "..."
	--完成判断
	local bOK = false
	 
	local i = 1
	 
	while true do
		local cur = string.sub(szText,i,i)
		local byte = string.byte(cur)
		if byte == nil then
			break
		end
		if byte > 128 then
			if width +sizeCN <= maxWidth - 3*sizeE then
				width = width +sizeCN
				 i = i + 3
				 lastpos = i+2
			else
				bOK = true
				break
			end
		elseif	byte ~= 32 then
			if width +sizeE <= maxWidth - 3*sizeE then
				width = width +sizeE
				i = i + 1
				lastpos = i
			else
				bOK = true
				break
			end
		else
			i = i + 1
			lastpos = i
		end
	end
	 
	 	if lastpos ~= 0 then
			szResult = string.sub(szText, 1, lastpos)
			if(bOK) then
				szResult = szResult..replaceStr..string.sub(szText,lastpos)
			end
		end
		return szResult
end


function appdf.onHttpDownUrl(url,filename,savepath,callback,timeout)
	local xhr = cc.XMLHttpRequest:new()
	xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
	xhr.timeout = timeout or 7
	local methon = "GET"

	xhr:open(methon, url)

	--HTTP回调函数
	local function onDownInfo(res)
		local datatable 
		local response
		local ok
	    if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
			   local fileData = xhr.response
			   if not cc.FileUtils:getInstance():isDirectoryExist(savepath) then
				  cc.FileUtils:getInstance():createDirectory(savepath)
			   end
			   local file = io.open(savepath..filename,"wb")
			   file:write(fileData)
			   file:close()
			   if type(callback) == "function" then
				   callback(appdf.DOWN_COMPELETED,xhr.response)
			   end	    
		else
			if type(callback) == "function" then
				callback(appdf.DOWN_ERROR_NET,xhr.response)
			end
	    end
	end
	xhr:registerScriptHandler(onDownInfo)
	xhr:send()
	return true

end

--HTTP获取json
function appdf.onHttpApiJson(methon,params,callback)
	local xhr = cc.XMLHttpRequest:new()
	
	xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
	local bPost = ((methon == "POST") or (methon == "post"))

	--模式判断
	if not bPost then
		if params ~= nil and params ~= "" then
			xhr:open(methon, url.."?"..params)
		else
			xhr:open(methon, url)
		end
	else
		xhr:open(methon, url)
	end
	--HTTP回调函数
	local function onJsionTable()
		local datatable 
		local response
		local ok
	    if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
	   		response  = xhr.response -- 获得响应数据
	   		if response then
	   		    ok, datatable = pcall(function()
			       return cjson.decode(response)
			    end)
			    if not ok then
			    	print("onHttpJsionTable_cjson_error")
			    	datatable = nil
			    end
		    end
	    else
	    	print("1onJsionTable http fail readyState:"..xhr.readyState.."#status:"..xhr.status)
	    end
	    if type(callback) == "function" then
	    	callback(datatable,response)
	    end	    
	end
	xhr:registerScriptHandler(onJsionTable)
	if not bPost then
		xhr:send()
	else
		xhr:send(params)
	end
	return true
end

--HTTP获取json
function appdf.onHttpJsionTable(url,methon,params,callback,header)
	--print("appdf.onHttpJsionTable:"..url.."?"..params)
	local xhr = cc.XMLHttpRequest:new()
	
	xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
	local bPost = ((methon == "POST") or (methon == "post"))
	
	--模式判断
	if not bPost then
		if params ~= nil and params ~= "" then
			xhr:open(methon, url.."?"..params)
			print('打开地址'..url.."?"..params)
		else
			xhr:open(methon, url)
		end
	else
		xhr:open(methon, url)
	end
	--HTTP回调函数
	local function onJsionTable()
		local datatable 
		local response
		local ok
	    if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
	   		response  = xhr.response -- 获得响应数据
	   		if response then
	   		    ok, datatable = pcall(function()
			       return cjson.decode(response)
			    end)
			    if not ok then
			    	print("onHttpJsionTable_cjson_error")
			    	datatable = nil
			    end
		    end
	    else
	    	print("2onJsionTable http fail readyState:"..xhr.readyState.."#status:"..xhr.status.."url==="..url)
	    end
	    if type(callback) == "function" then
	    	callback(datatable,response)
	    end	    
	end
	local data =string.format("telephone=13123456789")
	xhr:registerScriptHandler(onJsionTable)
	if header then
		xhr:send(data)
	else
		xhr:send()
	end
	return true
end
--创建版本
function appdf.ValuetoVersion(value)
	if not value then
		return {p=0,m=0,s=0,b=0}
	end
	local tmp 
	if type(value) ~= "number" then
		tmp = tonumber(value)
	else
		tmp = value
	end
	return
	{
		p = bit:_rshift(bit:_and(tmp,0xFF000000),24),
		m = bit:_rshift(bit:_and(tmp,0x00FF0000),16),
		s = bit:_rshift(bit:_and(tmp,0x0000FF00),8),
		b = bit:_and(tmp,0x000000FF)
	}
end

--创建颜色
function appdf.ValueToColor( r,g,b )
	r = r or 255
	g = g or 255
	b = b or 255
	if type(r) ~= "number" then
		r = 255
	end
	if type(g) ~= "number" then
		g = 255
	end
	if type(b) ~= "number" then
		b = 255
	end

	local c = 0
	c = bit:_lshift(bit:_and(0, 255),24)
	c = bit:_or(c, bit:_lshift(bit:_and(r, 255),16))
	c = bit:_or(c, bit:_lshift(bit:_and(g, 255),8))
	c = bit:_or(c, bit:_and(b, 255))

	return c
end

--版本值
function appdf.VersionValue(p,m,s,b)

	local v = 0
	if p ~= nil then
		v = bit:_or(v,bit:_lshift(p,24))
	end
	if m ~= nil then
		v = bit:_or(v,bit:_lshift(m,16))
	end
	if s ~= nil then
		v = bit:_or(v,bit:_lshift(s,8))
	end
	if b ~= nil then
		v = bit:_or(v,b)
	end

	return v
end

---根據名稱取node
function appdf.getNodeByName(node,name)
	local curNode = node:getChildByName(name)
	if curNode then
		return curNode
	else
		local  nodeTab = node:getChildren()
		if #nodeTab>0 then		
			for i=1,#nodeTab do
				local  result = appdf.getNodeByName(nodeTab[i],name)
				if result then					
					return result
				end 
			end
		end

	end
end

--判断是否对象
function appdf.isObject(obj)
    return (obj.__cname ~= nil)
end

--urldecode
function appdf.decodeURI(s)
    s = string.gsub(s, '%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
    return s
end

--urlencode
function appdf.encodeURI(s)
    s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
    return string.gsub(s, " ", "+")
end

function appdf.initListener(eventList,handler,lNode)
	local tblister = {}
	for i = 1, #eventList do
		local listener = cc.EventListenerCustom:create(eventList[i],handler)
		local dispatcher = lNode:getEventDispatcher()
		dispatcher:addEventListenerWithFixedPriority(listener, 1)
		table.insert(tblister,listener)
	end
	return tblister
end

function appdf.removeListener(eventList)
	for k,v in pairs(eventList) do
		cc.Director:getInstance():getEventDispatcher():removeEventListener(v)
	end
end

function appdf.PostCustomEvent(evname,data,srcnode)
	local event = cc.EventCustom:new(evname)
	event.name = evname
	event.data = data
	srcnode:getEventDispatcher():dispatchEvent(event)
end