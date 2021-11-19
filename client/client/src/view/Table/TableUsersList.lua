local TableUsersList = TableUsersList or class("TableUsersList")
--初始化玩家列表
function TableUsersList:ctor()
    self.ChairPlayers={}
end
--添加桌子信息
function TableUsersList:addTable(roomcode,value)
    self.ChairPlayers[roomcode]=value
end
--删除桌子
function TableUsersList:delTable(roomcode)
    self.ChairPlayers[roomcode]=nil
end
--添加玩家信息
function TableUsersList:addTableUser(roomcode,tableindex,value)
    if self.ChairPlayers[roomcode] then
        self.ChairPlayers[roomcode].userList[tableindex]=value
    end
end
--删除玩家信息
function TableUsersList:delTableUser(roomcode,tableindex)
    if self.ChairPlayers[roomcode] then
        self.ChairPlayers[roomcode].userList[tableindex]=nil
    end
end
--添加庄家信息
function TableUsersList:addTableBanker(roomcode,tableindex,value)
    if self.ChairPlayers[roomcode] then
        self.ChairPlayers[roomcode].bankerList[tableindex]=value
    end
end
--删除庄家信息
function TableUsersList:delTableBanker(roomcode,tableindex,value)
     if self.ChairPlayers[roomcode] then
        self.ChairPlayers[roomcode].bankerList[tableindex]=nil
    end
end
--判断桌子信息是否存在
function TableUsersList:findKey(roomcode)
    if self.ChairPlayers[roomcode] then
        return true
    end
    return false
end
--找到该桌子上的该玩家信息
function TableUsersList:findUserKey(roomcode,userCode)
    if self.ChairPlayers[roomcode] then
        return true
    end
    return false
end
--获取该桌上上的玩家信息
function TableUsersList:getTableValue(roomcode)
     return self.ChairPlayers[roomcode]
end
return TableUsersList