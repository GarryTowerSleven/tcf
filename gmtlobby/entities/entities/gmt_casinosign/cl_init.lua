
-----------------------------------------------------
include( "shared.lua" )

ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.SpinSpeed = 20

function ENT:Draw()

	self:DrawModel()

end

function ENT:Think()
	--self:DrawLight()
end

function ENT:DrawLight()
	local upMovement = (math.cos( CurTime() * 10 ) * 75)
	local sideMovement = (math.sin( CurTime() * 10 ) * 100)
	local dlight = DynamicLight( self:EntIndex() )

	local offset = Vector(-sideMovement, 0, upMovement )

	if self:GetAngles() == Angle(0,0,0) then
		offset = Vector(0, sideMovement, upMovement )
	end

	if ( dlight ) then
		dlight.pos = self:GetPos() + (self:GetForward() * 75) + offset
		dlight.r = 255
		dlight.g = 182
		dlight.b = 65
		dlight.brightness = 3
		dlight.Decay = 1000
		dlight.Size = 300
		dlight.DieTime = CurTime() + 1
	end
end
