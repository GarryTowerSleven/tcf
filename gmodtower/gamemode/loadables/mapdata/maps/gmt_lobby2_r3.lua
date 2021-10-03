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

local condoDoorData = {
	{ 'bathroom', 'models/map_detail/condo_slidingdoor.mdl', Angle(0, 0, 0), Vector(-6, 4, 10)  },
	{ 'extraroom', 'models/map_detail/condo_slidingdoor.mdl', Angle(0, 90, 0), Vector(-4, -6, 10)  },
	{ 'outside', 'models/map_detail/condo_slidingdoor.mdl', Angle(0, -90, 0), Vector(4, 6, 10)  },
	{ 'closet', 'models/map_detail/condo_slidingdoor.mdl', Angle(0, 90, 0), Vector(-4, -6, 10)  },
	{ 'pool2', 'models/map_detail/condo_slidingdoor.mdl', Angle(0, 90, 0), Vector(-4, -6, 10)  },
	{ 'bedroom', 'models/map_detail/condo_slidingdoor.mdl', Angle(0, 0, 0), Vector(-6, 4, 10)  },
	{ 'shower', 'models/map_detail/condo_shower_door.mdl', Angle(0, -90, 0), Vector(0, -34, -39)  },
	{ 'pool', 'models/map_detail/condo_slidingbackdoor.mdl', Angle(0, -90, 0), Vector(2, 0, -0.3)  },
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
	cam:SetAngles( ang )
	cam:Spawn()

	cam:SetNWInt( "Condo", (GetNearestCondo( pos ) or 0) )

end

local function AddL2Seat( model, pos, angle, skin, color )

	local seat = ents.Create( "prop_dynamic" )
	seat:SetPos( pos )
	seat:SetAngles( angle )
	seat:SetModel( model )
	seat:SetSolid( SOLID_VPHYSICS )
	seat:SetSkin( skin )
	seat:Spawn()

	if model == "models/map_detail/beach_chair.mdl" then
		seat:SetColor( table.Random( BeachChairColors ) )
	end

	if color != Color(255, 255, 255) then
		seat:SetColor( color )
	end

	seat:SetSaveValue("fademindist", 2048)
	seat:SetSaveValue("fademaxdist", 4096)

end

local function AddL2Door( ent, name, pos )

	local doorRaw = string.sub( name, 13 )

	local doorID = string.sub( doorRaw, 1, 2 )
	local doorName = string.sub( doorRaw, 14 )

	local condodoorAng, condodoorPos, condodoorModel

	for k,v in pairs(condoDoorData) do
		if v[1] == doorName then
			condodoorAng = v[3]
			condodoorPos = pos + v[4]
			condodoorModel = v[2]
		end
	end

	local door = ents.Create( "prop_dynamic" )
	door:SetPos( condodoorPos or pos )
	door:SetAngles( condodoorAng or Angle(0,0,0) )
	door:SetModel( condodoorModel or 'models/map_detail/condo_slidingdoor.mdl' )
	door:SetParent( ent )
	door:Spawn()
	door:DrawShadow( false )

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

local function RespawnEnt( ent )
	local class = ent:GetClass()
	local pos = ent:GetPos()
	pos.y = pos.y + 1.5
	local ang = ent:GetAngles()

	ent:Remove()

	local new = ents.Create( class )
	new:SetPos( pos )
	new:SetAngles( ang )
	new:Spawn()
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

local function MapFixes()

	// Center SK Multi
	for k,v in pairs( ents.FindInSphere( Vector(6254.8671875, -6095.8579101563, -825.11450195313), 600 ) ) do
		if v:GetClass() == "gmt_multiserver" then
			v:SetPos( v:GetPos() - Vector(16, 0, 0) )
		end
	end

	// Condo Doors
	for k,v in pairs(ents.FindByClass("func_door")) do
		AddL2Door( v, v:GetName(), v:GetPos() )
	end

	// Condo Bathroom
	for k,v in pairs( ents.FindByClass("gmt_roomloc") ) do
		AddL2Seat( "models/map_detail/condo_toilet.mdl", v:GetPos() + Vector(-32, -148, 0.3), Angle(0, 180, 0), 0, Color(255, 255, 255))

		SpawnDynamicProp( "models/map_detail/condo_toiletpaper.mdl", v:GetPos() + Vector(-0, -160, 28.8), Angle(0,180,0), false )
		SpawnDynamicProp( "models/map_detail/condo_towelrack.mdl", v:GetPos() + Vector(-0, -212, 60), Angle(0,180,0), false )
		SpawnDynamicProp( "models/map_detail/bathroomsink.mdl", v:GetPos() + Vector(-184, -264, 0), Angle(0,180,0), false )
		SpawnDynamicProp( "models/map_detail/mirrorfixture.mdl", v:GetPos() + Vector(-188, -299, 65), Angle(0,90,0), false )
		SpawnDynamicProp( "models/map_detail/bathtub1.mdl", v:GetPos() + Vector(-116, -151, 0.3), Angle(0,270,0), false )
	end

	// Mapboard in Station
	for k,v in pairs(ents.FindByClass('gmt_mapboard')) do
		if v:GetPos() == Vector(7128.000000, 0.000000, -1074.000000) then
			v:Remove()
		end
	end

	// Gamemodes Banner
	AddMapEntity( "gmt_gamebanner", Vector( 4400, -2915, 118 ), Angle( 0, 0, 0 ) )
	--SpawnDynamicProp( "models/map_detail/gmbanners.mdl", Vector( 4400, -2915, 118 ), Angle( 0, 90, 0 ), true )

	// Remove Fog
	timer.Simple( 3, function()
		for _, v in pairs( ents.FindByClass("func_smokevolume") ) do
			v:Remove()
		end
	end)

	// Respawn Electronic NPC
	timer.Simple( 5, function()
		for k,v in pairs( ents.FindByClass("gmt_npc_electronic") ) do
			RespawnEnt( v )
		end
	end)

	// Arcade Tables
	SpawnDynamicProp( "models/wilderness/wildernesstable1.mdl", Vector(4064, 4111, -896), Angle(0,60,0), false )
	SpawnDynamicProp( "models/wilderness/wildernesstable1.mdl", Vector(4656, 4364, -896), Angle(0,75,0), false )
	SpawnDynamicProp( "models/wilderness/wildernesstable1.mdl", Vector(4656, 4413, -896), Angle(0,55,0), false )

	// Ballrace Port Goal
	SpawnDynamicProp( "models/props_memories/memories_levelend.mdl", Vector(3424, -6400, -904), Angle(0, 0, 0), false )

end

hook.Add("InitPostEntity","AddL2Ents",function()

	MapFixes()

	NetworkCondoPanelIDs()
	SpawnCondoPlayers()	


	// Dopefish
	local ent = ents.Create("prop_dynamic")
	ent:SetPos( Vector(-5726.058594, -2349.844482, -1063.220093) )
	ent:SetAngles( Angle(1.677856, 180.635330, 0.000000) )
	ent:SetModel( "models/gmod_tower/dopefishisaliveyall.mdl" )
	ent:Spawn()
	ent:ResetSequenceInfo()
	ent:SetSequence( "idle" )

	// Halloween Shop
	if IsHalloweenMap() then
		AddL2Seat( "models/gmod_tower/shopstand.mdl", Vector( 5497.978516, -187.837418, -895.029480 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
		AddMapEntity( "gmt_npc_halloween", Vector( 5497.978516, -220, -895.029480 ), Angle( 0, 90, 0 ) )
	end

	// Christmas Sack
	if IsChristmasMap() then
		AddMapEntity( "gmt_presentbag", Vector( 4927.875, 208.3125, -894.718750 ), Angle( 0, 120, 0 ) )
	end

	// Particles Store
	--AddMapEntity( "gmt_npc_particles", Vector( 7434, 221, -1088 ), Angle( 0, -135, 0 ) )
	
	// Transit Station NPCs
	AddMapEntity( "gmt_npc_vip", Vector( 7425, 218, -1085 ), Angle( 0, -135, 0 ) )
	AddMapEntity( "gmt_npc_money", Vector( 7425, -212, -1085 ), Angle( 0, 135, 0 ) )

	// Web Board
	AddMapEntity( "gmt_webboard", Vector( 7504, 0, -1080 ), Angle( 0, 180, 0 ) )
	
	// The Board
	AddMapEntity( "gmt_streamer_board", Vector( 2580, 4930, -911 ), Angle( 0, 75, 0 ) )

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

	//AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(2818.1101074219, -2104.9299316406, -864), Angle(0, 279, 0), 1, Color(196, 0, 0, 255))
	//AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2696.0700683594, -2015.6300048828, -863.81097412109), Angle(0, 19, 0), 1, Color(196, 0, 0, 255))
	//AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2756, -2024, -863.81097412109), Angle(0, 334, 0), 1, Color(196, 0, 0, 255))

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
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector(7484, -101, -1066.4799804688), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector(7484, 99.000099182129, -1067), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
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
	
	//AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7000, -816, -608), Angle(0, 239.5, 0), 0, Color(255, 255, 255, 255))
	//AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(7016, -720, -608), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	//AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7008, -632, -608), Angle(0, 287, 0), 0, Color(255, 255, 255, 255))
	//AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7000, -464, -608), Angle(0, 239.5, 0), 0, Color(255, 255, 255, 255))
	//AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(7016, -368, -608), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	//AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7008, -280, -608), Angle(0, 287, 0), 0, Color(255, 255, 255, 255))
	//AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7000, 256, -608), Angle(0, 239.5, 0), 0, Color(255, 255, 255, 255))
	//AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(7016, 352, -608), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	//AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7008, 440, -608), Angle(0, 287, 0), 0, Color(255, 255, 255, 255))
	//AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7000, 608, -608), Angle(0, 239.5, 0), 0, Color(255, 255, 255, 255))
	//AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(7016, 704, -608), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	//AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7008, 792, -608), Angle(0, 287, 0), 0, Color(255, 255, 255, 255))

	// Inaccurate, but better
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(7004, 712, -607.81097412109), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(7004, 392, -607.81097412109), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(7004, -380, -607.81097412109), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(7004, -704, -607.81097412109), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7504, 1512, -608), Angle(0, 343, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(7416, 1520, -608), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7320, 1504, -608), Angle(0, 31, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7008, 1504, -608), Angle(0, 329.5, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(6912, 1520, -608), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(6824, 1512, -608), Angle(0, 17, 0), 0, Color(255, 255, 255, 255))
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

end)