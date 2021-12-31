

function GM:PlayerDisconnected(ply)

	--if ( ply:IsBot() || #player.GetBots() > 0 ) then return end

	ply:SetTeam( TEAM_SPEC )

	// last player left, and we never started a game, so cancel the waiting start
	if ( GetGlobalInt("State") == STATE_WAITING && #player.GetAll() == 1 ) then
		timer.Destroy( "WaitingStart" )
		timer.Destroy( "WaitingFade" )
	end

	if ( ply:GetNWBool("IsVirus") ) then
		SetGlobalInt("NumVirus",GetGlobalInt("NumVirus") - 1)
	end

	local numPlys = #player.GetAll()

	if ( numPlys == 0 ) then
		self:EndServer()
		return
	end

	if ( GetGlobalInt("State") != STATE_PLAYING ) then return end

	if ( GetGlobalInt("NumVirus") == 0 ) then

		GAMEMODE:HudMessage( nil, 18 /* Last infected has left */, 5 )
		timer.Simple( 1, function() GAMEMODE:RandomInfect() end )

		/*timer.Destroy( "RoundEnd" )

		self:EndRound( false ) // survivors win*/


	end

end


function GM:PlayerShouldTakeDamage( victim, attacker )

	if victim:IsPlayer() && attacker:IsPlayer() && ( victim:Team() == attacker:Team() ) then
		return false
	end

	if ( !victim:GetNWBool("IsVirus") ) then return false end

	local rp = RecipientFilter()
	rp:AddPlayer( victim )

	umsg.Start( "DmgTaken", rp )
	umsg.End()

	return true
end


function GM:DoPlayerDeath( ply, attacker, dmginfo )

	if ( ply.Flame != nil ) then  //flame off, bro
		ply.Flame:Remove()
		ply.Flame = nil

		ply.Flame2:Remove()
		ply.Flame2 = nil
	end

	if ply:GetNWBool("IsVirus") then
		eff = EffectData()
			eff:SetOrigin( ply:GetPos() + Vector( 0, 0, 50 ) )
		util.Effect( "virus_explode", eff )
	end

	ply.RespawnTime = CurTime() + 4

	if IsValid( attacker ) && attacker:IsPlayer() then

		if ( attacker == ply ) then
			attacker:AddDeaths( 1 )
		else
			self:AddScore( attacker, 1 )

			if IsValid( attacker:GetActiveWeapon() ) then
				if attacker:GetActiveWeapon():GetClass() == "weapon_sniperrifle" then
					attacker:AddAchievement( ACHIEVEMENTS.VIRUSPOINTANDCLICK, 1 )
				end
			end

		end

		if IsValid( dmginfo:GetInflictor() ) then

			local ent = dmginfo:GetInflictor():GetClass()
			if ent == "tnt" then

				attacker:AddAchievement( ACHIEVEMENTS.VIRUSEXPLOSIVE, 1 )  // yippee ki-yay mother huger

			elseif ent == "player" then

				if IsValid( attacker:GetActiveWeapon() ) then

					local weapon = attacker:GetActiveWeapon():GetClass()
					if weapon == "weapon_doublebarrel" then

						attacker._Shell = attacker._Shell + 1
						if attacker._Shell >= 2 then

							attacker:SetAchievement( ACHIEVEMENTS.VIRUSSHELLAWARE, 1 )
							attacker._Shell = 0

						end

					end

				end

			end

		end

	end

	if ( GetGlobalInt("State") == STATE_PLAYING && ply:GetNWBool("IsVirus") ) then
		ply:AddDeaths( 1 )
	end

	if ( GetGlobalInt("State") == STATE_PLAYING && !ply:GetNWBool("IsVirus") ) then
		self:Infect( ply )
	end

	ply:CreateRagdoll()

	if ( GetGlobalInt("State") != STATE_PLAYING ) then return end

	if ( ply:GetNWBool("IsVirus") ) then return end

	if ( #player.GetAll() - GetGlobalInt("NumVirus") == 1 ) then

		umsg.Start( "LastSurvivor" )
		umsg.End()

		local lastPlayer = team.GetPlayers( TEAM_PLAYERS )[ 1 ]
		PostEvent( lastPlayer, "lastman_on" )

	end
end

function GM:AddScore( ply, score )

	ply:AddFrags( score )

	umsg.Start( "ScorePoint", ply )
	umsg.End()

end


function GM:PlayerLoadout( ply )

	for _, v in ipairs( self:GetSelectedWeapons() ) do
		ply:Give( v )
	end

	if ( #ply:GetWeapons() == 0 ) then
		return
	end

	ply:SelectWeapon( self:GetStartWeapon() )

	//Ammo
	ply:GiveAmmo( 12, "SMG1", true )
	ply:GiveAmmo( 24, "357", true )
	ply:GiveAmmo( 28, "Pistol", true )
	ply:GiveAmmo( 24, "Buckshot", true )
	ply:GiveAmmo( 50, "AR2", true )


end

concommand.Add( "use_adrenaline", function( ply, cmd, args )

	if !ply:HasWeapon( "weapon_adrenaline" ) then return end

	local adrenaline = ply:GetWeapon( "weapon_adrenaline" )
	if !IsValid( adrenaline ) || adrenaline.Used then
		return
	end

	ply:SelectWeapon( "weapon_adrenaline" )
	timer.Simple( 0.15, function()
		if IsValid( ply:GetActiveWeapon() ) then
			ply:GetActiveWeapon():PrimaryAttack()
		end
	end )

end )
