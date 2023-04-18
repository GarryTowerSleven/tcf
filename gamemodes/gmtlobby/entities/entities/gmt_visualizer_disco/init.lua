AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:SpawnFunction( ply, tr )
	if ( !tr.Hit ) then return end
	
	local ent = ents.Create( "gmt_visualizer_disco" )
	ent:SetPos( tr.HitPos + Vector(0,0,32) )	
	ent:Spawn()
	ent:Activate()
	
	return ent
end

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:DrawShadow(false)
	
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end
	
	self:Think()
	
	self:StartMotionController()
end

function ENT:Trace( pos, dir )
	
	return util.TraceLine( {
		start = pos,
		endpos = pos + dir,
		filter = self,
		mask = MASK_SOLID_BRUSHONLY	
	} )
	
end

function ENT:Think()
	
	local DownTrace = self:Trace( self:GetPos(),  Vector(0,0,-10000) )
	local UpTrace = self:Trace( DownTrace.HitPos,  Vector(0,0,10000) )
	local Target = ( DownTrace.HitPos + UpTrace.HitPos ) / 2
	
	self.TargetZ = Target.z
	
	self:NextThink( CurTime() + 0.25 )
	
end

function ENT:PhysicsSimulate( phys, deltatime )
	
	phys:Wake()
	
	local Pos = phys:GetPos()
	local Vel = phys:GetVelocity()
	local Distance = self.TargetZ - Pos.z
	local AirResistance = 0.1
	
	if ( Distance == 0 ) then return end
	
	local Exponent = Distance^2
	
	if ( Distance < 0 ) then
		Exponent = Exponent * -1
	end
	
	Exponent = Exponent * deltatime * 300
	
	local physVel = phys:GetVelocity()
	local zVel = physVel.z
	
	Exponent = Exponent - (zVel * deltatime * 600 * ( AirResistance + 1 ) )
	// The higher you make this 300 the less it will flop about
	// I'm thinking it should actually be relative to any objects we're connected to
	// Since it seems to flop more and more the heavier the object
	
	Exponent = math.Clamp( Exponent, -5000, 5000 )
	
	local Linear = Vector(0,0,0)
	local Angular = Vector(0,0,0)
	
	Linear.z = Exponent
	
	if ( AirResistance > 0 ) then
	
		Linear.y = physVel.y * -1 * AirResistance
		Linear.x = physVel.x * -1 * AirResistance
	
	end

	Vel.x = -Vel.x
	Vel.y = -Vel.y
	Vel.z = 0
	
	self.Pos = self.Pos or self:GetPos()
	self.Pos.z = self:GetPos().z
	local v2 = self.Pos - self:GetPos()

	Vel = Vel + v2 * 32
	phys:AddVelocity(Vel)
	return Angular, Linear, SIM_GLOBAL_ACCELERATION
	
end

concommand.Add("syncdance", function(ply, _, args)
	args[1] = args[1] and tonumber(args[1]) or !ply:GetNWBool("dancing") and 1 or 0
	ply:SetNWBool("dancing", args[1] == 1)
end)

local dances = {
	["dance"] = ACT_GMOD_TAUNT_DANCE,
	["muscle"] = ACT_GMOD_TAUNT_MUSCLE,
	["robot"] = ACT_GMOD_TAUNT_ROBOT
}

concommand.Add("syncdance_set", function(ply, _, args)
	if !args[1] then return end
	local dance = dances[args[1]]
	if !dance then return end
	ply:SetNWInt("dance", dance)
	BroadcastLua([[ents.GetByIndex(]] .. ply:EntIndex() .. [[).Dance = nil]])
end)