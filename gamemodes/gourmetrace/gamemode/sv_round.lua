GM.DefaultRoundTime = 60 * 1.5 //maximum time before the round ends.
GM.WaitingTime = 60
GM.IntermissionTime = 15

util.AddNetworkString("ShowReadyScreen")

function GM:PreStartRound()

	//We are done here, send them back to the main server
	if ( self:GetRoundCount() + 1 ) > self.NumRounds then
		self:EndServer()
		return
	end

	globalnet.SetNet( "Round", self:GetRoundCount() + 1 )
	self:SetTime( 3 )
	self.Ending = false
	self.Intense = false
	self.FinishedPlayers = 0

	Msg( "Starting round! " .. tostring( self:GetRoundCount() ) .. "\n" )

	self:SetState( STATE_WARMUP )
	self:SetAllSpawn( SPAWN_STARTLINE )

	self:CleanUpMap( false )

	for _, ply in ipairs( player.GetAll() ) do

		ply:SetTeam( TEAM_RACING )

		ply:SetFrags( 0 )

		ply:StripWeapons()
		ply:RemoveAllAmmo()

		ply:Kill()
		ply:Spawn()
		ply:Freeze( true )
		ply:SetNet( "Rank", 99 )
		ply:SetNet( "Points", 0 )

		GAMEMODE:SetSpawn( SPAWN_STARTLINE, ply )
		ply:ConCommand( "gmt_showscores 0" )

	end

end

function GM:StartRound()

	self:SetTime( self.DefaultRoundTime )
	self:SetState( STATE_PLAYING )
	music.Play( 1, MUSIC_ROUND )

	for k, ply in ipairs( player.GetAll() ) do

		if k == 1 then ply:EmitSound('gmodtower/pvpbattle/ragingbull/deagle-1.wav',100,150) end

		ply:SetNet( "Pos", 99 )
		ply:Give( "weapon_kirby_hammer", true )
		ply:SetStepSize(30)
		ply:Freeze( false )
		ply.StartTime = CurTime()
		ply:SetNet( "Powerup", "" )

		GAMEMODE:SetSpawn( SPAWN_STARTLINE, ply )

	end

end

function GM:WaitRound( force )

	Msg( "Waiting for players.", "\n" )

	self:SetState( STATE_WAITING )

	if !self.FirstPlySpawned || force then
		self:SetTime( self.WaitingTime )
	end

	if force then
		self:SetAllSpawn( SPAWN_WAITING )
		music.Play( MUSIC_WAITING )
	end

end

function GM:EndRound( teamid )

	self:GiveMoney()

	self:SetTime( ( self.IntermissionTime or 12 ) )

	Msg( "Ending Round...\n" )

	self:SetState( STATE_INTERMISSION )
	hook.Run("ResetPositions")

	timer.Simple( 4, function() music.Play( 1, MUSIC_ENDROUND ) end )

	for _, ply in ipairs( player.GetAll() ) do

		ply:AddAchievement(ACHIEVEMENTS.GRMILESTONE1,1)

		self:SetRankSpawn( ply )

		if ply:GetNet( "Rank" ) && ply:GetNet( "Rank" ) <= 3 then
			music.Play( 1, MUSIC_WIN, ply )
		else
			if ply:Team() != TEAM_FINISHED then
				music.Play( 1, MUSIC_TIMEUP, ply )
			else
				music.Play( 1, MUSIC_LOSE, ply )
			end
		end

		ply:Kill()
		ply:Spawn()
		ply:SetNet( "Powerup", "" )

	end

end
