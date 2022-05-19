function GM:StartRound()

	GetWorldEntity():SetNet( "Round", GetWorldEntity():GetNet( "Round" ) + 1 )

	self:SetState( STATE_PLAYING )
	self:SetTime( self.RoundTime )
	self:RandomInfect()

end

function GM:EndRound( virusWins )

	self:CleanUpMap()

	self:SetState( STATE_INTERMISSION )
	self:SetTime( self.IntermissionTime )

	self:GiveMoney()

	self:PlayerFreeze( true )

	local plys = player.GetAll()
	
	for _, v in ipairs( plys ) do

		if !v:GetNet( "IsVirus" ) then
			v:AddAchievement( ACHIEVEMENTS.VIRUSSTRONG, 1 )
		end

		if v:GetNet("Rank") == 1 then
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

	net.Start( "EndRound" )
		net.WriteBool( virusWins )
	net.Broadcast()

end

function GM:RoundReset()

	for k,v in pairs( player.GetAll() ) do
		v:SetTeam( TEAM_PLAYERS )
		v:SetNet( "IsVirus", false )
		self:GiveLoadout( v )
	end

	self:RoundRespawn()

	self:SetState( STATE_INFECTING )
	self:SetTime( math.random( self.InfectingTime[1], self.InfectingTime[2] ) )

	local randSong = math.random( 1, self.NumWaitingForInfection )

	net.Start( "StartRound" )
		net.WriteInt( 1, 8 )
	net.Broadcast()

	self:PlayerFreeze( false )

end