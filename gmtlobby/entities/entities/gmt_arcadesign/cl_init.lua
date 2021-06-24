
-----------------------------------------------------
include( "shared.lua" )

ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.SpinSpeed = 20

function ENT:Draw()

	self:DrawModel()

end

function ENT:Think()
	self:SetAngles(Angle(0,CurTime() * self.SpinSpeed,0))
end