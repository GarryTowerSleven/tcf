
-----------------------------------------------------
include( "shared.lua" )

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.SpinSpeed = 20

ENT.Alpha = 255

function ENT:Initialize()
    self.StartTime = CurTime() + 3
end

function ENT:Draw()
	--self:DrawModel()

	if !self.CSModel then self.CSModel = ClientsideModel(self.Model,RENDERGROUP_OTHER) end

	if !IsValid(self.CSModel) then return end

  if !self.OGAng then self.OGAng = self:GetAngles() end

  local offset = Vector(0,0,2)
  if self:GetNWBool("Bouncing") then offset = Vector(0,0,0) self.OGAng = self:GetAngles() end

	self.CSModel:SetRenderMode(RENDERMODE_TRANSALPHA)
	self.CSModel:SetPos(self:GetPos() - offset)
	self.CSModel:SetAngles(self.OGAng)

	local redScale = 255

	if self.Fading then
		self.Alpha = self.Alpha - (FrameTime() * 125)
		redScale = 55
	end

	if self.Alpha < 0 then self.Alpha = 0 end

	self.CSModel:SetColor( Color( 255, redScale, redScale, self.Alpha ) )

end

function ENT:OnRemove()
		if IsValid(self.CSModel) then
	    self.CSModel:Remove()
		end
end

function ENT:Think()
	if CurTime() > self.StartTime then
		self.Fading = true
	end
end
