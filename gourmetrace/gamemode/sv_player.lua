function GM:PlayerInitialSpawn( ply )

	if ply:IsBot() then return end

	timer.Simple( 2, function()
		umsg.Start( "PlayerCute" )
		umsg.End()
	end )

	self:SetMusic( MUSIC_WAITING, ply )
	self:SetSpawn( SPAWN_WAITING, ply )

	if self:GetGameState() == STATE_WAITING && !self.FirstPlySpawned then

		self:WaitRound()
		self.FirstPlySpawned = true

	end

end

function GM:PlayerLoadout( ply ) ply:StripWeapons() end // this aint no silly fps junkie game! this IS GOOOOOOOOOOURMET RACE!!

function GM:PlayerSpawn( ply )

	umsg.Start( "PlayerCute" )
	umsg.End()

	ply:SetCollisionGroup( COLLISION_GROUP_NONE )
	ply:SetCustomCollisionCheck( true )
	ply:SetJumpPower( 250 )
	ply:CrosshairDisable()
	ply:SetTeam( TEAM_RACING )

	//MOVEMGR:SpawnOnSegment( ply )

	if !ply.ViewEnt then
		ply.ViewEnt = ents.Create( "prop_dynamic" )
		ply.ViewEnt:SetSolid( SOLID_NONE )
		ply.ViewEnt:SetPos( ply:GetPos() )
		ply.ViewEnt:SetParent( ply )
		ply.ViewEnt:SetNoDraw( true )
		ply:SetViewEntity( ply.ViewEnt )
	end

	hook.Call( "PlayerSetModel", GAMEMODE, ply )
	hook.Call( "PlayerLoadout", GAMEMODE, ply )

end

function GM:PlayerHurt( ply )
	//PostEvent( ply, "pdamage" )
end

function GM:PlayerDeath( victim, inflictor, attacker )

	if IsValid( attacker ) && !attacker:IsPlayer() && IsValid( attacker:GetOwner() ) then
		inflictor = attacker
		attacker = attacker:GetOwner()
	end

	self.BaseClass.PlayerDeath( self, victim, inflictor, attacker )

end

function GM:DoPlayerDeath( ply, attacker, dmginfo )

	ply:AddDeaths( 1 )
	ply:CreateRagdoll()

end

function GM:OnPlayerHitGround( ply )
end

function GM:PlayerDeathSound()
	return true
end

function GM:PlayerNoClip( ply )
	return false
end

function GM:PlayerSwitchFlashlight( ply, on )
	return false
end

function GM:GetFallDamage( ply, vel ) return 0 end
