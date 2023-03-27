local meta = FindMetaTable( "Player" )
if !meta then
	Msg("ALERT! Could not hook Player Meta Table\n")
	return
end

if SERVER then

	function meta:Pancake()
		
		if self:GetNet( "IsChimera" ) || self:GetNet( "IsPancake" ) || self.Bit || !GAMEMODE:IsPlaying() then return end
		
		//Msg( "Pancaking Pig: " .. tostring( self ), "\n" )

		self:SetNet( "IsPancake", true )
		self:Squeal()

		timer.Simple( .5, function()

			if IsValid( self ) then

				self.Squished = true
				self:Kill()

				local uc = GAMEMODE:GetUC()

				if IsValid( uc ) then
					uc:HighestRankKill( self:GetNet( "Rank" ) )
					uc:AddAchievement( ACHIEVEMENTS.UCHPANCAKE, 1 )
				end

				self:ResetRank()

			end

		end )

	end
	
else
	
	function meta:DoPancakeEffect()

		self.PancakeNum = self.PancakeNum or 1

		local num, spd = 1, 8

		self.PancakeNum = math.Approach( self.PancakeNum, .2, ( FrameTime() * ( self.PancakeNum * spd ) ) )

		SetModelScaleVector( Vector( 1, 1, self.PancakeNum ) )

	end

end