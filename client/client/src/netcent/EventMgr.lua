
----------------------------------EventMgr:事件管理器--------------------------------------

EventMgr =EventMgr or {}
EventMgr.eventsMap={}
function EventMgr.inint()
	EventMgr.eventsMap = {}				--正式列表
end
function EventMgr.registerEvent(target,targetName)
    print("targetName==>"..targetName)
	EventMgr.eventsMap[targetName] = target
end
--移除事件
function EventMgr.removeEvent(targetName)
    if EventMgr.eventsMap[targetName] then
        ExternalFun.print("removeEvent=="..targetName)
        EventMgr.eventsMap[targetName]=nil
    end
    ExternalFun.dump(EventMgr.eventsMap,"EventLayer")
    --清理
    for k, v in pairs(EventMgr.eventsMap) do
        if v==nil then
            table.remove(EventMgr.eventsMap,k)
        end            
	end 
end
--派发事件
function EventMgr.dispatchEvent(code,data)
    ExternalFun.dump(data,code)
    --轮询发送    
	for k, v in pairs(EventMgr.eventsMap) do
        if v and v.message then
            v:message(code,data)
        end            
	end 
end
return EventMgr 


--endregion

