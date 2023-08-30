RULE.Base = "base"
RULE.Name = "playlooping"

RULE.Table = {}
RULE.CurrentVolume = 1

RULE.NextActivateTime = 0

-- Create a sound that we'll store so we can stop it/fade out later
-- Note this uses bass as we have much more control over its position/sound than the builtin functions
function RULE:GetSound(filename)
	filename = "sound/" .. filename 

	if not IsValid(self.LoopingSound) and not self.LoadingSound then
		
		self.LoadingSound = true 

		-- Get if we should set the position of the song
		local shouldPos = self.Table.position ~= nil 

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

			stream:EnableLooping(true)
			stream:SetVolume(0) -- Default to zero volume, no weird pop-ins
			stream:Play()

			-- Set the time
			if syncSong then
				stream:SetTime(UnPredictedCurTime() % stream:GetLength())
			end

			-- We did it
			self.LoadingSound = false 
			self.LoopingSound = stream
		end)

	end

	return self.LoopingSound
end

function RULE:Think(volume, dsp)

	-- If it's time to replay the sound, go for it dude
	if self.NextActivateTime < RealTime() then
		local snd, len = self:Activate(volume, dsp )

		self.NextActivateTime = RealTime() + len 
	end

	-- Make sure the volume is in line with the owning soundscape
	if IsValid(self.LoopingSound) then
		-- Mute the stream if they aren't focused
		local isFocused = system.HasFocus() and 1 or 0
		local mp = Location.GetMediaPlayersInLocation(LocalPlayer():Location())
		mp = mp[1] and mp[1]._Media and 0 or 1
		local volume = math.sqrt(self.CurrentVolume * volume) * isFocused * mp
		self.LoopingSound:SetVolume( math.Clamp(volume, 0, 1 ))
	end
end

function RULE:Activate(volume, dsp)

	-- Store the full volume of the sound, multiply it later
	self.CurrentVolume = soundscape.GetValueFromVagueObject(self.Table.volume) or 1

	-- Retrieve this important info from the rule table
	local pitch = soundscape.GetValueFromVagueObject(self.Table.pitch) or 100
	local soundlevel = soundscape.GetValueFromVagueObject(self.Table.soundlevel) or 75
	local position = soundscape.GetVectorFromVagueObject(self.Table.position) or Vector(0,0,0)

	-- Retrieve a random sound from the list
	local soundFile = self.Table.sound[1]
	local length 	= soundscape.SoundLengths[ soundFile ] or self.Table.sound[2] or 5

	-- Retreive the sound we're looping, creating it if necessary
	local snd = self:GetSound(soundFile)

	-- If the sound wasn't valid, immedietly queue up for next time
	if not IsValid(snd) then return "", 0 end

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

	if false then
		print("[SOUNDSCAPE] playlooping\r\n" .. soundFile, volume, pitch, soundlevel, position )
	end

	-- Return with what we ended up playing
	return soundFile, length
end

function RULE:Remove()
	if IsValid(self.LoopingSound) then
		self.LoopingSound:Stop()
	end

	self._Removing = true 
end