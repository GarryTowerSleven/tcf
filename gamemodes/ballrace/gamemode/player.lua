function GM:IsSpawnpointSuitable( pl, spawnpointent, bMakeSuitable )
	return
end

function GM:LateJoin( ply )
	hook.Add("SetupMove", ply:SteamID64(), function(ply2, mv, cmd)
		if ply2 == ply and !cmd:IsForced() then
			ply.Late = false
			hook.Remove("SetupMove", ply:SteamID64())
		end
	end )
end

function GM:PlayerInitialSpawn(ply)

	if self:GetState() != STATE_WAITING then
		ply:SetTeam( TEAM_DEAD )
		ply.Late = true
		self:LateJoin( ply )
	end

	if ply:IsBot() then return end
	
	net.Start("pick_ball")
	net.Send(ply)

	if self:GetState() == STATE_NOPLAY && #player.GetAll() == 1 then
		game.CleanUpMapEx()

		self:SetState( STATE_WAITING )
		self:SetTime( GAMEMODE.WaitForPlayersTime )

		ply:ChatPrint("You are the first to join, waiting for additional players!")
	end

	hook.Add( "PlayerSpawnClient", "WaitingMessage", function( ply )
		if self:GetState() == STATE_WAITING then
			self:RoundMessage( MSGSHOW_WAITING, ply, GAMEMODE:GetTime() - CurTime() - 1 )
		end
	end)

end

function GM:PlayerDisconnected(ply)
	ply:SetTeam( TEAM_DEAD )
	self:UpdateSpecs( ply, true )

	self:LostPlayer( ply, true )
	self:ColorNotifyAll( ply:Name().. " has dropped out of the race." )
end

function GM:DoPlayerDeath(ply)
	if ply.NextSpawn and ply.NextSpawn > CurTime() then return end

	if ply:Deaths() - 1 == 0 then
		ply:SetTeam( TEAM_DEAD )
		self:UpdateSpecs( ply, true )
	end

	ply:SetDeaths( ply:Deaths() - 1 )

	local tr = util.QuickTrace(ply:GetPos(), Vector(0, 0, -1024), ply.Ball)
	ply.Fallout = !tr.Hit or tr.HitTexture == "TOOLS/TOOLSSKYBOX"
	if !ply.Fallout || ply.Ball && ply.Ball.Repel then
		self:LostPlayer( ply )

		local effectdata = EffectData()
		effectdata:SetOrigin( ply:GetPos() )
		util.Effect( "confetti", effectdata )

		ply:EmitSound("weapons/ar2/npc_ar2_altfire.wav", 75, math.random(160,180), 1, CHAN_AUTO )
	else
		sound.Play("ambient/levels/labs/teleport_winddown1.wav", util.QuickTrace(ply:GetPos(), Vector(0, 0, -64) + ply.Ball:GetVelocity() * 0.2, ply.Ball).HitPos, 70, 255)
		ply.Ball:SetModelScale(0, 1)
		ply:SetModelScale(0, 1)
		constraint.NoCollide(ply.Ball, game.GetWorld(), 0, 0)

		timer.Simple(1, function()
			self:LostPlayer(ply)
		end)
	end

	ply.NextSpawn = CurTime() + 2
end

function GM:PlayerDeathThink( pl )
	if (pl.NextSpawn or 0) <= CurTime() then
		pl:Spawn()
	end
end

function GM:PlayerDeathSound( ply )

	return true
end

function GM:PlayerSpawn(ply)
	if self:GetState() == STATE_SPAWNING && ply.Late != true || ply:Team() == TEAM_PLAYERS then

		ply.Spectating = nil

		if IsValid(ply.Ball) then
			ply.Ball:Remove()
			ply.Ball = nil
		end

		ply:UnSpectate()
		ply:SetTeam( TEAM_PLAYERS )

		ply:SetColor( Color( 0,0,0,0 ) )
		ply:SetNotSolid(true)
		ply:SetMoveType( MOVETYPE_NOCLIP )

		ply.Ball = ents.Create("player_ball")

		ply.Ball:SetPos(ply:GetPos() + Vector(0,0,48))

		ply.Ball:SetSkin((ply:EntIndex()-1) % 6)

		ply.Ball:SetOwner(ply)

		ply.Ball:Spawn()

		ply:SetBall(ply.Ball)

		self:UpdateSpecs(ply)

	else
		local delay = CurTime() + 0.5

		ply:Spectate(OBS_MODE_ROAMING)
		
		if ply:Team() != TEAM_DEAD then
			hook.Add( "Think", "SpectateDelay", function()
				if CurTime() < delay then return end
				self:SpectateNext(ply)
				hook.Remove( "Think", "SpectateDelay" )
			end )
		else
			self:SpectateNext(ply)
		end

		self:UpdateStatus()

	end

	ply:CrosshairDisable()
end

function GM:PlayerSelectSpawn(ply)
	if LateSpawn then
		return LateSpawn
	end
	return self.BaseClass:PlayerSelectSpawn(ply)
end

function GM:KeyPress(ply, key)
	if ply:Team() == TEAM_PLAYERS || !ply:Alive() then return end

	if key == IN_ATTACK then
		self:SpectateNext(ply)
	end
end

function GM:SetupPlayerVisibility(ply)
	local ball = ply:GetBall()
	if IsValid(ball) then
		AddOriginToPVS(ball:GetPos())
	end
end

function GM:CanPlayerSuicide( ply )
	return ply:Team() == TEAM_PLAYERS
end

function GM:PlayerSpray( pl )
	return pl:Team() != TEAM_PLAYERS
end

function GM:PlayerSwitchFlashlight(ply)
	return false
end

function GetPlayerStatus(ply)
	local player_status

	if ply:Team() == TEAM_DEAD then
		player_status = "DEAD"
	elseif ply:Team() == TEAM_COMPLETED then
		player_status = ply.placements
	elseif GAMEMODE:GetState() == STATE_WAITING then
		player_status = "WAITING"
	elseif GAMEMODE:GetState() != STATE_WAITING then
		player_status = "PLAYING"
	end

	return player_status
end

hook.Add( "PlayerInitialSpawn", "StartMusic", function( ply )

	music.Play( 1, MUSIC_LEVEL, ply )

end )