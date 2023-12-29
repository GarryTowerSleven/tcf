ENT.PrintName = "GMT Theater Screen"

ENT.Type = "anim"
ENT.Base = "mediaplayer_base"

ENT.RenderGroup = RENDERGROUP_OPAQUE

ENT.Model = Model( "models/gmod_tower/theater_screen.mdl")

ENT.PlayerConfig = {
	angle = Angle(-90, 90, 0),
	offset = Vector(10,346,480),
	width = 692,
	height = 355
}

local BaseClass = baseclass.Get( "mediaplayer_base" )

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
		self:InstallMediaPlayer( "theater" )
	end

end

if SERVER then

	function ENT:SetupMediaPlayer( mp )

		mp:SetTheaterConfig({
			location = "Theater",
			screenwidth = 800,
			screenheight = 480
		})

	end

	function ENT:Use()
	end

end