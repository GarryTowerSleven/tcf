
ENT.Type = "anim"
ENT.Category = "GMTower"

ENT.PrintName = "Reindeer Pet"
ENT.Spawnable = true

function ENT:SetupDataTables()

	self:NetworkVar( "String", 0, "PetName" )

end