local HttpClient = class("HttpClient")
local json = require("dkjson")
local proto = require "proto"
function HttpClient:ctor()
    print("HttpClient:onCreate")
  --  self.url = "http://www.iapploft.net/json"
    self.url = "http://"..G_LOGIN_SERVER..":8002/api"
    --    self.request = cc.XMLHttpRequest:new()
--    self.request:open("POST",self.url)
--    self.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
--    local function onStateChange()
--        self:onResponse(self.request)
--    end
    --self.eventHandlers = {}
end
--function HttpClient:getInstance()
--    if self.instance == nil then
--        self.instance = self:create()
--
--        self.request:retain();
--    end
--    return self.instance
--end
--function HttpClient:onResponse(request)
--    printf("REQUEST  - request.response = %s", request.response)
--    local opCode = request:getAllResponseHeaders()--request:getResponseHeader("Op_code")--
--    printf("REQUEST  - response.opCode = %s",opCode)
--    if request.status ~= 200 then
--       printf("REQUEST status 200")
--       return
--    else
--        local obj, pos, err = json.decode (request.response, 1, nil)
--        if err then
--            print ("REQUEST Error:", err)
--            self:dispatch({op_code=request.opCode,err=err,data=nil})
--        else
--           -- print ("count:", #obj)
--            self:dispatch({op_code=request.opCode,data=obj})
--        end
--
--
--    end
--    print("----------------------------------------")
--end
--function HttpClient:dispatch(event)
--    print("HttpClient:dispatch op_code:"..event.op_code .." data len:"..#event.data)
--
--    for i=1,#self.eventHandlers do
--        if self.eventHandlers[i]:dispatch(event) then --if dispatch success
--            break
--        end
--    end
--end
--function HttpClient:addEventHandler(handler)
--    for i=1,#self.eventHandlers do
--        if self.eventHandlers[i]==handler then
--            return
--        end
--    end
--    self.eventHandlers[#self.eventHandlers+1] = handler
--end
--function HttpClient:sendMessage(op_id,msg)
--    local prams = "op_id="..op_id.."&msg="..msg
--    print("--post==",prams)
--    self.request = cc.XMLHttpRequest:new()
--    self.request.opCode = op_id
--    self.request:open("POST",self.url)
--    self.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
--    local function onStateChange()
--        self:onResponse(self.request)
--    end
--    self.request:registerScriptHandler(onStateChange)
--    self.request:send(prams)
--end
--function HttpClient:sendJsonMessage(op_id,msg)
--    local prams = "op_id="..op_id.."&msg="..json.encode(msg, { indent = true })
--    print("--post==",prams)
--    self.request = cc.XMLHttpRequest:new()
--    self.request.opCode = op_id
--    self.request:open("POST",self.url)
--    self.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
--    local function onStateChange()
--        self:onResponse(self.request)
--    end
--    self.request:registerScriptHandler(onStateChange)
--    self.request:send(prams)
--end
function HttpClient:request(type,obj,cb)
    local data, tag = proto.request(type, obj)
    print("request = ",type)
        local function callback(ok, msg)
            if ok then
                return cb(proto.response(tag, msg))
            else
                print("error:", msg)
            end
        end
    local request = cc.XMLHttpRequest:new()
    request:open("POST",self.url)
    request:registerScriptHandler(function()
                if request.status ~= 200 then
                    printf("REQUEST status !200")
                    callback(false,nil);
                else
                    callback(true,request.response);
                end
    end)
    request:send(data)

--    self.request = cc.XMLHttpRequest:new()
--    self.request:open("POST",self.url)
--    self.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
--    local data, tag = proto.request(type, obj)
--    local function callback(ok, msg)
--        if ok then
--            return cb(proto.response(tag, msg))
--        else
--            print("error:", msg)
--        end
--    end
--    local function response()
--        if self.request.status ~= 200 then
--            printf("REQUEST status !200")
--            callback(false,nil);
--        else
--            callback(true,self.request.response);
--        end
--    end
--
--    self.request:registerScriptHandler(response)
--    self.request:send(data)
end
--function HttpClient:sendMessage(obj,msg)
--    --local prams = "op_id="..op_id.."&msg="..json.encode(msg, { indent = true })
--    print("--post==",prams)
--    self.request = cc.XMLHttpRequest:new()
--    self.request.opCode = op_id
--    self.request:open("POST",self.url)
--    self.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
--    local function onStateChange()
--        self:onResponse(self.request)
--    end
--    self.request:registerScriptHandler(onStateChange)
--    self.request:send(prams)
--end

return HttpClient
