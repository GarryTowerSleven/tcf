
-----------------------------------------------------
include('shared.lua')

ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Sprite = Material( "sprites/powerup_effects" )

function ENT:Initialize()
end

function ENT:Think()

	local dlight = DynamicLight( self:EntIndex() )
	if dlight then
		dlight.Pos = self:GetPos() + self:GetUp() * 12
		dlight.r = 185
		dlight.g = 122
		dlight.b = 87
		dlight.Brightness = .5
		dlight.Decay = 2048
		dlight.size = 1024
		dlight.DieTime = CurTime() + .5
	end

end

function ENT:Draw()

	self:DrawModel()
	self:SetModelScale( .65, 0 )
	self:CreateShadow()

	local size = SinBetween( .5, 1, RealTime() * 12 ) * 180
	render.SetMaterial( self.Sprite )
	render.DrawSprite( self:GetPos() + VectorRand():GetNormal() * 2, size, size, Color( 185, 122, 87 ) )

	// Rotation
	local rot = self:GetAngles()
	rot.y = rot.y + 90 * FrameTime()

	self:SetAngles(rot)	
	self:SetRenderAngles(rot)

end

function ENT:DrawTranslucent()
end