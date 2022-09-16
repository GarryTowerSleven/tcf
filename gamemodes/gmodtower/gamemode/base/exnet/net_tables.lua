--print("NET TABLES " .. (SERVER and "SERVER" or "CLIENT"))

module("exnet", package.seeall)

--LOCALS
local fnCreateTrajectory = nil
local FRAME_SENT_LEN = 0
local DTF = {}
DTF.__index = DTF

function DTF:ForceChange( k )
	self.__shadow[k] = nil
	if self.__shadow[k] == self.__content[k] then 
		self.__shadow[k] = 1
	end
end

function DTF:DTCompare( k )
	local dttab = self.__datatable

	if dttab[k][1] == DT_TRAJECTORY then
		return self.__content[k].dt:HasChanged()
	end

	if dttab[k][1] >= DT_CUSTOM then
		local reg = exnet.GetCustomType(vtype)
		if reg and reg.compare then 
			return reg.compare(self.__shadow[k], self.__content[k])
		end
	end

	return self.__shadow[k] ~= self.__content[k]
end

function DTF:GetChangeFlags( complete, incl )
	local dtvars = 0
	local dttab = self.__datatable
	local i = 0
	local ch = ""

	if complete then
		if not incl then
			return bit.lshift(1, self.__dt_bits) - 1
		else
			for k,v in pairs(dttab) do
				if incl[k] then dtvars = bit.bor(dtvars, bit.lshift(1, i)) end
				i = i + 1
			end
			return dtvars
		end
	end

	for k,v in pairs(dttab) do

		if not incl then
			if self:DTCompare(k) then
				dtvars = bit.bor(dtvars, bit.lshift(1, i))
			end
		else
			if incl[k] and self:DTCompare(k) then
				dtvars = bit.bor(dtvars, bit.lshift(1, i))
			end
		end

		i = i + 1
	end

	return dtvars
end

function DTF:Conform()
	for k,v in pairs(self.__datatable) do
		if v[1] == DT_VECTOR2 or v[1] == DT_VECTOR3 then
			self.__shadow[k].x = self.__content[k].x
			self.__shadow[k].y = self.__content[k].y
			self.__shadow[k].z = self.__content[k].z
		else
			self.__shadow[k] = self.__content[k]
		end
	end
end

function DTF:HasChanged()
	return self:GetChangeFlags() ~= 0
end

function DTF:Post( complete, incl )
	local dttab = self.__datatable
	local dtvars = self:GetChangeFlags( complete, incl )
	local i = 0

	net.WriteUInt( dtvars, self.__dt_bits )

	FRAME_SENT_LEN = self.__dt_bits

	--print("DT_BITS: " .. dtvars)

	for k,v in pairs(dttab) do

		local band = bit.band(dtvars, bit.lshift(1, i))
		if band ~= 0 then
		--if complete or self:DTCompare(k) then

			--print("SEND: " .. k .. " : " .. tostring(self.__content[k]))
			local vtype = v[1]
			local varg = v[2]

			if vtype == DT_BIT then
				local a = 0
				if self.__content[k] == true or self.__content[k] == 1 then a = 1 end
				net.WriteUInt( a, 1 )
				FRAME_SENT_LEN = FRAME_SENT_LEN + 1
			elseif vtype == DT_INT then
				net.WriteInt( self.__content[k], varg or 32 )
				FRAME_SENT_LEN = FRAME_SENT_LEN + varg or 32
			elseif vtype == DT_UINT then
				net.WriteUInt( self.__content[k], varg or 32 )
				FRAME_SENT_LEN = FRAME_SENT_LEN + varg or 32
			elseif vtype == DT_FLOAT then
				net.WriteFloat( self.__content[k] )
				FRAME_SENT_LEN = FRAME_SENT_LEN + 32
			elseif vtype == DT_STRING then
				net.WriteString( self.__content[k] )
				FRAME_SENT_LEN = FRAME_SENT_LEN + string.len(self.__content[k]) + 1
			elseif vtype == DT_VECTOR2 or vtype == DT_VECTOR3 then
				FRAME_SENT_LEN = FRAME_SENT_LEN + exnet.WriteDeltaVector( self.__shadow[k], self.__content[k], vtype == DT_VECTOR3 )
			elseif vtype == DT_TRAJECTORY then
				self.__content[k].dt:Post( complete )
			elseif vtype == DT_COLOR then
				net.WriteUInt( exnet.rgbaToInt( self.__content[k] ), 32 )
			elseif vtype == DT_ENTITY then
				net.WriteEntity( self.__content[k] )
			elseif vtype >= DT_CUSTOM then
				local reg = exnet.GetCustomType(vtype)
				if not reg then 
					ErrorNoHalt("ERROR: Unknown Custom Type: " .. vtype) 
				else
					reg.write(self.__content[k])
				end
			end

			if not complete then
				if vtype ~= DT_TRAJECTORY and not (vtype == DT_VECTOR2 or vtype == DT_VECTOR3) then
					self.__shadow[k] = self.__content[k]
				end

				if vtype == DT_VECTOR2 or vtype == DT_VECTOR3 then
					self.__shadow[k].x = self.__content[k].x
					self.__shadow[k].y = self.__content[k].y
					self.__shadow[k].z = self.__content[k].z
				end
			end

		end

		i = i + 1
	end

	return self, FRAME_SENT_LEN
end

function DTF:Receive()
	local dtvars = net.ReadUInt( self.__dt_bits )
	local dttab = self.__datatable
	local complete = (dtvars == bit.lshift(1, self.__dt_bits) - 1 )
	local i = 0

	--print("DT_BITS: " .. dtvars)

	for k,v in pairs(dttab) do

		local band = bit.band(dtvars, bit.lshift(1, i))
		if complete or band ~= 0 then
		
			local vtype = v[1]
			local varg = v[2]

			if vtype == DT_BIT then
				self.__content[k] = net.ReadUInt( 1 )
				if self.__content[k] == 0 then self.__content[k] = false 
				else self.__content[k] = true end
			elseif vtype == DT_INT then
				self.__content[k] = net.ReadInt( varg or 32 )
			elseif vtype == DT_UINT then
				self.__content[k] = net.ReadUInt( varg or 32 )
			elseif vtype == DT_FLOAT then
				self.__content[k] = net.ReadFloat()
			elseif vtype == DT_STRING then
				self.__content[k] = net.ReadString()
			elseif vtype == DT_VECTOR2 or vtype == DT_VECTOR3 then
				exnet.ReadDeltaVector( self.__content[k], vtype == DT_VECTOR3 )
			elseif vtype == DT_TRAJECTORY then
				self.__content[k].dt:Receive()
			elseif vtype == DT_COLOR then
				self.__content[k] = exnet.intToRgba( net.ReadUInt(32) )
			elseif vtype == DT_ENTITY then
				self.__content[k] = net.ReadEntity()
			elseif vtype >= DT_CUSTOM then
				local reg = exnet.GetCustomType(vtype)
				if not reg then 
					ErrorNoHalt("ERROR: Unknown Custom Type: " .. vtype) 
				else
					self.__content[k] = reg.read()
				end
			end

			self:VarChanged(k, self.__shadow[k], self.__content[k])

			if vtype ~= DT_TRAJECTORY and not (vtype == DT_VECTOR2 or vtype == DT_VECTOR3) then
				self.__shadow[k] = self.__content[k]
			end

			if vtype == DT_VECTOR2 or vtype == DT_VECTOR3 then
				self.__shadow[k].x = self.__content[k].x
				self.__shadow[k].y = self.__content[k].y
				self.__shadow[k].z = self.__content[k].z
			end

			--print("RECV: " .. k .. " : " .. tostring(self.__content[k]))

		end

		i = i + 1
	end

	return self
end

function DTF:VarChanged( var, old, new ) end

function DTF.__index( self, key )
	local get = rawget(DTF, key)
	if get then return get end

	return rawget(self, "data")[key]
end

function DTF.__newindex( self, key, value )
	rawget(self, "data")[key] = value
end

function CreateNetTable( types )
	local tab = {}
	local meta = {}
	tab.__datatable = types
	tab.__shadow = {}
	tab.__content = {}

	local n = 0
	for k,v in pairs(types) do
		if v[1] == DT_TRAJECTORY then
			tab.__content[k] = fnCreateTrajectory()
		elseif v[1] == DT_VECTOR2 or v[1] == DT_VECTOR3 then
			tab.__content[k] = Vector(0,0,0)
			tab.__shadow[k] = Vector(0,0,0)
		elseif v[1] == DT_COLOR then
			tab.__content[k] = Color(0,0,0)
			tab.__shadow[k] = Color(0,0,0)			
		else
			tab.__content[k] = 0
		end
		n = n + 1
	end

	tab.__dt_bits = n

	meta.__index = function( self, key )
		return tab.__content[key]
	end

	meta.__newindex = function( self, key, value )
		tab.__content[key] = value
	end

	tab.data = {}

	setmetatable( tab.data, meta )
	setmetatable( tab, DTF )

	return tab
end

local TRJ = {}
TRJ.__index = TRJ

function TRJ:Init()
	self.dt = Create({
		["pos"] = { DT_VECTOR2 },
		["vel"] = { DT_VECTOR2 },
		["time"] = { DT_FLOAT },
		["mode"] = { DT_UINT, 2 },
	})

	self.dt.pos = Vector(0,0,0)
	self.dt.vel = Vector(0,0,0)
	self.dt.time = CurTime()
	self.dt.mode = TR_LINEAR
	self.dt:Conform()
	return self
end

function TRJ:GetPos(time)
	time = time or CurTime()
	return self:Evaluate(time)
end

function TRJ:SetPos(pos)
	self.dt.pos = pos
	self.dt.time = CurTime()
end

function TRJ:SetVel(vel)
	local t = CurTime()
	local ch = vel.x ~= self.dt.vel.x or vel.y ~= self.dt.vel.y
	if not ch then return end

	local current = self:Evaluate( t )
	self.dt.pos.x = current.x
	self.dt.pos.y = current.y
	self.dt.vel.x = vel.x
	self.dt.vel.y = vel.y
	self.dt.time = t
end

function TRJ:GetVel()
	return self.dt.vel
end

function TRJ:Evaluate( time )
	local dt = time - self.dt.time
	local pos = self.dt.pos
	local vel = self.dt.vel

	if self.dt.mode == TR_LINEAR then
		return Vector(pos.x + vel.x * dt, pos.y + vel.y * dt, 0)
	end

	return Vector(pos.x, pos.y, 0)
end

function TRJ.__eq(a,b)
	if a.dt.vel ~= b.dt.vel then return false end
	if a.dt.pos ~= b.dt.pos then return false end
	if a.dt.time ~= b.dt.time then return false end
	if a.dt.mode ~= b.dt.mode then return false end
	return true
end

fnCreateTrajectory = function()
	return setmetatable( {}, TRJ ):Init()
end

Trajectory = fnCreateTrajectory