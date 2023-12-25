---------------------------------
ENT.Type = "anim"
ENT.Category = "GMTower"

ENT.PrintName = "Portal"
ENT.Spawnable = true

function ENT:SetupDataTables()

    self:NetworkVar( "Vector", 0, "RenderPos" )
    
end