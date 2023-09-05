// MediaPlayer.DEBUG = true

-- Load players
do
	local path = "players/"
	local players = {
		"suitetv",
		"jukebox",
		-- "club"
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
	return ply.IsStaff and ply:IsStaff() or false
end )