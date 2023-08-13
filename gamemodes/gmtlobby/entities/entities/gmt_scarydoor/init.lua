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
	if ply:IsPlayer() then

		if ply:GetNWBool("Outside") then
			self:EmitSound( "doors/door1_stop.wav", 75, 100, 1, CHAN_AUTO ) 
			timer.Simple(0.25, function()
				ply:SetNWBool("Outside", false)
				ply:ConCommand( "gmt_updateplayermodel" )
				ply:ConCommand( "gmt_updateplayercolor" )
				ply:ResetSpeeds()
				
				ply:SafeTeleport( Vector(928, -1472, 168 ))
				ply:SetAchievement( ACHIEVEMENTS.SMOOTHDETECTIVE, 1 )
			end)
		end

	end
end
