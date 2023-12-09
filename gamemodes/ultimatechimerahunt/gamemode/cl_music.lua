local function GetRandomSong( idx )

	local song = GAMEMODE.Music[idx][1] .. math.random( 1, GAMEMODE.Music[idx][2] ) .. ".mp3"
	//Msg( "Random Song: " .. song, "\n" )
	return song

end

local function LoopMusic( round, duration )
	local ply = LocalPlayer()
	timer.Create( "MusicLoop", duration, 0, function()
		if !ply.Looped then return end
		
		if round then
			PlayMusic(MUSIC_ROUND)
		else
			PlayMusic(MUSIC_GHOST)
		end
	end )
end

function PlayMusic( idx, teamid )

	idx = idx or MUSIC_WAITING

	local ply = LocalPlayer()
	if !IsValid( ply ) then  //well this is awkward, lets try again

		timer.Simple( 1, function()

			Msg( "Failed to play song, attempting again." )
			PlayMusic( idx, teamid )

		end )

		return

	end

	if idx == MUSIC_WAITING then

		if ply.WaitingMusic && ply.WaitingMusic:IsPlaying() then
			ply.WaitingMusic:FadeOut( 1 )
		end

		ply.WaitingMusic = CreateSound( ply, GetRandomSong( MUSIC_WAITING ) )
		ply.WaitingMusic:PlayEx( music.GetClientVolume(), 100 )

	end

	if idx == MUSIC_ROUND then

		local add = teamid == TEAM_CHIMERA && 3 || 3.75

		ply.Ignore = ply.Looped and add - 1 or 0
		ply.Looped = true
		
		if ply.WaitingMusic && ply.WaitingMusic:IsPlaying() then
			ply.WaitingMusic:FadeOut( 1 )
		end

		if ply.EndRoundMusic then
			ply.EndRoundMusic:Stop()
		end
		timer.Simple( add - ply.Ignore, function()
			local song = GetRandomSong( MUSIC_ROUND )
			ply.Music = CreateSound( ply, song )
			ply.Music:PlayEx( music.GetClientVolume(), 100 )
			
			LoopMusic(true, SoundDuration(song))
		end )

	end

	if idx == MUSIC_ENDROUND then

		ply.Looped = false
		
		if ply.SpawnMusic && ply.SpawnMusic:IsPlaying() then
			ply.SpawnMusic:Stop()
			ply.SpawnMusic = nil
		end

		if ply.Music && ply.Music:IsPlaying() then
			ply.Music:FadeOut( 0.5 )
		end
		
		if ply.GhostMusic && ply.GhostMusic:IsPlaying() then
			ply.GhostMusic:FadeOut( 0.5 )
		end

		local song = GAMEMODE.Music[ MUSIC_ENDROUND ].Tie

		if teamid then

			if teamid == TEAM_PIGS then

				if ply:Team() == TEAM_PIGS || ply:IsGhost() then

					song = GAMEMODE.Music[ MUSIC_ENDROUND ].Pigmask.win

				else

					song = GAMEMODE.Music[ MUSIC_ENDROUND ].Chimera.lose

				end

			elseif teamid == TEAM_CHIMERA then

				if ply:GetNet("IsChimera") then

					song = GAMEMODE.Music[ MUSIC_ENDROUND ].Chimera.win

				else

					song = GAMEMODE.Music[ MUSIC_ENDROUND ].Pigmask.lose

				end

			elseif teamid == TEAM_SALSA then

				song = GAMEMODE.Music[ MUSIC_ENDROUND ].Salsa

			end

		end

		ply.EndRoundMusic = CreateSound( ply, song )
		ply.EndRoundMusic:PlayEx( music.GetClientVolume(), 100 )

	end

	if idx == MUSIC_SPAWN then

		local song = nil

		if ply.SpawnMusic && ply.SpawnMusic:IsPlaying() then
			ply.SpawnMusic:Stop()
			ply.SpawnMusic = nil
		end

		if ply:GetNet("IsChimera") then

			song = GAMEMODE.Music[ MUSIC_SPAWN ].Chimera

		elseif !ply:IsGhost() then

			local rank = ply:GetNet("Rank")

			if rank == RANK_ENSIGN then

				song = GAMEMODE.Music[ MUSIC_SPAWN ].Pigmask.ensign

			elseif rank == RANK_CAPTAIN then

				song = GAMEMODE.Music[ MUSIC_SPAWN ].Pigmask.captain

			elseif rank == RANK_MAJOR then

				song = GAMEMODE.Music[ MUSIC_SPAWN ].Pigmask.major

			elseif rank == RANK_COLONEL then

				song = GAMEMODE.Music[ MUSIC_SPAWN ].Pigmask.colonel

			end

		end

		if song then
			ply.SpawnMusic = CreateSound( ply, song )
			ply.SpawnMusic:PlayEx( music.GetClientVolume(), 100 )
		end

	end

	if idx == MUSIC_GHOST then

		ply.Looped = true
		
		if ply.Music then
			ply.Music:FadeOut( 1 )
		end

		timer.Simple( 1, function()

			local song = GetRandomSong( MUSIC_GHOST )
			if ply:GetNet("IsFancy") then
				song = GetRandomSong( MUSIC_FGHOST )
			end

			ply.GhostMusic = CreateSound( ply, song )
			ply.GhostMusic:PlayEx( music.GetClientVolume(), 100 )
			LoopMusic(false, SoundDuration(song))
		end )

	end

	if idx == MUSIC_30SEC then

		if ply:IsGhost() then return end

		ply.Looped = false
		
		if ply.Music then
			ply.Music:Stop()
		end

		ply.Music = CreateSound( ply, GAMEMODE.Music[ MUSIC_30SEC ] )
		ply.Music:PlayEx( music.GetClientVolume(), 100 )

	end

	if idx == MUSIC_MRSATURN then

		if ply.SpawnMusic && ply.SpawnMusic:IsPlaying() then
			ply.SpawnMusic:Stop()
			ply.SpawnMusic = nil
		end

		ply.SpawnMusic = CreateSound( ply, GAMEMODE.Music[ MUSIC_MRSATURN ] )
		ply.SpawnMusic:PlayEx( music.GetClientVolume(), 100 )

	end

end

usermessage.Hook( "UC_PlayMusic", function( um )

	local idx 		= um:ReadChar() //Music index
	local teamid	= um:ReadChar() //Team that won

	PlayMusic( idx, teamid )

end )