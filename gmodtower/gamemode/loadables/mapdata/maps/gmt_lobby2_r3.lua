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
	local banner = ents.Create("gmt_gamebanner")
	banner:SetPos(Vector(4398.583496, -2909.327881, 137.968750))
	banner:Spawn()

	// Remove Fog
	timer.Simple( 3, function()
		for _, v in pairs( ents.FindByClass("func_smokevolume") ) do
			//print( "removing : " .. tostring( v ) .. " @ " .. tostring( v:GetBrushPlane( 1 ) ) )
			v:Remove()
		end
	end)

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
	--local ent = ents.Create("gmt_npc_particles")
	--ent:SetPos( Vector(7434, 221, -1088) )
	--ent:SetAngles( Angle(0, -135, 0) )
	--ent:Spawn()
	
	// Beta Money NPC
	AddMapEntity( "gmt_npc_money", Vector( 7425, 218, -1090 ), Angle( 0, -135, 0 ) )
	
	// The Board
	local ent = ents.Create( "gmt_streamer_board" )
	ent:SetPos( Vector( 2580, 4930, -911 ) )
	ent:SetAngles( Angle(0, 75, 0) )
	ent:Spawn()

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

	AddL2Seat( "models/map_detail/station_bench.mdl", Vector( 6592, 808, -1258.7299804688 ), Angle(0, 0, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector( 6592, 936, -1258.7299804688 ), Angle(0, 0, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector( 7664, 808, -1258.7299804688 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector( 7664, 936, -1258.7299804688 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector( 6592, -936, -1258.7299804688 ), Angle(0, 0, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector( 6592, -808, -1258.7299804688 ), Angle(0, 0, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector( 7664, -936, -1258.7299804688 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector( 7664, -808, -1258.7299804688 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector( 7488, 80, -1066.7299804688 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector( 7488, -80, -1066.7299804688 ), Angle(0, 180, 0), 0, Color(255, 255, 255))
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
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector( 2192, -4544, -2623.7700195313 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector( 2240, -4544, -2623.7700195313 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector( 2288, -4544, -2623.7700195313 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
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

end)