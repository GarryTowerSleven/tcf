
ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Club Light"
ENT.Author			= "PixelTail Games & Foohy"
ENT.Information		= "It spins around"
ENT.Category		= "GMod Tower"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.Model			= Model("models/map_detail/nightclub_light.mdl")
ENT.SupportPath		= Model("models/map_detail/nightclub_light_support.mdl")
ENT.IsVisualizer 	= true

ENT.LightModes = {}

-- How sensitive the beat detection lights are to beats
local BeatSensitivity = 0.023


local BeatSnapSpeed = 10 -- How fast the lights snap to the new angle
local BeatFadeTime = 4 -- How long to wait before moving the beat lights back 
local BeatReturnSpeed = 0.35 -- How fast to move them back

-- Clamp values for the tracking mode
local MinPitch = 22
local MaxPitch = 60
local MinYaw = 110
local MaxYaw = 240

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "TrackedEntity")
	--self:NetworkVar("Int", 0, "LightMode")
end


local function AddLightMode(name, csfunction, svfunction)
	local mode =
	{
		Name = name,
		Function = SERVER and svfunction or csfunction,
	}
	table.insert(ENT.LightModes, mode)
end


---
-- Define the lightmodes here 
---

-- Some util functions

local function FindDancefloor(self)
	if not IsValid(self) then return end
	local Controller = self:GetOwner()
	if not IsValidController(Controller) then return end 

	for _, v in pairs( ents.FindByClass("gmt_club_dancefloor")) do
		if v and v:GetOwner() == Controller then
			return v 
		end
	end
end

local function FindDanceBounds(self)
	-- First, set some defaults in case we can't find a dancefloor
	local Pos = self:GetPos()
	local Width, Height = 512, 512 

	-- Try to find a dancefloor if we don't have one
	self.Dancefloor = IsValid(self.Dancefloor) and self.Dancefloor or FindDancefloor(self)

	if IsValid(self.Dancefloor) then
		Pos = self.Dancefloor:GetPos()
		Width = self.Dancefloor.Width
		Height = self.Dancefloor.Height 
	end

	return Pos, Width, Height
end


-- Light moves to the beat, using really REALLY basic beat detection
AddLightMode("beat",
	-- Clientside
	function(self)

		if self:GetOwner():GetAverage("bass", true) > BeatSensitivity then

			if not self.LastSet or CurTime() > self.LastSet + 0.25 then
				self.LastSet = CurTime()

				self.BeatAngle = Angle( math.Rand(0, 80), math.Rand(270, 90), 0)
			end
		-- If it's been a sufficient amount of time, start moving back toward home
		elseif self.LastSet and CurTime() - self.LastSet > BeatFadeTime then
			self.BeatAngle = LerpAngle(math.min(FrameTime()*BeatReturnSpeed,1), self.BeatAngle, self.DefaultAngle )
		end

		-- Do a bit more than snap
		if self.BeatAngle then
			self:SetAngles( LerpAngle(math.min(FrameTime()*BeatSnapSpeed, 1), self:GetAngles(), self.BeatAngle ) )
		end

	end,
	
	-- Serverside
	function(self)

	end)

-- Tracking light mode. Tracks a random player on the dance floor
AddLightMode("track",
	-- Clientside
	function(self)

		--self.Color = Color(255,255,255)
		self.VisualizerGlowVector = self.Color:ToVector()
		self.ViewAngle = self.ViewAngle or self.DefaultAngle 

		local ply = self:GetTrackedEntity()
		local angle = self.DefaultAngle 

		local trackSpeed = 1.2
		if IsValid(ply) then 
			angle = (ply:GetPos() - self:GetPos()):Angle()

			angle.p = math.Clamp(angle.p, MinPitch, MaxPitch)
			angle.y = math.Clamp(angle.y, MinYaw, MaxYaw)
			trackSpeed = 10
		end

		self.ViewAngle = LerpAngle(math.min(FrameTime(), 1) * trackSpeed, self.ViewAngle, angle )
		self:SetAngles( self.ViewAngle  )

	end,
	
	-- Serverside
	function(self)

		-- Get the bounds of our little dance place we're gonna keep track of
		Pos, w, h = FindDanceBounds(self)
		
		local trackEnt = self:GetTrackedEntity()
		if IsValid(trackEnt) then
			local min, max = Pos - Vector(w/2, h/2, 500),
							 Pos + Vector(w/2, h/2, 500)

			-- If the player is no longer in the dance radius, immedietly find a new one
			if not trackEnt:GetPos():WithinAABox(min,max) then
				self.NextPlayerTrack = 0
			end
		end

		-- If it's time to track a new player
		if not self.NextPlayerTrack or CurTime() > self.NextPlayerTrack or not IsValid(trackEnt) then
			self.NextPlayerTrack = CurTime() + 15

			-- Find all the entities within the box above the dancefloor
			local entities = ents.FindInBox(Pos - Vector(w/2, h/2, 500),
											Pos + Vector(w/2, h/2, 500))

			-- Go through the entities and filter out all the players 
			local dancers = {}
			for _, v in pairs(entities) do
				if IsValid(v) and v:IsPlayer() then
					table.insert(dancers, v)
				end
			end

			-- Select a random dancer
			self:SetTrackedEntity( table.Random(dancers))
		end

	end)

-- Generic movement based on the song. iunno.
AddLightMode("movecircle",
	-- Clientside
	function(self)
		local beatOffset = self:GetOwner().TotalAverage * 30

		self.CirclePerc = self.CirclePerc or math.Rand(0, 360)
		self.CirclePerc = self.CirclePerc + FrameTime() * 0.001 + beatOffset
		local angle = Angle( math.sin(self.CirclePerc ) * 25 + 30, math.cos(self.CirclePerc ) * 25 + 180, 0 )
		self:SetAngles(angle)
	end,
	
	-- Serverside
	function(self)

	end)

-- Generic movement based on the song. iunno.
AddLightMode("movepitch",
	-- Clientside
	function(self)
		local beatOffset = self:GetOwner():GetAverage("bass", true) * 1500
		self.BeatHeight = self.BeatHeight or 0 
		self.BeatHeight = Lerp(FrameTime()*3, self.BeatHeight, beatOffset)
		local angle = Angle( -self.BeatHeight + 70, 180, 0 )
		self:SetAngles(angle)
	end,
	
	-- Serverside
	function(self)

	end)