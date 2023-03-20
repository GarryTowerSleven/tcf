RULE.Base = "base"
RULE.Name = "playrandom"

RULE.Table = {}
RULE.CurrentVolume = 1

RULE.NextActivateTime = 0

function RULE:Think( volume, dsp)

	-- If it's time to replay the sound, go for it dude
	if self.NextActivateTime < RealTime() then
		local snd, len = self:Activate(volume, dsp )

		self.NextActivateTime = RealTime() + len 
	end
end

function RULE:Activate(volume, dsp)

	-- Store the full volume of the sound, multiply it later
	self.CurrentVolume = soundscape.GetValueFromVagueObject(self.Table.volume) or 1

	-- Retrieve this important info from the rule table
	local pitch = soundscape.GetValueFromVagueObject(self.Table.pitch) or 100
	local soundlevel = soundscape.GetValueFromVagueObject(self.Table.soundlevel) or 75
	local position = soundscape.GetVectorFromVagueObject(self.Table.position)

	-- Retrieve a random sound from the list
	local soundFile, length = soundscape.GetSoundInfoFromVagueObject(self.Table.sounds)

	local isFocused = system.HasFocus() and 1 or 0

	-- Play the sound itself
	-- TODO: Use CSoundPatch when you can set its position
	sound.Play(soundFile, position, soundlevel, pitch, (self.CurrentVolume * volume) * isFocused )

	if false then
		print("[SOUNDSCAPE] playrandom\r\n" .. soundFile, volume, pitch, soundlevel, position )
	end

	local time = soundscape.GetValueFromVagueObject(self.Table.time)

	-- Return with what we ended up playing
	return soundFile, time
end

function RULE:IsValid()
	return true
end
