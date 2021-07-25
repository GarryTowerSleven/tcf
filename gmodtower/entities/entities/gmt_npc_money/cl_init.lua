include('shared.lua')

function ENT:Draw()
	self:DrawModel()
	self:SetSequence("pose_standing_01")
	self:SetAnimation(0)
end