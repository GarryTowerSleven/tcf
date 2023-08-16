AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Choice = 0
ENT.ChoiceTimeLeft = nil

function ENT:Initialize()
	self:SetModel( self.Model )
	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	
	self:SetUseType( SIMPLE_USE )

	local phys = self:GetPhysicsObject()
	if ( phys:IsValid() ) then
		phys:EnableMotion( false )
	end
end

function ENT:PlayerValid()
	if ( not IsValid( self:GetPlayer() ) or not self:GetPlayer():IsPlayer() ) then
		return false
	end

	if ( not self:GetPlayer():Alive() ) then
		return false
	end

	return true
end

function ENT:OnRemove()
	self:RemoveContestant()
end

function ENT:Clear( full )
	//trivia.log.info( "self:Clear %s", self )

	self.Choice = 0
	self.ChoiceTimeLeft = nil
	self:SetChoice( 0 )
	self:SetCorrect( false )
	self:SetAnswered( false )

	if ( full ) then
		self:SetPoints( 0 )
		self:SetNumCorrect( 0 )
		//self:SetStreak( 0 )
	end
end

function ENT:SetContestent( ply )
	if ( self.Controller:GetError() ) then return end

	if ( ply == self:GetPlayer() and self.Controller:GetState() != trivia.STATE_PLAY ) then
		self:RemoveContestant()
		return
	end

	if ( not ply:Alive() ) then return end

	if ( IsValid( ply:GetNet( "TriviaPodium" ) ) and ply:GetNet( "TriviaPodium" ) != self ) then return end

    if ( IsValid( self:GetPlayer() ) ) then return end

	if ( self:GetController():GetState() > trivia.STATE_WAITING ) then return end

	self:SetPlayer( ply )
	ply:SetNet( "TriviaPodium", self )
end

function ENT:RemoveContestant()
	if ( not IsValid( self:GetPlayer() ) ) then return end

	self:GetPlayer():SetNet( "TriviaPodium", NULL )

	self:SetPlayer( NULL )
	self:Clear( true )
end

function ENT:MakeChoice( choice )
	if ( self.Controller:GetState() != trivia.STATE_PLAY ) then return end
	if ( not IsValid( self:GetPlayer() ) ) then return end
	if ( self:GetAnswered() ) then return end
	
	self.Choice = math.Clamp( choice, 1, 4 )
	self.ChoiceTimeLeft = self.Controller:TimeLeft()
	
	net.Start( "trivia.Choice" )
		net.WriteEntity( self )
		net.WriteUInt( self.Choice, 3 )
	net.Send( self:GetPlayer() )
	
	self:SetAnswered( true )
	self.Controller:CheckAnswered()
	
	// trivia.log.info( "self:MakeChoice %s %s %s", self, self.Choice, self.ChoiceTimeLeft )
	// trivia.log.info( "%s has chosen choice #%s: \"%s\"", self:GetPlayer():Nick(), self.Choice, self:GetChoiceString() )
end

function ENT:GetChoiceString()
	return self:GetController():GetChoice(self.Choice)
end

function ENT:IsCorrect()
	return self:GetChoiceString() == self:GetController():GetAnswer()
end

function ENT:GivePoints( num )
	self:SetPoints( self:GetPoints() + num )
end

net.Receive( "trivia.Choice", function( len, ply )
	local p = ply:GetNet( "TriviaPodium" )
	if ( not IsValid( p ) or not p.MakeChoice ) then return end

	p:MakeChoice( net.ReadUInt( 3 ) or 0 )
end )

net.Receive( "trivia.Join", function( len, ply )
	local ent = net.ReadEntity()
	if ( not IsValid( ent ) or not ent.GetClass or ent:GetClass() != "gmt_trivia_podium" ) then return end

	ent:SetContestent( ply )
end )

net.Receive( "trivia.Leave", function( len, ply )
	local p = ply:GetNet( "TriviaPodium" )
	if ( not IsValid( p ) ) then return end

	p:RemoveContestant()
end )

/*function ENT:Use( ply )
	self:SetContestent( ply )
end*/