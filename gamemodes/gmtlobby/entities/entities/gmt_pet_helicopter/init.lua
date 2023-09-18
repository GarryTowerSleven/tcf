util.AddNetworkString( "PetHeliShoot" )

include( "shared.lua" )

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

function ENT:Initialize()

	self:SetModel( self.Model )

	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )

	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_NONE )
	self:SetUseType( SIMPLE_USE )

	self:DrawShadow( true )
	self:GetOwner().Helicopter = self

	if IsValid(self:GetOwner()) then
		self:SetParent(self:GetOwner())
	end

end

function ENT:Think()

	local owner = self:GetOwner()
	if !IsValid( owner ) then
		if IsValid(self) then self:Remove() end
		return
	end

	if ( SERVER ) then -- Only set this stuff on the server
		self:NextThink( CurTime() ) -- Set the next think for the serverside hook to be the next frame/tick
		return true -- Return true to let the game know we want to apply the self:NextThink() call
	end

end

hook.Add( "KeyPress", "PetHeliFly", function( ply, key )
	if ( key == IN_RELOAD ) and IsValid(ply.Helicopter) then
		if ply._nextHeliShoot and ply._nextHeliShoot > CurTime() then return end

		net.Start( "PetHeliShoot" )
			net.WriteEntity( ply.Helicopter )
		net.Broadcast()

		ply._nextHeliShoot = CurTime() + 1
	end
end )

// Prevent walking while flying
hook.Add( "SetupMove", "PetHeliFly", function( ply, mv, cmd )
	if ply.FlyingHeli then
		mv:SetMaxClientSpeed( 0 )
	end
end )