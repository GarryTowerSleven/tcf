---------------------------------
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)

	local phys = self:GetPhysicsObject()

	if IsValid(phys) then

		phys:EnableGravity(true)
		phys:EnableDrag(false)
		phys:SetMass(1)
		phys:SetBuoyancyRatio(0)

	end

	self.RemoveTime = CurTime() + 2
end

function ENT:PhysicsCollide(data, phys)

	if self.Hit then return end

	self.Hit = true

	local hitEnt = data.HitEntity

	if IsValid(hitEnt) && (hitEnt:IsPlayer() and hitEnt != hitEnt:GetOwner()) then

		umsg.Start( "SnowHit", data.HitEntity )
		umsg.End()

		if IsValid( self:GetOwner() ) then

			self:GetOwner():AddAchievement( ACHIEVEMENTS.FROSTBITE, 1 )

		end

		if self.Death then

			hitEnt:TakeDamage( 25, self:GetOwner(), self )

		end

	end

	self:Remove()

	self:Splat({Pos = data.HitPos, Normal = data.HitNormal})
end

function ENT:Think()
	if self.RemoveTime > CurTime() then return end
	self:Remove()
end

game.AddDecal("Snow", "decals/snow01")

util.AddNetworkString( "SnowDecal" )

function ENT:Splat(hit)
	--WorldSound("player/footsteps/snow" .. math.random(1, 6).. ".wav", hit.Pos, 100, 100)
	self:EmitSound( "player/footsteps/snow"..math.random(1,6)..".wav", 100, 100, 1, CHAN_AUTO )

	net.Start( "SnowDecal" )
	net.WriteVector( hit.Pos )
	net.WriteVector( hit.Normal )
	net.Broadcast()
end
