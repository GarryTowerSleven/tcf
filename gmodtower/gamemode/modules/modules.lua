---------------------------------
module("TowerModules", package.seeall )

LoadedModules = {}
ModulesFolder = string.sub( GM.Folder, 11 )  .. "/gamemode/modules/"
	

function LoadModule( Name )

	local FileName = SERVER && "init.lua" || "cl_init.lua"	
	
	local ModuleDir = ModulesFolder .. Name .. "/"
	local ModuleFiles = file.Find( ModuleDir .. "*", "LUA" )
	
	if table.Count( ModuleFiles ) == 0 then
		ErrorNoHalt( "Module folder: " .. Name .. " not found!\n")
		return
	end
	
	if table.HasValue( ModuleFiles, FileName ) then
		include( ModuleDir .. FileName )
		
	elseif table.HasValue( ModuleFiles, "shared.lua" ) then
		include( ModuleDir .. "shared.lua" )
	
	else
		ErrorNoHalt( "Could not find file to load in " .. Name .. " " .. FileName .."!\n")
		return
	
	end
	
	if !table.HasValue( LoadedModules, Name ) then
		table.insert( LoadedModules, Name )
	end
end

function LoadModules( list )

	//MsgC( co_color, " -- Starting Modules -- \n")
	
	for _, Name in pairs( list ) do
		//MsgC( co_color, "[Modules] Loaded: " .. Name .. "\n")
		LoadModule( Name )
	end
	
	//MsgC( co_color, " ----------------------\n\n")
	
end 