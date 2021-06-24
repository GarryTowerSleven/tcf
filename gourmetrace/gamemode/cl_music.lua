local function GetRandomSong( idx )

	local song = GAMEMODE.Music[idx][1] .. math.random( 1, GAMEMODE.Music[idx][2] ) .. ".mp3"
	//Msg( "Random Song: " .. song, "\n" )
	return song

end

function PlayMusic( idx, win )

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

		if ply.FinishMusic && ply.FinishMusic:IsPlaying() then
			ply.FinishMusic:FadeOut( 1 )
		end

		if ply.WaitingMusic && ply.WaitingMusic:IsPlaying() then
			ply.WaitingMusic:FadeOut( 1 )
		end

		if ply.WaitingMusic && ply.WaitingMusic:IsPlaying() then
			ply.WaitingMusic:FadeOut( 1 )
		end

		ply.WaitingMusic = CreateSound( ply, GetRandomSong( MUSIC_WAITING ) )
		ply.WaitingMusic:PlayEx( 80, 100 )

	end

	if idx == MUSIC_ROUND then

		if ply.Music && ply.Music:IsPlaying() then
			ply.Music:FadeOut( 1 )
		end

		if ply.EndRoundMusic then
			ply.EndRoundMusic:Stop()
		end

		ply.Music = CreateSound( ply, GetRandomSong( MUSIC_ROUND ) )
		ply.Music:PlayEx( 25, 100 )

	end

	if idx == MUSIC_30SEC then

		if ply:Team() != TEAM_RACING then return end

		if ply.Music then
			ply.Music:Stop()
		end

		if ply.FinishMusic && ply.FinishMusic:IsPlaying() then
			return
		end

		ply.Music = CreateSound( ply, GetRandomSong( MUSIC_30SEC ) )
		ply.Music:PlayEx( 100, 100 )

		if ply.InvincibleMusic && ply.InvincibleMusic:IsPlaying() then
			ply.Music:ChangeVolume( .1 )
		end

	end
	
	if idx == MUSIC_WINLOSE then

		if ply.Music && ply.Music:IsPlaying() then
			ply.Music:FadeOut( 0.5 )
		end

		if ply.InvincibleMusic then
			ply.InvincibleMusic:Stop()
		end

		local song = GAMEMODE.Music[ MUSIC_WINLOSE ].Lose

		if win then

			song = GAMEMODE.Music[ MUSIC_WINLOSE ].Win

		end

		if ply:Team() != TEAM_FINISHED then

			song = GAMEMODE.Music[ MUSIC_WINLOSE ].Timeup

		end

		ply.WinLoseMusic = CreateSound( ply, song )
		ply.WinLoseMusic:PlayEx( 100, 100 )

	end

	if idx == MUSIC_ENDROUND then

		if ply.Music then
			ply.Music:Stop()
		end

		if ply.FinishMusic && ply.FinishMusic:IsPlaying() then
			ply.FinishMusic:FadeOut( 1 )
		end

		if ply.InvincibleMusic then
			ply.InvincibleMusic:Stop()
		end

		if ply.WinLoseMusic then
			ply.WinLoseMusic:Stop()
		end

		ply.EndRoundMusic = CreateSound( ply, GetRandomSong( MUSIC_ENDROUND ) )
		ply.EndRoundMusic:PlayEx( 100, 100 )

	end

	if idx == MUSIC_INVINCIBLE then

		if ply.Music then
			ply.Music:ChangeVolume( .1 )
		end

		ply.InvincibleMusic = CreateSound( ply, GAMEMODE.Music[ MUSIC_INVINCIBLE ] )
		ply.InvincibleMusic:PlayEx( 100, 100 )

	end

	if idx == MUSIC_WARMUP then

		if ply.WaitingMusic && ply.WaitingMusic:IsPlaying() then
			ply.WaitingMusic:Stop()
		end

		if ply.FinishMusic && ply.FinishMusic:IsPlaying() then
			ply.FinishMusic:FadeOut( 1 )
		end

		surface.PlaySound( GAMEMODE.Music[ MUSIC_WARMUP ] )

	end

	if idx == MUSIC_TAKEFIRST then

		surface.PlaySound( GAMEMODE.Music[ MUSIC_TAKEFIRST ] )

	end

	if idx == MUSIC_FINISH then

		if ply.Music && ply.Music:IsPlaying() then
			ply.Music:FadeOut( 1 )
		end

		ply.FinishMusic = CreateSound( ply, GAMEMODE.Music[ MUSIC_FINISH ] )
		ply.FinishMusic:PlayEx( 80, 100 )

	end

end

usermessage.Hook( "GR_PlayMusic", function( um )

	local idx 		= um:ReadChar() //Music index
	local win		= um:ReadBool() //Win or lose

	PlayMusic( idx, win )

end )
