module("minigames", package.seeall )

do

	local MiniGames = file.FindDir( "gmtlobby/gamemode/world/event/minigames/*", "LUA" )

	if SERVER then
		MsgC( color_green, "\n[Minigames] Loading Minigames...\n")
	end

	for _, v in ipairs( MiniGames ) do
		if ( !string.EndsWith( v, ".lua" ) ) then
			if SERVER then
				MsgC( color_green, "Loading: " .. v .. " \n")
			end
		end
		if v != "." && v != ".." && v != ".svn" && string.sub( v, -4 ) != ".lua" then
			if SERVER then
				include( v .. "/init.lua" )
			else
				include( v .. "/cl_init.lua" )
			end

		end

	end

	Msg( "\n")
	
end
