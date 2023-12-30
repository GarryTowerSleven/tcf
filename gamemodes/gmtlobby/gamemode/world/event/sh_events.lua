local files, _ = file.Find( "gmtlobby/gamemode/world/event/events/*.lua", "LUA" )

for _, v in ipairs( files ) do

	local path = "events/" .. v
	
	if SERVER then
		AddCSLuaFile( path )
	end

	include( path )

end