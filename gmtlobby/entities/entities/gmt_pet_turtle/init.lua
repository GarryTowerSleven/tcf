include( "shared.lua" )

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

ENT.TeleportDist	= 600	// pet teleports to you at this distance
ENT.StopDist		= 150	// at distances closer than this, the pet stops applying velocity
ENT.FreezeDist		= 50	// at this distance, the pet stops moving entirely
ENT.WinkDist		= 100	// oh my, what a cute melon!
ENT.RollingVelocity	= 350	// at this velocity or greater, the pet does a rolling emote

ENT.DullTime		= 35
ENT.BoredTime		= 15

local NEARBY_NOTHING	= 0 // nothing found nearby
local NEARBY_PET		= 1 // another pet nearby

function ENT:Initialize()

	self:SetModel( self.Model )

	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )

	--self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_NONE )
	self:SetUseType( SIMPLE_USE )

	--self:PhysWake()

	self:DrawShadow( true )

	self.PlayerDistance = 0
	self.NextEmotionThink = CurTime()
	self.EmoteTime = CurTime()
	self.LastActionTime = CurTime()

	//self:SharedInit()

	self.EmoteTime = CurTime() + 2
	--self:EmitRandomSound( "Spawning", 5 )

	if IsValid(self:GetOwner()) then
		self:SetParent(self:GetOwner())
	end

end

function ENT:OnRemove()

	--self:EmitRandomSound( "Deleted", 5 )

	local owner = self:GetOwner()

	if IsValid( owner ) then
		owner.Pet = nil
	end


end


function ENT:Teleport( ply )

	local pos = ply:GetPos()

	pos.x = pos.x + ( math.Rand( -1.0, 1.0 ) * 40 )
	pos.y = pos.y + ( math.Rand( -1.0, 1.0 ) * 40 )
	pos.z = pos.z + 20

	self:SetPos( pos )

	self:PhysWake()

	--self:EmitRandomSound( "Teleporting", 30 )
end

function ENT:ResetIdle()
	self.LastActionTime = CurTime()
end

function ENT:IdleTime()
	return ( CurTime() - self.LastActionTime )
end

function ENT:Think()

	local owner = self:GetOwner()
	if !IsValid( owner ) then
	if IsValid(self) then self:Remove() end
	return
	end

end

// checks if another pet is near this pet
function ENT:GetNearby()

	local selfPos = self:GetPos()
	local foundMelon = false

	local entTable = {}

	local results = {}

	table.Add( entTable, ents.FindByClass( "gmt_pet" ) )

	for _, v in ipairs( entTable ) do
		if IsValid( v ) && v != self then

			local entDistance = selfPos:Distance( v:GetPos() )

			if ( entDistance <= self.WinkDist ) then
				results[ v ] = entDistance
			end

		end
	end

	local closestDist = 0
	local closestType = ""

	for k, v in pairs( results ) do
		if ( v >= closestDist ) then
			closestDist = v
			closestType = k:GetClass()
		end
	end

	if ( closestType == "gmt_pet" ) then
		return NEARBY_PET
	end

	return NEARBY_NOTHING

end

function ENT:PhysicsUpdate( phys )

	local velocity = phys:GetVelocity()

	if ( self.PlayerDistance <= self.FreezeDist ) then
		phys:SetVelocity( Vector( 0, 0, velocity.z ) )
		return
	end

	if ( self.PlayerDistance <= self.StopDist ) then return end

	local angle = self:GetOwner():GetPos() - self:GetPos()

	local vect = angle:GetNormalized() * ( self.PlayerDistance / 4 )
	vect.z = math.Clamp( vect.z, 0, 100 ) // don't move too far up

	phys:ApplyForceCenter( vect )

end