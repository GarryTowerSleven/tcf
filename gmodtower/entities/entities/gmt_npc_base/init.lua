AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_expression.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )
include( "schedules.lua" )
include( "tasks.lua" )

ENT.m_fMaxYawSpeed = 200
ENT.m_iClass = CLASS_CITIZEN_REBEL

AccessorFunc( ENT, "m_iClass", "NPCClass" )
AccessorFunc( ENT, "m_fMaxYawSpeed", "MaxYawSpeed" )

function ENT:Initialize()

	self:UpdateModel()

	-- Some default calls to make the NPC function
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal()
	self:SetSolid( SOLID_BBOX )
	self:SetMoveType( MOVETYPE_STEP )
	--self:CapabilitiesAdd( bit.bor( CAP_MOVE_GROUND, CAP_OPEN_DOORS, CAP_ANIMATEDFACE, CAP_SQUAD, CAP_USE_WEAPONS, CAP_DUCK, CAP_MOVE_SHOOT, CAP_TURN_HEAD, CAP_USE_SHOT_REGULATOR, CAP_AIM_GUN ) )
	--self:CapabilitiesAdd( bit.bor( CAP_ANIMATEDFACE, CAP_TURN_HEAD ) )
	self:CapabilitiesAdd( bit.bor( CAP_ANIMATEDFACE ) )
	self:Expression("happy")

	self:SetHealth( 100 )

	local GMTNPC = self.Entity

	if ( GMTNPC.StoreId == GTowerStore.BALLRACE || GMTNPC.StoreId == GTowerStore.PVPBATTLE ) then
		GMTNPC:SetPos(GMTNPC:GetPos() - Vector( 0, 0, 0.3 ))
	end

	GTowerNPCSharedInit(self)

end

function ENT:OnTakeDamage( dmginfo )
end

function ENT:AcceptInput( name, activator, ply )

    if name == "Use" && ply:IsPlayer() && ply:KeyDownLast(IN_USE) == false then
		
		timer.Simple( 0.0, function()
			GTowerStore:OpenStore( ply, self.StoreId )
		end )
		
    end 
end

function ENT:SetSale( sale )
	self:SetNWBool("Sale",sale)
end

/*
function ENT:TypeOnComp()
	self:StartSchedule( schdChase )
end
*/

function ENT:UpdateModel()
	self:SetModel( self.Model )
end

function ENT:OnCondition( iCondition )
end

function ENT:StartTouch( entity )
end

function ENT:EndTouch( entity )
end

function ENT:Touch( entity )
end

function ENT:GetRelationship( entity )
end

function ENT:ExpressionFinished( strExp )
end

function ENT:OnChangeActivity( act )
end

function ENT:Think()
end

function ENT:GetSoundInterests()
end

function ENT:OnMovementFailed()
end

function ENT:OnMovementComplete()
end

function ENT:OnActiveWeaponChanged( old, new )
end

function ENT:GetAttackSpread( Weapon, Target )
	return 0.1
end