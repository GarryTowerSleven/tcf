function GM:ShouldDrawLocalPlayer()
	
	if ( LocalPlayer():GetNet( "IsChimera" ) && LocalPlayer():Alive() ) then
		return true
	end
	
	return false
	
end

function GM:CreateMove( cmd )

	if cmd:KeyDown( IN_ATTACK ) && !cmd:KeyDown( IN_USE ) then
		cmd:SetButtons( cmd:GetButtons() + IN_USE )
	end

end

function GM:PlayerBindPress( ply, bind, pressed ) 

	if bind == "+duck" && !ply:IsPig() then
		return true
	end

	/*if bind == "+jump" && pressed then
		// Bhop prevention
		if LocalPlayer():Team() == TEAM_PIGS && ply:IsOnGround() then

			if !ply._CurJump then 
				ply._CurJump = CurTime()
			end

			if !ply._LastJump then
				ply._LastJump = ply._CurJump
			else
				ply._LastJump = nil
				ply._CurJump = CurTime()
				return false
			end

			local diff = ply._CurJump - ply._LastJump
			ply:ChatPrint( tostring( "last: " .. ply._LastJump .. " cur: " .. ply._CurJump .. " diff: " .. diff ) )

			if diff < .5 then
				return true
			end

		end

	end*/

	return false

end

local function TauntAngSafeGuard( ply )

	if !ply.TauntAng then

		local ang = ply:EyeAngles()
		ang.p = 45
		ply.TauntAng = ang

	end

end

function GM:InputMouseApply( cmd, x, y, ang )

	local ply = LocalPlayer()
	
	if ply:IsGhost() then return end

	if ply:GetNet( "IsTaunting" ) || ply:GetNet( "IsRoaring" ) || ( ply:GetNet( "IsChimera" ) && !ply:Alive() ) then

		TauntAngSafeGuard( ply )

		local ang = ply.TauntAng
		
		local y = ( x * -GetConVar( "m_yaw" ):GetFloat() )
		
		ang.y = ang.y + y
		//ang = ang:GetAngles()

		ang.p = 16

		ply.TauntAng = ang

		return true

	end

	if ply:GetNet( "IsBiting" ) then
		return true
	end
		
	return self.BaseClass:InputMouseApply( self, cmd, x, y, ang )

end

local lvec

local function ThirdPersonCamera( ply, pos, ang, fov, dis )

	local view = {}

	lvec = lvec or pos
	lvec = LerpVector( FrameTime() * 16, lvec, pos )

	local dir = ang:Forward()
	local tr = util.QuickTrace( lvec, ( dir * -dis ), player.GetAll())
	
	local trpos = tr.HitPos
	
	if tr.Hit then
		trpos = ( trpos + ( dir * 20))
	end

	view.origin = trpos
	view.angles = ang
	view.fov = fov
	
	return view

	/*local dist = 150
	local center = ply:GetPos() + Vector( 0, 0, 75 )

	// Check for intersections
	local tr = util.TraceLine( { start = center, 
								 endpos = center + ( ang:Forward() * -dist * 0.95 ),
								 filter = filters } )
	if tr.Fraction < 1 then
		dist = dist * ( tr.Fraction * 0.95 )
	end

	// Check for walls
	local trWall = util.TraceHull( { start = center,
								 endpos = center + ( ang:Forward() * -dist * 0.95 ),
								 mins= Vector( -8, -8, -8 ), maxs = Vector( 8, 8, 8 ),
								 filter = filters } )
	if trWall.Fraction < 1 then
		dist = dist * ( trWall.Fraction * 0.95 )
	end

	// Final position
	local finalPos = center + ( ang:Forward() * -dist * 0.95 )

	
	return {
		["origin"] = finalPos,
		["angles"] = Angle(ang.p + 2, ang.y, ang.r)
	}*/

end

local zoom = 0
local vb = CreateClientConVar("gmt_uch_viewbob", "1", true)

function GM:CalcView( ply, pos, ang, fov )

	if ply:IsGhost() then

		local num = 3
		local view = {}

		local bob = ( math.sin( CurTime() * num ) * 4 )

		view.origin = Vector( pos.x, pos.y, ( pos.z + bob ) )
		view.angles = ang
		view.fov = fov

		return view

	end
	
	local tang = ply.TauntAng
	local scared = ply:GetNet("IsScared")

	zoom = math.Approach( zoom, ( scared || ply:GetNet( "IsTaunting" )) && 1 || 0, FrameTime() * 8 )

	local rawr = ply:GetNet( "IsRoaring" )

	if rawr || zoom != 0 then
		
		if !scared then
			TauntAngSafeGuard( ply )
			tang = ply.TauntAng
		else
			ply.Scared = true
		end

		local scared = ply.Scared

		local view = {}
		
		local dir = ( scared and ang or tang ):Forward()
		
		local tr = util.QuickTrace( pos, ( dir * ( ( -115 * ( rawr and 1 or zoom ) ) + ( scared and 15 or 0 ) ) ), player.GetAll() )

		local trpos = tr.HitPos
		
		if ( tr.Hit ) then
			trpos = ( trpos + ( dir * 20 ) )
		end
		
		view.origin = trpos
		
		view.angles = scared and ang or ( ply:GetShootPos() - trpos ):Angle()
		
		view.fov = fov

		view.drawviewer = zoom >= 0.3

		return view
		
	else

		if tang && ply:Alive() then
			
			if !ply:GetNet( "IsChimera" ) then
				tang.p = 0
			end

			tang.r = 0
			ply:SetEyeAngles( tang )
			
			ply.TauntAng = nil
			
		end

		ply.Scared = false
		
	end
	
	if ply:GetNet( "IsChimera" ) then
		
		if ply:Alive() then
			return ThirdPersonCamera( ply, ply:EyePos(), ang, fov, 125 )
		else

			local followang = ang
		
			local rag = ply:GetRagdollEntity()
			if IsValid( rag ) then
				local pos = ( ply:GetPos() - ( ply:GetForward() * 800 ) )
				followang = ( ( rag:GetPos() - Vector( 0, 0, 100 ) ) - pos ):Angle()
			end
			
			local view = {}
			view.origin = ( pos + Vector( 0, 0, 25 ) )
			view.angles = followang
			view.fov = fov
			
			return view

		end
		
	end

	local vb2 = vb:GetFloat()
	if vb2 > 0 then
		local vel = LocalPlayer():GetVelocity()
		local vel2d = vel:Length2D()
		local l = vel2d / LocalPlayer():GetWalkSpeed()
		l = l * vb2

		local roll = vel:Dot(ang:Right())
		pos = pos + ang:Up() * math.sin(CurTime() * 16) * 0.8 * l
		ang:RotateAroundAxis(ang:Forward(), roll * 0.01)
		ang:RotateAroundAxis(ang:Up(), math.sin(CurTime() * 8) * 0.04 * l)
		ang:RotateAroundAxis(ang:Right(), math.sin(CurTime() * 6) * 0.02 * l)
		return { ply, origin = pos, angles = ang, fov }
	end

end

local function RestartAnimation( um )

	local ply = um:ReadEntity()
	if ply.AnimRestartMainSequence then
		ply:AnimRestartMainSequence()
	end

end
usermessage.Hook( "UC_RestartAnimation", RestartAnimation )