httpnect =httpnect or {}
httpnect.trycount=0

function httpnect.gettoken(cb)
    local ostime = os.date("%Y%m%d")
    local url = appdf.HTTP_URL .. "/gameCenter/check/getAccessToken"
    local token= nil
    local sign = nil
    local vcallback = function(datatable)
        if type(datatable) == "table" then
            --dump(datatable,"获取token")
            if datatable["code"] == "0" then
                token = datatable["data"]
                if token then
                    sign= md5(ostime..token)
                end
                cb(token,sign)
            else
                --获取失败
                cb()
            end
        else
            cb()
        end
    end
    appdf.onHttpJsionTable(url,"get","",vcallback)
end

function httpnect.onHttpPostJsionTable(url,params,callback)
    --dump(params,"HTTP发送Post数据")
    if type(params) ~= "table" then
        callback("shucuo")
    end

    function  Getsign(token,sign)
        if token == nil or sign== nil then
            callback("token no")
            return
        end
        ExternalFun.print("Http:"..url)
        -- print("token="..token)
        -- print("sign="..sign)
        --连接里面增加Token和sign
        url = url..string.lower(string.format("?token=%s&sign=%s",token,sign))

        local xhr = cc.XMLHttpRequest:new()
        xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
        xhr:setRequestHeader("Content-Type", "application/json")
        xhr:open("POST", url)
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
                        -- print("Post_cjson_error")
                        datatable = nil
                    end
                end
            else
                -- print("3onJsionTable http fail readyState:"..xhr.readyState.."#status:"..xhr.status)
            end
            callback(datatable,response)
        end
        xhr:registerScriptHandler(onJsionTable)

        ExternalFun.print("send"..json.encode(params))
        xhr:send(json.encode(params))
    end
    httpnect.gettoken(Getsign)
    return true
end
function httpnect.send(code,data,cb)
    function Senddata(jsdata)
        dissWait()
        local str=nil
        --dump(jsdata,"HTTP Get")
        if type(jsdata) == "table" then
            if jsdata and jsdata["code"] == "0" then
                dump(jsdata["data"],"web_back")
                cb(jsdata["data"])
            else
                str=jsdata["value"]
                if  str then
                    showToast(str,1)
                    return
                end
                 str=jsdata["data"]
                if  str then
                    showToast(str,1)
                    return
                end
            end
        elseif type(jsdata) == "string" then
                str=jsdata
                showToast(str,1)
        else
            -- str="no net!"
            -- showToast(str,1)
        end
    end
    showWait(10)
    local url = appdf.HTTP_URL ..code
    httpnect.onHttpPostJsionTable(url,data,Senddata)
end
