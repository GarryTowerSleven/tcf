/*MOVEMGR = {}
MOVEMGR.segment = {}
MOVEMGR.ents = nil

function MOVEMGR:GetSegment(ply)

	if !self.ents then
		self.ents = ents.FindByClass("player_node")
	end
	if !self.segment[ply] then
		self.segment[ply] = {1, 2}
	end

	return self.ents[self.segment[ply][1]], self.ents[self.segment[ply][2]]

end

function MOVEMGR:GetSegmentPos(ply)

	local s, e = self:GetSegment(ply)
	return s:GetPos(), e:GetPos()

end

function MOVEMGR:GetSegmentAngle(ply)

	local s, e = self:GetSegmentPos(ply)
	return (e-s):Angle()

end

function MOVEMGR:SpawnOnSegment(ply)

	local s, e = self:GetSegmentPos(ply)

	ply:SetPos(s + (e-s) * math.Rand(0.05, 0.2))

end

function GM:Move( ply, data )

	local s, e = MOVEMGR:GetSegmentPos(ply)

	data:SetSideSpeed(0)

	local mo = data:GetOrigin()
	local mv = data:GetVelocity()

	local va = ply:GetAimVector()

	local d = data:GetForwardSpeed()

	if d > 0 then
		data:SetMoveAngles((e-mo):Angle())
	else
		data:SetForwardSpeed(-d)
		data:SetMoveAngles((s-mo):Angle())
	end

end

function GM:CalcView( ply, origin, angles, fov )

	local view = {}

	local right = MOVEMGR:GetSegmentAngle(ply):Right()
	local face = (right * -1):Angle()

	view.origin = ply:EyePos() + right * 300
	view.angles = face
	view.fov = fov

	return view

end


function GM:CreateMove(ucmd)

	for k,v in ipairs( player.GetAll() ) do
		v:SetSolid( SOLID_NONE )
	end

	ucmd:SetForwardMove( ucmd:GetSideMove() )
	ucmd:SetSideMove( 0 )

	if !IsValid( LocalPlayer() ) then return end

	local trace = util.TraceLine( LocalPlayer():GetPlayerTrace() )
	local diff = trace.HitPos - LocalPlayer():GetShootPos()
	local ang = diff:Angle()

	local s, e = MOVEMGR:GetSegmentPos( LocalPlayer() )
	local angs = ( s - e ):Angle()

	local d = diff:Dot( e - LocalPlayer():GetShootPos() )

	if d > 0 then
		ang.y = math.NormalizeAngle( angs.y + 180 )
	else
		ang.y = angs.y
	end

	ucmd:SetViewAngles( ang )

end*/

function GM:CreateMove( cmd )

	if !IsValid( LocalPlayer() ) then return end

	local plyPos = ( LocalPlayer():GetPos() + Vector( 0, 0, 64 ) ):ToScreen()
	local plyvec = Vector( plyPos.x, plyPos.y, 0 )

	local angle = ( plyvec ):Angle()
	local dirang = 0
	local dir = 1

	if LocalPlayer():KeyDown( IN_MOVELEFT ) then

		dirang = 180
		dir = -1

	end

	angle.y = math.AngleDifference( angle.y, 360 ) // This is needed to fix a nasty Out-of-range warning. (Works fine with or without this line though.)

	cmd:SetForwardMove( cmd:GetSideMove() * dir )
	cmd:SetViewAngles( Angle(0, dirang, 64 ) )
	cmd:SetSideMove( 0 )

end

function GM:GUIMousePressed( mc )

	if mc == MOUSE_LEFT then
		RunConsoleCommand( "+attack", "" )
	end

end

function GM:GUIMouseReleased( mc )

	if mc == MOUSE_LEFT then
		RunConsoleCommand( "-attack", "" )
	end

end

function GM:CalcView( ply, origin, angles, fov )

	local view = {}

	local dist = -280
	if self:GetGameState() == STATE_INTERMISSION then
		dist = -150
	end

	view.origin = ply:EyePos() + Vector( 0, dist, 0 )
	view.angles = Angle( 0, 90, 0 )

	return view

end

// this a rough implementation of the WalkMove.. enough to do some prediction
hook.Add( "Move", "BestWalkMoveGuess", function ( ply, movedata )

	local vel = movedata:GetVelocity()
	vel.z = 0
	local groundent = ply:GetGroundEntity()

	// friction
	if groundent != NULL then

		local length = vel:Length()
		if length >= 0.1 then
			local friction = 8
			local control = length
			if length < 50 then
				control = 50
			end
			local drop = control * friction * FrameTime()
			local newspeed = length - drop
			if newspeed < 0 then newspeed = 0 end

			if newspeed != length then
				newspeed = newspeed / length
				vel = vel * newspeed
			end
		end

		// walk move
		local forward = movedata:GetMoveAngles():Forward()
		forward.z = 0
		forward:GetNormalized()

		local walkvel = vel + (forward * movedata:GetForwardSpeed() * 0.15)

		if vel:Length() <= movedata:GetMaxSpeed() && walkvel:Length() > movedata:GetMaxSpeed() then
			walkvel = walkvel * (movedata:GetMaxSpeed() / walkvel:Length())
		end

		vel = walkvel
	else

		// air move, this is rough
		local forward = movedata:GetMoveAngles():Forward()
		forward.z = 0
		forward:GetNormalized()
		forward = forward * movedata:GetForwardSpeed()
		forward:GetNormalized()

		local wishspeed = movedata:GetForwardSpeed()
		if wishspeed > movedata:GetMaxSpeed() then
			wishspeed = movedata:GetMaxSpeed()
		end

		local wishspd = wishspeed
		if wishspd > 30 then
			wishspd = 30
		end

		local currentspeed = movedata:GetVelocity():Dot(forward)

		local addspeed = wishspd - currentspeed

		if addspeed > 0 then
			local accel = 10 * wishspeed * FrameTime() * 0.25
			//print(currentspeed, wishspeed, addspeed, accel)

			if accel > addspeed then
				accel = addspeed
			end

			vel = vel + (accel * forward)
		end

	end

	return vel

end )

if SERVER then return end

local DoublePressTime = nil
function GM:KeyPress( ply, key )

	if key == IN_JUMP then

		if !ply:IsOnGround() then

			if ply:CanDoubleJump() && ply:GetNWInt( "DoubleJumpNum" ) < 1 then
				ply:DoubleJump()
			end

		end

		ply.Speed = 0

	end

	if key == IN_MOVERIGHT || key == IN_MOVELEFT then

		if DoublePressTime && DoublePressTime > CurTime() then

			--RunConsoleCommand( "+speed" )
			return

		end

		DoublePressTime = CurTime() + 0.08

	end

end

function GM:KeyRelease( ply, key )

	if key == IN_MOVERIGHT || key == IN_MOVELEFT then

		--RunConsoleCommand( "-speed" )

	end

	if key != IN_FORWARD && !ply:IsOnGround() then return end

	ply.LastSkid = ply.LastSkid or 0

	if ply.Speed && ply.Speed > 500 then

		if CurTime() > ply.LastSkid && !ply:IsMovementKeyDown() then

			ply.LastSkid = CurTime() + .5

			ply:DoSkidDust( key )
			ply.Speed = 0

		end

	end

end

/*local meta = FindMetaTable("Player")
if !meta then
    Msg( "ALERT! Could not hook Player Meta Table\n" )
    return
end

meta.GetPlayerTrace = function(ply, dir)

	local view = GAMEMODE:CalcView(ply)
	local direction = dir or ply:GetCursorAimVector()
	local trace = {start=view.origin,
			endpos=view.origin + direction * 16384, angle = view.angles}
	return trace

end*/
