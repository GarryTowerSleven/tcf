
-----------------------------------------------------
include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()

	local sequence = self:LookupSequence( "idle" )
	self:SetSequence( sequence )
	self:SetPlaybackRate( 1.0 )

end

function ENT:Draw()

	self:FrameAdvance( FrameTime() )
	self:DrawModel()

end

function ENT:Think()

	if self:GetOpen() and self:GetSequence() ~= self:LookupSequence( "Open" ) and not self.Opened then
		local sequence = self:LookupSequence( "Open" )
		self:ResetSequence( sequence )

		self.Opened = true
	end

	if not self:GetOpen() and self:GetSequence() ~= self:LookupSequence( "Close" ) and self.Opened then
		local sequence = self:LookupSequence( "Close" )
		self:ResetSequence( sequence )

		self.Opened = false
	end

end