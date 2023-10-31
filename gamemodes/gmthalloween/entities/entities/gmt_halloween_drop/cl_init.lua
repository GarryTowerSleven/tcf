include("shared.lua")

ENT.SpriteMat = Material( "sprites/light_glow02_add" )

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()

	self:SetModelScale(.8)

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
	render.SetMaterial( self.SpriteMat )
	render.DrawSprite( self:GetPos(), 28, 28, colorutil.Rainbow(50) ) 
end

function ENT:Think()

	if !self.OriginPos then return end

	local rot = self:GetAngles()
	rot.y = rot.y + 110 * FrameTime()

	self:SetAngles(rot)	
	self:SetRenderAngles(rot)

	if !self.TimeOffset then
		self.TimeOffset = math.Rand( 0, 3.14 )
	end

	local SinTime = math.sin( CurTime() + self.TimeOffset )
	self:SetRenderOrigin( self.OriginPos + Vector(0,0, 35 +  SinTime * 4 ) )

end
