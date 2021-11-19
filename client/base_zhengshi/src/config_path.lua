
-- 正式 配置地址
	
local URL_REQUEST_LIST = {
   "http://xnzyyy120.com:9080"  --"http://live213.cn:9080/"
}	
local WS_URL={

    ws 			=		"xnzyyy120.com",   --"live213.cn",
	port        =       9080,                                     --大厅端口
}

--  测试 配置地址
local TEST_URL_REQUEST_LIST = {
   "http://114.215.153.170:7004"
}

local TEST_WS_URL={
    ws          ="127.0.0.1",  --"127.0.0.1",--老郑
    port        ="7004"                                   --大厅端口"9080"--

}

office_url = "127.0.0.1"

return {URL_REQUEST_LIST,TEST_URL_REQUEST_LIST,WS_URL,TEST_WS_URL}