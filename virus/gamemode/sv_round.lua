


function GM:StartRound()

	GAMEMODE:CleanUpMap()
	
	SetGlobalInt("State",STATE_INFECTING)
	
	SetGlobalInt("NumVirus",0)
	
	GAMEMODE.CurrentRound = GAMEMODE.CurrentRound  + 1
	
	SetGlobalInt("Round",GAMEMODE.CurrentRound)
	SetGlobalInt("MaxRounds",GAMEMODE.NumRounds)
	
	GAMEMODE.HasLastSurvivor = false
	
	local plys = player.GetAll()
	
	for _, v in ipairs( plys ) do
	
		v:SetNWBool("IsVirus",false)
		
		v:SetTeam( TEAM_PLAYERS )
		
		v:Freeze( false )
		
		v:SetFrags( 0 )
		v:SetDeaths( 0 )
		
		v:StripWeapons()
		v:RemoveAllAmmo()
		
		v:SetCanZoom( false )

		v:Spawn()
		
	end
	
	local randSong = math.random( 1, GAMEMODE.NumWaitingForInfection )
	GAMEMODE.WaitingSong = randSong
	
	umsg.Start( "StartRound" )
		umsg.Char( randSong )
	umsg.End()
	
	if ( GetGlobalInt("MaxRounds") == GetGlobalInt("Round") ) then
		GAMEMODE:HudMessage( nil, 4 /* This is the last round! */, 10 )
	end
	
	local time = GAMEMODE.InfectingTime
	local infectRand = math.random( time[ 1 ], time[ 2 ] )
	
	timer.Destroy( "Infect" )
	if !GAMEMODE.VirusDebug then timer.Create( "Infect", infectRand, 1, GAMEMODE.RandomInfect, GAMEMODE ) end

end



function GM:EndRound( virusWins )
	
	SetGlobalInt("State",STATE_INTERMISSION)
	GAMEMODE.EndRoundMusic = virusWins
	
	local time = GAMEMODE.IntermissionTime

	SetGlobalFloat("Time",CurTime() + time)

	local plys = player.GetAll()
	
	for _, v in ipairs( plys ) do
		
		v:Freeze( true )
		
		v:StripWeapons()
		v:RemoveAllAmmo()
		
		if !v:GetNWBool("IsVirus") then
			v:AddAchievement( ACHIEVEMENTS.VIRUSSTRONG, 1 )
		end
		
		if v:GetNWInt("Rank") == 1 then
			v:AddAchievement( ACHIEVEMENTS.VIRUSBRAGGING, 1 )
		end
		
		v:AddAchievement( ACHIEVEMENTS.VIRUSTIMESPLIT, 1 )
		v:AddAchievement( ACHIEVEMENTS.VIRUSMILESTONE1, 1 )

	end
	
	local lastSurvivor = team.GetPlayers( TEAM_PLAYERS )[ 1 ]
	
	if IsValid( lastSurvivor ) then
		lastSurvivor:AddAchievement( ACHIEVEMENTS.VIRUSLASTALIVE, 1 )
	end
	
	if #team.GetPlayers( TEAM_PLAYERS ) >=4 then
		
		for _, v in ipairs( team.GetPlayers( TEAM_PLAYERS ) ) do

			v:SetAchievement( ACHIEVEMENTS.VIRUSTEAMPLAYER, 1 )

		end

	end
	
	if virusWins then
		GAMEMODE:HudMessage( nil, 11 /* infected have prevailed */, 5 )
	else
		GAMEMODE:HudMessage( nil, 12 /* survivors have won */, 5 )
	end
	
	umsg.Start( "EndRound" )
		umsg.Bool( virusWins )
	umsg.End()
	
	GAMEMODE:GiveMoney()
	
	if GetGlobalInt("Round") >= GetGlobalInt("MaxRounds") then
	
		timer.Destroy( "EndMap" )
		timer.Create( "EndMap", time+3, 1, GAMEMODE.EndServer, GAMEMODE )
	
		return
		
	end
		
	timer.Destroy( "RoundStart" )
	timer.Create( "RoundStart", time, 1, GAMEMODE.StartRound, GAMEMODE )
	
	GAMEMODE.HasLastSurvivor = false // JUST IN CASE LOL
	
end