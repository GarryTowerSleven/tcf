local MVector = FindMetaTable("Vector")

function MVector:Min(o)
	self.x = (o.x < self.x) and o.x or self.x
	self.y = (o.y < self.y) and o.y or self.y
	self.z = (o.z < self.z) and o.z or self.z
end

function MVector:Max(o)
	self.x = (o.x > self.x) and o.x or self.x
	self.y = (o.y > self.y) and o.y or self.y
	self.z = (o.z > self.z) and o.z or self.z
end

function MVector:ProjectVector( b )
	local inv_denom = 1.0 / b:Dot(b)
	local d = b:Dot(self) * inv_denom
	return self - (b * inv_denom) * d
end

local _v0 = {}
local _v1 = {}
function MVector:GetPerpendicular()
	local pos = 0
	local len = 1

	_v0[1] = self.x
	_v0[2] = self.y
	_v0[3] = self.z

	_v1[1] = 0
	_v1[2] = 0
	_v1[3] = 0

	for i=1, 3 do
		local d = math.abs( _v0[i] )
		if d < len then
			pos = i
			len = d
		end
	end

	_v1[pos] = 1.0
	local v = Vector(_v1[1], _v1[2], _v1[3]):ProjectVector(self) v:Normalize()
	return v
end

function MVector:WithinDistance( pos, dist )
	return self:DistToSqr( pos ) < ( dist * dist )
end