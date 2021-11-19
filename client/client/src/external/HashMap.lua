--[[
    --HashMap 
    --1. 支持添加 长整型量级 次元素，更多就溢出了
    --2. HashMap 的实例数目也是 长整型量级 限制的
    @author xiaowa
    @date 2015.5.17
--]]

local HashMap = HashMap or class("HashMap")

--HashMap 的实例编号
HashMap.Instance_num = HashMap.Instance_num or 0

function HashMap:ctor()
    self.element_count_ = 0
    self.map_key_ = {}
    self.map_value_ = {}
    --用于存字符串key 的表
    self.map_strIskey_ = {}
    --hashmap 实例 id 号
    self.class.Instance_num = self.class.Instance_num+1
    self.map_id_ = self.class.Instance_num
end
--[[
    @function 为hashmap 添加元素
    @reutrn nil
--]]
function HashMap:setElement(key,value)
    assert(type(key) == "table" or type(key) == "string", string.format("%s:setElement() - invalid key", self.class.__cname))
    --这里值是未限定类型的，只会从key 查找到value
    --assert(type(value) == "table", string.format("%s:setElement() - invalid value", self.class.__cname))

    if type(key) == "string" then
        self.map_strIskey_[key] = value
    elseif type(key) == "table" then
        local num = self:addElement_(key, value)
        --为用户表添加 hashmap 字段
        key["hashmap_" .. self.map_id_ .. "_@@key_"] = num --意思是key表是作为那个hashmap 实例的key
    else
        printLog("BUG","HashMap:setElement invalid")
    end
end
--[[
    @function 只能执行小于长整型量级次
    @return element NO.
--]]
function HashMap:addElement_(key,value)
    self.element_count_ = self.element_count_+1
    self.map_key_[self.element_count_] = key
    self.map_value_[self.element_count_] = value
    return self.element_count_
end
--[[
    @function 判断是否有某个键
    @return bool
--]]
function HashMap:findKey(key)
    if type(key) == "string" then
        if self.map_strIskey_[key] then
            return true
        end
        return false
    elseif type(key) == "table" then
        if key["hashmap_" .. self.map_id_ .. "_@@key_"] then
            return true
        end
        return false
    end
end
--[[
    @function 获得值
    @param key
    @return 
--]]
function HashMap:getValue(key)
    if type(key) == "string" then
        return self.map_strIskey_[key]
    elseif type(key) == "table" then
        local num = key["hashmap_" .. self.map_id_ .. "_@@key_"]
        if num then
            return self.map_value_[num]
        end
        return nil
    end
end
--[[
    @function 删除元素
    @param table#key
    @return table#key or string#key,table#value
--]]
function HashMap:delElement(key)
    local key_,value_ = key
    if type(key) == "string" then
        value_ = self.map_strIskey_[key_]
        self.map_strIskey_[key_] = nil
        return key_,value_
    elseif type(key) == "table" then
        local num = key["hashmap_" .. self.map_id_ .. "_@@key_"]
        if num then
            key["hashmap_" .. self.map_id_ .. "_@@key_"] = nil
            self.map_key_[num] = nil
            self.map_value_[num] = nil
        end
    end
end

return HashMap