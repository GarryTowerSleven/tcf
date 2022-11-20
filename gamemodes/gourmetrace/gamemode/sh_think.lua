function GM:Think()

	if SERVER then self:RoundThink() end

	for _,ply in ipairs( player.GetAll() ) do

		if ply:Team() == TEAM_SPEC || !ply:Alive() then return end

		if SERVER then
			self:PlayerRunThink( ply )
			self:PlayerJumpThink( ply )
		else
			ply:DoPuffEffects()
		end

	end

end

function GM:RoundThink()

	if self:GetGameState() == STATE_WAITING && self.FirstPlySpawned && self:GetTimeLeft() <= 0 then
		self:PreStartRound()
	end

	if self:GetGameState() == 0 && self:GetTimeLeft() <= 1 then
		net.Start("ShowReadyScreen")
		net.Broadcast()
	end

	if self:GetGameState() == 1 && self:GetTimeLeft() <= 1 then
		net.Start("ShowReadyScreen")
		net.Broadcast()
	end

	if self:GetGameState() == STATE_WARMUP && self:GetTimeLeft() < 0 then
		self:StartRound()
	end

	if self:GetGameState() != STATE_WARMUP && self:GetTimeLeft() <= 0 && GetGlobalInt( "Round" ) <= self.NumRounds && GetGlobalInt( "Round" ) > 0 then
		if self:IsRoundOver() then
			self:PreStartRound()
		else
			self:EndRound()
		end
	end

	if !self:IsPlaying() || self.Ending then return end

	local afks = 0
	for k,v in pairs(player.GetAll()) do if v.AFK then afks = (afks + 1) end end

	local RealCount = ( player.GetCount() - afks )

	if #team.GetPlayers( TEAM_FINISHED ) == RealCount then
		self.Ending = true
		timer.Simple( 2, function() self:EndRound() end )
		return
	end

	if self:GetTimeLeft() <= 31 && !self.Intense then
		self.Intense = true
		self:SetMusic( MUSIC_30SEC )
	end

end

function GM:PlayerRunThink( ply )

	local vel = ply:GetVelocity()
	vel.z = 0

	if ply:IsMovementKeyDown() && vel:Length() >= 250 && ply:IsOnGround() then

		if ply.Speed != self.MaxSpeed then
			ply.Speed = math.Approach( ply.Speed, self.MaxSpeed, 2 )
		end

		ply:DoPuffEffects()

	else

		if ply.Speed != 250 then
			ply.Speed = 250
		end

	end

	ply:SetWalkSpeed( ply.Speed )
	ply:SetRunSpeed( ply.Speed * 1.1 )

end

function GM:PlayerJumpThink( ply )

	if !ply:IsOnGround() then

		if ply:CanDoubleJump() && ply:KeyDown( IN_JUMP ) && ply:GetNWInt( "DoubleJumpNum" ) > 0 then
			ply:DoubleJump()
		end

	else

		if !ply.FirstDoubleJump then
			ply.FirstDoubleJump = true
		end
		if ply:GetNWInt( "DoubleJumpNum" ) != 0 then
			ply:SetNWInt( "DoubleJumpNum", 0 )
		end

	end

end
