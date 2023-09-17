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

	if IsValid(self:GetOwner()) then
		self:SetParent(self:GetOwner())
	end
end

function ENT:UpdatePetName()
	local ply = self:GetOwner()
	if IsValid( ply ) then
		self:SetPetName( string.sub(ply:GetInfo("gmt_petname_bcorn"),1,15) )
	end
end

function ENT:OnRemove()

	local owner = self:GetOwner()

	if IsValid( owner ) then
		owner.Pet = nil
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
