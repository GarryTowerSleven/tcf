--Utilities for meta tables -ZAK

module( "util", package.seeall )

local function toFixedPoint16(n) return math.floor( (n*256) + .5 ) + INTRANGE end
local function fromFixedPoint16(n) return (n - INTRANGE)/256 end

local atopack = 511 / 360
local afrompack = 360 / 511

--Creates a callback list (power of 2 + mask) from a table of strings
--To be used with "AddListener"
function CallbackList(t, listindex)
	local env = getfenv(2)
	local cblist = env
	if listindex then
		env[listindex] = {}
		cblist = env[listindex]
	end

	local cbx = 1
	for k,v in pairs(t) do
		cblist["CB_" .. tostring(v)] = cbx
		cbx = cbx * 2
	end

	cblist["CB_ALL"] = cbx-1
end

--Makes the object observable (creates listener system)
function MakeObservable(obj, cblist)
	local env = getfenv(2)
	cblist = cblist or env

	obj.__callbacks = {}
	obj.AddListener 	= function(self, func, mask) self.__callbacks[func] = mask or cblist.CB_ALL end
	obj.RemoveListener 	= function(self, func) self.__callbacks[func] = nil end
	obj.FireListeners 	= function(self, cb, ...) 
		for k,v in pairs(self.__callbacks) do 
			if bit.band(cb, v) ~= 0 then local b,e = pcall(k, cb, ...) if not b then print(e) end end
		end
	end
end

--Creates transform functions and data for the given object
function MakeTransformable2D(obj, callback)
	obj.__matrix = Matrix()
	obj.__tx = 0
	obj.__ty = 0
	obj.__tr = 0
	obj.__tsx = 1
	obj.__tsy = 1
	obj.__dirtyLinear = false
	obj.__dirtyAffine = false

	--Fire callbacks when any part of the transform is changed: (pos, rot, scale)
	local function cb(self,cbx,...) if callback then self:FireListeners( callback, cbx, ... ) 	end end
	local function daff(self,cdn,...) if cdn then self.__dirtyAffine = true cb(self,...) 		end end
	local function dlin(self,cdn,...) if cdn then self.__dirtyLinear = true cb(self,...) 		end end
	local function frot(r) if r < 0 then r = r + 360 end return math.fmod(r, 360) end

	--Setters
	obj.SetPos 		= function(self, x, y) daff(self,self.__tx ~= x or self.__ty ~= y, 		 "pos", x, y) 		self.__tx, self.__ty 	= x, y end
	obj.SetRotation = function(self, r) r = frot(r) 	dlin(self,self.__tr ~= r, 			 "rot", r) 			self.__tr 				= r end
	obj.SetScale 	= function(self, sx, sy) dlin(self,self.__tsx ~= sx or self.__tsy ~= sy, "scale", sx, sy) 	self.__tsx, self.__tsy 	= sx, sy end

	--Getters
	obj.GetPos 		= function(self) return self.__tx, self.__ty end
	obj.GetRotation = function(self) return self.__tr end
	obj.GetScale 	= function(self) return self.__tsx, self.__tsy end

	--Manipulators
	obj.Translate 	= function(self, x, y) local tx,ty = self:GetPos() self:SetPos(tx+x, ty+y) end
	obj.Rotate 		= function(self, r) self:SetRotation( self:GetRotation() + r ) end
	obj.Scale 		= function(self, x, y) local sx,sy = self:GetScale() self:SetScale(sx*x, sy*y) end

	--[[
		a = 
		[c, -s]
		[s,  c]

		b = 
		[sx, 0]
		[0, sy]

		c =
		[c * sx - s * 0, -s * sy + c * 0]
		[s * sx + c * 0, s * 0 + c * sy ]
	]]

	--Build the matrix (if needed) and return it
	obj.GetTransform = function(self)
		if self.__dirtyLinear then
			local theta = math.rad(self.__tr)
			local sin = math.sin(theta)
			local cos = math.cos(theta)
			obj.__matrix:SetField(1,1,cos * self.__tsx)
			obj.__matrix:SetField(1,2,-sin * self.__tsy)
			obj.__matrix:SetField(2,1,sin * self.__tsx)
			obj.__matrix:SetField(2,2,cos * self.__tsy)
			self.__dirtyLinear = false
		end
		if self.__dirtyAffine then
			obj.__matrix:SetField(1,4,self.__tx)
			obj.__matrix:SetField(2,4,self.__ty)
			self.__dirtyAffine = false
		end
		return obj.__matrix
	end

	--Compact transform table
	obj.GetXForm = function(self) return {self.__tx, self.__ty, self.__tr, self.__tsx, self.__tsy} end
	obj.SetXForm = function(self, xf) self:SetPos(xf[1],xf[2]) self:SetRotation(xf[3]) self:SetScale(xf[4], xf[5]) end

	obj.WriteNetXForm = function(self, stream)
		local t = self:GetXForm()
		if stream then
			stream:WriteBits( math.floor(t[1] + .5) + 512, 12 )
			stream:WriteBits( math.floor(t[2] + .5) + 512, 12 )
			stream:WriteBits( math.floor(t[3] * atopack + .5), 9 )
			stream:WriteBits( toFixedPoint16( t[4] ), 16 )
			stream:WriteBits( toFixedPoint16( t[5] ), 16 )
			return
		end
		net.WriteInt( math.floor(t[1] + .5), 12 )
		net.WriteInt( math.floor(t[2] + .5), 12 )
		net.WriteUInt( math.floor(t[3] * atopack + .5), 9 )
		net.WriteUInt( toFixedPoint16( t[4] ), 16 )
		net.WriteUInt( toFixedPoint16( t[5] ), 16 )
	end
	obj.ReadNetXForm = function(self, stream)
		local t = {}
		if stream then
			t[1] = stream:ReadBits( 12 ) - 512
			t[2] = stream:ReadBits( 12 ) - 512
			t[3] = stream:ReadBits( 9 ) * afrompack
			t[4] = fromFixedPoint16( stream:ReadBits( 16 ) )
			t[5] = fromFixedPoint16( stream:ReadBits( 16 ) )
			self:SetXForm(t)
			return
		end
		t[1] = net.ReadInt(12)
		t[2] = net.ReadInt(12)
		t[3] = net.ReadUInt( 9 ) * afrompack
		t[4] = fromFixedPoint16( net.ReadUInt(16) )
		t[5] = fromFixedPoint16( net.ReadUInt(16) )
		self:SetXForm(t)
	end
end

--Creates functions for manipulating object positions in a table
function MakeOrderFunctions(obj, subtype, tab, callback)

	obj["Move" .. subtype .. "Up"] = function(self, instance)
		local t, c = self[tab]
		local a = table.KeyFromValue( t, instance )
		local b = a - 1
		if t[b] == nil then return end

		c = t[a]
		t[a] = t[b]
		t[b] = c

		if callback then obj:FireListeners( callback, a, b, t[a], t[b] ) end
	end

	obj["Move" .. subtype .. "Down"] = function(self, instance)
		local t, c = self[tab]
		local a = table.KeyFromValue( t, instance )
		local b = a + 1
		if t[b] == nil then return end

		c = t[a]
		t[a] = t[b]
		t[b] = c

		if callback then obj:FireListeners( callback, a, b, t[a], t[b] ) end
	end

	obj["Move" .. subtype .. "ToTop"] = function(self, instance)
		local t, c = self[tab]
		local a = table.KeyFromValue( t, instance )
		local b = table.GetFirstKey( t )

		c = t[a]
		t[a] = t[b]
		t[b] = c

		if callback then obj:FireListeners( callback, a, b, t[a], t[b] ) end
	end

	obj["Move" .. subtype .. "ToBottom"] = function(self, instance)
		local t, c = self[tab]
		local a = table.KeyFromValue( t, instance )
		local b = table.GetLastKey( t )

		c = t[a]
		t[a] = t[b]
		t[b] = c

		if callback then obj:FireListeners( callback, a, b, t[a], t[b] ) end
	end

end