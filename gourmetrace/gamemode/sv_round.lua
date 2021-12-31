GM.DefaultRoundTime = 60 * 1.5 //maximum time before the round ends.
GM.WaitingTime = 60
GM.IntermissionTime = 15

util.AddNetworkString("ShowReadyScreen")

function GM:PreStartRound()

	//We are done here, send them back to the main server
	if ( GetGlobalInt( "Round" ) + 1 ) > self.NumRounds then
		self:EndServer()
		return
	end

	SetGlobalInt( "Round",GetGlobalInt( "Round" ) + 1 )
	SetGlobalInt( "Time", CurTime() + 3 )
	self.Ending = false
	self.Intense = false
	self.FinishedPlayers = 0

	Msg( "Starting round! " .. tostring( GetGlobalInt( "Round" ) ) .. "\n" )

	self:SetGameState( STATE_WARMUP )
	--self:SetMusic( MUSIC_WARMUP )
	self:SetAllSpawn( SPAWN_STARTLINE )

	game.CleanUpMap()

	for _, ply in ipairs( player.GetAll() ) do

		ply:SetTeam( TEAM_RACING )

		ply:SetFrags( 0 )

		ply:StripWeapons()
		ply:RemoveAllAmmo()

		ply:Kill()
		ply:Spawn()
		ply:Freeze( true )
		ply:SetNWInt( "Rank", nil )
		ply:SetNWInt("Points",0)

		GAMEMODE:SetSpawn( SPAWN_STARTLINE, ply )

	end

end

function GM:StartRound()

	SetGlobalInt( "Time", CurTime() + self.DefaultRoundTime )
	self:SetGameState( STATE_PLAYING )
	self:SetMusic( MUSIC_ROUND )

	for k, ply in ipairs( player.GetAll() ) do

		if k == 1 then ply:EmitSound('gmodtower/pvpbattle/ragingbull/deagle-1.wav',100,150) end

		ply:Give("weapon_kirby_hammer",true)
		ply:SetStepSize(30)
		ply:Freeze( false )
		ply.StartTime = CurTime()
		ply:SetNWString("Powerup","")

		GAMEMODE:SetSpawn( SPAWN_STARTLINE, ply )

	end

end

function GM:WaitRound( force )

	Msg( "Waiting for players.", "\n" )

	self:SetGameState( STATE_WAITING )

	if !self.FirstPlySpawned || force then
		SetGlobalInt( "Time", CurTime() + self.WaitingTime )
	end

	if force then
		self:SetAllSpawn( SPAWN_WAITING )
		self:SetMusic( MUSIC_WAITING )
	end

end

function GM:EndRound( teamid )

	self:GiveMoney()

	SetGlobalInt( "Time", CurTime() + ( self.IntermissionTime or 12 ) )

	Msg( "Ending Round...\n" )

	self:SetGameState( STATE_INTERMISSION )
	hook.Run("ResetPositions")

	if GetGlobalInt("Round") == GAMEMODE.NumRounds then
		SetGlobalBool("NoReadyScreen",true)
	end

	timer.Simple( 4, function() self:SetMusic( MUSIC_ENDROUND ) end )

	for _, ply in ipairs( player.GetAll() ) do

		ply:AddAchievement(ACHIEVEMENTS.GRMILESTONE1,1)

		ply:ConCommand("gmt_showscores 0")
		self:SetRankSpawn( ply )

		if ply:GetNWInt( "Rank" ) && ply:GetNWInt( "Rank" ) <= 3 then
			self:SetMusic( MUSIC_WINLOSE, ply, true )
		else
			self:SetMusic( MUSIC_WINLOSE, ply, false )
		end

		ply:Kill()
		ply:Spawn()
		ply:SetNWString("Powerup","")

	end

end
