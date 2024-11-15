strikes = {
	Sound( "npc/zombie/claw_strike1.wav" ),
	Sound( "npc/zombie/claw_strike2.wav" ),
	Sound( "npc/zombie/claw_strike3.wav" )
}

function GM:PlayerDisconnected(ply)

	if ( self:GetState() == 0 ) then return end

	local Players = #player.GetAll()

	if ( Players == 1 ) then
		self:EndServer()
		return
	end

	if ( self:GetState() != STATE_PLAYING ) then return end

	local NumVirus = #team.GetPlayers( TEAM_INFECTED )

	if ply:GetNet( "IsVirus" ) then
		if ( NumVirus <= 1 ) then
			self:HudMessage( nil, 18 /* Last infected has left */, 5 )
			timer.Simple( 1, function() GAMEMODE:RandomInfect() end )
		end
	end

end

function GM:HandlePlayerDeath( ply, attacker, inflictor )

	if ( ply.Flame != nil ) then  //flame off, bro
		ply:SetNWBool("Flame", false)
		ply.Flame = nil
	end

	if ply:GetNet( "IsVirus" ) then
		eff = EffectData()
			eff:SetOrigin( ply:GetPos() + Vector( 0, 0, 50 ) )
		util.Effect( "virus_explode", eff )

		virusDeath = virusDeath + 1
	end

	ply.RespawnTime = CurTime() + 4

	if IsValid( attacker ) && attacker:IsPlayer() then

		if IsValid( attacker:GetActiveWeapon() ) then
			if attacker:GetActiveWeapon():GetClass() == "weapon_sniperrifle" then
				attacker:AddAchievement( ACHIEVEMENTS.VIRUSPOINTANDCLICK, 1 )
			end
		end

		if IsValid( inflictor ) then

			local ent = inflictor:GetClass()
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

	ply:CreateRagdoll()

end

function GM:RandomInfect()

	self:SetState( STATE_PLAYING )

	local time = self.RoundTime
	self:SetTime( time )

	local plycount = player.GetAll()

	if ( #plycount <= 1 ) then
	
		GAMEMODE:EndServer()
		return
		
	end
	
	local plysawake = {}
	local plys = {}

	for _, ply in ipairs(player.GetAll()) do
		if !ply:GetNet("AFK") then
			table.insert(plysawake, ply)
			if ply != GAMEMODE.LastInfected then
				table.insert (plys, ply)
			end
		end
	end
	
	math.randomseed( RealTime() * 5555 )
	
	local infected = table.Random(plys)
	
	if table.IsEmpty(plys) then
		if !table.IsEmpty(plysawake) then
			infected = table.Random(plysawake)
		elseif table.IsEmpty(plysawake) then
			infected = table.Random(player.GetAll())
		end
	end
	
	self.FirstInfected = infected
	
	self:Infect(infected)
	infected.FirstSpawn = true
	
	if #plycount > 1 then
		GAMEMODE.LastInfected = infected
	end

end

--local VirusColor = Color( 155, 200, 160, 255 )
local VirusColor = Color( 255, 255, 255, 255 )

function GM:Infect( ply, infector )

	if self:GetState() != 3 then return end

	if !IsValid( ply ) then return end

	if ( ply:GetNet( "IsVirus" ) ) then return end

	if ( infector == nil ) then

		infector = GetWorldEntity()

		if ply:AchievementLoaded() then ply:AddAchievement( ACHIEVEMENTS.VIRUSLOSTHOPE, 1 ) end
		self:HudMessage( nil, 16 /* %s has been infected! */, 5, ply, nil, VirusColor )

	end

	if ( infector:IsPlayer() ) then

		local tr = util.TraceLine{
			start = infector:GetPos(),
			endpos = ply:GetPos(),
			filter = infector
		}

		if tr.HitWorld then return end

		infector:AddAchievement( ACHIEVEMENTS.VIRUSPANDEMIC, 1 )
		infector:AddFrags( 1 )

		infector:EmitSound(table.Random(strikes), 75, math.random( 90, 150 ), .5 )
		
		infector.ProliferationCount = infector.ProliferationCount + 1

		if infector.ProliferationTimer < CurTime() then
			infector.ProliferationTimer = 6+CurTime()
		end

		self:ScorePoint( infector )

		ply:AddDeaths( 1 ) // todo: should being infected add 1 to deaths?
		ply:EmitSound( "ambient/fire/ignite.wav", 75, math.random( 170, 200 ), 1, CHAN_AUTO )

		for _, v in ipairs( player.GetAll() ) do
			if ( v != ply ) then
				self:HudMessage( v, 17 /* %s was infected by %s! */, 2, ply, infector, VirusColor )
			else
				self:HudMessage( ply, 13 /* %s has infected you! */, 5, infector, nil, VirusColor )
			end
		end

	end

	//Fucking zoom
	ply:SetFOV( 0, 0 )

	if self.HasLastSurvivor != true then -- unnecessary 
		net.Start( "Scream" )
		net.WriteEntity( ply )
		net.Broadcast()
	end
	
	ply:SetTeam( TEAM_INFECTED )

	self:VirusSpawn( ply )

	ply:SetNet( "IsVirus", true )

	PostEvent( ply, "lastman_off" )
	PostEvent( ply, "adrenaline_off" )

	ply:SetDSP( 1 ) // turn off adrenaline dsp
	
	if ply._FlashlightEnabled then
		ply:Flashlight( false )
	end

	net.Start( "Infect" )
		net.WriteEntity( ply )
		net.WriteEntity( infector )
	net.Broadcast()

	music.Play( EVENT_PLAY, MUSIC_IGNITE, ply )
end

function GM:SetLastSurvivor()

	if ( self.HasLastSurvivor ) then return end

	-- timer.Simple( .2, function() music.Play( EVENT_PLAY, MUSIC_LAST_ALIVE ) end ) -- jank, but i cant figure out how else to get the music to play properly and not end up overlapping
	
	music.Play( EVENT_PLAY, MUSIC_LAST_ALIVE )

	local lastPlayer = team.GetPlayers( TEAM_PLAYERS )[ 1 ]

	PostEvent( lastPlayer, "adrenaline_off" ) // in case they used it
	PostEvent( lastPlayer, "lastman_on" )

	for _,v in ipairs( team.GetPlayers( TEAM_INFECTED ) ) do

		self:HudMessage( v, 3 /* last survivor is %s */, 5, lastPlayer )

	end

	self:HudMessage( lastPlayer, 2 /* you are the last survivor */, 5 )

	self.LastSurvivor = lastPlayer

	self.HasLastSurvivor = true

end

function GM:PlayerFreeze( freezeToggle, ply )

	if ply == nil then
		for k,v in pairs( player.GetAll() ) do
			v:Freeze( freezeToggle )
		end
	else
		if IsValid( ply ) then
			ply:Freeze( freezeToggle )
		end
	end

end

function GM:ScorePoint( ply )

	net.Start( "ScorePoint" )
	net.Send( ply )

end

function GM:WeaponsGive( ply )

	local weapons = self:GetSelectedWeapons()

	for k,v in pairs(weapons) do
		ply:Give( v )
	end

end

function GM:GiveLoadout( ply )

	ply:StripWeapons()
	ply:RemoveAllAmmo()

	self:WeaponsGive( ply )

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

function GM:AllowPlayerPickup( ply, ent )

	return false

end

function GM:PlayerSwitchFlashlight(ply, enabled	)

	if ply._FlashlightEnabled == false && ply:GetNet( "IsVirus" ) || self:GetState() == STATE_WAITING || self:GetState() == STATE_INTERMISSION then 
		return false
	end

	ply._FlashlightEnabled = enabled
	
	return true
end

function GM:PlayerShouldTakeDamage( victim, attacker )

	if victim:IsPlayer() && attacker:IsPlayer() && ( victim:Team() == attacker:Team() ) then
		return false
	end

	if ( !victim:GetNet( "IsVirus" ) ) then return false end

	local rp = RecipientFilter()
	rp:AddPlayer( victim )

	net.Start( "DmgTaken" )
	net.Send( rp )

	return true

end

function GM:PlayerDeathSound( ply )

	return true

end

hook.Add( "GetFallDamage", "DisableFallDamage", function( ply, speed )

    return 0

end )

hook.Add( "CanPlayerSuicide", "AllowSuicide", function( ply )

	return false

end )

hook.Add( "PlayerDeath", "ScorePointMessage", function( victim, inflictor, attacker )

	if victim:Team() == TEAM_PLAYERS then
		if GAMEMODE:GetState() == STATE_PLAYING then
			timer.Simple ( 0.01, function()
				victim:SetTeam( TEAM_INFECTED )
				victim:SetNet( "IsVirus", true )
				GAMEMODE:HudMessage( nil, 16 /* %s has been infected! */, 5, victim, nil, VirusColor )
			end )
		end
	end

	GAMEMODE:HandlePlayerDeath( victim, attacker, inflictor )
	GAMEMODE:ScorePoint( attacker )

end )

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