
local Listener = import(".Listener")
local LeagueManager = class("LeagueManager",Listener)
--local json = require("dkjson")
function LeagueManager:ctor()
    LeagueManager.super.ctor(self)
    self.ranks = {}
    self.scores = {}
    self.friends = {}
end

function LeagueManager:requestScores()
    local msg = {username=GAME_CENTER_ID}

    self.app_.httpClient:sendJsonMessage(GAME_OP_CODES.LEAGUE_SCORE,msg)
end
function LeagueManager:requestFriends()
    local msg = {username=GAME_CENTER_ID}

    self.app_.httpClient:sendJsonMessage(GAME_OP_CODES.LEAGUE_FRIEND,msg)
end
function LeagueManager:requestRanks()
    local msg = {username=GAME_CENTER_ID}
   -- msg = json.encode(msg, { indent = true })
    self.app_.httpClient:sendJsonMessage(GAME_OP_CODES.LEAGUE_RANK,msg)
end
function LeagueManager:getScores()
    return self.scores
end
function LeagueManager:getRanks()
    return self.ranks
end
function LeagueManager:getFriends()
    return self.friends
end
function LeagueManager:onScoresReceived(event)

--    local obj, pos, err = json.decode (event.data, 1, nil)
--    if err then
--        print ("Error:", err)
--    else
--        print ("count:", #obj)
--        self.scores = obj
--    end
    self.scores = event.data
    for i=1,#self.listeners  do
        self.listeners[i]:onScoresReceived()
    end
end
function LeagueManager:onFriendsReceived(event)

--    local obj, pos, err = json.decode (event.data, 1, nil)
--    if err then
--        print ("Error:", err)
--    else
--        print ("count:", #obj)
--        self.friends = obj
--    end
    self.friends = event.data
    for i=1,#self.listeners  do
        self.listeners[i]:onFriendsReceived()
    end
end
function LeagueManager:onRanksReceived(event)

--    local obj, pos, err = json.decode (event.data, 1, nil)
--    if err then
--        print ("Error:", err)
--    else
--        print ("count:", #obj)
--        self.ranks = obj
--    end
    self.ranks = event.data
    for i=1,#self.listeners  do
        self.listeners[i]:onRanksReceived()
    end
end
function LeagueManager:dispatch(event)
    print("LeagueManager:dispatch op_code:"..event.op_code .." data len:"..#event.data)
    if tonumber(event.op_code) == GAME_OP_CODES.LEAGUE_RANK  then
        self:onRanksReceived(event)
        return true
    elseif tonumber(event.op_code) == GAME_OP_CODES.LEAGUE_SCORE then
        self:onScoresReceived(event)
        return true
    elseif tonumber(event.op_code) == GAME_OP_CODES.LEAGUE_FRIEND  then
        self:onFriendsReceived(event)
        return true
    end
    return false
end
return LeagueManager
