local MatchController = class("MatchController")
local json = require("dkjson")

local userDefault = cc.UserDefault:getInstance()
function MatchController:ctor()
    self.currentPlayer = nil
    self.remotePlayer = nil
    -- bind the "event" component
    --cc.bind(self, "event")
    self.delegate = nil
    self.queue = {}

--    local function update(dt)
--         if self.delegate and #self.queue>0 then
--
--            local msg = table.remove(self.queue,1)
--            self.delegate:onMessageReceive(msg)
--         end
--    end
--    local scheduler = cc.Director:getInstance():getScheduler()
--    local schedulerEntry = scheduler:scheduleScriptFunc(update, 1/30, false)
end

function MatchController:setDelegate(delegate)
    --print("setDelegate = ",delegate)
    self.delegate = delegate
end
function MatchController:setCurrentPlayer(player)
    --print("player name = "..player.name)
    self.currentPlayer = player
end
function MatchController:onGameCenterAuthSuccessed(arr)

       local oldId = userDefault:getStringForKey(K_GAME_CENTER_ID)
       if oldId==arr.playerId then
            print ("oldId==arr.playerId")
            return
        else
            print ("setStringForKey")
            userDefault:setStringForKey(K_GAME_CENTER_ID, arr.playerId)
            self.app_.userManager:login(arr.playerId,"ios")
            currentLoginID = arr.playerId
        end

end
function MatchController:onGetPlayIdSuccessed(arr)

       print ("onGetPlayIdSuccessed:%s", arr)
       local arr1, pos, err = json.decode (arr, 1, nil)
       print ("onGetPlayIdSuccessed:%s", arr1.playerId)
       local oldId = userDefault:getStringForKey(K_GAME_CENTER_ID)

        if oldId==arr1.playerId then
            return
        else
            print ("requestlogInWithGameCenterId2:%s", arr1.playerId)
            userDefault:setStringForKey(K_GAME_CENTER_ID, arr1.playerId)

            self.app_.userManager:login(arr1.playerId,"android")
            currentLoginID = arr1.playerId
        end

end

function MatchController:enterMenuScene()
    print("enterMenuScene = -->>>>")
    --self:getApp():enterScene("MainScene")
    --self:getApp():enterScene("MainView")
     local view = self:getApp():enterScene("MainView")
     view:onLoginReceived()
    
end
function MatchController:getApp()
    return self.app_
end
function MatchController:onPlayerInfoReceived(players)
    --print("player1 name = "..players[1].name)
    self.remotePlayer =  players[1]
    --onPlayerInfoReceivedHandler
    self:getApp():enterScene("VSShowView")

end
function MatchController:onPlayerDisconnected(msg)
    print("onPlayerDisconnected playerId = "..msg.playerId)
--    local disconnectMsg = {
--        msgid = 1008,
--        playerId = msg.playerId
--    }
--    table.insert(self.queue,disconnectMsg)
    --self.app_.matchManager:onPlayerDisconnected(msg)
end

function MatchController:onReceivedDataByPlayer(data)

--    local msg, pos, err = json.decode (all.jsonData, 1, nil)
--    if err then
--        print ("Error:", err)
--    else
--
--    end
--    table.insert(self.queue,msg)
     self.app_.matchManager:onReceivedDataByPlayer(data)

end

function MatchController:onReady()
    print ("MatchController:onReady() ")
end

--call obj-c
function MatchController:findOpponent()
    LuaObjcBridge.callStaticMethod("MatchController","findOpponent",nil)
end
function MatchController:cancelMatchmakingRequest()
    LuaObjcBridge.callStaticMethod("MatchController","cancelMatchmakingRequest",nil)
end
function MatchController:sendJsonMsgToAllPlayer(jsonMsg)
    local str = json.encode(jsonMsg, { indent = true })
    LuaObjcBridge.callStaticMethod("MatchController","sendDataToAllPlayer",{data = str})
end


return MatchController
