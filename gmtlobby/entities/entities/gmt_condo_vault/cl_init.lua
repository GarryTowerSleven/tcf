
-----------------------------------------------------
include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()

	local sequence = self:LookupSequence( "idle" )
	self:SetSequence( sequence )
	self:SetPlaybackRate( 1.0 )

	self.Opened = false

end

function ENT:GetOpen()
	return self:GetNWBool( "Open" )
end

function ENT:Draw()

	self:FrameAdvance( FrameTime() )
	self:DrawModel()

end

function ENT:Think()

	if self:GetOpen() and self:GetSequence() ~= self:LookupSequence( "open" ) and not self.Opened then
		self.Sequence = self:LookupSequence( "open" )

		self:SetPlaybackRate( 1.0 )
		self:ResetSequence( self.Sequence )
		self:SetCycle( 0 )

		self.Opened = true
	end

	self:SetPlaybackRate( 1.0 )

	if not self:GetOpen() and self:GetSequence() ~= self:LookupSequence( "close" ) and self.Opened then
		self.Sequence = self:LookupSequence( "close" )

		self:SetPlaybackRate( 1.0 )
		self:ResetSequence( self.Sequence )
		self:SetCycle( 0 )

		self.Opened = false

	end

		if !self.LastTick then self.LastTick = CurTime() end

		self:FrameAdvance( CurTime() - self.LastTick )

		self.LastTick = CurTime()

end
