---------------------------------
include('shared.lua')

function ENT:Draw()
	self:DrawModel()
end

function ENT:Think()
	self:SetSequence("pose_standing_01")
end