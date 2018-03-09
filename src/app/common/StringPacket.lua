 
local StringPacket = class("StringPacket", function()
	return {}
end)

function StringPacket.create(...)
	local packet = StringPacket.new(...)
	return packet
end

function StringPacket:ctor()
	self.data = {}
end

function StringPacket:write(str)
	self.data[#self.data + 1] = str
end

function StringPacket:getData()
   
	local s = table.concat(self.data, ";")
	local len = s:len()
    print(string.format("len:%d s:%s",len,s))

	print(string.format("SEND %8d bytes, TYPE:%s", len, self.data[1]))

	local high = math.floor(len/256)
	local low = len % 256
    print(string.format("high:%d low:%d",high,low))
    local d = {string.char(low), string.char(high), s}
	return table.concat(d)
end
function StringPacket:getString()

    local s = table.concat(self.data, ";")
    return s;
end

return StringPacket