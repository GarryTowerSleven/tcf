
----------------------------------------------------------

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
  self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )

	self:SetTrigger(true)

	self:SetPos(self:GetPos() + Vector(0,0,5))
	self:SetAngles(self:GetAngles() + Angle(0,180,0))

end

function ENT:StartTouch(ply)
    if ply:IsPlayer() and self:GetOwner() != ply and !ply:GetNWBool("Invincible") then

			self:GetOwner():AddAchivement(ACHIVEMENTS.GROFFYOUGO,1)

			ply:SetVelocity(Vector(-700,0,255))
			self:SetTrigger(false)
			self:SetModelScale(0,0.25)
			ply:EmitSound("gmodtower/gourmetrace/actions/spike_hit.wav",80)
			timer.Simple(0.25,function()
				self:Remove()
			end)
    end
end
