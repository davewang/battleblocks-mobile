local lsocket = require "lsocket"
local crypt = require "crypt"
local time = require "timesync"

local socket = {}
local tmo = 1000
local function closefd(self)
	if self.__fd then
		self.__fd:close()
		self.__fd = nil
	end
end

local function readline(self)
	local str = self.__read
	local nl = str:find("\n", 1, true)
	if nl then
		self.__read = str:sub(nl+1)
		return str:sub(1, nl-1)
	end
 
	while lsocket.select(self.__select_rd,tmo) do
		str = str .. self.__fd:recv()
		local nl = str:find("\n", 1, true)
		if nl then
			self.__read = str:sub(nl+1)
			return str:sub(1, nl-1)
		end
	end
end

local function writeline(self, text)
	text = text .. "\n"
	local n = #text
	local wt = self.__fd:send(text)
	if wt == nil then
		lsocket.select(nil, {self.__fd},tmo)
		wt = 0
	end
	local unsend = wt+1
	while wt < n do
		n = n - wt
		wt = assert(self.__fd:send(text:sub(unsend)))
		unsend = unsend + wt
	end
end

local function connect(addr, port)
	local fd = assert(lsocket.connect(addr, port))
	return {
		__fd = fd,
		login = login,
		__read = "",
		__select_rd = { fd },
	}
end
local function unpack_big_s2(text)
    local s_l = string.byte(text,1)*256
    s_l = string.byte(text,2)+s_l
    return string.sub(text,2+1,s_l+2),s_l+2+1
end
local function split_package(text)
	-- read whole package, todo
    local ok, str, offset = pcall(unpack_big_s2,text)--pcall(string.unpack, ">s2", text)
	if not ok then
		return
	end
	return str, text:sub(offset)
end

local function read_package(self, timeout)
	local result, text = split_package(self.__read)
	if result then
		self.__read = text
		return result
	end
-- wait for 1/1000 s, todo: remove it
	local r = lsocket.select(self.__select_rd,timeout)
	if r then
		local rd = self.__fd:recv()
		if rd then
			local text = self.__read .. rd
			local result, text = split_package(text)
			if result then
				self.__read = text
				return result
			else
				self.__read = text
				return false	-- block
			end
		else
			return rd
		end
	else
		return false
	end
end
local function pack_big_s2(str)
       local size = #str 
       local a = size % 256
       local b = math.floor(size / 256)
       return string.char(b)..string.char(a).. str
     
end
local function auth(self, timeout)
	if self.__auth == nil then
		local handshake = self.__token .. self.__index
		self.__index = self.__index + 1
		local hmac = crypt.hmac_hash(self.__secret, handshake)
        local package = pack_big_s2(handshake .. ":" .. crypt.base64encode(hmac))-- string.pack(">s2", handshake .. ":" .. crypt.base64encode(hmac))
		local n = #package
		
		local sb = self.__fd:send(package)
		if sb == false then
			return false
		end
		local unsend = sb + 1
		while sb < n do
			n = n - sb
			sb = self.__fd:send(package:sub(unsend))
			if sb == nil then
				return nil
			end
			if sb == false then
				sb = 0
			else
				unsend = unsend + sb
			end
		end
		self.__auth = false
		return false
	else
		-- recv response
		local pack = read_package(self,timeout)
		if pack then
			if pack ~= "200 OK" then
				self.__auth = nil
				closefd(self)
				error(pack)
			end
			self.__auth = true
		elseif pack == nil then
			-- disconnect
			self.__auth = nil
			return nil
		else
			-- block
			return false
		end
	end
	return true
end

local function send_request(self, data)
	local n = #data
	local sb = self.__fd:send(data)
	if not sb then
		closefd(self)
		return
	end
	local unsend = sb + 1
	while sb < n do
		n = n - sb
		local sb = self.__fd:send(v.data:sub(unsend))
		if not sb then
			closefd(self)
			return
		end
		unsend = unsend + sb
	end
end
local function unpack_big_i4(buf)
    local l = string.byte(buf,1)*256*256*256 
    l = string.byte(buf,2)*256*256+l
    l = string.byte(buf,3)*256+l
    l = string.byte(buf,4)+l
    return l
end
local function unpack_content_ok_session(size, buf)
    local content = string.sub(buf,1,size)
    local ok = string.byte(buf,size+1) --string.sub(buf,size+1,size+1)
    local session = unpack_big_i4(string.sub(buf,size+2,size+6) )
    return content,ok,session
end
local function recv_response(self, timeout)
	if self.__fd == nil then
		return nil
	end
	timeout = timeout or 1000
	if not self.__auth then
		local ret = auth(self, timeout)
		if not ret then
			return ret
		end
		for _, v in ipairs(self.__request) do
			send_request(self, v.data)
			if not self.__fd then
				return nil
			end
		end
	end
	local v = read_package(self,timeout)
	if not v then
		return v
	end
	local size = #v - 5
    local content, ok, session = unpack_content_ok_session(size,v)--string.unpack("c"..tostring(size).."B>I4", v)
	for k,v in ipairs(self.__request) do
		if v.session == session then
			local cb = v.callback
			table.remove(self.__request, k)
			return cb, ok~=0, content
		end
	end
	error("Invalid session " .. session)

	return cb, ok~=0, content
end

local function connect_gameserver(self, addr, port)
	self.__fd = assert(lsocket.connect(addr, port))
	self.login = nil
	self.dispatch = recv_response
	self.__host = addr
	self.__port = port
	self.__read = ""
	self.__select_rd[1] = self.__fd
	self.__request = {}
	self.__auth = nil
	self.__index = 1
	self.__session = 1
end

local function reconnect_gameserver(self)
	closefd(self)
	self.__fd = assert(lsocket.connect(self.__host, self.__port))
	self.__read = ""
	self.__select_rd[1] = self.__fd
	self.__auth = nil
	self.__index = self.__index + 1
end
local function pack_big_i2(size)
     
    local a = size % 256
    local b = math.floor(size / 256)
    return string.char(b) .. string.char(a)
end
local function pack_big_i4(id)
    local a = id % 256
    id = math.floor(id / 256)
    local b = id % 256
    id = math.floor(id / 256)
    local c = id % 256
    id = math.floor(id / 256)
    local d = id
    return string.char(d)..string.char(c)..string.char(b)..string.char(a)
end
local function request_gameserver(self, req, callback)
	local session = self.__session
	local r = {
		session = session,
        data = pack_big_i2( #req + 4)..req..pack_big_i4(session),--string.pack(">I2", #req + 4)..req..string.pack(">I4", session),
		callback = assert(callback),
	}
	table.insert(self.__request, r)
	self.__session = session + 1
	if self.__auth then
		send_request(self, r.data)
	end
end

function socket.login(token)
	local self = connect(token.host, token.port)
	 
	local challenge = crypt.base64decode(readline(self))
	local clientkey = crypt.randomkey()
	writeline(self, crypt.base64encode(crypt.dhexchange(clientkey)))
	local secret = crypt.dhsecret(crypt.base64decode(readline(self)), clientkey)

	local hmac = crypt.hmac64(challenge, secret)
	writeline(self, crypt.base64encode(hmac))

	local function encode_token(token)
		return string.format("%s@%s:%s*%s",
			crypt.base64encode(token.user),
			crypt.base64encode(token.server),
			crypt.base64encode(token.pass),
            crypt.base64encode(token.platform))
	end

	local etoken = crypt.desencode(secret, encode_token(token))
	local b = crypt.base64encode(etoken)
	writeline(self, crypt.base64encode(etoken))

	local result = readline(self)
	local code = tonumber(string.sub(result, 1, 3))
	closefd(self)
	if code == 200 then
		self.__secret = secret
		local subid = crypt.base64decode(string.sub(result, 5))
		self.__token = string.format("%s@%s#%s:", crypt.base64encode(token.user), crypt.base64encode(token.server),crypt.base64encode(subid))
		crypt.base64decode(string.sub(result, 5))
		self.secret = secret
		self.connect = connect_gameserver
		self.request = request_gameserver
		self.reconnect = reconnect_gameserver
		return self
	else
	    return nil	-- error(string.sub(result, 5))
	end
end

local function pack_little_i4(id)
    local a = id % 256
    id = math.floor(id / 256)
    local b = id % 256
    id = math.floor(id / 256)
    local c = id % 256
    id = math.floor(id / 256)
    local d = id
    return string.char(a)..string.char(b)..string.char(c)..string.char(d)
end

local function pack_little_iii(a,b,c)
    local r = pack_little_i4(a)
    r = r.. pack_little_i4(b)
    r = r.. pack_little_i4(c)
    return r
end

local function udp_sync(self)
	local now = time.localtime()
    local data = pack_little_iii(now, 0xffffffff, self.__session) --string.pack("<III", now, 0xffffffff, self.__session)
	data = crypt.hmac_hash(self.__secret, data) .. data
	self.__fd:send(data)
end

local function udp_send(self, data)
--    print("udp_send time.localtime() = ",time.localtime())
--    print("udp_send time.globaltime() = ",time.globaltime())
--    print("udp_send self.__session() = ",self.__session)
    
   -- print("localtime %s eventtime %d session %d data %s", time.localtime(), time.globaltime(), self.__session,data)
    data = pack_little_iii( time.localtime(), 1111, self.__session) .. data--string.pack("<III", time.localtime(), time.globaltime(), self.__session) .. data

   -- data = pack_little_iii( time.localtime(), time.globaltime(), self.__session) .. data--string.pack("<III", time.localtime(), time.globaltime(), self.__session) .. data
	data = crypt.hmac_hash(self.__secret, data) .. data
	self.__fd:send(data)
end
local function unpack_little_i(buf)
    local l = string.byte(buf,4)*256*256*256 
    l = string.byte(buf,3)*256*256+l
    l = string.byte(buf,2)*256+l
    l = string.byte(buf,1)+l
    return l
end
local function unpack_little_iiii(buf)
    local a = unpack_little_i(string.sub(buf,1,4))
    local b = unpack_little_i(string.sub(buf,5,8))
    local c = unpack_little_i(string.sub(buf,9,12))
    local d = unpack_little_i(string.sub(buf,13,16))
    
    return a,b,c,d,17
end


local function udp_recv(self)
	local data = self.__fd:recv()
	if data then
        local globaltime, localtime, eventtime, session = unpack_little_iiii(data)--string.unpack("<IIII", data)
--		if session == self.__session then
--			time.sync(localtime, globaltime)
--		end
		data = data:sub(17)
--		if data ~= "" then
			return eventtime, session, data
--		end
	end
end

function socket.udp(conf)
	local fd = assert(lsocket.connect("udp", conf.host, conf.port))
	return {
		__fd = fd,
		__secret = conf.secret,
		__session = conf.session,
		send = udp_send,
		recv = udp_recv,
		sync = udp_sync,
	}
end

local function pack_little_i2(size)
     
    local a = size % 256
    local b = math.floor(size / 256)
    return string.char(a) .. string.char(b)
end
local function unpack_little_i2(text)
    local s_l = string.byte(text,2)*256
    s_l = string.byte(text,1)+s_l
    return s_l,3
end

local function tcp_post(self, text)
	local n = #text
	local wt = self.__fd:send(text)
	if wt == nil then
		lsocket.select(nil, {self.__fd},tmo)
		wt = 0
	end
	local unsend = wt+1
	while wt < n do
		n = n - wt
		wt = assert(self.__fd:send(text:sub(unsend)))
		unsend = unsend + wt
	end
end
local function tcp_sync(self)
	local now = time.localtime()
	local data = pack_little_i4(self.__session)--string.pack("<I", self.__session)
	data = crypt.hmac_hash(self.__secret, data) .. data
	data = pack_little_i2(string.len(data)+2) .. data --string.pack("<I2",string.len(data)+2)..data
	self.post(self,data)
end

local function tcp_send(self, data)
	--print(string.len(data))
	data = pack_little_i4(self.__session) .. data --string.pack("<I", self.__session) .. data
	--print(string.len(data))
	data = crypt.hmac_hash(self.__secret, data) .. data
	--print(string.len(data))
	data = pack_little_i2(string.len(data)+2) .. data --string.pack("<I2",string.len(data)+2)..data
	--print(string.len(data))
	self.post(self,data)
end

local function tcp_recv(self)


	local str = self.__read
	 
	if string.len(str) >= 2 then
	    local sz,offset = unpack_little_i2(str)--string.unpack("<I2", str)
		if string.len(str) >= sz then
		    self.__read = str:sub(sz+1)
			local data = str:sub(offset, offset+(sz-2))
			local session = unpack_little_i(data)--string.unpack("<I", data)
			 
			return session,data:sub(5)
		end
 
	end
  
	
	
	local r = lsocket.select({self.__fd},0)
	if r then
		local rc = self.__fd:recv()
		if rc == nil then
		    return
		end
		str = str .. rc
		if string.len(str) >= 2 then
		    local sz,offset = unpack_little_i2(str)--string.unpack("<I2", str)
			if string.len(str) >= sz then
			    self.__read = str:sub(sz+1)
				local data = str:sub(offset, offset+(sz-2))
				local session = unpack_little_i(data)--string.unpack("<I", data)
				return session,data:sub(5)
			end
		end
	end
end

function socket.tcp(conf)
	local fd = assert(lsocket.connect(conf.host, conf.port))
	return {
		__fd = fd,
		__secret = conf.secret,
		__session = conf.session,
		__read = "",
		send = tcp_send,
		recv = tcp_recv,
		sync = tcp_sync, 
		post = tcp_post,
	}
end
return socket
