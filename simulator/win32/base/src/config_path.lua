
-- 正式 配置地址
	
local URL_REQUEST_LIST = {
   "http://8.212.16.136:9080/" --"http://47.57.14.222:9080/"
}	
local WS_URL={

    ws 			=		"8.212.16.136",--"47.57.230.190",--"47.57.14.222",
	port        =       9080,                                     --大厅端口
}
-- local URL_REQUEST_LIST = {
--     "http://techpnr.top:9080/"
-- }	
-- local WS_URL={

--     ws =        "techpnr.top",
--     port        =       9080,                                     --大厅端口
-- }

--  测试 配置地址
local TEST_URL_REQUEST_LIST = {
   "http://127.0.0.1:9080"
}

local TEST_WS_URL={
    ws          ="127.0.0.1",  --"127.0.0.1",--老郑
    port        ="9080"                                   --大厅端口"9080"--

}

office_url = "118.190.157.238:8886/weixinx.html"

return {URL_REQUEST_LIST,TEST_URL_REQUEST_LIST,WS_URL,TEST_WS_URL}