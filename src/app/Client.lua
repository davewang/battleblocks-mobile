--require "Cocos2d"
local socket = require "socket.core"
local MsgPacket = {}--require "game.network.MsgPacket"
local StrPacket =  require "app.common.StringPacket"
local json = require("dkjson")
local SocketTCP = require "app.SocketTCP"

local Client = class("Client")
local socketevent = require("socketevent")

function Client:ctor()
    self.status = "disconnected"
    self.statistics = {} -- {times:n, totalCost:n} 统计执行次数和总时间
    self.netstat = nil
    self.buffer = nil
    self.socket = nil
    self.networkDebug =true
end
--return function()

local sproto = {}--require "game.network.SprotoWrapper"
--local Client = {}

-- 网络连接状态:
-- "disconnected"
-- "connecting"
-- "connected"
--Client.status = "disconnected"
--
--Client.statistics = {} -- {times:n, totalCost:n} 统计执行次数和总时间
--
--Client.netstat = nil
--Client.buffer = nil
--Client.socket = nil
--
--Client.networkDebug = true
    

function Client:ConnectServer(host, port)
 
	self.buffer = nil
    if not self._socket then
        print("connect!!!")
        
        
--        self._socket = SocketTCP.new(host,port, false)
--        self._socket:addEventListener(SocketTCP.EVENT_CONNECTED, handler(self, self.onStatus) )
--        self._socket:addEventListener(SocketTCP.EVENT_CLOSE,handler(self, self.onStatus) )
--        self._socket:addEventListener(SocketTCP.EVENT_CLOSED, handler(self, self.onStatus) )
--        self._socket:addEventListener(SocketTCP.EVENT_CONNECT_FAILURE, handler(self, self.onStatus) )
--        self._socket:addEventListener(SocketTCP.EVENT_DATA, handler(self, self.onData) )

        self._socket = socketevent.tcp()
       
        self._socket:on("connect", function(event)
            print("connect")
            self.status = "SOCKET_TCP_CONNECTED"
            self.buffer = {}
            self.buffer.requestlen = 2
            self.buffer.sendbuffer = ""
            self.buffer.recvbuffer = ""
        end)

        self._socket:on("data", function(event)
            print("on--->data:")
            self.buffer.recvbuffer =  self.buffer.recvbuffer .. event.data
             
            local packet = self:DecodePacket()
            --    if packet then
            --        print(string.format("packet = %s",packet))
            --        self:ProcessPacket(packet)
            --    end
            while packet ~= nil do
                print(string.format("packet = %s",packet))
                self:ProcessPacket(packet)
                packet = self:DecodePacket()
            end
            
--            if packet then
--                print(string.format("packet = %s",packet))
--                self:ProcessPacket(packet)
--            end
            --handler(self,self.onReceivedData)(event.data)
            --self.buffer.recvbuffer =  self.buffer.recvbuffer .. event.data
            --        local packet = self:DecodePacket()
            --        if packet then
            --            print(string.format("packet = %s",packet))
            --            self:ProcessPacket(packet)
            --        end
            --print("data: " .. event.data)
        end)

        self._socket:on("close", function(event)
            print("close!")
        end)

        self._socket:on("error", function(event)
            print("error: " .. event.error .. ", " .. event.message)
        end)
    end
    if self.status ~= "SOCKET_TCP_CONNECTED" then
       -- self._socket:connect()
        self._socket:connect(host, port)
    end
 
end
function Client:SendJsonMsg( msgtype,msg)
    --local st = sproto.core.querytype(sproto.sp, msgname)
    --local raw = sproto.core.encode(st, msg)
    local raw = json.encode(msg, { indent = true }) 
    local ret = StrPacket.create()
    ret:write(msgtype)
    ret:write(raw)
    --self:SendMsg(ret:getData())
    self:SendMsg(ret:getString())
end
 

--[[
--! @发送数据包
--! @func comment
--! @param packet - string 类型的数据
--]]
function Client:SendMsg(packet)
    print(string.format("status : %s",self.status));
    if self.status ~= "SOCKET_TCP_CONNECTED" then
		return
	end
   -- print(string.format("packet : %s",packet));
	if packet then
		self.buffer.sendbuffer = self.buffer.sendbuffer .. packet
		--return
	end
    print(string.format("send msg : %s",self.buffer.sendbuffer));
    self._socket:sendmessage(self.buffer.sendbuffer)
    self.buffer.sendbuffer = ""
--    local rst, err, n = self._socket:send(self.buffer.sendbuffer)
--        
--	if rst then
--		self.buffer.sendbuffer = ""
--		--print("发送数据成功", rst)
--		--Client.DumpPacket(packet)
--	else
--		if err == "closed" then
--			self.status = "disconnected"
--			self.buffer = nil
--			self.socket = nil
--			print("发送数据失败, 连接已断开")
--		elseif err == "timeout" then
--			self.buffer.sendbuffer = self.buffer.sendbuffer:sub(n+1)
--			print("发送数据超时")
--		end
--	end
end
function Client:onStatus(__event)
    print(string.format( "socket status: %s", __event.name))
    if __event.name == "SOCKET_TCP_CONNECTED" then
        self.buffer = {}
        self.buffer.requestlen = 2
        self.buffer.sendbuffer = ""
        self.buffer.recvbuffer = ""
    end
    self.status = __event.name
end
function Client:onData(__event)
    self.buffer.recvbuffer =  self.buffer.recvbuffer .. __event.data
    local packet = self:DecodePacket()
--    if packet then
--        print(string.format("packet = %s",packet))
--        self:ProcessPacket(packet)
--    end
    while packet ~= nil do
        print(string.format("packet = %s",packet))
        self:ProcessPacket(packet)
        packet = self:DecodePacket()
    end
   -- local packet = self:DecodePacket()
    

end
 
--[[
--! @从消息缓冲区中解一个消息包出来
--! 消息包格式:
--! 2 bytes length + 2 bytes msgtype + N bytes data
--! 整数的编码顺序是高位在低地址, 地位在高地址
--! 返回值: 能解出完整消息包返回 MsgPacket, 不能解出返回 nil
--]]
function Client:DecodePacket()
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
			return nil
		end
	else
		self.buffer.requestlen = 2 - self.buffer.recvbuffer:len()
		return nil
	end
end

--[[
--! @处理消息包
--! @param packet 消息包
--! 消息包格式: 2 bytes packet length + 2 packet msgtype + N bytes data
--]]
function Client:ProcessPacket(packet)
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
	local rst, err = pcall(f, Client, msg)
	local dtcost = socket.gettime() - dtstart

	-- Profile
	if not self.statistics[msg_type] then
		self.statistics[msg_type] = {
			times = 1,
			cost = dtcost
		}
	else
		self.statistics[msg_type].times = self.statistics[msg_type].times + 1
		self.statistics[msg_type].cost = self.statistics[msg_type].cost + dtcost
	end

	if not rst then
		print(string.format("处理消息码 %s 失败: %s, 耗时: %f", msg_type, tostring(err), dtcost))
	else
		print(string.format("处理消息码 %s 成功, 耗时: %f, ", msg_type, dtcost))
	end
end

function Client:DumpStatistics()
	for k, v in pairs(self.statistics) do
		print(string.format("msgtype: %d, execute times: %d, cost: %f", k, v.times, v.cost))
	end
end

function Client:DumpPacket(data)
	if not self.networkDebug then
		return
	end

	local s = "binpack:DUMP(" .. #data .. ") \n"
	for i = 1, #data do
		s = s .. string.format("%02X ", string.byte(data, i))
		if (i%16) == 0 then s = s .. "\n" end
	end
	print(s .. "\n")
end

return Client
