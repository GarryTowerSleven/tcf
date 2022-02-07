include("shared.lua")
local Sizes =  { 128, 96, 64, 32, 24, 16, 8 }
local Weight = { 900, 900, 500, 500, 500, 500, 500 }
for k, v in pairs( Sizes ) do
	surface.CreateFont( "dos_" .. k, {
		font = "Clear Sans",
		size = v,
		weight = Weight[k]
	} )
end