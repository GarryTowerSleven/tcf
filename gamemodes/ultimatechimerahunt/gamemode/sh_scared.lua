local meta = FindMetaTable( "Player" )
if !meta then
	Msg("ALERT! Could not hook Player Meta Table\n")
	return
end

if CLIENT then return end

function meta:Scare( t )
	
	if self:Team() != TEAM_PIGS || !self:Alive() || self:IsGhost() || self:GetNet( "IsScared" ) then return end

	self.UnScareTime = self.UnScareTime or 0

	self:SetNet( "IsScared", true )

	self:SetNet( "Sprint", 0 )
	self:SetNet( "IsSprinting", false )

	self:StripSaturn()
	self:SetNet( "HasSaturn", false )
	
	self:PlaybackRateOV( 1 )
	
	local num = ( 6.5 + ( ( t * ( 1 - ( self:GetNet( "Rank" ) / 5 ) ) ) * .5 ) )
	self.UnScareTime = CurTime() + num
	
	self:EmitSound( "vo/halloween_scream" .. tostring( math.random( 1, 8 ) ) .. ".mp3", 75, math.random( 94, 105))
	
end

function meta:UnScare()
	
	if !self:GetNet( "IsScared" ) then return end

	self:SetNet( "IsScared", false )
	
	//local num = math.Clamp( self.Sprint - .5, 0, 1 )

	// Just to make sure
	self:SetNet( "Sprint", 0 )
	self:SetNet( "IsSprinting", false )

	local num = 1 + ( 1.5 * ( 1 - ( self:GetNet( "Rank" ) / 5) ) )
	self.SprintCooldown = CurTime() + num
	
end

local function ScareThink()

	for k, v in pairs( player.GetAll() ) do

		if v:GetNet( "IsScared" ) then
			
			if v:GetNet( "IsTaunting" ) then
				v:StopTaunting()
			end

			if CurTime() >= v.UnScareTime then
				v:UnScare()
			end

		end

	end

end
hook.Add( "Think", "UC_ScareThink", ScareThink )