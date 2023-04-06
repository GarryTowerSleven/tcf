module( "articulator", package.seeall )

local meta = {}
meta.__index = meta

local function curve_interpolate(t, power)
	if t == 0 then return 0 end
	if power > 1 then
		return 1 - (1-t) ^ power
	elseif power < -1 then
		return (t ^ -power)
	else
		return t
	end
end

local function curve_power(p)
	if p > 0 then
		return (1 + p / 100) ^ 4
	elseif p < 0 then
		return -(1 + -p / 100) ^ 4
	end
	return 0
end

function meta:SortPoints()
	table.sort(self.points, function(a,b)
		return a.t < b.t
	end)
end

function meta:GetLastAdded()
	return self.last_point
end

function meta:ClearPoints()
	self.points = {}
	self.num_points = 0
end

function meta:AddPoint(t, v)
	local p = {
		t = t,
		v = v,
		curve = 0,
		ccurve = 0,
		ocurve = 0,
	}

	table.insert(self.points,p)
	self:SortPoints()

	self.num_points = #self.points
	self.last_point = p
	return self
end

function meta:RemovePoint(p)
	for k,v in pairs(self.points) do
		if v == p then
			table.remove(self.points,k)
			return
		end
	end
end

function meta:ApplyQCurve()
	local last = nil
	for _,p in pairs(self.points) do
		if p.ccurve ~= p.ocurve then
			p.curve = curve_power(p.ccurve)
			p.ocurve = p.ccurve
		end
		last = p
	end

	if last then
		last.curve = 0
		last.ccurve = 0
		last.ocurve = 0
	end
end

function meta:GetPointAt(t)
	local i=0
	while self.points[i+1] and self.points[i+1].t <= t do
		i = i + 1
	end
	return i
end

function meta:GetPoints()
	return self.points
end

function meta:Interpolate(t)
	local id = self:GetPointAt(t)
	local p = self.points[id]
	if not p then return 0 end

	local n = self.points[id+1]
	if not n then return p.v end

	local dv = (n.v - p.v)
	if dv == 0 then return p.v end

	local dt = (n.t - p.t)
	local t0 = (t - p.t) / dt
	local interp = curve_interpolate(t0, p.curve)

	if interp > 10000 then
		print("INTERPOLATE ERROR: " .. interp .. " : " .. t0 .. " : " .. p.curve)
	end

	return p.v + interp * dv
end

new = function()

	local tab = setmetatable({
		points = {},
		num_points = 0,
	}, meta)
	
	return tab

end