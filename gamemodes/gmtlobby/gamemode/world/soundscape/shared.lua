AddCSLuaFile()

local path = "rules/"
local defaultRules = 
{
	"playrandom",
	"playlooping",
	"playrandom_bass",
	"playlist",
	--"playsoundscape"
}

-- Load in our default rules now
do
	for _, rule in pairs(defaultRules) do
		local f = path .. rule .. ".lua"

		if SERVER then
			AddCSLuaFile(f)
		else
			RULE = {}

			include(f)
			soundscape.RegisterRule(RULE)

			RULE = nil
		end

	end
end

// Loading
local function Load()
	local map = "lobby1"
	local basedir = "gmtlobby/gamemode/world/soundscape/maps/"

	local files = {
		"cl_soundscape_music.lua",
		"cl_soundscape_songlengths.lua",
		"cl_soundscape.lua",
	};

	for _, v in ipairs( files ) do
		local path = basedir .. map .. "/" .. v

		if ( file.Exists( path, "LUA" ) ) then
			if SERVER then
				AddCSLuaFile( path )
			else
				LogPrint( "Loading soundscapes file: " .. v, color_green, "Soundscapes" )
				include( path )
			end
		end
	end
end

Load()