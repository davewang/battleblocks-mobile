
local Listener = import(".Listener")
local DailyManager = class("DailyManager",Listener)
--local json = require("dkjson")
function DailyManager:ctor()
    DailyManager.super.ctor(self)
    self.goods = {}
end

function DailyManager:requestDailyGoods()
    local msg = {username=GAME_CENTER_ID}

   -- msg = json.encode(msg, { indent = true })
    --print("msg2:"..msg)
    self.app_.httpClient:sendJsonMessage(GAME_OP_CODES.GET_DAILY,msg)
end
function DailyManager:getGoods()
    return self.goods
end

function DailyManager:onGoodsReceived(event)

    self.goods = event.data
--    local obj, pos, err = json.decode (event.data, 1, nil)
--    if err then
--        print ("Error:", err)
--    else
--        print ("count:", #obj)
--        self.products = obj
--    end
    for i=1,#self.listeners  do
        self.listeners[i]:onReceived()
    end
end

function DailyManager:dispatch(event)
    print("DailyManager:dispatch op_code:"..event.op_code .." data len:"..#event.data)
    if tonumber(event.op_code) == GAME_OP_CODES.GET_DAILY  then
        self:onGoodsReceived(event)
        return true
    end   
    return false
end 
return DailyManager
