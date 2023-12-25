
-----------------------------------------------------
ENT.Type = "anim"

ENT.Base = "base_anim"


ENT.Model = Model("models/gmod_tower/fedorahat.mdl")


function ENT:SetupDataTables()

    self:NetworkVar( "Bool", 0, "Custom" )

end