
-----------------------------------------------------
STORED_CURVES = STORED_CURVES or {}

local curve = CreateBezierCurve()



curve:Add(Vector(-4110.53125,-4664.09375,-8420.5625), Angle(0,90,0), 485.96875, 306.0625, nil, nil)

curve:Add(Vector(-4087.6875,-4090.625,-8438.9375), Angle(6.416015625,85.9130859375,-0.263671875), 181.69366765847, 396.74204958165, nil, nil)

curve:Add(Vector(-3534.75,-3733.25,-8475), Angle(1.23046875,0.1318359375,0.0439453125), 93.615977118625, 168.19709478856, nil, nil)

curve:Add(Vector(-2785.71875,-3731.21875,-8629.75), Angle(0,1.5380859375,0), 369.03756001676, 99.098105785694, nil, nil)

curve:Add(Vector(-2323.03125,-3726.21875,-8629.625), Angle(0,-2.4169921875,0), 194.7557220459, 355.44320678711, nil, nil)

curve:Add(Vector(-2374.71875,-4372.8125,-8631.15625), Angle(1.0107421875,179.12109375,0), 517.02056884766, 274.43438720703, nil, nil)

curve:Add(Vector(-3110.21875,-4199.46875,-8732.78125), Angle(4.3505859375,171.650390625,0.3076171875), 273.46383666992, 251.74003601074, nil, nil)

curve:Add(Vector(-3627.15625,-4165.59375,-8749.6875), Angle(0,179.033203125,0), 207.49671025254, 183.93174738286, nil, nil)

curve:Add(Vector(-4033.15625,-3706.03125,-8749.65625), Angle(0,90.87890625,0), 265.56426695399, 378.98450609408, nil, nil)

curve:Add(Vector(-4026.125,-3035.375,-8754.9375), Angle(1.494140625,89.0771484375,0), 176.55225080872, 183.02404960653, nil, nil)

curve:Add(Vector(-3697.34375,-2683.0625,-8798.0625), Angle(5.4052734375,-1.669921875,-1.0107421875), 169.50769997721, 303.84793463641, nil, nil)

curve:Add(Vector(-3307.90625,-3072.96875,-8848.96875), Angle(5.009765625,-88.2861328125,-1.494140625), 132.81286764655, 416.23039321315, nil, nil)

curve:Add(Vector(-4032.125,-3063.5,-8945.96875), Angle(6.0205078125,90.17578125,3.1640625), 450.07336533024, 191.93075584456, nil, nil)

curve:Add(Vector(-4033.84375,-2176.71875,-9074.21875), Angle(0,89.560546875,0), 244.13196234631, 499.98328585345, nil, nil)



STORED_CURVES["waterslide_a"] = curve



-- This point is the exact center between the two slides

-- Only the x value matters

local pivotPos = Vector(-4215.354980, -4547.199707, -8359.968750)

local offsetPos = Vector(0,0,8192.0)



-- We're going to mirror the curve on the x axis

local mirrorCurve = CreateBezierCurve()

for i=1, #curve.Points do



	-- First offset all the points because FUCK GAMEDEV

	curve.Points[i].Pos = curve.Points[i].Pos + offsetPos





	-- Now duplicate it for the other side

	local point = table.Copy(curve.Points[i])

	local offset = pivotPos - point.Pos

	point.Pos = Vector(pivotPos.X + offset.x, point.Pos.y, point.Pos.z)

	point.Angle = Angle(point.Angle.p, 180 - point.Angle.y , point.Angle.r)



	mirrorCurve.Points[i] = point

end



STORED_CURVES["waterslide_b"] = mirrorCurve

-----------------------------------------------------
-- Names of the curves to manage creating tubes for

local CurveNames =

{

	"waterslide_a",

	"waterslide_b"

}



-- Maximum number of tubes to be created per curve

local MaxTubesPerCurve = 3





local function GetStartPosAngle(curvename)

	local curve = STORED_CURVES[curvename]



	-- WELLLLP this shouldn't happen

	if not curve then return Vector(), Angle() end



	return curve.Points[1].Pos, curve.Points[1].Angle

end





-- If we're on the client, all we'll do is draw some ghost tubes

if CLIENT then



	local TubeModel = Model( "models/gmod_tower/pooltube.mdl")

	local GhostModels = {}

	local NextThink = 0



	-- For the soundscape system, give em some audio

	local SlideSoundInfo = {

		type = "playlooping",

		volume = 1,

		soundlevel = 350,

		sound = { "GModTower/pool/waterloop.ogg", 30}, }



	local function QuerySoundscape( name, bTop  )

		local curve = STORED_CURVES[name]

		if not curve then return end



		-- Determine whether to retrieve the first or last point

		local pos = bTop and curve.Points[1].Pos or curve.Points[#curve.Points].Pos



		-- Try to get the location of the point

		local loc = Location.Find(pos)--Location.Find(pos)

		local scape = soundscape.GetSoundscape(loc)

		if not scape then return end



		-- Unique rulename

		local ruleName = name .. (bTop and "_top" or "_bottom")



		-- Define our hum soundscape only if it isn't defined already

		if scape and soundscape.IsDefined(scape) and not soundscape.HasRule(scape, ruleName) then

			local sndInfo = table.Copy(SlideSoundInfo)

			sndInfo.position = pos



			-- Add our hum to the soundscape system

			soundscape.AppendRuleDefinition(scape, sndInfo, ruleName)

		end

	end



	hook.Add("Think", "GMTWaterslideGhostManager", function()

		-- We don't need to check very often

		if RealTime() < NextThink then return end

		NextThink = RealTime() + 5



		-- Only bother updating when they're in the boardwalk

		local plyLoc = LocalPlayer():Location()--Location.Get(LocalPlayer():Location())

		--if not plyLoc or plyLoc.Group ~= "boardwalk" then return end



		-- Go through each curvename, checking its subsequent ghost models

		for _, v in pairs(CurveNames) do



			-- Make sure the curve is valid

			if not STORED_CURVES[v] then continue end



			-- Query soundscape worldsounds for the top and bottom

			--QuerySoundscape(v, true )

			--QuerySoundscape(v, false )



			local pos, ang = GetStartPosAngle(v)



			-- If it's now invalid, recreate the model

			if not IsValid(GhostModels[v]) then



				local mdl = ClientsideModel(TubeModel)

				mdl:SetPos(pos)

				mdl:SetAngles(ang)

				mdl:SetRenderMode(RENDERMODE_GLOW)

				mdl:SetColor(Color(255,255,255,150))

				mdl:SetModelScale(0.90,0)



				-- Store it so we don't recreate it if don't have to

				GhostModels[v] = mdl

			end

		end

	end )



	-- Go no further, it's serverside time

	return

end



local Tubes = {}



-- Create a unique table for each curve to manage

for _, v in pairs(CurveNames) do



	-- Make sure there's an actual matching curve

	if not STORED_CURVES[v] then continue end



	-- Create a useful storage table

	Tubes[v] = {}

	Tubes[v].CreatedTubes = {}

end



-- Clean the table of removed pooltubes

local function CleanPoolTubes(tbl)

	for i=#tbl.CreatedTubes, 1, -1 do

		if not IsValid(tbl.CreatedTubes[i]) then

			table.remove(tbl.CreatedTubes, i)

		end

	end

end



-- Find any available tube to use, as opposed to creating a new one

local function FindOpenTube(curvename)

	for _, v in pairs( ents.FindByClass("gmt_pooltube")) do



		-- Has a matching curve and nobody's riding it

		if IsValid(v) and v.SlideCurveName == curvename and not IsValid(v:GetOwner()) then

			return v

		end

	end

end



-- General function for managing pool tubes, their positions, and queueing them up

local function ManagePoolTubes(tbl, curvename)

	-- If a tube is sliding or we've hit the max entities, do nothing

	if IsValid(tbl.SlidingTube) then



		-- Check if the're still on a curve

		if tbl.SlidingTube.CurrentCurve == nil then

			tbl.SlidingTube = nil

		end



		-- There's nothing further here to do

		return

	end



	-- If we've got a valid queued tube, check if its state changes

	if IsValid(tbl.QueuedTube) then

		local tube = tbl.QueuedTube

		if IsValid(tube:GetOwner() ) or tube.CurrentCurve ~= nil then



			-- Set the slide curve

			tube:SetSlideCurve(STORED_CURVES[curvename])

			tube:SetMoveType(MOVETYPE_VPHYSICS) -- Unfreeze it



			tbl.SlidingTube = tube

			tbl.QueuedTube = nil

		end



		return

	end



		-- Prioritize existing tubes before creating one

	local tube = FindOpenTube(curvename)



	-- Only create a new tube if we're below the limit

	if not IsValid(tube) and #tbl.CreatedTubes < MaxTubesPerCurve then



		//MsgC( co_color2, "[Pooltubes] No valid tubes found, but under limit. Creating a new one.\n")



		-- If all else fails, create a new tube

		tube = ents.Create("gmt_pooltube")

		tube:Spawn()

		tube:Activate()



		-- We're overwriting this for our own slide management so

		tube.NoReset = true



		-- You're with us now

		tube.SlideCurveName = curvename

		table.insert(tbl.CreatedTubes, tube)

	end



	if not IsValid(tube) then return end



	-- Get the position of the very first node

	local pos, ang = GetStartPosAngle(curvename)



	-- Set the pos/angles to right where the start of the curve is

	tube:SetPos(pos)

	tube:SetAngles(ang)

	tube:SetMoveType(MOVETYPE_NONE) -- Freeze it while it's 'queued'



	-- Store that shit

	tbl.QueuedTube = tube

end



-- sorry foohy, I don't want your STUPID tubes on flatgrass

if not IsLobby then

	return

end



local NextThink = 0

hook.Add("Think", "GMTPoolTubeWaterslideManager", function()

	if CurTime() < NextThink then return end

	NextThink = CurTime() + 0.20


	for curve, tbl in pairs(Tubes) do

		-- First clean up the list of pooltubes

		CleanPoolTubes(tbl)



		-- Now decide to idle, create an entity, or move an entity

		ManagePoolTubes(tbl, curve)

	end

end )

