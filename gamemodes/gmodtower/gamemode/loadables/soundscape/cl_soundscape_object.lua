local SOUNDSCAPE = {}
SOUNDSCAPE.__index = SOUNDSCAPE 

-- Instead of being removed when faded out, keep it in the background so it fades back into the middle of the audio clip/effects
SOUNDSCAPE.ShouldKeepIdle = false 

-- Volume of the entire soundscape
SOUNDSCAPE.Volume = 0 

-- DSP number to invoke on the local player
SOUNDSCAPE.DSP = nil 

-- Noncustomizable variables
SOUNDSCAPE.EndFadeTime = 0 
SOUNDSCAPE.StartFadeTime = 0
SOUNDSCAPE.FadeTime = 0

---
-- Called when the soundscape loads a definition table
---
function SOUNDSCAPE:Load(definition)

	-- First, extract the global settings
	self.DSP = definition.dsp
	self.ShouldKeepIdle = definition.idle or false 
	
	self.Loaded = true 

	-- Now, peruse through for valid rules
	for k, v in pairs(definition) do
		self:LoadRule(v, k)
	end
end


---
-- Load in a specific rule via its definition
---
function SOUNDSCAPE:LoadRule( ruleDef, name )
	if type(ruleDef) ~= "table" or not ruleDef.type then return false end

		-- If it exists within the soundscape's rule system, add it here
	if soundscape.Rules[ruleDef.type] then 
		local rule = soundscape.Rules[ruleDef.type]:Create(ruleDef)
		rule.Name = name

		table.insert(self.Rules, rule)
		return rule -- I dunno, someone might want it
	end

	return false 
end

---
-- Fades out the soundscape, marking it for deletion when volume reaches 0
---
function SOUNDSCAPE:FadeOut( fadeTime )
	self._IsStopping = true 

	self:SetVolume(0, fadeTime)
end

---
-- Fade in the soundscape, even if we're in the process of fading out
---
function SOUNDSCAPE:FadeIn(volume, fadeTime)
	self._IsStopping = false 
	
	self:SetVolume(volume or 1, fadeTime)
end

---
-- Returns whether the soundscape is currently fading out to deletion
---
function SOUNDSCAPE:IsFadingOut()
	return self._IsStopping
end

---
-- Set the soundscape's volume, optionally over a certain number of seconds
---
function SOUNDSCAPE:SetVolume(volume, time)

	-- If there's no fade time set, boop it megasmall
	if not time then
		self.Volume, self.GoalVolume = volume, volume
		self.EndFadeTime = 0 
		return
	end

	self.StartVolume = self.Volume * 1.0 
	self.GoalVolume = volume 

	self.EndFadeTime = RealTime() + time
	self.FadeTime = time 
end

---
-- Return the current overall volume of the soundscape
---
function SOUNDSCAPE:GetVolume()
	return self.Volume 
end

---
-- Called when the soundscape is being deleted and it's time to remove any active sound objects
---
function SOUNDSCAPE:Remove()
	-- Go through each rule and tell it to stop
	for _, v in pairs( self.Rules ) do
		v:Remove()
	end
end


---
-- Think about the soundscape state and all of its rules 
---
function SOUNDSCAPE:Think()

	-- Set the DSP of the localplayer
	if self.DSP and self.DSP >= 0 and not self._IsStopping then
		LocalPlayer():SetDSP(self.DSP)
	end

	-- Handle the volume changing over time
	local timeLeft = self.EndFadeTime - RealTime()

	if timeLeft > 0 then
		local perc = math.Clamp(1-(timeLeft / self.FadeTime), 0, 1)

		-- Set the faded volume
		self.Volume = math.Clamp(Lerp(perc, self.StartVolume, self.GoalVolume), 0, 1)
	else 
		self.Volume = self.GoalVolume 
	end

	-- Go through each of our rules and see if they need anything to do 
	for _, rule in pairs(self.Rules) do
		rule:Think(self.Volume, self.DSP)
	end
end

function SOUNDSCAPE:__tostring()
	return "SOUNDSCAPE: " .. self.Name 
end

function SOUNDSCAPE:IsValid()
	return self.Loaded == true
end

----
-- Create a new instance of our bezier curve object
----
module( "soundscape", package.seeall )
function Create( definition, name )
	if not definition then return end 
	if not name then error("Soundscape requires a name!") end

	local tbl = {}
	tbl = setmetatable(tbl, SOUNDSCAPE)

	tbl.Name = name 
	tbl.Rules = {}
	tbl.Settings = {}

	-- Extract the rules and settings from this table
	tbl:Load(definition)
	
	return tbl
end