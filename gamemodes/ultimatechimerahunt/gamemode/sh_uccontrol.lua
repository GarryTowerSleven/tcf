local meta = FindMetaTable( "Player" ) 
if !meta then
	Msg("ALERT! Could not hook Player Meta Table\n")
	return
end

local roardistance = 450
local stuntime = 5

function meta:RoarCooldown() -- Sorry if this is bad >_>
	return( math.Clamp( self:GetNet( "TimesRoared" ) * 5 + 15, 15, 30) )
end

function meta:CanDoAction()
	
	self.LastAction = self.LastAction || 0
	return self:Alive() && !self:GetNet( "IsBiting" ) && !self:GetNet( "IsRoaring" ) && !self:GetNet( "IsStunned" ) && CurTime() >= self.LastAction

end

function meta:ResetUCVars()

	self:SetNet( "IsBiting", false )
	self:SetNet( "IsRoaring", false )
	self:SetNet( "TimesRoared", 0 )

end

function meta:Stun()

	self.StunnedTime = CurTime() + stuntime
	self:SetNet( "IsStunned", true )
	self:SetNet( "Sprint", 0 )
	self:StunEffect()

	/*local eff = EffectData()
		eff:SetEntity( self )
	util.Effect( "chimera_stunned", eff )*/

end

function meta:StunEffect()

	local effectdata = EffectData()
	local pos, ang = self:GetBonePosition(36)

	if pos then

		pos = pos + ang:Up() * 4 + ang:Right() * 4

	else

		pos = self:WorldSpaceCenter()

	end

		effectdata:SetOrigin(pos || self:WorldSpaceCenter())
		effectdata:SetNormal(Angle(math.random(0, 30), math.random(-180, 180), 0):Forward())
		effectdata:SetScale(stuntime)
		effectdata:SetFlags(2)
		effectdata:SetEntity(self)
	util.Effect("saturn_stars", effectdata)

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

		if ( v:IsPlayer() && ( !v:GetNet( "IsChimera" ) && !v:IsGhost() ) ) || !v:IsPlayer() then
			
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

hook.Add( "StartCommand", "UC_Chimera", function( ply, cmd )

	if ply:GetNet( "IsChimera" ) && ply:Alive() then

		local s = ply:GetNet( "Sprint" )

		if cmd:KeyDown( IN_SPEED ) then

			if s == 0 || ply.Holding then

				cmd:RemoveKey( IN_SPEED )
				ply:SetNet( "IsSprinting", false )
				ply.Holding = true

			elseif s > 0.2 then

				ply:SetNet( "IsSprinting", true )

			end

		else

			ply:SetNet( "IsSprinting", false )
			ply.Holding = false

		end

		if s <= 0.02 && cmd:KeyDown( IN_JUMP ) && !ply:GetNet( "IsStunned" ) then

			cmd:RemoveKey( IN_JUMP )

		end

	end

end)

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
				local num = ( ply:GetNet( "IsSprinting" ) && .075 ) || .025
				ply:SetNet( "Sprint", math.Clamp( ply:GetNet( "Sprint" ) - num, 0, 1 ) )
			end
	
		else

			if ply:CanDoubleJump() && ply:GetNet( "DoubleJumpNum" ) < 1 then
				ply:DoubleJump()
			end

		end

	end	
	
end


/* UC Think Functions */

GM.LastUCThink = 0
local UCsLastStompPlace = {}

function GM:UCThink(uc)
	
	// if !IsValid( self:GetUC() ) then return end

	// local uc = self:GetUC()

	local visible = {}

	for _, ply in ipairs( player.GetAll() ) do
		
		local pos = uc:WorldSpaceCenter()

		if util.QuickTrace( pos, ply:WorldSpaceCenter() - pos, uc ).Entity == ply then

			table.insert( visible, ply )
			
		end

	end

	if uc.StunnedTime then
		uc.LastStun = uc.LastStun or 0

		if uc.LastStun < CurTime() then

			uc:EmitSound("ambient/energy/spark" .. math.random(6) .. ".wav")
			uc.LastStun = CurTime() + math.Rand(0.2, 0.8)

		end

		if uc.StunnedTime < CurTime() then
			uc:SetNet( "IsStunned", false )
			uc.StunnedTime = nil
		end

	end

	if uc:GetNet( "IsRoaring" ) && CurTime() >= self.LastUCThink then

		self.LastUCThink = CurTime() + .1

		for k, v in pairs( player.GetAll() ) do
			
			local b, dis = v:WithinRoarDistance( uc )
			if v != self && b && v:Team() == TEAM_PIGS && v:Alive() then
				
				if !v:GetNet( "IsScared" ) then
				
					local t = ( 3.2 * ( ( 1 - ( dis / roardistance ) ) * 1.8 ) )

					v:Scare( t )					
					uc:SetNet( "Sprint", uc:GetNet( "Sprint" ) + .05 )

				end
				
			end
			
		end
		
		for k, sat in ipairs( ents.FindByClass( "mr_saturn" ) ) do

			local dist = uc:GetPos():Distance( sat:GetPos() )

			if dist <= roardistance && !sat.IsScared then
				uc:AddAchievement( ACHIEVEMENTS.UCHSCARED, 1 )
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

		if uc:CanDoubleJump() && uc:KeyDown( IN_JUMP ) && uc:GetNet( "DoubleJumpNum" ) > 0 then
			uc:DoubleJump()
		end

	else

		uc.LastStomp = uc.LastStomp or 0

		if UCsLastStompPlace[ uc:EntIndex() ] then

			local dist = UCsLastStompPlace[ uc:EntIndex() ]:Distance( uc:GetPos() )
			if uc:MovementKeyDown() && ( uc:GetNet( "IsSprinting" ) && dist >= 8 ) || ( !uc:GetNet( "IsSprinting" ) && dist >= 3 ) && dist < 10 then
				uc.PlayStomp = true
			end

		end
		UCsLastStompPlace[ uc:EntIndex() ] = uc:GetPos()

		if uc.PlayStomp && CurTime() >= uc.LastStomp && uc:IsMoving() then
			uc.LastStomp = CurTime() + (uc:GetNet("IsSprinting") && 0.325 || .5)
			uc.PlayStomp = false
			uc:Stomp()
		end
		
		if !uc:GetNet( "FirstDoubleJump" ) then
			uc:SetNet( "FirstDoubleJump", true )
		end
		if uc:GetNet( "DoubleJumpNum" ) != 0 then
			uc:SetNet( "DoubleJumpNum", 0 )
		end

	end
	
	if uc.Swiping then
		
		if CurTime() >= uc.SwipeTime then
			uc.Swiping = false
		end

		uc:DoPigSwipe()
		
	else

		local swipemeter = uc:GetNet( "SwipeMeter" )
		if swipemeter != 1 then
			local add = .00375
			if self:IsLastPigmasks() then
				add = add * 2
			end
			uc:SetNet( "SwipeMeter", math.Round( math.Clamp( swipemeter + add, 0, 1 ), 3 ) )
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

	self.Step = self.Step or 0
	self.Step = math.fmod(self.Step + 1, 2)
	self:EmitSound( "UCH/chimera/step" .. (self.Step == 0 and "" or 2) .. "_hd.wav", 82, math.random( 94, 105 ) * ( self:GetNet("IsSprinting") && 1.1 || 1 ) * ( self.Step == 1 && 1.05 || 1 ) )
	util.ScreenShake( self:GetPos(), 5, 5, .5, ( roardistance * 1.85 ) )

end

hook.Add( "PlayerDisconnected", "ResetStompWalk", function( ply )

	UCsLastStompPlace[ ply:EntIndex() ] = nil

end )


/* Double Jump Functions */

function meta:CanDoubleJump()

	local add = 36 //how much to increase the required z velocity per jump
	local numjumps = 1 //how many jumps you're allowed before increasing the required z velocity

	local num = -( 150 - ( add * numjumps ) + ( add * ( self:GetNet( "DoubleJumpNum" ) or 0 ) ) )
	local penalty = math.Clamp( self:GetNet( "Sprint" ) - ( GAMEMODE.DJumpPenalty * ( 1 + ( self:GetNet( "DoubleJumpNum" ) * .66 ) ) ), 0, 1 )

	local sprint = self:GetNet( "Sprint" )

	if sprint > 0.02 && sprint > penalty && !self:IsOnGround() && ( ( self:GetVelocity().z < num ) || self:GetNet( "FirstDoubleJump" ) ) then
		return true
	end
	
	return false
	
end

function meta:DoubleJump()

	local vel = self:GetVelocity()

	if self:GetNet( "Sprint" ) <= .025 then
		vel.x = vel.x * .5
		vel.y = vel.y * .5
	end

	vel.z = 275
	self:SetGroundEntity( nil )
	self:SetLocalVelocity( vel )
	
	self:SetNet( "Sprint", math.Clamp( self:GetNet( "Sprint" ) - ( GAMEMODE.DJumpPenalty * ( 1 + ( self:GetNet( "DoubleJumpNum" ) * .66 ) ) ), 0, 1 ) )
	self:SetNet( "FirstDoubleJump", false )
	self:SetNet( "DoubleJumpNum", self:GetNet( "DoubleJumpNum" ) + 1 )

	self:EmitSound( "UCH/chimera/double_jump.wav", 75, 100 - ( self:GetNet( "DoubleJumpNum" ) * 2.5 ) ) 

	RestartAnimation( self )

end


/* Swipe Functions */

local swipedelay = .5

function meta:CanDoTailSwipe()

	if !self:CanDoAction() then return false
	end
	
	if self:Alive() && !self:GetNet( "IsRoaring" ) && !self:GetNet( "IsBiting" ) && CurTime() >= ( ( self.SwipeTime || 0 ) + .15 ) && self:GetNet( "SwipeMeter" ) >= .25 then
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
	
	self.SwipePower = self:GetNet( "SwipeMeter" )
	self:SetNet( "SwipeMeter", 0 )

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

			if !v:GetNet( "IsStunned" ) && v.CanBeSwiped then
			
				v:SetNet( "IsStunned", true )
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
					v:SetNet( "IsStunned", false )
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

		if !self:Alive() || !self:GetNet( "IsChimera" ) then return end
		
		if v:IsPlayer() && v:Alive() && v:Team() == TEAM_PIGS && !self.Squashed && !v:GetNet( "IsPancake" ) && !v:IsGhost() then

			v.Bit = true
			
			if v:GetNet( "IsTaunting" ) then -- silly
				v:Kill()
				self:AddAchievement( ACHIEVEMENTS.UCHSHOWBOATING, 1 )
			else
				v:Kill()
			end
			
			//v:Spawn()
			//v:CreateUCHRagdoll( true )

			umsg.Start( "UCMakeRagFly" )
				umsg.Entity( v )
			umsg.End()
			
			v:AddAchievement( ACHIEVEMENTS.UCHBACON, 1 )
			self:AddAchievement( ACHIEVEMENTS.UCHCHOMP, 1 )
			
			self:HighestRankKill( v:GetNet( "Rank" ) )

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
					for _, v in ipairs( player.GetAll() ) do
						GAMEMODE:HUDMessage( v, MSG_MRSATURNDEAD, 5 )
					end
				end )

			end

		end

	end

	function meta:Roar()
		
		self.LastRoar = self.LastRoar or 0

		if !self:CanDoAction() || CurTime() < self.LastRoar then return end

		self:SetNet( "TimesRoared", self:GetNet( "TimesRoared" ) + 1 )
		
		self.LastRoar = CurTime() + self:RoarCooldown()

		self:SetNet( "IsRoaring", true )
		
		local seq = self:LookupSequence( "idle3" )
		self:ResetSequence( seq )
		
		local dur = self:SequenceDuration()
		
		RestartAnimation( self )
		
		self:EmitSound( "UCH/chimera/roar_hd.wav", 82, math.random( 94, 105 ) )
		util.ScreenShake( self:GetPos(), 5, 5, dur * .96, roardistance * 1.85, true )
		
		timer.Simple( dur * .96, function()

			if IsValid( self ) then

				self:SetNet( "IsRoaring", false )
				
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
	
		self:SetNet( "IsBiting", true )
	
		local seq = self:LookupSequence( "bite" )
		self:ResetSequence( seq )
	
		local dur = self:SequenceDuration()
		RestartAnimation( self )
	
		self:EmitSound( "UCH/chimera/bite_hd.wav", 80, math.random( 94, 105 ) )
	
		timer.Simple( dur * .98, function()
			self:SetNet( "IsBiting", false )
		end )

		local tbl = self:FindThingsToBite()
		if #tbl >= 1 then

			for k, v in pairs( tbl ) do

				timer.Simple( .32, function()
					if IsValid( self ) && IsValid( v ) then
						// v:ScreenFade(SCREENFADE.IN, color_black, 0.33, 0)
						v:SetNoDraw( false )
						self:DoBiteThing( v )
					end
				end )

				if v:IsPlayer() then
					v:Freeze( true )
					// v:ScreenFade(SCREENFADE.OUT, color_black, 0.3, 0.1)
				end

			end

		end

		self.LastAction = CurTime() + ( dur * 1.05 )

	end

	function meta:FindEnts( tbl, dis, num )
	
		self:LagCompensation(true)
		local pos = self:GetPos()
		local forward = self:GetForward() * num
	
		local entitiesInFront = {}
		for i, e in ipairs( tbl ) do

			if e != self and forward:Dot( ( e:GetPos() - pos ):GetNormalized() ) <= dis then
				table.insert( entitiesInFront, e )
			end

		end
		
		self:LagCompensation(false)

		return entitiesInFront

	end

	function meta:CanPressButton()

		local uc = GAMEMODE:GetUC()
		
		if !GAMEMODE:IsPlaying() then return false end
		if !IsValid( uc ) || !uc:Alive() || self:GetNet( "IsScared" ) || self:IsGhost() || self:GetNet( "IsStunned" ) || self:GetNet( "IsPancake" ) || self:GetNet( "HasSaturn" ) then
			return false
		end

		local pos = uc:GetShootPos()
	
		local fwd = uc:GetForward()
		fwd.z = 0
		fwd = fwd:GetNormal()
	
		pos = pos + ( fwd * -6 )
	
		self:LagCompensation(true)
		local tr = self:GetEyeTrace()
		self:LagCompensation(false)
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

		if LocalPlayer():GetNet( "IsStunned" ) then ply.RoarMeterSmooth = 0 end

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
		local diff = math.abs( swipeSmooth - ply:GetNet( "SwipeMeter" ) )

		swipeSmooth = math.Approach( swipeSmooth, ply:GetNet( "SwipeMeter" ), FrameTime() * ( diff * 5 ) )

		if LocalPlayer():GetNet( "IsStunned" ) then swipeSmooth = 0 end

		draw.RoundedBox( 0, x, y, w, h, Color( 130, 130, 130, 255 ) )
		draw.RoundedBox( 0, x, y, w * .25 , h, Color( 100, 100, 100, 255 ) )

		surface.SetTexture( mat )
		surface.SetDrawColor( Color( 250, 120, 5, 255 ) )
		surface.DrawTexturedRect( x, y, w * swipeSmooth, h )

	end

end
