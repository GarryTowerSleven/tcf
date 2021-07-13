//lua_run_cl Msg( LocalPlayer():GetEyeTrace().HitPos )

module("Location", package.seeall )

GTowerLocation.MapPositions = {
    // Transit Station
    { 38, Vector(5720,-704,-1328), Vector(7512,704,-640), 'transit', 1 }, // Transit Station
    { 39, Vector(5424,704,-1328), Vector(8832,1256,-1024), 'transit', 0 }, // Station A
    { 40, Vector(5424,-1256,-1328), Vector(8832,-704,-1024), 'transit', 0 }, // Station B

    // Plaza
    { 17, Vector(1024,-3328,-1024), Vector(6136,3240,-36), 'plaza', 0 }, // Plaza
    { 16, Vector(1920,-768,-992), Vector(3456,768,-896), 'plaza', 1 }, // Center Plaza
    { 19, Vector(1656,1536,-864), Vector(1960,1960,-608), 'plaza', 1 }, // Arcade Loft
    { 24, Vector(1784,-3000,-864), Vector(2856,-1960,-576), '', 1 }, // Casino Loft

    // Stores
    { 18, Vector(-1856,-1448,-966), Vector(1024,1440,-36), 'stores', 0 }, // Stores

    { 20, Vector(-472,1440,-672), Vector(240,2240,-372), 'stores', 1 }, // Tower Outfitters
    { 21, Vector(288,1440,-671), Vector(1032,2296,-432), 'stores', 1 }, // Toy Stop and Pets
    { 37, Vector(288,-2208,-672), Vector(1024,-1440,-428), 'stores', 1 }, // Songbirds
    { 23, Vector(-672,-2208,-672), Vector(256,-1440,-428), 'stores', 1 }, // Central Circuit
    { 22, Vector(-720,-1472,-896), Vector(-288,-796,-696), 'stores', 1 }, // Sweet Suite Furnishings

    // Theater
    { 32, Vector(3504,3240,-896), Vector(5296,4492,-480), 'theater', 1 }, // Theater Main
    { 35, Vector(4118,4110,-896), Vector(4682,4492,-480), 'theater', 2 }, // Theater Game Room
    { 33, Vector(2852,4896,-2944), Vector(4112,5864,-2304), 'theater', 1 }, // Theater 1
    { 34, Vector(4688,4896,-2944), Vector(5952,5864,-2304), 'theater', 1 }, // Theater 2

    // Casino
    { 25, Vector(2168,-11780,-2648), Vector(3836,-9220,-2288), '', 0 }, // Casino
    { 30, Vector(3314,-1472,-3584), Vector(4982,64,-2816), '', 0 }, // Duel Arena Lobby

    // Nightclub
    { 26, Vector(1472,-5760,-2688), Vector(2880,-4304,-2240), 'nightclub', 0 }, // Pulse Nightclub
    { 27, Vector(1472,-4736,-2688), Vector(2144,-4304,-2240), 'nightclub', 1 }, // Pulse Nightclub Bar

    // Boardwalk
    { 42, Vector(-8120,-5376,-1144), Vector(-1720,4352,1032), 'boardwalk', 0 }, // Boardwalk
    { 45, Vector(-4920,-454,-1144), Vector(-3192,1408,1280), 'boardwalk', 2 }, // Beach
    { 47, Vector(-6134,-2304,-1144), Vector(-4858,2110,1280), 'boardwalk', 1 }, // Ocean
    { 43, Vector(-4858,-2496,-952), Vector(-1722,-454,1280), 'boardwalk', 1 }, // Pool
    { 48, Vector(-4858,-4864,-952), Vector(-1720,-2240,1280), 'boardwalk', 1 }, // Water Slides
    { 46, Vector(-4472,-4864,-232), Vector(-3768,-4480,136), 'boardwalk', 2 }, // Top of Water Slides
    { 44, Vector(-7178,566,-896), Vector(-6134,2110,1280), 'boardwalk', 1 }, // Ferris Wheel

    // Games
    { 28, Vector(1456,-6256,-896), Vector(7072,-3440,176), 'games', 0 }, // Games
    { 36, Vector(3984,-3968,-896), Vector(4816,-2944,-544), '', 1 }, // Games Lobby

    { 55, Vector(6656,-5712,-896), Vector(6912,-5200,-640), 'minigolf', 1 }, // Minigolf Port
    { 54, Vector(5984,-6128,-896), Vector(6496,-5872,-640), 'sourcekarts', 1 }, // Source Karts Port
    { 53, Vector(5120,-6128,-896), Vector(5632,-5872,-640), 'pvpbattle', 1 }, // PVP Battle Port
    { 52, Vector(3168,-6128,-896), Vector(3680,-5872,-640), 'ballrace', 1 }, // Ball Race Port
    { 51, Vector(2304,-6128,-896), Vector(2816,-5872,-640), 'ultimatechimerahunt', 1 }, // UCH Port
    { 50, Vector(1888,-5712,-896), Vector(2144,-5200,-640), 'virus', 1 }, // Virus Port
    { 49, Vector(1888,-4496,-896), Vector(2144,-3984,-640), 'zombiemassacre', 1 }, // Zombie Massacre Port

    // Tower
    { 15, Vector(6112,-1568,-608), Vector(9216,1568,1024), 'lobby', 1 }, // Tower Lobby
    { 14, Vector(7072,-896,-608), Vector(7872,896,-320), 'lobby', 2 }, // Tower Elevators Lobby
    { 29, Vector(-4294,-1006,14983), Vector(250,1886,15711), 'condos', 0 }, // Tower Condos Lobby

    // Elevators
    //{ 31, Vector(7864,-600,-608), Vector(8056,-407,-480), 'elevators', 3 }, // Condo Elevator
	{ 31, Vector(8166, 827, -446), Vector(7846, -825, -751), 'elevators', 4  }, //Condo Elevator
	{ 31, Vector(-1866, 864, 14783), Vector(-1624, 1753, 15160), 'elevators', 4  }, //Condo Elevator
	{ 31, Vector(7318, -768, -657), Vector(7551, -294, -449), 'elevators', 4  }, //Condo Elevator
	{ 31, Vector(7295, 334, -663), Vector(7554, 661, -468), 'elevators', 4  }, //Condo Elevator
	{ 31, Vector(-2395, 862, 14929), Vector(-2169, 1088, 15165), 'elevators', 4  }, //Condo Elevator
	{ 31, Vector(-2386, 1468, 14853), Vector(-2166, 1754, 15156), 'elevators', 4  }, //Condo Elevator

    // Misc
    { 30, Vector(-9984,-16096,2304), Vector(256,-5856,12544), '', 0 }, // Duel Arena
    { 60, Vector(2856,3048,-888), Vector(3120,3224,-616), '', 2 }, // ???

    // Condos (Unused)
    //{ 45, Vector(102,8416,14460), Vector(1581,10584,15016), 'condos', 0 }, // Condo #1
    //{ 46, Vector(102,13024,14460), Vector(1581,15192,15016), 'condos', 0 }, // Condo #2
    //{ 47, Vector(-4506,13024,14460), Vector(-3027,15192,15016), 'condos', 0 }, // Condo #3
    //{ 48, Vector(-9114,13024,14460), Vector(-7635,15192,15016), 'condos', 0 }, // Condo #4
    //{ 49, Vector(-13722,13024,14460), Vector(-12243,15192,15016), 'condos', 0 }, // Condo #5
    //{ 50, Vector(-4506,8416,14460), Vector(-3027,10584,15016), 'condos', 0 }, // Condo #6
    //{ 51, Vector(4710,13024,14460), Vector(6189,15192,15016), 'condos', 0 }, // Condo #7
    //{ 52, Vector(9318,13024,14460), Vector(10797,15192,15016), 'condos', 0 }, // Condo #8
    //{ 53, Vector(4710,8416,14460), Vector(6189,10584,15016), 'condos', 0 }, // Condo #9
    //{ 54, Vector(9318,8416,14460), Vector(10797,10584,15016), 'condos', 0 }, // Condo #10
    //{ 55, Vector(13926,13024,14460), Vector(15405,15192,15016), 'condos', 0 }, // Condo #11
    //{ 56, Vector(13926,8416,14460), Vector(15405,10584,15016), 'condos', 0 }, // Condo #12
}
ResortVectors()

GTowerLocation.Locations = {
	[1] = "Somewhere",
	[2] = "Condo #1",
	[3] = "Condo #2",
	[4] = "Condo #3",
	[5] = "Condo #4",
	[6] = "Condo #5",
	[7] = "Condo #6",
	[8] = "Condo #7",
	[9] = "Condo #8",
	[10] = "Condo #9",
	[11] = "Condo #10",
	[12] = "Condo #11",
	[13] = "Condo #12",
	[14] = "Tower Elevators Lobby",
	[15] = "Tower Lobby",
	[16] = "Center Plaza",
	[17] = "Plaza",
	[18] = "Stores",
	[19] = "Arcade Loft",
	[20] = "Tower Outfitters",
	[21] = "Toy Stop and Pets",
	[22] = "Sweet Suite Furnishings",
	[23] = "Central Circuit",
	[24] = "Casino Loft",
	[25] = "Casino",
	[26] = "Pulse Nightclub",
	[27] = "Pulse Nightclub Bar",
	[28] = "Games",
	[29] = "Tower Condos Lobby",
	[30] = "Duel Arena Lobby",
	[31] = "Condo Elevator",
	[32] = "Theater Main",
	[33] = "Theater 1",
	[34] = "Theater 2",
	[35] = "Theater Game Room",
	[36] = "Games Lobby",
	[37] = "Songbirds",
	[38] = "Transit Station",
	[39] = "Station A",
	[40] = "Station B",
	[41] = "Duel Arena",
	[42] = "Boardwalk",
	[43] = "Pool",
	[44] = "Ferris Wheel",
	[45] = "Beach",
	[46] = "Top of Water Slides",
	[47] = "Ocean",
	[48] = "Water Slides",
	[49] = "Zombie Massacre Port",
	[50] = "Virus Port",
	[51] = "UCH Port",
	[52] = "Ball Race Port",
	[53] = "PVP Battle Port",
	[54] = "Source Karts Port",
	[55] = "Minigolf Port",
	[56] = "???",
	[57] = "Tower Garden",
	[58] = "Arcade",
	[59] = "Trivia",
	[60] = "???",
	[61] = "The Hallway",
	[62] = "The Dev HQ?",
	[63] = "Gourmet Race Port",
	[64] = "Monorail",
	[65] = "Smoothie Bar",
	[66] = "Basical's Goods",
	[67] = "Beach House",
	[68] = "Back Beach",
	[69] = "Resort Pool",
	[70] = "Monorail",
	[71] = "Firework Dealer"
}

function GTowerLocation:GetGroup( locid )
	for k,v in pairs( GTowerLocation.MapPositions ) do
		if v[1] != locid then continue end
		return v[4]
	end
end

function GTowerLocation:DefaultLocation( pos )
	local Candidates = {}

	for _, v in ipairs( GTowerLocation.MapPositions ) do
		if self:InBox( pos, v[2], v[3] ) then
			table.insert(Candidates,v)
		end
	end

	if #Candidates > 1 then
		local Prio = {}
		for k,v in pairs(Candidates) do
			Prio[v[5]] = v[1]
		end
		table.SortByKey( Prio )
		return Prio[#Prio]
	else
		if Candidates[1] == nil then return 1 end
		return Candidates[1][1]
	end

	return nil
end

local NoEntsLocations = {
	[31] = true, // Condo Elevators
	[33] = true, // Theater 1
	[34] = true, // Theater 2
	[41] = true, // Duel Arena
	[44] = true, // Ferris Wheel
	[58] = true, // Arcade
	[59] = true, // Trivia
	[25] = true, // Casino
	[64] = true, // Monorail
	[70] = true, // Monorail
}

function IsNoEntsLoc(id)
	return NoEntsLocations[id] != nil
end

function IsTheater(id)
	return ( id == 34 || id == 33 )
end

function IsNightclub(id)
	return ( id == 26 || id == 27 )
end

function IsCondo(id)
	return ( id > 1 && id < 14 )
end

function IsDuelLobby(id)
	return ( id == 30 )
end

function IsDuelArena(id)
    return ( id == 41 )
end

function IsMonorail(id)
	return false
end