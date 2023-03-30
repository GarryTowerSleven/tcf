
include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

util.AddNetworkString("fishTalk")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetSolid(SOLID_BBOX)
    self:SetUseType(SIMPLE_USE)
end

function ENT:Think()
   self:NextThink(CurTime())
end

function ENT:Use(ply)
  if CurTime() < (ply.NextFishTime or 0) then return end
  ply.NextFishTime = (CurTime() + 15)

  ply:Lock()

  timer.Simple(10,function()
    ply:UnLock()
  end)

  net.Start( "fishTalk" )
    net.WriteBool( hasAchi )
  net.Send( ply )
end
