include("shared.lua")

ENT.SpriteMat = Material( "sprites/light_glow02_add" )
ENT.SpriteMat2 = Material("decals/messages/gear")

ENT.RenderGroup 	= RENDERGROUP_BOTH

function ENT:Initialize()

	timer.Simple( .1, function()

		if IsValid( self ) then
			self.OriginPos = self:GetPos()
		end

	end )

end

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	render.SetMaterial( self.SpriteMat2 )
	render.DrawSprite( self:GetPos() + Vector(0,0,10), 50, 50, Color(255,255,255) ) 
	render.SetMaterial( self.SpriteMat )
	render.DrawSprite( self:GetPos(), 50, 50, colorutil.Rainbow(50) ) 
end

function ENT:Think()

	if !self.OriginPos then return end

	local rot = self:GetAngles()
	rot.y = rot.y + 90 * FrameTime()

	self:SetAngles(rot)	
	self:SetRenderAngles(rot)

	if !self.TimeOffset then
		self.TimeOffset = math.Rand( 0, 3.14 )
	end

	local SinTime = math.sin( CurTime() + self.TimeOffset )
	self:SetRenderOrigin( self.OriginPos + Vector(0,0, 35 +  SinTime * 4 ) )

end
