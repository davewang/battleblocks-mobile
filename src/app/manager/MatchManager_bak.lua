local MatchManager = class("MatchManager")
local json = require("dkjson")
function MatchManager:ctor(match)
    self.listeners = {}
    self.match = match
    self.remotePlayer = nil
    self.queue = {}
--    self.read_queue = {}
--    self.wirte_queue = {}
--    self.wirte_max = 100000
--    self.read_max = 100000
--    self.send_data = ""
--    self.recv_data = ""
    self.state_names = {in_game = 'in game', idle = 'idle'}
    self.keyOrder = {'msgid','msg_type','playerId','dx','solid_count','gap_index','next','random_fig'}
    self.state = ""
    self.groups = {}
    self.path = device.writablePath.."upd/"
    local function update(dt)
        if #self.queue>0 and #self.listeners>0 then
            local msg = table.remove(self.queue,1)
           -- print("self.listeners count = ",#self.listeners)
            for i=1,#self.listeners do
                self.listeners[i]:onReceived(msg)
            end
        end
    end

    local scheduler = cc.Director:getInstance():getScheduler()
    local schedulerEntry = scheduler:scheduleScriptFunc(update, 1/60, false)
    print(string.format( "add handler = %s ----------->",GAME_OP_CODES.START_MATCH))
    MsgHandlers[GAME_OP_CODES.START_MATCH]= handler(self,self.onReceivedMatched)
    MsgHandlers[GAME_OP_CODES.SEND_MATCH_DATA]= handler(self,self.onReceivedFromSend)
    MsgHandlers[GAME_OP_CODES.RECV_MATCH_DATA]= handler(self,self.onReceivedDataFromPlayer)
    MsgHandlers[GAME_OP_CODES.CANCEL_MATCH]= handler(self,self.onReceivedCancelMatched)
    --print(string.format( "writeTo = %s",self.path))
end

function MatchManager:getOnlineInfo()
  self.app_.client:request("onlineinfo", {uid="1"} , function(obj)
      if obj then
        self.groups = obj

        print(string.format( "self.groups count = %d ",#self.groups))
        for i=1,#self.groups do
          print(string.format( "group id %s count = %d ",self.groups[i].id,self.groups[i].count))
        end
      end
  end)
end
function MatchManager:writeToReceived(msg,file)
    --print(string.format( "writeToReceived = %s",file))
    self.recv_data = self.recv_data .. json.encode(msg, { indent = true ,keyorder=self.keyOrder})
    io.writefile(file, self.recv_data)
end
function MatchManager:writeToSend(msg,file)
    --print(string.format( "writeToSend = %s",file))
    self.send_data = self.send_data .. json.encode(msg, { indent = true ,keyorder=self.keyOrder})
    io.writefile(file, self.send_data)
end
function MatchManager:onReceivedFromSend(client,data)
    -- print(string.format("onReceivedFromSend msgdata : %s",data.msgdata))
    --print(string.format("onReceivedFromSend msgtype : %s",data.msgtype))
end
function MatchManager:onReceivedCancelMatched(client,data)
    print(string.format("onReceivedCancelMatched msgtype : %s",data.msgtype))
end
function MatchManager:onReceivedMatched(client,data)
     if data.msgdata.state == "found" then
        self.remotePlayer = data.msgdata.players[1]
        local function enterVs()
        	self.app_:enterScene("VSShowView")
        end

        local wait = cc.DelayTime:create(0.5*3)
        local enter = cc.CallFunc:create(enterVs)
        self.app_:getCurrentScene():runAction(cc.Sequence:create({wait,enter}))


     end
--    print(string.format("onReceivedMatched msgdata : %s",data.msgdata))
--    print(string.format("onReceivedMatched msgtype : %s",data.msgtype))
--
end
function MatchManager:onReceivedDataFromPlayer(client,data)
    --print(string.format("onReceivedDataFromPlayer data :%s",data))

--    print(string.format("onReceivedDataFromPlayer msgdata : %s",data.msgdata))
--    print(string.format("onReceivedDataFromPlayer msgtype : %s",data.msgtype))

--    local msg, pos, err = json.decode (data.jsonData, 1, nil)
--    if err then
--        print ("Error:", err)
--    else
--    --print ("msgid = ", msg.msgid)
--    end
--    table.insert(self.queue,msg)
    --table.insert(self.queue,data.msgdata)

    table.insert(self.queue,data)
  --  self:writeToReceived(data,device.writablePath.."received_queue")



end

function MatchManager:sendJsonMsgToAllPlayer(data)
  --  local dtstart = socket.gettime()
      self.app_.client:send(data)
     -- self:writeToSend(data,device.writablePath.."send_queue")

  --  self.app_.client:SendJsonMsg(GAME_OP_CODES.SEND_MATCH_DATA,data)
   -- local dtcost = socket.gettime() - dtstart
    --print(string.format("发送消息耗时: %f", dtcost))
end
function MatchManager:findOpponentByGroup(group)
    local msg = {group=group}
   -- self.app_.client:SendJsonMsg(GAME_OP_CODES.START_MATCH,msg)
    self.app_.client:request(GAME_OP_CODES.START_MATCH,msg,function(obj)
        self.app_.client:openBroadcast(obj,handler(self,self.onReceivedDataFromPlayer))
        print("response START_MATCH")
    end)
end
function MatchManager:cancelMatchmakingOpponent()
    --local msg = {action="cancel"}
    --self.app_.client:SendJsonMsg(GAME_OP_CODES.CANCEL_MATCH,msg)
    self.app_.client:request(GAME_OP_CODES.CANCEL_MATCH,{uid=""},function(obj)
        print("response CANCEL_MATCH")
    end)
end
function MatchManager:requestMatchGameByGroup(group)
    local msg = {user_id="hello",group=group,user_name = self.app_:getCurrentUser().nickname }
    self.app_.client:SendJsonMsg(GAME_OP_CODES.START_MATCH,msg)

    --      local matchStart = {
    --                user_id = "1021",
    --                user_name = "dave",
    --                group = 1
    --            }
    --            self:app_:getClient().SendJsonMsg(matchStart,GAME_OP_CODES.START_MATCH);
end

-- Game Center
--function MatchManager:onReceivedDataByPlayer(data)
--    local msg, pos, err = json.decode (data.jsonData, 1, nil)
--    if err then
--        print ("Error:", err)
--    else
--    --print ("msgid = ", msg.msgid)
--    end
--    table.insert(self.queue,msg)
--end


function MatchManager:onPlayerDisconnected(msg)
    local disconnectMsg = {
        msgid = 1008,
        msg_type = 0,
        playerId = msg.playerId
    }
    table.insert(self.queue,disconnectMsg)
end


function MatchManager:sendSolidMsg(solid_count)
    print("MatchManager:sendSolidMsg solid_count = ",solid_count)
    local solidTetris = {
        msgid = 2001,
        msg_type = 1,
        solid_count = solid_count
    }
    --self.match:sendJsonMsgToAllPlayer(solidTetris)
    self:sendJsonMsgToAllPlayer(solidTetris)
end
function MatchManager:sendSolidSimMsg(solid_count,gap_index)
    print("MatchManager:sendSolidSimMsg solid_count = ",solid_count)
    local solidTetris = {
        msgid = 1010,
        msg_type = 0,
        solid_count = solid_count,
        gap_index = gap_index
    }
    --self.match:sendJsonMsgToAllPlayer(solidTetris)
    self:sendJsonMsgToAllPlayer(solidTetris)
end
function MatchManager:sendGameOverMsg()
    local gameOverTetris = {
        msgid = 1009,
        msg_type = 0
    }
    --self.match:sendJsonMsgToAllPlayer(gameOverTetris)
    self:sendJsonMsgToAllPlayer(gameOverTetris)
end


function MatchManager:sendDropMsg()
    local dropTetris = {
        msgid = 1006,
        msg_type = 0
    }
    --self.match:sendJsonMsgToAllPlayer(dropTetris)
    self:sendJsonMsgToAllPlayer(dropTetris)
end
function MatchManager:sendRotateMsg()
    local rotateTetris = {
        msgid = 1007,
        msg_type = 0
    }
    --self.match:sendJsonMsgToAllPlayer(rotateTetris)
    self:sendJsonMsgToAllPlayer(rotateTetris)
end
function MatchManager:sendHoldSimMsg(index)
    local startTetris = {
        msgid = 1011,
        msg_type = 0,
        random_fig = index
    }
    --self.match:sendJsonMsgToAllPlayer(startTetris)
    self:sendJsonMsgToAllPlayer(startTetris)
end
function MatchManager:sendInitSimMsg(nextIndex,index)
    local startTetris = {
        msgid = 1001,
        msg_type = 0,
        next = nextIndex,
        random_fig = index
    }
    --self.match:sendJsonMsgToAllPlayer(startTetris)
    self:sendJsonMsgToAllPlayer(startTetris)
end
function MatchManager:sendFallMsg()
    local fallTetris = {
        msgid = 1002,
        msg_type = 0
    }
    --self.match:sendJsonMsgToAllPlayer(fallTetris)
    self:sendJsonMsgToAllPlayer(fallTetris)
end
function MatchManager:sendLockMsg(solid_count)
    local lockTetris = {
        msgid = 1003,
        msg_type = 0
    }
    --self.match:sendJsonMsgToAllPlayer(lockTetris)
    self:sendJsonMsgToAllPlayer(lockTetris)

end
function MatchManager:sendRemoveMsg(solid_count)
    local removeTetris = {
        msgid = 1004,
        msg_type = 0
    }
    --self.match:sendJsonMsgToAllPlayer(removeTetris)
    self:sendJsonMsgToAllPlayer(removeTetris)

end
function MatchManager:sendAroundMsg(dx)
    local aroundTetris = {
        msgid = 1005,
        dx = dx,
        msg_type = 0
    }
    --self.match:sendJsonMsgToAllPlayer(aroundTetris)
    self:sendJsonMsgToAllPlayer(aroundTetris)

end


function MatchManager:addListener(obj)
    for i=1,#self.listeners  do
        if self.listeners[i]==obj then
            return
        end
    end
    self.listeners[#self.listeners+1] = obj
end


function MatchManager:removeListener(obj)
    for i=1,#self.listeners  do
        if self.listeners[i]==obj then
            table.remove(self.listeners,i)
            break
        end
    end
end

return MatchManager
