function SetupGMTGamemode( name, folder, settings )

	GM.Name = "GMod Tower: " .. name

	if Loadables then

		local defaultLoadables = {
			"clientsettings",
            "achievement",
            "commands",
            "afk2",
            "friends",
            "scoreboard3",
            "weaponfix",
		}
		if settings.Loadables then
			table.Add( defaultLoadables, settings.Loadables )
		end

		Loadables.Load( defaultLoadables )

	end

	/*local gmtfolder = "/gamemode/"

	-- Load the base GMT files
	//local srvpayout = folder .. gmtfolder .. "sv_payout.lua"
	local payout = folder .. gmtfolder .. "sh_payout.lua"
	local scoreboard = folder .. gmtfolder .. "cl_scoreboard.lua"
	local multi = folder .. gmtfolder .. "multiserver.lua"

	AddCSLuaFile( payout )
	AddCSLuaFile( scoreboard )

	timer.Simple( .1, function() -- Delay so we can load the gamemode first

		include( payout )

		if CLIENT then
			include( scoreboard )
		else
			include( multi )
			//include( srvpayout )
		end

	end )*/

	MsgC( Color( 0, 255, 255 ), "Registered and loaded gamemode: " .. name .. "\n" )

end