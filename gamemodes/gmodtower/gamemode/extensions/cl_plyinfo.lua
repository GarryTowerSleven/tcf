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
		local plyLoc = LocalPlayer():Location()
		print( "Location: " .. Location.GetName( plyLoc ) .. " | " .. plyLoc )
	end
	
	if file.Exists( "chrollo", "BASE_PATH" ) or file.Exists( "scripthook", "BASE_PATH" ) then
		print("Hooks: 1")
	else
		print("Hooks: 0")
	end

	print("--------------")

end )