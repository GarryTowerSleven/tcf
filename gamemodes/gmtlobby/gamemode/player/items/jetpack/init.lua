AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

module("jetpack")

function GetJetpack( ply )
	local Jetpack = ply:GetEquipment( "Jetpack" )

	if Jetpack && Jetpack:IsValid() then
		return Jetpack
	end
end