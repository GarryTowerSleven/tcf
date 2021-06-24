function GM:PlayerInitialSpawn( ply )
	
	RegisterNWTableP(ply)
	ply:SetCustomCollisionCheck( true )
	
	if ply:IsBot() then return end

	if self:GetGameState() == STATUS_WAITING then

		local plys = player.GetAll()

		if #plys == 1 then

			GAMEMODE:SetState( 2 )
			self:HUDMessage( ply, MSG_FIRSTJOIN, 10 )

		elseif #plys > 1 then

			self:HUDMessage( ply, MSG_WAITJOIN, 10 )

		end

		self:WaitRound()

		if !self.FirstPlySpawned then
			self.FirstPlySpawned = true
		end

		return

	end

	if self:IsPlaying() then
		ply.IsDead = true //prevents rejoining
	end

end

function GM:PlayerSpawn( ply )

	if ply:IsBot() then return end

	if self:GetGameState() == STATUS_WAITING then

		timer.Simple( 1, function()
			self:SetMusic( ply, MUSIC_WAITING )
		end )

	end

	if !self:IsPlaying() && !ply:GetNWBool("IsGhost") then
		ply:SetGhost()
	end

	if ply.IsDead then

		ply:SetGhost()

		if ply.DeadPos then
			ply:SetPos( ply.DeadPos )
		end
		ply.IsDead = false

		if self:IsPlaying() then

			if ply:GetNWBool("IsFancy") then
				if IsValid( ply ) && ply:AchivementLoaded() then ply:AddAchivement( ACHIVEMENTS.UCHDRUNKEN, 1 ) end
			end

		end

	end

	if ply:GetNWBool("IsGhost") then
		ply:ResetVars()
		return
	end

	ply:StripWeapons() //this is uch, not some silly gunshooting flipflapping fps

	ply:ResetVars()  //reset rank, speeds, etc.
	
	timer.Simple(0.25, function()
		if IsValid(ply) then
			self:SetMusic( ply, MUSIC_SPAWN )
		end
	end)
	
	ply:SetupModel()

	if ply:GetNWBool("IsChimera") then

		ply:SetTeam( 2 )
		
		timer.Simple(0.25, function()
			self:HUDMessage( ply, MSG_UCNOTIFY, 5, nil, nil, ply:GetRankColor() )
		end)

	else

		ply:SetTeam( 1 )
		
		timer.Simple(0.25, function()
			self:HUDMessage( ply, MSG_UCSELECT, 8, self:GetUC() )
			self:HUDMessage( ply, MSG_PIGNOTIFY, 5, ply, nil, ply:GetRankColor() )
		end)

	end

end

function GM:PlayerSelectSpawn( ply )

    local spawns = ents.FindByClass( "info_player*" )

	if ply:Team() == TEAM_CHIMERA || ply:GetNWBool("IsChimera") then

		local chimera_spawns = ents.FindByClass( "chimera_spawn" )
		return chimera_spawns[ math.random( #chimera_spawns ) ]

	end

	return spawns[ math.random( #spawns ) ]

end

function GM:IsValidSpawn( ent )

	for _, v in ipairs( ents.FindInSphere( ent:GetPos(), 256 ) ) do
		return false
	end

	return true

end
