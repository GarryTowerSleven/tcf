
-----------------------------------------------------
include( "shared.lua" )

function ENT:Think()


	self:SetPlaybackRate( 1.0 )

  if !self.NextAnim then self.NextAnim = UnPredictedCurTime() end

	if UnPredictedCurTime() > self.NextAnim then

    self.NextAnim = UnPredictedCurTime() + 4

		self:SetPlaybackRate( 1.0 )
		self:ResetSequence( 0 )
		self:SetCycle( 0 )

	end


		if !self.LastTick then self.LastTick = CurTime() end

		self:FrameAdvance( CurTime() - self.LastTick )

		self.LastTick = CurTime()
end
