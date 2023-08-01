AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_deathnotice.lua" )
AddCSLuaFile( "cl_post_events.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )
include( "player.lua" )

CreateConVar("gmt_srvid", 5 )

game.ConsoleCommand("sv_scriptenforcer 1\n")
GTowerServers:SetRandomPassword()  //Hot fix for now.

//Set a random password for the server
/*if GetConVarString("sv_password") == "" then
	GTowerServers:SetRandomPassword()
end*/

GM.DefaultRoundTime = 120
GM.GiveAllWeapons = false
GM.Weapons = {}

hook.Add("PlayerInitialSpawn", "ResetOnEmptyServer", function( ply )
	if !ply:IsBot() then
		GAMEMODE:BeginGame()

		//This is a one time deal, or it can be abused to make a infinite game by reconnecting
		hook.Remove("PlayerInitialSpawn", "ResetOnEmptyServer")

		GAMEMODE:SetState( 2 )
		StartMusicJoin(ply)
	end
end )

hook.Add( "PlayerDeathThink", "RespawnCoolDown", function( ply )
	if IsValid( ply ) && !ply:Alive() && ply.RespawnTimer < CurTime() then
		ply:Spawn()
	end

	return true
end )

hook.Add( "CanPlayerSuicide", "DisablePVPSuicide", function( ply )
	return false
end )

local function FixMarsExploit()
	if game.GetMap() == "gmt_pvp_mars" then
		local trigger = ents.Create("trigger_luadeath")
		trigger:SetPos( Vector( 0, 0, 0 ) )
		trigger:Spawn()
	end
end

hook.Add( "InitPostEntity", "MarsExploitFix", function()
	FixMarsExploit()
end )

function GM:BeginGame()
	self:SetTime( self.DefaultRoundTime )
	globalnet.SetNet( "RoundOver", false )
	globalnet.SetNet( "Round", 1 )

	for _, v in ipairs( weapons.GetList() ) do
		if ( v != nil && v.Base == "weapon_pvpbase" ) then
			table.insert( self.Weapons, v.Classname )
		end
	end
end

local RoundAlert = false

function GM:Think()
	if self:GetTimeLeft() <= 0 && self:GetRoundCount() <= self.MaxRoundsPerGame && self:GetRoundCount() > 0 then
		if self:IsRoundOver() then
			hook.Call( "StartRound", self )
		else
			hook.Call( "EndRound", self )
		end
	end

	local TimeLeft = self:GetTimeLeft()

	if TimeLeft > 0 && TimeLeft <= 16 then
		if RoundAlert then return end
		music.Play( 1, 2 )
		RoundAlert = true
	else
		RoundAlert = false
	end
end

function GM:PlayerSpawn( ply )
	// Music on join
	if !ply.MusicJoined then
		ply.MusicJoined = true
		music.Play( 1, 1, ply )
	end

	// Stop observer mode
 	ply:UnSpectate()

	// Disable default crosshair
	ply:CrosshairDisable()

	// Fuck you
	PostEvent( ply, "putimestop_off" )

 	// Call item loadout function
 	hook.Call( "PlayerLoadout", self, ply )

 	// Set player model
 	hook.Call( "PlayerSetModel", self, ply )

	if !ply._HackerAmt then
		ply._HackerAmt = 0
	end

	if !ply._TheKid then
		ply._TheKid = 0
	end
	
	if !ply._Camper then
		ply._Camper = 0
	end

	self:PlayerResetSpeed( ply )
end

function GM:PlayerResetSpeed( ply )
	ply:SetWalkSpeed( 450 )
	ply:SetRunSpeed( 450 )
end

function GM:PlayerLoadout( ply )
	if self.GiveAllWeapons == true || !PVPBattle || ply:IsBot() then
		for _, v in ipairs( self.Weapons ) do
			ply:Give( v )
		end
	else
		self:GivePVPWeapons( ply )
	end

	//Ammo
	ply:GiveAmmo( 54, "SMG1", true )
	ply:GiveAmmo( 1, "SMG1_Grenade", true )
	ply:GiveAmmo( 24, "357", true )
	ply:GiveAmmo( 28, "Pistol", true )
	ply:GiveAmmo( 18, "Buckshot", true )
	ply:GiveAmmo( 50, "AR2", true )
	ply:GiveAmmo( 12, "SniperRound", true )
	ply:GiveAmmo( 4, "RPG_Round", true )
	ply:GiveAmmo( 4, "slam", true )
end

function GM:GivePVPWeapons( ply )
	local delay = 5

	if ply.WeaponList != nil then
		delay = 0
	end

	PopulateLoadout( ply, delay )
end

local WeaponDefaults = {
	"weapon_toyhammer",
	"weapon_bouncynade",
	"weapon_semiauto",
	"weapon_supershotty",
	"weapon_thompson"
}

function PopulateLoadout( ply, delay )
	if !IsValid( ply ) then return end

	timer.Simple( delay, function()
		if IsValid( ply ) then
			if ply.WeaponList == nil then
				if table.IsEmpty( PVPBattle.GiveWeapons( ply ) ) then
					ply.WeaponList = WeaponDefaults
				else
					ply.WeaponList = PVPBattle.GiveWeapons( ply )
				end
			end

			for k,v in pairs( ply.WeaponList ) do
				ply:Give(v)
			end
		end
	end )
end

function GM:PlayerHurt( ply )
	PostEvent( ply, "pdamage" )
end

function GM:EntityTakeDamage( ent, dmginfo )
	local attacker = dmginfo:GetAttacker()
	local inflictor = dmginfo:GetInflictor()
	local amount = dmginfo:GetDamage()
	local attacker = dmginfo:GetAttacker()

	if ent:IsPlayer() && dmginfo:IsFallDamage() then
		dmginfo:ScaleDamage( 0 )
	end
	if ent && ent:IsValid() && ent:IsPlayer() then

		SendDeathNote( attacker, ent, amount, false )

		local CurWeapon = ent:GetActiveWeapon()
		if IsValid( CurWeapon ) && CurWeapon:GetClass() == "weapon_sword" then
			ent:EmitSound("GModTower/pvpbattle/Sword/SwordVHurt" .. math.random( 1, 2 ) .. ".wav")
		end
	end
end

function SendDeathNote( attacker, ent, amount, death )
	if attacker == ent then return end
	if not IsValid( attacker ) and not attacker:IsPlayer() then return end

	net.Start( "DamageNotes" )
		net.WriteFloat( math.Round( amount ) )
		net.WriteVector( util.GetCenterPos( ent ) + ( VectorRand() * 5 ) )
		if death && !ent:Alive() then
			net.WriteInt( 1, 3 )
		elseif attacker.IsPulp then
			net.WriteInt( 2, 3 )
		else
			net.WriteInt( 0, 3)
		end
	net.Send( attacker )
end

function GM:PlayerTraceAttack( ply, dmginfo, dir, tr )
	ply.HackerLastGroup = tr.HitGroup
end

function CustomDeath( Victim, Inflictor, Attacker, Type )
	local weapon
	local PVPVictim
	local PVPAttacker

	if IsValid( Victim ) && !Victim:IsPlayer() then return end

	if IsValid ( Attacker ) && IsValid( Victim ) then
		if Attacker == Victim then
			PVPVictim = Victim
			PVPAttacker = Victim
			if Type != 64 && Type != 6144 then
				weapon = "fall"
			end
		else
			PVPVictim = Attacker
			PVPAttacker = Victim
			if IsValid( Attacker:GetActiveWeapon() ) then
				if ( IsValid( Attacker.ThrownWeapon ) ) then
					weapon = Attacker.ThrownWeapon:GetClass()
				else
					weapon = Attacker:GetActiveWeapon():GetClass()
				end
			end
		end
		
		if !Victim:Alive() then
			net.Start( "CustomDeath" )
				net.WriteEntity( PVPVictim )
				net.WriteString( weapon || Inflictor:GetName() )
				net.WriteEntity( PVPAttacker )
			net.Broadcast()
		end
	end
end

function GM:PlayerDeath( Victim, Inflictor, Attacker )
	if IsValid( Inflictor ) && Inflictor:GetClass() == "pvp_babynade" then
		Inflictor.Kills = ( Inflictor.Kills or 0 ) + 1
		if Inflictor.Kills == 2 && IsValid( Attacker ) then
			Attacker:AddAchievement( ACHIEVEMENTS.PVPFAMILY, 1 )
		end
	end

	if IsValid(Inflictor) && Inflictor:GetClass() == "pvp_babynade" && IsValid(Attacker) && Attacker:IsPlayer() && string.StartWith( game.GetMap(), "gmt_pvp_aether" ) then
		Attacker:AddAchievement( ACHIEVEMENTS.PVPMAFIA, 1 )
	end

	if ( IsValid(Attacker) && !Attacker:IsPlayer() && IsValid(Attacker:GetOwner()) ) then
		Inflictor = Attacker
		Attacker = Attacker:GetOwner()
	end

	if ( ( IsValid(Attacker) && Attacker:IsPlayer() ) && ( IsValid(Victim) && Victim:IsPlayer() ) ) then
		SendDeathNote( Attacker, Victim, 0, true )
	end

	Victim.RespawnTimer = 3 + CurTime()
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	ply:CreateRagdoll()
	if ply:GetNet("PowerUp") > 0 then ply:SetNet("PowerUp", CurTime() - 1) end

	ply:AddDeaths( 1 )
	ply._TheKid = 0

	if IsValid( attacker ) && !self:IsRoundOver() then
		if attacker == ply then
			attacker:AddFrags( -1 )
		else
			if ply.HackerLastGroup == HITGROUP_HEAD then
				if IsValid( attacker ) && attacker:IsPlayer() then

					attacker:AddAchievement( ACHIEVEMENTS.PVPTRUEHACKER, 1 )
					attacker._HackerAmt = attacker._HackerAmt + 1

					if attacker._HackerAmt >= 10 then
						attacker:SetAchievement( ACHIEVEMENTS.PVPHACKER, 1 )
					end

				end

				local rp = RecipientFilter()

				rp:AddPlayer( attacker )
				rp:AddPlayer( ply )

				net.Start( "hacker" )
					net.WriteEntity( attacker )
				net.Send( rp )
			end

			if ( ply:GetNWFloat("TauntTime") > CurTime() ) then
				ply:SetAchievement( ACHIEVEMENTS.PVPBOXFAIL, 1 )
			end
			
			ply.HackerLastGroup = HITGROUP_GENERIC

			if IsValid( attacker ) && !attacker:IsPlayer() && IsValid(attacker:GetOwner()) then
				attacker = attacker:GetOwner()
			end

			if IsValid( attacker ) && attacker:IsPlayer() then
				attacker:AddFrags( 1 )
				attacker:AddAchievement( ACHIEVEMENTS.PVPOVERKILL , 1 )

				if attacker:GetNet("PowerUp") > 0 then
					attacker:AddAchievement( ACHIEVEMENTS.PVPMILESTONE2, 1 )
				end

				local dist = attacker:GetPos():Distance( ply:GetPos() )
				if dist >= 2400 then
					attacker:SetAchievement( ACHIEVEMENTS.PVPEAGLEEYE, 1 )
				end

				if IsValid( attacker:GetActiveWeapon() ) then
					local weapon = attacker:GetActiveWeapon():GetClass()

					if weapon == "weapon_neszapper" then
						attacker:AddAchievement( ACHIEVEMENTS.PVPDAMNEDDOG, 1 )
					elseif weapon == "weapon_stealthpistol" then
						if attacker:GetNWBool("Cloaked") then
							attacker._Camper = attacker._Camper + 1
							
							if attacker._Camper >= 5 then
								attacker:SetAchievement( ACHIEVEMENTS.PVPCAMPER, 1 )
								attacker._Camper = 0
							end
						end
					elseif weapon == "weapon_akimbo" then
						attacker:AddAchievement( ACHIEVEMENTS.PVP12SHOTS, 1 )
					elseif weapon == "weapon_ragingbull" then
						attacker._TheKid = attacker._TheKid + 1
						print(attacker._TheKid)

						if attacker._TheKid >= 10 then
							attacker:SetAchievement( ACHIEVEMENTS.PVPTHEKID, 1 )
							attacker._TheKid = 0
						end
					elseif weapon == "weapon_toyhammer" then
						if attacker._LaserOn then
							attacker:SetAchievement( ACHIEVEMENTS.PVPLAZOR, 1 )
						end
					elseif weapon == "weapon_patriot" then
						if game.GetMap() == "gmt_pvp_meadow01" then
							attacker:AddAchievement( ACHIEVEMENTS.PVPBIGBOSS, 1 )
						end
					end
				end
			elseif IsValid( attacker:GetOwner() ) then
				attacker:GetOwner():AddFrags( 1 )
				attacker:GetOwner():AddAchievement( ACHIEVEMENTS.PVPOVERKILL , 1 )
			else
				ErrorNoHalt("Unhandled attacker " .. tostring(attacker) .. " owner: " .. tostring(attacker:GetOwner()))
			end
		end
	end
	local Type = dmginfo:GetDamageType()
	CustomDeath( ply, dmginfo:GetInflictor(), dmginfo:GetAttacker(), Type )
end

function GM:PlayerDeathSound( )
	return true
end

function GM:CanPlayerSuicide( ply )
  return ply:IsAdmin()
end

function GM:StartRound()
	if self:GetRoundCount() > self.MaxRoundsPerGame then
		return
	end

	self:CleanUpMap( false )

	self:SetTime( self.DefaultRoundTime )
	globalnet.SetNet( "RoundOver", false )

	local plys = player.GetAll()
	for _, ply in ipairs( plys ) do
		ply:Freeze( false )

		//Set scores.
		ply:SetFrags( 0 )
		ply:SetDeaths( 0 )

		ply:StripWeapons()
		ply:RemoveAllAmmo()

		ply:Spawn()
	end

	local rp = RecipientFilter()
	rp:AddAllPlayers()

	net.Start( "PVPRound" )
		net.WriteBool( false )
	net.Send( rp )

	music.Play( 1, 1 )

	FixMarsExploit()

	/*net.Start( "ToggleMusic" )
	net.WriteBool( true )
	net.Send( rp )*/

end

function GM:EndRound()
	self:SetTime( 10 )
	globalnet.SetNet( "RoundOver", true )

	local plys = player.GetAll()
	for _, ply in ipairs( plys ) do
		if ply:GetNet("PowerUp") > 0 then ply:SetNet("PowerUp", CurTime() - 1) end
		ply:Freeze( true )
		ply._Camper = 0
		ply._TheKid = 0
		ply:AddAchievement( ACHIEVEMENTS.PVPVETERAN, 1 )
		ply:AddAchievement( ACHIEVEMENTS.PVPMILESTONE1, 1 )
	end

	local rp = RecipientFilter()
	rp:AddAllPlayers()

	net.Start( "PVPRound" )
		net.WriteBool( true )
	net.Send( rp )
end

function GM:PlayerSwitchFlashlight( ply, on )
	if ply:IsAdmin() then
		return
	end

	if on == true then
		return false
	end

end

hook.Add( "PlayerDisconnected", "PlayerPopulationCheck", function( ply )
	timer.Simple(0.2, function()
		if ( GAMEMODE:GetRoundCount() > 0 && #player.GetAll() == 0 ) then
			GAMEMODE:EndServer()
			return
		end
	end)
end)

hook.Add("AllowSpecialAdmin", "DisalowGodmode", function()
	return false
end)

// no anti-tranquility on gamemodes
hook.Add( "AntiTranqEnable", "GamemodeAntiTranq", function() return false end )

concommand.Add("gmt_pvpgiveweapons", function( ply, cmd, args )

	if !ply:IsAdmin() then
		return
	end

	local Input = tonumber( args[1] )
	local Message = ""

	if !Input then
		GAMEMODE.GiveAllWeapons = !GAMEMODE.GiveAllWeapons
	else
		GAMEMODE.GiveAllWeapons = tobool( GAMEMODE.GiveAllWeapons )
	end

	if GAMEMODE.GiveAllWeapons then
		Message = "All weapons has been turned ON."
	else
		Message = "All weapons has been turned OFF."
	end

	for _, v in pairs( player.GetAll() ) do
		v:Msg2( Message )
	end

end )

util.AddNetworkString("hacker")
util.AddNetworkString("ToggleMusic")
util.AddNetworkString("PVPRound")
util.AddNetworkString("DamageNotes")
util.AddNetworkString("CustomDeath")
--util.AddNetworkString("PlayerTelefragged")
--util.AddNetworkString("PlayerFell")
