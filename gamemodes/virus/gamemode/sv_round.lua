function GM:StartRound()
	virusDeath = 0
	music.Play( EVENT_PLAY, MUSIC_ROUNDPLAY )
	music.Play( EVENT_PLAY, MUSIC_STINGER )

	self:SetState( STATE_PLAYING )
	self:SetTime( self.RoundTime )
	self:RandomInfect()
end

function GM:EndRound( virusWins )

	self:CleanUpMap()

	self:SetState( STATE_INTERMISSION )
	self:SetTime( self.IntermissionTime )

	self:GiveMoney( virusWins )

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

	if #team.GetPlayers( TEAM_PLAYERS ) == 1 then
		local lastSurvivor = team.GetPlayers( TEAM_PLAYERS )[ 1 ]
		if IsValid( lastSurvivor ) then
			lastSurvivor:AddAchievement( ACHIEVEMENTS.VIRUSLASTALIVE, 1 )
			lastSurvivor:AddAchievement( ACHIEVEMENTS.VIRUSMILESTONE3, 1 )
		end
	end
	
	if #team.GetPlayers( TEAM_PLAYERS ) >=4 then
		
		for _, v in ipairs( team.GetPlayers( TEAM_PLAYERS ) ) do
			v:SetAchievement( ACHIEVEMENTS.VIRUSTEAMPLAYER, 1 )
		end

	end

	if virusWins then
		GAMEMODE:HudMessage( nil, 11 /* infected have prevailed */, 5 )
		music.Play( EVENT_PLAY, MUSIC_ROUNDEND_VIRUS )
	else
		GAMEMODE:HudMessage( nil, 12 /* survivors have won */, 5 )
		music.Play( EVENT_PLAY, MUSIC_ROUNDEND_SURVIVORS )
	end

	net.Start( "EndRound" )
		net.WriteBool( virusWins )
	net.Broadcast()

end

function GM:RoundReset()

	globalnet.SetNet( "Round", globalnet.GetNet( "Round" ) + 1 )
	//self:IncrementRound()

	for k,v in pairs( player.GetAll() ) do
		v:SetTeam( TEAM_PLAYERS )
		v:SetNet( "IsVirus", false )
		v:SetNet( "Enraged", false )
		
		self:GiveLoadout( v )
	end

	self:RoundRespawn()

	self:SetState( STATE_INFECTING )
	self:SetTime( math.random( self.InfectingTime[1], self.InfectingTime[2] ) )

	self.HasLastSurvivor = false

	net.Start( "StartRound" )
		net.WriteInt( 1, 8 )
	net.Broadcast()

	self:PlayerFreeze( false )

	music.Play( EVENT_PLAY, MUSIC_WAITING_FOR_INFECTION )
end