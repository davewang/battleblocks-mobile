local sproto = require "sproto"

local function loadproto()
--	local f = assert(io.open "proto/lobby.sproto")
--	local proto = f:read "a"
--	f:close()
    local proto = cc.FileUtils:getInstance():getStringFromFile("proto/lobby.sproto")
	return sproto.parse(proto)
end

local P = assert(loadproto())

local proto = {}
local function packvalue(id)
    local a = id % 256
    id = math.floor(id / 256)
    local b = id % 256
    id = math.floor(id / 256)
    local c = id % 256
    id = math.floor(id / 256)
    local d = id
    return string.char(a)..string.char(b)..string.char(c)..string.char(d)
end
function proto.request(type, obj)
	local data , tag = P:request_encode(type,obj)
	
	return sproto.pack(packvalue(tag) .. data), tag
	--return sproto.pack(string.pack("<I4",tag) .. data), tag
end

function proto.response(type, blob)
	local data = sproto.unpack(blob)
	return P:response_decode(type, data)
end

return proto
