
-----------------------------------------------------
local CurveName = "ball"

if SERVER then AddCSLuaFile(CurveName .. "_curve.lua") end
include(CurveName .. "_curve.lua")

ENT.Type 				= "anim"
ENT.Base 				= "base_anim"

ENT.PrintName			= "Gamemode Port Ball"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

ENT.Model				= Model( "models/gmod_tower/pooltube.mdl")
ENT.Curve 				= STORED_CURVES[CurveName]

-- Controls the number of sub-points per node during linearization
-- Higher looks better for large curves, but generates more keypoints and memory usage
ENT.KeysPerNode 		= 10

-- The speed of the train along the track
ENT.Velocity 			= 500
ENT.CarCount			= 1

ENT.Fuck = false

-- Only use this function because the client and server might implement their own Initialize
function ENT:Initialize()
	self.Curve:CalculateKeyPoints( self.KeysPerNode )
end

local function GetCurveLength(self)
	if !self.Fuck then
		self.Curve:CalculateKeyPoints( self.KeysPerNode )
		self.Fuck = true
	end
	return self.Curve and self.Curve.KeyPoints[#self.Curve.KeyPoints].TotalDistance
end

function ENT:GetDistance(offset)
	return ((UnPredictedCurTime() * self.Velocity) + (offset or 0)) % GetCurveLength(self)
end

function ENT:GetPosAngle( distanceOffset, num )
	return self.Curve:CalculateLinear(self:GetDistance(distanceOffset), num)
end
