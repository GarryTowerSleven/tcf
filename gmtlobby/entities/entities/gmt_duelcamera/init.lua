
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:DrawShadow(false)
    self:SetSolid(SOLID_NONE)
    self:SetMoveType(MOVETYPE_NONE)
    self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )

    local e = ents.Create("info_specialspawn")
    e:SetPos(self:GetPos())
    e:Spawn()

    local e = ents.Create("gmt_duelrot")
    e:SetPos(self:GetPos())
    e:Spawn()

end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:Think()

  if IsValid(self.OurMan) then

    self:SetPos(self.OurMan:GetPos())
    self:SetAngles(Angle(0,0,0))

    if !self.OurMan:GetNWBool("IsDueling") then self.OurMan = nil end

    return
  end

  self.OurMan = nil

  for k,v in pairs(player.GetAll()) do
    if v:GetNWBool("IsDueling") then
      self.OurMan = v
    end
  end

  if !self.OurMan then
    local rot = ents.FindByClass("gmt_duelrot")[1]
    if !IsValid(rot) then return end

	--self:SetPos( rot:GetPos() + Vector( 2000, 0, 0 ) + (rot:GetForward() * -750) + (rot:GetUp() * 5000) )
	--self:SetAngles(Angle(50,0,0))
	self:SetPos( rot:GetPos() + Vector(500,0,3000) + ( self:GetAngles():Forward() * -750 ) + self:GetAngles():Up() )
	self:SetAngles(Angle(35,0,0))

  end

end
