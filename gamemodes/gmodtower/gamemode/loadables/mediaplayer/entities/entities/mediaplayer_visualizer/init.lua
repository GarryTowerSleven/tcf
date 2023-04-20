AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self:SetModel( self.Model )
	self:DrawShadow( false )

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)

	self:SetUseType( SIMPLE_USE )
	
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end

	/*if ( not self:GetFirstMediaPlayerInLocation() ) then
		self.MediaPlayer = self:InstallMediaPlayer( "radio" )
		print( self.MediaPlayer )
	end*/
end

function ENT:Use( activator )
	// activator:Msg2( "This mediaplayer is currently unavailable, please try again another time." )

	net.Start( "OpenReqMenu" )
		net.WriteEntity( self:GetFirstMediaPlayerInLocation() and self:GetFirstMediaPlayerInLocation().Entity )
	net.Send( activator )
end

util.AddNetworkString( "OpenReqMenu" )