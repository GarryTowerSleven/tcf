ENT.Base = "base_entity"
ENT.Type = "point"

function ENT:Initialize()
	self:DrawShadow( false )
	self:SetNotSolid(true)
end