
-----------------------------------------------------
include('shared.lua')

function ENT:Draw()

	if self:GetSkin() == 1 then

		self:DrawModel()
		self:SetModel("models/map_detail/condo_blinds.mdl")

	elseif self:GetSkin() == 2 then

		self:DrawModel()
		self:SetModel("models/map_detail/condo_blinds_closed.mdl")

	end

end
