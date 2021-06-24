
-----------------------------------------------------
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