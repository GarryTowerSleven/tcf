AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_load.lua")
AddCSLuaFile("sh_loadables.lua")

// dotenv
require("dotenv")
env.load(".env")

include("shared.lua")
include("sh_load.lua")
include("sh_loadables.lua")

RunConsoleCommand("sv_hibernate_think", "1")

// Base Content
resource.AddWorkshop( 2947436186 ) -- Base
resource.AddWorkshop( 2947437306 ) -- Lobby
resource.AddWorkshop( 2947438865 ) -- Ballrace
resource.AddWorkshop( 2947439169 ) -- Chimera
resource.AddWorkshop( 2947439518 ) -- Minigolf
resource.AddWorkshop( 2947440075 ) -- PVP Battle
resource.AddWorkshop( 2947440462 ) -- Source Karts
resource.AddWorkshop( 2947440760 ) -- Virus
resource.AddWorkshop( 2947441080 ) -- Zombie Massacre

// TCF Content
resource.AddWorkshop( 2952547939 ) -- TCF Base
resource.AddWorkshop( 2948325260 ) -- TCF Lobby
resource.AddWorkshop( 2952552769 ) -- TCF Ballrace
resource.AddWorkshop( 2956124164 ) -- TCF Minigolf
resource.AddWorkshop( 2956124349 ) -- TCF PVP Battle
resource.AddWorkshop( 3111819031 ) -- TCF UCH

// BACKUP
/* THIS IS NOT UP TO DATE
resource.AddWorkshop( 2949539663 ) -- Base
resource.AddWorkshop( 2949540184 ) -- Lobby
resource.AddWorkshop( 2949541045 ) -- Ballrace
resource.AddWorkshop( 2949541208 ) -- Chimera
resource.AddWorkshop( 2949541468 ) -- Minigolf
resource.AddWorkshop( 2949541746 ) -- PVP Battle
resource.AddWorkshop( 2949542051 ) -- Source Karts
resource.AddWorkshop( 2949542425 ) -- Virus
resource.AddWorkshop( 2949542574 ) -- Zombie Massacre

resource.AddWorkshop( 2957302618 ) -- TCF Base
resource.AddWorkshop( 2949543296 ) -- TCF Lobby
resource.AddWorkshop( 2957302660 ) -- TCF Ballrace
resource.AddWorkshop( 2957302833 ) -- TCF Minigolf
resource.AddWorkshop( 2957302861 ) -- TCF PVP Battle
resource.AddWorkshop( 3111790286 ) -- TCF UCH
*/

local CurrentGamemode = engine.ActiveGamemode()

hook.Add( "PlayerSpawn", "SetGMTPlayerClass", function( ply )
	if ( IsLobby ) then return end
    player_manager.SetPlayerClass( ply, "player_gmt" )
end )

// Lua Refresh Notification
if ( _LUAREFRESH && GTowerChat ) then
	GTowerChat.AddChat( "Lua refreshed.", Color( 255, 255, 0 ), "Server" )
end
_LUAREFRESH = true

MultiUsers = MultiUsers or {}

local aumsg = umsg.Start
local bumsg = umsg.End
local s = false
local LastTraceBack = ""
local startedumsg = ""

umsg.Start = function(a, b)

	if s == true then
		bumsg()
		SQLLog("error", "Umsg started without ending! (" .. startedumsg .. ") ORIGINAL TRACEBACK: " .. LastTraceBack .. "\n END ORIGINAL TRACEBACK.\n\n")
	end

	startedumsg = a
	LastTraceBack = debug.traceback()

	aumsg(a, b)
	s = true
end


umsg.End = function()
	bumsg()
	startedumsg = ""
	s = false
end

hook.Add( "InitPostEntity", "AddTempBot", function()

	if GetConVarNumber("sv_voiceenable") != 1 then
		RunConsoleCommand("sv_voiceenable","1")
	end

	if game.SinglePlayer() then return end

	SQLLog("start", "Server start - ", game.GetMap() )

end )

concommand.Add( "gmt_bot", function( ply, _, args )
	if ply != NULL then return end

	local count = args[1] and tonumber( args[1] ) or 1

	for i=1, count do
		RunConsoleCommand("bot")
	end
end )

hook.Add( "CanPlayerUnfreeze", "GMTOnPhysgunReload", function( ply, ent, physObj )
	return ply:GetSetting( "GTAllowPhysGun" )
end )

function IsTester()
	return false
end

hook.Add( "CheckPassword", "GatekeeperCheck", function( steamID64, ipAddress, svPassword, clPassword, name )

	local steamid = util.SteamIDFrom64( steamID64 )

	if ( Admins.IsStaff( steamid ) ) then
		return true
	end

	if svPassword != "" then
		if clPassword == svPassword then
			return true
		end
	end

	if ( not IsLobby && CurrentGamemode != "gmthalloween" ) then
		local ip = string.Split( ipAddress, ":" )[1] or ipAddress

		print( ip, name, string.Split( ipAddress, ":" )[1], ipAddress )
	
		if MultiUsers[ ip ] != true then
			return false, "You must join from the lobby server, IP: join.gtower.net"
		end
	end

end )

function GetMaxSlots()

	local Slots = GetConVarNumber("sv_visiblemaxplayers")

	if Slots <= 1 then -- If MaxSlots is not set, just adjust it to the true maxplayers
		return game.MaxPlayers() -- MaxPlayers()
	end

	return Slots

end

timer.Remove( "HostNameThink" )
hook.Remove( "PlayerInitialSpawn", "PlayerAuthSpawn")

function GM:PlayerSetModel( ply )

	local modelinfo = string.Explode( "-", ply:GetInfo("gmt_playermodel") or "kleiner" )
	local modelname = modelinfo[1]
	local modelskin = tonumber( modelinfo[2] or 0 ) or 0
	
	if ( not GTowerModels.CanUseModel( ply, modelname, modelskin ) ) then
		modelname = nil
		modelskin = 0
	end
	
	local model = player_manager.TranslatePlayerModel(modelname)
	
	ply:SetModel(model)
	ply:SetSkin(modelskin)

	GTowerModels.Set( ply )

	hook.Call( "PlayerSetModelPost", GAMEMODE, ply, model, modelskin )

end

hook.Add( "PlayerSpawn", "FixHats", function( ply )
	ply:ReParentCosmetics()
end )

hook.Add( "PlayerSpawn", "Machinima", function( ply )
	if ply:GetSetting(30) and not IsLobby then
		MACHINIMA = true
	end
end )