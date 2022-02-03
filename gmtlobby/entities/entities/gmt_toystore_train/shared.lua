local CurveName = "toystore_train"

if SERVER then AddCSLuaFile(CurveName .. "_curve.lua") end 
include(CurveName .. "_curve.lua")

ENT.Type 				= "anim"
ENT.Base 				= "base_anim"

ENT.PrintName			= "Toystore Train"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

ENT.Model				= Model( "models/gmod_tower/pooltube.mdl")
ENT.Curve 				= STORED_CURVES[CurveName]

-- Controls the number of sub-points per node during linearization
-- Higher looks better for large curves, but generates more keypoints and memory usage
ENT.KeysPerNode 		= 10

-- The speed of the train along the track
ENT.Velocity 			= 100
ENT.CarCount			= 10

-- Only use this function because the client and server might implement their own Initialize
function ENT:SetupDataTables()
	/*if not self.Curve then
		print("Failed to load curve \"" .. CurveName .. "\"")
	else */
		-- Linearize the track so we can make it a function of time 
		self.Curve:CalculateKeyPoints( self.KeysPerNode )
	--end
end

local function GetCurveLength(self)
	return self.Curve and self.Curve.KeyPoints[#self.Curve.KeyPoints].TotalDistance
end

function ENT:GetDistance(offset)
	return ((UnPredictedCurTime() * self.Velocity) + (offset or 0)) % GetCurveLength(self)
end

function ENT:GetPosAngle( distanceOffset, num )
	return self.Curve:CalculateLinear(self:GetDistance(distanceOffset), num)
end

--ImplementNW() -- Implement transmit tools instead of DTVars