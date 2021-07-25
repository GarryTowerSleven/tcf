include('shared.lua')

function ENT:Draw()
	self:DrawModel()
	self:SetSequence(2)
	self:SetAnimation(0)
end

function ENT:Think()
	self:SetSequence(2)
	self:SetAnimation(0)
end