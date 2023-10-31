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

    local ammo = math.random(8, 16)

    ply:GiveAmmo( ammo, "AR2", true )

    ply:Msg2( "Picked up " .. ammo .. " extra ammo." )
    ply:EmitSound( self.Sound, 140, 80 )

    self:Remove()
end