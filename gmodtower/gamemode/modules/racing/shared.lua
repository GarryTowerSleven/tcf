---------------------------------

-----------------------------------------------------


if SERVER then

	--AddCSLuaFile("racing.lua")

end



--print("RACING " .. (SERVER and "SERVER" or "CLIENT"))



module("racing", package.seeall)



MSG_RACE_STARTED = 0

MSG_RACE_CHECKPOINT = 1

MSG_RACE_FAILED = 2

MSG_RACE_FINISHED = 3



local function SafeCall(func, ...)

	if not func then return end

	local b,e = pcall(func, unpack({ ... }))

	if not b then

		print("ERROR: " .. tostring(e))

	end

	return e

end



if SERVER then



	util.AddNetworkString( "RaceInfo" )



	_ACTIVE_RACES = {}

	_RACE_RINGS = _RACE_RINGS or {}



	for k,v in pairs(_RACE_RINGS) do

		if IsValid(v) then v:Remove() end

	end



	_RACE_RINGS = {}



	local function SpawnRaceRing(pos, angle, radius)

		local e = ents.Create( "race_ring" )

		e:SetPos(pos)

		e:SetAngles(angle)

		e:SetRingSize(radius)

		e:Spawn()

		e:Activate()

		table.insert(_RACE_RINGS, e)

		return e

	end



	local function RaceThink()

		for k,v in pairs(_ACTIVE_RACES) do

			v.think()

		end

	end

	hook.Add("Think", "racethink", RaceThink)



	function Destroy( race, pl )

		if SERVER then
			if IsValid(pl) then
				for k,v in pairs(player.GetAll()) do
					v:SendLua([[GTowerChat.Chat:AddText("]]..pl:Name()..[[ has finished the race, winning 10,000 GMC!", Color(85, 225, 100, 255))]])
				end
			end
		end

		if IsValid(race.root) then race.root:Remove() end

		for k,v in pairs(race.nodes) do

			if IsValid(v.entity) then v.entity:Remove() end

		end



		for k,v in pairs(_ACTIVE_RACES) do

			if v == race then

				table.remove(_ACTIVE_RACES, k)

				break

			end

		end



		race = nil

	end



	function Reset( race )

		for k,v in pairs(race.nodes) do

			if IsValid(v.entity) then v.entity:Remove() end

		end

		race.started = false

		race.root:SetState(1)

		race.currentDuration = race.duration

	end



	local function RaceMSG( race, msg )

		SafeCall(function()

			net.Start( "RaceInfo" )

			net.WriteUInt( msg, 2 )

			net.WriteFloat( race.startTime )

			net.WriteFloat( race.currentDuration )

			net.Send( race.player )

		end)

	end



	function Create( racedata )

		if CLIENT then return end



		local data = {}

		local race = {}



		if type(racedata) == "string" then

			for s in string.gmatch(racedata,"[%-*%d*.*%d*]+") do

				local n = tonumber(s)

				table.insert(data, n)

			end

		elseif type(racedata) == "table" then

			for k,v in pairs(racedata) do

				table.insert(data, v.pos.x)

				table.insert(data, v.pos.y)

				table.insert(data, v.pos.z)

				table.insert(data, v.ang.p)

				table.insert(data, v.ang.y)

				table.insert(data, v.ang.r)

			end

		end



		race.nodes = {}

		race.think = function()

			if race.started then

				local dt = CurTime() - race.startTime

				race.timeLeft = race.currentDuration - dt

				if race.timeLeft <= 0 then

					race.timeLeft = 0

					race.started = false

					SafeCall(race.onFail, race, race.player)

					RaceMSG(race, MSG_RACE_FAILED)

					race.player = nil

				end

				if race.addTime then

					race.currentDuration = race.currentDuration + race.addTime

					race.addTime = nil

					SafeCall(race.onTimeAdded, race, race.player)

				end

			end

		end



		table.insert(_ACTIVE_RACES, race)



		for i=1, #data, 6 do

			local pos = Vector(data[i], data[i+1], data[i+2])

			local ang = Angle(data[i+3], data[i+4], data[i+5])

			local radius = 50



			if i == 1 then



				race.root = SpawnRaceRing(pos, ang, radius)

				race.root:SetState(1)

				race.root:SetTriggerCallback(function( ply )

					if race.exclusive and ply ~= race.exclusive then

						return false

					end



					race.started = true

					race.startTime = CurTime()

					race.player = ply

					race.currentDuration = race.duration

					SafeCall( race.onStart, race, ply )



					RaceMSG(race, MSG_RACE_STARTED)



					local last = race.root

					for k,v in pairs(race.nodes) do

						v.entity = SpawnRaceRing(v.pos, v.ang, v.radius)

						v.entity:SetTriggerCallback(function( ply )

							SafeCall( race.onCheckpoint, race, ply )



							race.think()



							RaceMSG(race, MSG_RACE_CHECKPOINT)

						end)



						last:SetNextRing(v.entity)

						last = v.entity

					end



					last:SetTriggerCallback(function( ply )

						SafeCall( race.onFinished, race, ply )



						RaceMSG(race, MSG_RACE_FINISHED)



						for k,v in pairs(race.nodes) do

							if IsValid(v.entity) then v.entity:Remove() end

							v.entity = nil

						end

					end)



				end)



			else



				table.insert(race.nodes, {

					pos = pos,

					ang = ang,

					radius = radius,

				})



			end



		end



		return race



	end



	local raceData = [[
	setpos 4673.958496 -36.585773 -837.968750;setang -1.227671 89.565880 -0.000000;
	setpos 4677.882813 482.729736 -837.968750;setang -1.005530 89.565880 0.168173;
	setpos 4682.274414 1064.141724 -837.968750;setang -1.338912 89.565880 -0.197140;
	setpos 4683.864258 1667.038208 -837.968750;setang -1.464086 89.975075 0.081410;
	setpos 4682.963379 2143.796631 -837.968750;setang -1.042473 90.384270 0.208470;
	setpos 4621.086426 2291.580078 -837.968750;setang -1.933408 141.397934 0.005091;
	setpos 4123.007813 2334.786133 -837.968750;setang -1.755830 179.862793 0.239112;
	setpos 3525.215820 2334.955078 -837.968750;setang -2.875562 -179.182343 -0.232500;
	setpos 3182.005371 2269.062744 -837.968750;setang -1.340243 -119.439102 0.030902;
	setpos 3140.346924 1694.820679 -837.968811;setang -2.055717 -90.658752 -0.020707;
	setpos 3097.624268 1249.561035 -837.968750;setang -0.858587 -147.537537 0.046600;
	setpos 2710.004883 1207.448120 -837.968750;setang 0.412215 -179.727966 -0.150920;
	setpos 2202.908203 1204.937256 -837.968750;setang -1.599793 -179.727966 -0.086486;
	setpos 1872.583374 951.767212 -837.968811;setang -0.442180 -134.306686 0.186701;
	setpos 1467.180786 532.706665 -837.968750;setang -0.632839 -104.980682 1.195862;
	setpos 1426.412354 115.529305 -837.968750;setang -1.227670 -150.538315 0.000000;
	setpos 1007.345459 11.020841 -837.968750;setang -0.818855 -179.182266 0.000769;
	setpos 731.330017 136.015884 -837.968750;setang 0.409233 125.302917 -0.000201;
	setpos 307.807251 266.368805 -837.968750;setang -1.629528 179.726593 -0.077470;
	setpos -216.214417 268.485657 -837.968750;setang 0.228005 179.863007 -0.141940;
	setpos -811.136292 269.908783 -837.968750;setang 0.109829 179.863007 0.195402;
	setpos -1447.952515 267.053192 -837.968750;setang 0.272894 -122.167015 0.000285;
	setpos -1540.645508 -66.937439 -831.968750;setang 1.270376 -86.703041 0.063782;
	setpos -1487.698120 -249.285614 -837.968750;setang 1.353362 -18.639442 -0.019865;
	setpos -961.770508 -280.754272 -837.968750;setang 0.315302 0.320155 -0.183298;
	setpos -251.655151 -275.745026 -837.968750;setang -0.440557 0.320155 -0.188993;
	setpos 241.124939 -272.990753 -837.968750;setang -0.688701 0.320155 -0.229710;
	setpos 678.794739 -247.759003 -837.968750;setang -2.407784 50.242542 -0.056514;
	setpos 983.797791 3.783145 -837.968750;setang -0.047600 -0.498254 0.040956;
	setpos 1383.723633 -50.151348 -837.968750;setang -0.137554 -69.653046 -0.001810;
	setpos 1443.040405 -469.914337 -837.968750;setang -0.476345 -83.020233 0.122455;
	setpos 1667.601807 -761.831909 -837.968811;setang -0.218745 -44.282635 0.229378;
	setpos 2039.516479 -1111.458374 -837.968750;setang -0.619131 -42.918636 0.203637;
	setpos 2334.077637 -1206.173584 -837.968750;setang 0.261193 -1.180238 -0.011790;
	setpos 2893.926025 -1214.825928 -837.968750;setang 0.757563 -1.043838 -0.198543;
	setpos 3109.227051 -1402.338745 -837.968750;setang 0.452004 -78.655357 -0.250100;
	setpos 3130.799316 -1883.928223 -837.968750;setang 0.447907 -89.430962 -0.103166;
	setpos 3267.974854 -2313.924316 -837.968750;setang -0.000068 0.183805 -0.000002;
	setpos 3934.515869 -2318.326660 -837.968750;setang -1.010088 -0.634595 0.183643;
	setpos 4506.030273 -2321.355469 -837.968750;setang -0.702979 0.183805 -0.237470;
	setpos 4648.541992 -2270.654297 -837.968750;setang -1.650458 78.886589 0.024247;
	setpos 4677.094727 -1528.828613 -837.968750;setang -1.681154 89.934959 0.238336;
	setpos 4680.812012 -876.712524 -837.968750;setang -0.117983 89.934959 0.215478;
	setpos 4684.395508 -106.531860 -837.968750;setang 0.790600 89.934959 -0.239479;
	]]



	local function startRaceTest()



		local r = Create(raceData)

		r.exclusive = nil --Set to only allow a specific player to run race

		r.duration = 3

		r.onFinished = function( race, pl )

			pl:ChatPrint("FINISHED RACE!")

			pl:AddMoney( 10000 )

			Destroy( race, pl )

		end



		r.onTimeAdded = function( race, pl ) end

		r.onCheckpoint = function( race, pl )

			race.addTime = 1.5

		end



		r.onStart = function( race, pl )

			pl:ChatPrint("START RACE!")

		end



		r.onFail = function( race, pl )

			pl:ChatPrint("YOU FAIL!")

			Reset(race)

		end



	end

	concommand.Add("gmt_startrace", function(ply)

		if ply:IsAdmin() then startRaceTest() end

	end)


	return



end



local CL_RACE_INFO = {}



surface.CreateFont( "RaceTimerFont", { font = "verdana", size = 40, weight = 50 } )



local function FormatTime(t)

	return string.format("%0.2i:%0.2i", math.floor(t), math.floor(t*100 % 100))

end



net.Receive( "RaceInfo", function(len)

	local msg = net.ReadUInt( 2 )

	local start = net.ReadFloat()

	local duration = net.ReadFloat()



	if msg == MSG_RACE_STARTED then

		CL_RACE_INFO.started = true

		CL_RACE_INFO.start = start

		CL_RACE_INFO.duration = duration

	elseif msg == MSG_RACE_CHECKPOINT then

		CL_RACE_INFO.start = start

		CL_RACE_INFO.checkpointTime = CurTime()

		CL_RACE_INFO.checkpointAdd = duration - CL_RACE_INFO.duration

		CL_RACE_INFO.duration = duration

	elseif msg == MSG_RACE_FAILED then

		CL_RACE_INFO.started = false

		CL_RACE_INFO.endTime = CurTime()

		CL_RACE_INFO.win = false

	elseif msg == MSG_RACE_FINISHED then

		CL_RACE_INFO.started = false

		CL_RACE_INFO.endTime = CurTime()

		CL_RACE_INFO.win = true

	end



	hook.Call("RaceState", GAMEMODE, msg, CL_RACE_INFO)

end)



local function drawRaceStats()

	if not CL_RACE_INFO.started then return end



	local t = CL_RACE_INFO.duration - ( CurTime() - CL_RACE_INFO.start )

	local ft = FormatTime(t)



	draw.SimpleTextOutlined(

		ft,

		"RaceTimerFont",

		ScrW()/2,

		20,

		Color(255,255,255,255),

		TEXT_ALIGN_CENTER,

		TEXT_ALIGN_LEFT,

		2,

		Color(0,0,0,255)

	)



	if not CL_RACE_INFO.checkpointTime then return end

	local ck_dt = 1 - math.min( CurTime() - CL_RACE_INFO.checkpointTime, 1 )



	draw.SimpleTextOutlined(

		"+" .. FormatTime(CL_RACE_INFO.checkpointAdd),

		"RaceTimerFont",

		ScrW()/2,

		50 + ck_dt * 20,

		Color(100,255,100,255 * ck_dt),

		TEXT_ALIGN_CENTER,

		TEXT_ALIGN_LEFT,

		1,

		Color(0,0,0,255 * ck_dt)

	)

end



hook.Add("HUDPaint", "racepaint", function()



	drawRaceStats()



	if (not CL_RACE_INFO.endTime) or CL_RACE_INFO.endTime < CurTime() - 2 then return end



	draw.SimpleTextOutlined(

		CL_RACE_INFO.win and "YOU WIN!" or "YOU LOSE!",

		"RaceTimerFont",

		ScrW()/2,

		50,

		CL_RACE_INFO.win and Color(255,255,100,255) or Color(255,100,100,255),

		TEXT_ALIGN_CENTER,

		TEXT_ALIGN_LEFT,

		2,

		Color(0,0,0,255)

	)

end)
