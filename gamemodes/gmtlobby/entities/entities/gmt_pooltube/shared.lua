
-----------------------------------------------------
ENT.Type 				= "anim"
ENT.Base 				= "base_anim"

ENT.PrintName			= "Pool Tube"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.RenderGroup 		= RENDERGROUP_BOTH

ENT.Model				= Model( "models/gmod_tower/pooltube.mdl")
ENT.Gravity 			= -350

--ENT.Curve 				= STORED_CURVES["waterslide_a"]

-- Controls the number of sub-points per node during linearization
-- Higher looks better for large curves, but generates more keypoints and memory usage
ENT.KeysPerNode 		= 10

-- The speed of the train along the track
ENT.Velocity 			= 500
ENT.CarCount			= 10

ENT.Fuck = false

-- Only use this function because the client and server might implement their own Initialize
function ENT:Initialize()
	--self.Curve:CalculateKeyPoints( self.KeysPerNode )
end

local function GetCurveLength(self)
	if !self.Fuck then
		self.Curve:CalculateKeyPoints( self.KeysPerNode )
		self.Fuck = true
	end
	return self.Curve and self.Curve.KeyPoints[#self.Curve.KeyPoints].TotalDistance
end

function ENT:GetDistance(offset)

	local time = UnPredictedCurTime() - (self.StartTime or 0)

	return ((time * self.Velocity) + (offset or 0)) % GetCurveLength(self)
end

function ENT:GetPosAngle( distanceOffset, num )
	return self.Curve:CalculateLinear(self:GetDistance(distanceOffset), num)
end

local function GetPoolTube( ply )
	return ply.PoolTube
end

local novel = Vector(0,0,0)
hook.Add( "Move", "MoveTube", function( ply, movedata )

	local tube = GetPoolTube( ply )

	if IsValid( tube ) then

		movedata:SetForwardSpeed( 0 )
		movedata:SetSideSpeed( 0 )
		movedata:SetVelocity( novel )
		if SERVER then ply:SetGroundEntity( NULL ) end

		movedata:SetOrigin( tube:GetPos() )

		return true

	end

end )

hook.Add( "PlayerFootstep", "PlayerFootstepTube", function( ply, pos, foot, sound, volume, rf )
	return GetPoolTube( ply )
end )

local meta = FindMetaTable( "Player" )
if !meta then
	return
end

function meta:GetTranslatedModel()

	return util.TranslateToPlayerModel( self:GetModel() )

end

function meta:SetProperties( ent )

	if !IsValid( ent ) then return end

	ent.GetPlayerColor = function() return self:GetPlayerColor() end
	ent:SetMaterial( self:GetMaterial() )
	ent:SetSkin( self:GetSkin() )
	ent:SetBodygroup( 1, self:GetBodygroup(1) )

end

local meta = FindMetaTable("Entity")

function meta:SetPlayerProperties(ply)
	if !IsValid(ply) then return end

	if !self.GetPlayerColor then
		self.GetPlayerColor = function() return ply:GetPlayerColor() end
	end

	--self:SetBodygroup( ply:GetBodyGroup(1),1 )
	self:SetMaterial( ply:GetMaterial() )
	self:SetSkin( ply:GetSkin() or 1 )

end
