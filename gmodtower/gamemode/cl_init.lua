---------------------------------
//Obligatory at first

include("nwvar/shared.lua")
include("sh_load.lua")
include("shared.lua")
include("sh_loadables.lua")

// this is to protect console commands you believe could be called at bad times (the player isn't valid to the server yet)
// or the game would put the command in the buffer to execute on the map change
hook.Add("Think", "PlayerValid", function()
	if IsValid(LocalPlayer()) && (GetWorldEntity() != NULL) then
		SafeToSend = true
		hook.Remove("Think", "PlayerValid")
	end
end)

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