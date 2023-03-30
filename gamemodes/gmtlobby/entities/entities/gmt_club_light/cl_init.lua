
include( "shared.lua" )

ENT.RenderGroup = RENDERGROUP_BOTH

ENT.Sensitivity = 800
ENT.SpriteMat = Material( "sprites/light_glow02_add" )

ENT.MinTransparency = 0.10 
ENT.TransparencySensitivity = 20

function ENT:Initialize()

	-- Make the start light angle not POOP
	self.DefaultAngle = self:GetAngles() + Angle(60,180,0)
end

function ENT:Draw()

	self:DrawModel()

	local Controller = self:GetOwner()
	if not IsValidController( Controller ) then return end

	-- Light sprite
	local pos = self:GetPos() + self:GetForward() * 20
	local ang = self:GetAngles()
	local scale = 100 + ( Controller:GetSmoothedAverage("bass") * 500 )

	render.SetMaterial( self.SpriteMat )
	render.DrawSprite( pos, 20, scale, self.Color )
	render.DrawQuadEasy( pos - ang:Forward() * 1, ang:Forward() * 1, scale, scale, self.Color )

end

local tempLightModes = {}
tempLightModes["2648.000000 -4900.000000 -2384.000000"] = 1
tempLightModes["2648.000000 -4956.000000 -2384.000000"] = 4
tempLightModes["2648.000000 -5020.000000 -2384.000000"] = 3
tempLightModes["2648.000000 -5088.000000 -2384.000000"] = 2
tempLightModes["2648.000000 -5156.000000 -2384.000000"] = 3
tempLightModes["2648.000000 -5212.000000 -2384.000000"] = 4
tempLightModes["2648.000000 -5276.000000 -2384.000000"] = 1

function ENT:GetLightMode()
	return tempLightModes[tostring(self:GetPos())]
end

function ENT:Think()
	-- Make sure the clientside models exist and all that fun stuff
	self:CheckSupportModel()

	local Controller = self:GetOwner()
	if !IsValid(Controller) then
		for k,v in pairs( ents.FindByClass("gmt_club_dj") ) do
			if IsValid(v) then self:SetOwner(v) end
		end
	end

	if not IsValidController( Controller ) then 
		self.VisualizerAlphaFloat = 0
		return 
	end

	-- Set the glow color before calling the lightmode function, in case they want to override it
	local bassUnweighted = Controller:GetSmoothedAverage("bass")
	self.Color = Controller:GetThemeColor(bassUnweighted * self.Sensitivity)
	self.VisualizerGlowVector = self.Color:ToVector()

	-- Set the transparency
	local totalUnweighted = Controller.TotalAverage
	self.VisualizerAlphaFloat = self.MinTransparency + self.TransparencySensitivity * totalUnweighted

 
	if IsValid(Controller:GetStream()) then			
		-- Perform the current light mode
		local mode = self.LightModes[self:GetLightMode()]
		if mode and mode.Function then 
			mode.Function( self )
		end
	else
		-- If there's no stream playing, reset to a default angle
		self:SetAngles( LerpAngle(math.min(FrameTime(), 1), self:GetAngles(), self.DefaultAngle ) )
	end

	-- Set the orientation of the support model
	self.SupportModel:SetPos(self:GetPos())
	self.SupportModel:SetAngles(Angle(0, self:GetAngles().y, 0))

end

function ENT:CheckSupportModel()
	self.SupportModel = IsValid(self.SupportModel) and self.SupportModel or ClientsideModel(self.SupportPath)
end

-- Material proxy for transparency of the light
matproxy.Add( {
	name = "LightTransparency",
	init = function( self, mat, values )
		self.ColorVar = values.resultvar 
	end,

	bind = function( self, mat, ent )
		if ent and ent.VisualizerAlphaFloat then
			mat:SetFloat(self.ColorVar, ent.VisualizerAlphaFloat)
		end
	end
})