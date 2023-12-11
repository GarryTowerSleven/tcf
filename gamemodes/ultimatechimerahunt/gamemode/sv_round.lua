GM.WaitingTime = 45
GM.IntermissionTime = 12
GM.OverTimeAdd = 5

function GM:StartRound()

	//We are done here, send them back to the main server
	if ( globalnet.GetNet("Round") + 1 ) > self.NumRounds then
		self:EndServer()
		return
	end

	globalnet.SetNet( "RoundStart", CurTime() )

	//Check if we have enough players.
	//local clients = player.GetAll()
	//local connecting = clients.spawning
	//if connecting < 1 && #player.GetAll() <= 1 then
	if #player.GetAll() <= 1 then

		Msg( "Not enough players - ending game.", "\n" )
		self:EndServer()  //no one connecting and not enough on the server...
		return

	//elseif connecting >= 1 && #player.GetAll() == 1 then
	elseif #player.GetAll() == 1 then

		Msg( "Enough players are connected, but only one spawned - waiting.", "\n" )
		self:WaitRound( true ) //jesus they're taking forever to join
		return

	end

	globalnet.SetNet("Round", globalnet.GetNet("Round") + 1)
	globalnet.SetNet("Time", CurTime() + self.RoundTime)
	self.Intense = false
	self.UCAngry = false

	Msg( "Starting round! " .. tostring( globalnet.GetNet("Round") ) .. "\n" )

	self:SetState( STATE_PLAYING )

	self:CleanUp()
	//self.CanStartDead = CurTime() + 5

	for _, v in ipairs( player.GetAll() ) do
		v:SetNet( "IsChimera", false )
		v:SetNet( "PressedButton", false )
		v:SetNet( "KilledWithSaturn", false )
	end

	globalnet.SetNet("UC", NULL)
	self:RandomChimera()
	self.SpawnedSaturn = false
	self.SaturnSpawn = nil

	for _, v in ipairs( player.GetAll() ) do

		v:UnGhost()
		v.IsDead = false
		if !v:GetNet("IsChimera") then v:SetTeam( TEAM_PIGS ) end
		self:SetMusic( v, MUSIC_ROUND, v:Team() )
		//v:Freeze( false )

		v:SetFrags( 0 )
		v:SetDeaths( 0 )

		v:StripWeapons()
		v:RemoveAllAmmo()

		v:Spawn()

	end

	umsg.Start( "UCRound" )
	umsg.End()

end

function GM:WaitRound( force )

	Msg( "Waiting for players.", "\n" )

	self:SetState( STATE_WAITING )

	if !self.FirstPlySpawned || force then
		globalnet.SetNet("Time", CurTime() + self.WaitingTime)
	end

	if force then
		for _, v in ipairs( player.GetAll() ) do //restart music

			self:SetMusic( v, MUSIC_WAITING )
			self:HUDMessage( v, MSG_FIRSTJOIN, 10 )

			//v:Freeze( false )
			v:Spawn()

		end
	end

	/*timer.Destroy( "WaitingStart" )
	timer.Create( "WaitingStart", self.WaitingTime, 1, self.StartRound, self )*/

end

function GM:EndRound( teamid )

	local endofgame = false
	if ( globalnet.GetNet("Round") + 1 ) > self.NumRounds then endofgame = true end

	globalnet.SetNet("Time", CurTime() + ( self.IntermissionTime or 12 ))

	Msg( "Ending Round...\n" )

	self:SetState( STATE_INTERMISSION )

	for _, v in ipairs( player.GetAll() ) do

		/*if v:GetNet("IsChimera") then
			v:Freeze( true )
		end*/

		v:ConCommand("gmt_showscores 1")

		v:AddAchievement( ACHIEVEMENTS.UCHMILESTONE1, 1 )
		v:AddAchievement( ACHIEVEMENTS.UCHMILESTONE2, 1 )

		if endofgame then
			self:SetMusic( v, MUSIC_ENDROUND, TEAM_SALSA )
		else
			self:SetMusic( v, MUSIC_ENDROUND, teamid )
		end

		if teamid == TEAM_PIGS then

			if v:Team() == TEAM_PIGS then

				v:AddAchievement( ACHIEVEMENTS.UCHENTERTHEPIG, 1 )
				if team.AlivePigs() >= 3 then
					v:AddAchievement( ACHIEVEMENTS.UCHDYNASTY, 1 )
				end

			end

			self:HUDMessage( v, MSG_PIGWIN, 10 )
			self.WinningTeam = TEAM_PIGS

		elseif teamid == TEAM_CHIMERA then

			self:HUDMessage( v, MSG_UCWIN, 10 )
			self.WinningTeam = TEAM_CHIMERA

			local uc = self:GetUC()

			if IsValid(uc) then
				uc:AddAchievement( ACHIEVEMENTS.UCHMOTHER, 1 )

				if !uc.Jumped then
					uc:AddAchievement( ACHIEVEMENTS.UCHEARTHBOUND, 1 )
				end

				if uc:GetNet( "TimesRoared" ) == 0 then
					uc:AddAchievement( ACHIEVEMENTS.UCHSILENTDEADLY, 1 )
				end
			end

		else
			self:HUDMessage( v, MSG_TIEGAME, 10 )
			self.WinningTeam = 1002
		end

	end

	self:GiveMoney()

	umsg.Start( "UCRound" )
	umsg.End()

end

local cid = 0

function GM:RandomChimera()

	Msg( "Finding Chimera...", "\n" )

	local plys = player.GetAll()
	local PlayerCount = #plys
	
	for _, ply in ipairs(plys) do
		if ply:GetInfoNum("gmt_uch_optout", 0) != 0 then
			table.RemoveByValue(plys, ply)
		end
	end

	if PlayerCount == 0 then
		self:EndServer()
		return
	end

	if plys == 0 && PlayerCount >= 1 then
		plys = player.GetAll()
	end
	
	if cid == 0 || cid > #plys then
		cid = 1
	end

	math.randomseed( RealTime() * 5555 )

	local ucPlayer
	
	ucPlayer = plys[ cid ]

	globalnet.SetNet("UC", ucPlayer)
	self:SetChimera( ucPlayer )
	cid = cid + 1

	if PlayerCount > 1 then
		self.LastChimera = ucPlayer
	end

end

function GM:SetChimera( ply )

	ply:SetNet("IsChimera",true)
	ply:SetTeam( TEAM_CHIMERA )

	ply.Jumped = false
end

function GM:CheckGame( ply ) //this function checks if the game should end or not based on the players alive

	if !self:IsPlaying() then return end

	Msg( "Alive pigs: " .. team.AlivePigs(), "\n" )

	if ply:GetNet("IsChimera") then

		self:EndRound( TEAM_PIGS )

	elseif team.AlivePigs() <= 0 then

		self:EndRound( TEAM_CHIMERA )

	end

end

function GM:CleanUp()

	self:CleanUpMap( false )

	local rag = self.UCRagdoll
	if IsValid( rag ) then
		rag:Remove()
	end
	local bird = self.BirdProp
	if IsValid( bird ) then
		bird:Remove()
	end

end
