AddCSLuaFile()

ENT.PrintName = "Global Mediaplayer"

ENT.Type = "anim"
ENT.Base = "mediaplayer_base"

ENT.RenderGroup = RENDERGROUP_OPAQUE

ENT.PlayerConfig = {
	angle = Angle(0, 0, 0),
	offset = Vector(0,0,0),
	width = 0,
	height = 0
}

function ENT:Initialize()

	self:SetModel( self.Model )

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetCollisionGroup( 0 )
	self:DrawShadow( false )
	
	local phys = self:GetPhysicsObject()
	
	if IsValid( phys ) then
		phys:EnableMotion( false )
	end

	if SERVER then
		-- Install media player to entity
		self:InstallMediaPlayer( "mediaplayer" )
	end

end

function ENT:Draw()
end