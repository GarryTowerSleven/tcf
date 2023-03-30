
include( "shared.lua" )

local TopBone = "speaker_top"
local BottomBone = "speaker_bottom"

-- The speaker is at a slight angle, we need to account for that
ENT.SpeakerAngle = Angle( 0, 0, -10.38)

ENT.TopSensitivity = 200
ENT.BottomSensitivity = 120

ENT.TopShakeSensitivity = 0.30
ENT.BottomShakeSensitivity = 0.01

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

	local trebleSize = Controller:GetSmoothedAverage("treble", true) * self.TopSensitivity
	local bassSize = Controller:GetSmoothedAverage("bass", true) * self.BottomSensitivity
	Controller:SetSmoothAmount("treble", 15)

	-- Add a bit of vibration to the scale
	local topShakeScale =  trebleSize * self.TopShakeSensitivity - 0.5
	local bottomShakeScale = ( Vector(1,1,1)) * trebleSize * self.BottomShakeSensitivity + Vector(1,1,1)


	local topBonePos = Vector( 0, -trebleSize * self.TopShakeSensitivity, 0)
	topBonePos:Rotate(self.SpeakerAngle)

	self:ManipulateBonePosition( self.TopBoneID, topBonePos)

	-- Manipulate the scale of the top one
	self:ManipulateBoneScale( self.TopBoneID, Vector(1,1,1))

	-- Manipulate the scale of the bottom one
	self:ManipulateBoneScale( self.BottomBoneID,  bottomShakeScale)
end