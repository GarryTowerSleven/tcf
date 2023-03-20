
module("Loadables", package.seeall )

DEBUG = false

LoadedModules = {}
LoadablesFolder = string.sub( GM.Folder, 11 )  .. "/gamemode/loadables/"
	
function Load( name )

	if type( name ) == "table" then
		if DEBUG then
			MsgC( color_green, "Loadables table:\n")
		end
		for _, v in pairs( name ) do
			if DEBUG then
				MsgC( color_green, "\t" .. v .. "\n")
			end
			Load( v )
		end
		return
	end

	// Lobby 1 loadables
	if ( IsLobbyOne && table.Count( file.FindDir( LoadablesFolder .. name .. "lobby1" .. "/*", "LUA" ) ) != 0 ) then
		name = name .. "lobby1"
	end
	
	local ModuleDir = LoadablesFolder .. name .. "/"
	local ModuleFiles = file.FindDir( ModuleDir .. "*", "LUA" )

	//PrintTable( ModuleFiles )
	
	if table.Count( ModuleFiles ) == 0 then
		ErrorNoHalt( "Module folder: " .. name .. " not found!\n")
		return
	end

	local FileName = SERVER && "init.lua" || "cl_init.lua"
	
	if table.HasValue( ModuleFiles, FileName ) then

		//MsgN( ModuleDir .. FileName )
		include( ModuleDir .. FileName )
	
	// Include shared file
	elseif table.HasValue( ModuleFiles, "shared.lua" ) then

		//MsgN( "SHARED " .. ModuleDir .. "shared.lua" )
		include( ModuleDir .. "shared.lua" )

	end
	
	
	// Include entities
	if table.HasValue( ModuleFiles, "entities" ) then
		
		if DEBUG then
			print("\t\t" .. ModuleDir .. "entities/" )
		end
		
		DirLoader.LoadEntitiesFolder( ModuleDir .. "entities/" )

	end

	if !table.HasValue( LoadedModules, name ) then
		table.insert( LoadedModules, name )
	end
	
end

concommand.Add( "gmt_reloadloadable", function( ply, cmd, args )
	if !ply:IsAdmin() then return end
	Loadables.Load( tostring( args[1] ) )
end )