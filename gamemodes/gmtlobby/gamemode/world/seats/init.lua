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
	ent:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )

	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end
	
	ent.IsSeat = true

	return ent
end

function ForceEnterGivenSeat( seat, ply, hitpos )
	if !IsValid( seat ) || !IsValid( ply ) then return end

	local model = seat:GetModel()
	if not model then return end

	local offsets = ChairOffsets[string.lower(model)]
	if !offsets then return end

	local usetable = seat.UseTable or {}
	local pos = -1

	if hitpos then
		
		if #offsets > 1 then
			local localpos = seat:WorldToLocal(hitpos)
			local bestpos, bestdist = -1
	
			for k, v in pairs(offsets) do
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

	else
		pos = 1
	end

	usetable[pos] = true
	seat.UseTable = usetable

	local ang = seat:GetAngles()
	if NotRight[model] then
		ang:RotateAroundAxis(seat:GetUp(), NotRight[model])
	else
		ang:RotateAroundAxis(seat:GetUp(), -90)
	end

	if NotRight2[model] then
		ang:RotateAroundAxis(seat:GetRight(), NotRight2[model])
	end
	
	local s = CreateSeatAtPos(seat:LocalToWorld(offsets[pos].Pos), ang)
	s:SetParent(seat)
	s:SetOwner(ply)

	s.SeatData = {
		Ent = seat,
		Pos = pos,
		EntryPoint = ply:GetPos(),
		EntryAngles = ply:EyeAngles() // ply:GetAngles()
	}

	ply:EnterVehicle(s)
	ply:SetDriving(s)

	// s:EmitSound( ChairSitSounds[model] or DefaultSitSound, 100, 100 )

	return s
end

hook.Add("KeyRelease", "EnterSeat", function(ply, key)
	if key != IN_USE || ply:InVehicle() || (ply.ExitTime && CurTime() < ply.ExitTime + 1) then return end

	local eye = ply:EyePos()
	local trace = util.TraceLine({start=eye, endpos=eye+ply:GetAimVector()*100, filter=ply})

	if !IsValid(trace.Entity) then return end

	if trace.Entity.OnSeatUse and isfunction( trace.Entity.OnSeatUse ) then
		trace.Entity.OnSeatUse( ply )
		return
	end

	ForceEnterGivenSeat( trace.Entity, ply, trace.HitPos )
end)

hook.Add("CanPlayerEnterVehicle", "EnterSeat", function(ply, vehicle)
	if not vehicle.IsSeat then return end

	if vehicle.Removing then return false end
	return vehicle:GetOwner() == ply
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
end

local function PlayerLeaveVehicle( vehicle, ply )
	if not vehicle.IsSeat then return end
	if vehicle.Removing == true then return end

	local seat = vehicle.SeatData

	if not (istable(seat) and IsValid(seat.Ent)) then
		return true
	end

	if vehicle.OnSeatLeave and isfunction( vehicle.OnSeatLeave ) then
		if not vehicle.OnSeatLeave( ply ) then return false end
	end

	if seat.Ent && seat.Ent.UseTable then
		seat.Ent.UseTable[seat.Pos] = false
	end

	if IsValid(ply) and ply:InVehicle() and (CurTime() - (ply.ExitTime or 0)) > 0.001 then

		ply.ExitTime = CurTime()
		ply:ExitVehicle()

		ply:SetEyeAngles(seat.EntryAngles)

		local trace = util.TraceEntity({
			start = seat.EntryPoint,
			endpos = seat.EntryPoint
		}, ply)

		if vehicle:GetPos():Distance(seat.EntryPoint) < 128 && !trace.StartSolid && trace.Fraction > 0 then
			ply:SetPos(seat.EntryPoint)
		else
			TryPlayerExit(ply, vehicle)
		end

		ply:SetDriving( nil )
		
		ply:SetCollisionGroup( COLLISION_GROUP_PLAYER )
	end

	if !vehicle.bSlots then
		vehicle.Removing = true
		vehicle:Remove()
	end

	ply:ReParentCosmetics()

	return false
end

hook.Add( "CanExitVehicle", "Leave", PlayerLeaveVehicle )

function PlayerExitLeft( ply )
	if ply:IsPlayer() then
		local Vehicle = ply:GetVehicle()
		
		if IsValid( Vehicle ) and Vehicle.IsSeat then
			PlayerLeaveVehicle( Vehicle, ply )
		end
	end
end

hook.Add("PlayerDisconnected","VehicleCleanup", PlayerExitLeft)
hook.Add("PlayerLeaveVehicle", "VehicleLeft", PlayerExitLeft)
hook.Add("PlayerDeath", "VehicleKilled", PlayerExitLeft)
hook.Add("PlayerSilentDeath", "VehicleKilled", PlayerExitLeft)
hook.Add("EntityRemoved", "VehicleCleanup", PlayerExitLeft)

timer.Create("GTowerCheckVehicle", 10.0, 0, function()
	for _, ply in pairs( player.GetAll() ) do
		local Vehicle = ply:GetVehicle()

		if IsValid( Vehicle ) then
			ply:AddAchievement( ACHIEVEMENTS.LONGSEATGETALIFE, 10/60 )
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

/*hook.Add("KeyPress", "DebugPos", function(ply, key)
	if key != IN_USE then return end

	local trace = util.TraceLine(util.GetPlayerTrace(ply))
	if !IsValid(trace.Entity) || (trace.Entity:IsVehicle()) then return end

	local ent = CreateSeatAtPos(trace.HitPos, trace.Entity:GetRight():Angle())
	constraint.NoCollide(ent, trace.Entity, 0, 0)

	local model = trace.Entity:GetModel()

	if !DEBUGOFFSETS[model] then DEBUGOFFSETS[model] = {} end

	table.insert(DEBUGOFFSETS[model], {trace.Entity, ent})
end)

concommand.Add( "dump_seats", function()

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
end )*/
