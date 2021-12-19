include("shared.lua")

function ENT:Draw()

	// lets not draw on maps that haven't been fixed yet
	if Maps.IsMap( "gmt_ballracer_skyworld" ) || Maps.IsMap( "gmt_ballracer_grassworld" ) then return end

	self:DrawModel()

	if LocalPlayer():Team() == TEAM_PLAYERS then
		local ang = LocalPlayer():EyeAngles()
		self:SetAngles( Angle( 0, ang.y, 0 ) )
	end
	
	self:SetPos( self:GetPos() + self:GetAngles():Up() * math.sin( CurTime() * 3 ) * 0.2 )

end