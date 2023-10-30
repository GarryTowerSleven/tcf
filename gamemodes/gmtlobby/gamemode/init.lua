PRIVATE_TEST_MODE = false

util.AddNetworkString("AdminMessage")
util.AddNetworkString("gmt_gamemodestart")
util.AddNetworkString("MultiserverJoinRemove")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("cl_playermenu.lua")

AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_hud_old.lua")
AddCSLuaFile("cl_hud_lobby2.lua")

AddCSLuaFile("cl_post_events.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("cl_hudchat.lua")
AddCSLuaFile("milestones/uch_animations.lua")
AddCSLuaFile("milestones/virus_radar.lua")

AddCSLuaFile("cl_tetris.lua")

include("milestones/uch_animations.lua")
include("shared.lua")
include("tetris/highscore.lua")
include("mapchange.lua")
include("sv_tetris.lua")
include("sv_hwevent.lua")
include("sv_commands.lua")

-- AddCSLuaFile( "minigames_new/cl_init.lua" )
-- include( "minigames_new/init.lua" )

AddCSLuaFile("sh_events.lua")
include("sv_events.lua")
include("sh_events.lua")

include("animation.lua") -- for gmt_force* commands
--include( "interaction.lua" )

CreateConVar("gmt_srvid", 99 )

function GM:PlayerSpawn( ply )

	player_manager.SetPlayerClass( ply, "player_lobby" )
	player_manager.OnPlayerSpawn( ply )
	player_manager.RunClass( ply, "Spawn" )

	ply:SetTeam(1)

	local col = ply:GetInfo( "cl_playercolor" )
	ply:SetPlayerColor( Vector( col ) )
	ply:SetCustomCollisionCheck(true)
	ply:SetNoCollideWithTeammates(true)

	-- Set player model
	hook.Call( "PlayerSetModel", GAMEMODE, ply )

end

hook.Add( "PlayerSpawn", "UCHMilestoneFix", function(ply)
	local list = ply:GetEquipedItems()
	SpawnPlayerUCH( ply, list )
end )

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

function GM:PlayerLoadout( ply )
	return true
end

function GM:IsSpawnpointSuitable( ply, spawnpointent, bMakeSuitable )
	return true
end

function AdminNotify(str)
	net.Start("AdminMessage")
		net.WriteEntity(nil)
		net.WriteString(str)
	net.Broadcast()
end

local godignore = { -- What classnames should we ignore?
	["entityflame"] = true
}

function GM:PlayerShouldTakeDamage( ply, attacker )

	if not attacker:IsPlayer() then
		return godignore[ attacker:GetClass() ]
	end

	if Friends and ( Friends.IsBlocked( ply, attacker ) or Friends.IsBlocked( attacker, ply ) ) then
		return false
	end

	return false // attacker:IsAdmin()

end

hook.Add( "PlayerSpawn", "PISCollisions", function(ply)
	--ply:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	ply:CrosshairDisable()
end )

-- Flashlight
hook.Add( "PlayerSwitchFlashlight", "GMTFlashLight", function( ply, enabled )
	if ( ply:IsStaff() ) then return true end
	if ( Location.IsEquippablesNotAllowed( ply:Location() ) and enabled ) then return false end
	if ply._FlashlightTime and ply._FlashlightTime > CurTime() then return false end
	
	ply._FlashlightEnabled = enabled
	ply._FlashlightTime = CurTime() + 1

	return true
end )

hook.Add( "Location", "LocationChangeFlashlight", function( ply, loc )
	if ( not ply:IsStaff() and Location.IsEquippablesNotAllowed( loc ) and ply._FlashlightEnabled ) then
		ply._FlashlightTime = CurTime()
		ply:Flashlight( false )
	end
end )

hook.Add( "GTowerPhysgunPickup", "DisablePrivAdminPickup", function( ply, ent )
	if IsValid( ent ) then
		if ( ent:GetModel() == "models/gmod_tower/suite_bath.mdl" ) then return false end
	end
end )

hook.Add( "PhysgunDrop", "ResetPISCollisions", function( ply, ent )
	if IsValid( ent ) and ent:IsPlayer() then
		ent:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	end
end )

hook.Add( "Location", "KeepOut", function( ply, loc )
	if Location.Is( loc, "???" ) and not ply:GetNWBool( "InLimbo" ) then
		ply:SafeTeleport( Vector(1630, -3510, -190 ), nil, Angle(0, 180, 0) )
	end
end )

hook.Add( "EntityTakeDamage", "NoBurnDamage", function( ent, dmginfo )
	if ent:IsPlayer() and dmginfo:IsDamageType( DMG_BURN ) then
		dmginfo:SetDamage(0)
	end
end )
