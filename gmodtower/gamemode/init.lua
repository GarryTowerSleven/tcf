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

AddCSLuaFile("base/sh_net_queue.lua")
include("base/sh_net_queue.lua")

AddCSLuaFile("base/exnet/shared.lua")
include("base/exnet/shared.lua")

//Obligatory at first

include("base/anti_script_hook/sv_scripthookpwnd.lua")

include("base/debug/init.lua")
include("nwvar/shared.lua")
include("sh_extensions.lua")

include("sh_player_net.lua")
AddCSLuaFile("sh_player_net.lua")

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
include("base/database/network.lua")

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

include("base/bit/bit.lua")
include("base/bit/hex.lua")

include("base/vip/init.lua")

RunConsoleCommand("sv_hibernate_think", "1")

// Workshop
resource.AddWorkshop( 148215278 ) -- Accessories
resource.AddWorkshop( 150404359 ) -- Player model pack
resource.AddWorkshop( 104548572 ) -- Playable piano
resource.AddWorkshop( 546392647 ) -- Media player

// Lobby 2 content from before shutdown, hidden
resource.AddWorkshop( 2667443678 ) -- base
resource.AddWorkshop( 2667447617 ) -- lobby
resource.AddWorkshop( 2667452517 ) -- lobby2
resource.AddWorkshop( 2667461993 ) -- ballrace
resource.AddWorkshop( 2667463971 ) -- pvpbattle
resource.AddWorkshop( 2667466895 ) -- virus
resource.AddWorkshop( 2667468743 ) -- chimera
resource.AddWorkshop( 2667470886 ) -- minigolf
resource.AddWorkshop( 2667474570 ) -- zombiemassacre
resource.AddWorkshop( 2667477578 ) -- karts

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

/////////////////////////////
// Tester Steam Group Shit //
/////////////////////////////
TesterGroupData = ""

local testerCachePath = "tester_cache.txt"

// check for cache and use it immediately for startup
if PRIVATE_TEST_MODE && file.Exists( testerCachePath, "DATA" ) then
	MsgC( co_color, "[Testers] Cached testers found, using...\n" )
	TesterGroupData = file.Read( testerCachePath, "DATA" )
end

local groupID = "103582791471194784"
local checkfor = "76561197963035118" // kity
local updateAttempts = 0
function UpdateTesters()
	MsgC( co_color, "[Testers] Fetching group members...\n" )

	local url = "https://steamcommunity.com/gid/" .. groupID .. "/memberslistxml/?xml=1"

	http.Fetch( url,
		function( body, length, headers, code )

			updateAttempts = 0

			// Check if data has a specific user (checkfor) before doing anything, just to be safe
			if !string.find( body, checkfor ) then
				MsgC( co_color2, "[Testers] Data received is incomplete, not using.\n" )
				return
			end

			MsgC( co_color, "[Testers] Successfully got group members!\n" )

			// get only the members portion of the XML
			local t1, t2 = string.find( body, "<members>" )
			local tt1, tt2 = string.find( body, "</members>" )
			local memberData = string.sub( body, t1, tt2 )

			TesterGroupData = memberData

			// Cache testers if they've changed
			if file.Exists( testerCachePath, "DATA" ) then
				if memberData != file.Read( testerCachePath, "DATA" ) then
					MsgC( co_color, "[Testers] Testers have changed!\n" )
					cacheTesters( memberData )	
				end
			else
				cacheTesters( memberData )
			end
		end,

		function( message )
			if updateAttempts <= 5 then
				MsgC( co_color2, "[Testers] Failed to get group members. \"" .. message .. "\"\n" )
				MsgC( co_color2, "[Testers] Retrying...\n" )
				updateAttempts = updateAttempts + 1
				UpdateTesters()
			else
				MsgC( co_color2, "[Testers] Failed to get group members 5 times, giving up.\n" )
				updateAttempts = 0
			end
		end
	)
end

local testerTimeDelay = ( 5*60 )
local testerTimeSince = CurTime() + testerTimeDelay
if PRIVATE_TEST_MODE then
	timer.Simple( 2, function()
		UpdateTesters()
	end )

	// refresh testers every X minutes
	hook.Add("Think", "TesterUpdater", function()
		if testerTimeSince < CurTime() then
			testerTimeSince = CurTime() + testerTimeDelay
			UpdateTesters()
		end
	end)
end

// cache the groupdata to use incase steam is down 
function cacheTesters( data )
	MsgC( co_color, "[Testers] Caching testerdata in \"".. "garrysmod/data/" .. testerCachePath .."\".\n" )
	file.Write( testerCachePath, data )
end

function IsTester( steam64 )
	return string.find( TesterGroupData, steam64 )
end

concommand.Add( "gmt_refreshtesters", function( ply, cmd, args )
	if ply:IsAdmin() then
		ply:Msg2("Attempting to refresh testers...", "admin")
		testerTimeSince = CurTime() + testerTimeDelay
		UpdateTesters()
	end
end)
/////////////////////////////

function GM:CheckPassword(steam, IP, sv_pass, cl_pass, name)

	if engine.ActiveGamemode() == "gmtlobby" then return end

	local steam64 = steam
	local steam = util.SteamIDFrom64(steam)

	local PortRemove = string.find(IP,"%:")

	if PortRemove != nil then IP = string.sub( IP, 1, PortRemove - 1 ) end

	--PrintTable(MultiUsers)
	--print("IP:"..tostring(IP))

	if IsAdmin(steam) or IsTester(steam64) or MultiUsers[IP] then
		return true
	else
		MsgC( co_color2, stringmod.SafeChatName(name) .. " <" .. steam .. "> (" .. IP .. ") tried to join the server.\n" )
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

	return GAMEMODE:DefaultPlayerModel(model)
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

function AdminLog( message, color )
	for k,v in pairs( player.GetAdmins() ) do
		if v:GetInfoNum( "gmt_admin_log", 1 ) == 0 then return end
		GAMEMODE:ColorNotifyPlayer( v, message, color )
	end
end

// precache these so clients can test
local modelsToCheck = {
	{ "CSS", {"models/props/de_cbble/cb_doorarch32.mdl","models/props/de_prodigy/ammo_can_03.mdl"} },
	{ "TF2", {"models/props_trainyard/beer_keg001.mdl","models/props_manor/banner_01.mdl"} },

	{ "GMTBase", {"models/gmt_money/fifty.mdl","models/gmod_tower/plant/largebush01.mdl"} },
	{ "GMTLobby", {"models/func_touchpanel/terminal04.mdl","models/gmod_tower/propper/bar_elev.mdl"} },
	{ "GMTLobby2", {"models/sunabouzu/elevator_roof.mdl","models/map_detail/appearance_stand.mdl"} },
	{ "GMTMinigolf", {"models/props/gmt_minigolf_moon/light_sphere.mdl","models/gmod_tower/golftriangleflag.mdl"} },
	{ "GMTPVPBattle", {"models/gmod_tower/future_doorframe.mdl","models/weapons/v_pvp_ire.mdl"} },
	{ "GMTKarts", {"models/gmt_turnright.mdl","models/gmod_tower/sourcekarts/flux.mdl"} },
	{ "GMTChimera", {"models/uch/mghost.mdl","models/uch/pigmask.mdl"} },
	{ "GMTVirus", {"models/gmod_tower/facility/gmt_facilitydoor.mdl","models/weapons/v_vir_snp.mdl"} },
	{ "GMTZombie", {"models/weapons/w_flamethro.mdl","models/zom/dog.mdl"} },
	{ "GMTBallrace", {"models/gmod_tower/ballcrate.mdl","models/props_memories/memories_levelend.mdl"} },
}

for k,v in pairs(modelsToCheck) do
	for j,c in pairs( v[2] ) do
		util.PrecacheModel(c)
	end
end