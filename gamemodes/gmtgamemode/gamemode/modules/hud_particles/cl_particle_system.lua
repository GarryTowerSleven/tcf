module( "particle_system", package.seeall )

local mat_white = Material("vgui/white.vmt")
local meta = {}
meta.__index = meta

function meta:Init( limit, num_scale )
	self.particles = {}
	self.particle_pool = {}
	self.limit = limit or 1000
	self.num_scale = num_scale or 1
	for i=1, limit do
		table.insert(self.particle_pool, {})
	end

	return self
end

function meta:Count()
	return #self.particles
end

function meta:Spawn()
	if #self.particle_pool == 0 then 
		self:Remove( 1 )
	end

	local pooled = self.particle_pool[1]
	table.remove(self.particle_pool, 1)
	table.insert(self.particles, pooled)
	return pooled
end

function meta:Remove( id )
	local topool = self.particles[id]
	table.remove(self.particles, id)
	table.insert(self.particle_pool, topool)
end

local function drawParticle(p, dt)
	local lt = RealTime() - p.time
	local ldt = (lt / p.life) * 3

	local r = p.values.color_red:Interpolate(ldt)
	local g = p.values.color_green:Interpolate(ldt)
	local b = p.values.color_blue:Interpolate(ldt)
	local a = p.values.color_alpha:Interpolate(ldt)
	local size = p.size * p.values.size:Interpolate(ldt) * 2
	local image = p.image

	surface.SetMaterial(image or mat_white)
	surface.SetDrawColor(r,g,b,a)
	surface.DrawTexturedRectRotated( p.x, p.y, size, size, p.r )
end

local function updateParticle(p, dt)
	local lt = RealTime() - p.time
	if lt > p.life then p.die = true return end

	local ldt = (lt / p.life) * 3

	local spin = p.spin * p.values.spin:Interpolate(ldt)
	local weight = p.weight * p.values.weight:Interpolate(ldt)
	local vscale = p.values.velocity:Interpolate(ldt)

	p.x = p.x + p.cos * p.vel * vscale * dt
	p.y = p.y + ((p.sin * p.vel) + p.grav) * vscale * dt
	p.r = p.r + spin * dt

	p.grav = p.grav + 200 * dt * weight
end

function meta:Draw()
	for k,v in pairs(self.particles) do
		drawParticle(v, dt)
	end

	surface.SetDrawColor(0,0,0,0)
end

local rmids = {}
function meta:Update(dt)
	for k,v in pairs(self.particles) do
		if v.die then
			table.insert(rmids, k)
		end

		updateParticle(v, dt)
	end

	local rmo = 0
	while #rmids > 0 do
		local rm = rmids[1]
		--self.particles[rm] = nil
		self:Remove( rm - rmo )
		table.remove(rmids, 1)
		rmo = rmo + 1
	end
end

local function calcWithVariance(param, t)
	local var = math.abs(param.values[2]:Interpolate(t))
	return param.values[1]:Interpolate(t) + math.random(-var*100,var*100)/100
end

local def_overrides = {}
function meta:SpawnFromParams(x, y, params, t, last_emit_time, overrides)
	if !params then return end
	local rt = RealTime()
	local ldt = rt - last_emit_time
	local number = calcWithVariance(params.number, t) * self.num_scale * (overrides.number or 1)

	overrides = overrides or def_overrides

	--Cache these in the parameters table
	params.values_tab = params.values_tab or {
		color_red = params.color.values[1],
		color_green = params.color.values[2],
		color_blue = params.color.values[3],
		color_alpha = params.color.values[4],
		size = params.size.values[3],
		spin = params.spin.values[3],
		weight = params.weight.values[3],
		velocity = params.velocity.values[3],
	}

	local amount = math.floor(ldt * number)
	if amount == 0 then return last_emit_time end
	last_emit_time = rt

	for i=1, amount do
		local p = self:Spawn()
		if not p then continue end

		local range = overrides.range or params.range.values[1]:Interpolate(t)
		local angle = math.rad(math.random(-range, range) + params.angle.values[1]:Interpolate(t))
		local rand_rot = overrides.rand_rot or 0

		angle = angle + math.rad(overrides.angle or 0)

		p.die = false
		p.time = rt
		p.x = x
		p.y = y
		p.r = calcWithVariance(params.rotation, t) + math.random(-rand_rot,rand_rot)
		p.cos = math.cos(angle)
		p.sin = math.sin(angle)
		p.grav = 0
		p.vel = calcWithVariance(params.velocity, t) * (overrides.vel or 1)
		p.spin = calcWithVariance(params.spin, t) * (overrides.spin or 1)
		p.size = calcWithVariance(params.size, t) * (overrides.size or 1)
		p.weight = calcWithVariance(params.weight, t) * (overrides.weight or 1)
		p.life = calcWithVariance(params.life, t) * (overrides.life or 1)
		p.image = params.image
		p.values = params.values_tab

	end

	return last_emit_time
end

new = function( limit, num_scale )

	local tab = setmetatable({}, meta):Init( limit, num_scale )
	return tab

end