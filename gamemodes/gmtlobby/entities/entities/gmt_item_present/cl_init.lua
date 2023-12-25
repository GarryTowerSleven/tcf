include( "shared.lua" )

surface.CreateFont( "ChristmasPresent", {
	size = 64
} )

surface.CreateFont( "ChristmasPresent2", {
	size = 48
} )

surface.CreateFont( "ChristmasPresent3", {
	size = 40
} )

function ENT:Draw()

	self:SetModelScale( 1.4 or 1.4 + math.sin( CurTime() * 8 ) * 0.01 )

	self:SetRenderOrigin( self:GetNetworkOrigin() + Vector( 0, 0, 8 + math.sin( CurTime() * 4 ) * 2 ) )
	self:SetRenderAngles( Angle( math.sin( CurTime() * 4 ) * 8, self:GetAngles().y + FrameTime() * 32, math.sin( CurTime() * 8 ) * 8 ) )

	self:SetModelScale( self:GetModelScale() + 0.01 )
	render.CullMode(MATERIAL_CULLMODE_CW)
	render.SetLightingMode( 1 )

	local rgb = self.Color || colorutil.Rainbow( 64 )

	render.SetColorModulation( rgb.r / 255, rgb.g / 255, rgb.b / 255 )
	self:SetMaterial("models/debug/debugwhite")
	self:DrawModel()
	self:SetMaterial()
	render.SetColorModulation( 1 + rgb.r / 64, 1 + rgb.g / 64, 1 )
	render.SetLightingMode( 0 )
	render.CullMode(MATERIAL_CULLMODE_CCW)

	self:SetModelScale( self:GetModelScale() - 0.01 )
	self:DrawModel()
	self:UpdateShadow()

end

function ENT:GetShadowCastDirection( shadowType )

	return Vector(math.sin( CurTime() / 2 ) * 0.5, math.sin( CurTime() ) * 0.5, -1 )

end

function ENT:Think()

	local s = math.Remap( math.sin( CurTime() * 8 ), -1, 1, 0, 1 )

	self.Color = Color( Lerp( s, 0, 255 ), Lerp( s, 255, 0 ), 0 )

	local light = DynamicLight( self:EntIndex() )

	if light then

		light.Pos = self:GetNetworkOrigin() + Vector( 0, 0, 24 )
		light.Brightness = 2
		light.DieTime = CurTime() + 0.01
		light.Decay = 1
		light.Size = 128

		light.r = Lerp( s, 0, 255 )
		light.g = Lerp( s, 255, 0 )
		light.b = 0

	end

end

ENT.WantsTranslucency = true

local glow = Material( "sprites/glow04_noz" )

function ENT:DrawTranslucent()

	local s = math.Remap( math.sin( CurTime() * 8 ), -1, 1, 0, 1 )

	render.SetMaterial( glow )
	render.DrawSprite( self:GetRenderOrigin() + self:GetUp() * 18, 128, 128, Color( Lerp( s, 0, 255 ), Lerp( s, 255, 0 ), 0, 100 ) )

	local ang = EyeAngles()

	ang:RotateAroundAxis( ang:Right(), 90 )
	ang:RotateAroundAxis( ang:Up(), -90 )

	self.Emitter = self.Emitter || ParticleEmitter( self:GetPos() )

	local dir = Angle( math.random( -20, 20 ), math.random( -180, 180 ) )
	local part = self.Emitter:Add( "sprites/glow04_noz", self:WorldSpaceCenter() + dir:Forward() * 16 )

	if part then

		part:SetDieTime( 1 )

		part:SetStartAlpha( 255 )
		part:SetEndAlpha( 0 )

		part:SetStartSize( 8 )
		part:SetEndSize( 2 )

		part:SetVelocity( dir:Forward() * 24 )
		part:SetGravity( Vector( 0, 0, 22 ) )

		local c = self.Color || colorutil.Rainbow( 128 )
		part:SetColor( c.r, c.g, c.b )

	end

end