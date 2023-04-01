local meta = nil
IsVec2 = function(v)
	return type(v) == "table" and getmetatable(v).__class == "Vec2"
end

module( "Vec2", package.seeall )

local ctor = nil
local xyret = {}
meta = {__class = "Vec2"}

meta.__index = function(self,k)
	if k == 'x' then return rawget(self, 'x') end
	if k == 'y' then return rawget(self, 'y') end
	if k == 1 then return rawget(self, 'x') end
	if k == 2 then return rawget(self, 'y') end
	if k == "xy" then 
		xyret[1] = self.x
		xyret[2] = self.y
		return xyret
	end
	return meta[k]
end

meta.__newindex = function(self,k,v)
	if k == 'x' then rawset(self, 'x', v) end
	if k == 'y' then rawset(self, 'y', v) end
	if k == 1 then rawset(self, 'x', v) end
	if k == 2 then rawset(self, 'y', v) end
	rawset(self,k,v)
end

meta.__tostring = function(self)
	return self.x .. ", " .. self.y
end

meta.__add = function(a,b)
	if not IsVec2(a) then error("__add argument 1 was not a vector: " .. type(a)) end
	if not IsVec2(b) then error("__add argument 2 was not a vector: " .. type(b)) end
	return ctor(a.x + b.x, a.y + b.y)
end

meta.__sub = function(a,b)
	if not IsVec2(a) then error("__sub argument 1 was not a vector: " .. type(a)) end
	if not IsVec2(b) then error("__sub argument 2 was not a vector: " .. type(b)) end
	return ctor(a.x - b.x, a.y - b.y)
end

meta.__mul = function(a,b)
	if IsVec2(a) then
		if IsVec2(b) then
			return ctor(a.x * b.x, a.y * b.y)
		elseif type(b) == "number" then
			return ctor(a.x * b, a.y * b)
		end
	end
	if IsVec2(b) then
		if type(a) == "number" then
			return ctor(a * b.x, a * b.y)
		end
	end
	error("invalid arguments supplied for multiplication")
end

meta.__div = function(a,b)
	if IsVec2(a) then
		if IsVec2(b) then
			return ctor(a.x / b.x, a.y / b.y)
		elseif type(b) == "number" then
			return ctor(a.x / b, a.y / b)
		end
	end
	if IsVec2(b) then
		if type(a) == "number" then
			return ctor(a / b.x, a / b.y)
		end
	end
	error("invalid arguments supplied for multiplication")
end

meta.__unm = function(a)
	return ctor(-a.x, -a.y)
end

meta.__eq = function(a,b)
	if not IsVec2(a) then return false end
	if not IsVec2(b) then return false end
	return a.x == b.x and a.y == b.y
end

meta.__lt = function(a,b)
	if not IsVec2(a) then return false end
	if not IsVec2(b) then return false end
	return a.x < b.x or (a.x == b.x and a.y < b.y)
end

meta.__le = function(a,b)
	if not IsVec2(a) then return false end
	if not IsVec2(b) then return false end
	return a.x <= b.x and a.y <= b.y
end

meta.__num = function(a) return 2 end

function meta:Snap(other, range)
	if self:Distance(other) < range then
		self.x = other.x
		self.y = other.y
	end
end

function meta:Clone()
	return ctor(self.x, self.y)
end

function meta:Cross(other)
	if not IsVec2(other) then error("Attempted to cross vector with " .. type(other)) end
	return self.x*other.y - self.y*other.x
end

function meta:Dot(other)
	if not IsVec2(other) then error("Attempted to dot vector with " .. type(other)) end
	return self.x * other.x + self.y * other.y
end

function meta:DotAbs(other)
	if not IsVec2(other) then error("Attempted to dot vector with " .. type(other)) end
	return math.abs(self.x * other.x) + math.abs(self.y * other.y)
end

function meta:LengthSquared()
	return self.x * self.x + self.y * self.y
end

function meta:Length()
	return math.sqrt(self:LengthSquared())
end

function meta:Distance(other)
	if not IsVec2(other) then error("Attempted to measure distance from vector to " .. type(other)) end
	return (other - self):Length()
end

function meta:DistanceSquared(other)
	if not IsVec2(other) then error("Attempted to measure distance from vector to " .. type(other)) end
	return (other - self):LengthSquared()
end

function meta:GetPerpendicular()
	return ctor(self.y, -self.x)
end

function meta:MakePerpendicular()
	local x = self.x
	self.x = self.y
	self.y = -x
	return self
end

function meta:Normalize()
	if self:Length() == 0 then
		self.x = 0
		self.y = 0
		return self
	end

	local d = 1 / self:Length()
	self.x = self.x * d
	self.y = self.y * d
	return self
end

function meta:GetNormal()
	return self:Clone():Normalize()
end

function meta:NormalTo(other)
	return (other - self):Normalize()
end

function meta:FromPolar(r,d)
	d = d or 1
	self.x = math.cos(r) * d
	self.y = math.sin(r) * d
	return self
end

function meta:Rotate(r)
	local y = self.y * math.cos(r) + self.x * math.sin(r)
	local x = self.x * math.cos(r) - self.y * math.sin(r)
	self.x = x
	self.y = y
	return self
end

function meta:ToPolar()
	local l = self:Length()
	local d = 1 / l
	return math.atan2(self.y * d, self.x * d), l
end

function meta:AddDelta(other)
	if not IsVec2(other) then error("Attempted to add non-vector") end
	self.x = self.x + other.x
	self.y = self.y + other.y
end

function meta:InBox(min,max)
	return (self.x > min.x and self.x < max.x) and (self.y > min.y and self.y < max.y)
end

function meta:LineTo(other)
	if not IsVec2(other) then error("Line to non-vector") end

	love.graphics.line(self.x, self.y, other.x, other.y)
end

function meta:Plot(s)
	love.graphics.circle("fill", self.x, self.y, s or 4)
end

function meta:Put(t)
	table.insert(t, self.x)
	table.insert(t, self.y)
end

function meta:Set(x,y)
	if IsVec2(x) then 
		self.y = x.y
		self.x = x.x
		return self
	end

	self.x = x
	self.y = y
	return self
end

function meta:Add(other)
	if not IsVec2(other) then error("Attempted to set to non-vector") end
	self.x = self.x + other.x
	self.y = self.y + other.y
	return self
end

function meta:Sub(other)
	if not IsVec2(other) then error("Attempted to set to non-vector") end
	self.x = self.x - other.x
	self.y = self.y - other.y
	return self
end

function meta:Scale(s)
	self.x = self.x * s
	self.y = self.y * s
	return self
end

function meta:AxialType()
	if self.x == -1 then return 1 end
	if self.x == 1 then return 2 end
	if self.y == -1 then return 3 end
	if self.y == 1 then return 4 end
	return 5
end

ctor = function(x,y)

	if type(x) == "string" then
		local x1 = nil
		local y1 = nil
		for s in string.gmatch(x, "[%-*%d*.*%d*]+") do

			print("PVEC: " .. s)

			if x1 == nil then 
				x1 = tonumber(s)
			elseif y1 == nil then 
				y1 = tonumber(s)
			end

		end

		--print("PVEC: " .. tostring(x) .. ":" .. tostring(x1) .. ", " .. tostring(y1))

		x = tonumber(x1 or 0)
		y = tonumber(y1 or 0)
	end

	if IsVec2(x) then
		y = x.y
		x = x.x
	end

	return setmetatable({x=x or 0,y=y or 0}, meta)

end

local __min = ctor()
local __max = ctor()
function meta:PickRect(v,w,h)
	__min = v
	__max.x = __min.x + w
	__max.y = __min.y + h
	return self:InBox(__min, __max)
end

function meta:PickRectCenter(v,w,h)
	return self:PickRect(ctor(v.x-w/2,v.y-h/2),w,h)
end

function meta:Clamp(min,max)
	if self.x < min.x then self.x = min.x end
	if self.y < min.y then self.y = min.y end
	if self.x > max.x then self.x = max.x end
	if self.y > max.y then self.y = max.y end
end

function meta:Max(other)
	if other.x > self.x then self.x = other.x end
	if other.y > self.y then self.y = other.y end
end

function meta:Min(other)
	if other.x < self.x then self.x = other.x end
	if other.y < self.y then self.y = other.y end
end

function meta:Tween(b, frac)
	return ctor(self + (b - self) * frac)
end

_G["Vec2"] = ctor