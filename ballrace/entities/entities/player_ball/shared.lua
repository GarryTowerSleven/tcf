ENT.Type 			= "anim"
ENT.Base			= "base_anim"

ENT.RenderGroup 	= RENDERGROUP_TRANSLUCENT

ENT.RollSound		= Sound( "GModTower/balls/BallRoll.wav" )

function ENT:Center()
	local attach = self.Entity:LookupAttachment("gmt_ball_center")

	if attach > 0 then
		local attach = self.Entity:GetAttachment(attach)
		return attach.Pos
	end

	return self:LocalToWorld(self:OBBCenter())
end