Ambiance = Ambiance or {}

module( "Ambiance", package.seeall )

Ambiance.Music = {
	// Stores
	[0] = { "GModTower/music/store.mp3", timetoint( 2, 53 ) },

	// Lobby
	[2] = {
			{ "GModTower/music/lobby1.mp3", timetoint( 3, 40 ) },
			{ "GModTower/music/lobby2.mp3", timetoint( 4, 54 ) },
			{ "GModTower/music/lobby3.mp3", timetoint( 4, 00 ) },
	},

	// EPlaza
	[3] = { "GModTower/music/plaza.mp3", timetoint( 3, 41 ) },

	// Theater hallway
	[42] = { "GModTower/music/theater.mp3", timetoint( 10, 35 ) },

	// Suites
	[4] = {
		{ "GModTower/music/suite1.mp3", timetoint( 4, 41 ) },
		{ "GModTower/music/suite2.mp3", timetoint( 3, 16 ) },
	},

	// Arcade
	[38] = { "GModTower/music/arcade.mp3", timetoint( 3, 56 ) },

	// Lobby roof
	[43] = { "GModTower/music/lobbyroof.mp3", timetoint( 1, 34 ) },

	// Lake
	[57] = { 
		{ "GModTower/music/lakeside.mp3", timetoint( 2, 19 ) },
		{ "GModTower/music/lakeside2.mp3", timetoint( 3, 34 ) },
	},

	// Pool
	[56] = { 
		{ "GModTower/music/pool1.mp3", timetoint( 3, 16 ) },
		{ "GModTower/music/pool2.mp3", timetoint( 3, 28 ) },
	},

	// Gamemodes (manually override for 36 and 37)
	[35] = { 
		{ "GModTower/music/gamemodes1.mp3", timetoint( 2, 1 ) },
		{ "GModTower/music/gamemodes2.mp3", timetoint( 1, 46 ) },
	},
}

// Halloween
/*Ambiance.Music = {
	// Stores
	[0] = { "GModTower/music/halloween/store.mp3", timetoint( 1, 3 ) },

	// Lobby
	[2] = {
			{ "GModTower/music/halloween/lobby1.mp3", timetoint( 3, 8 ) },
			{ "GModTower/music/halloween/lobby2.mp3", timetoint( 2, 37 ) },
	},

	// Theater hallway
	[42] = { "GModTower/music/theater.mp3", timetoint( 10, 35 ) },

	// Suites
	[4] = { "GModTower/music/halloween/suite1.mp3", timetoint( 2, 43 ) },

	// Arcade
	[38] = { "GModTower/music/arcade.mp3", timetoint( 3, 56 ) },

	// Lobby roof
	[43] = { "GModTower/music/halloween/roof.mp3", timetoint( 1, 4 ) },

	// Haunted Mansion
	[52] = { "GModTower/music/halloween/haunted.mp3", timetoint( 3, 34 ) },
}*/

// Christmas
/*Ambiance.Music = {
	// Stores
	[0] = {
		{ "GModTower/music/christmas/store1.mp3", timetoint( 1, 48 ) },
		{ "GModTower/music/christmas/store2.mp3", timetoint( 1, 21 ) },
	},

	// EPlaza
	[3] = { "GModTower/music/christmas/entertainment1.mp3", timetoint( 3, 14 ) },

	// Lobby
	[2] = {
		{ "GModTower/music/christmas/lobby1.mp3", timetoint( 3, 27 ) },
		{ "GModTower/music/christmas/lobby2.mp3", timetoint( 2, 24 ) },
	},

	// Theater hallway
	[42] = { "GModTower/music/theater.mp3", timetoint( 10, 35 ) },

	// Suites
	[4] = {
		{ "GModTower/music/christmas/suite1.mp3", timetoint( 4, 20 ) },
		{ "GModTower/music/christmas/suite2.mp3", timetoint( 2, 34 ) },
	},

	// Arcade
	[38] = { "GModTower/music/arcade.mp3", timetoint( 3, 56 ) },

	// Lobby roof
	[43] = { "GModTower/music/christmas/roof1.mp3", timetoint( 4, 50 ) },

	// Lake
	[57] = { "GModTower/music/christmas/lake1.mp3", timetoint( 2, 37 ) },

	// Pool
	[56] = { 
		{ "GModTower/music/christmas/lake1.mp3", timetoint( 2, 37 ) },
	},

	// Gamemodes (manually override for 36 and 37)
	[35] = { 
		{ "GModTower/music/gamemodes1.mp3", timetoint( 2, 1 ) },
		{ "GModTower/music/gamemodes2.mp3", timetoint( 1, 46 ) },
	},
}*/

Ambiance.Sounds = {
	// Event notify
	[1] = "GModTower/misc/notifyevent.wav"
}