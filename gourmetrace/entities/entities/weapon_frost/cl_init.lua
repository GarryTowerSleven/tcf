include("shared.lua")

function ENT:Think()

	if !IsValid(self) then return end

	local dlight = DynamicLight( self:EntIndex() )
		if ( dlight ) then
		dlight.pos = self:GetPos() + Vector(0,20,0)
		dlight.r = 0
		dlight.g = 255
		dlight.b = 255
		dlight.brightness = 2
		dlight.Decay = 1000
		dlight.Size = 256
		dlight.DieTime = CurTime() + 1
	end

end
