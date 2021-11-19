--
-- Author: zhong
-- Date: 2016-07-29 17:45:30
--
local Bridge_android = {}
local luaj = require "cocos.cocos2d.luaj"
-- local UTILS_PACKAGE_NAME = "qipai/weixiao/utils/Utils"


-- function Bridge_android.getPackageName()
--     local cur_package_ver =  cc.UserDefault:getInstance():getStringForKey("package_ver") or ""
--     if cur_package_ver < "6.0" then
--         return "qipai/weixiao/dwc"
--     end
--     local sigs = "()Ljava/lang/String;"    
--     local ok,ret = luaj.callStaticMethod(UTILS_PACKAGE_NAME,"getInstallPackageName",{},sigs)
--     if not ok then
--         print("luaj error:" .. ret)
--         return ""
--     else
--         print("The ret is:" .. ret)
--         return string.gsub(ret,'%.', '%/')
--     end
-- end

local BRIDGE_CLASS = "org/cocos2dx/lua/AppActivity"
--print("BRIDGE_CLASS>>>>>",BRIDGE_CLASS,appdf.channelId)


--获取相册地址
function Bridge_android.getExternalStorageDirectory(path,filename)
    local cur_package_ver =  cc.UserDefault:getInstance():getStringForKey("package_ver") or ""
    if cur_package_ver < "5.0" then
        return
    end
    local args = { path,filename or "" }
    local sigs = "(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;"    
    local ok,ret = luaj.callStaticMethod(BRIDGE_CLASS,"getExternalStorageDirectory",args,sigs)
    if not ok then
        print("luaj error:" .. ret)
        return ""
    else
        print("The ret is:" .. ret)
        return ret.."/"
    end
end
--获取设备id
function Bridge_android.groupCode()
    local sigs = "()Ljava/lang/String;"    
    local ok,ret = luaj.callStaticMethod(BRIDGE_CLASS,"groupCode",{},sigs)
    if not ok then
        --print("luaj error:" .. ret)
        return nil
    else
        --print("The ret is:" .. ret)
        local str =ret 
        if str=="" then
             return nil
        else
             return ret
        end
       
    end
end
--获取设备id
function Bridge_android.getMachineId()
    local sigs = "()Ljava/lang/String;"    
    local ok,ret = luaj.callStaticMethod(BRIDGE_CLASS,"getUUID",{},sigs)
    if not ok then
        print("luaj error:" .. ret)
        return "A501164B366ECFC"..os.time()
    else
        print("The ret is:" .. ret)
        return md5(ret)
    end
end

--获取设备ip
function Bridge_android.getClientIpAdress()
    local sigs = "()Ljava/lang/String;"
    local ok,ret = luaj.callStaticMethod(BRIDGE_CLASS,"getHostAdress",{},sigs)
    if not ok then
        print("luaj error:" .. ret)
        return "192.168.1.1"
    else
        print("The ret is:" .. ret)
        return ret
    end
end

--获取外部存储可写文档目录
function Bridge_android.getExtralDocPath()
    local sigs = "()Ljava/lang/String;"
    local ok,ret = luaj.callStaticMethod(BRIDGE_CLASS,"getSDCardDocPath",{},sigs)
    if not ok then
        print("luaj error:" .. ret)
        return device.writablePath
    else
        print("The ret is:" .. ret)
        return ret
    end
end

--选择图片
function Bridge_android.pickImg(callback, url,userid,probleid,sign)
    local args = { callback, url,userid,probleid,sign }
    if nil == callback or type(callback) ~= "function" then
    	print("user default callback fun")

    	local function callbackLua(param)
	        if type(param) == "string" then
	        	print(param)
	        end        
	    end
    	args = { callbackLua, url,userid,probleid,sign }
    end    
    
    local sigs = "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V"
    local ok,ret  = luaj.callStaticMethod(BRIDGE_CLASS,"pickImg",args,sigs)
    if not ok then
        print("luaj error:" .. ret)       
    end
end

--选择图片
function Bridge_android.pickSignImg(callback)
    local args = { callback}
    if nil == callback or type(callback) ~= "function" then
    	print("user default callback fun")

    	local function callbackLua(param)
	        if type(param) == "string" then
	        	print(param)
	        end        
	    end
    	args = { callbackLua}
    end    
    
    local sigs = "(I)V"
    local ok,ret  = luaj.callStaticMethod(BRIDGE_CLASS,"pickSignImg",args,sigs)
    if not ok then
        print("luaj error:" .. ret)       
    end
end


--配置支付、登陆相关
function Bridge_android.thirdPartyConfig(thirdparty, configTab)
    local args = {thirdparty, cjson.encode(configTab)}
    local sigs = "(ILjava/lang/String;)V"
    local ok,ret  = luaj.callStaticMethod(BRIDGE_CLASS,"thirdPartyConfig",args,sigs)
    if not ok then
        print("luaj error:" .. ret)        
    end
end

function Bridge_android.configSocial(socialTab)
    local title = socialTab.title
    local content = socialTab.content
    local url = socialTab.url

    local args = {title, content, url}
    local sigs = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V"
    local ok,ret  = luaj.callStaticMethod(BRIDGE_CLASS,"socialShareConfig",args,sigs)
    if not ok then
        print("luaj error:" .. ret)        
    end
end

--第三方登陆
function Bridge_android.thirdPartyLogin(thirdparty, callback)
    local args = { thirdparty, callback }
    local sigs = "(II)V"
    local ok,ret  = luaj.callStaticMethod(BRIDGE_CLASS,"thirdLogin",args,sigs)
    if not ok then
        local msg = "luaj error:" .. ret
        print(msg)  
        return false, msg   
    else  
        return true     
    end
end

--分享
function Bridge_android.startShare(callback)
    local sigs = "(I)V"
    local ok,ret  = luaj.callStaticMethod(BRIDGE_CLASS,"startShare",{callback},sigs)
    if not ok then
        local msg = "luaj error:" .. ret
        print(msg)  
        return false, msg   
    else  
        return true     
    end
end

--自定义分享
function Bridge_android.customShare( title, content,url, img, imgOnly, callback )
    local sigs = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V"
    local ok,ret  = luaj.callStaticMethod(BRIDGE_CLASS,"customShare",{title, content, url, img, imgOnly, callback},sigs)
    if not ok then
        local msg = "luaj error:" .. ret
        print(msg)  
        return false, msg   
    else  
        return true     
    end
end

-- 分享到指定平台
function Bridge_android.shareToTarget( target, title, content, url, img, imgOnly, callback )
    local sigs = "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V"
    local ok,ret  = luaj.callStaticMethod(BRIDGE_CLASS,"shareToTarget",{target, title, content, url, img, imgOnly, callback},sigs)
    if not ok then
        local msg = "luaj error:" .. ret
        print(msg)  
        return false, msg   
    else  
        return true     
    end
end

--第三方支付
function Bridge_android.thirdPartyPay(thirdparty, payparamTab, callback)
    local args = { thirdparty, cjson.encode(payparamTab), callback }
    local sigs = "(ILjava/lang/String;I)V"
    local ok,ret  = luaj.callStaticMethod(BRIDGE_CLASS,"thirdPartyPay",args,sigs)
    if not ok then
        local msg = "luaj error:" .. ret
        print(msg)  
        return false, msg   
    else  
        return true     
    end
end

--获取竣付通支付列表
function Bridge_android.getPayList(token, callback)
    local args = { token, callback }
    local sigs = "(Ljava/lang/String;I)V" 
    local ok,ret  = luaj.callStaticMethod(BRIDGE_CLASS,"getPayList",args,sigs)
    if not ok then
        local msg = "luaj error:" .. ret
        print(msg)  
        return false, msg   
    else  
        return true     
    end
end

function Bridge_android.isPlatformInstalled(thirdparty)
    local args = { thirdparty }
    local sigs = "(I)Z" 
    local ok,ret  = luaj.callStaticMethod(BRIDGE_CLASS,"isPlatformInstalled",args,sigs)
    if not ok then
        local msg = "luaj error:" .. ret
        print(msg)  
        return false, msg   
    else  
        return ret
    end
end

function Bridge_android.setPlaybackRate( rate )
    local args = { rate }
    local sigs = "(I)V" 
    local ok,ret  = luaj.callStaticMethod(BRIDGE_CLASS,"setPlaybackRate",args,sigs)
    if not ok then
        local msg = "luaj error:" .. ret
        print(msg)  
        return false, msg   
    else  
        return ret
    end
end


function Bridge_android.openRTMP( data,callback )
    local args = { data ,callback}
    local sigs = "(Ljava/lang/String;I)V" 
    local ok,ret  = luaj.callStaticMethod(BRIDGE_CLASS,"openRTMP",args,sigs)
    if not ok then
        local msg = "luaj error:" .. ret
        print(msg)  
        return false, msg   
    else  
        return ret
    end
end

function Bridge_android.closeRTMP( )
    -- local paramtab = data
    local args = {}
    local sigs = "()V" 
    local ok,ret  = luaj.callStaticMethod(BRIDGE_CLASS,"closeRTMP",args,sigs)
    if not ok then
        local msg = "luaj error:" .. ret
        print(msg)  
        return false, msg   
    else  
        return ret
    end
end

function Bridge_android.saveImgToSystemGallery(filepath, filename)
    local args = { filepath, filename }
    local sigs = "(Ljava/lang/String;Ljava/lang/String;)Z" 
    local ok,ret = luaj.callStaticMethod(BRIDGE_CLASS,"saveImgToSystemGallery",args,sigs)
    if not ok then
        local msg = "luaj error:" .. ret
        print(msg)  
        return false, msg   
    else  
        return ret
    end
end

--==============================--
--desc:
--time:2018-09-20 11:44:23
--@versionUrl:下载地址
--@versionName:保存文件名
--@downPath:保存路径
--@pathDir:保存文件夹名
--@return 
--==============================--
function Bridge_android.downloadAPK(versionUrl, versionName,downPath,pathDir)
    local args = { versionUrl, versionName,downPath,pathDir }
    local sigs = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V" 
    local ok,ret = luaj.callStaticMethod(BRIDGE_CLASS,"downloadAPK",args,sigs)
    if not ok then
        local msg = "luaj error:" .. ret
        print(msg)  
        return false, msg   
    else  
        return ret
    end
end

function Bridge_android.installClient( filepath )
    local args = { filepath }
    local sigs = "(Ljava/lang/String;)V" 
    local ok,ret = luaj.callStaticMethod(BRIDGE_CLASS,"installClient", args, sigs)
    if not ok then
        local msg = "luaj error:" .. ret
        print(msg)  
        return false, msg   
    else  
        return ret
    end
end


function Bridge_android.checkRecordPermission()
    local args = { }
    local sigs = "()Z" 
    local ok,ret = luaj.callStaticMethod(BRIDGE_CLASS,"isHaveRecordPermission",args,sigs)
    if not ok then
        local msg = "luaj error:" .. ret
        print(msg)  
        return false, msg   
    else  
        return ret
    end
end

function Bridge_android.requestLocation( callback )
    local args = { callback }
    local sigs = "(I)V" 
    local ok,ret = luaj.callStaticMethod(BRIDGE_CLASS,"requestLocation", args, sigs)
    if not ok then
        local msg = "luaj error:" .. ret
        print(msg)  
        return false, msg   
    else  
        return ret
    end
end

function Bridge_android.metersBetweenLocation( loParam )
    local args = { cjson.encode(loParam) }
    local sigs = "(Ljava/lang/String;)Ljava/lang/String;"
    local ok,ret = luaj.callStaticMethod(BRIDGE_CLASS,"metersBetweenLocation", args, sigs)
    if not ok then
        local msg = "luaj error:" .. ret
        print(msg)  
        return false, msg   
    else  
        return ret
    end
end

function Bridge_android.requestContact( callback )
    local args = { callback }
    local sigs = "(I)V" 
    local ok,ret = luaj.callStaticMethod(BRIDGE_CLASS,"requestContact", args, sigs)
    if not ok then
        local msg = "luaj error:" .. ret
        print(msg)  
        return false, msg   
    else  
        return ret
    end
end

function Bridge_android.openBrowser(url)
    local args = { url }
    local sigs = "(Ljava/lang/String;)V" 
    local ok,ret  = luaj.callStaticMethod(BRIDGE_CLASS,"openBrowser",args,sigs)
    if not ok then
        local msg = "luaj error:" .. ret
        print(msg)  
        return false, msg   
    else  
        return true     
    end
end

function Bridge_android.copyToClipboard( msg )
    local args = { msg }
    local sigs = "(Ljava/lang/String;)Z" 
    local ok,ret  = luaj.callStaticMethod(BRIDGE_CLASS,"copyToClipboard",args,sigs)
    if not ok then
        local msg = "luaj error:" .. ret
        print(msg)  
        return 0, msg   
    else  
        return ret     
    end
end

function Bridge_android.getClipboard(callback)
    local cur_package_ver =  cc.UserDefault:getInstance():getStringForKey("package_ver") or ""
    if cur_package_ver < "6.0" then
        return ""
    end
    local args = { callback}
    if nil == callback or type(callback) ~= "function" then
    	print("user default callback fun")

    	local function callbackLua(param)
	        if type(param) == "string" then
	        	print("getClipboard>>>>",param)
	        end        
	    end
    	args = { callbackLua }
    end    
    
    local sigs = "(I)V"
    local ok,ret  = luaj.callStaticMethod(BRIDGE_CLASS,"getClipboard",args,sigs)
    if not ok then
        print("luaj error:" .. ret)       
    end
end


function Bridge_android.onInitSDK( callback )
    local args = { callback }
    local sigs = "(I)V" 
    local ok,ret = luaj.callStaticMethod(BRIDGE_CLASS,"onInitSDK", args, sigs)
    if not ok then
        local msg = "luaj error:" .. ret
        print(msg)  
        return false, msg   
    else  
        return ret
    end
end

function Bridge_android.onSendSDKLogin( )
    local args = { }
    local sigs = "()V" 
    local ok,ret = luaj.callStaticMethod(BRIDGE_CLASS,"onSendSDKLogin",args,sigs)
    if not ok then
        local msg = "luaj error:" .. ret
        print(msg)  
        return false, msg   
    else  
        return ret
    end
end

function Bridge_android.onSendSDKPay( info )
    local args = {info }
    local sigs = "(Ljava/lang/String;)V" 
    local ok,ret  = luaj.callStaticMethod(BRIDGE_CLASS,"onSendSDKPay",args,sigs)
    if not ok then
        local msg = "luaj error:" .. ret
        print(msg)  
        return false, msg   
    else  
        return ret
    end
end

function Bridge_android.onGetAgentInfo( )
    local args = { }
    local sigs = "()Ljava/lang/String;" 
    local ok,ret = luaj.callStaticMethod(BRIDGE_CLASS,"getAgentInfo",args,sigs)
    if not ok then
        local msg = "luaj error:" .. ret
        print(msg)  
        return false, msg   
    else  
        return ret
    end
end

function Bridge_android.getBindData()
    local cur_package_ver =  cc.UserDefault:getInstance():getStringForKey("package_ver") or ""
    if cur_package_ver < "6.5" then
        return ""
    end
    local sigs = "()Ljava/lang/String;"    
    local ok,ret = luaj.callStaticMethod(BRIDGE_CLASS,"getBindData",{},sigs)
    if not ok then
        print("luaj error:" .. ret)
        return ""
    else
        print("The ret is:" .. ret)
        return string.gsub(ret,'%.', '%/')
    end
end


--设置横竖屏
function Bridge_android.setOrientation(nType)
    local sigs = "(I)V"
    local ok,ret  = luaj.callStaticMethod(BRIDGE_CLASS,"setOrientation",{nType},sigs)
    if not ok then
        local msg = "luaj error:" .. ret
        print(msg)  
        return false, msg   
    else  
        return true     
    end
end

function Bridge_android.reportRegister( )
    local args = { }
    local sigs = "()v" 
    local ok,ret = luaj.callStaticMethod(BRIDGE_CLASS,"reportRegister",args,sigs)
    if not ok then
        local msg = "luaj error:" .. ret
        print(msg)  
        return false, msg   
    else  
        return ret
    end
end

function Bridge_android.upLoadImg(cb,uploadUrl,fileUrl,params,sign )
    local args = { cb,uploadUrl,fileUrl,params,sign }
    local sigs = "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V" 
    local ok,ret = luaj.callStaticMethod(BRIDGE_CLASS,"upLoadImg",args,sigs)
    if not ok then
        local msg = "luaj error:" .. ret
        print(msg)  
        return false, msg   
    else  
        return ret
    end
end


return Bridge_android