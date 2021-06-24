module("minigames", package.seeall )

function file.FindDir( File, Dir )



	local files, folders = file.Find( File, Dir )

	return table.Add( files, folders )



end

do

	local MiniGames = file.FindDir( "gmtlobby/gamemode/minigames/*", "LUA" )
	
	print("====Loaded Minigames====")
	
	for _, v in ipairs( MiniGames ) do
		if ( !string.EndsWith( v, ".lua" ) ) then
			print(v)
		end
		if v != "." && v != ".." && v != ".svn" && string.sub( v, -4 ) != ".lua" then
			if SERVER then
				include( v .. "/init.lua" )
			else
				include( v .. "/cl_init.lua" )
			end

		end

	end
	
	print("========================")
	
end
