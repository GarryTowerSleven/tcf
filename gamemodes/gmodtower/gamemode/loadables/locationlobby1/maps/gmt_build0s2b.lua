module("Location", package.seeall )

// Last Used ID: 67

// NOTE: NEVER, EVER, EVER CHANGE THE IDS!!
// ORDER ADDED DOESN'T MATTER, THOUGH, SO ORGANIZE IT SO WE CAN READ THE LOCATIONS FFS

Add( 1, "Unknown" )

// TRAIN
Add( 53, "Train Station", "trainstation", Vector( 1408, -4271, -323 ), Vector( 1867, -3040, 1 ) )
Add( 47, "Train Station", "trainstation", Vector( 447, -4271, -323 ), Vector( 28, -3040, 1 ) )
Add( 48, "Train Stairs", "trainstation", Vector( 1408, -2791, -256 ), Vector( 447, -3583, 150 ) )

// LOBBY
Add( 9, "Dev HQ", "devhq",  Vector( -553, -1324, 0 ), Vector( -215, -1016, 801 ) )
Add( 2, "Lobby", "lobby", Vector( -309, -2796, -119 ), Vector( 1850, -736, 2551 ) )
Add( 8, "Lobby Teleporters", "teleporters", Vector( 1850, -1213, 0 ), Vector( 3090, -1730, 384 ) )
Add( 43, "Lobby Roof", "lobbyroof", Vector( 2050, -3200, 2500 ), Vector( -350,  -500, 3460) )


// THEATER
Add( 41, "Theater", "theater", Vector( -2100, 355, -2 ), Vector( -410, -800, 1000 ) )
Add( 42, "Theater Hallway", "theaterhallway", Vector( -300, -1600, 0 ), Vector( -831, -800, 191 ) )
Add( 46, "Theater Vents", "vents", Vector( -773, -400, 265 ), Vector( -261, -772, 2598 ) )
Add( 50, "Moon", "moon", Vector( -6714, -11841,  3200 ), Vector( -11721, -6735, 5800 ) )

// EPLAZA
Add( 3, "Entertainment Plaza", "eplaza", Vector( 238, -736, -35 ), Vector( 1600, 2050, 506 )  )
Add( 59, "Food Court", "eplaza", Vector( -17, 112, 181 ), Vector( 1864, 2780, 506 ) )

// STORES
Add( 31, "Appearance Store", "stores", Vector( 1960, 895, -24 ), Vector( 1600, 256, 168) )
Add( 32, "Furniture Store", "stores", Vector( -710, 895, 190 ), Vector( 256,  256, -25) )
Add( 44, "Electronic Store", "stores", Vector( -12, 1295, 383 ), Vector( -768, 1935, 192 ) )
Add( 45, "General Goods", "stores", Vector( 1863, 1807, 383 ), Vector( 2431, 1392, 192 ) )

// BAR
Add( 39, "Bar", "bar", Vector( 1864, 2050, -24 ), Vector( 3436, 2935, 506 ) )
Add( 40, "Bar Restrooms", "bar", Vector( 2688, 3456, -24 ), Vector( 3328, 2935, 506 ) )

// ACTIVITIES
Add( 10, "Casino", "casino", Vector( 1864, 1280, 168 ), Vector( 3300, 112, 381 ) )
Add( 7, "Restaurant", "stores", Vector( -580, 128, 190 ), Vector( -12, 1060, 381 ) )

// ARCADE
Add( 38, "Arcade", "arcade", Vector( -2196, 1508, -679 ), Vector( -796, 3051, 506 ) )
Add( 58, "Arcade Stairs", nil, Vector( -796, 2012, -37 ), Vector( -17, 2495, 506 ) )

// GAMEMODES
Add( 34, "Gamemode Teleporters", "teleporters", Vector( 12128, 10386, 6650 ), Vector( 11039, 10879, 7040 ) )
Add( 35, "Gamemode Ports", "gamemodeports", Vector( 9840, 11007, 6650 ), Vector( 11040, 10240, 7103 ) )
Add( 36, "West GM Ports", "gamemodeports", Vector( 9982, 8897, 6402 ), Vector( 11041, 10289, 7679 ) )
Add( 37, "East GM Ports", "gamemodeports", Vector( 9982, 10976, 6430 ), Vector( 11041, 12353, 7294 ) )

Add( 74, "Minigolf Port", "minigolf", Vector( 10512.805664, 8900.727539, 6589.746582 ), Vector(9931.981445, 8467.902344, 7096.779297) )
Add( 75, "Source Karts Port", "sourcekarts", Vector( 9982.151367, 9024.776367, 7164.083984 ), Vector(9623.632813, 9557.327148, 6607.956055) )
Add( 76, "PVP Battle Port", "pvpbattle", Vector( 9982.511719, 9561.395508, 7102.123535 ), Vector(9634.414063, 10105.034180, 6553.928711) )
Add( 77, "Ballrace Port", "ballrace", Vector( 9983.404297, 11151.226563, 7109.980469 ), Vector(9572.683594, 11678.227539, 6619.046387) )
Add( 78, "UCH Port", "ultimatechimerahunt", Vector( 9470.082031, 12297.280273, 7107.578613 ), Vector(9982.288086, 11691.755859, 6618.224609) )
Add( 81, "ZM Port", "zombiemassacre", Vector( 11040.503906, 12217.260742, 7181.680176 ), Vector(11327.876953, 11676.507813, 6545.638184) )
Add( 82, "Virus Port", "virus", Vector( 11046.933594, 11680.425781, 6587.111816 ), Vector(11429.869141, 11080.302734, 7076.871094) )

Add( 79, "Gourmet Race Port", "gamemodeports", Vector( 9975.600586, 12352.126953, 6571.575684 ), Vector(10511.842773, 12677.255859, 7167.942871) )
Add( 80, "Conquest Port", "gamemodeports", Vector( 10523.416992, 12350.396484, 7272.190430 ), Vector(11072.001953, 12686.518555, 6521.653809) )
Add( 83, "GMT Adventure Port", "gamemodeports", Vector( 11043.552734, 10102.039063, 7082.580566 ), Vector(11373.348633, 9567.859375, 6626.402344) )
Add( 84, "Monotone Port", "gamemodeports", Vector( 11470.217773, 8991.557617, 6532.794922 ), Vector(11044.097656, 9570.459961, 7147.701660) )
Add( 85, "Construction Port", "gamemodeports", Vector( 11049.779297, 8895.711914, 7163.955078 ), Vector(10517.468750, 8567.005859, 6573.260742) )

// MISC
Add( 51, "Narnia", "narnia", Vector( -3008, -6100, -512 ), Vector( -10000, -13483 , 2224 ) )
Add( 56, "Pool", "pool", Vector( -9267, 4958, -550 ), Vector( -1130, 15381, 3693 )  )
Add( 57, "Lakeside", "lakeside", Vector( -15419, 4958, -550 ), Vector( -9267, 15381, 3693 ) )

//Add( 52, "Haunted Mansion", Vector( -11608, 3069, -256 ), Vector( -6491, 11817, 1227 ) )
//Add( 54, "Super Secret", Vector( 556, -2830, 2568 ), Vector( 823, -2561, 2701 ) )
//Add( 55, "Hidden Cave", Vector( -680, -3536, 1364 ), Vector( 128, -3194, 2748 ) )

// SUITES
Add( 4, "Suites", "suites", Vector( 5440, -10600, 4096 ), Vector( 4048, -9792, 4480 ), true )
Add( 5, "Suites 1 - 9", "suites", Vector( 4736, -10600, 4096 ), Vector( 4356, -12508, 4332 ), true )
Add( 60, "Suites 10 - 15", "suites", Vector( 1800, -10370, 4096 ), Vector( 4048, -9985, 4332 ), true )
Add( 6, "Suites 16 - 24", "suites", Vector( 4736, -9792, 4096 ), Vector( 4356, -7855, 4332 ), true )
Add( 33, "Suite Teleporters", "teleporters", Vector( 5440, -10432, 4090 ), Vector( 6160, -9920, 4480 ), true )
Add( 61, "Suite Furniture Store", "suites", Vector( 3360, -10816, 4084 ), Vector( 4048, -10370, 4328 ), true )
Add( 62, "Suite Building Store", "suites", Vector( 3360, -9985, 4084 ), Vector( 4048, -9525, 4328 ), true )
//Add( 49, "Abandoned Site", Vector( 2580, -10384, 4008 ), Vector( 3564, -9489, 4483 ) , true )
Add( 11, "Suite #1", "suite", Vector( 4733, -11208, 4085 ), Vector( 6048, -10840, 4372 ), true, 1 )
Add( 12, "Suite #2", "suite", Vector( 4734, -11592, 4085 ), Vector( 6049, -11224, 4372 ), true, 2 )
Add( 13, "Suite #3", "suite", Vector( 4734, -11976, 4085 ), Vector( 6049, -11608, 4372 ), true, 3 )
Add( 14, "Suite #4", "suite", Vector( 4734, -12360, 4085 ), Vector( 6049, -11992, 4372 ), true, 4 )
Add( 15, "Suite #5", "suite", Vector( 4416, -13824, 4085 ), Vector( 4784, -12509, 4372 ), true, 5 )
Add( 16, "Suite #6", "suite", Vector( 3039, -12360, 4085 ), Vector( 4354, -11992, 4372 ), true, 6 )
Add( 17, "Suite #7", "suite", Vector( 3039, -11976, 4085 ), Vector( 4354, -11608, 4372 ), true, 7 )
Add( 18, "Suite #8", "suite", Vector( 3039, -11592, 4085 ), Vector( 4354, -11224, 4372 ), true, 8 )
Add( 19, "Suite #9", "suite", Vector( 3039, -11208, 4085 ), Vector( 4354, -10840, 4372 ), true, 9 )
Add( 20, "Suite #10", "suite", Vector( 2624, -11681, 4085 ), Vector( 2992, -10366, 4372 ), true, 10 )
Add( 21, "Suite #11", "suite", Vector( 2240, -11681, 4085 ), Vector( 2608, -10366, 4372 ), true, 11 )
Add( 22, "Suite #12", "suite", Vector( 1856, -11681, 4085 ), Vector( 2224, -10366, 4372 ), true, 12 )
Add( 23, "Suite #13", "suite", Vector( 1792, -9986, 4085 ), Vector( 2160, -8671, 4372 ), true, 13 )
Add( 24, "Suite #14", "suite", Vector( 2176, -9986, 4085 ), Vector( 2544, -8671, 4372 ), true, 14 )
Add( 25, "Suite #15", "suite", Vector( 2560, -9986, 4085 ), Vector( 2928, -8671, 4372 ), true, 15 )
Add( 26, "Suite #16", "suite", Vector( 3040, -9512, 4085 ), Vector( 4355, -9144, 4372 ), true, 16 )
Add( 27, "Suite #17", "suite", Vector( 3040, -9128, 4085 ), Vector( 4355, -8760, 4372 ), true, 17 )
Add( 28, "Suite #18", "suite", Vector( 3040, -8744, 4085 ), Vector( 4355, -8376, 4372 ), true, 18 )
Add( 29, "Suite #19", "suite", Vector( 3040, -8360, 4085 ), Vector( 4355, -7992, 4372 ), true, 19 )
Add( 30, "Suite #20", "suite", Vector( 4304, -7855, 4085 ), Vector( 4672, -6540, 4372 ), true, 20 )
Add( 63, "Suite #21", "suite", Vector( 4732, -8360, 4085 ), Vector( 6047, -7992, 4372 ), true, 21 )
Add( 64, "Suite #22", "suite", Vector( 4732, -8744, 4085 ), Vector( 6047, -8376, 4372 ), true, 22 )
Add( 65, "Suite #23", "suite", Vector( 4732, -9128, 4085 ), Vector( 6047, -8760, 4372 ), true, 23 )
Add( 66, "Suite #24", "suite", Vector( 4732, -9512, 4085 ), Vector( 6047, -9144, 4372 ), true, 24 )

ResortVectors()

SUITETELEPORTERS = 33

TeleportLocations = {
	[8] = { 
		["name"] = "Lobby", 
		["desc"] = "A place to play and chat.",
		["ents"] = {},
		["failpos"] = Vector(2721.0, -1482.1, 304.4)
	},
	[33] = { 
		["name"] = "Suites", 
		["desc"] = "Relax and store items.",
		["ents"] = {},
		["failpos"] = Vector(11837.0, 10615.3, 6910.0)
	},
	[34] = { 
		["name"] = "Gamemodes", 
		["desc"] = "Join the gamemode servers.",
		["ents"] = {},
		["failpos"] = Vector(11848, 10628, 6948 )
	}
}

/*if GTowerSrvID.IsMainServer() then

	TeleportLocations[34] = { 
		["name"] = "Gamemodes", 
		["desc"] = "Join the gamemode servers.",
		["ents"] = {},
		["failpos"] = Vector(11848, 10628, 6948 )
	}

end*/

AddKeyValue( 41, "Theater", {
	Name = "Theater 1",
	Flags = THEATER_REPLICATED,
	Pos = Vector(-1843,-587,476),
	Ang = Angle(0,90,0),
	Width = 800,
	Height = 360,
	-- ThumbInfo = {
	-- 	Pos = Vector(1288, 994.5, 70),
	-- 	Ang = Angle(0, -90, 0)
	-- }
} )