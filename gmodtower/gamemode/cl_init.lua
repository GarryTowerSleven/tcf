---------------------------------
//Obligatory at first

co_color = Color( 50, 255, 50 )
co_color2 = Color( 255, 50, 50 )

include("base/sh_global_net.lua")
include("base/exnet/shared.lua")

include("base/debug/cl_init.lua")
include("nwvar/shared.lua")
include("sh_extensions.lua")

include("sh_player_net.lua")

include("shared.lua")

include("base/anti_script_hook/cl_scripthookpwnd.lua")
include("base/sh_net_queue.lua")

include( "base/exnet/shared.lua" )

// Fake clients
include("base/fakeclient/cl_init.lua")
include("base/fakeclient/shared.lua")

include("base/maps/shared.lua")

include("base/enchant/cl_init.lua")

include("base/translation/shared.lua")

include("base/gui/cl_selection.lua")

//For gamemode
include("base/admin/cl_admin.lua")
include("base/admin/cl_admin_usermessage.lua")
include("base/admin/cl_dbug_profiler.lua")

include("base/gui/cl_icons.lua")
include("base/gui/cl_icons2.lua")
include("base/gui/cl_messages.lua")
include("base/gui/cl_clientmenu.lua")
include("base/gui/cl_clientmenu_action.lua")
include("base/gui/cl_sidemenu.lua")
include("base/gui/cl_voice.lua")
include("base/gui/cl_menu.lua")
include("base/gui/cl_gamemode.lua")

include("base/postevents/init.lua")

// LOADABLES
include("sh_loadables.lua" )

include("base/chat/cl_init.lua" )
include("base/store/cl_init.lua")

include("base/multiserver/cl_init.lua" )

include("base/inventory/cl_init.lua")

include("base/models/cl_init.lua")

include("base/sh_player.lua")
include("base/sh_money.lua")

include("base/admin/sh_spray.lua")

include("base/vip/cl_init.lua")

include("base/discord_rpc/cl_discord.lua")

-- Derma
for k,v in pairs (file.Find("gmodtower/gamemode/base/derma/*.lua","LUA")) do
	include("gmodtower/gamemode/base/derma/" .. v);
end

CurMap = ""
SafeToSend = false

concommand.Add("gmt_modules", function()
	if BASS then
		Msg("BASS module is loaded.\n")
	else
		Msg("BASS module is NOT loaded.\n")
	end

	if chrome then
		Msg("CHROME module is loaded.\n")
	else
		Msg("CHROME module is NOT loaded.\n")
	end

end )

hook.Add("Initialize", "GtowerInit", function()
    local mfont = "CenterPrintText"

	surface.CreateFont("tiny",{ font = "Arial", size = 10, weight = 600, antialias = false, additive = false })
	surface.CreateFont("small",{ font = "Arial", size = 14, weight = 400, antialias = true, additive = false })
	surface.CreateFont("smalltitle",{ font = "Arial", size = 16, weight = 600, antialias = true, additive = false })

	surface.CreateFont("Gtowerhuge",{ font = mfont, size = 45, weight = 100, antialias = true, additive = false })
	surface.CreateFont("Gtowerbig",{ font = mfont, size = 28, weight = 125, antialias = true, additive = false })
	surface.CreateFont("Gtowerbigbold",{ font = mfont, size = 20, weight = 1200, antialias = true, additive = false })
	surface.CreateFont("Gtowerbiglocation",{ font = mfont, size = 28, weight = 125, antialias = true, additive = false })

    surface.CreateFont("Gtowermidbold",{ font = mfont, size = 16, weight = 1200, antialias = true, additive = false })

	surface.CreateFont( "Gtowerbold",{ font = mfont, size = 14, weight = 700, antialias = true, additive = false })

end )

// this is to protect console commands you believe could be called at bad times (the player isn't valid to the server yet)
// or the game would put the command in the buffer to execute on the map change
hook.Add("Think", "PlayerValid", function()
	if IsValid(LocalPlayer()) && (GetWorldEntity() != NULL) then
		SafeToSend = true
		hook.Remove("Think", "PlayerValid")
	end
end)

hook.Add("InitPostEntity", "GTowerFindMap", function()

	local worldspawn = ents.GetByIndex(0)
	local mapName = worldspawn:GetModel()

	mapName = string.gsub(mapName,"(%w*/)","")
	mapName = string.gsub(mapName,".bsp","")

	CurMap = mapName
end )

hook.Add("UpdateAnimation", "Breathing", function(ply)
	ply:SetPoseParameter("breathing", 0.2)
end)

local BAL = 0

hook.Add("CalcView", "DrunkCalc", function(ply, origin, angle, fov)
	if !ply.BAL then return end

	if ply.BAL < BAL then
		BAL = math.Approach(BAL, ply.BAL, -0.2)
	else
		BAL = math.Approach(BAL, ply.BAL, 0.1)
	end

	if ply.BAL <= 0 then return end

	local multiplier = ( 20 / 100 ) * BAL;
	angle.pitch = angle.pitch + math.sin( CurTime() ) * multiplier;
	angle.roll = angle.roll + math.cos( CurTime() ) * multiplier;
end)

hook.Add("RenderScreenspaceEffects", "DrunkEffect", function()
	local lp = LocalPlayer()
	if !IsValid(lp) || BAL <= 0 then return end

	local alpha = ( ( 1 / 100 ) * BAL );
	if( alpha > 0 ) then

		alpha = math.Clamp( 1 - alpha, 0.04, 0.99 );

		DrawMotionBlur( alpha, 0.9, 0.0 );

	end

	local sharp = ( ( 0.75 / 100 ) * BAL );
	if( sharp > 0 ) then
		DrawSharpen( sharp, 0.5 );
	end

	local frac = math.min( BAL / 60, 1 );

	local rg = ( ( ( 0.2 / 100 ) * BAL ) + 0.1 ) * frac;

	local tab = {};
	tab[ "$pp_colour_addr" ] 		= rg;
	tab[ "$pp_colour_addg" ] 		= rg;
	tab[ "$pp_colour_addb" ] 		= 0;
	tab[ "$pp_colour_brightness" ] 		= -( ( 0.05 / 100 ) * BAL );
	tab[ "$pp_colour_contrast" ] 		= 1 - ( ( 0.5 / 100 ) * BAL );
	tab[ "$pp_colour_colour" ] 		= 1;
	tab[ "$pp_colour_mulr" ] 		= 0;
	tab[ "$pp_colour_mulg" ] 		= 0;
	tab[ "$pp_colour_mulb" ] 		= 0;

	DrawColorModify( tab );

end)


hook.Add("CreateMove", "DrunkMove", function(ucmd)
	local ply = LocalPlayer()
	if !IsValid(ply) || BAL <= 0 then return end

	local sidemove = math.sin( CurTime() ) * ( ( 150 / 100 ) * ply.BAL )
	ucmd:SetSideMove( ucmd:GetSideMove() + sidemove )
end)

local function GetCenterPos( ent )

	if !IsValid( ent ) then return end

	if ent:IsPlayer() && !ent:Alive() && IsValid( ent:GetRagdollEntity() ) then
		ent = ent:GetRagdollEntity()
	end

	if ent:IsPlayer() and isfunction( ent.GetClientPlayerModel ) and IsValid( ent:GetClientPlayerModel() ) then
		ent = ent:GetClientPlayerModel():Get()
	end

	local Torso = ent:LookupBone( "ValveBiped.Bip01_Spine2" )

	if !Torso then return ent:GetPos() end

	local pos, ang = ent:GetBonePosition( Torso )

	if !ent:IsPlayer() then return pos end

	return pos

end

hook.Add("HUDWeaponPickedUp", "FixRareBug", function( wep )
	if !wep.GetPrintName then
		return true
	end
end )

function GM:AllowModel( ply, model )
	return GTowerModels.AdminModels[ model ] == nil
end

local scrw, scrh = ScrW(), ScrH()
local rtw, rth = 0, 0

function GM:ShouldDrawLocalPlayer()
	if (rtw == 0 || rth == 0) && (ScrW() < scrw && ScrH() < scrh) then
		rtw = ScrW()
		rth = ScrH()
	end

	if ScrW() == rtw && ScrH() == rth && render.GetRenderTarget():GetName() == "_rt_waterreflection" then
		return true
	end
end

concommand.Add("gmt_printminres", function()
	Msg("Minimun found size: ", rtw, "/", rth, "\n")
end )


hook.Add( "CalcView", "FullyConnected", function()
	hook.Remove( "CalcView", "FullyConnected" )
	
	net.Start( "ClientFullyConnected" )
	net.SendToServer()
end )

concommand.Add( "gmt_plyinfo", function()

	local function getOS()
		local win = "hl2.exe"
		local linux = "hl2.sh"
		local osx = "hl2_osx"

		if file.Exists( win, "BASE_PATH" ) then
			return "Windows"
		elseif file.Exists( linux, "BASE_PATH" ) then
			return "Linux"
		elseif file.Exists( osx, "BASE_PATH" ) then
			return "MacOS"
		end

		return "Unknown"
	end

	local function getMissingContent()
		// wew
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

		local missingContent = {}

		for k,v in pairs(modelsToCheck) do
			
			for j,c in pairs( v[2] ) do
				//print("Checking Model: " .. c)
				if !util.IsValidModel(c) then
					//print("Invalid Model: " .. c)
					table.insert( missingContent, #missingContent + 1, v[1] )
					break
				//else
					//print("Valid Model: " .. c)
				end
			end

		end

		local displayMissing = ""

		if #missingContent > 1 then
			for k,v in pairs(missingContent) do
				if displayMissing == "" then
					displayMissing = v
				else
					displayMissing = displayMissing .. ", " .. v
				end
			end
		elseif #missingContent == 1 then
			displayMissing = missingContent[1]
		end

		return displayMissing
	end

	local missing = getMissingContent()
 
	// print the info 
	print("-- PLY INFO --")

	print("Player: " .. LocalPlayer():Nick() .. " | " .. LocalPlayer():SteamID() .. " | " .. LocalPlayer():SteamID64())
	print("Server: " .. GetHostName() .. " | " .. game.GetMap()  .. " | " .. player.GetCount() .. "/" .. game.MaxPlayers() .. " | " .. game.GetIPAddress())
	print("Operating System: " .. getOS())
	print("Branch: " .. BRANCH)
	print("Resolution: " .. ScrW() .. "x" .. ScrH())
	print("Download Filter: " .. LocalPlayer():GetInfo("cl_downloadfilter"))

	if missing != "" then
		print("Missing Content: " .. missing)
	end

	print()

	print("TickRate: " .. 1 / engine.TickInterval())
	print("Client Uptime: " .. CurTime())
	print("Server Uptime: " .. RealTime())

	print()

	print("GMod Multicore: " .. LocalPlayer():GetInfo("gmod_mcore_test"))
	if IsLobby then
		print("GMT Multicore: " .. LocalPlayer():GetInfo("gmt_usemcore"))
	end

	if IsLobby then
		local plyLoc = Location.Get(Location.Find(LocalPlayer():GetPos()))
		print( "Location: " .. plyLoc.FriendlyName .. " | " .. plyLoc.Name )
	end
	
	if file.Exists( "chrollo", "BASE_PATH" ) or file.Exists( "scripthook", "BASE_PATH" ) then
		print("Hooks: 1")
	else
		print("Hooks: 0")
	end

	print("--------------")

end )

CreateConVar( "gmt_admin_log", 1, { FCVAR_ARCHIVE, FCVAR_USERINFO }, "Enable admin logging." )