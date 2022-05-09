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

	local value = unpack( doors )
	local door = table.KeyFromValue( doors, value )

	if !IsValid(door) then return end

	return door:GetCondoID()

end

local function AddL2Camera( pos, ang )
	local cam = ents.Create("gmt_condo_camera")
	cam:SetPos( pos )
	cam:SetAngles( ang )
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

local function SpawnDynamicProp( model, pos, ang, shadow )
	local prop = ents.Create( "prop_dynamic" )
	prop:SetPos( pos )
	prop:SetAngles( ang )
	prop:SetModel( model )
	prop:SetSolid( SOLID_VPHYSICS )
	prop:Spawn()
	prop:DrawShadow( shadow )
end

local function CenterSKPanel()
	for k,v in pairs( ents.FindInSphere( Vector(6254.8671875, -6095.8579101563, -825.11450195313), 600 ) ) do
		if v:GetClass() == "gmt_multiserver" then
			v:SetPos( v:GetPos() - Vector(10, 0, 0) )
		end
	end
end

local function NetworkCondoPanelIDs()
	for k,v in pairs(ents.FindByClass("gmt_condo_panel")) do
		local entloc = Location.Find( v:GetPos() )
		local condoID = entloc

		v:SetNWInt( "condoID", condoID )
	end
end

local function SpawnCondoPlayers()
	for k,v in pairs(ents.FindByClass("gmt_roomloc")) do
		local entloc = Location.Find( v:GetPos() )
		local condoID = entloc

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
	end
end

local function SetupSKPort()
	AddMapEntity( "gmt_sk_pickup", Vector( 6384, -6768, -900 ), Angle( 0, 0, 0 ) )
	AddMapEntity( "gmt_sk_pickup", Vector( 6288, -6768, -900 ), Angle( 0, 0, 0 ) )
	AddMapEntity( "gmt_sk_pickup", Vector( 6192, -6768, -900 ), Angle( 0, 0, 0 ) )
	AddMapEntity( "gmt_sk_pickup", Vector( 6096, -6768, -900 ), Angle( 0, 0, 0 ) )
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

	AddMapModel( "models/sunabouzu/golf_hole.mdl", Vector( 7070, -5544, -878 ), Angle( 0, 0, 0 ) )
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

	//for k,v in pairs( ents.FindByClass("env_projectedtexture") ) do
	//	v:Remove()
	//end

	// Remove Condo Door Shadows
	timer.Simple( 1, function()
		for _, door in pairs( ents.FindByClass("func_door") ) do
			door:GetChildren()[1]:DrawShadow(false)
		end	
	end )
end

local function SpawnGameBanner()
	local banner = ents.Create("gmt_gamebanner")
	banner:SetPos(Vector(4398.583496, -2909.327881, 137.968750))
	banner:Spawn()
end

local function createPreview( loc, ang, key, w, h )
	local preview = ents.Create("gmt_theater_preview")
	preview:SetPos( loc )
	preview:SetAngles( ang or Angle( 0,0,0 ) )
	preview:SetKeyValue( "theater", key )
	preview:SetKeyValue( "width", tostring(w) or "79" )
	preview:SetKeyValue( "height", tostring(h) or "82" )
	preview:Spawn()
end

local function CreateTheaterPreviews()
	createPreview( Vector(4110.6, 2677.75, -615.15), nil, "theater1" )
	createPreview( Vector(4610.4, 2677.75, -615.15), nil, "theater2" )

	createPreview( Vector(4020.6, 2816.75, -638.15), Angle(0,-90,0), "theater1", 106, 59 )
	createPreview( Vector(4778.6, 2710.75, -638.15), Angle(0,90,0), "theater2", 106, 59 )
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
	SetupSKPort()							-- Source Karts port animations
	SetupUCHPort()						-- UCH port animation
	SetupBallracePort()				-- Ballrace port animations
	SetupZombieMassacrePort()	-- Zombie Massacre port animations
	SetupMinigolfPort()				-- Minigolf port animations

	// Misc
	//===============================================
	SpawnGameBanner()					-- Spawns the animated gamemode banner model
	CreateTheaterPreviews()				-- Theater previews


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

    // Ballrace Port Goal
	SpawnDynamicProp( "models/props_memories/memories_levelend.mdl", Vector(3424, -6400, -904), Angle(0, 0, 0), false )

	// Theatre Missing Table
	SpawnDynamicProp( "models/wilderness/wildernesstable1.mdl", Vector(4064, 4111, -896), Angle(0,60,0), false )

	if time.IsThanksgiving() then
		AddMapEntity( "gmt_npc_thanksgiving", Vector( 5497.978516, -220, -895.029480 ), Angle( 0, 90, 0 ) )
	end

	// Condo cameras
	//===============================================
	AddL2Camera( Vector( -1154, 54, 15100 ), Angle(0, 90, 0) )
	AddL2Camera( Vector( -672, 54, 15100 ), Angle(0, 90, 0) )
	AddL2Camera( Vector( -192, 54, 15100 ), Angle(0, 90, 0) )
	AddL2Camera( Vector( -3940, 54, 15100 ), Angle(0, 90, 0) )
	AddL2Camera( Vector( -3458, 54, 15100 ), Angle(0, 90, 0) )
	AddL2Camera( Vector( -2978, 54, 15100 ), Angle(0, 90, 0) )
	AddL2Camera( Vector( -2888, 654, 15100 ), Angle(0, -90, 0) )
	AddL2Camera( Vector( -3368, 654, 15100 ), Angle(0, -90, 0) )
	AddL2Camera( Vector( -3850, 654, 15100 ), Angle(0, -90, 0) )
	AddL2Camera( Vector( -102, 654, 15100 ), Angle(0, -90, 0) )
	AddL2Camera( Vector( -582, 654, 15100 ), Angle(0, -90, 0) )
	AddL2Camera( Vector( -1064, 654, 15100 ), Angle(0, -90, 0) )

	// SEATS!!!
	//===============================================
    AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(64, 104, -896), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(224, 104, -896), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(64, -104, -896), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(224, -104, -896), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(2464, -1024, -896), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(2320, -1024, -896), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(2912, -1024, -896), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(3056, -1024, -896), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(1664, -368, -896), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(1664, -224, -896), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(1664, 368, -896), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(1664, 224, -896), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(2464, 1024, -896), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(2320, 1024, -896), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(2912, 1024, -896), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(3056, 1024, -896), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(3712, 368, -896), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(3712, 224, -896), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(3712, -368, -896), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(3712, -224, -896), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector(5032, 248, -883), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector(5144, 248, -883), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector(5032, -248, -883), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector(5144, -248, -883), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector(4864, 1312, -883), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector(4864, 1176, -883), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector(4864, 584, -883), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector(4864, -1312, -883), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector(4864, -1176, -883), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector(4864, -584, -883), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(-1188, -104, -896), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(-1028, -104, -896), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(-1028, 104, -896), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(-1188, 104, -896), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(4204, -368, -895.75), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(4364, -368, -895.75), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(4364, -160.08799743652, -895.75), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(4204, -160.08799743652, -895.75), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(4372, 376, -895.75), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(4212, 376, -895.75), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(4212, 168.08799743652, -895.75), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(4372, 168.08799743652, -895.75), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(1896.9499511719, -4646.6298828125, -2604), Angle(0, 34.999992370605, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(1885.3100585938, -4713.9799804688, -2604), Angle(0, -55, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(1829.5999755859, -4634.9799804688, -2604), Angle(0, 125, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(1822.0699462891, -4699.4501953125, -2604), Angle(0, -145.00001525879, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(1953.5600585938, -4502.2900390625, -2604), Angle(0, -10.000014305115, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(1914.1800537109, -4446.4399414063, -2604), Angle(0, 80, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(1863.2700195313, -4486.7001953125, -2604), Angle(0, 170, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(1897.7099609375, -4541.6801757813, -2604), Angle(0, -99.999992370605, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(2021.8000488281, -4594, -2604), Angle(0, 177, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(2067.419921875, -4547.830078125, -2604), Angle(0, 86.999992370605, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(2062.6799316406, -4644.3701171875, -2604), Angle(0, -93.000007629395, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(5397.8999023438, -3608.25, -895.53900146484), Angle(0, 359.5, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(5333.25, -3617.8598632813, -895.53900146484), Angle(0, 7.5000100135803, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(5459.490234375, -3619.1201171875, -895.53900146484), Angle(0, 334, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(5708.41015625, -3624.3598632813, -895.53900146484), Angle(0, 7.5000100135803, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(5834.6499023438, -3625.6201171875, -895.53900146484), Angle(0, 334, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(5773.0600585938, -3614.75, -895.53900146484), Angle(0, 359.5, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(6147.3500976563, -3629.4301757813, -895.53900146484), Angle(0, 7.5000100135803, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(6212, -3619.8198242188, -895.53900146484), Angle(0, 359.5, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(6273.58984375, -3630.6899414063, -895.53900146484), Angle(0, 334, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(3363.3500976563, -3629.4301757813, -895.53900146484), Angle(0, 7.5000100135803, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(3428, -3619.8198242188, -895.53900146484), Angle(0, 359.5, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(3489.5900878906, -3630.6899414063, -895.53900146484), Angle(0, 334, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2924.4099121094, -3624.3598632813, -895.53900146484), Angle(0, 7.5000100135803, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(3050.6499023438, -3625.6201171875, -895.53900146484), Angle(0, 334, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2989.0600585938, -3614.75, -895.53900146484), Angle(0, 359.5, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2613.8999023438, -3608.25, -895.53900146484), Angle(0, 359.5, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2549.25, -3617.8598632813, -895.53900146484), Angle(0, 7.5000100135803, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2675.4899902344, -3619.1201171875, -895.53900146484), Angle(0, 334, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(4332, -4952, -895.7509765625), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(4492, -4952, -895.7509765625), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(4332, -4744.08984375, -895.7509765625), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(4492, -4744.08984375, -895.7509765625), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/haxxer/me2_props/reclining_chair.mdl", Vector(4617.759765625, -768, -3519.75), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/haxxer/me2_props/reclining_chair.mdl", Vector(4617.759765625, -840, -3519.75), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/haxxer/me2_props/reclining_chair.mdl", Vector(4617.759765625, -568, -3519.75), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/haxxer/me2_props/reclining_chair.mdl", Vector(4617.759765625, -640, -3519.75), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/haxxer/me2_props/reclining_chair.mdl", Vector(4617.759765625, -704, -3519.75), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3339, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3373, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3407, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3441, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3475, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3509, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3543, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3577, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3645, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3611, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3339, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3373, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3407, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3441, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3475, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3509, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3543, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3577, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3645, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3611, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3339, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3373, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3407, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3441, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3475, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3509, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3543, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3577, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3645, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3611, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3339, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3373, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3407, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3441, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3475, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3509, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3543, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3577, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3645, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3611, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3339, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3373, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3407, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3441, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3475, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3509, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3543, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3577, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3645, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3611, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3339, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3373, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3407, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3441, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3475, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3509, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3543, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3577, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3645, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3611, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3339, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3373, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3407, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3441, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3475, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3509, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3543, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3577, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3645, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3611, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3793, 5268, -2892), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3834, 5268, -2892), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3834, 5350, -2918), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3793, 5350, -2918), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3793, 5186, -2866), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3834, 5186, -2866), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3834, 5106, -2840), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3793, 5025, -2814), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3793, 5106, -2840), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3834, 5025, -2814), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3834, 4945, -2788), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3793, 4945, -2788), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(576, 768, -672), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(-96, 920, -672), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(-256, 920, -672), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(576, -768.08801269531, -672), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(688, -768.08801269531, -672), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(-256, -920.08801269531, -672), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(-96, -920.08801269531, -672), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(-256, -1128, -672), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(-96, -1128, -672), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector(5400, -216, -595), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector(5560, -216, -595), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector(5400, 216, -595), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector(5560, 216, -595), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(576, -1128, -672), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(688, -1128, -672), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(-256, 1127.9100341797, -672), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(-96, 1127.9100341797, -672), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(576, 1135.9100341797, -672), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(688, 768, -672), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(688, 1135.9100341797, -672), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(-448, 1536, -672), Angle(0, 90, 0), 1, Color(172, 92, 45, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(218.03500366211, 1536, -672), Angle(0, 270, 0), 1, Color(172, 92, 45, 255))
	AddL2Seat( "models/gmod_tower/medchair.mdl", Vector(-1568, -1016, -888), Angle(0, 334, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/haxxer/me2_props/reclining_chair.mdl", Vector(-1568, -968, -888), Angle(0, 247, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/haxxer/me2_props/illusive_chair.mdl", Vector(-1568, -920, -888), Angle(0, 153.5, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/comfychair.mdl", Vector(-912, -1400, -664), Angle(0, 110, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/splayn/rp/lr/chair.mdl", Vector(-768, -1392, -664), Angle(0, 135, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(2600, -9536, -2624), Angle(0, 90, 0), 1, Color(139, 12, 5, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(2600, -9404, -2624), Angle(0, 90, 0), 1, Color(139, 12, 5, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(3402.0300292969, -9404, -2624), Angle(0, 270, 0), 1, Color(139, 12, 5, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(3402.0300292969, -9536, -2624), Angle(0, 270, 0), 1, Color(139, 12, 5, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2809.1298828125, -2490.2399902344, -863.81097412109), Angle(0, 244, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2820, -2428.6499023438, -863.81097412109), Angle(0, 269.5, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2810.3898925781, -2364, -863.81097412109), Angle(0, 277.5, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(2770.7399902344, -2047.4300537109, -863.81097412109), Angle(0, 315, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2816, -2128, -863.81097412109), Angle(0, 285, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2688, -2000, -863.81097412109), Angle(0, 345, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2386.9799804688, -1994.2800292969, -864), Angle(0, 7.5, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2451.6298828125, -1984.6800537109, -864), Angle(0, 359.5, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2513.2199707031, -1995.5500488281, -864), Angle(0, 334, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector(6432, -288, -1066.4799804688), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector(6672, -288, -1066.4799804688), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector(6432, 288, -1066.4799804688), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector(6672, 288, -1066.4799804688), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector(7664, 936, -1259), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector(7664, 816, -1259), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector(6592, 936, -1259), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector(6592, 816, -1259), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector(6592, -816, -1259), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector(6592, -936, -1259), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector(7664, -816, -1259), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector(7664, -936, -1259), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	//AddL2Seat( "models/map_detail/station_bench.mdl", Vector(7484, -101, -1066.4799804688), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	//AddL2Seat( "models/map_detail/station_bench.mdl", Vector(7484, 99.000099182129, -1067), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(1936, -5056, -2624), Angle(0, 105, 0), 1, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(1888, -4992, -2623.8100585938), Angle(0, 90.000007629395, 0), 1, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(1936, -4928, -2623.8100585938), Angle(0, 74.999984741211, 0), 1, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(1936, -5264, -2624), Angle(0, 105, 0), 1, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(1936, -5135.9995117188, -2623.8100585938), Angle(0, 74.999984741211, 0), 1, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(1888, -5200, -2623.8100585938), Angle(0, 90.000007629395, 0), 1, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector(2536, -4544, -2623), Angle(0, 90.000007629395, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector(2576, -4544, -2623), Angle(0, 90.000007629395, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector(2456, -4544, -2623), Angle(0, 90.000007629395, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector(2496, -4544, -2623), Angle(0, 90.000007629395, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector(2296, -4544, -2623), Angle(0, 90.000007629395, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector(2336, -4544, -2623), Angle(0, 90.000007629395, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector(2376, -4544, -2623), Angle(0, 90.000007629395, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector(2416, -4544, -2623), Angle(0, 90.000007629395, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector(2132, -4352, -2623), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector(2132, -4392, -2623), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector(2132, -4432, -2623), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector(2247.0500488281, -4543.080078125, -2623), Angle(0, 90.000007629395, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(1999.6700439453, -4352.16015625, -2604), Angle(0, -180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(2096.330078125, -4351.83984375, -2604), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(1960, -4353.7797851563, -2604), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(1863.3399658203, -4354.1000976563, -2604), Angle(0, -180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(1761.7799072266, -4495.33984375, -2604), Angle(0, 90.000007629395, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(1762.0999755859, -4592, -2604), Angle(0, -90.000007629395, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector(2200, -4544, -2623), Angle(0, 90.000007629395, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector(2132, -4476, -2623), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/sunabouzu/theater_curve_couch.mdl", Vector(2048, -5664, -2623.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/sunabouzu/theater_curve_couch.mdl", Vector(2304, -5664, -2623.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(3787.9099121094, -4657.009765625, -895.76000976563), Angle(0, 5.0000100135803, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(3827.9299316406, -4775.0498046875, -895.76000976563), Angle(0, 33.5, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(2924.0700683594, -4785.0498046875, -895.76000976563), Angle(0, 147, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(2958.0900878906, -4687, -895.76000976563), Angle(0, 176.5, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(3458, -5286.91015625, -895.76000976563), Angle(0, 270.5, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(3332, -5286.91015625, -895.76000976563), Angle(0, 270.5, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(5356, -5297.91015625, -895.76000976563), Angle(0, 269.5, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(5482, -5297.91015625, -895.76000976563), Angle(0, 269.5, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(5839.91015625, -4706, -895.76000976563), Angle(0, 3.5, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(5873.9301757813, -4804.0498046875, -895.76000976563), Angle(0, 33, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(5018.08984375, -4668.009765625, -895.76000976563), Angle(0, 175, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(4978.0698242188, -4786.0498046875, -895.76000976563), Angle(0, 146.5, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(-1754, -586, 15303), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(-1658, -690, 15303), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(-2041, 1710, 14983.200195313), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(-1608.5500488281, -136.86000061035, 14983.200195313), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(-1690.5500488281, -54.860000610352, 14983.200195313), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(-2434.5900878906, -16.590000152588, 14983.200195313), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(-2352.5900878906, -98.589996337891, 14983.200195313), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(-2402, -674, 15303), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(-2298, -578, 15303), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-4149.8100585938, 1037.0999755859, -952.95098876953), Angle(-3.6437900066376, 311.76800537109, 1.69468998909), 0, Color(79, 237, 33, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-4303.509765625, 1558.8699951172, -942.40600585938), Angle(-0.71457898616791, 305.92199707031, -2.3608200550079), 0, Color(207, 228, 58, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-4254.7700195313, 1502.6999511719, -938.06701660156), Angle(-3.6437900066376, 305.76800537109, 1.69468998909), 0, Color(224, 128, 39, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-4227.3901367188, 1777.0200195313, -935.71301269531), Angle(-0.71457898616791, 305.92199707031, -2.3608200550079), 0, Color(228, 58, 186, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-4543.3500976563, 1793.1999511719, -972.94598388672), Angle(-0.71457898616791, 2.9219899177551, -2.3608200550079), 0, Color(32, 177, 208, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-3716.7800292969, 1460.7099609375, -907.52099609375), Angle(-0.71457898616791, 305.92199707031, -2.3608200550079), 0, Color(216, 58, 228, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-3744.3000488281, 966.97698974609, -935.69299316406), Angle(-3.6437900066376, 292.76800537109, 1.69468998909), 0, Color(241, 18, 23, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-3717.6799316406, 908.56701660156, -935.78302001953), Angle(-3.6437900066376, 292.76800537109, 1.69468998909), 0, Color(48, 98, 216, 255))
	AddL2Seat( "models/sunabouzu/theater_sofa01.mdl", Vector(3833, 4334, -895.98297119141), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/sunabouzu/theater_sofa01.mdl", Vector(3696, 4224, -895.98297119141), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/sunabouzu/theater_sofa01.mdl", Vector(3744, 4312, -895.98297119141), Angle(0, 30, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/sunabouzu/theater_sofa01.mdl", Vector(4964.990234375, 4327.8999023438, -895.98297119141), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/sunabouzu/theater_sofa01.mdl", Vector(5053.919921875, 4305.83984375, -895.98297119141), Angle(0, 330, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/sunabouzu/theater_sofa01.mdl", Vector(5101.740234375, 4217.8500976563, -895.98297119141), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3150, 4945, -2788), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3191, 4945, -2788), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3191, 5025, -2814), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3150, 5025, -2814), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3191, 5106, -2840), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3150, 5106, -2840), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3150, 5186, -2866), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3191, 5186, -2866), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3150, 5268, -2892), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3191, 5268, -2892), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3150, 5350, -2918), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3191, 5350, -2918), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5155, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5189, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5223, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5257, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5291, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5325, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5359, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5393, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5461, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5427, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5155, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5189, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5223, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5257, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5291, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5325, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5359, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5393, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5461, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5427, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5155, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5189, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5223, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5257, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5291, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5325, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5359, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5393, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5461, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5427, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5155, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5189, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5223, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5257, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5291, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5325, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5359, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5393, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5461, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5427, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5155, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5189, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5223, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5257, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5291, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5325, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5359, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5393, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5461, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5427, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5155, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5189, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5223, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5257, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5291, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5325, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5359, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5393, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5461, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5427, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5155, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5189, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5223, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5257, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5291, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5325, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5359, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5393, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5461, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5427, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5007, 5350, -2918), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(4966, 5350, -2918), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5007, 5268, -2892), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(4966, 5268, -2892), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5007, 5186, -2866), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(4966, 5186, -2866), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(4966, 5106, -2840), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5007, 5106, -2840), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5007, 5025, -2814), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(4966, 5025, -2814), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(4966, 4945, -2788), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5007, 4945, -2788), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5650, 5350, -2918), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5609, 5350, -2918), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5650, 5268, -2892), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5609, 5268, -2892), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5650, 5186, -2866), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5609, 5186, -2866), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5650, 5106, -2840), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5609, 5106, -2840), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5609, 5025, -2814), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5650, 5025, -2814), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5650, 4945, -2788), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5609, 4945, -2788), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(6422, 1209, -607), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(6340, 1127, -607), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(6349, 1437, -607), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(6267, 1355, -607), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(6364.7299804688, -1126.2199707031, -606.80999755859), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(6288.58984375, -1210.5200195313, -606.80999755859), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(6444.3901367188, -1341.5500488281, -606.80999755859), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(6374.1201171875, -1423.1600341797, -606.80999755859), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(7004, 712, -607.81097412109), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(6949, 807, -607.81097412109), Angle(0, 360, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(6949, 617, -607.81097412109), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(7004, 392, -607.81097412109), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(6949, 487, -607.81097412109), Angle(0, 360, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(6949, 297, -607.81097412109), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(7004, -380, -607.81097412109), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(6949, -285, -607.81097412109), Angle(0, 360, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(6949, -475, -607.81097412109), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(7004, -704, -607.81097412109), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(6949, -609, -607.81097412109), Angle(0, 360, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(6949, -799, -607.81097412109), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(7257, 968, -607.5), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7352, 1023, -607.5), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7162, 1023, -607.5), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(7242, -965, -607.5), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7337, -1020, -607.5), Angle(0, -90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7147, -1020, -607.5), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7504, 1512, -608), Angle(0, 343, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(7416, 1520, -608), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7320, 1504, -608), Angle(0, 31, 0), 0, Color(255, 255, 255, 255))
	//AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7008, 1504, -608), Angle(0, 329.5, 0), 0, Color(255, 255, 255, 255))
	//AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(6912, 1520, -608), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	//AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(6824, 1512, -608), Angle(0, 17, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-3503.6398925781, -935.53802490234, -896), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-3707.2900390625, -935.53802490234, -896), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-3639.3999023438, -935.53802490234, -896), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-3571.5200195313, -935.53802490234, -896), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-3392.0700683594, -895.4169921875, -896), Angle(0, 225, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-3344.0700683594, -847.4169921875, -896), Angle(0, 225, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-3296.0700683594, -799.4169921875, -896), Angle(0, 225, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-3248.0700683594, -751.4169921875, -896), Angle(0, 225, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-2991.9299316406, -1818.5799560547, -896), Angle(0, 45, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-2935.9299316406, -1762.5799560547, -896), Angle(0, 45, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-2887.9299316406, -1714.5799560547, -896), Angle(0, 45, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-2839.9299316406, -1666.5799560547, -896), Angle(0, 45, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-2791.9299316406, -1618.5799560547, -896), Angle(0, 45, 0), 0, Color(255, 255, 255, 255))

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
