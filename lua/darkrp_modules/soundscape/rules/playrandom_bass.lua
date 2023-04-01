
-----------------------------------------------------
-- This rule is an exact duplicate of playrandom, however, this uses bass internally
-- I keep the option to use the other playrandom as those sounds are affected by dsp, 'soundlevel' is sanely applied, and certain file formats (some .wav files) not working
-- I hope to fix these issues eventually and move it completely over to this one

RULE.Base = "base"
RULE.Name = "playrandom_bass"

RULE.Table = {}
RULE.CurrentVolume = 1

RULE.NextActivateTime = 0

local function ValidSound( sndData )

	return sndData ~= nil and 
		IsValid(sndData.Sound) and
		sndData.Sound:GetState() == GMOD_CHANNEL_PLAYING
end

function RULE:Think( volume, dsp)

	-- If it's time to replay the sound, go for it dude
	if self.NextActivateTime < RealTime() and not self.LoadingSound then
		local snd, len = self:Activate(volume, dsp )

		self.NextActivateTime = RealTime() + len 
	end

	if not self.ActiveSounds then return end 

	-- Loop through each sound to set its volume according to current settings
	for i=#self.ActiveSounds, 1, -1 do
		if ValidSound(self.ActiveSounds[i]) then

			-- Mute the stream if they aren't focused
			local isFocused = system.HasFocus() and 1 or 0
			local vol = math.pow(self.ActiveSounds[i].Volume * volume, 2) * isFocused
			self.ActiveSounds[i].Sound:SetVolume(math.Clamp(vol, 0, 1 ))

		else -- Remove inactive sounds
			table.remove(self.ActiveSounds, i )
		end
	end
end

-- Create a new one-time sound with bass
function RULE:AddSound(filename, position, soundlevel, pitch, volume  )
	self.ActiveSounds = self.ActiveSounds or {}
	filename = "sound/" .. filename -- Bass doesn't automatically look in the sounds directory

	self.LoadingSound = true 

	-- Get if we should set the position of the song
	local shouldPos = position ~= nil 

	-- if this is set, then set noblock on the song and its time syncd to the server
	local syncSong = self.Table.sync
	local args = "noplay " .. (syncSong and "noblock " or "") .. (shouldPos and "3d " or "")

	sound.PlayFile( filename, args, function(stream, errcode, err)

		if not soundscape.CheckStream(stream) then
			print("Failed to play " .. filename, err, errcode, errcode == nil and " PREVENTED MALFORMED AUDIO" or "")
			return 
		end 

		-- If we were marked for removal while loading, stop now
		if not self or self._Removing then
			stream:Stop()
			return
		end

		self.LoadingSound = false

		-- Configure the sound with its settings
		stream:SetVolume(volume)
		stream:SetPlaybackRate((pitch / 100))
		if position then
			stream:SetPos(position)
		end

		-- Falloff (TODO: Find out how to actually calculate realistic falloff?)
		local fade = soundlevel --math.pow(10, (soundlevel - 140)/20) 
		stream:Set3DFadeDistance(fade, 1000000000)

		-- Set the time
		if syncSong then
			stream:SetTime(UnPredictedCurTime() % stream:GetLength())
		end

		stream:Play()

		-- If there's no time variable, we have to manually set the next active time here
		-- A bit icky but eh, it works and this is the only case
		if not self.Table.time then 
			self.NextActivateTime = RealTime() + stream:GetLength()
		end

		if DEBUG then
			--print("[SOUNDSCAPE] playlooping_bass\r\n" .. filename, self.CurrentVolume, pitch, soundlevel, position )
		end

		-- We did it
		local SoundData = 
		{
			Volume = volume,
			Pitch = pitch,
			Soundlevel = soundlevel,
			Position = position,
			Sound = stream,
		}
		table.insert(self.ActiveSounds,SoundData)
	end)
end

function RULE:Activate(volume, dsp)

	-- Store the full volume of the sound, multiply it later
	local vol = soundscape.GetValueFromVagueObject(self.Table.volume) or 1

	-- Retrieve this important info from the rule table
	local pitch = soundscape.GetValueFromVagueObject(self.Table.pitch) or 100
	local soundlevel = soundscape.GetValueFromVagueObject(self.Table.soundlevel) or 75
	local position = soundscape.GetVectorFromVagueObject(self.Table.position)
	local time = soundscape.GetValueFromVagueObject(self.Table.time) 

	-- Retrieve a random sound from the list
	local soundFile, length = soundscape.GetSoundInfoFromVagueObject(self.Table.sounds)

	-- Play the sound itself
	-- TODO: Use CSoundPatch when you can set its position
	self:AddSound(soundFile, position, soundlevel, pitch, vol )

	-- Return with what we ended up playing
	return soundFile, time or 0
end

function RULE:Remove()
	self._Removing = true 

	if not self.ActiveSounds then return end

	-- Stop any currently active sounds
	for _, v in pairs(self.ActiveSounds) do
		if v.Sound then
			v.Sound:Stop()
		end
	end
end

function RULE:IsValid()
	return true
end
