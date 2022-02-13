local meta = FindMetaTable( "Player" )
if !meta then
    Msg( "ALERT! Could not hook Player Meta Table\n" )
    return
end

function meta:IsMovementKeyDown()

	return self:KeyDown( IN_MOVELEFT ) || self:KeyDown( IN_MOVERIGHT )

end

function meta:FindMoveVec( key )

	local vec = self:GetForward()

	if key == IN_MOVELEFT then
		vec = vec * -1
	end

	if key == IN_MOVERIGHT then
		vec = vec
	end

	return vec

end

function meta:MoveEffects( idx, vec )

	local idx = idx or 1
	local pos = self:GetPos()

	if idx == 1 then // run dust

		local vel = self:GetVelocity()

		local num = vel:Length() / GAMEMODE.MaxSpeed
		num = math.Clamp( num, .01, 1 )
		num = ( num + num ) * num
		num = num * .5

		local eff = EffectData()
			eff:SetOrigin( pos )
			eff:SetStart( vel:GetNormal() * -1 )
			eff:SetAngles( Angle(1, 3, 0 ) )
			eff:SetScale( 2.25 * num )

			local num = 15 + ( 10 * num )
			eff:SetNormal( Vector( num * 12, 0, 0 ) )
			eff:SetMagnitude( num )
		util.Effect( "speed_dust", eff )

	elseif inx == 2 then

		local eff = EffectData()
			eff:SetOrigin( pos )
			eff:SetStart( vec )
			eff:SetAngles( Angle( 4, 6, 0 ) )
			eff:SetScale( 5 )
			eff:SetNormal( Vector( 160, 0, 0 ) )
			eff:SetMagnitude( 160 )
		util.Effect("speed_dust", eff )

	end

end

function meta:DoSkidDust( key )

	local vec = self:FindMoveVec( key )
	self:MoveEffects( 2, vec )

end

function meta:DoPuffEffects()

	self.Puff = self.Puff or 0

	if CurTime() >= self.Puff && self:IsOnGround() then

		self.Puff = CurTime() + math.Rand( .01, .02 )
		self:MoveEffects( 1, nil )

	end

end

function meta:FinishRace()

	if self:Team() == TEAM_FINISHED then return end

	music.Play( 1, MUSIC_FINISH, self )
	self:SetTeam( TEAM_FINISHED )

	self:SetNet( "Rank", #team.GetPlayers( TEAM_FINISHED ) )
	local rank = self:GetNet( "Rank" )
	Msg( self:Name() .. " " .. rank, "\n" )

	local time = self.StartTime - CurTime()
	self:SetNet( "Time", time )

	//GAMEMODE:NotifyFinish( self, time, rank )

end

function meta:CanDoubleJump()

	local add = 36; //how much to increase the required z velocity per jump
	local numjumps = 1; //how many jumps you're allowed before increasing the required z velocity

	local num = -( 150 - ( add * numjumps ) + ( add * self:GetNet( "DoubleJumpNum" ) ) )

	if !self:IsOnGround() and self.FirstDoubleJump then
		return true
	else
	   return false
   end

end

function meta:DoubleJump()

	local upward_velocity = 175

	self:SetVelocity((self:GetVelocity() * 0.6 )+Vector(0,0,upward_velocity));

	self.FirstDoubleJump = false
	self:EmitSound( "GModTower/gourmetrace/actions/jump.wav", 75, math.random(100,110) )
	self:SetNet( "DoubleJumpNum", self:GetNet( "DoubleJumpNum" ) + 1 )

end
