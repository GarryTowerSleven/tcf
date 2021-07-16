include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Sprite = Material( "sprites/powerup_effects" )

function ENT:Initialize()

	self.NextRandomLazers = 0
	self.NextScale = 0.2

	self:GetStream()

end

function ENT:Draw()
	self:DrawModel()
	self:SetColor( colorutil.Rainbow( 50 ) )

	/*if GTowerMainGui.MenuEnabled then
		self:SetModelScale( 1, 0 )
	end*/

	local size = self.NextScale or .1
	render.SetMaterial( self.Sprite )
	render.DrawSprite( self:GetPos(), 15 + ( size * 100 ), 15 + ( size * 100 ), colorutil.Rainbow(self.NextScale) )

end

function ENT:InLimit( loc )
	return loc == self:Location()
end

function ENT:Think()

	local Stream = self:GetStream()
	if not Stream then return end

	-- Lasers
	if CurTime() > self.NextRandomLazers then
	
		local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() )
			effectdata:SetEntity( self )
			effectdata:SetMagnitude( 5.0 + math.Rand(-1,1) )
		util.Effect( "disco_light", effectdata )
		
		self.NextRandomLazers = CurTime() + 0.25 + math.Rand( -0.15, 0.15 )

	end

	-- Visualizers
	self:UpdateStreamVals( Stream )

end

function ENT:UpdateStreamVals( Stream )

	if not self:StreamIsPlaying() then
		self:SetModelScale( 1, 0 )
		self.NextScale = 0.2
		return
	end
	
	local Bands = self:GetFFTFromStream()
	
	local Max = 0
	local Sum = 0
	local Total = 40
	
	if Bands then
		for i=1, Total do
			Max = math.max( Max, Bands[i] )
			Sum = Sum + Bands[i]
		end
	end
	
	local Avg = Sum/Total
	
	self.NextScale = 0.5 + math.Clamp( ( Avg / Max ) * 0.8, 0, 0.8 )
	self.NextScale = math.Clamp( self.NextScale, .1, 3 )
	self:SetModelScale( self.NextScale, 0 )
	
end