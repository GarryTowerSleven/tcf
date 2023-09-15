ENT.Base 			= "base_anim"
ENT.Type 			= "vehicle"
ENT.Model 			= Model( "models/gmod_tower/kart/kart_frame.mdl" )
ENT.ModelSmall		= Model( "models/gmod_tower/kart/kart_frame_small.mdl" )
ENT.FrontWheelModel = Model( "models/gmod_tower/kart/kart_frontwheel.mdl" )
ENT.BackWheelModel 	= Model( "models/gmod_tower/kart/kart_backwheel.mdl" )

ENT.Spawnable		= true
ENT.AdminSpawnable	= true

SafeMaterials = { // Materials that are safe for the kart to be on
	"GMOD_TOWER/KARTRACER/LIFELESSRACEWAY/RACETRACK",
	"GMOD_TOWER/KARTRACER/DESERT/WOOD_PLANKS01"
}

DirtMaterials = { // Materials that slow down the kart

}

GrassMaterials = { // Materials that slow down the kart
	"GMOD_TOWER/COMMON/GRASS",
	"GMOD_TOWER/KARTRACER/LIFELESSRACEWAY/LGRASS",
}

SandMaterials = { // Materials that slow down the kart
	"DEV/VALUESAND50",
}

LavaMaterials = { // Materials that slow down and kill the kart
	"GMOD_TOWER/KARTRACER/TRACK/LAVA",
}

BoostMaterials = { // Materials that speed up the kart
	"GMOD_TOWER/BALLS/MAXIMUMSPEED",
	"GMOD_TOWER/KARTRACER/RAVE/SK_BOOST_PINK",
	"maps/gmt_sk_rave/gmod_tower/kartracer/rave/sk_boost_pink_-5049_9856_-512"
}

StickMaterials = { // Materials that maintain its own surface gravity
	"DEV/DEV_MEASUREGENERIC01B",
	"GMOD_TOWER/KARTRACER/TRACK/ROAD7",
	"GMOD_TOWER/KARTRACER/LIFELESSRACEWAY/RACETRACK_GRAV",
	"GMOD_TOWER/KARTRACER/LIFELESSRACEWAY/TUNNELWALLSTOP_GRAV",
	"GMOD_TOWER/KARTRACER/TRACK/ROADGRAVITY",
	"GMOD_TOWER/KARTRACER/TRACK/GRAVITY",
	"GMOD_TOWER/KARTRACER/DESERT/WOOD_PLANKS01_GRAVITY",
	"GMOD_TOWER/KARTRACER/RAVE/GLITTER_TRACK",
	"maps/gmt_sk_rave/gmod_tower/kartracer/rave/glitter_track_-5488_10736_-694"
	//"DEV/DEV_MEASUREWALL01A"
}

function ENT:GetKart()

	return self:GetOwner():GetKart()

end



function ENT:IsValidOwner()

	return IsValid( self:GetOwner() )

end

ENT.Wheels = {
	{
		Model = "frontwheel",
		Att = "wheel_fr",
		Ang = 0,
		Extrude = 1,
	},
	{
		Model = "frontwheel",
		Att = "wheel_fl",
		Ang = 180,
		Extrude = -1,
	},
	{
		Model = "backwheel",
		Att = "wheel_rr",
		Ang = 0,
		Extrude = 1,
	},
	{
		Model = "backwheel",
		Att = "wheel_rl",
		Ang = 180,
		Extrude = -1,
	}
}

ENT.Settings = {
	//Key = {Value, Min, Max, Mod}
	FrictionFactor = { 300, 0, 300 },
	FrictionRightFactor = { 200, 0, 500 },
	PowerForward = { 250, 0, 800 },
	PowerBackwards = { -100, -800, 0 },
	TurnPower = { 100, 0, 150 },
	TurnFricton = { 1, 0.01, 2 },

	MaxVel = { 500, 1, 2000 },
	MaxBoostVel = { 500, 1, 2000 },
	MaxAngVel = { 300, 0.01, 500 },

	DriftingFactor = { .15, 0, 5 },
	DriftingJumpPower = { 1.8, 0, 25 },
	DriftingYawPower = { 0.25, 0, 5 },
	DriftingTurnFactor = { 5, 0, 600 },

	// Not from the latest Source Karts, only used in the old base. Added for compatibility.
	// Altered cause the originals were way too high. (They still are)
	JumpPower = { 5, 0, 10000 },
	JumpWaitTime = { 1, 0, 5 },
	UpwardForce = { 600, -300, 600 }

	// Originals, once again, not used in the final Source Karts.
	/*
	JumpPower = { 300, 0, 10000 },
	JumpWaitTime = { 1, 0, 5 },
	UpwardForce = { 180, -300, 600 }
	*/
}

ENT.BattleSettings = {
	//Key = {Value, Min, Max, Mod}
	FrictionFactor = { 300, 0, 300 },
	FrictionRightFactor = { 500, 0, 500 },
	PowerForward = { 500, 0, 800 },
	PowerBackwards = { -500, -800, 0 },
	TurnPower = { 150, 0, 150 },
	TurnFricton = { 1.58, 0.01, 2 },

	MaxVel = { 500, 1, 2000 },
	MaxBoostVel = { 1000, 1, 2000 },
	MaxAngVel = { 300, 0.01, 500 },

	DriftingFactor = { 4.17, 0, 5 },

	DriftingJumpPower = { 12.8, 0, 25 },

	DriftingYawPower = { 1.54, 0, 5 },

	DriftingTurnFactor = { 10, 0, 600 },

}

ENT.DriftMinimum = .25

ENT.DriftLevels = {
	1.15,
	2,
	3,
}

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "TurnAngleNet" )
	self:NetworkVar( "Int", 1, "DriftStart" )
	self:NetworkVar( "Bool", 0, "IsEngineOn" )
	self:NetworkVar( "Bool", 1, "IsDrifting" )
	self:NetworkVar( "Bool", 2, "IsInvincible" )
	//self:NetworkVar( "Bool", 2, "IsDriftReady" )
	self:NetworkVar( "Bool", 3, "IsBoosting" )
	self:NetworkVar( "Bool", 4, "IsGhost" )
end


function ENT:IsGhost()
	return self:GetIsGhost()
end

function ENT:Initialize()
    self:SetCustomCollisionCheck( true )
end

function ENT:GetDownTrace( origin, mask, box )
	local origin = origin or self:GetPos()
	local filtered = {}
	table.Add(filtered, ents.FindByClass("sk_kart"))
	table.Add(filtered, ents.FindByClass("sk_wheel"))
	table.Add(filtered, ents.FindByClass("player"))

	if box then
		return util.TraceHull( {
			start = origin,
			endpos = origin + self:GetUp() * -32,
			mins = Vector( -box, -box, -box ),
			maxs = Vector( box, box, box ),
			filter = filtered,
			mask = mask
		} )
	else
		return util.TraceLine( {
			start = origin,
			endpos = origin + self:GetUp() * -32,
			filter = filtered,
			mask = mask
		} )
	end
end

function ENT:GetUpTrace( origin, mask )
	local origin = origin or self:GetPos()
	local filtered = table.Add( ents.FindByClass( "sk_kart" ), ents.FindByClass( "sk_wheel" ) )

	--filtered = table.Add( filtered, ents.FindByClass( "sk_item*" ) )

	return util.TraceLine( {
		start = origin,
		endpos = origin + self:GetUp() * 32,
		filter = filtered,
		mask = mask
	} )
end

function ENT:HitWorld( trace )
	if !trace then return false end
	return trace.HitWorld || ( IsValid( trace.Entity ) && ( trace.Entity:GetClass() == "func_brush" || trace.Entity:GetClass() == "func_movelinear" ) )
end

function ENT:IsOnWater()

	local wtrace = self:GetDownTrace( nil, MASK_WATER )

	return wtrace.Hit, wtrace.HitPos, wtrace.HitNormal

end

function ENT:GetTraction( trace )
	// == SPECIAL CASES ==

	// Handle on water
	local water, whitpos = self:IsOnWater()

	if water then
		return .1, "water", true
	end

	// Handle spinning... yeah this is kinda a hack BUT WHATEVER
	/*if self.Spinning && self.Spinning > CurTime() then
		return 1.6, "spinning", true
	end
*/
	// == TRACE CASES ==
	trace = trace or self:GetDownTrace()

	local hitTexture = trace.HitTexture
	local matType = trace.MatType

	// Handle grass
	if table.HasValue( GrassMaterials, hitTexture ) || matType == MAT_DIRT then
		return .5, "grass", true
	end

	// Handle dirt
	if table.HasValue( DirtMaterials, hitTexture ) || matType == MAT_SLOSH then
		return .8, "dirt", true
	end

	// Handle sand
	if table.HasValue( SandMaterials, hitTexture ) || matType == MAT_SAND then
		return .9, "sand", true
	end

	// Handle lava
	if table.HasValue( LavaMaterials, hitTexture ) /*|| matType == MAT_FLESH*/ then
		return 1.1, "lava", true
	end

	// Handle boost
	if table.HasValue( BoostMaterials, hitTexture ) || matType == MAT_COMPUTER || string.StartWith( hitTexture, "maps/gmt_sk_rave/gmod_tower/kartracer/rave/sk_boost_pink" ) then
		return .4, "boost", false
	end


	// Handle surface
	if table.HasValue( StickMaterials, hitTexture ) or string.StartWith( hitTexture, "maps/gmt_sk_rave/gmod_tower/kartracer/rave/glitter" ) or string.StartWith( hitTexture, "maps/gmt_sk_rave/gmod_tower/kartracer/rave/sk_boost_blue" ) then
		return .15, "surface", false
	end

	if hitTexture == "**displacement**" then

		if game.GetMap() == "gmt_sk_rave" then
			return .15, "surface", false
		end

		return .8, "dirt", true
	end

	return .2, "normal", false
end


concommand.Add( "sk_ground", function( ply, cmd, args )
	if !ply:IsAdmin() then return end

	local kart = ply:GetKart()

	if IsValid( kart ) then
		local trace = kart:GetDownTrace()
		local hitTexture = trace.HitTexture

		local hitType = trace.MatType

		local Traction, MatType = kart:GetTraction()

		ply:ChatPrint( tostring( hitTexture ) )
		ply:ChatPrint( tostring( hitType ) )

		if MatType then
			ply:ChatPrint( MatType )
		end
	end
end )
