AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:KeyValue(key, value)
	if key == "skin" then
		self.Skin = tonumber(value)
	end
end

function ENT:Initialize()

	if self.Skin == nil then
		self.Skin = 0
	end

	self.Entity:SetModel( self.Model )

	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_NONE )

	local phys = self:GetPhysicsObject()

	if IsValid( phys ) then
		phys:EnableMotion( false )
	end

	self.NextUse = 0

	self:SetSkin(self.Skin)
end

function ENT:Use( ply )
	if CurTime() < self.NextUse then return end
	self.NextUse = CurTime() + 1

	umsg.Start("StartGame", ply)
		umsg.Entity(self.Entity)
	umsg.End()
	
	local PlyHat = GTowerHats:GetHat( ply )

	if PlyHat != nil then

		if self.Entity.GameIDs[ self.Entity:GetSkin() - 1 ] == "Fancy Pants" && GTowerHats.Hats[ PlyHat ] && GTowerHats.Hats[ PlyHat ].Name == "Top Hat"  then
			ply:SetAchievement( ACHIEVEMENTS.FANCYPANTS, 1 )
		end

	end
end