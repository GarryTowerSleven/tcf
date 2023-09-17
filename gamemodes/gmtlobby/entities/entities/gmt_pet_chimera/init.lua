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

	self.PlayerDistance = 0
	self.NextEmotionThink = CurTime()
	self.EmoteTime = CurTime()
	self.LastActionTime = CurTime()

	self.EmoteTime = CurTime() + 2

	self:GetOwner().Chimera = self

	self:ResetSequence("jump3")

	if IsValid(self:GetOwner()) then
		self:SetParent(self:GetOwner())
	end

end

hook.Add( "KeyPress", "ChimeraRoarLol", function( ply, key )
	if ( key == IN_RELOAD ) && IsValid(ply.Chimera) && CurTime() > (ply.RoarTime or 0) then
		ply.RoarTime = CurTime() + 5
		ply.Chimera:SetCycle(0)
		ply.Chimera:ResetSequence("idle3")
		ply:EmitSoundInLocation(ply.Chimera.Sound,60,125)
		local dur = ply.Chimera:SequenceDuration()
		timer.Simple(dur,function()
			if IsValid(ply.Chimera) then
				ply.Chimera:ResetSequence("jump3")
			end
		end)
	end
end )

function ENT:UpdatePetName()
	local ply = self:GetOwner()
	if IsValid( ply ) then
		self:SetPetName( string.sub(ply:GetInfo("gmt_petname_chimera"),1,15) )
	end
end

function ENT:OnRemove()

	--self:EmitRandomSound( "Deleted", 5 )

	local owner = self:GetOwner()

	if IsValid( owner ) then
		owner.Pet = nil
	end


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

	if ( SERVER ) then -- Only set this stuff on the server
		self:NextThink( CurTime() ) -- Set the next think for the serverside hook to be the next frame/tick
		return true -- Return true to let the game know we want to apply the self:NextThink() call
	end

end
