--[[
	版本保存
]]
local Version = class("Version", function()
   local node = display.newNode()
   return node
end)	

function Version:ctor()
   self:retain()
   local sp = ""
   local fileUitls=cc.FileUtils:getInstance()
   --保存路径
   self._path = device.writablePath.."version.plist"
   --保存信息
   self._versionInfo  = fileUitls:getValueMapFromFile(self._path)
   if not self._versionInfo or not self._versionInfo.cid then
      local _path = "version.plist"
      self._versionInfo = fileUitls:getValueMapFromFile( _path)
   end  
   self._downUrl = nil
end


--设置是否加载压缩包
function Version:setNeedZip(version)
   self._versionInfo["zip"] = version
end

--获取是否加载压缩包
function Version:getNeedZip(kindid)
   return self._versionInfo["zip"] 
end

--设置安装包版本
function Version:setHostVersion(version)
   self._versionInfo["host"] = version
end

--获取安装包版本
function Version:getHostVersion(kindid)
   return self._versionInfo["host"] 
end

--设置初始client版本
function Version:setBeganVersion(version)
   self._versionInfo["beganClient"] = version
end

--获取初始client版本
function Version:getBeganVersion(kindid)
   return self._versionInfo["beganClient"] 
end

--设置渠道号
function Version:setChannelID(cid)
   self._versionInfo["cid"] = cid
end

--获取渠道号
function Version:getChannelID()
   return self._versionInfo["cid"] 
end

--获取是否平板
function Version:getIsPad()
   return self._versionInfo["pad"] 
end

--获取
function Version:getPadGameid()
   return self._versionInfo["padgameid"] 
end


--设置资源版本
function Version:setResVersion(version,kindid)
   print("setResVersion>>>>",version,kindid)
   -- print(debug.traceback("", 2))
   if not kindid then
      self._versionInfo["res_client"] = version
   else
      self._versionInfo["res_game_"..kindid] = version
   end
   self:save()
end

--获取资源版本
function Version:getResVersion(kindid)
   local vid
   if not kindid then 
      vid = self._versionInfo["res_client"]
   else
      vid =  self._versionInfo["res_game_"..kindid]
   end
   return vid
end

--是否测试版本
function Version:getIsTest()
   return self._versionInfo["isTest"] 
end

--是否测试版本
function Version:getIsOpen()
   return self._versionInfo["isOpen"] 
end

--保存版本
function Version:save()
   cc.FileUtils:getInstance():writeToFile(self._versionInfo,self._path)
end

--获取苹果审核价格列表
function Version:getPriceList()
   return self._versionInfo["iosprice"] 
end

--获取苹果审核游戏列表
function Version:getGameList()
   return self._versionInfo["gamelist"] 
end

return Version