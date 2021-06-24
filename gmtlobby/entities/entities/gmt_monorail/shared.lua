
----------------------------------------------------

local CurveName = "monorail"

if SERVER then AddCSLuaFile(CurveName .. "_curve.lua") end
include(CurveName .. "_curve.lua")

ENT.Type              = "anim"
ENT.Base              = "base_anim"
ENT.PrintName         = "Monorail"
ENT.Information       = "Floatin train"

ENT.Spawnable         = false
ENT.AdminSpawnable    = false

ENT.Model             = Model("models/map_detail/monorail_d.mdl")
ENT.ModelFront        = Model("models/map_detail/monorailend_d.mdl")
ENT.Curve 				    = STORED_CURVES[CurveName]

ENT.StartPostion      = Vector( 8940, 0, -340 )
ENT.FakeOrigin        = Vector( 0, 0, 2060 )

ENT.PlayerHeight      = Vector(0,0,64)
ENT.ViewOffset        = Vector(0,0,4040)

-- Controls the number of sub-points per node during linearization
-- Higher looks better for large curves, but generates more keypoints and memory usage
ENT.KeysPerNode 	= 10

-- The speed of the train along the track
ENT.Velocity 			     = 350
ENT.VelocityChangeRate = 1

ENT.Acceleration = 1
ENT.TargetAcceleration = 1

ENT.CarCount			     = 2

ENT.CalculatedKeyPoints = false

function ENT:GetPlayerOffset(ply)

  local plyOffset = self.FakeOrigin - ply:EyePos() + Vector(0,0,5)

  local pos = self:GetPos()
  local ang = self:GetAngles()

  // Multiply the player position relative to the monorail.
  local newVec =
    pos
    - ( Monorail:GetForward() * plyOffset.x )
    - ( Monorail:GetRight() * -plyOffset.y )
    - ( Monorail:GetUp() * plyOffset.z )
    + ( Monorail:GetUp() * 18 )

  return newVec
end

local function GetCurveLength(self)
	if !self.CalculatedKeyPoints then
		self.Curve:CalculateKeyPoints( self.KeysPerNode )
		self.CalculatedKeyPoints = true
	end
	return self.Curve and self.Curve.KeyPoints[#self.Curve.KeyPoints].TotalDistance
end

ENT.RunTime = 0

function ENT:GetDistance(offset)
  return ((( self.RunTime * ( self.Velocity )) + (offset or 0) ) % GetCurveLength(self) )
end

function ENT:GetPosAngle( distanceOffset, num )
	return self.Curve:CalculateLinear(self:GetDistance(distanceOffset), num)
end
