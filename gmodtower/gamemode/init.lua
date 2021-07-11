---------------------------------

co_color = Color( 50, 255, 50 )
co_color2 = Color( 255, 50, 50 )

include("base/sh_global_net.lua")
AddCSLuaFile("base/sh_global_net.lua")

include("base/exnet/shared.lua")
AddCSLuaFile("base/exnet/shared.lua")

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

// Fake clients
include("base/fakeclient/init.lua")
AddCSLuaFile("base/fakeclient/cl_init.lua")
AddCSLuaFile("base/fakeclient/shared.lua")
include("base/fakeclient/shared.lua")

include("base/maps/shared.lua")
AddCSLuaFile("base/maps/shared.lua")

AddCSLuaFile("base/anti_script_hook/cl_scripthookpwnd.lua")

AddCSLuaFile("base/gui/cl_messages.lua")
AddCSLuaFile("base/gui/cl_icons.lua")
AddCSLuaFile("base/gui/cl_icons2.lua")
AddCSLuaFile("base/gui/cl_clientmenu.lua")
AddCSLuaFile("base/gui/cl_clientmenu_action.lua")
AddCSLuaFile("base/gui/cl_sidemenu.lua")
AddCSLuaFile("base/gui/cl_voice.lua")
AddCSLuaFile("base/gui/cl_menu.lua")
AddCSLuaFile("base/gui/cl_gamemode.lua")

AddCSLuaFile("base/admin/cl_admin.lua")

AddCSLuaFile("base/gui/cl_selection.lua")

AddCSLuaFile("base/admin/cl_admin_usermessage.lua")
AddCSLuaFile("base/admin/cl_dbug_profiler.lua")

AddCSLuaFile("sh_extensions.lua")

AddCSLuaFile("base/sh_player.lua")

AddCSLuaFile("base/sh_money.lua")

AddCSLuaFile("base/admin/sh_spray.lua")


AddCSLuaFile( "base/translation/shared.lua" )

AddCSLuaFile( "base/postevents/init.lua" )

// LOADABLES
AddCSLuaFile( "sh_loadables.lua" )

include("base/sh_net_queue.lua")
AddCSLuaFile("base/sh_net_queue.lua")

//Obligatory at first

include("base/anti_script_hook/sv_scripthookpwnd.lua")

include("base/debug/init.lua")
include("nwvar/shared.lua")
include("sh_extensions.lua")

//Nornal loads
include("shared.lua")
include("base/sh_player.lua")
include("base/sh_money.lua")

include("base/admin/sh_spray.lua")

include("base/admin/powers.lua")

include( "base/translation/init.lua" )

include("base/enchant/init.lua")

include("base/database/mysql.lua")
include("base/database/basicsql.lua")

include("base/database/player.lua")
//include("server/betatester.lua")
include("base/database/network.lua")

include("base/gtrivia/init.lua")

include("base/postevents/init.lua")

// LOADABLES
include( "sh_loadables.lua" )

include("base/chat/init.lua")
include("base/store/init.lua")

include("base/admin/admin.lua")
include("base/database/loadsql.lua")

include("base/multiserver/init.lua")

include("base/inventory/init.lua")
include("base/models/init.lua")
//include("server/alltalk.lua")

include("base/bit/bit.lua")
include("base/bit/hex.lua")

AddCSLuaFile( 'base/theater/cl_init.lua' )
include( 'base/theater/init.lua' )

RunConsoleCommand("sv_hibernate_think", "1")

resource.AddWorkshop( 148215278 ) -- Accessories.
resource.AddWorkshop( 150404359 ) -- Player model pack.
resource.AddWorkshop( 104548572 ) -- Playable piano.

MultiUsers = {}

-- Derma
for k,v in pairs (file.Find("gmodtower/gamemode/base/derma/*.lua","LUA")) do
	AddCSLuaFile("gmodtower/gamemode/base/derma/" .. v);
end

/*require("luaerror")

hook.Add("LuaError", "LE", function(err)
	SQLLog('error', err)
end)*/

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

// 1 second tick player think, this should be pretty efficient
timer.Create( "GTowerPlayerThink", 1.0, 0, function()

	for _, v in ipairs( player.GetAll() ) do
		if IsValid(v) then
			hook.Call("PlayerThink", GAMEMODE, v)
		end
	end

end)

hook.Add("InitPostEntity", "AddTempBot", function()

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

function GM:CheckPassword(steam, IP, sv_pass, cl_pass, name)

	if engine.ActiveGamemode() == "gmtlobby" then return end

	steam = util.SteamIDFrom64(steam)

	local PortRemove = string.find(IP,"%:")

	if PortRemove != nil then IP = string.sub( IP, 1, PortRemove - 1 ) end

	--PrintTable(MultiUsers)
	--print("IP:"..tostring(IP))

	if IsAdmin(steam) or IsTester(steam) or MultiUsers[IP] then
		return true
	else
		MsgC( co_color2, string.SafeChatName(name) .. " <" .. steam .. "> (" .. IP .. ") tried to join the server.\n" )
		return false, "You must join from the lobby server, IP: join.gmtdeluxe.org"
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
end

function GM:PlayerSetModel( ply )

	if ( !IsValid(ply) || ply:IsBot() ) then return end

	local model, skin = GTowerModels.GetModelName( ply:GetInfo( "cl_playermodel" ) )

	local allow = CanUseFuckingModel( ply, model, skin )

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

	hook.Call("PlayerSetModelPost", GAMEMODE, ply, model, skin )
end

function GM:AllowModel( ply, model )
	return GTowerModels.AdminModels[ model ] == nil || ply:IsAdmin()
end

net.Receive( "ClientFullyConnected", function( len, ply )
	hook.Call("PlayerFullyJoined",GAMEMODE,ply)
end )

util.AddNetworkString( "ClientFullyConnected" )