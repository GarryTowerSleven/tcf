AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.rouletteExit = false
function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:DrawShadow(false)
end

function ENT:Use(ply)
	if ply:GetNWBool("Outside") then

		ply:SetNWBool("Outside", false)
		ply:SetNWBool("ForceModel", false)
		ply:ConCommand( "gmt_updateplayermodel" )
		ply:ResetSpeeds()
		
		ply:SafeTeleport( Vector(928, -1472, 168 ))
		ply:SetAchievement( ACHIEVEMENTS.SMOOTHDETECTIVE, 1 )
	end
end
