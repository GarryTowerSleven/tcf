include('shared.lua')


function ENT:Think()

	if !LocalPlayer():GetPos():WithinDistance(self:GetPos(), 1500) then return end

	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		dlight.pos = self:GetPos() + self:GetForward() * 25 + self:GetUp() * 25
		dlight.r = 95
		dlight.g = 25
		dlight.b = 5
		dlight.brightness = 2
		dlight.Decay = 1000
		dlight.Size = 256
		dlight.DieTime = CurTime() + 1
	end
  
end
