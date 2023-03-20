ENT.Base = "base_point"
ENT.Type = "point"

function ENT:Initialize()
    local ent = ents.Create( "gmt_casino_slotmachine" )
    ent:SetPos( self:GetPos() )
    ent:SetAngles( self:GetAngles() )
    ent:Spawn()

    self:Remove()
end