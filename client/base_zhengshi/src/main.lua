cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("base/src/")
cc.FileUtils:getInstance():addSearchPath("base/res/")

require "config"
require "cocos.init"

local breakInfoFun,xpcallFun  = require("LuaDebugjit")("localhost",7003)
cc.Director:getInstance():getScheduler():scheduleScriptFunc(breakInfoFun, 0.3, false)
--如果已经存在 __G__TRACKBACK__ 请将 debugXpCall 直接加入 __G__TRACKBACK__ 即可
--__G__TRACKBACK__ 方法不是必须 debugXpCall是实现的是在lua 脚本调用错误时进行代码错误定位 
-- function __G__TRACKBACK__(errorMessage)
--     debugXpCall();  
-- end
__G__TRACKBACK__ = function(errorMessage)
    xpcallFun()
    print("----------------------------------------")
    local msg = debug.traceback(errorMessage, 3)
    print(msg)
    print("----------------------------------------")
end

local function main()
	require("app.MyApp"):create():run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
