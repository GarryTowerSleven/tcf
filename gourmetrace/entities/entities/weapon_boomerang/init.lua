
----------------------------------------------------------

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

local Wait = false

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
  self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )

	self:SetTrigger(true)

	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:EnableGravity(false)
		phys:SetVelocity(self.Owner:GetForward()*750)
		self:SetLocalAngularVelocity( Angle(1200,0,0) )
	end

	self:SetPos(self:GetPos() + Vector(0,0,20))
	self:SetAngles(self:GetAngles() + Angle(0,180,0))

	self:SetVelocity(Vector(200,0,0))

	timer.Simple(2,function()
		if IsValid(self) then
			self:SetTrigger(false)
			self:SetModelScale(0,0.25)
			timer.Simple(0.25,function()
				self:Remove()
			end)
		end
	end)

end

function ENT:StartTouch(ply)
    if ply:IsPlayer() and self:GetOwner() != ply and !ply:GetNWBool("Invincible") then

			self:GetOwner():AddAchivement(ACHIVEMENTS.GROFFYOUGO,1)

			ply:SetVelocity(Vector(0,0,255))
			self:SetTrigger(false)
			self:SetModelScale(0,0.25)
			ply:EmitSound("gmodtower/gourmetrace/actions/spike_hit.wav",80)
			timer.Simple(0.25,function()
				self:Remove()
			end)
    end
end
