module( "seats", package.seeall )

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

DEBUGMODE = false

local function HandleRollercoasterAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_GMOD_SIT_ROLLERCOASTER )
end

function CreateSeatAtPos(pos, angle)
	local ent = ents.Create("prop_vehicle_prisoner_pod")
	ent:SetModel("models/nova/airboat_seat.mdl")
	ent:SetKeyValue("vehiclescript","scripts/vehicles/prisoner_pod.txt")
	ent:SetPos(pos)
	ent:SetAngles(angle)
	ent:SetNotSolid(true)
	ent:SetNoDraw(true)

	ent.HandleAnimation = HandleRollercoasterAnimation

	ent:Spawn()
	ent:Activate()

	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end

	return ent
end

hook.Add("KeyRelease", "EnterSeat", function(ply, key)
	if key != IN_USE || ply:InVehicle() || (ply.ExitTime && CurTime() < ply.ExitTime + 1) then return end

	local eye = ply:EyePos()
	local trace = util.TraceLine({start=eye, endpos=eye+ply:GetAimVector()*100, filter=ply})

	if !IsValid(trace.Entity) then return end

	local model = trace.Entity:GetModel()

	local offsets = ChairOffsets[model]
	if !offsets then return end

	local usetable = trace.Entity.UseTable or {}
	local pos = -1

	if #offsets > 1 then
		local localpos = trace.Entity:WorldToLocal(trace.HitPos)
		local bestpos, bestdist = -1

		for k,v in pairs(offsets) do
			local dist = localpos:Distance(v.Pos)
			if !usetable[k] && (bestpos == -1 || dist < bestdist) then
				bestpos, bestdist = k, dist
			end
		end

		if bestpos == -1 then return end
			pos = bestpos
		elseif !usetable[1] then
			pos = 1
		else

		return
	end

	usetable[pos] = true
	trace.Entity.UseTable = usetable

	ply:SetNWVector("SeatEntry",ply:GetPos())
	ply:SetNWVector("SeatEntryAng",ply:EyeAngles())
	ply.SeatEnt = trace.Entity
	ply.SeatPos = pos

	-- disable jetpack when we sit down
	ply.JetpackStart = 0

	local ang = trace.Entity:GetAngles()
	if ( offsets[pos].Ang != nil ) then
		ang:RotateAroundAxis(trace.Entity:GetForward(), offsets[pos].Ang.p)
		ang:RotateAroundAxis(trace.Entity:GetUp(), offsets[pos].Ang.y)
		ang:RotateAroundAxis(trace.Entity:GetRight(), offsets[pos].Ang.r)
	else
		ang:RotateAroundAxis(trace.Entity:GetUp(), -90)
	end

	local s = CreateSeatAtPos(trace.Entity:LocalToWorld(offsets[pos].Pos), ang)
	s:SetParent(trace.Entity)
	s:SetOwner(ply)

	ply:EnterVehicle(s)

	s:EmitSound( ChairSitSounds[model] || DefaultSitSound, 100, 100 )
end)

hook.Add("CanPlayerEnterVehicle", "EnterSeat", function(ply, vehicle)
	if vehicle:GetClass() != "prop_vehicle_prisoner_pod" then return end

	if vehicle.Removing then return false end
	return (vehicle:GetOwner() == ply)
end)

local airdist = Vector(0,0,48)

function TryPlayerExit(ply, ent)
	local pos = ent:GetPos()
	local trydist = 8
	local yawval = 0
	local yaw = Angle(0, ent:GetAngles().y, 0)

	while trydist <= 64 do
		local telepos = pos + yaw:Forward() * trydist
		local trace = util.TraceEntity({start=telepos, endpos=telepos - airdist}, ply)

		if !trace.StartSolid && trace.Fraction > 0 && trace.Hit then
			ply:SetPos(telepos)
			return
		end

		yaw:RotateAroundAxis(yaw:Up(), 15)
		yawval = yawval + 15
		if yawval > 360 then
			yawval = 0
			trydist = trydist + 8
		end
	end

	print("player", ply, "couldn't get out")
end

local function PlayerLeaveVehice( vehicle, ply )

	if vehicle:GetClass() != "prop_vehicle_prisoner_pod" then return end

	if DEBUGMODE then print("exit") end
	if !IsValid(ply.SeatEnt) then
		return true
	end

	if ply.SeatEnt.UseTable then
		ply.SeatEnt.UseTable[ply.SeatPos] = false
	end
	ply.SeatPos = 0
	ply.SeatEnt = nil

	ply.ExitTime = CurTime()
	ply:ExitVehicle()

	ply:SetEyeAngles(ply.EntryAngles)

	local trace = util.TraceEntity({start=ply.EntryPoint, endpos=ply.EntryPoint}, ply)

	if vehicle:GetPos():Distance(ply.EntryPoint) < 128 && !trace.StartSolid && trace.Fraction > 0 then
		ply:SetPos(ply.EntryPoint)
	else
		TryPlayerExit(ply, vehicle)
	end

	vehicle.Removing = true
	vehicle:Remove()

	ply:ResetEquipmentAfterVehicle()
	ply:CrosshairDisable()
	ply:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )

	return false

end

hook.Add("CanExitVehicle", "Leave", PlayerLeaveVehice)

function PlayerExitLeft( ply )

	ply:CrosshairDisable()

	local Vehicle = ply:GetVehicle()

	if IsValid( Vehicle ) then
		PlayerLeaveVehice( Vehicle, ply )
	end
end

hook.Add("PlayerDeath", "VehicleKilled", PlayerExitLeft)
hook.Add("PlayerSilentDeath", "VehicleKilled", PlayerExitLeft)
hook.Add("PlayerDisconnected","VehicleCleanup", PlayerExitLeft)


timer.Create("GTowerCheckVehicle", 10.0, 0, function()
	for _, ply in pairs( player.GetAll() ) do
		local Vehicle = ply:GetVehicle()

		if IsValid( Vehicle ) then
			ply:AddAchivement( ACHIVEMENTS.LONGSEATGETALIFE, 10/60 )
		end
	end
end )

if !DEBUGMODE then return end

DEBUGOFFSETS = {}

hook.Add("InitPostEntity", "CreateSeats", function(ent)
	local phys = ents.FindByClass("prop_physics")

	for k,v in pairs(phys) do
		local model = v:GetModel()
		if ChairOffsets[model] then
			for x,y in pairs(ChairOffsets[model]) do
				local ang = v:GetRight():Angle()
				if NotRight[model] then ang = (v:GetForward() * NotRight[model]):Angle() end

				local s = CreateSeatAtPos(v:LocalToWorld(y), ang)
				s:SetParent(v)
			end
		end
	end
end)

hook.Add("KeyPress", "DebugPos", function(ply, key)
	if key != IN_USE then return end

	local trace = util.TraceLine(util.GetPlayerTrace(ply))
	if !IsValid(trace.Entity) || (trace.Entity:IsVehicle()) then return end

	local ent = CreateSeatAtPos(trace.HitPos, trace.Entity:GetRight():Angle())
	constraint.NoCollide(ent, trace.Entity, 0, 0)

	local model = trace.Entity:GetModel()

	if !DEBUGOFFSETS[model] then DEBUGOFFSETS[model] = {} end

	table.insert(DEBUGOFFSETS[model], {trace.Entity, ent})
end)

concommand.Add("dump_seats", function()

	for k,v in pairs(DEBUGOFFSETS) do
		print("ChairOffsets[\"" .. tostring(k) .. "\"] = {")
		for k,v in pairs(v) do
			if IsValid(v[2]) then
				local offset = v[1]:WorldToLocal(v[2]:GetPos())
				print("\t\tVector(" .. tostring(offset.x) .. ", " .. tostring(offset.y) .. ", " .. tostring(offset.z) .. "),")
			end
		end
		print("}")
	end
end)
