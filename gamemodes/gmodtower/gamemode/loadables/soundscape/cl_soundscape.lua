
module( "soundscape", package.seeall )

-- Default Fade time out of the current soundscape, in seconds
-- Note, only works with looping sounds for now
FadeTime = FadeTime or 2

-- Show debug prints
DEBUG = false

-- Whether to actually spawn any sounds or do any thinking
Enabled = Enabled or false 

-- Misc. Variables
ChannelSettings = ChannelSettings or {}
Soundscapes = Soundscapes or {}
SoundscapeDefinitions = SoundscapeDefinitions or {}
Rules = Rules or {}

---
-- Check the stream to make sure it's valid and won't turbostatic everywhere. Check em'
---
function CheckStream(stream)
	
	local timeDif = 0
	if IsValid(stream) and SoundLengths then
		local streamLen = stream:GetLength()
		timeDif = streamLen - (SoundLengths and SoundLengths[string.lower(stream:GetFileName())] or streamLen)
		timeDif = math.abs(timeDif)
	end 

	-- KILL ME. Check if the sample rate is not 48000 and not far away from the calculated timedif
	return IsValid( stream ) and stream:GetSamplingRate() ~= 48000 and timeDif < 0.2
end

---
-- Get a value from either a static value, a range, or a function callback
---
function GetValueFromVagueObject(obj)
	local t = type(obj)

	if t == "number" then
		return obj 
	elseif t == "table" and #obj >= 2 then
		return math.Rand(obj[1], obj[2])
	elseif t == "function" then
		return obj() or nil
	end

	-- welp
	return nil
end 

---
-- Get a value from either a static vector, a ranged distance, or a function callback
---
function GetVectorFromVagueObject(obj)
	local t = type(obj)

	if t == "number" then
		return VectorRand() * obj + LocalPlayer():GetPos()
	elseif t == "Vector" then
		return obj
	elseif t == "Entity" or t == "Player" then
		return IsValid(obj) and obj:GetPos()
	elseif t == "function" then
		return obj() or Vector(0,0,0)
	end

	-- welp
	return nil
end 

---
-- Get sound info from either a string-number table or a function callback
---
function GetSoundInfoFromVagueObject(obj)
	local t = type(obj)

	-- If it's a table, assume it's a table of sound information
	if t == "table" and #obj >= 1 then
		local sndInfo = table.Random(obj)
		return sndInfo[1], sndInfo[2]
	-- If it's a function, they should return it
	elseif t == "function" then
		return obj()
	end

	-- TODO: Default sound to show they fucked up
	return "", 0
end

---
-- Register a soundscape definition table within the soundscape system
---
function Register( name, tbl )
	SoundscapeDefinitions[name] = tbl
end

---
-- Add additional rules/information to a specific soundscape
-- (1) Name of the soundscape to modify, (2) A defined rule table, (3 optional) the keyname of the rule. This lets you have access to overwriting it later 
---
function AppendRuleDefinition(name, tbl, rulename)
	if not SoundscapeDefinitions[name] then 
		ErrorNoHalt("Could not append soundscape " .. tostring(name) .. ", soundscape does not exist!\r\n")
		return
	end 

	-- Add the rule with a specified name, so they can modify it later
	if rulename then
		SoundscapeDefinitions[name][rulename] = tbl
		
	-- Else just add it anonymously
	else
		table.Add(SoundscapeDefinitions[name], {tbl})
	end

	-- Reload the current soundscape with the same settings if it was currently playing
	if IsPlaying(name) then
		for _, v in pairs( Soundscapes ) do
			if not v or v.Name ~= name or not v.Rules then continue end 

			-- Remove each rule individually and remove them if they match our own
			for i = table.Count(v.Rules), 1, -1 do
				local rule = v.Rules[i]
				if rule.Name == rulename then
					rule:Remove()
					table.remove(v.Rules, i )
				end
			end

			-- Load in JUST this rule
			v:LoadRule(tbl, rulename)
		end
	end

end

---
-- Get whether a specific named rule is defined within a soundscape
---
function HasRule(name, rulename)
	return SoundscapeDefinitions[name] and SoundscapeDefinitions[name][rulename] ~= nil 
end

---
-- Register a rule to be used within the soundscape sytem
-- Default rules include "playlooping" and "playrandom"
---
function RegisterRule( rule )
	local name = rule.Name 

	-- Construct a quick baseclass
	local base = {}
	base.__index = base 
	base.Think = function() end
	base.IsValid = function(self) return true end 
	base.Remove = function(self) end
	base.__tostring = function(self) return self.Name end

	-- Function to instantiate the rule
	rule.Create = function(self, tbl) 
		if not tbl then 
			ErrorNoHalt("[Soundscapes]: Rule must be created with a ruletable!")
			debug.Trace()
			return nil 
		end

		-- Create the rule instance
		local ruleObj = setmetatable({}, {__index = self, __tostring = self.__tostring })
		ruleObj.Table = tbl 

		return ruleObj
	end

	-- Add the base class to our rule 
	rule = setmetatable(rule, {__index = base, __tostring = base.__tostring })

	Rules[name] = rule 

	if DEBUG then 
		print("Registered soundscape rule \"" .. name .. "\"")
	end
end


---
-- Return whether a given name is defined in the soundscape system
---
function IsDefined( name )
	return SoundscapeDefinitions[name] ~= nil 
end

---
-- Return if the specified soundscape is currently playing
---
function IsPlaying(name)
	-- If they didn't specify, return if anything is playing
	if not name then
		return table.Count(Soundscapes) > 0
	end

	-- Find any active soundscapes that matches the name
	for _, v in pairs( Soundscapes ) do
		if v.Name == name and not v:IsFadingOut() then return true end
	end

	return false
end

---
-- Play the specified soundscape
---
function Play( name, channel, clearChannel )

	-- Assign a default channel 
	channel = channel or "default"

	-- Stop all other soundscapes on this channel if that's what they want
	if clearChannel then
		Stop(channel)
	end

	-- Attempt to find a matching soundscape that is currently fading out and reuse that
	local soundScape = nil
	for _, v in pairs( Soundscapes ) do
		if IsValid(v) and v.Name == name and v:IsFadingOut() then
			soundScape = v 
			break
		end
	end

	-- If there weren't any soundscapes we could use, create a new one
	if not IsValid(soundScape) then

		-- Get the soundscape definition table and create the soundscape object
		local tbl = SoundscapeDefinitions[name]
		soundScape = soundscape.Create(tbl, name)
	end

	if not IsValid(soundScape) then return end 

	if DEBUG then
		print("Adding new soundscape " .. name )
	end

	-- Fade them into life
	soundScape.Channel = channel 
	soundScape:FadeIn(GetSettings(channel).Volume, GetSettings(channel).FadeTime )

	-- Insert this soundscape onto the currently playing table
	table.insert(Soundscapes, soundScape)
end

---
-- Stops all active soundscapes
-- bFadeTime - The amount of time to fade out the soundscape
-- bIdleOveride - Remove soundscapes set to keep idle as well
---
function StopAll( bFadeTime, bIdleOverride )

	for _, v in pairs(Soundscapes) do
		if IsValid(v) then 
			if bIdleOverride then v.ShouldKeepIdle = false end 
			v:FadeOut(bFadeTime or GetSettings(v.Channel).FadeTime ) 
		end 
	end
end

---
-- Stops all soundscapes with the specified name
-- name - The name of the soundscape to stop
-- bFadeTime - The amount of time to fade out the soundscape
-- bIdleOveride - Remove soundscapes set to keep idle as well
---
function Stop( name, bFadeTime, bIdleOverride )

	for _, v in pairs(Soundscapes) do
		if IsValid(v) and v.Name == name then 
			if bIdleOverride then v.ShouldKeepIdle = false end 
			v:FadeOut(bFadeTime or GetSettings(v.Channel).FadeTime ) 
		end 
	end
end

---
-- Stops all soundscapes with a specific channel marker
-- channel - The channel that holds a group of soundscapes to stop
-- bFadeTime - The amount of time to fade out the soundscape
-- bIdleOveride - Remove soundscapes set to keep idle as well
---
function StopChannel( channel, bFadeTime, bIdleOverride )

	local fadeTime = bFadeTime or GetSettings(channel).FadeTime
	for _, v in pairs(Soundscapes) do
		if IsValid(v) and v.Channel == channel then 
			if bIdleOverride then v.ShouldKeepIdle = false end 
			v:FadeOut(fadeTime) 
		end 
	end
end


-----------------------
-- The following functions are for setting things specifically to each soundscape channel
-----------------------
local function CreateSettingsTable()
	return 
	{
		Volume = 1,
		FadeTime = 3,
		-- Uhh, is there anything else?
	}
end

---
-- Retrieve the raw settings table
-- You should use the provided getters/setters before using this unless you know what you're doing
---
function GetSettings(channel)
	ChannelSettings[channel] = ChannelSettings[channel] or CreateSettingsTable()

	return ChannelSettings[channel]
end

---
-- Set overall soundscape volume 
---
function SetVolume(channel, volume, bFade )
	local settings = GetSettings(channel)
	settings.Volume = volume 

	-- Loop through all soundscapes of this channel
	for _, v in pairs(Soundscapes) do

		if IsValid(v) and v.Channel == channel and not v:IsFadingOut() then 
			v:SetVolume(settings.Volume, bFade and settings.FadeTime or nil ) 
		end 
	end
end

---
-- Retrieve the overall soundscape volume
---
function GetVolume(channel)
	return GetSettings(channel).Volume 
end

---
-- Set the fade time of soundscape rules
---
function SetFadeTime(channel, time)
	local settings = GetSettings(channel)
	settings.FadeTime = time 
end

---
-- Retrieve the fade time of soundscape rules
---
function GetFadeTime(channel)
	return RetrieveSettingsTable(channel).FadeTime 
end



-- Call think on all the currently active soundscapes
hook.Add("Think", "GMTSoundscapeThink", function()
	if not Enabled then return end

	local mp = Location.GetMediaPlayersInLocation(LocalPlayer():Location())
	mp = mp[1] and mp[1]._Media

	-- Think on every active soundscape
	for k, v in pairs(Soundscapes) do

		v:Think()

		local vol = mp and 0 or nil

		if vol and v:GetVolume() ~= vol || !vol and v:GetVolume() == 0 then
			local channel = v.Channel
			v:SetVolume(mp and 0 or GetSettings(channel).Volume, mp and 0.1 or GetSettings(channel).FadeTime )
		end

		-- If they're stopped, remove them from the active soundscapes
		if v:IsFadingOut() and v.EndFadeTime < RealTime() and not v.ShouldKeepIdle then
			v:Remove()
			Soundscapes[k] = nil 
		end
	end
end )

-- Don't do ANY soundscape stuff until we know for sure the client is ready and initialized
hook.Add("PlayerSpawnClient", "GMTSoundscapeEnable", function(ply)
	timer.Simple(1, function() Enabled = true end )
end )


-- Hold a list of sound lengths to check against
-- Last minute panic mode for fixing the turbo sound error
local SoundLengths = {}
local function AddSoundLength( snd, len )
	snd = string.lower(snd)
	if SoundLengths[snd] and math.abs(SoundLengths[snd] - len) > 0.1 then
		print("DIFFERENCE: \n\r", snd:sub((#"sound/") + 1), "\r\n", SoundLengths[snd], len)
	elseif SoundLengths[snd] == nil then
		print("Adding... ", len, snd)
	end
	SoundLengths[snd] = len
end

local function CheckEm( snd )

	-- Test creating the stream, and get the length
	local args = "noplay "

	sound.PlayFile( "sound/" .. snd, args, function(stream, errcode, err)

		if not IsValid(stream) or stream:GetSamplingRate() == 48000 then
			print("Failed to play " .. snd, err, errcode, errcode == nil and " PREVENTED MALFORMED AUDIO" or "")
			return 
		end 

		-- Store that shit
		AddSoundLength(stream:GetFileName(), stream:GetLength())
	end )
end

local function PrintSoundLengths()
	print "\r\n\r\n\r\n"
	print "local soundLengths = {}"

	for k, v in pairs(SoundLengths) do
		print( string.format("soundLengths[%q] = %f", k, v ) ) 
	end 

end

-- Fuck
concommand.Add("gmt_soundscape_generate", function(ply, cmd, args)

	if args[1] == "done" then
		PrintSoundLengths()
		return
	end

	-- Go through each soundscape, looking for sounds to grab the audio length of
	for k, v in pairs(SoundscapeDefinitions) do

		-- Loop through every rule in the soundscape definition
		for __, rule in pairs(v) do
			if not rule or type(rule) ~= "table" then continue end

			-- Save rule sound info
			if type(rule.sound) == "table" then
				CheckEm(rule.sound[1])
			elseif type(rule.sounds) == "table" then
				for _, snd in pairs( rule.sounds) do
					CheckEm(snd[1])
				end
			end
		end
	end

end )

concommand.Add("gmt_soundscape_debug", function(ply, cmd, args)

	local v, k = table.Random(SoundscapeDefinitions)
	StopChannel("background")
	print(k)
	Play(k, "background", true )
end )

concommand.Add("gmt_soundscape_addgen", function(ply, cmd, args)
	if #args == 0 then print("Gimme a soundfile to test you punk") return end

	CheckEm(args[1])

end )
