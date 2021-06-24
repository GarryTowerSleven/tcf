include('shared.lua')
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

function ENT:Initialize()

	self:DrawShadow( false )
	self:SetNotSolid( true )

end

function ENT:Think()

	local owner = self:GetOwner()

	if !IsValid( owner ) then
		self:Remove()
	else

		if owner:Crouching() then
			owner:SetJumpPower(self.CrouchedJumpPower)
		else
			owner:SetJumpPower(self.JumpPower)
		end

		if !owner:Alive() then

			self:Remove()
			owner.TakeOn = nil

		end
	end

end

function ENT:SetShoeOwner( ply )

	self:SetPos( ply:GetPos() )
	self:SetOwner( ply )
	self:SetParent( ply )

	ply:SetJumpPower( self.JumpPower )

end


function ENT:OnRemove()

	local owner = self:GetOwner()

	if IsValid( owner ) then

		owner.TakeOn = nil
		owner:SetJumpPower(200)

	end

end

hook.Add("PlayerDeath", "RemoveTakeon", function( ply )

	if IsValid( ply.TakeOn ) then

		ply.TakeOn:Remove()
		ply.TakeOn = nil

		ply:SetJumpPower( 200 )

	end

end )

hook.Add("PlayerSilentDeath", "RemoveTakeon", function( ply )

	if IsValid( ply.TakeOn ) then

		ply.TakeOn:Remove()
		ply.TakeOn = nil

		ply:SetJumpPower( 200 )

	end

end )

hook.Add("PlayerDisconnected", "RemoveTakeon", function( ply )

	if IsValid( ply.TakeOn ) then

		ply.TakeOn:Remove()
		ply.TakeOn = nil

	end

end )

hook.Add("PlayerThink", "RemoveTakeonInTheater", function( ply )

	if !IsValid( ply ) || !GTowerLocation:IsTheater(( GTowerLocation:GetPlyLocation( ply ) )) then return end

	if IsValid( ply.Takeon ) then

		ply.Takeon:Remove()
		ply.Takeon = nil

	end

end )
