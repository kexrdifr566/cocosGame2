local SDKUtils = { }

function SDKUtils.initBaseSDK( ... )

    local isinit= false
    local loginJson= {line="line",lineName="lineName",gamename=appdf.gamename or "掌心电玩",gameid=appdf.gameid or "ENG-ZXDW-001"}
    if device.platform == "ios" then
        local luaoc = require "cocos.cocos2d.luaoc"
        local ok,ret  = luaoc.callStaticMethod("AppController","initBaseSDK",loginJson)
        print("ios SDKUtils.isInit>>>>>",ok,ret)
        isinit =  ret
    elseif device.platform == "android" then
		local luaj = require "cocos.cocos2d.luaj"
        loginJson=json.encode(loginJson)
        local javaClassName = "common/SDKBridge"
        local javaMethodName = "initBaseSDK"
        -- local javaParams = {loginJson,cb}
        local javaMethodSig = "()Z"
        local ok,ret = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
        print("tag>>>>>>>>>>>>>>isInit:",ret)
        isinit =  ret
    end
    return isinit
 --   return false
end

--==============================--
--desc:客户端是否已经初始化sdk
--time:2017-05-22 10:08:04
--@args:
--return 
--==============================--

function SDKUtils.isInit( ... )

    local isinit= false
    local loginJson= {line="line",lineName="lineName"}
    if device.platform == "ios" then
        local luaoc = require "cocos.cocos2d.luaoc"
        local ok,ret  = luaoc.callStaticMethod("AppController","isInitSDK")
        print("ios SDKUtils.isInit>>>>>",ok,ret)
        isinit =  ret
    elseif device.platform == "android" then
		local luaj = require "cocos.cocos2d.luaj"
        loginJson=json.encode(loginJson)
        local javaClassName = "common/SDKBridge"
        local javaMethodName = "isInitSdk"
        -- local javaParams = {loginJson,cb}
        local javaMethodSig = "()Z"
        local ok,ret = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
        print("tag>>>>>>>>>>>>>>isInit:",ret)
        isinit =  ret
    end
    return isinit
 --   return false
end

function SDKUtils.initSDKConfig()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if cc.PLATFORM_OS_WINDOWS == targetPlatform then
        return
    end
	if  device.platform == "ios" then
		local loginJson= {line="line",lineName="lineName",gamename=appdf.gamename or "掌心电玩",gameid=appdf.gameid or "掌心电玩"}
		local luaoc = require "cocos.cocos2d.luaoc"
		local ok,ret  = luaoc.callStaticMethod("AppController","initBaseSDK",loginJson)
		print("initSDKConfig>>>>>>>>>>",appdf.basesdk)
		local cfgJson= appdf.basesdk and cjson.decode(appdf.basesdk) or {sdkurl="t.ppcp213.com",kfurl="kf.ppcp213.com",sdkport=8000,kfport=8000}
		local luaoc = require "cocos.cocos2d.luaoc"
		local ok,ret  = luaoc.callStaticMethod("AppController","initBaseSDKConfig",cfgJson)
	end
	if device.platform == "android" then 
		local loginJson= appdf.basesdk and cjson.decode(appdf.basesdk) or {sdkurl="t.ppcp213.com",kfurl="kf.ppcp213.com",sdkport=8000,kfport=8000}
		loginJson=json.encode(loginJson)
		local luaj = require "cocos.cocos2d.luaj"
		local javaClassName = "common/SDKBridge"
        	local javaMethodName = "initBaseSDKConfig"
		local javaMethodSig = "(Ljava/lang/String;)V"
		local javaParams = {loginJson}
		local ok,ret = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
	end

end

--==============================--
--desc:调用sdk  登录接口
--time:2017-05-22 10:03:37
--@loginJson:登录参数  {line="line",lineName="lineName"}
--@cb:回调函数
--return 
--==============================--
function SDKUtils.login( loginJson,cb )
    loginJson.line = "line"
    loginJson.lineName = "lineName"
    local callParams = {loginJson,cb}
    if device.platform == "ios" then
        loginJson.functionId = cb
	    local luaoc = require "cocos.cocos2d.luaoc"
        local ok,ret  = luaoc.callStaticMethod("AppController","showSDKLogin",loginJson)
        if not ok then
            print("luaoc error:" .. ret)        
        end
    elseif device.platform == "android" then
		local luaj = require "cocos.cocos2d.luaj"
        loginJson=json.encode(loginJson)
        print("tag>>>>>>>>>>>>>>loginJson:",loginJson)
        local javaClassName = "common/SDKBridge"
        local javaMethodName = "showSDKLogin"
        local javaParams = {loginJson,cb}
        local javaMethodSig = "(Ljava/lang/String;I)V"
        luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    end
end

function SDKUtils.guestlogin( loginJson,cb )
    loginJson.line = "line"
    loginJson.lineName = "lineName"
    local callParams = {loginJson,cb}
    if device.platform == "ios" then
        loginJson.functionId = cb
	    local luaoc = require "cocos.cocos2d.luaoc"
        local ok,ret  = luaoc.callStaticMethod("AppController","showGuestSDKLogin",loginJson)
        if not ok then
            print("luaoc error:" .. ret)        
        end
    elseif device.platform == "android" then
		local luaj = require "cocos.cocos2d.luaj"
        loginJson=json.encode(loginJson)
        print("tag>>>>>>>>>>>>>>loginJson:",loginJson)
        local javaClassName = "common/SDKBridge"
        local javaMethodName = "showGuestSDKLogin"
        local javaParams = {loginJson,cb}
        local javaMethodSig = "(Ljava/lang/String;I)V"
        luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    end
end

function SDKUtils.accountlogin( loginJson,cb )
    loginJson.line = "line"
    loginJson.lineName = "lineName"
    local callParams = {loginJson,cb}
    if device.platform == "ios" then
        loginJson.functionId = cb
	    local luaoc = require "cocos.cocos2d.luaoc"
        local ok,ret  = luaoc.callStaticMethod("AppController","showAccountSDKLogin",loginJson)
        if not ok then
            print("luaoc error:" .. ret)        
        end
    elseif device.platform == "android" then
		local luaj = require "cocos.cocos2d.luaj"
        loginJson=json.encode(loginJson)
        print("tag>>>>>>>>>>>>>>loginJson:",loginJson)
        local javaClassName = "common/SDKBridge"
        local javaMethodName = "showAccountSDKLogin"
        local javaParams = {loginJson,cb}
        local javaMethodSig = "(Ljava/lang/String;I)V"
        luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    end
end

function SDKUtils.autologin( loginJson,cb )
    loginJson.line = "line"
    loginJson.lineName = "lineName"
    local callParams = {loginJson,cb}
    if device.platform == "ios" then
        loginJson.functionId = cb
	    local luaoc = require "cocos.cocos2d.luaoc"
        local ok,ret  = luaoc.callStaticMethod("AppController","showAutoLogin",loginJson)
        if not ok then
            print("luaoc error:" .. ret)        
        end
    elseif device.platform == "android" then
		local luaj = require "cocos.cocos2d.luaj"
        loginJson=json.encode(loginJson)
        print("tag>>>>>>>>>>>>>>loginJson:",loginJson)
        local javaClassName = "common/SDKBridge"
        local javaMethodName = "showAutoLogin"
        local javaParams = {loginJson,cb}
        local javaMethodSig = "(Ljava/lang/String;I)V"
        luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    end
end
--==============================--
--desc:调用sdk  切换接口
--time:2017-06-01 10:27:43
--@loginJson:
--@cb:  --没用调用到 
--return 
--==============================--
function SDKUtils.SwitchUserBySDK( loginJson,cb)
    local loginJson= {line="line",lineName="lineName"}
    if device.platform == "ios" then
        luaoc.callStaticMethod("AppController","SwitchUserBySDK",loginJson)
    elseif device.platform == "android" then
		local luaj = require "cocos.cocos2d.luaj"
        loginJson=json.encode(loginJson)
        local javaClassName = "common/SDKBridge"
        local javaMethodName = "SwitchUserBySDK"
        local javaParams = {loginJson,cb}
        local javaMethodSig = "(Ljava/lang/String;I)V"
        dump(javaParams,"javaParams>>>>")
        luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    end
end

--==============================--
--desc:调用sdk  退出接口
--time:2017-06-02 07:15:28
--return 
--==============================--
function SDKUtils.LogoutSDK(cb)
    if device.platform == "ios" then
        luaoc.callStaticMethod("AppController","LogoutSDK")
    elseif device.platform == "android" then
		local luaj = require "cocos.cocos2d.luaj"
        local javaClassName = "common/SDKBridge"
        local javaMethodName = "LogoutSDK"
        -- local javaParams = {"",cb}
        -- local javaMethodSig = "(Ljava/lang/String;I)V"
        luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    end
end


--==============================--
--desc:调用sdk  用户中心接口
--time:2017-06-01 10:29:00
--@loginJson:
--@cb:
--return 
--==============================--

function SDKUtils.OpenUsercenterBySDK()
    -- local loginJson= {line="line",lineName="lineName"}
    if device.platform == "ios" then
        luaoc.callStaticMethod("AppController","OpenUsercenterBySDK",loginJson)
    elseif device.platform == "android" then
		local luaj = require "cocos.cocos2d.luaj"
        local javaClassName = "common/SDKBridge"
        local javaMethodName = "OpenUsercenterBySDK"
        -- local javaParams = {loginJson,cb}
        -- local javaMethodSig = "(Ljava/lang/String;I)V"
        luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    end
end

--==============================--
--desc:调用sdk  支付接口
--time:2017-05-22 10:08:29
--@payJson:支付参数  {amount=data.amount,productName=data.productName,productId=data.productId,extra = data.extra ,serverid=1,channel=1,prepaid_id=1,moneyName="rmb"}    
--@cb:回调函数
--return 
--==============================--

function SDKUtils.pay( payJson,cb )
    if not appdf.bingPhone or checkint(appdf.bingPhone) < 1 then
        -- local luaoc = require "cocos.cocos2d.luaoc"
        -- luaoc.callStaticMethod("AppController","bindPhone")
        -- return
    end
    -- dump(payJson,"payJson>>>")
    if device.platform == "ios" then
        -- local iosParams = {payJson,cb}
        payJson.functionId = cb
        local luaoc = require "cocos.cocos2d.luaoc"
        luaoc.callStaticMethod("AppController","showSDKPay",payJson)
    elseif device.platform == "android" then
		local luaj = require "cocos.cocos2d.luaj"
        payJson=json.encode(payJson)
        print("tag>>>>>>>>>>>>>>payJson:",payJson)
        local javaClassName = "common/SDKBridge"
        local javaMethodName = "PaySDK"
        local javaParams = {payJson,cb}
        local javaMethodSig = "(Ljava/lang/String;I)V"
        luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    end
end
 
--==============================--
--desc:调用sdk  结算接口
--time:2017-05-22 04:31:35
--@moneyJson: money=100,cpOrderid="20152585",extra="extra"
--@cb:回调函数
--return 
--==============================--
function SDKUtils.GetMoneyBySDK( moneyJson,cb ,getcb)
    -- dump(moneyJson,"json>>>")
    if device.platform == "ios" then
        moneyJson.functionId = cb
        moneyJson.getfunctionId = getcb
        local luaoc = require "cocos.cocos2d.luaoc"
        luaoc.callStaticMethod("AppController","verifyPayPassword",moneyJson)
    elseif device.platform == "android" then
		local luaj = require "cocos.cocos2d.luaj"
        moneyJson=json.encode(moneyJson)
        print("tag>>>>>>>>>>>>>>payJson:",moneyJson)
        local javaClassName = "common/SDKBridge"
        local javaMethodName = "verifyPayPassword"
        local javaParams = {moneyJson,cb}
        local javaMethodSig = "(Ljava/lang/String;I)V"
        luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    end
end



function SDKUtils.toBindPayAccout( bindJson,cb )
    -- dump(moneyJson,"json>>>")
    if device.platform == "ios" then
        bindJson.functionId = cb
        local luaoc = require "cocos.cocos2d.luaoc"
        luaoc.callStaticMethod("AppController","bindPayAccount",bindJson)
    elseif device.platform == "android" then
		local luaj = require "cocos.cocos2d.luaj"
        bindJson=json.encode(bindJson)
        print("tag>>>>>>>>>>>>>>payJson:",bindJson)
        local javaClassName = "common/SDKBridge"
        local javaMethodName = "bindPayAccount"
        local javaParams = {bindJson,cb}
        local javaMethodSig = "(Ljava/lang/String;I)V"
        luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    end
end

function SDKUtils.setBindPayAccout( bindJson,cb )
    -- dump(moneyJson,"json>>>")
    if device.platform == "ios" then
        bindJson.functionId = cb
        local luaoc = require "cocos.cocos2d.luaoc"
        luaoc.callStaticMethod("AppController","setSelectedAccount",bindJson)
    elseif device.platform == "android" then
		local luaj = require "cocos.cocos2d.luaj"
        bindJson=json.encode(bindJson)
        print("tag>>>>>>>>>>>>>>payJson:",bindJson)
        local javaClassName = "common/SDKBridge"
        local javaMethodName = "setSelectedAccount"
        local javaParams = {bindJson,cb}
        local javaMethodSig = "(Ljava/lang/String;I)V"
        luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    end
end


function SDKUtils.setPayPassword( pwdJson,cb )
    -- dump(moneyJson,"json>>>")
    if device.platform == "ios" then
        pwdJson.functionId = cb
        local luaoc = require "cocos.cocos2d.luaoc"
        luaoc.callStaticMethod("AppController","setPayPassword",pwdJson)
    elseif device.platform == "android" then
		local luaj = require "cocos.cocos2d.luaj"
        pwdJson=json.encode(pwdJson)
        print("tag>>>>>>>>>>>>>>payJson:",pwdJson)
        local javaClassName = "common/SDKBridge"
        local javaMethodName = "setPayPassword"
        local javaParams = {pwdJson,cb}
        local javaMethodSig = "(Ljava/lang/String;I)V"
        luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    end
end

function SDKUtils.resetPayPassword( pwdJson,cb )
    -- dump(moneyJson,"json>>>")
    if device.platform == "ios" then
        pwdJson.functionId = cb
        local luaoc = require "cocos.cocos2d.luaoc"
        luaoc.callStaticMethod("AppController","resetPayPassword",pwdJson)
    elseif device.platform == "android" then
		local luaj = require "cocos.cocos2d.luaj"
        pwdJson=json.encode(pwdJson)
        print("tag>>>>>>>>>>>>>>payJson:",pwdJson)
        local javaClassName = "common/SDKBridge"
        local javaMethodName = "resetPayPassword"
        local javaParams = {pwdJson,cb}
        local javaMethodSig = "(Ljava/lang/String;I)V"
        luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    end
end

function SDKUtils.hasSetPayPassword(cb)
    -- dump(moneyJson,"json>>>")
    if device.platform == "ios" then
        
        local luaoc = require "cocos.cocos2d.luaoc"
        local ok,ret=luaoc.callStaticMethod("AppController","hasSetPayPassword",{functionId = cb})
        -- print("hasSetPayPassword>>>>>>",ok,ret)
        -- return ret
    elseif device.platform == "android" then
		local luaj = require "cocos.cocos2d.luaj"
        moneyJson=json.encode(moneyJson)
        print("tag>>>>>>>>>>>>>>payJson:",moneyJson)
        local javaClassName = "common/SDKBridge"
        local javaMethodName = "hasSetPayPassword"
        local javaParams = {moneyJson,cb}
        local javaMethodSig = "(Ljava/lang/String;I)V"
        luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    end
end

function SDKUtils.verifyPayPassword( moneyJson,cb )
    -- dump(moneyJson,"json>>>")
    if device.platform == "ios" then
        local luaoc = require "cocos.cocos2d.luaoc"
        luaoc.callStaticMethod("AppController","verifyPayPassword",moneyJson)
    elseif device.platform == "android" then
		local luaj = require "cocos.cocos2d.luaj"
        moneyJson=json.encode(moneyJson)
        print("tag>>>>>>>>>>>>>>payJson:",moneyJson)
        local javaClassName = "common/SDKBridge"
        local javaMethodName = "verifyPayPassword"
        local javaParams = {moneyJson,cb}
        local javaMethodSig = "(Ljava/lang/String;I)V"
        luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    end
end

-- ==============================--
-- desc:
-- @_cb:回调函数
-- ==============================--
function SDKUtils.getBindPhone(_cb)
    print("getBindPhone>>>>>>")
    local ok,ret
    local cb = function( ... )
        _cb(ret)
    end
    if device.platform == "ios" then
        local luaoc = require "cocos.cocos2d.luaoc"
        ok,ret = luaoc.callStaticMethod("AppController","getBindPhone")
        print("getBindPhone>>>>>",ok,ret)
    elseif device.platform == "android" then
		local luaj = require "cocos.cocos2d.luaj"
        local javaClassName = "common/SDKBridge"
        local javaMethodName = "getBindPhone"
        local javaParams = cb
        local javaMethodSig = "()Ljava/lang/String;"
        ok,ret = luaj.callStaticMethod(javaClassName, javaMethodName, {}, javaMethodSig)
    end
    return ret
end


function SDKUtils.toBindPhone(bindjson,_cb)
    print("getBindPhone>>>>>>")
    local ok,ret
    local cb = function( resp )
        if _cb then
            _cb(resp)
        end 
    end
    bindjson.phone = "86"..bindjson.phone
    if device.platform == "ios" then
        bindjson.functionId = cb
        local luaoc = require "cocos.cocos2d.luaoc"
        ok,ret = luaoc.callStaticMethod("AppController","bindPhone",bindjson)
        print("getBindPhone>>>>>",ok,ret)
    elseif device.platform == "android" then
		local luaj = require "cocos.cocos2d.luaj"
        local javaClassName = "common/SDKBridge"
        local javaMethodName = "bindPhone"
		bindjson = json.encode(bindjson)
        local javaParams = {bindjson,cb}
        local javaMethodSig = "(Ljava/lang/String;I)V"
        ok,ret = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    end
    return ret
end


function  SDKUtils.onSDKCode( codejson ,cb)
	if device.platform == "ios" then
		local luaoc = require "cocos.cocos2d.luaoc"
		codejson.phone = "86"..codejson.phone
		codejson.functionId = cb
		local ok,ret  = luaoc.callStaticMethod("AppController","onSDKCode",codejson)
    elseif device.platform == "android" then
		local luaj = require "cocos.cocos2d.luaj"
        local javaClassName = "common/SDKBridge"
        local javaMethodName = "onSDKCode"
        local javaParams = {"86"..codejson.phone,cb}
		
        local javaMethodSig = "(Ljava/lang/String;I)V"
        local ok,ret = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
	end
end

function  SDKUtils.getKefuService(  )
	if device.platform == "ios" then
    local luaoc = require "cocos.cocos2d.luaoc"
    local ok,ret  = luaoc.callStaticMethod("AppController","customerService")
	 elseif device.platform == "android" then
		local luaj = require "cocos.cocos2d.luaj"
        local javaClassName = "common/SDKBridge"
        local javaMethodName = "customerService"
      --  local javaParams = cb
        local javaMethodSig = "()V"
        ok,ret = luaj.callStaticMethod(javaClassName, javaMethodName, {}, javaMethodSig)
	end
   
end

function  SDKUtils.isBindPhone(  )
	if device.platform == "ios" then
    local luaoc = require "cocos.cocos2d.luaoc"
    local ok,ret  = luaoc.callStaticMethod("AppController","isBindPhone")
    return ret
	 elseif device.platform == "android" then
		local luaj = require "cocos.cocos2d.luaj"
        local javaClassName = "common/SDKBridge"
        local javaMethodName = "isBindPhone"
      --  local javaParams = cb
        local javaMethodSig = "()Z"
        ok,ret = luaj.callStaticMethod(javaClassName, javaMethodName, {}, javaMethodSig)
		 return ret
	end
end

function  SDKUtils.getBankerAccountList(cb )
	if device.platform == "ios" then
     local luaoc = require "cocos.cocos2d.luaoc"
    local ok,ret  = luaoc.callStaticMethod("AppController","getAccountList",{functionId=cb})
    return ret
	elseif device.platform == "android" then
		local luaj = require "cocos.cocos2d.luaj"
        local javaClassName = "common/SDKBridge"
        local javaMethodName = "getAccountList"
        local javaParams = {cb}
        local javaMethodSig = "(I)V"
        ok,ret = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
		 return ret
	end
end

SDKUtils.phoneType = {
    ["iPhone4,1"]="iPhone 4S",
    ["iPhone5,1"]="iPhone 5",
    ["iPhone5,2"]="iPhone 5",
    ["iPhone5,3"]= "iPhone 5c",
    ["iPhone5,4"]= "iPhone 5c",
    ["iPhone6,1"]= "iPhone 5s",
    ["iPhone6,2"]= "iPhone 5s",
    ["iPhone7,1"]= "iPhone 6 Plus",
    ["iPhone7,2"]= "iPhone 6",
    ["iPhone8,1"]= "iPhone 6s",
    ["iPhone8,2"]= "iPhone 6s Plus",
    ["iPhone8,4"]= "iPhone SE",
    ["iPhone9,1"]= "iPhone 7",
    ["iPhone9,2"]= "iPhone 7 Plus",
    ["iPad4,1"]= "iPad Air",
    ["iPad4,2"]= "iPad Air",
    ["iPad4,3"]= "iPad Air",
    ["iPad4,4"]= "iPad Mini",
    ["iPad4,5"]= "iPad Mini",
    ["iPad4,6"]= "iPad Mini",
}

return SDKUtils