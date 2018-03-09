
local Listener = import(".Listener")
local UserManager = class("UserManager",Listener)
local userDefault = cc.UserDefault:getInstance()
--local json = require("dkjson")
function UserManager:ctor()
    UserManager.super.ctor(self)
    --UserManager.super.ctor()
    self.loginUser = nil
    self.userInfo = nil
    self.isLoginBattle = false
    MsgHandlers[GAME_OP_CODES.AUTH_BATTLE]= handler(self,self.onReceivedAuth)
end
function UserManager:onReceivedAuth(client,data)
    self.isLoginBattle = true
    --print(string.format("onReceivedAuth msgdata : %s",data.msgdata))
    --print(string.format("onReceivedAuth msgtype : %s",data.msgtype))

end
function UserManager:getUserInfo()
    return self.userInfo
end
function UserManager:getLoginUser()
    return self.loginUser
end
function UserManager:requestlogInWithGameCenterId(gamecenterId,platform)
    local msg = {username=gamecenterId,platform=platform}
    GAME_CENTER_ID = gamecenterId
    --msg = json.encode(msg, { indent = true })
    --print("msg2:"..msg)
    self.app_.httpClient:sendJsonMessage(GAME_OP_CODES.LOGIN,msg)
end
function UserManager:requestLoginBattle()
    print("GAME_CENTER_ID = ",GAME_CENTER_ID)
    local msg = {player_id=self.userInfo.game_center_id,user_name=self.userInfo.nickname,rank_level=12,avatar_id=1}
   -- self.app_.client:SendJsonMsg(GAME_OP_CODES.AUTH_BATTLE,msg)

    self.app_.client:request("info",{nickname=self.userInfo.nickname,uid=self.userInfo.game_center_id,ranklevel=12,avatarid=1},
    function(obj)
      print(string.format("result:", obj.result))
    end);
end
function UserManager:requestUserInfo()

    local msg = {u_id=self.loginUser.league_id}

   -- msg = json.encode(msg, { indent = true })
    --print("msg2:"..msg)
    self.app_.httpClient:sendJsonMessage(GAME_OP_CODES.USER_INFO,msg)
end

--function UserManager:handler(event)
--
--    self.loginUser = json.encode(event.data, { indent = true })
--    self.app_:enterScene("MainScene")
--    for i=1,#self.listeners  do
--        self.listeners[i]:onReceived()
--    end
--end
function UserManager:userInfoReceived(event)
    --local obj, pos, err = json.decode (event.data, 1, nil)
    self.userInfo = event.data

    for i=1,#self.listeners  do
        self.listeners[i]:onUserInfoReceived()
    end
end
function UserManager:requestUpdateScore(score)

    local msg = {u_id=self.loginUser.league_id,score = score}

   -- msg = json.encode(msg, { indent = true })
    --print("msg2:"..msg)
    self.app_.httpClient:sendJsonMessage(GAME_OP_CODES.UPDATE_SCORE,msg)
end
function UserManager:updateScoreReceived(event)
    --local obj, pos, err = json.decode (event.data, 1, nil)
    if event.data.success == 'yes' then
        self.userInfo.score = event.data.score
    end

    for i=1,#self.listeners  do
        self.listeners[i]:onUserInfoReceived()
    end
end
function UserManager:requestUpdateStar(star)

    local msg = {u_id=self.loginUser.league_id,star_count = star}

    --msg = json.encode(msg, { indent = true })
    --print("msg2:"..msg)
    self.app_.httpClient:sendJsonMessage(GAME_OP_CODES.UPDATE_STAR,msg)
end
function UserManager:updateStarReceived(event)
    --local obj, pos, err = json.decode (event.data, 1, nil)
    if event.data.success == 'yes' then
        self.userInfo.star_count = event.data.star_count
    end

    for i=1,#self.listeners  do
        if self.listeners[i].onUpdateStarReceived and type(self.listeners[i].onUpdateStarReceived) == "function" then
            self.listeners[i]:onUpdateStarReceived()
        end
        -- self.listeners[i]:onUpdateStarReceived()
    end
end
--function UserManager:updateStarReceived(event)
--    --local obj, pos, err = json.decode (event.data, 1, nil)
--    if event.data.success == 'yes' then
--        self.userInfo.star_count = event.data.star_count
--    end
--
--    for i=1,#self.listeners  do
--
--        self.listeners[i]:onUpdateStarReceived()
--    end
--end

function UserManager:loginReceived(event)
    --local obj, pos, err = json.decode (event.data, 1, nil)
    self.loginUser = event.data
    print(string.format( "event.data.username = %s",event.data.username))
    self.app_.client:login(event.data.username,"pass")
    local function cb()
        self.app_.client:request("matchnotify", {sid="one"} , function(obj)
            if obj then
                obj.state = "found"

                local msg = {msgtype = GAME_OP_CODES.START_MATCH, msgdata = obj}
                print(string.format( "matchnotify -----------> %s  ",msg.msgtype))
                local f = MsgHandlers[msg.msgtype]
                if not f then
                    print("没有处理函数",msg.msgtype)
                    return
                end

                --local dtstart = socket.gettime()
                self.app_:getMatchManager():onReceivedMatched("",msg)
                --local rst, err = pcall(f, self.app_.client, msg)
                --local dtcost = socket.gettime() - dtstart

                cb()
            end
        end)
    end
    cb()






--    local notify = self.app_.client:request("matchnotify", {sid="one"} , function(obj)
--         if obj then
--
--         end
--    end)
    --local view = self.app_:enterScene("MainScene")
    local view = self.app_:enterScene("TestDrawer")
    self:addListener(view)
    for i=1,#self.listeners  do
        self.listeners[i]:onLoginReceived()
    end
    if self.userInfo==nil then
    	self:requestUserInfo()
    end
end
function UserManager:dispatch(event)
    print("UserManager:dispatch op_code:"..event.op_code .." data len:"..#event.data)
    if tonumber(event.op_code) == GAME_OP_CODES.LOGIN  then
        self:loginReceived(event)
        return true
    elseif tonumber(event.op_code) == GAME_OP_CODES.USER_INFO  then
        self:userInfoReceived(event)
        return true
    elseif tonumber(event.op_code) == GAME_OP_CODES.UPDATE_STAR  then
        self:updateStarReceived(event)
        return true
    elseif tonumber(event.op_code) == GAME_OP_CODES.UPDATE_SCORE  then
        self:updateScoreReceived(event)
        return true
--    elseif tonumber(event.op_code) == GAME_OP_CODES.UPDATE_STAR  then
--        self:updateStarReceived(event)
--        return true
    end
    return false
end
return UserManager
