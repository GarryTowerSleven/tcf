local meta = FindMetaTable( "Player" ) 
if !meta then
	Msg("ALERT! Could not hook Player Meta Table\n")
	return
end

local roardistance = 450
local roarcooldown = 12
local stuntime = 5

function meta:CanDoAction()
	
	self.LastAction = self.LastAction || 0
	return self:Alive() && !self:GetNWBool( "IsBiting" ) && !self:GetNWBool( "IsRoaring" ) && !self:GetNWBool( "IsStunned" ) && CurTime() >= self.LastAction

end

function meta:ResetUCVars()

	self:SetNWBool( "IsBiting", false )
	self:SetNWBool( "IsRoaring", false )

end

function meta:Stun()

	self.StunnedTime = CurTime() + stuntime
	self:SetNWBool( "IsStunned", true )
	self:SetNWFloat( "Sprint", 0 )

	/*local eff = EffectData()
		eff:SetEntity( self )
	util.Effect( "chimera_stunned", eff )*/

end

function meta:StunEffect()

	local effectdata = EffectData()
		effectdata:SetStart(self:GetPos())
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetScale(5)
		effectdata:SetMagnitude(10)
		effectdata:SetEntity(self)
	util.Effect("TeslaHitBoxes", effectdata)

end

function meta:HighestRankKill( rank )  //used for payout

	if !self.HighestKilledRank then
		self.HighestKilledRank = rank or 0
		return
	end
	
	if rank > self.HighestKilledRank then
		self.HighestKilledRank = rank
	end

end

local function playerGetAllMinus( ent )

	local tbl = {}

	for k, v in pairs( player.GetAll() ) do
		if v != ent then
			table.insert( tbl, v )
		end
	end

	return tbl

end

function meta:FindThingsToBite()

	local tbl = {}
	
	local pos = self:GetShootPos()
	local fwd = self:GetForward()

	fwd.z = 0
	fwd = fwd:GetNormal()
	local vec = ( ( pos + Vector( 0, 0, -16 ) ) + ( fwd * 60 ) )
	local rad = 70

	debugoverlay.Sphere( vec, rad )
	for k, v in pairs( ents.FindInSphere( vec, rad ) ) do

		if ( v:IsPlayer() && ( !v:GetNWBool( "IsChimera" ) && !v:GetNWBool( "IsGhost" ) ) ) || !v:IsPlayer() then
			
			local pos = self:GetShootPos()
			local epos = v:IsPlayer() && v:GetShootPos() || v:GetPos()
			local tr = util.QuickTrace( pos, (epos - pos ) * 10000, playerGetAllMinus( v ) )
			debugoverlay.Line( pos, tr.HitPos, 3, Color( 255, 0, 0 ) )

			if IsValid( tr.Entity ) && tr.Entity == v then
				table.insert( tbl, v )
			end

		end

		if v:GetClass() == "func_breakable" || v:GetClass() == "func_breakable_surf" then
			table.insert( tbl, v )
		end

	end

	return tbl
	
end

function meta:WithinRoarDistance( uc )

	local pos, ucpos = self:GetShootPos(), uc:GetShootPos()
	local dis = pos:Distance( ucpos )
	local tr = util.QuickTrace( ucpos, ( pos - ucpos ) * 10000, playerGetAllMinus( self ) )

	if dis <= roardistance then

		if IsValid( tr.Entity ) && tr.Entity == self then
			return true, dis
		else
			return false, 0
		end

	end
	
	return false, 0

end

function meta:CreateBirdProp()

	local bird = ents.Create( "prop_physics" )
	bird:SetModel( "models/uch/birdgib.mdl" )
	
	local pos = self:GetPos()
	local fwd = self:GetForward()
	pos = ( pos + Vector( 0, 0, 12 ) ) + ( fwd * 25 )
	
	bird:SetPos( pos )
	
	bird:SetAngles( self:GetAngles())
	bird:Spawn()
	bird:SetCollisionGroup( COLLISION_GROUP_DEBRIS )

	GAMEMODE.BirdProp = bird

end

function GM:UCKeyPress( ply, key )

	if ply:IsOnGround() && self:IsPlaying() then
	
		if key == IN_ATTACK then  //bite
			ply:Bite()
		end
		
		if key == IN_ATTACK2 then  //roar
			ply:Roar()
		end
		
		if key == IN_RELOAD then
			if ply:CanDoTailSwipe() then
				ply:DoTailSwipe()
			end
		end
		
	end
	
	if key == IN_JUMP then

		ply.Jumped = true

		if ply:IsOnGround() then

			if ply:CanSprint() then
				local num = ( ply:GetNWBool( "IsSprinting" ) && .075 ) || .025
				ply:SetNWFloat( "Sprint", math.Clamp( ply:GetNWInt( "Sprint" ) - num, 0, 1 ) )
			end
	
		else

			if ply:CanDoubleJump() && ply:GetNWInt( "DoubleJumpNum" ) < 1 then
				ply:DoubleJump()
			end

		end

	end	
	
end


/* UC Think Functions */

GM.LastUCThink = 0
local UCsLastStompPlace = {}

function GM:UCThink()
	
	if !IsValid( self:GetUC() ) then return end

	local uc = self:GetUC()

	if uc.StunnedTime then
		uc:StunEffect()
		if uc.StunnedTime < CurTime() then
			uc:SetNWBool( "IsStunned", false )
			uc.StunnedTime = nil
		end
	end

	if uc:GetNWBool( "IsRoaring" ) && CurTime() >= self.LastUCThink then

		self.LastUCThink = CurTime() + .1

		for k, v in pairs( player.GetAll() ) do
			
			local b, dis = v:WithinRoarDistance( uc )
			if v != self && b && v:Team() == TEAM_PIGS && v:Alive() then
				
				if !v:GetNWBool( "IsScared" ) then
				
					local t = ( 3.2 * ( ( 1 - ( dis / roardistance ) ) * 1.8 ) )

					v:Scare( t )					
					uc:SetNWFloat( "Sprint", uc:GetNWInt( "Sprint" ) + .05 )

				end
				
			end
			
		end
		
		for k, sat in ipairs( ents.FindByClass( "mr_saturn" ) ) do

			local dist = uc:GetPos():Distance( sat:GetPos() )

			if dist <= roardistance && !sat:GetNWBool( "IsScared" ) then
				sat:Scare()
			end

		end

	end
	
	uc:SetDuckSpeed( 6000 ) //blah hacky

	uc.PlayStomp = uc.PlayStomp or false

	if !uc:IsOnGround() then

		if !uc.PlayStomp then
			uc.PlayStomp = true
		end

		if uc:CanDoubleJump() && uc:KeyDown( IN_JUMP ) && uc:GetNWInt( "DoubleJumpNum" ) > 0 then
			uc:DoubleJump()
		end

	else

		uc.LastStomp = uc.LastStomp or 0

		if UCsLastStompPlace[ uc:EntIndex() ] then

			local dist = UCsLastStompPlace[ uc:EntIndex() ]:Distance( uc:GetPos() )
			if uc:MovementKeyDown() && ( uc:GetNWBool( "IsSprinting" ) && dist >= 8 ) || ( !uc:GetNWBool( "IsSprinting" ) && dist >= 3 ) && dist < 10 then
				uc.PlayStomp = true
			end

		end
		UCsLastStompPlace[ uc:EntIndex() ] = uc:GetPos()

		if uc.PlayStomp && CurTime() >= uc.LastStomp && uc:IsMoving() then
			uc.LastStomp = CurTime() + .5
			uc.PlayStomp = false
			uc:Stomp()
		end
		
		if !uc:GetNWBool( "FirstDoubleJump" ) then
			uc:SetNWBool( "FirstDoubleJump", true )
		end
		if uc:GetNWInt( "DoubleJumpNum" ) != 0 then
			uc:SetNWInt( "DoubleJumpNum", 0 )
		end

	end
	
	if uc.Swiping then
		
		if CurTime() >= uc.SwipeTime then
			uc.Swiping = false
		end

		uc:DoPigSwipe()
		
	else

		local swipemeter = uc:GetNWFloat( "SwipeMeter" )
		if swipemeter != 1 then
			local add = .00375
			if self:IsLastPigmasks() then
				add = add * 2
			end
			uc:SetNWFloat( "SwipeMeter", math.Round( math.Clamp( swipemeter + add, 0, 1 ), 3 ) )
		end

	end

	local pig = uc:GetGroundEntity()

	if IsValid( pig ) && uc:Alive() then

		if pig:IsPlayer() && pig:IsPig() then

			//local vel = uc.StompVel or uc:GetVelocity()
			//if vel.z < -250 then
				pig:Pancake()
			//end
		
		end

	else
		uc.StompVel = uc:GetVelocity()
	end

end

function meta:Stomp()

	self:EmitSound( "UCH/chimera/step.wav", 82, math.random( 94, 105 ) )
	util.ScreenShake( self:GetPos(), 5, 5, .5, ( roardistance * 1.85 ) )

end

hook.Add( "PlayerDisconnected", "ResetStompWalk", function( ply )

	UCsLastStompPlace[ ply:EntIndex() ] = nil

end )


/* Double Jump Functions */

function meta:CanDoubleJump()

	local add = 36 //how much to increase the required z velocity per jump
	local numjumps = 1 //how many jumps you're allowed before increasing the required z velocity

	local num = -( 150 - ( add * numjumps ) + ( add * ( self:GetNWInt( "DoubleJumpNum" ) or 0 ) ) )

	if !self:IsOnGround() && ( ( self:GetVelocity().z < num ) || self:GetNWBool( "FirstDoubleJump" ) ) then
		return true
	end
	
	return false
	
end

function meta:DoubleJump()

	local vel = self:GetVelocity()

	if self:GetNWFloat( "Sprint" ) <= .025 then
		vel.x = vel.x * .5
		vel.y = vel.y * .5
	end

	vel.z = 275
	self:SetGroundEntity( nil )
	self:SetLocalVelocity( vel )
	
	self:SetNWFloat( "Sprint", math.Clamp( self:GetNWFloat( "Sprint" ) - ( GAMEMODE.DJumpPenalty * ( 1 + ( self:GetNWInt( "DoubleJumpNum" ) * .66 ) ) ), 0, 1 ) )
	self:SetNWBool( "FirstDoubleJump", false )
	self:SetNWInt( "DoubleJumpNum", self:GetNWInt( "DoubleJumpNum" ) + 1 )

	self:EmitSound( "UCH/chimera/double_jump.wav", 75, 100 - ( self:GetNWInt( "DoubleJumpNum" ) * 2.5 ) ) 

	RestartAnimation( self )

end


/* Swipe Functions */

local swipedelay = .5

function meta:CanDoTailSwipe()

	if !self:CanDoAction() then return false
	end
	
	if self:Alive() && !self:GetNWBool( "IsRoaring" ) && !self:GetNWBool( "IsBiting" ) && CurTime() >= ( ( self.SwipeTime || 0 ) + .15 ) && self:GetNWFloat( "SwipeMeter" ) >= .25 then
		return true
	end

	return false
	
end

function meta:FindSwipablePigs()

	local tbl = {}
	
	local pos = self:GetShootPos()
	local fwd = self:GetForward()

	fwd.z = 0
	fwd = fwd:GetNormal()
	local vec = ( pos + ( ( fwd * -1 ) * 78 ) )
	local rad = 80
	
	//debugoverlay.Sphere( vec, rad )

	for k, v in pairs( ents.FindInSphere( vec, rad ) ) do
		
		if ( v:IsPlayer() && v:IsPig() ) || ( v:GetClass() == "mr_saturn" ) then
			
			local pos = self:GetShootPos()
			local epos = ( v:IsPlayer() && v:GetShootPos() ) || v:GetPos()
			local tr = util.QuickTrace( pos, ( epos - pos ) * 10000, playerGetAllMinus( v ) )
			//debugoverlay.Line( pos, tr.HitPos, 3, Color( 255, 0, 0 ) )

			if IsValid( tr.Entity ) && tr.Entity == v then
				table.insert( tbl, v )
			end

		end

	end
	
	return tbl
	
end

function meta:DoTailSwipe()

	umsg.Start( "TailSwipe" )
		umsg.Entity( self )
	umsg.End()

	self:EmitSound( "UCH/chimera/tailswipe.wav", 75, math.random( 90, 105 ) )
	
	self.SwipePower = self:GetNWFloat( "SwipeMeter" )
	self:SetNWFloat( "SwipeMeter", 0 )

	self.Swiping = true
	self.SwipeTime = CurTime() + swipedelay
	
end

function meta:DoPigSwipe()
	
	if !self.Swiping then return end

	local pigs = self:FindSwipablePigs()

	if #pigs >= 1 then

		for k, v in pairs( pigs ) do
			
			if v.CanBeSwiped == nil then
				v.CanBeSwiped = true
			end

			if !v:GetNWBool( "IsStunned" ) && v.CanBeSwiped then
			
				v:SetNWBool( "IsStunned", true )
				v.CanBeSwiped = false
				
				if v:GetClass() != "mr_saturn" then
					v:UpdateSpeeds()
					v:StopTaunting()
				end

				local pos = self:GetPos()
				local epos = v:GetPos()

				pos.z, epos.z = 0, 0
				local dir = ( epos - pos ):GetNormal()
				v:SetGroundEntity( nil )

				local vel = ( dir * 300 ) + Vector( 0, 0, 340 )
				local num = math.Clamp( self.SwipePower * 1.32, 0, 1 )
				vel = vel * num
				v:SetLocalVelocity( vel )

				timer.Simple( self.SwipePower, function()
					v:SetNWBool( "IsStunned", false )
				end )

				timer.Simple( 1, function()
					v.CanBeSwiped = true
				end )

			end

		end

	end

end


if SERVER then

	function meta:DoBiteThing( v )

		if !self:Alive() || !self:GetNWBool( "IsChimera" ) then return end
		
		if v:IsPlayer() && v:Alive() && v:Team() == TEAM_PIGS && !self.Squashed && !v:GetNWBool( "IsPancake" ) && !v:GetNWBool( "IsGhost" ) then

			v.Bit = true
			v:Kill()
			//v:Spawn()
			//v:CreateUCHRagdoll( true )

			umsg.Start( "UCMakeRagFly" )
				umsg.Entity( v )
			umsg.End()
			
			v:AddAchievement( ACHIEVEMENTS.UCHBACON, 1 )
			self:AddAchievement( ACHIEVEMENTS.UCHCHOMP, 1 )
			
			self:HighestRankKill( v:GetNWInt( "Rank" ) )

			v:ResetRank()

		else

			local fwd = v:GetPos() - self:GetPos()
			fwd.z = 0
			fwd = fwd:GetNormal()
			
			local phys = v:GetPhysicsObject()
			if IsValid( phys ) then
				local dir = fwd * 35000
				phys:ApplyForceCenter( dir + Vector( 0, 0, 16000 ) )
			end

			v:TakeDamage( 1 )
			if v:Health() > 0 then
				v:Fire( "break" )
			end
			
			if v:GetClass() == "mr_saturn" then

				timer.Simple( 2, function()
					v:Explode()
					v:Remove()
					GAMEMODE:HUDMessage( nil, MSG_MRSATURNDEAD, 5 )
				end )

			end

		end

	end

	function meta:Roar()
		
		self.LastRoar = self.LastRoar or 0

		if !self:CanDoAction() || CurTime() < self.LastRoar then return end

		self.LastRoar = CurTime() + roarcooldown

		self:SetNWBool( "IsRoaring", true )
		
		local seq = self:LookupSequence( "idle3" )
		self:ResetSequence( seq )
		
		local dur = self:SequenceDuration()
		
		RestartAnimation( self )
		
		self:EmitSound( "UCH/chimera/roar.wav", 82, math.random( 94, 105 ) )
		util.ScreenShake( self:GetPos(), 5, 5, dur * .96, roardistance * 1.85 )
		
		timer.Simple( dur * .96, function()

			if IsValid( self ) then

				self:SetNWBool( "IsRoaring", false )
				
				umsg.Start( "UCRoared", self ) //let the clientside meter know
					umsg.Float( self.LastRoar )
					umsg.Float( CurTime())
				umsg.End()

			end

		end )
		
		self.LastAction = CurTime() + ( dur * 1.05 )
		
	end

	function meta:Bite()
	
		if !self:CanDoAction() then return end
	
		self:SetNWBool( "IsBiting", true )
	
		local seq = self:LookupSequence( "bite" )
		self:ResetSequence( seq )
	
		local dur = self:SequenceDuration()
		RestartAnimation( self )
	
		self:EmitSound( "UCH/chimera/bite.wav", 80, math.random( 94, 105 ) )
	
		timer.Simple( dur * .98, function()
			self:SetNWBool( "IsBiting", false )
		end )

		local tbl = self:FindThingsToBite()
		if #tbl >= 1 then

			for k, v in pairs( tbl ) do

				timer.Simple( .32, function()
					if IsValid( self ) && IsValid( v ) then
						self:DoBiteThing( v )
					end
				end )

				if v:IsPlayer() then
					v:Freeze( true )
				end

			end

		end

		self.LastAction = CurTime() + ( dur * 1.05 )

	end

	function meta:FindEnts( tbl, dis, num )
	
		local pos = self:GetPos()
		local forward = self:GetForward() * num
	
		local entitiesInFront = {}
		for i, e in ipairs( tbl ) do

			if e != self and forward:Dot( ( e:GetPos() - pos ):GetNormalized() ) <= dis then
				table.insert( entitiesInFront, e )
			end

		end

		return entitiesInFront

	end

	function meta:CanPressButton()

		local uc = GAMEMODE:GetUC()
		
		if !GAMEMODE:IsPlaying() then return false end
		if !IsValid( uc ) || !uc:Alive() || self:GetNWBool( "IsScared" ) || self:GetNWBool( "IsGhost" ) || self:GetNWBool( "IsStunned" ) || self:GetNWBool( "IsPancake" ) then
			return false
		end

		local pos = uc:GetShootPos()
	
		local fwd = uc:GetForward()
		fwd.z = 0
		fwd = fwd:GetNormal()
	
		pos = pos + ( fwd * -6 )
	
		local tr = self:GetEyeTrace()
		if !IsValid( tr.Entity ) then
			return false
		end
	
		local dis = self:GetShootPos():Distance( pos )
		local tblbool = table.HasValue( uc:FindEnts( player.GetAll(), .42, -1 ), self )
	
		if tr.Entity == uc && ( dis <= 92 && !tblbool ) || self:GetGroundEntity() == uc then
			return true
		end

		return false

	end
	
else
	
	local function UCRoared( um )

		local ply = LocalPlayer()
		local t1, t2 = um:ReadFloat(), um:ReadFloat()
		ply.RoarCalc = t1
		ply.RoarT = t2
		ply.RoarMeterSmooth = 0

		/*timer.Simple( ( t1 - CurTime() ) * .95, function()

			if ply.IsChimera then
				surface.PlaySound( "UCH/music/cues/UC_roar_recharged.wav" )
			end

		end )*/

	end
	usermessage.Hook( "UCRoared", UCRoared )


	local sw, sh = ScrW(), ScrH()
	local roarbar = surface.GetTextureID( "UCH/hud_sprint_bar_UC" )

	function GM:DrawRoarMeter( x, y, w, h )
		
		local ply = LocalPlayer()
		
		ply.RoarMeterSmooth = ply.RoarMeterSmooth or 0
		ply.RoarCalc = ply.RoarCalc or 0
		ply.RoarT = ply.RoarT or 0
		
		local mat = roarbar
		local t = CurTime() - ply.RoarT
		local calc = math.Clamp( t / ( ply.RoarCalc - ply.RoarT ), 0, 1 )

		ply.RoarMeterSmooth = math.Approach( ply.RoarMeterSmooth, calc, FrameTime() * 750 )

		if LocalPlayer():GetNWBool( "IsStunned" ) then ply.RoarMeterSmooth = 0 end

		draw.RoundedBox( 0, x, y, w, h, Color( 130, 130, 130, 255 ) )
		surface.SetTexture( mat )
		surface.SetDrawColor( Color( 200, 200, 200, 255 ) )
		surface.DrawTexturedRect( x, y, w * ply.RoarMeterSmooth, h )
		
	end

	local swipebar = surface.GetTextureID( "UCH/hud_sprint_bar" )
	local swipeSmooth = 0
	function GM:DrawSwipeMeter( x, y, w, h )

		local ply = LocalPlayer()

		local mat = swipebar

		local a = ply.SwipeMeterAlpha
		local diff = math.abs( swipeSmooth - ply:GetNWFloat( "SwipeMeter" ) )

		swipeSmooth = math.Approach( swipeSmooth, ply:GetNWFloat( "SwipeMeter" ), FrameTime() * ( diff * 5 ) )

		if LocalPlayer():GetNWBool( "IsStunned" ) then swipeSmooth = 0 end

		draw.RoundedBox( 0, x, y, w, h, Color( 130, 130, 130, 255 ) )
		draw.RoundedBox( 0, x, y, w * .25 , h, Color( 100, 100, 100, 255 ) )

		surface.SetTexture( mat )
		surface.SetDrawColor( Color( 250, 120, 5, 255 ) )
		surface.DrawTexturedRect( x, y, w * swipeSmooth, h )

	end

end
