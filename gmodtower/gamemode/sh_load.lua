module("DirLoader", package.seeall )

DEBUG = false
BaseDir = string.sub( GM.Folder, 11 )  .. "/gamemode/"

local function IsLua( name )
	return string.sub( name, -4 ) == ".lua" 
end	

local function ValidName( name )
	return name != "." && name != ".." && name != ".svn"
end

function Include( File, name )

	local filename = File
	if name then filename = name end
	
	local Suffix = string.sub( filename, 0, 3 )
	local Type = "server"
	
	if Suffix == "cl_" then
		
		if SERVER then
			AddCSLuaFile( File )
		else
			include( File )
		end

		Type = "client"
		
	elseif Suffix == "sh_" || File == "shared.lua" then
		
		if SERVER then
			AddCSLuaFile( File )
		end
		
		include( File )

		Type = "shared"
		
	elseif SERVER then
		
		include( File )
		
	end
	
	if DEBUG then
		Msg("\t " .. File .. " \t type: " .. Type .. "\n")
	end

end

function SelectiveInclude( dir, name )
	
	local File = dir .. name
	Include( File, name )

end

function BasicFolderInclude( LoadDir, FileList )
	
	if SERVER && table.HasValue( FileList, "init.lua" ) then
		include( LoadDir .. "init.lua" )
	elseif CLIENT && table.HasValue( FileList, "cl_init.lua" ) then
		include( LoadDir .. "cl_init.lua" )
	elseif table.HasValue( FileList, "shared.lua" ) then
		if SERVER then
			AddCSLuaFile( LoadDir .. "shared.lua" )
		end
		include( LoadDir .. "shared.lua" )
	end

end

function LoadFolder( dir )

	local LoadDir = BaseDir .. dir .. "/"
	local FileList = file.Find( LoadDir .. "*", "LUA" )

	if !FileList then return end
	
	if DEBUG then
		Msg("Loading " .. LoadDir .. " (".. #FileList ..")\n")
	end
	
	for _, name in pairs( FileList ) do
		
		if ValidName( name ) then
			if IsLua( name ) then
				SelectiveInclude( LoadDir, name )
			else
				LoadExtension( LoadDir .. name .. "/" )
			end
		end
		
	end

end

function LoadExtension( LoadDir )
	
	local FileList = file.FindDir( LoadDir .. "*", "LUA" )
	
	if DEBUG then
		Msg("\t Loading " .. LoadDir .. " (".. #FileList ..")\n")
	end
	
	BasicFolderInclude( LoadDir, FileList )
	
	if table.HasValue( FileList, "entities" ) then
		LoadEntitiesFolder( LoadDir .. "entities/" )
	end
	
end

function LoadEntitiesFolder( LoadDir )

	local FileList = file.FindDir( LoadDir .. "*", "LUA" )
	
	for _, FileName in ipairs( FileList ) do

		if ValidName( FileName ) then

			if FileName == "entities" then
				LoadEntities( LoadDir .. "entities/" )
			elseif FileName == "weapons" then
				LoadWeapons( LoadDir .. "weapons/" )
			elseif FileName == "effects" then
				LoadEffects( LoadDir .. "effects/" )
			else	
				ErrorNoHalt("\t\t Invalid entitity dir: " ..LoadDir .. FileName .. "\n" )
			end	
			
		end
	
	end
	
	BasicFolderInclude( LoadDir, FileList )

end

function LoadEntities( LoadDir ) 
	
	if DEBUG then
		Msg("\tEntity " .. LoadDir .. "\n")
	end
	
	local FileList = file.FindDir( LoadDir .. "*", "LUA" )
	
	for _, name in pairs( FileList ) do
		
		if ValidName( name ) then
			
			local Dir = LoadDir .. name .. "/"
			local List = file.Find( Dir .. "*", "LUA" )
			
			if DEBUG then
				print( "\t\t" .. name )
			end
			
			_G.ENT = {}
	
			BasicFolderInclude( Dir , List )
			
			if _G.ENT.Type then
				scripted_ents.Register( _G.ENT, name, false )
			end
			
			_G.ENT = nil
		
		end
		
	end
	
end

function LoadWeapons( LoadDir ) 
	
	if DEBUG then
		Msg("\tWeapons " .. LoadDir .. "\n")
	end
	
	local FileList = file.FindDir( LoadDir .. "*", "LUA" )
	
	for _, name in pairs( FileList ) do
		
		if ValidName( name ) then
			
			local Dir = LoadDir .. name .. "/"
			local List = file.Find( Dir .. "*", "LUA" )
			
			if DEBUG then
				print( "\t\t" .. name )
			end
			
			_G.SWEP = {Primary={}, Secondary={}}

			// No CS:S weapons!
			if _G.SWEP.Base == "weapon_cs_base" then
				_G.SWEP = nil
				continue
			end
	
			BasicFolderInclude( Dir , List )
			
			if _G.SWEP.Base == nil then
				_G.SWEP.Base = "weapon_base"
			end
			
			weapons.Register( _G.SWEP, name, false )
			
			_G.SWEP = nil
		
		end
		
	end
	
end

function LoadEffects( LoadDir )

	if DEBUG then
		Msg("\tEffects " .. LoadDir .. "\n")
	end
	
	local FileList = file.FindDir( LoadDir .. "*", "LUA" )
	
	for _, name in pairs( FileList ) do
		
		if ValidName( name ) then
			
			local EffectFile = LoadDir .. name .. "/init.lua"
			
			if DEBUG then
				print( "\t\t" .. name )
			end
			
			if CLIENT then

				_G.EFFECT = {}
		
				include( EffectFile )
				
				effects.Register( _G.EFFECT, name, false )
				
				_G.EFFECT = nil
			
			else //IF SERVER
				
				AddCSLuaFile( EffectFile )
			
			end
			
		end
		
	end

end

function LoadModulesInOrder()

	// module, has load order
	local ModulesLoadOrder =
	{
		// Load the VERY IMPORTANT extensions and small scripts
		{ "base", false },
		{ "extensions", false },

		// Core
		{ "base/sharedlist", false }, // networking
		{ "base/exnet", true }, // networking
		{ "base/derma", false }, // derma elements
		{ "base/translation", true }, // translation

		{ "base/database", false }, // database

		{ "base/gui", false }, // main tower GUI
		{ "base/store", true }, // stores!
		{ "base/inventory", true }, // inventory
		{ "base/maps", true }, // map definitions
		{ "base/postevents", true }, // post process events
		{ "base/voice", false }, // voice management

		// Modules
		{ "base/chat", true }, // chat
		{ "base/hats", true }, // hats (load stores first)
		{ "base/models", false }, // player models
		{ "base/multiserver", true }, // bread and butta
		{ "base/fakeclient", true }, // fake clients
		{ "base/admin", false }, // admin shit
		{ "base/vip", false }, // vip!
		{ "base/friends", true }, // friends
		{ "base/globalserver", true }, // global server
	}

	for id, mod in ipairs( ModulesLoadOrder ) do
		LoadAsModule( mod[1], mod[2] )
	end

end

function LoadAsModule( dir, hasload )

	if !hasload then
		LoadFolder( dir )
		return
	end

	local LoadDir = BaseDir .. dir .. "/"
	local LoaderDefinition = "sh_loadorder.lua"
	local LoadLua = LoadDir .. LoaderDefinition

	if !file.Exists( LoadLua, "LUA" ) then
		ErrorNoHalt( "Module " .. dir .. " not setup correctly! Must have a " .. LoaderDefinition .. "!\n" )
		return
	end

	SelectiveInclude( dir .. "/", LoaderDefinition )

end

LoadModulesInOrder()