---------------------------------

include("nwtranslator.lua")
AddCSLuaFile("nwtranslator.lua")

include("exnet/shared.lua")
AddCSLuaFile("exnet/shared.lua")

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("helper.lua")

include("sv_analytics.lua")

// Fake clients
include("fakeclient/init.lua")
AddCSLuaFile("fakeclient/cl_init.lua")
AddCSLuaFile("fakeclient/shared.lua")
include("fakeclient/shared.lua")

include("maps/shared.lua")
AddCSLuaFile("maps/shared.lua")

AddCSLuaFile("anti_script_hook/cl_scripthookpwnd.lua")
AddCSLuaFile("client/messages.lua")
AddCSLuaFile("client/network.lua")
AddCSLuaFile("client/menu.lua")
AddCSLuaFile("client/alltalk.lua")
AddCSLuaFile("client/helper.lua")
AddCSLuaFile("client/clientmenu.lua")
AddCSLuaFile("client/sidemenu.lua")
AddCSLuaFile("client/hud_hide.lua")
AddCSLuaFile("client/cl_admin.lua")
AddCSLuaFile("client/cl_selection.lua")
AddCSLuaFile("client/cl_admin_usermessage.lua")
AddCSLuaFile("client/cl_dbug_profiler.lua")
AddCSLuaFile("client/dmodel.lua")
AddCSLuaFile("client/cl_question.lua")
AddCSLuaFile("client/clientmenu_action.lua")
AddCSLuaFile("client/cl_resizer.lua")
AddCSLuaFile("sh_extensions.lua")
AddCSLuaFile("sh_player.lua")
AddCSLuaFile("sh_spray.lua")


AddCSLuaFile( "translation/shared.lua" )
AddCSLuaFile( "postprocess/init.lua" )
AddCSLuaFile( "cl_debug.lua" )
AddCSLuaFile( "cl_playermenu.lua" )

AddCSLuaFile( "modules/modules.lua" )

include("network_queue.lua")
AddCSLuaFile("network_queue.lua")

//Obligatory at first

include("anti_script_hook/sv_scripthookpwnd.lua")

include("debug/init.lua")
include("nwvar/nwvars.lua")
include("sh_extensions.lua")

//Nornal loads
include("shared.lua")
include("helper.lua")
include("sh_player.lua")
include("sh_spray.lua")

include( "translation/init.lua" )
include("enchant/init.lua")

include("server/mysql.lua")
include("server/basicsql.lua")

include("server/player.lua")
include("icons/init.lua")
include("server/betatester.lua")
include("server/network.lua")
include("gtrivia/init.lua")
include("clientsettings/init.lua")
include("postprocess/init.lua")
include( "modules/modules.lua" )
include("chat/init.lua")
include("store/init.lua")
include("server/question.lua")
include("server/admin.lua")
include("server/loadsql.lua")
include("server/admin/noclip.lua")
include("server/admin/god.lua")
include("server/admin/teleport.lua")
include("server/admin/entityreset.lua")
include("server/admin/decal.lua")
include("server/entitydump.lua")
include("server/admin/rement.lua")
include("multiserver/init.lua")
include("inventory/init.lua")
include("models/init.lua")
include("mapchange.lua")
include("server/alltalk.lua")


include("server/rocket.lua")
include("bit/bit.lua")
include("bit/hex.lua")

AddCSLuaFile( 'theater/cl_init.lua' )
AddCSLuaFile( 'theater/init.lua' )

--include( 'theater/cl_init.lua' )
include( 'theater/init.lua' )

RunConsoleCommand("sv_hibernate_think", "1")

resource.AddWorkshop( 148215278 ) -- Accessories.
resource.AddWorkshop( 150404359 ) -- Player model pack.
resource.AddWorkshop( 104548572 ) -- Playable piano.

MultiUsers = {}

-- Modules
for k,v in pairs (file.Find("gmodtower/gamemode/oboy/*.lua","LUA")) do
	AddCSLuaFile("gmodtower/gamemode/oboy/" .. v);
end

-- Derma
for k,v in pairs (file.Find("gmodtower/gamemode/derma/*.lua","LUA")) do
	AddCSLuaFile("gmodtower/gamemode/derma/" .. v);
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
		MsgC( Color(51, 204, 51), string.SafeChatName(name) .. " <" .. steam .. "> (" .. IP .. ") tried to join the server.\n" )
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
