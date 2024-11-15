include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Sprite = Material( "sprites/powerup_effects" )

function ENT:Initialize()

	self.Bass = 0
	self:GetStream()

end

function ENT:Draw()

	// self:SetColor( colorutil.Rainbow( 9999 ) )

	/*if GTowerMainGui.MenuEnabled then
		self:SetModelScale( 1, 0 )
	end*/

	local size = self.NextScale or 40 * self.Bass / 24
	render.SetMaterial( self.Sprite )
	// render.DrawSprite( self:WorldSpaceCenter() + self:GetUp() * 16 + self:GetForward() * 4, 15 + ( size * 100 ), 15 + ( size * 100 ), colorutil.Rainbow(self.NextScale) )

	self.FT = self.FT or 0
	self.FTSpeed = self.FTSpeed or 0
	self.FTSpeed = Lerp(FrameTime() * (2 + (self.Bass > 4 and 4 or 0)), self.FTSpeed, self.Bass + (self.Bass > 4 and 8 or 0))
	self.FT = self.FT + FrameTime() * self.FTSpeed * Lerp(math.min(self.Bass, 1) / 4, 0, 1)
	self:SetRenderOrigin(self:GetNetworkOrigin() + Vector(0, 0, self.Bass * 4) + self:GetRight() * math.sin(self.FT * 2) * self.Bass * -1 + Vector(0, 0, math.abs(math.sin(self.FT * 2)) * -4 * self.Bass)) // + (self.Bass > 2 && self.Bass * 4 || 0)))
	self:SetRenderAngles(self:GetNetworkAngles() + Angle(self.Bass * 2, math.sin(self.FT * 2) * self.Bass * 4, math.sin(self.FT * 2) * self.Bass * -4))
	self:ManipulateBoneScale(0, Vector(1, 1 + self.Bass * 0.01, 1 + self.Bass * 0.04))
	self:SetModelScale(1 + self.Bass * 0.01 + self.FTSpeed * 0.01)
	self:DrawModel()
	//self:SetRenderOrigin()
	//self:SetRenderAngles()

end

function ENT:InLimit( loc )
	return loc == self:Location()
end

function ENT:Think()
	//print("!")
	local Stream = self:GetStream()
	//print(Stream)
	if not Stream then self.Bass = 0 return end
	if not self:StreamIsPlaying() then
		self.Bass = 0
		return
	end
	local fft = self:GetFFTFromStream()

	if #fft <= 0 then return end
	local b = 0
	for i = 1, 40 do
		b = b + fft[i]
	end

	for i = #fft / 2, #fft do
		b = b + fft[i]
	end

	b = b / (40 + (#fft / 2))
	b = b * 400
	self.Bass = Lerp(FrameTime() * (18 / 2), self.Bass, b)
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