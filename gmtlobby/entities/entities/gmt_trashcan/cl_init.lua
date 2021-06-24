
-----------------------------------------------------
include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
	self:FrameAdvance( FrameTime() )
	self:DrawModel()

	if ( self:GetSequence() == self:LookupSequence( "use" ) && self:GetCycle() > 25 ) then
		self:SetSequence( self:LookupSequence( "idle" ) )
	end
end

function ENT:Initialize()

	local sequence = self:LookupSequence( "idle" )
	self:SetSequence( sequence )
	self:SetPlaybackRate( 1.0 )

end

net.Receive("trashcan",function()

	local ent = net.ReadEntity()
	if ( !IsValid( ent ) ) then return end

	local sequence = ent:LookupSequence( "use" )
	ent:ResetSequence( sequence )

end )

function ENT:CanUse()

	local sequence = self:GetSequence()
	if self:GetSequenceName(sequence) == "idle" then
		return true, "USE"
	end

end
