module("Location", package.seeall )

// Last Used ID: 85
// NOTE: NEVER, EVER, EVER CHANGE THE IDS!!

Add( 1, {
    Name = "Unknown",
} )

// TRAIN
Add( 53, {
    Name = "Train Station",
    Group = "trainstation",
    Min = Vector(1408,-4271,-323),
    Max = Vector(1867,-3040,75),
    Priority = 0,
} )
Add( 47, {
    Name = "Train Station",
    Group = "trainstation",
    Min = Vector(28,-4271,-323),
    Max = Vector(447,-3040,75),
    Priority = 0,
} )
Add( 48, {
    Name = "Train Stairs",
    Group = "trainstation",
    Min = Vector(447,-3583,-256),
    Max = Vector(1408,-2791,150),
    Priority = 0,
} )

// LOBBY
Add( 9, {
    Name = "Dev HQ",
    Group = "devhq",
    Min = Vector(-553,-1344,0),
    Max = Vector(-215,-1016,801),
    Priority = 1,
} )
Add( 2, {
    Name = "Lobby",
    Group = "lobby",
    Min = Vector(-309,-2796,-119),
    Max = Vector(1850,-736,2500),
    Priority = 0,
} )
Add( 8, {
    Name = "Lobby Teleporters",
    Group = "teleporters",
    Min = Vector(1850,-1730,0),
    Max = Vector(3090,-1213,384),
    Priority = 0,
} )
Add( 43, {
    Name = "Lobby Roof",
    Group = "lobbyroof",
    Min = Vector(-350,-3200,2500),
    Max = Vector(2050,-500,3465),
    Priority = 0,
} )

// THEATER
Add( 41, {
    Name = "Theater",
    Group = "theater",
    Min = Vector(-2100,-800,-2),
    Max = Vector(-410,355,1000),
    Priority = 0,
} )
Add( 42, {
    Name = "Theater Hallway",
    Group = "theaterhallway",
    Min = Vector(-831,-1600,0),
    Max = Vector(-300,-800,310),
    Priority = 0,
} )
Add( 46, {
    Name = "Theater Vents",
    Group = "vents",
    Min = Vector(-773,-772,265),
    Max = Vector(-261,-400,2614),
    Priority = 1,
} )
Add( 50, {
    Name = "Moon",
    Group = "moon",
    Min = Vector(-11721,-11841,3200),
    Max = Vector(-6714,-6735,5800),
    Priority = 0,
} )

// EPLAZA
Add( 3, {
    Name = "Entertainment Plaza",
    Group = "eplaza",
    Min = Vector(-17,-736,-35),
    Max = Vector(1864,2050,506),
    Priority = 0,
} )
Add( 59, {
    Name = "Food Court",
    Group = "eplaza",
    Min = Vector(-17,112,181),
    Max = Vector(1864,2780,506),
    Priority = 0,
} )
// STORES
Add( 31, {
    Name = "Appearance Store",
    Group = "stores",
    Min = Vector(1600,256,-24),
    Max = Vector(1960,895,175),
    Priority = 1,
} )
Add( 32, {
    Name = "Furniture Store",
    Group = "stores",
    Min = Vector(-710,256,-25),
    Max = Vector(256,895,190),
    Priority = 0,
} )
Add( 44, {
    Name = "Electronic Store",
    Group = "stores",
    Min = Vector(-768,1295,192),
    Max = Vector(-12,1935,390),
    Priority = 0,
} )
Add( 45, {
    Name = "General Goods",
    Group = "stores",
    Min = Vector(1863,1392,192),
    Max = Vector(2431,1807,390),
    Priority = 0,
} )

// BAR
Add( 39, {
    Name = "Bar",
    Group = "bar",
    Min = Vector(2472,2050,-24),
    Max = Vector(3436,2936,506),
    Priority = 0,
} )
Add( 40, {
    Name = "Bar Restrooms",
    Group = "bar",
    Min = Vector(2630,2936,-24),
    Max = Vector(3328,3456,506),
    Priority = 0,
} )
// BAR
Add( 49, {
    Name = "Bar Stairs",
    Group = "nil",
    Min = Vector(1864,2050,-24),
    Max = Vector(2472,2500,506),
    Priority = 0,
} )
// ACTIVITIES
Add( 10, {
    Name = "Casino",
    Group = "casino",
    Min = Vector(1864,112,168),
    Max = Vector(3300,1280,390),
    Priority = 0,
} )
Add( 7, {
    Name = "Restaurant",
    Group = "stores",
    Min = Vector(-580,128,190),
    Max = Vector(-12,1060,390),
    Priority = 0,
} )

// ARCADE
Add( 38, {
    Name = "Arcade",
    Group = "arcade",
    Min = Vector(-2196,1508,-679),
    Max = Vector(-796,3051,506),
    Priority = 0,
} )
Add( 58, {
    Name = "Arcade Stairs",
    Group = "nil",
    Min = Vector(-796,2012,-37),
    Max = Vector(-17,2495,506),
    Priority = 0,
} )

// GAMEMODES
Add( 34, {
    Name = "Gamemode Teleporters",
    Group = "teleporters",
    Min = Vector(11039,10386,6650),
    Max = Vector(12128,10879,7040),
    Priority = 0,
} )
Add( 35, {
    Name = "Gamemode Ports",
    Group = "gamemodeports",
    Min = Vector(9840,10240,6650),
    Max = Vector(11040,11007,7150),
    Priority = 0,
} )
Add( 36, {
    Name = "West GM Ports",
    Group = "gamemodeports",
    Min = Vector(9982,8897,6402),
    Max = Vector(11041,10289,7150),
    Priority = 0,
} )
Add( 37, {
    Name = "East GM Ports",
    Group = "gamemodeports",
    Min = Vector(9982,10976,6430),
    Max = Vector(11041,12353,7150),
    Priority = 0,
} )

Add( 74, {
    Name = "Minigolf Port",
    Group = "minigolf",
    Min = Vector(9931.9814453125,8467.90234375,6589.7465820313),
    Max = Vector(10512.805664063,8900.7275390625,7096.779296875),
    Priority = 0,
} )
Add( 75, {
    Name = "Source Karts Port",
    Group = "sourcekarts",
    Min = Vector(9623.6328125,9024.7763671875,6607.9560546875),
    Max = Vector(9982.1513671875,9557.3271484375,7164.083984375),
    Priority = 0,
} )
Add( 76, {
    Name = "PVP Battle Port",
    Group = "pvpbattle",
    Min = Vector(9634.4140625,9561.3955078125,6553.9287109375),
    Max = Vector(9982.51171875,10105.034179688,7102.1235351563),
    Priority = 0,
} )
Add( 77, {
    Name = "Ballrace Port",
    Group = "ballrace",
    Min = Vector(9572.68359375,11151.2265625,6619.0463867188),
    Max = Vector(9983.404296875,11678.227539063,7109.98046875),
    Priority = 0,
} )
Add( 78, {
    Name = "UCH Port",
    Group = "ultimatechimerahunt",
    Min = Vector(9470.08203125,11691.755859375,6618.224609375),
    Max = Vector(9982.2880859375,12297.280273438,7107.5786132813),
    Priority = 0,
} )
Add( 81, {
    Name = "ZM Port",
    Group = "zombiemassacre",
    Min = Vector(11040.50390625,11676.5078125,6545.6381835938),
    Max = Vector(11327.876953125,12217.260742188,7181.6801757813),
    Priority = 0,
} )
Add( 82, {
    Name = "Virus Port",
    Group = "virus",
    Min = Vector(11046.93359375,11080.302734375,6587.1118164063),
    Max = Vector(11429.869140625,11680.42578125,7076.87109375),
    Priority = 0,
} )

Add( 79, {
    Name = "Gourmet Race Port",
    Group = "gamemodeports",
    Min = Vector(9975.6005859375,12352.126953125,6571.5756835938),
    Max = Vector(10511.842773438,12677.255859375,7167.9428710938),
    Priority = 0,
} )
Add( 80, {
    Name = "Conquest Port",
    Group = "gamemodeports",
    Min = Vector(10523.416992188,12350.396484375,6521.6538085938),
    Max = Vector(11072.001953125,12686.518554688,7272.1904296875),
    Priority = 0,
} )
Add( 83, {
    Name = "GMT Adventure Port",
    Group = "gamemodeports",
    Min = Vector(11043.552734375,9567.859375,6626.40234375),
    Max = Vector(11373.348632813,10102.0390625,7082.5805664063),
    Priority = 0,
} )
Add( 84, {
    Name = "Monotone Port",
    Group = "gamemodeports",
    Min = Vector(11044.09765625,8991.5576171875,6532.794921875),
    Max = Vector(11470.217773438,9570.4599609375,7147.7016601563),
    Priority = 0,
} )
Add( 85, {
    Name = "Construction Port",
    Group = "gamemodeports",
    Min = Vector(10517.46875,8567.005859375,6573.2607421875),
    Max = Vector(11049.779296875,8895.7119140625,7163.955078125),
    Priority = 0,
} )

// MISC
Add( 51, {
    Name = "Narnia",
    Group = "narnia",
    Min = Vector(-10000,-13483,-512),
    Max = Vector(-3008,-6100,2224),
    Priority = 0,
} )
Add( 55, {
    Name = "Lakeside Cabin",
    Group = "lakeside",
    Min = Vector(-11025,9152,-129),
    Max = Vector(-9800,10250,742),
    Priority = 0,
} )
Add( 56, {
    Name = "Pool",
    Group = "pool",
    Min = Vector(-9267,8860,-330),
    Max = Vector(-5952,11860,742),
    Priority = 0,
} )
Add( 57, {
    Name = "Lakeside",
    Group = "lakeside",
    Min = Vector(-12258,9145,-300),
    Max = Vector(-9267,11860,742),
    Priority = 0,
} )

// HALLOWEEN
/*Add( 52, {
    Name = "Haunted Mansion",
    Group = nil,
    Min = Vector( -11608, 3069, -256 ),
    Max = Vector( -6491, 11817, 1227 ),
    Priority = 0,
} )
Add( 54, {
    Name = "Super Secret",
    Group = nil,
    Min = Vector( 556, -2830, 2568 ),
    Max = Vector( 823, -2561, 2701 ),
    Priority = 0,
} )
Add( 54, {
    Name = "Hidden Cave",
    Group = nil,
    Min = Vector( -680, -3536, 1364 ),
    Max = Vector( 128, -3194, 2748 ),
    Priority = 0,
} )*/

// SUITES
Add( 4, {
    Name = "Suites",
    Group = "suites",
    Min = Vector(4048,-10600,4096),
    Max = Vector(5440,-9792,4480),
    IsSuite = true,
    SuiteID = 0,
    Priority = 0,
} )
Add( 5, {
    Name = "Suites 1 - 9",
    Group = "suites",
    Min = Vector(4356,-12508,4096),
    Max = Vector(4736,-10600,4334),
    IsSuite = true,
    SuiteID = 0,
    Priority = 0,
} )
Add( 60, {
    Name = "Suites 10 - 15",
    Group = "suites",
    Min = Vector(1800,-10370,4096),
    Max = Vector(4048,-9985,4334),
    IsSuite = true,
    SuiteID = 0,
    Priority = 0,
} )
Add( 6, {
    Name = "Suites 16 - 24",
    Group = "suites",
    Min = Vector(4356,-9792,4096),
    Max = Vector(4736,-7855,4334),
    IsSuite = true,
    SuiteID = 0,
    Priority = 0,
} )

Add( 33, {
    Name = "Suite Teleporters",
    Group = "teleporters",
    Min = Vector(5440,-10432,4090),
    Max = Vector(6160,-9920,4480),
    IsSuite = true,
    SuiteID = 0,
    Priority = 0,
} )
Add( 61, {
    Name = "Suite Furniture Store",
    Group = "suites",
    Min = Vector(3360,-10816,4084),
    Max = Vector(4048,-10370,4328),
    IsSuite = true,
    SuiteID = 0,
    Priority = 0,
} )
Add( 62, {
    Name = "Suite Building Store",
    Group = "suites",
    Min = Vector(3360,-9985,4084),
    Max = Vector(4048,-9525,4328),
    IsSuite = true,
    SuiteID = 0,
    Priority = 0,
} )

// Unused
/*Add( 49, {
    Name = "Party Suite",
    Group = "suites",
    Min = Vector( 2580, -10384, 4008 ),
    Max = Vector( 3564, -9489, 4483 ),
    IsSuite = true,
    SuiteID = 0,
    Priority = 0,
} )*/

Add( 11, {
    Name = "Suite #1",
    Group = "suite",
    Min = Vector(4733,-11208,4085),
    Max = Vector(6048,-10840,4374),
    IsSuite = true,
    SuiteID = 1,
    Priority = 0,
} )
Add( 12, {
    Name = "Suite #2",
    Group = "suite",
    Min = Vector(4734,-11592,4085),
    Max = Vector(6049,-11224,4374),
    IsSuite = true,
    SuiteID = 2,
    Priority = 0,
} )
Add( 13, {
    Name = "Suite #3",
    Group = "suite",
    Min = Vector(4734,-11976,4085),
    Max = Vector(6049,-11608,4374),
    IsSuite = true,
    SuiteID = 3,
    Priority = 0,
} )
Add( 14, {
    Name = "Suite #4",
    Group = "suite",
    Min = Vector(4734,-12360,4085),
    Max = Vector(6049,-11992,4374),
    IsSuite = true,
    SuiteID = 4,
    Priority = 0,
} )
Add( 15, {
    Name = "Suite #5",
    Group = "suite",
    Min = Vector(4416,-13824,4085),
    Max = Vector(4784,-12509,4374),
    IsSuite = true,
    SuiteID = 5,
    Priority = 0,
} )
Add( 16, {
    Name = "Suite #6",
    Group = "suite",
    Min = Vector(3039,-12360,4085),
    Max = Vector(4354,-11992,4374),
    IsSuite = true,
    SuiteID = 6,
    Priority = 0,
} )
Add( 17, {
    Name = "Suite #7",
    Group = "suite",
    Min = Vector(3039,-11976,4085),
    Max = Vector(4354,-11608,4374),
    IsSuite = true,
    SuiteID = 7,
    Priority = 0,
} )
Add( 18, {
    Name = "Suite #8",
    Group = "suite",
    Min = Vector(3039,-11592,4085),
    Max = Vector(4354,-11224,4374),
    IsSuite = true,
    SuiteID = 8,
    Priority = 0,
} )
Add( 19, {
    Name = "Suite #9",
    Group = "suite",
    Min = Vector(3039,-11208,4085),
    Max = Vector(4354,-10840,4374),
    IsSuite = true,
    SuiteID = 9,
    Priority = 0,
} )
Add( 20, {
    Name = "Suite #10",
    Group = "suite",
    Min = Vector(2624,-11681,4085),
    Max = Vector(2992,-10366,4374),
    IsSuite = true,
    SuiteID = 10,
    Priority = 0,
} )
Add( 21, {
    Name = "Suite #11",
    Group = "suite",
    Min = Vector(2240,-11681,4085),
    Max = Vector(2608,-10366,4374),
    IsSuite = true,
    SuiteID = 11,
    Priority = 0,
} )
Add( 22, {
    Name = "Suite #12",
    Group = "suite",
    Min = Vector(1856,-11681,4085),
    Max = Vector(2224,-10366,4374),
    IsSuite = true,
    SuiteID = 12,
    Priority = 0,
} )
Add( 23, {
    Name = "Suite #13",
    Group = "suite",
    Min = Vector(1792,-9986,4085),
    Max = Vector(2160,-8671,4374),
    IsSuite = true,
    SuiteID = 13,
    Priority = 0,
} )
Add( 24, {
    Name = "Suite #14",
    Group = "suite",
    Min = Vector(2176,-9986,4085),
    Max = Vector(2544,-8671,4374),
    IsSuite = true,
    SuiteID = 14,
    Priority = 0,
} )
Add( 25, {
    Name = "Suite #15",
    Group = "suite",
    Min = Vector(2560,-9986,4085),
    Max = Vector(2928,-8671,4374),
    IsSuite = true,
    SuiteID = 15,
    Priority = 0,
} )
Add( 26, {
    Name = "Suite #16",
    Group = "suite",
    Min = Vector(3040,-9512,4085),
    Max = Vector(4355,-9144,4374),
    IsSuite = true,
    SuiteID = 16,
    Priority = 0,
} )
Add( 27, {
    Name = "Suite #17",
    Group = "suite",
    Min = Vector(3040,-9128,4085),
    Max = Vector(4355,-8760,4374),
    IsSuite = true,
    SuiteID = 17,
    Priority = 0,
} )
Add( 28, {
    Name = "Suite #18",
    Group = "suite",
    Min = Vector(3040,-8744,4085),
    Max = Vector(4355,-8376,4374),
    IsSuite = true,
    SuiteID = 18,
    Priority = 0,
} )
Add( 29, {
    Name = "Suite #19",
    Group = "suite",
    Min = Vector(3040,-8360,4085),
    Max = Vector(4355,-7992,4374),
    IsSuite = true,
    SuiteID = 19,
    Priority = 0,
} )
Add( 30, {
    Name = "Suite #20",
    Group = "suite",
    Min = Vector(4304,-7855,4085),
    Max = Vector(4672,-6540,4374),
    IsSuite = true,
    SuiteID = 20,
    Priority = 0,
} )
Add( 63, {
    Name = "Suite #21",
    Group = "suite",
    Min = Vector(4732,-8360,4085),
    Max = Vector(6047,-7992,4374),
    IsSuite = true,
    SuiteID = 21,
    Priority = 0,
} )
Add( 64, {
    Name = "Suite #22",
    Group = "suite",
    Min = Vector(4732,-8744,4085),
    Max = Vector(6047,-8376,4374),
    IsSuite = true,
    SuiteID = 22,
    Priority = 0,
} )
Add( 65, {
    Name = "Suite #23",
    Group = "suite",
    Min = Vector(4732,-9128,4085),
    Max = Vector(6047,-8760,4374),
    IsSuite = true,
    SuiteID = 23,
    Priority = 0,
} )
Add( 66, {
    Name = "Suite #24",
    Group = "suite",
    Min = Vector(4732,-9512,4085),
    Max = Vector(6047,-9144,4374),
    IsSuite = true,
    SuiteID = 24,
    Priority = 0,
} )

ResortVectors()

SUITETELEPORTERS = 33

TeleportLocations = TeleportLocations or {
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