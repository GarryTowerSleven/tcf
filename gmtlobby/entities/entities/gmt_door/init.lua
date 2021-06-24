
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("LoadingDoor")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetSolid(SOLID_VPHYSICS)
    self:DrawShadow(false)
    self:SetUseType(SIMPLE_USE)
end

function ENT:IsRoulette()
  return self:GetModel() == "models/map_detail/firework_door.mdl"
end

function ENT:Use(ply)

  if ply.UsingDoor then return end

  for k,v in pairs(ents.FindByClass("info_teleport_destination")) do
    if tostring( v:GetName() ) == self.TeleportName then
      self.TeleportEnt = v
    end
  end

  if !IsValid(self.TeleportEnt) then return end

  ply.UsingDoor = true
  ply:Freeze(true)

  self:EmitSound( self:IsRoulette() and self.OpenSoundRoulette or self.OpenSound, 80 )

  local OpenSeq = self:LookupSequence("open")
  local CloseSeq = self:LookupSequence("close")

  self:ResetSequence(OpenSeq)

  timer.Simple( ( self:IsRoulette() and 4 or 0 ), function()
    net.Start("LoadingDoor")
    net.WriteEntity(self)
    net.Send(ply)

    timer.Simple( (self.DelayTime + self.WaitTime) ,function()
      ply.UsingDoor = false
      ply:Freeze(false)

      ply:EmitSound( self:IsRoulette() and self.CloseSoundRoulette or self.CloseSound, 80 )

      self:ResetSequence(CloseSeq)

      if self.TeleportName == "secret_exit2" then ply:AddAchivement(ACHIVEMENTS.WTF, 1) end

      if ( ply.BallRaceBall && IsValid(ply.BallRaceBall) ) then
        ply.BallRaceBall:SetAngles(self.TeleportEnt:GetAngles())
        ply:SetEyeAngles(self.TeleportEnt:GetAngles())
        ply.BallRaceBall:SetPos( self.TeleportEnt:GetPos() + Vector(0,0,35) )
      else
        ply:SetEyeAngles(self.TeleportEnt:GetAngles())
        ply.DesiredPosition = self.TeleportEnt:GetPos()
      end
    end)
  end)

end

function ENT:KeyValue( key,value )
  if key == "model" then self.Model = value end
  if key == "modelscale" then self:SetModelScale(tonumber(value)) end
  if key == "skin" then self:SetSkin(tonumber(value)) end
  if key == "teleportentity" then self.TeleportName = value end
end
