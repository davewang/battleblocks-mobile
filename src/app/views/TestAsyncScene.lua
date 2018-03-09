
local TestAsyncScene = class("TestAsyncScene", cc.load("mvc").ViewBase)
local socketevent = require("socketevent")
local StrPacket =  require "app.common.StringPacket"
local json = require("dkjson")
function TestAsyncScene:onCreate()
    self.socket = socketevent.tcp()
    self.buffer = nil
    self.stars = display.newSprite("starfield-hd.jpg")
        :move(display.center)
        :addTo(self,-1)
    self.stars:runAction(cc.RepeatForever:create(cc.RotateBy:create(360,360)))

    self.socket:on("connect", function(event)
        print("connect")
        self.buffer = {}
        self.buffer.requestlen = 2
        self.buffer.sendbuffer = ""
        self.buffer.recvbuffer = ""
    end)

    self.socket:on("data", function(event)
        print("data: " .. event.data)
        self.buffer.recvbuffer =  self.buffer.recvbuffer .. event.data
        local packet = self:DecodePacket()
        if packet then
           print(string.format("packet = %s",packet))
           self:ProcessPacket(packet)
        end
     --handler(self,self.onReceivedData)(event.data)
        --self.buffer.recvbuffer =  self.buffer.recvbuffer .. event.data
--        local packet = self:DecodePacket()
--        if packet then
--            print(string.format("packet = %s",packet))
--            self:ProcessPacket(packet)
--        end
        --print("data: " .. event.data)
    end)

    self.socket:on("close", function(event)
        print("close!")
    end)

    self.socket:on("error", function(event)
        print("error: " .. event.error .. ", " .. event.message)
    end)

   

   

    local scheduler = cc.Director:getInstance():getScheduler()
    cc.MenuItemFont:setFontName("CGF Locust Resistance")
    cc.MenuItemFont:setFontSize(44)
    local connectRequest =  cc.MenuItemFont:create("connect msg")
        :onClicked(function()
            self.socket:connect("127.0.0.1", 8080)

        end)
    local function authCb(client,data)
        print("auth ok!");
    end
    local authRequest =  cc.MenuItemFont:create("auth msg")
        :onClicked(function()
            local auth_a = {player_id="G:1152190469",user_name="noname5",rank_level=12,avatar_id=1}
            
            local raw = json.encode(auth_a, { indent = true }) 
            local ret = StrPacket.create()
            ret:write(GAME_OP_CODES.AUTH_BATTLE)
            ret:write(raw)
            --ret:getData()
            print("data = "..ret:getString())  
            self.socket:sendmessage(ret:getString())
            --self:getApp():getUserManager():requestAuthBattle();

        end)
 
     
    connectRequest:setColor(cc.c4b(0,255,255,255))
    authRequest:setColor(cc.c4b(0,255,255,255))
    
    cc.Menu:create(connectRequest,authRequest)
        :move(display.cx, display.cy-350)
        :addTo(self)
        :alignItemsVertically()






    -- self.connectTimeTickScheduler = scheduler:scheduleScriptFunc(__connectTimeTick, SOCKET_TICK_TIME,false)
    --    local function update(dt)
    --        client.RecvMsg();
    --    end
    --
    --    local scheduler = cc.Director:getInstance():getScheduler()
    --    local schedulerEntry = scheduler:scheduleScriptFunc(update, 1/30, false)
end
function TestAsyncScene:onReceived()

end
function TestAsyncScene:onReceivedData(data)
    self.buffer={}
    -- =  self.buffer.recvbuffer .. data
    print("data = %s",data)
    --self.buffer.recvbuffer =  self.buffer.recvbuffer .. data
end


function TestAsyncScene:DecodePacket()
    if self.buffer.recvbuffer:len() >= 2 then
        -- print(string.format( "len(%d)  ",Client.buffer.recvbuffer:len()))

        local packetLen = string.byte(self.buffer.recvbuffer, 2) * 256
        packetLen = string.byte(self.buffer.recvbuffer, 1) + packetLen
        -- print(string.format( "packetLen = %d  ",packetLen))
        --local packetLen = string.byte(Client.buffer.recvbuffer, 1) * 256
        --packetLen = string.byte(Client.buffer.recvbuffer, 2) + packetLen

        if self.buffer.recvbuffer:len() >= 2 + packetLen then
            local packet = string.sub(self.buffer.recvbuffer, 1, 2 + packetLen)
            self.buffer.recvbuffer = string.sub(self.buffer.recvbuffer, 2 + packetLen + 1)
            --print(string.format( "Client.buffer.recvbuffer = %s  ",packet))
            return packet
        else
            self.buffer.requestlen = 2 + packetLen - self.buffer.recvbuffer:len()
        end
    else
        self.buffer.requestlen = 2 - self.buffer.recvbuffer:len()
    end
end

--[[
--! @处理消息包
--! @param packet 消息包
--! 消息包格式: 2 bytes packet length + 2 packet msgtype + N bytes data
--]]
function TestAsyncScene:ProcessPacket(packet)
    --Client.DumpPacket(packet)

    local spacket = packet:sub(3)
    --print("spacket", spacket)
    local data = {}

    local i = string.find(spacket, ";")
    if not i then
        -- 未找到消息分隔符 ;
        print("未找到消息分隔符")
        return
    end

    local msg_type = spacket:sub(1, i-1)
    local msg_data = spacket:sub(i+1)

    print(string.format("RECV %8d bytes, TYPE: %s", #spacket, msg_type))
    local json_data, pos, err = json.decode (msg_data, 1, nil)
    if err then
        print ("REQUEST Error:", err)
    end
    --local msg = {msgtype = msg_type, msgdata = msg_data}
    local msg = {msgtype = msg_type, msgdata = json_data}

    local f = MsgHandlers[msg_type]
    if not f then
        print("没有处理函数", msg_type)
        return
    end

    local dtstart = socket.gettime()
   -- local rst, err = pcall(f, Client, msg)
    local dtcost = socket.gettime() - dtstart

    -- Profile
--    if not self.statistics[msg_type] then
--        self.statistics[msg_type] = {
--            times = 1,
--            cost = dtcost
--        }
--    else
--        self.statistics[msg_type].times = self.statistics[msg_type].times + 1
--        self.statistics[msg_type].cost = self.statistics[msg_type].cost + dtcost
--    end

    if not rst then
        print(string.format("处理消息码 %s 失败: %s, 耗时: %f", msg_type, tostring(err), dtcost))
    else
        print(string.format("处理消息码 %s 成功, 耗时: %f, ", msg_type, dtcost))
    end
end
function TestAsyncScene:onEnter() 
    print("onEnter TestAsyncScene  ")

end
function TestAsyncScene:onExit() 

    print("onExit TestAsyncScene  ")

end


return TestAsyncScene