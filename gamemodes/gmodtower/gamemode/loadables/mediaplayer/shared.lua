// MediaPlayer.DEBUG = true

-- Load players
do
	local path = "players/"
	local players = {
		"suitetv",
		"jukebox",
		-- "club"
		"suitepanel"
	}

	for _, player in ipairs(players) do
		local clfile = path .. player .. "/cl_init.lua"
		local svfile = path .. player .. "/init.lua"

		MEDIAPLAYER = {}
		
		if SERVER then
			AddCSLuaFile(clfile)
			include(svfile)
		else
			include(clfile)
		end 

		MediaPlayer.Register( MEDIAPLAYER )
		MEDIAPLAYER = nil
	end

	local path = "services/"
	local services = {
		"audiofile"
	}

	for _, service in ipairs(services) do
		local clfile = path .. service .. "/cl_init.lua"
		local svfile = path .. service .. "/init.lua"

		print(clfile)

		SERVICE = {}
		
		if SERVER then
			AddCSLuaFile(clfile)
			include(svfile)
		else
			include(clfile)
		end 

		MediaPlayer.RegisterService( SERVICE )
		SERVICE = nil
	end
end

local function GMTInitMediaPlayer( MediaPlayer )
	local GMTServices = {}

	for _, serviceId in pairs({
		"base",

		"browser",
		"yt",
		-- "twv",
		-- "twl",

		"res",
		"img",
		"h5v",
		"www",

		"af",
		"shc",
		-- "sc"
	}) do
		GMTServices[serviceId] = true
	end

	-- Unregister disallowed services (temporary until they're fixed)
	for id, service in pairs(MediaPlayer.Services) do
		if not GMTServices[service.Id] then
			MediaPlayer.Services[id] = nil
		end
	end
end
hook.Add("InitMediaPlayer", "GMT.InitMediaPlayer", GMTInitMediaPlayer)

hook.Add( "MediaPlayerIsPlayerPrivileged", "GMTMediaPrivileged", function( mp, ply )

	if ply:IsStaff() then

		return true

	end

	// check if in suite
	local roomid = Location.GetSuiteID( mp:GetLocation() )

	if ( roomid < 1 ) then return false end

	local room = CLIENT && GTowerRooms:Get( roomid ) || GTowerRooms.Get( roomid )

	if room && room.Owner == ply then

		return true

	end

end )

function MediaPlayer.GetVisualizer( loc )
	for _, e in ipairs(Location.GetMediaPlayersInLocation(loc)) do
		if string.StartsWith(e.Entity:GetClass(), "gmt_jukebox") then
			return e
		end
	end
end