AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_deathnotice.lua" )
AddCSLuaFile( "cl_post_events.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )
include( "player.lua" )

CreateConVar("gmt_srvid", 5 )

util.AddNetworkString("DamageNotes")

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

local function FixMarsExploit()
	if game.GetMap() == "gmt_pvp_mars" then
		local trigger = ents.Create("trigger_luadeath")
		trigger:SetPos(Vector(0,0,0))
		trigger:Spawn()
	end
end

hook.Add("InitPostEntity","MarsExploitFix",function()
	FixMarsExploit()
end)

function GM:BeginGame()
	SetGlobalFloat( "PVPRoundTime", self.DefaultRoundTime + CurTime() )
	SetGlobalBool( "PVPRoundOver", false )
	SetGlobalInt( "PVPRoundCount", 1 )

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
			hook.Call("StartRound", self )
		else
			hook.Call("EndRound", self )
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
		timer.Simple(2.5,function()
			music.Play( 1, 1, ply )
		end)
	end
	
	// Indexes Player Weapons
	ply.PlayerWeapons = PvpBattle:GiveWeapons( ply )

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

	self:PlayerResetSpeed( ply )
end

function GM:PlayerResetSpeed( ply )
	ply:SetWalkSpeed( 450 )
	ply:SetRunSpeed( 450 )
end

function GM:PlayerLoadout( ply )
	if self.GiveAllWeapons == true  || ply:IsBot() then
		for _, v in ipairs( self.Weapons ) do
			ply:Give( v )
		end
	end

	self:GivePVPWeapons(ply)

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

	local WeaponList = ply.PlayerWeapons

	local function GiveDefaults(ply)
		ply:Give("weapon_toyhammer")
		ply:Give("weapon_bouncynade")
		ply:Give("weapon_semiauto")
		ply:Give("weapon_supershotty")
		ply:Give("weapon_thompson")
	end

	if WeaponList then
		local Count = #WeaponList
		if Count > 0 then
			ply:StripWeapons()
			for k,v in pairs(WeaponList) do
				v:Give(v)
			end
		else
			GiveDefaults(ply)
		end
	else
		GiveDefaults(ply)
	end

	return WeaponList

end

hook.Add("SQLConnect", "GiveLateWeapons", function( ply )
	if ply.NeedLateWeapons == true then
		GAMEMODE:GivePVPWeapons( ply )
	end
end )

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

		SendDeathNote( attacker, ent, amount )

		local CurWeapon = ent:GetActiveWeapon()
		if IsValid( CurWeapon ) && CurWeapon:GetClass() == "weapon_sword" then
			ent:EmitSound("GModTower/pvpbattle/Sword/SwordVHurt" .. math.random( 1, 2 ) .. ".wav")
		end
	end
end

function SendDeathNote(attacker,ent,amount,death)

	if attacker == ent then return end
	if !IsValid( attacker ) && !attacker:IsPlayer() then return end

	net.Start("DamageNotes")
		net.WriteFloat(math.Round(amount))
		net.WriteVector(util.GetCenterPos(ent) + (VectorRand() * 5))
		if death then
			net.WriteInt(1,3)
		elseif attacker.IsPulp then
			net.WriteInt(2,3)
		end
	net.Send(attacker)
end

function GM:PlayerTraceAttack( ply, dmginfo, dir, tr )
	ply.HackerLastGroup = tr.HitGroup
end

function GM:PlayerDeath( Victim, Inflictor, Attacker )

	if IsValid(Inflictor) && Inflictor:GetClass() == "pvp_babynade" then
		Inflictor.Kills = (Inflictor.Kills or 0) + 1
		if Inflictor.Kills == 2 && IsValid(Attacker) then
			Attacker:AddAchievement( ACHIEVEMENTS.PVPFAMILY, 1 )
		end
	end

	if IsValid(Inflictor) && Inflictor:GetClass() == "pvp_babynade" && IsValid(Attacker) && Attacker:IsPlayer() && string.StartWith( game.GetMap(), "gmt_pvp_aether" ) then
		Attacker:AddAchievement( ACHIEVEMENTS.PVPMAFIA, 1 )
	end

	if IsValid(Attacker) && Attacker:IsPlayer() && IsValid(Victim) && Victim:IsPlayer() then
		SendDeathNote(Attacker, Victim, 0, true)
	end

	if IsValid(Attacker) && !Attacker:IsPlayer() && IsValid(Attacker:GetOwner()) then
		Inflictor = Attacker
		Attacker = Attacker:GetOwner()
	end

	self.BaseClass.PlayerDeath( self, Victim, Inflictor, Attacker )
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	ply:CreateRagdoll()
	if ply.PowerUp > 0 then ply.PowerUp = CurTime() - 1 end

	ply:AddDeaths( 1 )
	ply._TheKid = 0

	if IsValid(attacker) && !self:IsRoundOver() then
		if attacker == ply then
			attacker:AddFrags( -1 )
		else
			if ply.HackerLastGroup == HITGROUP_HEAD then
				if IsValid(attacker) && attacker:IsPlayer() then

					attacker:AddAchievement( ACHIEVEMENTS.PVPTRUEHACKER, 1 )
					attacker._HackerAmt = attacker._HackerAmt + 1

					if attacker._HackerAmt >= 10 then
						attacker:SetAchievement( ACHIEVEMENTS.PVPHACKER, 1 )
					end

				end

				local rp = RecipientFilter()

				rp:AddPlayer(attacker)
				rp:AddPlayer(ply)

				net.Start("hacker")
					net.WritePlayer( attacker )
				net.Send(rp)
			end

			ply.HackerLastGroup = HITGROUP_GENERIC

			if IsValid(attacker) && !attacker:IsPlayer() && IsValid(attacker:GetOwner()) then
				attacker = attacker:GetOwner()
			end

			if IsValid( attacker ) && attacker:IsPlayer() then
				attacker:AddFrags( 1 )
				attacker:AddAchievement( ACHIEVEMENTS.PVPOVERKILL , 1 )

				if attacker.IsTakeOn then
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
						attacker:EmitSound( Sound("gmodtower/pvpbattle/neszapper/neskill.wav"), 80 )

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

					elseif weapon == "weapon_pulsesmartpen" then

						attacker:EmitSound( "gmodtower/pvpbattle/pulsesmartpen/yougotthat"..math.random(1,3)..".wav", 80 )

					elseif weapon == "weapon_sword" then

						attacker:EmitSound( Sound("gmodtower/pvpbattle/sword/swordvdeath.wav"), 80 )

					elseif weapon == "weapon_patriot" then

						attacker:EmitSound( Sound("gmodtower/pvpbattle/patriot/patriotkill.wav"), 80 )

						if game.GetMap() == "gmt_pvp_meadow01" then
							attacker:AddAchievement( ACHIEVEMENT.PVPBIGBOSS, 1 )
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

	if IsValid(ply) && IsValid(ply:GetActiveWeapon()) then
		if ply:GetActiveWeapon():GetClass() == "weapon_sword" then
			ply:EmitSound( Sound("GModTower/pvpbattle/Sword/SwordVDeath.wav") )
		end
	end

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

	game.CleanUpMap(false, {"gmt_cosmeticbase", "gmt_hat"})

	SetGlobalFloat( "PVPRoundTime", self.DefaultRoundTime + CurTime() )
	SetGlobalBool( "PVPRoundOver", false )

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
	SetGlobalFloat( "PVPRoundTime", 10 + CurTime() )
	SetGlobalBool( "PVPRoundOver", true )


	local plys = player.GetAll()
	for _, ply in ipairs( plys ) do
		if ply.PowerUp > 0 then ply.PowerUp = CurTime() - 1 end
		ply:Freeze( true )
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
		if ( GAMEMODE:GetRoundCount() > 0 && #player.GetAll() == 0) then
			GAMEMODE:EndServer()
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
