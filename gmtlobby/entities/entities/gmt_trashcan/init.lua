
include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

util.AddNetworkString("trashcan")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetSolid(SOLID_BBOX)
    self:SetUseType(SIMPLE_USE)

    -- Deluxify the model
    self:SetMaterial("models/map_detail/plaza_trashcan_d", true)
end

function ENT:Use(ply)

  if self.NO then return end

  self.NO = true

  ply:AddAchivement( ACHIVEMENTS.TRASHMAN, 1 )

  if math.random( 1, 10 ) == 1 then
    ply:AddMoney( math.random( 1, 5 ) )
    ply:Msg2( "You found some cash in the trashcan, nice!" )
  end

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
