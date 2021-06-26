
// Adds all missing shit to Lobby 2

local BeachChairColors = {
	Color( 230, 25, 75 ),		-- Red
	Color( 60, 180, 75 ),		-- Green
	Color( 255, 225, 25 ),	-- Yellow
	Color( 0, 130, 200 ),		-- Blue
	Color( 245, 130, 48 ),	-- Orange
	Color( 145, 30, 180 ),	-- Purple
	Color( 70, 240, 240 ),	-- Cyan
	Color( 240, 50, 230 ),	-- Magenta
	Color( 210, 245, 60 )		-- Lime
}

local function GetNearestCondo( pos )

	local doors = {}

	for k,v in pairs( ents.FindByClass("gmt_condo_door") ) do
		if v:GetCondoDoorType() == 1 then
			doors[v] = v:GetPos():Distance(pos)
		end
	end

	local value = math.min( unpack( doors ) )
	local door = table.KeyFromValue( doors, value )

	if !IsValid(door) then return end

	return door:GetCondoID()

end

local function AddL2Camera( pos, ang )
	local cam = ents.Create("gmt_condo_camera")
	cam:SetPos( pos )
	cam:SetAngles( ang + Angle( 0, -90, 0 ) )
	cam:Spawn()

	cam:SetNWInt( "Condo", (GetNearestCondo( pos ) or 0) )

end

local function AddL2Seat( model, pos, angle, skin, color )

  local seat = ents.Create( "prop_physics_multiplayer" )
  seat:SetPos( pos )
  seat:SetAngles( angle )
  seat:SetModel( model )
  seat:SetSkin( skin )
  seat:Spawn()

	seat:SetKeyValue("spawnflags",2)

  if model == "models/map_detail/beach_chair.mdl" then
    seat:SetColor( table.Random( BeachChairColors ) )
  end

	if color != Color(255, 255, 255) then
		seat:SetColor( color )
	end

  seat:SetSaveValue("fademindist", 2048)
  seat:SetSaveValue("fademaxdist", 4096)
  local phys = seat:GetPhysicsObject()
  if IsValid(phys) then
    phys:EnableMotion(false)
  end

end

local function AddMapModel( model, pos, ang )

	if !model then return end

	if !pos then
		print("Not spawning map model " .. model .. ". No position specified.")
		return
	end

	local e = ents.Create("prop_dynamic")
	e:SetPos( pos )
	e:SetAngles( ang or Angle(0,0,0) )
	e:SetModel( model )
	e:Spawn()
end

local function AddMapEntity( class, pos, ang )

	if !class then return end

	if !pos then
		print("Not spawning map entity " .. class .. ". No position specified.")
		return
	end

	local e = ents.Create( class )
	e:SetPos( pos )
	e:SetAngles( ang or Angle(0,0,0) )
	e:Spawn()
end

local function CenterSKPanel()
	for k,v in pairs( ents.FindInSphere( Vector(6254.8671875, -6095.8579101563, -825.11450195313), 600 ) ) do
		if v:GetClass() == "gmt_multiserver" then
			v:SetPos( v:GetPos() - Vector(30, 0, 0) )
		end
	end
end

local function NetworkCondoPanelIDs()
	for k,v in pairs(ents.FindByClass("gmt_condo_panel")) do
		local entloc = GTowerLocation:FindPlacePos( v:GetPos() )
		local condoID = (entloc - 1)

		v:SetNWInt( "condoID", condoID )

	end
end

local function SpawnCondoPlayers()
	for k,v in pairs(ents.FindByClass("gmt_roomloc")) do
		local entloc = GTowerLocation:FindPlacePos( v:GetPos() )
		local condoID = (entloc - 1)

		local e = ents.Create("gmt_condoplayer")
		e:SetPos(v:GetPos())
		e:Spawn()
		e:SetNWInt( "condoID", condoID )

		e:SetNoDraw(true)
		e:SetSolid(SOLID_NONE)

	end
end

local function SpawnCondoToilets()
	for k,v in pairs( ents.FindByClass("gmt_roomloc") ) do
		AddL2Seat( "models/map_detail/condo_toilet.mdl", v:GetPos() + Vector( -35, -155, 5 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
		print(tostring(v:GetPos() + Vector( 20, 5, 0 )))
	end
end

local function SetupUCHPort()
	local e = ents.Create( "gmt_ai_animated" )
	e:SetPos( Vector(2799.96875, -6533.6787109375, -895.96875) )
	e:Spawn()
	e:SetNWString( "Type", "pigmask" )

	local e = ents.Create( "gmt_ai_animated" )
	e:SetPos( Vector(2799.96875, -6533.6787109375, -895.96875) )
	e:Spawn()
	e:SetNWString( "Type", "chimera" )
end

local function SetupBallracePort()
	local e = ents.Create( "gmt_gmball" )
	e:SetPos( Vector(3423.8525390625, -6758.4086914063, -758.42822265625) )
	e:Spawn()

	local e = ents.Create( "gmt_ai_animated" )
	e:SetPos( Vector(3423.8525390625, -6758.4086914063, -758.42822265625) )
	e:Spawn()
	e:SetNWString( "Type", "ballrace" )
end

local function SetupZombieMassacrePort()
	local e = ents.Create( "gmt_ai_zombie" )
	e:SetPos( Vector(1779.020874, -4203.050781, -895.968750) )
	e:SetAngles( Angle(0.000, -30.558, 0.000) )
	e:Spawn()
end

local function SetupMinigolfPort()
	local e = ents.Create( "gmt_gmgolfball" )
	e:SetPos( Vector(7189.2172851563, -5464.8168945313, -875.61584472656) )
	e:Spawn()
end

local function FixMapBugs()
	for k,v in pairs(ents.FindByClass('gmt_mapboard')) do
		if v:GetPos() == Vector(7128.000000, 0.000000, -1074.000000) then
			v:Remove()
		end
	end

	for k,v in pairs( ents.FindByClass("gmt_npc_electronic") ) do
		local e = ents.Create("gmt_npc_electronic")
		e:SetPos(v:GetPos())
		e:Spawn()
		e:SetAngles(v:GetAngles())
		v:Remove()
	end

	for k,v in pairs( ents.FindByClass("gmt_npc_particles") ) do
		v:SetPos( Vector( 1277.697876, 715.775269, -893.177063 ) )
	end

	for k,v in pairs(ents.FindByClass('gmt_npc_basical')) do
	 	v:SetAngles(v:GetAngles() - Angle(0,-15,0))
	end
end

local function SpawnGameBanner()
	local banner = ents.Create("gmt_gamebanner")
	banner:SetPos(Vector(4398.583496, -2909.327881, 137.968750))
	banner:Spawn()
end

hook.Add("InitPostEntity","AddL2Ents",function()

	FixMapBugs()							-- Fix some map bugs

	// Fixes and automation
	//===============================================
	CenterSKPanel()						-- Center the join panel for Source Karts
	NetworkCondoPanelIDs()		-- Network the Condo OS IDs
	SpawnCondoPlayers()				-- Spawn the condo players, used for playing music with Condo OS
	SpawnCondoToilets()				-- Spawns in the toilets

	// Animated gamemode ports
	//===============================================
	SetupUCHPort()						-- UCH port animation
	SetupBallracePort()				-- Ballrace port animations
	SetupZombieMassacrePort()	-- Zombie Massacre port animations
	SetupMinigolfPort()				-- Minigolf port animations

	// Misc
	//===============================================
	SpawnGameBanner()					-- Spawns the animated gamemode banner model


	// Delete one of the 2 animated Virus port actors.
	for k,v in pairs( ents.FindInSphere( Vector(1516, -5053, -901), 64 ) ) do
		if v:GetClass() == "gmt_ai_animated" then v:Remove() end
	end

	// Foohy credit plates
	//===============================================
	AddMapModel( "models/map_detail/foohy_plate.mdl", Vector( 2660.14, -5176.67, -2586.26 ), Angle( 0, 270, 0 ) )
	AddMapModel( "models/map_detail/foohy_plate.mdl", Vector( 1736.13, -1687.99, -798.32 ), Angle( 0, 270, 0 ) )

	// Spawn missing entities
	//===============================================
	AddMapEntity( "gmt_npc_nature", Vector(7053.555176, 2645.244873, -556.064880), Angle(0.000, -116.949, 0.000) )
	AddMapEntity( "gmt_transmittor", Vector(-2353.534912, 1651.215942, -895.480774), Angle(2.711, -121.603, 0.334) )
	AddMapEntity( "gmt_npc_beach", Vector(-6133.142578, 3826.287109, -895.805359), Angle(0.000, -90, 0.000) )
	AddMapEntity( "gmt_dopefish", Vector(-5642, -2214, -1050), Angle(1.677856, 180.635330, 0.000000) )

	// Monorail Spawn
	//===============================================
	AddMapEntity( "gmt_monorail", Vector(8962, 2, -224), Angle(0,0,0) )

	// Thanksgiving
	//===============================================
	if time.IsThanksgiving() then
		AddMapEntity( "gmt_npc_thanksgiving", Vector( 5497.978516, -220, -895.029480 ), Angle( 0, 90, 0 ) )
	end

	// Halloween
	//===============================================

	// Using L2Seat because it needs to be a physics object.
	AddL2Seat( "models/gmod_tower/shopstand.mdl", Vector( 5497.978516, -187.837418, -895.029480 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddMapEntity( "gmt_npc_halloween", Vector( 5497.978516, -220, -895.029480 ), Angle( 0, 90, 0 ) )

	AddMapEntity( "ghost_mutant", Vector(6629.1401367188, -810.82995605469, -470.92190551758), Angle( 0, 0, 0 ) )

	// Fixes AI not initializing
	timer.Simple(5,function()

		for k,v in pairs(ents.FindByClass("ghost_mutant")) do
			v:Remove()
		end

		local e = ents.Create("ghost_mutant")
		e:SetPos(Vector(6629.1401367188, -810.82995605469, -470.92190551758))
		e:Spawn()
	end)

	// Remove default spinner wheels
	for k,v in pairs( ents.FindByClass("gmt_casino_spinner") ) do
		v:Remove()
	end

	// Alternate them between normal and Halloween spinners
	AddMapEntity( "gmt_casino_spinner", Vector(2875.341796875,-11666.010742188,-2572.0146484375), Angle(0,90,0) )
	AddMapEntity( "gmt_casino_spinner", Vector(3122.9431152344,-11666.673828125,-2570.873046875), Angle(0,90,0) )
	AddMapEntity( "gmt_casino_spinner", Vector(3363.2565917969,-11666.71875,-2571.603515625), Angle(0,90,0) )
	AddMapEntity( "gmt_casino_spinner", Vector(2632.2482910156,-11666.71875,-2571.6962890625), Angle(0,90,0) )
	AddMapEntity( "gmt_halloween_spinner", Vector(3243.4973144531,-11666.749023438,-2571.99609375), Angle(0,90,0) )
	AddMapEntity( "gmt_halloween_spinner", Vector(3000.7260742188,-11666.71875,-2571.93359375), Angle(0,90,0) )
	AddMapEntity( "gmt_halloween_spinner", Vector(2752.4057617188,-11666.71875,-2572.2939453125), Angle(0,90,0) )

	// Condo cameras
	//===============================================
	AddL2Camera( Vector( -1154, 60.18159866333, 15100 ), Angle(0, 180, 0) )
	AddL2Camera( Vector( -672, 60.18159866333, 15100 ), Angle(0, 180, 0) )
	AddL2Camera( Vector( -192, 60.181701660156, 15100 ), Angle(0, 180, 0) )
	AddL2Camera( Vector( -2888, 654, 15100 ), Angle(0, 0, 0) )
	AddL2Camera( Vector( -3368, 654, 15100 ), Angle(0, 0, 0) )
	AddL2Camera( Vector( -3850, 654, 15100 ), Angle(0, 0, 0) )
	AddL2Camera( Vector( -102, 654, 15100 ), Angle(0, 0, 0) )
	AddL2Camera( Vector( -582, 654, 15100 ), Angle(0, 0, 0) )
	AddL2Camera( Vector( -1064, 654, 15100 ), Angle(0, 0, 0) )
	AddL2Camera( Vector( -3940, 60.181499481201, 15100 ), Angle(0, 180, 0) )
	AddL2Camera( Vector( -3458, 60.181499481201, 15100 ), Angle(0, 180, 0) )
	AddL2Camera( Vector( -2978, 60.18159866333, 15100 ), Angle(0, 180, 0) )

	// SEATS!!!
	//===============================================
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector( 6592, 808, -1258.7299804688 ), Angle(0, 0, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector( 6592, 936, -1258.7299804688 ), Angle(0, 0, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector( 7664, 808, -1258.7299804688 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector( 7664, 936, -1258.7299804688 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector( 6592, -936, -1258.7299804688 ), Angle(0, 0, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector( 6592, -808, -1258.7299804688 ), Angle(0, 0, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector( 7664, -936, -1258.7299804688 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector( 7664, -808, -1258.7299804688 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector( 6676, -296, -1066.7299804688 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector( 6428, -296, -1066.7299804688 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector( 6676, 300, -1066.7299804688 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector( 6428, 300, -1066.7299804688 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector( 5024, -256, -883.13000488281 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector( 5152, -256, -883.13000488281 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector( 5024, 256, -883.13000488281 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector( 5152, 256, -883.13000488281 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 4368, -160, -895.75 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 4192, -160, -895.75 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 4368, 168, -895.75 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 4192, 168, -895.75 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 4184, 376, -895.75 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 3712, -368, -895.75 ), Angle(0, 0, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 3712, -208, -895.75 ), Angle(0, 0, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 3712, 216, -895.75 ), Angle(0, 0, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 3712, 376, -895.75 ), Angle(0, 0, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 2896, -1024, -895.75 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 3056, -1024, -895.75 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 2472, -1024, -895.75 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 2312, -1024, -895.75 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 3064, 1024, -895.75 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 2904, 1024, -895.75 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 2472, 1024, -895.75 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 2312, 1024, -895.75 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 1664, -216, -895.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 1664, -376, -895.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 1664, 216, -895.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 1664, 376, -895.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector( 5416, 224, -595.13000488281 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector( 5544, 224, -595.13000488281 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector( 5544, -224, -595.13000488281 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector( 5416, -224, -595.13000488281 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector( 4872, 1152, -883.13000488281 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector( 4872, 1280, -883.13000488281 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector( 4872, -1272, -883.13000488281 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector( 4872, -1144, -883.13000488281 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/sunabouzu/theater_sofa01.mdl", Vector( 3688, 4224, -895.98297119141 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/sunabouzu/theater_sofa01.mdl", Vector( 3720, 4312, -895.98297119141 ), Angle(0, 45, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/sunabouzu/theater_sofa01.mdl", Vector( 3808, 4344, -895.98297119141 ), Angle(0, 0, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/sunabouzu/theater_sofa01.mdl", Vector( 5072, 4184, -895.98297119141 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/sunabouzu/theater_sofa01.mdl", Vector( 5040, 4272, -895.98297119141 ), Angle(0, 315, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/sunabouzu/theater_sofa01.mdl", Vector( 4952, 4304, -895.98297119141 ), Angle(0, 0, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/wilderness/wildernesstable1.mdl", Vector( 4064, 4112, -895.98297119141 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/wilderness/wildernesstable1.mdl", Vector( 4648, 4392, -895.76000976563 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/wilderness/wildernesstable1.mdl", Vector( 4656, 4344, -895.76000976563 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/wilderness/wildernesstable1.mdl", Vector( 4736, 4112, -895.98297119141 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 592, 768, -671.75 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 720, 768, -671.75 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 592, 1128, -671.75 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 720, 1128, -671.75 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( -256, 1128, -671.75 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( -96, 1128, -671.75 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( -256, 920, -671.75 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( -96, 920, -671.75 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( -256, -1128, -671.75 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( -96, -1128, -671.75 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( -256, -920, -671.75 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( -96, -920, -671.75 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 600, -1128, -671.75 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 728, -1128, -671.75 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 600, -768, -671.75 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 728, -768, -671.75 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 224, 104, -895.75 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 64, -104, -895.75 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 224, -104, -895.75 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 64, 104, -895.75 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( -1032, 104, -895.75 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( -1192, -104, -895.75 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( -1032, -104, -895.75 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( -1192, 104, -895.75 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector( -4272, 1826.9899902344, -940.03802490234 ), Angle(2.2489399909973, 335.0530090332, 2.6825299263), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector( -4215.2202148438, 1773.8100585938, -936.93298339844 ), Angle(2.829400062561, 299.82800292969, 9.1160097122192), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector( -4513.669921875, 1751.8399658203, -975.04400634766 ), Angle(-6.5266699790955, 329.58801269531, 3.006059885025), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector( -4310.91015625, 1590.0699462891, -949.78302001953 ), Angle(-2.0960800647736, 284.75500488281, 1.5157300233841), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector( -4311.41015625, 1515.1300048828, -943.80499267578 ), Angle(-2.0960800647736, 257.25500488281, 1.5157300233841), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector( -3724.4899902344, 1475.3800048828, -912.28601074219 ), Angle(-1.6125600337982, 284.75100708008, 1.6431200504303), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector( -3736.1101074219, 915.39001464844, -940.97100830078 ), Angle(-1.4862699508667, 284.69500732422, 10.983699798584), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector( -4187.5698242188, 1087.5899658203, -952.15197753906 ), Angle(5.23907995224, 316.98001098633, -0.38349398970604), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector( -2816, -1672, -895.75 ), Angle(0, 45, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector( -2864, -1720, -895.75 ), Angle(0, 45, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector( -2912, -1768, -895.75 ), Angle(0, 45, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector( -2968, -1824, -895.75 ), Angle(0, 45, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector( -2768, -1624, -895.75 ), Angle(0, 45, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector( -3520, -928, -896 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector( -3584, -928, -896 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector( -3648, -928, -896 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector( -3712, -928, -896 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector( -3400, -872, -896 ), Angle(0, 225, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector( -3354.75, -826.74499511719, -896 ), Angle(0, 225, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector( -3309.4899902344, -781.48999023438, -896 ), Angle(0, 225, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector( -3264.2399902344, -736.23498535156, -896 ), Angle(0, 225, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/props_vtmb/fancybed.mdl", Vector( -1408, -1344, -888 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/comfybed.mdl", Vector( -1528, -1352, -888 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 2800, -2352, -863.81097412109 ), Angle(0, 285, 0), 0, Color(85, 25, 25))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 2816, -2424, -863.81097412109 ), Angle(0, 270, 0), 0, Color(85, 25, 25))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 2808, -2496, -863.81097412109 ), Angle(0, 255, 0), 0, Color(85, 25, 25))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector( 2770.7399902344, -2047.4300537109, -863.81097412109 ), Angle(0, 315, 0), 0, Color(85, 25, 25))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 2816, -2128, -863.81097412109 ), Angle(0, 285, 0), 0, Color(85, 25, 25))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 2688, -2000, -863.81097412109 ), Angle(0, 345, 0), 0, Color(85, 25, 25))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 2400, -2008, -863.81097412109 ), Angle(0, 30, 0), 0, Color(85, 25, 25))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 2504, -2008, -863.81097412109 ), Angle(0, 330, 0), 0, Color(85, 25, 25))
	AddL2Seat( "models/haxxer/me2_props/reclining_chair.mdl", Vector( 4632, -832, -3519.75 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/haxxer/me2_props/reclining_chair.mdl", Vector( 4632, -768, -3519.75 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/haxxer/me2_props/reclining_chair.mdl", Vector( 4632, -640, -3519.75 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/haxxer/me2_props/reclining_chair.mdl", Vector( 4632, -704, -3519.75 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/haxxer/me2_props/reclining_chair.mdl", Vector( 4632, -576, -3519.75 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 4348, -4744, -895.75 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 4476, -4744, -895.75 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 4476, -4952, -895.75 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 4348, -4952, -895.75 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 3852, -4812, -895.75 ), Angle(0, 39.5, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 3792, -4700, -895.75 ), Angle(0, 15, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 4972, -4792, -895.75 ), Angle(0, 144.5, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 5012, -4688, -895.75 ), Angle(0, 171.5, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 3400, -5288, -895.75 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 3528, -5288, -895.75 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 5248, -5304, -895.75 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector( 5376, -5304, -895.75 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 2544, -3616, -895.81097412109 ), Angle(0, 30, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 2616, -3608, -895.81097412109 ), Angle(0, 0, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 2680, -3616, -895.81097412109 ), Angle(0, 345, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 3048, -3624, -895.81097412109 ), Angle(0, 345, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 2984, -3616, -895.81097412109 ), Angle(0, 0, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 2912, -3624, -895.81097412109 ), Angle(0, 30, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 3520, -3672, -895.81097412109 ), Angle(0, 315, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 3468.25, -3631.7099609375, -895.81097412109 ), Angle(0, 345, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 3396.6298828125, -3620.8000488281, -895.81097412109 ), Angle(0, 15, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 5312, -3664, -895.81097412109 ), Angle(0, 75, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 5363.4799804688, -3621.6398925781, -895.81097412109 ), Angle(0, 15, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 5427.3701171875, -3612.8000488281, -895.81097412109 ), Angle(0, 0, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 5704, -3624, -895.81097412109 ), Angle(0, 30, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 5776, -3616, -895.81097412109 ), Angle(0, 0, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 5840, -3624, -895.81097412109 ), Angle(0, 345, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 6136, -3632, -895.81097412109 ), Angle(0, 30, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 6208, -3624, -895.81097412109 ), Angle(0, 0, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 6272, -3632, -895.81097412109 ), Angle(0, 345, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector( 6360, -1424, -606.81097412109 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 6432, -1352, -606.81097412109 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 6288, -1216, -606.81097412109 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 6272, 1336, -606.81097412109 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 6416, 1200, -606.81097412109 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector( 6368, 1432, -606.81097412109 ), Angle(0, 0, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector( 7004, 712, -607.81097412109 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector( 7004, 392, -607.81097412109 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector( 7004, -380, -607.81097412109 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector( 7004, -704, -607.81097412109 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 7208, -952, -607.81097412109 ), Angle(0, 15, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 7276, -956, -607.81097412109 ), Angle(0, 345, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 7288, 952, -607.81097412109 ), Angle(0, 195, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 7220, 956, -607.81097412109 ), Angle(0, 165, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector( -1604, -132, 14983.200195313 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector( -1688, -44, 14983.200195313 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector( -2364, -116, 14983.200195313 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector( -2448, -28, 14983.200195313 ), Angle(0, 0, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/sunabouzu/theater_curve_couch.mdl", Vector( 2304, -5664, -2625.3798828125 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/sunabouzu/theater_curve_couch.mdl", Vector( 2048, -5664, -2625.3798828125 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 1928, -5068, -2623.8100585938 ), Angle(0, 105, 0), 1, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 1928, -5124, -2623.8100585938 ), Angle(0, 75, 0), 1, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 1896, -4940, -2623.8100585938 ), Angle(0, 60, 0), 1, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 1896, -5248, -2623.8100585938 ), Angle(0, 120, 0), 1, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 1872, -5184, -2623.8100585938 ), Angle(0, 90, 0), 1, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector( 1872, -5004, -2623.8100585938 ), Angle(0, 90, 0), 1, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector( 2336, -4544, -2623.7700195313 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector( 2384, -4544, -2623.7700195313 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector( 2432, -4544, -2623.7700195313 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector( 2480, -4544, -2623.7700195313 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector( 2528, -4544, -2623.7700195313 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector( 2576, -4544, -2623.7700195313 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector( 1760, -4608, -2602.0100097656 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector( 1760, -4480, -2602.0100097656 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector( 1920, -4448, -2602.0100097656 ), Angle(0, 75, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector( 1888, -4528, -2602.0100097656 ), Angle(0, 255, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector( 2000, -4352, -2602.0100097656 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector( 2096, -4352, -2602.0100097656 ), Angle(0, 0, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector( 2048, -4400, -2602.0100097656 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector( 2070.7800292969, -4543.4399414063, -2602.0100097656 ), Angle(0, 78.5, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector( 2016, -4592, -2602.0100097656 ), Angle(0, 168.5, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector( 1856, -4368, -2602.0100097656 ), Angle(0, 195, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector( 1904, -4400, -2602.0100097656 ), Angle(0, 270, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector( 1824, -4704, -2602.0100097656 ), Angle(0, 210, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector( 1888, -4704, -2602.0100097656 ), Angle(0, 315, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5632, 5360, -2917.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5632, 5280, -2891.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5632, 5200, -2866 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5632, 5120, -2840 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5632, 5040, -2813.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5632, 4960, -2787.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5452, 4960, -2787.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5452, 5040, -2813.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5452, 5120, -2840 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5452, 5200, -2866 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5452, 5280, -2891.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5452, 5360, -2917.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5404, 4960, -2787.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5404, 5040, -2813.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5404, 5120, -2840 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5404, 5200, -2866 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5404, 5280, -2891.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5404, 5360, -2917.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5356, 4960, -2787.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5356, 5040, -2813.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5356, 5120, -2840 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5356, 5200, -2866 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5356, 5280, -2891.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5356, 5360, -2917.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5308, 4960, -2787.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5308, 5040, -2813.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5308, 5120, -2840 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5308, 5200, -2866 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5308, 5280, -2891.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5308, 5360, -2917.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5260, 4960, -2787.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5260, 5040, -2813.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5260, 5120, -2840 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5260, 5200, -2866 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5260, 5280, -2891.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5260, 5360, -2917.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5212, 4960, -2787.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5212, 5040, -2813.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5212, 5120, -2840 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5212, 5200, -2866 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5212, 5280, -2891.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5212, 5360, -2917.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5164, 4960, -2787.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5164, 5040, -2813.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5164, 5120, -2840 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5164, 5200, -2866 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5164, 5280, -2891.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 5164, 5360, -2917.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 4988, 4960, -2787.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 4988, 5040, -2813.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 4988, 5120, -2840 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 4988, 5200, -2866 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 4988, 5280, -2891.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 4988, 5360, -2917.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3636, 4956, -2787.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3588, 4956, -2787.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3540, 4956, -2787.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3492, 4956, -2787.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3444, 4956, -2787.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3396, 4956, -2787.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3348, 4956, -2787.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3348, 5036, -2813.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3396, 5036, -2813.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3444, 5036, -2813.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3492, 5036, -2813.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3540, 5036, -2813.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3588, 5036, -2813.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3636, 5036, -2813.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3636, 5116, -2840 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3588, 5116, -2840 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3540, 5116, -2840 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3492, 5116, -2840 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3444, 5116, -2840 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3396, 5116, -2840 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3348, 5116, -2840 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3348, 5196, -2866 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3396, 5196, -2866 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3444, 5196, -2866 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3492, 5196, -2866 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3540, 5196, -2866 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3588, 5196, -2866 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3636, 5196, -2866 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3636, 5276, -2891.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3636, 5356, -2917.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3588, 5356, -2917.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3588, 5276, -2891.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3540, 5276, -2891.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3540, 5356, -2917.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3492, 5356, -2917.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3492, 5276, -2891.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3444, 5276, -2891.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3444, 5356, -2917.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3396, 5356, -2917.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3396, 5276, -2891.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3348, 5276, -2891.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3348, 5356, -2917.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3816, 4956, -2787.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3816, 5036, -2813.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3816, 5116, -2840 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3816, 5196, -2866 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3816, 5276, -2891.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3816, 5356, -2917.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3172, 5356, -2917.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3172, 5276, -2891.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3172, 5196, -2866 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3172, 5116, -2840 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3172, 5036, -2813.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector( 3172, 4956, -2787.75 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/comfychair.mdl", Vector( -912, -1404, -664 ), Angle(0, 105, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/splayn/rp/lr/chair.mdl", Vector( -764, -1396, -664 ), Angle(0, 120, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/wilderness/wildernesstable1.mdl", Vector( -2004, -1172, -664 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/gmod_tower/medchair.mdl", Vector( -1572, -1016, -888 ), Angle(0, 330, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/haxxer/me2_props/reclining_chair.mdl", Vector( -1568, -964, -888 ), Angle(0, 240, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/haxxer/me2_props/illusive_chair.mdl", Vector( -1572, -900, -888 ), Angle(0, 135, 0), 0, Color(255, 255, 255))

	// CSGO models have to be spawned with lua due to their updated model format not working in GMod correctly.
	//===============================================
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_table.mdl", Vector( -3584, 3968, -895.69598388672 ), Angle(0, 0, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_umbrella_big_open.mdl", Vector( -3584, 3968, -895.69598388672 ), Angle(0, 0, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_chair.mdl", Vector( -3568, 4016, -895.75 ), Angle(0, 165, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_chair.mdl", Vector( -3648, 3968, -895.75 ), Angle(0, 270, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_chair.mdl", Vector( -3600, 3920, -895.75 ), Angle(0, 330, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_table.mdl", Vector( -3456, 3712, -895.69598388672 ), Angle(0, 0, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_umbrella_big_open.mdl", Vector( -3456, 3712, -895.69598388672 ), Angle(0, 0, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_chair.mdl", Vector( -3504, 3744, -895.09197998047 ), Angle(0, 240, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_chair.mdl", Vector( -3440, 3648, -895.09197998047 ), Angle(0, 15, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_chair.mdl", Vector( -3504, 3664, -895.09197998047 ), Angle(0, 330, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_chair.mdl", Vector( -3312, 3952, -895.09197998047 ), Angle(0, 240, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_chair.mdl", Vector( -3312, 3872, -895.09197998047 ), Angle(0, 315, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_chair.mdl", Vector( -3232, 3872, -895.09197998047 ), Angle(0, 45, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_table.mdl", Vector( -3264, 3920, -895.69598388672 ), Angle(0, 0, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_umbrella_big_open.mdl", Vector( -3264, 3920, -895.69598388672 ), Angle(0, 0, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_chair.mdl", Vector( -3024, 3792, -895.09197998047 ), Angle(0, 150, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_chair.mdl", Vector( -3090.3898925781, 3765.1000976563, -895.09197998047 ), Angle(0, 240, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_chair.mdl", Vector( -3040, 3680, -895.09197998047 ), Angle(0, 30, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_table.mdl", Vector( -3040, 3744, -895.69598388672 ), Angle(0, 0, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_umbrella_big_open.mdl", Vector( -3040, 3744, -895.69598388672 ), Angle(0, 0, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_table.mdl", Vector( -3120, 3472, -895.69598388672 ), Angle(0, 0, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_chair.mdl", Vector( -3168, 3504, -895.09197998047 ), Angle(0, 225, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_chair.mdl", Vector( -3152, 3424, -895.09197998047 ), Angle(0, 330, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_umbrella_big_open.mdl", Vector( -3120, 3472, -895.69598388672 ), Angle(0, 0, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_chair.mdl", Vector( -3072, 3456, -895.09197998047 ), Angle(0, 75, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_chair.mdl", Vector( -2800, 3520, -895.09197998047 ), Angle(0, 135, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_chair.mdl", Vector( -2896, 3520, -895.09197998047 ), Angle(0, 240, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_chair.mdl", Vector( -2896, 3456, -895.09197998047 ), Angle(0, 315, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_table.mdl", Vector( -2848, 3488, -895.69598388672 ), Angle(0, 0, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props/de_dust/hr_dust/dust_patio_set/dust_patio_umbrella_big_open.mdl", Vector( -2848, 3488, -895.69598388672 ), Angle(0, 0, 0), 0, Color(255,255,255))
	AddL2Seat( "models/props_urban/light_fixture01.mdl", Vector( -2681, 3392, -720 ), Angle(0, 180, 0), 1, Color(255,255,255))
	AddL2Seat( "models/props_urban/light_fixture01.mdl", Vector( -2681, 3191, -720 ), Angle(0, 180, 0), 1, Color(255,255,255))
	AddL2Seat( "models/props_urban/light_fixture01.mdl", Vector( -2681, 3048, -720 ), Angle(0, 180, 0), 1, Color(255,255,255))
	AddL2Seat( "models/props_urban/light_fixture01.mdl", Vector( -2681, 2847, -720 ), Angle(0, 180, 0), 1, Color(255,255,255))
	AddL2Seat( "models/props_urban/light_fixture01.mdl", Vector( -2681, 2701, -720 ), Angle(0, 180, 0), 1, Color(255,255,255))
	AddL2Seat( "models/props_urban/light_fixture01.mdl", Vector( -2681, 2357, -720 ), Angle(0, 180, 0), 1, Color(255,255,255))
	AddL2Seat( "models/props_urban/light_fixture01.mdl", Vector( -2681, 2156, -720 ), Angle(0, 180, 0), 1, Color(255,255,255))
	AddL2Seat( "models/props_urban/light_fixture01.mdl", Vector( -2681, 2016, -720 ), Angle(0, 180, 0), 1, Color(255,255,255))
	AddL2Seat( "models/props_urban/light_fixture01.mdl", Vector( -2681, 1815, -720 ), Angle(0, 180, 0), 1, Color(255,255,255))

end)
