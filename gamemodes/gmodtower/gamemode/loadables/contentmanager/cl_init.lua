
include( "shared.lua" )

//local enableNotice = CreateClientConVar( "gmt_notice_workshop", 1, true, false )

module( "contentmanager", package.seeall )

//HasGMTContent = FileReport.HasFile( "addons/GMT2_Base/sound/GModTower/music/award.wav" )
RequiredModels = {
	[240] = "models/props/cs_militia/wood_table.mdl",
	[440] = "models/props_trainyard/beer_keg001.mdl"
}

RequiredGames = {
	[240] = "Counter-Strike: Source",
	[440] = "Team Fortress 2"
	//[420] = "HL2: Episode Two",
}

// Check for missing games
MissingGames = {}

// Check for missing addons
MissingAddons = {}

// Find missing games, if any
for _, item in pairs( engine.GetGames() ) do

	local content = RequiredGames[item.depot]

	if content then

		local model = RequiredModels[item.depot]

		if !item.mounted || !item.installed then
			if ( model && !util.IsValidModel( model ) ) then -- wait wtf was I doing LOL
				table.insert( MissingGames, content )
			end
		end

	end

end


// Check for workshop items
HasAllWorkshop = true

for name, models in pairs( modelsToCheck ) do

	for _, v in ipairs( models ) do
		if ( not util.IsValidModel( v ) ) then
			HasAllWorkshop = false
		end
	end

end

/*if !HasAllWorkshop then

	if enableNotice:GetBool() then

		Derma_Query( "It appears that you do not have all the necessary GMTower content!\n\n" ..
			"You'll need to login to Steam and hit subscribe to all on our workshop collection.\n" ..
			"Would you like to open the collection now?",

			"Workshop Content Missing!",
			"Yes", function() browser.OpenURL( "https://content.gtower.net", "Workshop Collection" ) end,
			"No", EmptyFunction()
		)

	else

		Msg( "NOTICE! You are missing workshop addons. You have chosen to ignore the workshop content notice." )

	end


end*/


hook.Add( "HUDPaint", "ContentNotice", function()

	if GTowerHUD && GTowerHUD.DrawNotice then

		local message = nil

		// Missing Games!
		if #MissingGames > 0 then

			local gamesmissing = ""
			for id, gamename in pairs( MissingGames ) do
				gamesmissing = gamesmissing .. gamename

				if id != #MissingGames then
					gamesmissing = gamesmissing .. ", "
				end
			end

			message = "It appears that you are missing the required " .. string.Pluralize( "game", #MissingGames ) .. ": " .. gamesmissing .. "\n" ..
					  "Please mount the "  .. string.Pluralize( "game", #MissingGames ) .. " and restart to remove errors."

		end

		// Missing GMT Content!
		if !HasAllWorkshop then
			if !message then message = "" end
			message = message .. "\nAlert: GMT workshop content is not installed, is outdated, or manual content is out of date!\n " ..
								"Please subscribe to all at http://content.gtower.net/ and restart."
		end

		if message then
			GTowerHUD.DrawNotice( "Missing Content", message .. "\nYou can disable this notice in the settings." )
		end

	end

end )