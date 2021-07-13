//lua_run_cl Msg( LocalPlayer():GetEyeTrace().HitPos )

module("Location", package.seeall )

GTowerLocation.MapPositions = {
	{ 32, Vector(3504,3240,-896), Vector(5296,4492,-480), 'theater', 1  }, //Theater Main
	{ 28, Vector(1456.0200195313,-6256,-996), Vector(7072.009765625,-3440,176), 'games', 0  }, //Games
	{ 24, Vector(1784,-3000,-864.00006103516), Vector(2856,-1960,-576), '', 1  }, //Casino Loft
	{ 20, Vector(-472,1440,-672), Vector(240,2240,-372), 'stores', 1  }, //Tower Outfitters
	{ 41, Vector(-9984,-16096,2304), Vector(256,-5856,12544), 'duels', 0  }, //Duel Arena
	{ 33, Vector(2852,4896,-2944), Vector(4112,5864,-2304), 'theater', 1  }, //Theater 1
	{ 56, Vector(2856,3048,-188), Vector(3120,3224,-1000), '', 2  }, //???
	{ 29, Vector(-4294,-1006,14883), Vector(250,1886,15711), 'condos', 0  }, //Tower Condos Lobby
	{ 53, Vector(5120,-6128,-896), Vector(5632,-5872,-640), 'pvpbattle', 1  }, //PVP Battle Port
	{ 50, Vector(1888,-5712,-896), Vector(2144,-5200,-640), 'virus', 1  }, //Virus Port
	{ 25, Vector(2168,-11780,-2648), Vector(3835.9899902344,-9220,-2288), '', 0  }, //Casino
	{ 34, Vector(4688,4896,-2944), Vector(5952,5864,-2304), 'theater', 1  }, //Theater 2
	{ 55, Vector(6656,-5712,-896), Vector(6912,-5200,-640), 'minigolf', 1  }, //Minigolf Port
	{ 21, Vector(288,1440,-672), Vector(1032,2296,-372), 'stores', 1  }, //Toy Stop and Pets
	{ 52, Vector(3168.1899414063,-6128.2202148438,-896), Vector(3680.1899414063,-5872.2202148438,-640), 'ballrace', 1  }, //Ball Race Port
	{ 47, Vector(-6134,-2304,-1144), Vector(-4858,2110,1280), 'boardwalk', 2  }, //Ocean
	{ 17, Vector(1024,-3328,-1024), Vector(6136,3240,1636), 'plaza', 0  }, //Plaza
	{ 22, Vector( -2038.3122558594, -1430.8845214844, -1000.1024780273 ), Vector( -716.17419433594, -556.38677978516, -264.75384521484 ), 'stores', 1  }, //Sweet Suite Furnishings
	{ 39, Vector(5424,704,-1328), Vector(8832,1256,-1024), 'transit', 0  }, //Station A
	{ 15, Vector(6112,-1568,-608), Vector(9216,1568,1024), 'lobby', 1  }, //Tower Lobby
	{ 54, Vector(5984,-6128,-896), Vector(6496,-5872,-640), 'sourcekarts', 1  }, //Source Karts Port
	{ 49, Vector(1888,-4496,-896), Vector(2144,-3984,-640), 'zombiemassacre', 1  }, //Zombie Massacre Port
	{ 46, Vector(-4472,-4864,-232), Vector(-3768,-4480,136), 'boardwalk', 4  }, //Top of Water Slides
	{ 48, Vector(-4858,-4864,-952), Vector(-1720,-2240,1280), 'boardwalk', 2  }, //Water Slides
	{ 38, Vector(5720,-704.00006103516,-1328), Vector(7512.0004882813,704,-640), 'transit', 1  }, //Transit Station
	{ 36, Vector(3984,-3968,-896), Vector(4816,-2944,-544), '', 1  }, //Games Lobby
	{ 45, Vector(-4920,-454,-1144), Vector(-3192,1408,1280), 'boardwalk', 2  }, //Beach
	{ 44, Vector(-7178,566,-896), Vector(-6134,2110.3334960938,1280), 'boardwalk', 2  }, //Ferris Wheel
	{ 18, Vector(-1856,-1448,-966.10906982422), Vector(1023.9899902344,1440,1636), 'stores', 0  }, //Stores
	{ 42, Vector(-8120,-5375.9794921875,-1144), Vector(-1720,4351.9599609375,1032), 'boardwalk', 1  }, //Boardwalk
	{ 40, Vector(5424,-1256,-1328), Vector(8832,-704,-1024), 'transit', 0  }, //Station B
	{ 37, Vector(288,-2208,-671.97998046875), Vector(1024,-1440,-428.00302124023), 'stores', 1  }, //Songbirds
	{ 35, Vector(4118,4110,-896), Vector(4682,4492,-480), 'theaterarcade', 2  }, //Theater Game Room
	{ 31, Vector(8166, 827, -446), Vector(7846, -825, -751), 'elevators', 4  }, //Condo Elevator
	{ 31, Vector(-1866, 864, 14783), Vector(-1624, 1753, 15160), 'elevators', 4  }, //Condo Elevator
	{ 31, Vector(7318, -768, -657), Vector(7551, -294, -449), 'elevators', 4  }, //Condo Elevator
	{ 31, Vector(7295, 334, -663), Vector(7554, 661, -468), 'elevators', 4  }, //Condo Elevator
	{ 31, Vector(-2395, 862, 14929), Vector(-2169, 1088, 15165), 'elevators', 4  }, //Condo Elevator
	{ 31, Vector(-2386, 1468, 14853), Vector(-2166, 1754, 15156), 'elevators', 4  }, //Condo Elevator
	{ 30, Vector(3313.759765625,-1472,-3584), Vector(4981.759765625,64,-2816), 'duelarena', 0  }, //Duel Arena Lobby
	{ 27, Vector(1472,-4736,-2688), Vector(2144,-4304,-2240), 'nightclub', 1  }, //Pulse Nightclub Bar
	{ 23, Vector(-672,-2208,-672), Vector(256,-1440,-428.02304077148), 'stores', 1  }, //Central Circuit
	{ 26, Vector(1472,-5760,-2688), Vector(2880,-4304,-2240), 'nightclub', 0  }, //Pulse Nightclub
	{ 51, Vector(2304,-6128,-896), Vector(2816,-5872,-640), 'ultimatechimerahunt', 1  }, //UCH Port
	{ 19, Vector(1640, 1960, -921), Vector(2855, 3243, -408), 'plaza', 2  }, //Arcade Loft
	{ 43, Vector(-4858,-2496,-952), Vector(-1722,-454,1280), 'boardwalk', 1  }, //Pool
	{ 16, Vector(1920,-768,-992), Vector(3455.9899902344,768,-556), 'plaza', 1  }, //Center Plaza
	{ 14, Vector(7072,-896,-608), Vector(7872,896,-320), 'lobby', 2  }, //Tower Elevators Lobby
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