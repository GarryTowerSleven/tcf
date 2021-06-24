
include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

ENT.StartPos = Vector(0,0,0)

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetSolid(SOLID_VPHYSICS)
    self.StartPos = self:GetPos()

    self.Speed = math.random(3000,5000)

end

function ENT:Think()
    self:SetPos( self:GetPos() - Vector(0, FrameTime() * self.Speed ,0) )

    self:SetAngles(Angle(0,-90,0))

    if self:GetPos().y < 0 then
      self:SetPos(self.StartPos)
    end
end
