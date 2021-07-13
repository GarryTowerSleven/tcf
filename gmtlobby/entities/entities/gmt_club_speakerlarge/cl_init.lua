
include( "shared.lua" )

local TopBone = "speaker_top"
local BottomBone = "speaker_bottom"
local GlowProxyName = "SpeakerGlowColor"

ENT.BottomSensitivity = 3
ENT.GlowSensitivity = 30

function ENT:Initialize()
	self.TopBoneID = self:LookupBone( TopBone )
	self.BottomBoneID = self:LookupBone(BottomBone)
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:Think()
	local Controller = self:GetOwner()
	if !IsValid(Controller) then
		for k,v in pairs( ents.FindByClass("gmt_club_dj") ) do
			if IsValid(v) then self:SetOwner(v) end
		end
	end
	if not IsValidController( Controller ) then return end

	local bassSize = Controller:GetSmoothedAverage("bass", true) * self.BottomSensitivity

	-- Add a bit of vibration to the scale
	local bottomShakeScale = ( Vector(1,1,1)) * bassSize + Vector(1,1,1)

	-- Manipulate the scale of the top one
	self:ManipulateBoneScale( self.TopBoneID, bottomShakeScale)
	self:ManipulateBonePosition( self.TopBoneID,  Vector(0,bassSize*30,0))

	-- Manipulate the scale of the bottom one
	self:ManipulateBoneScale( self.BottomBoneID,  bottomShakeScale)
	self:ManipulateBonePosition( self.BottomBoneID,  Vector(0,bassSize*30,0))

	-- Now set the glow color
	local bassUnweighted = Controller:GetSmoothedAverage("bass")
	color = Controller:GetThemeColor()

	color = colorutil.Brighten( color, self.GlowSensitivity * bassUnweighted )
	self.VisualizerGlowVector = color:ToVector() 
end