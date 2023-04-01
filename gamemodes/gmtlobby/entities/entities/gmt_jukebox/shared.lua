AddCSLuaFile()

ENT.PrintName = "Jukebox"

ENT.Type = "anim"
ENT.Base = "mediaplayer_base"

ENT.RenderGroup = RENDERGROUP_OPAQUE

ENT.Model = Model( "models/gmod_tower/jukebox.mdl")

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
		self:InstallMediaPlayer( "jukebox" )
	end

end

if SERVER then return end

function ENT:Draw()
	self:DrawModel()

	local mp = self:GetMediaPlayer()
	if ( not mp ) then return end
	
	local offset 	= Vector( 0,0, math.sin( CurTime() * 4 ) * 2 )
	local pos 		= self:GetPos() + self:GetUp() * 80 + offset
	local ang 		= self:GetAngles()
	
	local scale 	= .15

	ang:RotateAroundAxis( self:GetForward(), 90 )
	ang:RotateAroundAxis( self:GetUp(), 90 )
	
	cam.Start3D2D( pos, ang, scale )
		draw.DrawText( "HOLD Q TO REQUEST MUSIC",
		"GTowerSkyMsgSmall",
		0,
		0,
		Color(255,255,255,255),
		TEXT_ALIGN_CENTER
		)
	cam.End3D2D()
end