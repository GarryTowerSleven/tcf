AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

ENT.ExpireTime = 0
ENT.Touched = false

function ENT:CustomInit()

end

function ENT:Initialize()

	self:SetModel(self.Model)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )

	self:SetTrigger(true)

	self:CustomInit()

end

function ENT:CustomTouch( ply )

end

function ENT:StartTouch( ply )

    if ply:IsPlayer() and self:GetOwner() != ply and !ply:GetNet( "Invincible" ) then

		self:GetOwner():AddAchievement(ACHIEVEMENTS.GROFFYOUGO,1)

		self.Touched = true
		self:CustomTouch( ply )

		ply:EmitSound("gmodtower/gourmetrace/actions/spike_hit.wav",80)

    end

end

function ENT:Think()

	if self.Touched && self.ExpireTime < CurTime() then
		self:Remove()
	end

end
