
-----------------------------------------------------
include( "shared.lua" )

ENT.RenderGroup = RENDERGROUP_BOTH
ENT.ModelScale = 0.60
ENT.SpriteMat = Material( "sprites/light_glow02_add" )
ENT.MovementSpeed = 0.080

ENT.SmoothPitch = 0
function ENT:Initialize()

	-- Make the start light angle not POOP
	self.DefaultAngle = self:GetAngles()

	-- Quick fix rotation
	self.DefaultAngle:RotateAroundAxis(self.DefaultAngle:Up(), 90)

	self.VisualizerAlphaFloat = 0.20
end

function ENT:Draw()
	-- If we're rendering the rendertexture, don't draw ourselves in it, we'll just obstruct view
	if LocalPlayer().CurrentCamera == self and LocalPlayer().IsRenderingCamView then return end

	--self:DrawModel()

	-- Light sprite
	local pos = self:GetPos() + self:GetForward() * 11
	local ang = self:GetAngles()
	local scale = 60

	//render.SetMaterial( self.SpriteMat )
	//render.DrawQuadEasy( pos - ang:Forward() * 1, ang:Forward() * 1, scale, scale, self:GetColor() )

end


local function SawFlatWave(x)
	return math.abs((x % 2) - 1);
end

local function SquareWave(x)
	return math.floor(x) % 2
end

function ENT:Think()
	-- Make sure the clientside models exist and all that fun stuff
	self:CheckStaticModel()

	self.SmoothPitch = Lerp(FrameTime()*self.MovementSpeed*25, self.SmoothPitch,SquareWave(CurTime()* self.MovementSpeed))

	-- Set our angles
	local viewAngle = Angle(self.SmoothPitch*20 + 50,
		SawFlatWave(CurTime()*self.MovementSpeed ) * 90 - 180, 0)

	self:SetAngles(self.DefaultAngle + viewAngle)

	-- Set the orientation of the static model
	self.StaticModel:SetPos(self:GetPos())
	self.StaticModel:SetAngles(self.DefaultAngle)

end

function ENT:CheckStaticModel()
	self.StaticModel = IsValid(self.StaticModel) and self.StaticModel or ClientsideModel(self.Model)
end

function ENT:OnRemove()
	if IsValid(self.StaticModel) then self.StaticModel:Remove() end
end
