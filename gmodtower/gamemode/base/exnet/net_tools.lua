
-----------------------------------------------------
--print("NET TOOLS " .. (SERVER and "SERVER" or "CLIENT"))

DT_INVALID = 0
DT_BIT = 1
DT_USHORT = 2
DT_SHORT = 3
DT_UBYTE = 4
DT_BYTE = 5
DT_ANGLE = 6
DT_INT = 7
DT_UINT = 8
DT_FLOAT = 9
DT_STRING = 10
DT_VECTOR2 = 11
DT_VECTOR3 = 12
DT_TRAJECTORY = 13
DT_COLOR = 14
DT_ENTITY = 15

--MAX IS 15

module("exnet", package.seeall)

function rgbaToInt(col)
	local c = 0
	c = bit.bor(c, bit.lshift(col.a, 24))
	c = bit.bor(c, bit.lshift(col.r, 16))
	c = bit.bor(c, bit.lshift(col.g, 8))
	c = bit.bor(c, col.b)
	return c
end

function intToRgba(i)
	local a = bit.band(0xFF, bit.rshift(i, 24))
	local r = bit.band(0xFF, bit.rshift(i, 16))
	local g = bit.band(0xFF, bit.rshift(i, 8))
	local b = bit.band(0xFF, i)
	return Color(r,g,b,a)
end

function WriteDeltaVector(old, new, z)
	local len = 0
	local changes = 0
	if old.x ~= new.x then changes = bit.bor(changes, 1) end
	if old.y ~= new.y then changes = bit.bor(changes, 2) end
	if old.z ~= new.z and z then changes = bit.bor(changes, 4) end

	if z then 
		net.WriteUInt(changes, 3) len = len + 3
	else 
		net.WriteUInt(changes, 2) len = len + 2
	end

	if old.x ~= new.x then net.WriteFloat(new.x) len = len + 32 end
	if old.y ~= new.y then net.WriteFloat(new.y) len = len + 32 end
	if old.z ~= new.z and z then net.WriteFloat(new.z) len = len + 32 end
	return len
end

function ReadDeltaVector(v, z)
	local changes = 0
	if z then changes = net.ReadUInt(3) else 
		changes = net.ReadUInt(2)
	end

	if bit.band(changes, 1) ~= 0 then v.x = net.ReadFloat() end
	if bit.band(changes, 2) ~= 0 then v.y = net.ReadFloat() end
	if z and bit.band(changes, 4) ~= 0 then v.z = net.ReadFloat() end
end


function GetNumBits(v)
	for i=0, 32 do
		local max = bit.lshift(1, i)
		if max > v then return max end
	end
	return 32
end

local function IsFloat(v)
	if type(v) ~= "number" then return false end
	return v ~= math.floor(v)
end

function TypeOf(value)
	if value == true or value == false then return DT_BIT end
	if isvector(value) then return DT_VECTOR3 end
	if isangle(value) then return DT_ANGLE end
	if IsEntity(value) then return DT_ENTITY end
	if IsFloat(value) then return DT_FLOAT end
	if type(value) == "string" then return DT_STRING end
	if type(value) == "number" then
		if value >= 0 then
			if value <= 255 then return DT_UBYTE end
			return value <= 65535 and DT_USHORT or DT_UINT
		end
		if value >= -127 then return DT_BYTE end
		return value >= -32768 and DT_SHORT or DT_INT
	end
	if type(value) == "table" then
		if type(value.r) == "number" and type(value.g) == "number" and type(value.b) == "number" and type(value.a) == "number" then
			return DT_COLOR
		end
	end
	return DT_INVALID
end

function DefWriteValue(vtype, value)
	if vtype == DT_BIT then net.WriteUInt(value == true and 1 or 0, 1) end
	if vtype == DT_UBYTE then net.WriteUInt(value, 8) end
	if vtype == DT_USHORT then net.WriteUInt(value, 16) end
	if vtype == DT_UINT then net.WriteUInt(value, 32) end
	if vtype == DT_BYTE then net.WriteInt(value, 8) end
	if vtype == DT_SHORT then net.WriteInt(value, 16) end
	if vtype == DT_INT then net.WriteInt(value, 32) end
	if vtype == DT_FLOAT then net.WriteFloat(value) end
	if vtype == DT_STRING then net.WriteString(value) end
	if vtype == DT_VECTOR3 then net.WriteVector(value) end
	if vtype == DT_ANGLE then net.WriteAngle(value) end
	if vtype == DT_COLOR then net.WriteUInt(rgbaToInt(value), 32) end
	if vtype == DT_ENTITY then net.WriteEntity(value) end
end

function DefReadValue(vtype)
	if vtype == DT_BIT then return net.ReadUInt(1) == 1 end
	if vtype == DT_UBYTE then return net.ReadUInt(8) end
	if vtype == DT_USHORT then return net.ReadUInt(16) end
	if vtype == DT_UINT then return net.ReadUInt(32) end
	if vtype == DT_BYTE then return net.ReadInt(8) end
	if vtype == DT_SHORT then return net.ReadInt(16) end
	if vtype == DT_INT then return net.ReadInt(32) end
	if vtype == DT_FLOAT then return net.ReadFloat() end
	if vtype == DT_STRING then return net.ReadString() end
	if vtype == DT_VECTOR3 then return net.ReadVector() end
	if vtype == DT_ANGLE then return net.ReadAngle() end
	if vtype == DT_COLOR then return intToRgba(net.ReadUInt(32)) end
	if vtype == DT_ENTITY then return net.ReadEntity() end
	if vtype == DT_INVALID then return -999 end
	ErrorNoHalt("NET_TOOLS: UNABLE TO PROCESS TYPE: " .. vtype)
	return -999
end