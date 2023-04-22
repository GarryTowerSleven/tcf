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

// BACKUP
/*
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
*/

hook.Add( "PlayerSpawn", "SetGMTPlayerClass", function( ply )
	if ( IsLobby ) then return end
    player_manager.SetPlayerClass( ply, "player_gmt" )
end )

// Lua Refresh Notification
if ( _LUAREFRESH && GTowerChat ) then
	GTowerChat.AddChat( "Lua refreshed.", Color( 255, 255, 0 ), "Server" )
end
_LUAREFRESH = true

MultiUsers = {}

local aumsg = umsg.Start
local bumsg = umsg.End
local s = false
local LastTraceBack = ""
local startedumsg = ""

umsg.Start = function(a, b)

	if s == true then
		bumsg()
		SQLLog('error',"Umsg started without ending! (" .. startedumsg .. ") ORIGINAL TRACEBACK: " .. LastTraceBack .. "\n END ORIGINAL TRACEBACK.\n\n")
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

local DefaultPlayerModels = {}

function CatalogDefaultModels()
	for name, model in pairs( player_manager.AllValidModels() ) do
		if !GTowerModels.NormalModels[name] then

			if string.StartWith( name, "medic" ) || string.StartWith( name, "hostage" ) || string.StartWith( name, "dod_" ) then continue end
			if name == "kdedede_pm" or name == "bond" or name == "classygentleman" || name == "maskedbreen" or name == "windrunner" || name == "grayfox" then continue end
			table.insert( DefaultPlayerModels, model )

		end
	end
end

function GM:DefaultPlayerModel(model)
	return table.HasValue( DefaultPlayerModels, model )
end

hook.Add("InitPostEntity", "AddTempBot", function()

	CatalogDefaultModels()

	if GetConVarNumber("sv_voiceenable") != 1 then
		RunConsoleCommand("sv_voiceenable","1")
	end

	if game.SinglePlayer() then return end

	// Needed for multiservers to initialize, don't remove m8.
	RunConsoleCommand("bot")

	timer.Simple( 1.0, function()
		for _, v in pairs( player.GetAll() ) do
			if v:IsBot() then
				v:Kick("A bot")
			end
		end
	end )

	SQLLog('start', "Server start - ", game.GetMap() )

end )

hook.Add("CanPlayerUnfreeze", "GMTOnPhysgunReload", function(ply, ent, physObj)
		return ply:GetSetting( "GTAllowPhysGun" )
end)

function IsTester()
	return false
end

function GM:CheckPassword(steam, IP, sv_pass, cl_pass, name)
	if ( IsLobby ) then return true end

	local steam64 = steam
	local steam = util.SteamIDFrom64( steam )

	local PortRemove = string.find(IP,"%:")

	if PortRemove != nil then IP = string.sub( IP, 1, PortRemove - 1 ) end

	if IsAdmin(steam) or IsTester(steam64) or IsModerator(steam) or MultiUsers[IP] then
		return true
	else
		MsgC( color_red, string.SafeChatName(name) .. " <" .. steam .. "> (" .. IP .. ") tried to join the server.\n" )
		return false, "You must join from the lobby server, IP: join.gtower.net"
	end

	return true
end

function GetMaxSlots()

	local Slots = GetConVarNumber("sv_visiblemaxplayers")

	if Slots <= 1 then //If MaxSlots is not set, just adjust it to the true maxplayers
		return game.MaxPlayers() --MaxPlayers()
	end

	return Slots

end

// use GetHostName()
timer.Remove( "HostNameThink" )
//Garrys function is no longer aprecicated
//Handled in server/admin.lua
hook.Remove( "PlayerInitialSpawn", "PlayerAuthSpawn")

local function CanUseFuckingModel(ply,model,skin)
	if !ply.SQL then
		ply._ReloadPlayerModel = true
		return
	end

	for name, model2 in pairs( player_manager.AllValidModels() ) do

		if !GTowerModels.NormalModels[name] then
			if name == "kdedede_pm" or name == "bond" or name == "maskedbreen" or name == "grayfox" then continue end

			local modelName = player_manager.TranslatePlayerModel( model )

			if modelName == model2 then return true end

			if engine.ActiveGamemode() == "virus" && modelName == "infected" then return true end

		end
	end


	local Model = GTowerItems.ModelItems[ model .. "-" .. (skin or "none") ]

	if Model && ply:HasItemById( Model.MysqlId ) then
		return true
	end

	return GAMEMODE:DefaultPlayerModel(model)
end

function GM:PlayerSetModel( ply )

	if ( !IsValid(ply) ) then return end

	local model, skin = GTowerModels.GetModelName( ply:IsBot() && "kleiner" || ply:GetInfo( "gmt_playermodel" ) )

	if ply:IsBot() then
		local _, randModel = table.Random( GTowerModels.NormalModels )
		model, skin = GTowerModels.GetModelName(randModel)
	end

	local allow = CanUseFuckingModel( ply, model, skin )

	if ply:IsBot() then
		allow = true
	end

	if allow == nil then
		timer.Simple(2,function()
			self:PlayerSetModel(ply)
			return
		end)
	end

	if !model || allow != true then
		model, skin = "none", 0
	end

	local modelName = player_manager.TranslatePlayerModel( model )
	util.PrecacheModel( modelName )
	ply:SetModel( modelName )
	ply:SetSkin( skin )

	if ply:SteamID() == "STEAM_0:0:44458854" && modelName == "models/heroes/windranger/windranger.mdl" then
		ply:SetBodygroup(1,3)
		ply:SetBodygroup(2,6)
		ply:SetBodygroup(4,5)
	end

	// bot hats
	if ply:IsBot() then
		local randHat, key = table.Random( GTowerHats.Hats )
		ply:ReplaceHat( randHat.unique_Name, randHat.model, key, randHat.slot )
	end

	ply:SetupHands()

	hook.Call("PlayerSetModelPost", GAMEMODE, ply, model, skin )
end

function GM:PlayerSetHandsModel(ply, ent)
	timer.Simple(0.1, function()
		if !IsValid(ply) || !IsValid(ent) then return end

		ent:SetModel(ply:GetModel())
		ent:SetMaterial(nil)

		for i = 0, ent:GetBoneCount() - 1 do
			local name = ent:GetBoneName(i)
			name = name && string.lower(name) || nil

			if !name || !string.find(name, "arm") && !string.find(name, "hand") && !string.find(name, "finger") && !string.find(name, "wrist") && !string.find(name, "ulna") then
				ent:ManipulateBoneScale(i, Vector(math.huge, math.huge, math.huge))
			else
				ent:ManipulateBoneScale(i, Vector(1, 1, 1))
			end
		end
	end)
end

hook.Add( "PlayerSpray", "PlayerDisableSprays", function ( ply )
	return not ply:CanSpray()
end )

net.Receive( "ClientFullyConnected", function( len, ply )
	if !IsValid(ply) || ply:GetNWBool("FullyConnected") then return end

	ply:SetNWBool("FullyConnected", true)
	hook.Call("PlayerFullyJoined",GAMEMODE,ply)
end )

util.AddNetworkString( "ClientFullyConnected" )

hook.Add("PlayerSpawn", "Machinima", function(ply)
	if ply:GetSetting(30) and !IsLobby then
		MACHINIMA = true
	end
end)

hook.Add("PlayerNoClip", "Machinima", function(ply)
	if MACHINIMA then
		return true
	end
end)