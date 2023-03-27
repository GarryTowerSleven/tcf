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

end

function ENT:OnTakeDamage( dmginfo )
end

function ENT:AcceptInput( name, activator, ply )

    if name == "Use" && ply:IsPlayer() && ply:KeyDownLast(IN_USE) == false then
		
		timer.Simple( 0.0, function()
			self:EmitSound("vo/npc/" .. (string.find(self:GetModel(), "fe") and "fe" or "") .. "male01/hi0" .. math.random(2) .. ".wav")
			GTowerStore:OpenStore( ply, self.StoreId )
		end )
		
    end 
end

function ENT:SetSale( sale )
	self:SetSale( sale )
end

/*
function ENT:TypeOnComp()
	self:StartSchedule( schdChase )
end
*/

local modelSub = {}
modelSub["models/humans/gmtsui1/female_01.mdl"] = 3
modelSub["models/humans/gmtsui1/female_02.mdl"] = 4
modelSub["models/humans/gmtsui1/female_03.mdl"] = 4
modelSub["models/humans/gmtsui1/female_04.mdl"] = 2
modelSub["models/humans/gmtsui1/female_06.mdl"] = 5
modelSub["models/humans/gmtsui1/female_07.mdl"] = 3
modelSub["models/humans/gmtsui1/male_02.mdl"] = 3
modelSub["models/humans/gmtsui1/male_04.mdl"] = 5
modelSub["models/humans/gmtsui1/male_09.mdl"] = 3

function ENT:UpdateModel()
	self:SetModel( self.Model )

	// deluxifgy
	if ( string.StartWith( string.lower(self.Model), "models/humans/gmtsui1/female_" ) ) then
		self:SetSubMaterial( modelSub[string.lower(self.Model)] - 1, self.FemaleSheet )
	elseif ( string.StartWith( string.lower(self.Model), "models/humans/gmtsui1/male_" ) ) then
		self:SetSubMaterial( modelSub[string.lower(self.Model)] - 1, self.MaleSheet )
	end
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
	if self.TaskSequenceEnd == nil then
		self.LineIdle = self.LineIdle or math.random(2) == 1 and 1 or 3
		self:PlaySequence(self:LookupSequence("lineidle0" .. self.LineIdle), nil, nil, 1)
	end
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