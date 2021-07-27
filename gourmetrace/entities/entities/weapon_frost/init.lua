
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

	self:SetPos(self:GetPos() + Vector(0,0,10))
	self:SetAngles(self:GetAngles() + Angle(0,-90,0))

end

function ENT:StartTouch(ply)
    if ply:IsPlayer() and self:GetOwner() != ply and !ply:GetNWBool("Invincible") then

			self:GetOwner():AddAchievement(ACHIEVEMENTS.GROFFYOUGO,1)

			timer.Create("ForceWalk",0.1,50,function() // Try making players go slow or be slippery in Gourmet Race. It won't work...
				if ply:GetNWBool("Invincible") then
					ply:ConCommand("-walk")
				else
					ply:ConCommand("+walk")
				end
			end)
			timer.Simple(5.5,function()
				ply:ConCommand("-walk")
			end)

			self:SetTrigger(false)
			self:SetNoDraw(true)
			self:Remove()
    end
end
