
-----------------------------------------------------
--ENT.Base = "base_point"
--ENT.Type = "point"

ENT.Type 	= "anim"
ENT.Base 	= "base_anim"

function ENT:GetGravityConstant()
	return 600
end

function ENT:EvalTrajectory(t, start, vel)
	local grav = self:GetGravityConstant()
	local p = (start + vel * t)
	p.z = p.z - grav*(0.5*t*t)
	return p, Vector(vel.x, vel.y, vel.z - grav * t)
end

function ENT:GetTrajectory(startPos, pdebug)
	local grav = self:GetGravityConstant()
	local target = self:GetTargetEntity()

	if not IsValid(target) then return end

	--target = player.GetAll()[2]

	startPos = startPos or self:GetPos()

	local targetPos = target:GetPos()
	local dir = (targetPos - startPos)

	local altitude = dir.z
	dir.z = 0
	local range = dir:Length()

	local speed = 1050 + (math.sin(CurTime() * 2 + self:EntIndex()) + 1) * 80
	local height = 600
	local speedSqr = speed*speed
	local speed4 = math.pow(speed, 4)
	local rangeSqr = range*range

	local r = speed4 - grav*(grav * rangeSqr + 2*altitude*speedSqr)
	if r < 0 then
		if pdebug then print("Invalid Trajectory") end
		return Vector(0,0,500)
	end
	local launchAngle = math.atan((speedSqr + math.sqrt(r)) / (grav * range))
	local aimAngle = math.atan2(dir.y, dir.x)

	local right = dir:Cross(Vector(0,0,1))
	local a = Angle(-math.deg(launchAngle),math.deg(aimAngle),0)
	dir = a:Forward()

	if pdebug then print("A: " .. math.deg(launchAngle)) end

	dir:Normalize()

	dir = dir * speed
	--dir.z = dir.z + height

	return dir
end

function __PLAYER_LAUNCHER_PHYSCALLBACK(...)
	for k,v in pairs({...}) do
		print(tostring(k) .. " = " .. tostring(v))
	end
end

function ENT:OnPlayerTouch(ply, t)
	--print("LAUNCH PLAYER!")
	local vel = self:GetTrajectory(ply:GetPos())
	--print(tostring(vel))

	local p,v = self:EvalTrajectory(0, self:GetPos(), vel)

	--ply:SetPos(p)
	--ply:SetVelocity(vel)
	ply.__lastLauncher = self
	ply.__launchTime = t
	ply.__launchStart = ply:GetPos()
	ply.__launchVel = vel
	ply.__launching = true
	ply.__lastTR = {p,v}

end

function ENT:OnStopPlayer(ply, t)
	--print("STOP PLAYER")
	ply.__launching = false
end

function ENT:SetupDataTables()

	self:NetworkVar( "Entity", 0, "TargetEntity" )

end

local function LaunchPadMove(ply, mv)
	if ply.__launching then

		--[[if ply:GetMoveType() ~= MOVETYPE_NOCLIP then
			ply:SetMoveType(MOVETYPE_NOCLIP)
		end]]

		local dt = CurTime() - ply.__launchTime
		local start = ply.__launchStart
		local vel = ply.__launchVel
		local tpos, tvel = ply.__lastLauncher:EvalTrajectory(dt, start, vel)
		local lpos, lvel = ply.__lastTR[1], ply.__lastTR[2]

		if dt > .2 then
			if IsValid(ply.__lastLauncher) then ply.__lastLauncher:OnStopPlayer(ply) end
			return
		end


		--[[local tr = util.TraceHull( {
			start = lpos,
			endpos = tpos,
			filter = ply,
			mins = ply:OBBMins(),
			maxs = ply:OBBMaxs(),
		} )
		if tr.Hit and dt > 0.2 then
			if SERVER then
				if IsValid(ply.__lastLauncher) then ply.__lastLauncher:StopPlayer(ply, CurTime()) end
			else
				if IsValid(ply.__lastLauncher) then ply.__lastLauncher:OnStopPlayer(ply, CurTime()) end
			end
			tpos = tr.HitPos
			--ply:SetMoveType(MOVETYPE_WALK)
		end]]

		mv:SetVelocity(tvel)
		mv:SetOrigin(tpos)

		--print(tostring(tvel))

		ply.__lastTR[1] = mv:GetOrigin()
		ply.__lastTR[2] = mv:GetVelocity()

		return true

	end
	--return true
end
hook.Add("Move", "launchpad_predict_movement", LaunchPadMove)

//ImplementNW() -- Implement transmit tools instead of DTVars
