local meta = FindMetaTable( "Player" )
if !meta then
	Msg("ALERT! Could not hook Player Meta Table\n")
	return
end

function meta:IsGhost()
	return self:Team() == TEAM_GHOST
end

function meta:SetupModel()

	//Msg( "Trying to set model for " .. tostring( self ), "\n" )

	if self:GetNet( "IsChimera" ) then

		//Msg( "Setting Chimera model for " .. tostring( self ), "\n" )
		self:SetModel2( "models/UCH/uchimeraGM.mdl" )
		self:SetSkin( 0 )
		self:SetBodygroup( 1, 1 )

		return
	end
	
	if self:IsGhost() then

		//Msg( "Setting Ghost model for " .. tostring( self ), "\n" )
		self:SetModel2( "models/UCH/mghost.mdl" )

		if self:GetNet( "IsFancy" ) then
			self:SetBodygroup( 1, 1 )
		else
			self:SetBodygroup( 1, 0 )
		end

		return
	end

	//Msg( "Setting Pig model for " .. tostring( self ), "\n" )
	self:SetModel2( "models/UCH/pigmask.mdl" )
	self:SetRankModels()
	self:SetBodygroup( 4, 1 )
	
end

function meta:IsPig()

	if !self:GetNet( "IsChimera" ) && !self:IsGhost() && self:IsPlayer() && self:Alive() && self:Team() == TEAM_PIGS then
		return true
	end
	
	return false

end

function meta:Squeal( ent )

	if self:Team() != TEAM_PIGS then return end

	local ent = ent or self
	ent:EmitSound( "UCH/pigs/squeal" .. tostring( math.random( 2, 3 ) ) .. ".wav", 92, math.random( 90, 110 ) )

end

function meta:ResetVars()

	/* Reset Jump */
	self:SetView( 48 )
	self:SetJumpPower( 242 )
	
	/* Reset Speeds */
	self:SetupSpeeds()  //set the speeds
	
	/* Reset Sprint */
	self:SetNet( "Sprint", 1 )
	self:SetNet( "IsSprinting", false )
	self:SetNet( "IsStunned", false )
	self:SetNet( "Flashlight", false )
	self.SaturnHit = false

	/* Reset Pig Stuff */
	self:StopTaunting()
	self:UnScare()
	self:SetNet( "IsPancake", false )
	self:SetMaterial()
	self:Freeze( false )
	self:SetSolid( SOLID_BBOX )
	
	BroadcastLua([[local ent = ents.GetByIndex(]] .. self:EntIndex() .. [[) if IsValid(ent) then ent:DisableMatrix("RenderMultiply") end]])
	
	/* Set Rank */
	if self:IsPig() then
		self:SetNet( "Rank", self:GetNet( "NextRank" ) )
	end

	if self:IsPig() && self:GetNet( "Rank" ) == RANK_CAPTAIN && ( Hats.IsWearing( self, "hatfedorahat" ) or Hats.IsWearing( self, "FedoraAlternative" ) ) then
		self:SetAchievement( ACHIEVEMENTS.UCHBROTHER, 1 )
	end
	
	if self:IsPig() && self:GetNet( "Rank" ) == RANK_COLONEL then
		self:SetAchievement( ACHIEVEMENTS.UCHCAPE, 1 )
	end

	/* Chimera Variables */
	if self:GetNet( "IsChimera" ) then
		self:ResetUCVars()
	end
	
	/* Saturn */
	if IsValid( self.HeldSaturn ) then
		self.HeldSaturn = nil
	end
	self:SetNet( "HasSaturn", false )

	GAMEMODE:UpdateHull( self )

	self:CollisionRulesChanged()

end

function meta:CanTaunt()

	if !self:GetNet( "IsTaunting" ) && !self:GetNet( "IsScared" ) && !self:GetNet( "IsSprinting" ) && self:IsOnGround() && self:Team() == TEAM_PIGS then
		return true
	end

	return false

end

function meta:MovementKeyDown()
	
	if self:KeyDown( IN_FORWARD ) || self:KeyDown( IN_BACK ) || self:KeyDown( IN_MOVELEFT ) || self:KeyDown( IN_MOVERIGHT ) then
		return true	
	end
	
	return false

end

function GM:StartCommand( ply, cmd )

	if !ply:GetNet( "IsChimera" ) && ply:GetNet( "IsStunned" ) then

		cmd:SetForwardMove( 0 )
		cmd:SetSideMove( 0 )

	end

end

if SERVER then

	function meta:SendSound( snd )

		if !snd then return end
		
		self:EmitSound( snd )
		
	end
	
	function meta:StripSaturn()
	
		if !self:GetNet( "HasSaturn" ) then return end
		
		if IsValid( self.HeldSaturn ) then
			self.HeldSaturn:Remove()
			self.HeldSaturn = nil
		end

		local ent = ents.Create( "mr_saturn" )
		if IsValid( ent ) then
			ent:SetPos( self:GetPos() + Vector( 0, 0, 30 ) )
			ent:Spawn()
			ent:Activate()
			ent.ShouldSpaz = true
				
			local phys = ent:GetPhysicsObject()
			if IsValid( phys ) then
				phys:SetVelocity( self:GetPos() + Vector( 0, 0, 30 ) + ( VectorRand() * 150 ) )
			end

		end
		
	end
	
	function meta:IsMoving()
	
		local vel = self:GetVelocity()
		return vel:Length() > 0
	
	end

	function meta:MakePiggyNoises()

		if !self:IsPig() then return end

		self.LastSnort = self.LastSnort || CurTime() + math.random( 9, 14 )

		if CurTime() >= self.LastSnort then
			
			self:EmitSound( "UCH/pigs/snort" .. tostring( math.random( 1, 4 ) ) .. ".wav", 75, math.random( 90, 110 ) )

			local num = math.Rand( 6, 9 )

			if self:GetNet( "IsScared" ) || !self:CanSprint() then
				num = num * .25
			end
			
			self.LastSnort = CurTime() + num
			
		end

	end

	function meta:SetupSpeeds()

		local spd, cspd = 175, .3

		if GAMEMODE:GetUC() == self then
			spd, cspd = 112, 1
		end

		if self:IsGhost() then
			spd, cspd = 250, 1
		end

		self:SetSpeed( spd )
		self:SetCrouchedWalkSpeed( cspd )
		self:SetDuckSpeed( .25 )

	end

	function meta:UpdateSpeeds()

		if !GAMEMODE:IsPlaying() then
			self:SetupSpeeds()
		end

		if self:GetNet( "IsSprinting" ) || self:GetNet( "IsScared" ) then

			local spd, cspd = 375, .5

			if self:GetNet( "IsScared" ) then
				spd = 242
			end

			if self:GetNet( "IsChimera" ) then
				spd = 300
			end

			self:SetSpeed( spd )
			self:SetCrouchedWalkSpeed( cspd )

		else
			self:SetupSpeeds()
		end

	end

	function meta:SetSpeed( spd )
		self:SetWalkSpeed( spd )
		self:SetRunSpeed( spd )
	end

	/*function meta:CreateUCHRagdoll( pig )
		
		umsg.Start( "CreateUCHRagdoll" )
			umsg.Entity( self )
			if ( b ) then
				umsg.Entity( GAMEMODE:GetUC())
			end
		umsg.End()

		if self:IsGhost() then return end

		if IsValid( self.Ragdoll ) then
			self.Ragdoll:Remove()
		end

		local rag = ents.Create( "prop_ragdoll" )
			rag:SetModel( self:GetModel() )
			rag:SetPos( self:GetPos() + Vector( 0, 0, 24 ) )
			rag:SetAngles( self:GetAngles() )
		rag:Spawn()
		if !IsValid( rag ) then return end
		rag:SetCollisionGroup( COLLISION_GROUP_DEBRIS )

		local entvel
		local entphys = self:GetPhysicsObject()
	
		if IsValid( entphys ) then
			entvel = entphys:GetVelocity()
		else
			entvel = self:GetVelocity()
		end

		if pig then
			self:Squeal( rag )
			local uc = GAMEMODE:GetUC()
			if !IsValid( uc ) then return end

			local dir = uc:GetForward() + Vector( 0, 0, .75 )
			for i = 0, rag:GetPhysicsObjectCount() - 1 do
				rag:GetPhysicsObjectNum( i):ApplyForceCenter( dir * 50000 )
			end
		end

		for i = 1, rag:GetPhysicsObjectCount() do

			local bone = rag:GetPhysicsObjectNum( i )
			if IsValid( bone ) then

				local bonepos, boneang = self:GetBonePosition( rag:TranslatePhysBoneToBone( i ) )
				bone:SetPos( bonepos )
				bone:SetAngles( boneang )
				
				if pig && IsValid( GAMEMODE:GetUC() ) then
					
					local fwd = GAMEMODE:GetUC():GetForward()
					fwd.z = 0
					fwd:Normalize()
					
					entvel = entvel + ( fwd * 3200 ) + Vector( 0, 0, 1600 )
					
				end
				
				bone:ApplyForceOffset( self:GetVelocity(), self:GetPos() )
				bone:AddVelocity( entvel )

			end

		end

		rag:SetSkin( self:GetSkin() )
		rag:SetColor( self:GetColor() )
		rag:SetMaterial( self:GetMaterial() )

		for i = 1, 2 do
			rag:SetBodygroup( i, self:GetBodygroup( i ) )
		end
		self.Ragdoll = rag

		rag.CollideVar = true

		timer.Simple( 32, function()
			if IsValid( rag ) && rag != GAMEMODE:GetUC():GetRagdollEntity() then
				rag:Remove()
			end
		end )

		return rag

	end*/

	function meta:StopTaunting()
		self:SetNet( "IsTaunting", false )
	end
	
	function meta:Taunt( t, playback )

		if !IsValid( self ) || self:GetNet( "IsChimera" ) || self:IsGhost() || self.IsDead || self:GetNet( "IsTaunting" ) then return end

		self:SetNet( "IsTaunting", true )
		
		//for achievement
		local uc = GAMEMODE:GetUC()

		if IsValid( uc ) then
			local dist = self:GetPos():Distance( uc:GetPos() )
			if dist <= 812 && uc:Alive() && !uc.Pressed then
				self:AddAchievement( ACHIEVEMENTS.UCHTAUNTING, 1 )
			end
		end

		self:SetCycle( 0 )
		local seq = self:LookupSequence( t )
		self:ResetSequence( seq )
		
		self:PlaybackRateOV( playback )
		RestartAnimation( self )

		timer.Simple( self:SequenceDuration() * ( .98 / 1 /*self:GetNet( "PlaybackRate" )*/ ), function()
			if IsValid( self ) then

				self:StopTaunting()
				self:PlaybackReset()

			end
		end )
		
	end
	
	
	function meta:SetView( num )
		self:SetViewOffset( Vector( 0, 0, num))
		self:SetViewOffsetDucked( Vector( 0, 0, ( num * .75)))
	end

	/*function meta:PlaySpawnSound()  //replaced by a 100 times better music system

		if self:IsGhost() then return end
		
		self.LastSpawnSound = self.LastSpawnSound || 0
		
		if CurTime() >= self.LastSpawnSound then
			
			local rank = self:GetRankName()

			if self.IsChimera then
				rank = "chimera"
			end

			self:SendSound( "UCH/music/cues" .. rank:lower() .. "_spawn.wav" )
			self.LastSpawnSound = CurTime() + 15

		end

	end*/
	
	hook.Add( "Think", "UC_Swimming", function()
		for k, ply in pairs( player.GetAll() ) do

			if ply:WaterLevel() > 0 then

				if ply:IsOnGround() && ply:WaterLevel() <= 2 then
					if ply.IsSwimming then
						ply.IsSwimming = false
					end
				else
					if !ply.IsSwimming then
						ply.IsSwimming = true
					end
				end

			else

				if ply.IsSwimming then
					ply.IsSwimming = false
				end

			end

		end
		
	end )

end

/*if SERVER then return end

usermessage.Hook( "CreateUCHRagdoll", function( um )

	local ply = um:ReadEntity()
	//local rag = ply:CreateRagdoll()
	local pig = ( ply:Team() == TEAM_PIGS )

	local rag = ent:BecomeRagdollOnClient()
	if !IsValid( rag ) then	return end

	rag:SetModel( ply:GetModel() )
	rag:SetPos( ply:GetPos() )
	rag:SetAngles( ply:GetAngles() )
	rag:SetCollisionGroup( COLLISION_GROUP_DEBRIS )

	local entvel
	local entphys = ply:GetPhysicsObject()

	if IsValid( entphys ) then
		entvel = entphys:GetVelocity()
	else
		entvel = ply:GetVelocity()
	end

	for i = 1, rag:GetPhysicsObjectCount() do

		local bone = rag:GetPhysicsObjectNum( i )
		if IsValid( bone ) then

			local bonepos, boneang = ply:GetBonePosition( rag:TranslatePhysBoneToBone( i ) )
			bone:SetPos( bonepos )
			bone:SetAngles( boneang )
			
			if pig && IsValid( GAMEMODE:GetUC() ) then
				
				local fwd = GAMEMODE:GetUC():GetForward()
				fwd.z = 0
				fwd:Normalize()
				
				entvel = entvel + ( fwd * 3200 ) + Vector( 0, 0, 1600 )
				
			end
			
			bone:ApplyForceOffset( ply:GetVelocity(), ply:GetPos() )
			bone:AddVelocity( entvel )

		end

	end

	rag:SetSkin( ply:GetSkin() )
	rag:SetColor( ply:GetColor() )
	rag:SetMaterial( ply:GetMaterial() )

	for i = 1, 2 do
		rag:SetBodygroup( i, ply:GetBodygroup( i ) )
	end

	timer.Simple( 32, function()
		if IsValid( rag ) then
			rag:Remove()
		end
	end )

end )*/