util.AddNetworkString("FoodAlpha")

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize()

	self:SetModel( self.Model )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( self.SolidType )
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )

	self:SetModelScale( self.FoodScale, 0 )

	self:SetTrigger( true )

	self:DrawShadow( false )

	self.CoolDown = 0

end

function ENT:CustomTouch( ply )

end

function ENT:StartTouch( ply )

	if ply:IsPlayer() then

		local vPoint = self:GetPos()
		local effectdata = EffectData()
		effectdata:SetOrigin( vPoint )
		util.Effect( "food_eat", effectdata, true, true )

		self:CustomTouch( ply )

		self.CoolDown = CurTime() + self.CoolDownTime
		self:SetTrigger( false )

		self:EmitSound( self.PickupSound, 80, math.random( 100, 110 ) )

		ply:SetNet( "Points", ply:GetNet( "Points" ) + self.Points )

		net.Start( "FoodAlpha" )
			net.WriteEntity( self )
		net.Broadcast()

    end

end

function ENT:Think()

	if self.CoolDown < CurTime() && !self.SingleUse then
		self:SetTrigger( true )
	end

end
