AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:Activate()
	
	local phys = self:GetPhysicsObject()

	if(phys:IsValid()) then

		phys:EnableMotion(false)

	end
end

util.AddNetworkString("ObamaSmashed")


function ENT:OnTakeDamage(dmg)
    if self.DMG then return end
    self.DMG = true
	net.Start("ObamaSmashed")
    net.WriteVector(self:GetPos())
    net.WriteAngle(self:GetAngles())
    local ply = Entity(1)
    dmg:SetAttacker(ply)
    net.WriteVector(Vector(0, 0, (dmg:GetAttacker():GetEyeTrace().HitPos.z - self:GetPos().z) - 8))
	net.WriteAngle(dmg:GetAttacker():EyeAngles())
    net.Broadcast()

    timer.Simple(0, function()
    	self:Remove()
    end)
end
