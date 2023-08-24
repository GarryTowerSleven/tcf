PRIVATE_TEST_MODE = false

util.AddNetworkString("AdminMessage")
util.AddNetworkString("gmt_gamemodestart")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("cl_playermenu.lua")

AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_post_events.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("cl_webboard.lua")
AddCSLuaFile("cl_hudchat.lua")
AddCSLuaFile("milestones/uch_animations.lua")

AddCSLuaFile("cl_tetris.lua")

AddCSLuaFile("minigames/shared.lua")

include("milestones/uch_animations.lua")
include("shared.lua")
include("sv_tetris.lua")
include("tetris/highscore.lua")
include("mapchange.lua")
include("sv_hwevent.lua")
include("minigames/init.lua")

AddCSLuaFile("event/cl_init.lua")
include("event/init.lua")


include( "animation.lua" ) // for gmt_force* commands
//include( "interaction.lua" )

//game.ConsoleCommand("sv_password peoplearefun\n")

CreateConVar("gmt_srvid", 99 )

--[[ Check if they can join

GM.AllowedList = {}
GM.AllowedList["STEAM_0:0:71992617"] = true
GM.AllowedList["STEAM_0:0:44458854"] = true
GM.AllowedList["STEAM_0:1:39916544"] = true
GM.AllowedList["STEAM_0:1:24463799"] = true
GM.AllowedList["STEAM_0:0:156132358"] = true
GM.AllowedList["STEAM_0:0:63281019"] = true
GM.AllowedList["STEAM_0:1:61911698"] = true
GM.AllowedList["STEAM_0:1:117410706"] = true
GM.AllowedList["STEAM_0:1:124798129"] = true
GM.AllowedList["STEAM_0:1:44119258"] = true
GM.AllowedList["STEAM_0:1:4313984"] = true
GM.AllowedList["STEAM_0:1:97372299"] = true
GM.AllowedList["STEAM_0:1:457668257"] = true
GM.AllowedList["STEAM_0:1:50147143"] = true
--]]
util.AddNetworkString("MultiserverJoinRemove")
--[[ Not needed right now.
timer.Create("gmt_timer_private",(60*2),0,function()
	if !PRIVATE_TEST_MODE then timer.Destroy("gmt_timer_private") return end
	MsgC( Color( 125, 255, 125 ), "GMTD IS IN PRIVATE MODE, SET PRIVATE_TEST_MODE TO FALSE IN GMTLOBBY/INIT.LUA:2\n" )
end)
--]]

function GM:PlayerSpawn( pl )

	player_manager.SetPlayerClass( pl, "player_lobby" )
	player_manager.OnPlayerSpawn( pl )
	player_manager.RunClass( pl, "Spawn" )

	pl:SetTeam(1)
	local col = pl:GetInfo( "cl_playercolor" )
	pl:SetPlayerColor( Vector( col ) )
	pl:SetCustomCollisionCheck(true)
	//pl:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	pl:SetNoCollideWithTeammates(true)

	-- Set player model
	hook.Call( "PlayerSetModel", GAMEMODE, pl )

end

function GM:CheckPassword(steam, IP, sv_pass, cl_pass, name)
	local steam64 = steam
	local steam = util.SteamIDFrom64(steam)

	if IsAdmin(steam) or IsTester(steam64) or !PRIVATE_TEST_MODE then
		return true
	else
		MsgC(Color(51, 204, 51),name.." <"..steam.."> ("..IP..") tried to join the server.\n")
		return false, "fail..."
	end

	return true
end

hook.Add("PlayerSpawn","UCHMilestoneFix", function(ply)

	local list = ply:GetEquipedItems()

	SpawnPlayerUCH(ply, list)

end)

function SpawnPlayerUCH(ply, list)

	if list == nil then
		timer.Simple(1, function() SpawnPlayerUCH(ply,ply:GetEquipedItems()) end)
		return
	end

	for k, v in pairs( list ) do

		if v.Name == "Pigmask" then

			timer.Simple(0.5, function()
				UCHAnim.SetupPlayer( ply, UCHAnim.TYPE_PIG )
			end)

		elseif v.Name == "Ghost" then
			timer.Simple(0.5, function()
				UCHAnim.SetupPlayer( ply, UCHAnim.TYPE_GHOST )
			end)
		end

	end
end

function GM:PlayerLoadout( pl )
	return true
end

function GM:IsSpawnpointSuitable( ply, spawnpointent, bMakeSuitable )

	return true

end

local dons = {
	Vector(2056.412842, 1261.577637, 208.463181),
	Vector(2152.033203, 1261.568970, 208.448746),
	Vector(2247.797119, 1261.497437, 208.449326),
	Vector(2344.245117, 1261.497314, 208.493423),
	Vector(2440.292480, 1261.500366, 208.499008),
	Vector(2535.299561, 1261.316650, 208.340546),
	Vector(2631.354004, 1261.499268, 208.453522),
}


concommand.Add("gmt_disco",function(ply)
	if !ply:IsAdmin() then return end

	if ply:GetNWBool("IsDisco") then
		if timer.Exists("DiscoTimer") then
			timer.Destroy("DiscoTimer")
			ply:SetNWBool("IsDisco",false)
			return
		end
	end

	ply:SetNWBool("IsDisco",true)

	local red = Vector(1000000000,0,0)
	local green = Vector(0,1000000000,0)
	local blue = Vector(0,0,1000000000)

	ply:SetPlayerColor(red)

	timer.Create("DiscoTimer",0.25,0,function()
		if !IsValid(ply) then timer.Destroy("DiscoTimer") end

		if ply:GetPlayerColor() == red then
			ply:SetPlayerColor(green)
		elseif ply:GetPlayerColor() == green then
			ply:SetPlayerColor(blue)
		elseif ply:GetPlayerColor() == blue then
			ply:SetPlayerColor(red)
		end

	end)

end)

function AdminNotify(str)
	net.Start("AdminMessage")
	net.WriteEntity(nil)
	net.WriteString(str)
	net.Broadcast()
end

concommand.Add("gmt_adminmessage",function(ply, cmd, args, str)

	if !ply:IsAdmin() then return end

	net.Start("AdminMessage")
		net.WriteEntity(ply)
		net.WriteString(str)
	net.Broadcast()

end)

concommand.Add("remove_ent",function(ply,cmd,args,str)

	if !ply:IsAdmin() then return end

	for k,v in pairs(ents.GetAll()) do
		if v:GetClass() == str then
			v:Remove()
		end
	end

end)

concommand.Add("gmt_rc_boat",function(ply)

	if !ply:IsAdmin() then return end

	local obj = ents.Create("gmt_rc_boat")
	obj:SetPos(ply:GetEyeTrace().HitPos)
	obj:Spawn()


end)

concommand.Add("gmt_bigheads",function(ply)

	if !ply:IsAdmin() then return end

	for k,v in pairs(player.GetAll()) do
		local Head = v:LookupBone("ValveBiped.Bip01_Head1")
		v:ManipulateBoneScale(Head,Vector(5,5,5))
	end

end)

concommand.Add("gmt_chimera",function(ply)

	if !ply:IsAdmin() then return end

	ply:SetModel( "models/UCH/uchimeraGM.mdl" )
	ply:SetSkin( 0 )
	ply:SetBodygroup( 1, 1 )

	ply:SetWalkSpeed(100)
	ply:SetRunSpeed(250)

	ply:EmitSound("uch/music/endround/pigs_lose.mp3")

end)

concommand.Add("gmt_trex",function(ply)

	if !ply:IsAdmin() then return end

	ply:SetModel( "models/dinosaurs/trex.mdl" )
	ply:SetSkin( 0 )
	ply:SetBodygroup( 1, 1 )

end)

concommand.Add("gmt_dog",function(ply)

	if !ply:IsAdmin() then return end

	ply:SetModel( "models/zom/dog.mdl" )
	ply:SetSkin( 0 )
	ply:SetBodygroup( 1, 1 )

end)

concommand.Add("gmt_setalldog",function(ply)

	if !ply:IsAdmin() then return end

	for k,v in pairs(player.GetAll()) do
		v:SetModel( "models/zom/dog.mdl" )
		v:SetSkin( 0 )
		v:SetBodygroup( 1, 1 )
	end

end)

concommand.Add("gmt_spider",function(ply)

	if !ply:IsAdmin() then return end

	ply:SetModel( "models/npc/spider_regular/npc_spider_regular.mdl" )
	ply:SetSkin( 0 )
	ply:SetBodygroup( 1, 1 )

end)

concommand.Add("gmt_spiderbig",function(ply)

	if !ply:IsAdmin() then return end

	ply:SetModel( "models/npc/spider_monster/npc_spider_monster.mdl" )
	ply:SetSkin( 0 )
	ply:SetBodygroup( 1, 1 )

end)

concommand.Add("gmt_salsa",function(ply)
	if ply:IsAdmin() and ply:GetModel() == "models/uch/uchimeragm.mdl" then
		ply:EmitSound("uch/music/endround/salsa.mp3")
		timer.Create("ConfettiSalsa",0.25,70,function()
			local vPoint = ply:GetPos()
			local effectdata = EffectData()
			effectdata:SetOrigin( vPoint )
			util.Effect( "confetti", effectdata )
		end)
	end
end)

hook.Add("PlayerFootstep","ChimeraSteps",function(ply)

	if ply:IsAdmin() and ply:GetModel() == "models/uch/uchimeragm.mdl" then
		ply:EmitSound( "UCH/chimera/step.wav", 82, math.random( 94, 105 ))
		util.ScreenShake( ply:GetPos(), 5, 5, .5, ( 450 * 1.85 ) )
		return true
	end

end)

hook.Add( "KeyPress", "Bite", function( ply, key )

	if ply:IsAdmin() and ply:GetModel() == "models/uch/uchimeragm.mdl" and ply:Alive() then
		if ( key == IN_ATTACK ) then
			Bite(ply)
		end
	end

end )

function FindThingsToBite(ply)

	local tbl = {}

	local pos = ply:GetShootPos()
	local fwd = ply:GetForward()

	local function playerGetAllMinus( ent )

		local tbl = {}

		for k, v in pairs( player.GetAll() ) do
			if v != ent then
				table.insert( tbl, v )
			end
		end

		return tbl

	end

	fwd.z = 0
	fwd:Normalize()
	local vec = ( ( pos + Vector( 0, 0, -16 ) ) + ( fwd * 60 ) )
	local rad = 70

	debugoverlay.Sphere( vec, rad )
	for k, v in pairs( ents.FindInSphere( vec, rad ) ) do

		if v:IsPlayer() then

			local pos = ply:GetShootPos()
			local epos = v:IsPlayer() && v:GetShootPos() || v:GetPos()
			local tr = util.QuickTrace( pos, (epos - pos ) * 10000, playerGetAllMinus( v ) )
			debugoverlay.Line( pos, tr.HitPos, 3, Color( 255, 0, 0 ) )

			if IsValid( tr.Entity ) && tr.Entity == v then
				table.insert( tbl, v )
			end

		end

	end

	return tbl

end

function Bite(ply)
	if timeout then return end
	Animation.PlayAnim( ply, ACT_MELEE_ATTACK1 )
	local timeout = true
	ply:Freeze(true)
	ply:EmitSound( "UCH/chimera/bite.mp3", 80, math.random( 94, 105 ) )
	timer.Simple(0.75,function() timeout = false ply:Freeze(false) end)

	local tbl = FindThingsToBite(ply)
	if #tbl >= 1 then
		for k, v in pairs( tbl ) do
			if v:IsPlayer() then
				v:Freeze( true )
			end
			timer.Simple( .32, function()
				if IsValid( ply ) && IsValid( v ) then
					v:Kill()
					v:EmitSound("uch/pigs/die.wav")
					ply:EmitSound("uch/music/roundtimer_add.wav")
				end
			end )
		end
	end

end

concommand.Add( "gmt_enablegod", function( ply, cmd, args )

	local val = tonumber( args[1] ) or 0

	if val == 1 then
		ply.IsGodMode = true
	else
		ply.IsGodMode = false
	end

end )

/*hook.Add("PlayerInitialSpawn", "PlayerGod", function(ply)

	ply.IsGodMode = true

end)*/

function GM:EntityTakeDamage( ent, dmginfo  )

	if ent:IsNPC() then
		dmginfo:ScaleDamage( 0.0 )
	end

	if ent:IsPlayer() && ent.IsGodMode then //why this? because we want to be able to override it if needed
		dmginfo:ScaleDamage( 0.0 )
	end

end

concommand.Add("toss", function(ply, cmd, args)
		if !ply:IsAdmin() or (ply.NextToss and CurTime() < ply.NextToss) then return end

		ply.NextToss = CurTime() + .5

		local num = math.Clamp(tonumber(args[1]) or 1, 1, 10)

		for i = 1,num do
			local eye = ply:EyeAngles()

			local aim = eye - Angle(30, 0, 0)
			local aimforward = aim:Forward()

			local trace = util.TraceLine({start=ply:GetShootPos(), endpos=ply:GetShootPos() + ply:GetAimVector() * 30, filter=ply})
			local start = trace.HitPos - (aimforward * num * 5) - (aimforward * 10)

			local corn = ents.Create("candycorn")

			if i > 1 then
				local offset = eye:Up() * math.random(-15,15) + eye:Right() * math.random(-15, 15) + (aimforward * i * 5)
				corn:SetPos(start + offset)
			else
				corn:SetPos(start)
			end

			corn:SetAngles(VectorRand():Angle())
			corn:Spawn()

			local phys = corn:GetPhysicsObject()
			if IsValid(phys) then
				phys:Wake()
				phys:SetVelocity(aimforward * 300)
			end
		end
	end)

concommand.Add("morebeer", function(ply, cmd, args)
		if !ply:IsAdmin() or (ply.NextBeer and CurTime() < ply.NextBeer) then return end

		ply.NextBeer = CurTime() + .5

		local eye = ply:EyeAngles()

		local aim = eye - Angle(30, 0, 0)
		local aimforward = aim:Forward()

		local trace = util.GetPlayerTrace(ply)
		trace = util.TraceLine(trace)

		local beer = ents.Create("alcohol_bottle")

		beer:SetPos(trace.HitPos)
		beer:Spawn()
		local phys = beer:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion(false)
		end
end)

concommand.Add("gmt_giveammo", function(ply, cmd, args) --Temporary fix.
	if !ply:IsAdmin() then return end
	
	ply:GiveAmmo( 50, "SMG1", true )
	ply:GiveAmmo( 50, "AR2", true )
	ply:GiveAmmo( 50, "AlyxGun", true )
	ply:GiveAmmo( 50, "Pistol", true )
	ply:GiveAmmo( 50, "SMG1", true )
	ply:GiveAmmo( 50, "357", true )
	ply:GiveAmmo( 50, "XBowBolt", true )
	ply:GiveAmmo( 50, "Buckshot", true )
	ply:GiveAmmo( 50, "RPG_Round", true )
	ply:GiveAmmo( 50, "SMG1_Grenade", true )
	ply:GiveAmmo( 50, "SniperRound", true )
	ply:GiveAmmo( 50, "SniperPenetratedRound", true )
	ply:GiveAmmo( 50, "Grenade", true )
	ply:GiveAmmo( 50, "Trumper", true )
	ply:GiveAmmo( 50, "Gravity", true )
	ply:GiveAmmo( 50, "Battery", true )
	ply:GiveAmmo( 50, "GaussEnergy", true )
	ply:GiveAmmo( 50, "CombineCannon", true )
	ply:GiveAmmo( 50, "AirboatGun", true )
	ply:GiveAmmo( 50, "StriderMinigun", true )
	ply:GiveAmmo( 50, "HelicopterGun", true )
	ply:GiveAmmo( 50, "AR2AltFire", true )
	ply:GiveAmmo( 50, "slam", true )
end)

hook.Add("PlayerSpawn", "PISCollisions", function(ply)
	--ply:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	ply:CrosshairDisable()
end)

// Flashlight

hook.Add( "PlayerSwitchFlashlight", "GMTFlashLight", function( ply, enabled )
	if ( ply:IsStaff() ) then return true end
	if ( Location.IsEquippablesNotAllowed( ply:Location() ) and enabled ) then return false end
	if ply._FlashlightTime and ply._FlashlightTime > CurTime() then return false end

	ply._FlashlightTime = CurTime() + 1

	return true
end )

hook.Add( "Location", "LocationChangeFlashlight", function( ply, loc )
	if ( not ply:IsStaff() and Location.IsEquippablesNotAllowed( loc ) ) then
		ply._FlashlightTime = CurTime()
		ply:Flashlight( false )
	end
end )

hook.Add("GTowerPhysgunPickup", "DisablePrivAdminPickup", function(pl, ent)
	if IsValid( ent ) then
		if ( ent:GetModel() == "models/gmod_tower/suite_bath.mdl" ) then return false end
		--if ( ent:GetClass() == "player" && ent:IsPrivAdmin() ) then return false end
	end
end)

hook.Add("PhysgunDrop", "ResetPISCollisions", function(pl, ent)
	if IsValid( ent ) && ent:GetClass() == "player"  then
		ent:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	end
end)

hook.Add( "Location", "KeepOut", function( ply, loc )

	if Location.Is( loc, "???" ) && !ply:GetNWBool( "InLimbo" ) then
		ply:SafeTeleport( Vector(1630, -3510, -190 ), nil, Angle(0, 180, 0) )
	end

 end )

// unused
/* 
hook.Add( "Location", "BWDev", function( ply, loc )

	if Location.Is( loc, "secret_hallway" ) || Location.Is( loc, "secret_devhq" ) then
		PostEvent( ply, "bw_on" )
	else
		PostEvent( ply, "bw_off" )
	end

 end )/*