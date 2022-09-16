AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:CustomInit()

	self:SetPos(self:GetPos() + Vector(0,0,5))
	self:SetAngles(self:GetAngles() + Angle(0,180,0))

end

function ENT:CustomTouch( ply )

	ply:SetVelocity(Vector(-700,0,255))
	self:SetTrigger(false)
	self:SetModelScale(0,0.25)

end
