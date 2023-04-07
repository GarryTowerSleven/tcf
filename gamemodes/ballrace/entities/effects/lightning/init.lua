EFFECT.Mat = Material( "effects/laser1" )
EFFECT.NumPoints = 12

EFFECT.BaseColor = Color(255, 255, 255, 255)
EFFECT.LightningColor = Color(255, 255, 255, 255)

function EFFECT:Init( data )
	self.Start = data:GetOrigin()
	self.TargetEntity = data:GetEntity()
	self.RepellerEnt = Entity(data:GetAttachment())
	
	local repels = self.RepellerEnt:GetNWBool( "Repel", false )
	
	self.LightningColor = repels and Color(25, 255, 255, 255) or Color(255, 100, 100, 255)
	
	self.Points = {}
	self:GeneratePoints()
	
	self.Update = RealTime()
end

function EFFECT:GeneratePoints()
	local endpos = self.TargetEntity:LocalToWorld(self.TargetEntity:OBBCenter())
	local diff = endpos - self.Start
	local length = diff:Length()
	diff = diff:GetNormal()
	
	local interval = (length / self.NumPoints)
	
	for i = 1, self.NumPoints do
		self.Points[i] = self.Start + (diff * (interval * i)) + (VectorRand() * math.random(1, 24))
	end
	
	self:SetRenderBoundsWS( self.Start, endpos )
end

function EFFECT:Think( )
	if IsValid(self.TargetEntity) && self.TargetEntity.Links[self.RepellerEnt] then
		
		/*local waveX = math.sin( RealTime() * 32 ) * .075
		local waveY = math.cos( RealTime() * 32 ) * .075
		
		local scale = Vector(1 + waveX, 1 + waveY, 1)

		if IsValid(self.RepellerEnt) then
			local mat = Matrix()
			mat:Scale(scale)
			self.RepellerEnt:EnableMatrix("RenderMultiply", mat)
		end*/

		if RealTime() > self.Update then
			self:GeneratePoints()
			self.Update = RealTime() + 0.01
		end
		return true
	end

	/*if IsValid(self.RepellerEnt) then
		local scale = Vector(1,1,1)

		local mat = Matrix()
		mat:Scale(scale)
		self.RepellerEnt:EnableMatrix("RenderMultiply", mat)
	end*/

	return false 
end

function EFFECT:Render()
	render.SetMaterial(self.Mat)

	render.StartBeam(self.NumPoints + 1)
	
	render.AddBeam(self.Start, 32, CurTime(), self.LightningColor)
	
	for i = 1, self.NumPoints do
		local tcoord = CurTime() + ( 1 / 12 ) * i
		render.AddBeam(self.Points[i], 16, tcoord, self.BaseColor)
	end
	
	render.EndBeam()

	render.StartBeam(self.NumPoints + 1)
	
	render.AddBeam(self.Start, 32, CurTime(), self.LightningColor)
	
	for i = 1, self.NumPoints do
		local tcoord = CurTime() + ( 1 / 12 ) * i
		render.AddBeam(self.Points[i], 48, tcoord, self.LightningColor)
	end
	
	render.EndBeam()
end