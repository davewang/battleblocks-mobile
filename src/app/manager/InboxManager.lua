
local Listener = import(".Listener")
local InboxManager = class("InboxManager",Listener)
--local json = require("dkjson")
function InboxManager:ctor()
    InboxManager.super.ctor(self)
    self.systemMessages = {}
end

function InboxManager:requestReadMessage(messageId)
    local msg = {messageId = messageId}

   -- msg = json.encode(msg, { indent = true })
    --print("msg2:"..msg)
    self.app_.httpClient:sendJsonMessage(GAME_OP_CODES.READ_ACTION_INBOX,msg)
end  
function InboxManager:requestAcceptMessage(messageId)
    local msg = {messageId = messageId}

   -- msg = json.encode(msg, { indent = true })
    --print("msg2:"..msg)
    self.app_.httpClient:sendJsonMessage(GAME_OP_CODES.APPECT_ACTION_INBOX,msg)
end

function InboxManager:requestMessages()
    
    local msg = {u_id = self.app_:getCurrentUser().objectId}

    --msg = json.encode(msg, { indent = true })
    --print("msg2:"..msg)
    self.app_.httpClient:sendJsonMessage(GAME_OP_CODES.GET_INBOX,msg)
end
function InboxManager:requestUnReadCount()
    local msg =  {u_id = self.app_:getCurrentUser().objectId}

    --msg = json.encode(msg, { indent = true })
    --print("msg2:"..msg)
    self.app_.httpClient:sendJsonMessage(GAME_OP_CODES.GET_UNREAD_COUNT_INBOX,msg)
end

function InboxManager:getSystemUnreadCount()
    return #self.systemMessages
end
function InboxManager:getSystemMessages()
    return self.systemMessages
end

function InboxManager:onSystemMessagesReceived(event)

    self.systemMessages = event.data
--    local obj, pos, err = json.decode (event.data, 1, nil)
--    if err then
--        print ("Error:", err)
--    else
--        print ("count:", #obj)
--        self.systemMessages = obj
--    end
    for i=1,#self.listeners  do
        self.listeners[i]:onSystemMessagesReceived()
    end
end

function InboxManager:onReceived(event)
    
    if event.data then
        for i=1,#self.listeners  do
            self.listeners[i]:onReceived()
        end
    end
--  
--    local obj, pos, err = json.decode (event.data, 1, nil)
--    if err then
--        print ("Error:", err)
--    else
--        print ("count:", #obj)
--    end
   
end

function InboxManager:dispatch(event)
    print("InboxManager:dispatch op_code:"..event.op_code .." data len:"..#event.data)
    if tonumber(event.op_code) == GAME_OP_CODES.GET_INBOX  then
        self:onSystemMessagesReceived(event)
        return true
    elseif tonumber(event.op_code) == GAME_OP_CODES.READ_ACTION_INBOX then
        self:onReceived(event)
        return true
    elseif tonumber(event.op_code) == GAME_OP_CODES.APPECT_ACTION_INBOX then
        self:onReceived(event)
        return true
    elseif tonumber(event.op_code) == GAME_OP_CODES.GET_UNREAD_COUNT_INBOX then
        self:onReceived(event)
        return true
    end   
    return false
end 
return InboxManager

 