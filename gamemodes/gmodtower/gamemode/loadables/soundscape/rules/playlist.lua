
-----------------------------------------------------
-- This rule is functionally similar to playlooping, except with the idea that you can play multiple sounds from it
-- This is different from playrandom as sounds are explicitly played one at a time and after eachother
-- Similar to a music playlist

RULE.Base = "base"
RULE.Name = "playlist"

RULE.Table = {}
RULE.CurrentVolume = 1

RULE.NextActivateTime = 0

-- Create a sound that we'll store so we can stop it/fade out later
-- Note this uses bass as we have much more control over its position/sound than the builtin functions
function RULE:GetSound(filename)
	filename = "sound/" .. filename

	if self.LoadingSound then return end

	-- If there's an existing sound, remove that one
	if IsValid(self.LoopingSound) then
		self.LoopingSound:Stop()
		self.LoopingSound = nil
	end


	-- Mark that we're gonna be loading the sound
	self.LoadingSound = true

	-- Get if we should set the position of the song
	local shouldPos = self.Table.position ~= nil

	-- if this is set, then set noblock on the song and its time syncd to the server
	local syncSong = self.Table.sync
	local args = "noplay " .. (syncSong and "noblock " or "") .. (shouldPos and "3d " or "")

	-- Go! Activate the rest of the sound settings within the callback
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

		stream:EnableLooping(false)
		stream:SetVolume(0) -- Default to zero volume, no weird pop-ins
		stream:Play()

		-- Set the time
		if syncSong then
			stream:SetTime(UnPredictedCurTime() % stream:GetLength())
		end

		-- We did it
		self.LoadingSound = false
		self.LoopingSound = stream

		-- Activate it manually
		self:ApplySettings(stream)
	end)


	return self.LoopingSound
end

function RULE:Think(volume, dsp)

	-- If it's time to replay the sound, go for it dude
	if self.NextActivateTime < RealTime() and not self.LoadingSound then
		self:Activate(volume, dsp )
	end

	-- Make sure the volume is in line with the owning soundscape
	if IsValid(self.LoopingSound) then
		-- Mute the stream if they aren't focused
		local isFocused = system.HasFocus() and 1 or 0
		local volume = math.sqrt(self.CurrentVolume * volume) * isFocused
		self.LoopingSound:SetVolume( math.Clamp(volume, 0, 1 ))
	end
end

function RULE:ApplySettings(snd)

	-- Retrieve this important info from the rule table
	local pitch = soundscape.GetValueFromVagueObject(self.Table.pitch) or 100
	local soundlevel = soundscape.GetValueFromVagueObject(self.Table.soundlevel) or 75
	local position = soundscape.GetVectorFromVagueObject(self.Table.position) or Vector(0,0,0)
	local time = soundscape.GetValueFromVagueObject(self.Table.time)

 	-- Time for this rule is an OFFSET relative to the length of the sound
	time = time * pitch / 100.0 + snd:GetLength()

	if snd:GetState() ~= GMOD_CHANNEL_PLAYING then
		snd:Play()
	end

	-- Set the pitch
	snd:SetPlaybackRate((pitch / 100))

	-- World position (if it wasn't started with the 3d flag, this won't matter)
	snd:SetPos(position)

	-- Falloff (TODO: Find out how to actually calculate realistic falloff?)
	local fade = soundlevel --math.pow(10, (soundlevel - 140)/20)

	snd:Set3DFadeDistance(fade, 1000000000)

	if DEBUG then
		--print("[SOUNDSCAPE] playlooping\r\n" .. soundFile, volume, pitch, soundlevel, position )
	end

	self.NextActivateTime = RealTime() + time
end

function RULE:Activate(volume, dsp)

	-- Store the full volume of the sound, multiply it later
	self.CurrentVolume = soundscape.GetValueFromVagueObject(self.Table.volume) or 1

	-- Retrieve a random sound from the list
	local soundFile, length = soundscape.GetSoundInfoFromVagueObject(self.Table.sounds)

	-- Retreive the sound we're looping, creating it if necessary
	local snd = self:GetSound(soundFile)

end

function RULE:Remove()
	if IsValid(self.LoopingSound) then
		self.LoopingSound:Stop()
	end

	self._Removing = true
end
