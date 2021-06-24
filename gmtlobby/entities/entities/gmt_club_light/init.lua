
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetSolid(SOLID_NONE)
    self:DrawShadow(false)
end

function ENT:Think()
  if !self.NextPlayer then self.NextPlayer = CurTime() end
  if CurTime() > self.NextPlayer then
    self.NextPlayer = CurTime() + 10

    local Controller = self:GetOwner()

    if !IsValid(Controller) then
      for k,v in pairs( ents.FindByClass("gmt_club_dj") ) do
        if IsValid(v) then self:SetOwner(v) end
      end
    end

    if !IsValid(Controller:GetMediaPlayer()) then return end

    if !Controller:GetMediaPlayer():IsPlaying() then return end

    local tbl = {}

    for k,v in pairs( player.GetAll() ) do
      if v.GLocation == 26 then
        table.insert(tbl, v)
      end
    end

    self:SetTrackedEntity( table.Random(tbl) )

  end
end
