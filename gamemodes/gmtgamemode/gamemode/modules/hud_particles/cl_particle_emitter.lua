module( "particle_emitter", package.seeall )

local meta = {}
local active_emitters = {}
local class_cache = {}
meta.__index = meta

local function addToActiveEmitters( emitter )
	for k,v in pairs(active_emitters) do
		if v == emitter then return end
	end
	table.insert(active_emitters, emitter)
end

local function removeFromActiveEmitters( emitter )
	for k,v in pairs(active_emitters) do
		if v == emitter then table.remove(active_emitters, k) return end
	end
end

function UpdateAll()
	for i=1, #active_emitters do
		if active_emitters[i] then active_emitters[i]:Update() end
	end
end

function Precache( class, f_text )
	--if class_cache[class] then return end

	if f_text then
		class_cache[class] = particle_params.LoadFromText(f_text)
	else
		class_cache[class] = particle_params.LoadFromFile(class)
	end

	print("REGISTER CLASS: " .. class .. " | " .. type(f_text))
end

function meta:Init( class, system )
	self.class = class_cache[class] or particle_params.LoadFromFile(class)
	self.system = system
	self.overrides = {}

	return self
end

function meta:Set( override, num )
	if type(num) == "number" or not num then
		self.overrides[override or "dummy"] = num
	end
end

function meta:SetPos(x,y)
	self.x = x
	self.y = y
end

function meta:Start( x, y, lifetime )
	self.x = x or 0
	self.y = y or 0
	self.start_time = RealTime()
	self.last_emit_time = self.start_time
	addToActiveEmitters(self)

	if lifetime then
		self.lifetime = lifetime
	end
end

function meta:Stop()
	removeFromActiveEmitters(self)
end

function meta:Update()
	local time = RealTime() - self.start_time
	self.last_emit_time = self.system:SpawnFromParams(self.x, self.y, self.class, time, self.last_emit_time, self.overrides)

	if self.lifetime and time > self.lifetime then self:Stop() end
end

new = function( ... )

	local tab = setmetatable({}, meta):Init( unpack({...}) )
	return tab

end