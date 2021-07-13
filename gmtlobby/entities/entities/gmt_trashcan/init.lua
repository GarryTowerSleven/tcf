
include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

util.AddNetworkString("trashcan")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetSolid(SOLID_BBOX)
    self:SetUseType(SIMPLE_USE)
end

function ENT:Use(ply)

  if self.NO then return end

  self.NO = true

  net.Start("trashcan")
    net.WriteEntity(self)
  net.Broadcast()

  timer.Simple(5,function()
    local e = ents.Create("gmt_trashcan")
    e:SetPos(self:GetPos())
    e:SetAngles(self:GetAngles())
    e:Spawn()
    self:Remove()
  end)

end
