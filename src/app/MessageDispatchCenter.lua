MessageDispatchCenter = {}

MessageDispatchCenter.MessageType = {
    MATCH_NOTIFY = "MATCH_NOTIFY",
    CHECK_INBOX_NOTIFY= "CHECK_INBOX_NOTIFY",
    REFRESH_USERINFO = "REFRESH_USERINFO",
    DISCONNECTION = "DISCONNECTION",
  
}

MessageDispatchCenter.MessageQue = {}
 

--need param messageType and callback function
function MessageDispatchCenter:registerMessage(messageType,callback)
    --if param is valid
    if self.MessageType[messageType] == nil or type(callback) ~= "function" then
        print("param is invalid")
        return
    end
    
    --add message to messageQue
    if self.MessageQue[messageType] == nil then
        self.MessageQue[messageType] = {}
    end
    local index = table.getn(self.MessageQue[messageType])
    self.MessageQue[messageType][index+1] = callback
    
 
end

function MessageDispatchCenter:dispatchMessage(messageType,param)
    --if param is valid
    if self.MessageType[messageType] == nil then
        print("param is invalid")
        return
    end
    
    --callback
    if self.MessageQue[messageType] == nil then
        return
    end
    for i,v in pairs(self.MessageQue[messageType]) do
        v(param)
    end
end
function MessageDispatchCenter:removeAllMessage(messageType)

     print("MessageDispatchCenter:removeMessage1")
    --if param is valid
    if self.MessageType[messageType] == nil then
        print("param is invalid")
        return
    end
    print("MessageDispatchCenter:removeMessage2")
   
    --remove callback
    if self.MessageQue[messageType] then 
        for i,v in pairs(self.MessageQue[messageType]) do
            table.remove(self.MessageQue[messageType],i)
        end
    end
   
end
function MessageDispatchCenter:removeMessage(messageType,callback)

     print("MessageDispatchCenter:removeMessage1")
    --if param is valid
    if self.MessageType[messageType] == nil or type(callback) ~= "function" then
        print("param is invalid")
        return
    end
    print("MessageDispatchCenter:removeMessage2")
   
    --remove callback
    for i,v in pairs(self.MessageQue[messageType]) do
        print("callback = ",v)
        if callback == v then
              print("remove = ",v)
            table.remove(self.MessageQue[messageType],i)
            return
        end
    end
end

return MessageDispatchCenter
