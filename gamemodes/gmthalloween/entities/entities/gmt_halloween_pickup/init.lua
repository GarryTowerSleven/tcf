AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

    self:SetModel( self.Model )

	self:SetSolid( SOLID_BBOX )
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self:SetCollisionBounds( Vector( -10, -10, -10 ), Vector( 10, 10, 10 )  )
	self:SetTrigger( true )

    self:DrawShadow( false )

end

function ENT:Touch( ply )

	if not ply:IsPlayer() then return end
    if ply._LastPickup and ply._LastPickup + 5 > CurTime() then return end

    ply:ReplenishAmmo()
    ply:ReplenishHealth()
    ply:Msg2( "Ammo and battery replenished. Good luck." )

    ply:EmitSound( self.Sound, 140, 80 )

    ply._LastPickup = CurTime()

end