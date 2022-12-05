---------------------------------
Ambiance = Ambiance or {}

module( "Ambiance", package.seeall )

local function duration( min, sec )
	return min * 60 + sec
end

Ambiance.Music = {
	// Condo Elevator
	[31] = {
		{ "gmodtower/soundscapes/music/elevator1.mp3", 147.278367 },
		{ "gmodtower/soundscapes/music/elevator2.mp3", 77.818776 },
		{ "gmodtower/soundscapes/music/elevator3.mp3", 34.298776 },
		{ "gmodtower/soundscapes/music/elevator4.mp3", 119.588571 },
		{ "gmodtower/soundscapes/music/elevator5.mp3", 130.403265 },
		{ "gmodtower/soundscapes/music/elevator6.mp3", 100.205714 },
		{ "gmodtower/soundscapes/music/elevator7.mp3", 162.586122 },
		{ "gmodtower/soundscapes/music/elevator8.mp3", 132.414694 },
		{ "gmodtower/soundscapes/music/elevator9.mp3", 201.586939 },
		{ "gmodtower/soundscapes/music/elevator10.mp3", 122.017959 },
		{ "gmodtower/soundscapes/music/elevator11.mp3", 214.543673 },
		{ "gmodtower/soundscapes/music/elevator12.mp3", 244.610612 },
		{ "gmodtower/soundscapes/music/elevator13.mp3", 187.689796 },
		{ "gmodtower/soundscapes/music/elevator14.mp3", 89.521633 },
		{ "gmodtower/soundscapes/music/elevator15.mp3", 131.840000 },
		{ "gmodtower/soundscapes/music/elevator16.mp3", 144.039184 },
		{ "gmodtower/soundscapes/music/elevator17.mp3", 88.528980 },
		{ "gmodtower/soundscapes/music/elevator18.mp3", 249.260408 },
		{ "gmodtower/soundscapes/music/elevator19.mp3", 161.671837 },
		{ "gmodtower/soundscapes/music/elevator20.mp3", 48.718367 },
		{ "gmodtower/soundscapes/music/elevator21.mp3", 246.257392 },
	},

	// Transit Station
	[38] = {
		{ "gmodtower/voice/station/psa1.mp3", 50 },
		{ "gmodtower/voice/station/psa2.mp3", 45 },
		{ "gmodtower/voice/station/psa3.mp3", 55 },
		{ "gmodtower/voice/station/psa4.mp3", 60 },
	},

	// Station A
	[39] = {
		{ "gmodtower/voice/station/psa1.mp3", 25 },
		{ "gmodtower/voice/station/psa2.mp3", 25 },
		{ "gmodtower/voice/station/psa3.mp3", 25 },
		{ "gmodtower/voice/station/psa4.mp3", 25 },
	},

	// Station B
	[40] = {
		{ "gmodtower/voice/station/psa1.mp3", 25 },
		{ "gmodtower/voice/station/psa2.mp3", 25 },
		{ "gmodtower/voice/station/psa3.mp3", 25 },
		{ "gmodtower/voice/station/psa4.mp3", 25 },
	},

	// Plaza
	[17] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Garden
	[57] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Condo Lobby
	[29] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Stores
	[18] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	[20] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	[21] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	[22] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	[23] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	[37] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Boardwalk
	[42] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Games
	[28] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Games Lobby
	[36] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Arcade Loft
	[19] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Center Plaza
	[16] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Casino Loft
	[24] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Pool
	[43] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Top of Water Slides
	[46] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Water Slides
	[48] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Beach
	[45] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Ocean
	[47] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Ocean
	[44] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Tower Lobby
	[15] = {
		{ "gmodtower/soundscapes/music/towermainlobby1.mp3", 116.324331 },
	},

	[14] = {
		{ "gmodtower/soundscapes/music/towermainlobby1.mp3", 116.324331 },
	},

	// Theater Main
	[32] = {
		{ "GModTower/music/theater.mp3", duration( 10, 35 ) },
	},

	// Arcade
	[58] = {
		{ "GModTower/music/arcade.mp3", duration( 3, 56 ) },
	},

	[55] = {
		{ "GModTower/minigolf/music/waiting1.mp3", duration( 0, 32 ) },
		{ "GModTower/minigolf/music/waiting3.mp3", duration( 0, 33 ) },
		{ "GModTower/minigolf/music/waiting5.mp3", duration( 0, 36 ) },
	},

	[54] = {
		{ "GModTower/sourcekarts/music/island_race2.mp3", duration( 3, 34 ) },
		{ "GModTower/sourcekarts/music/raceway_race1.mp3", duration( 2, 12 ) },
		{ "GModTower/sourcekarts/music/island_race3.mp3", duration( 3, 41 ) },
	},

	[53] = {
		{ "GModTower/pvpbattle/startofcolonyround.mp3", duration( 3, 52 ) },
		{ "GModTower/pvpbattle/startofoneslipround.mp3", duration( 5, 59 ) },
		{ "GModTower/pvpbattle/startoffrostbiteround.mp3", duration( 4, 13 ) },
	},

	[52] = {
		{ "GModTower/balls/midori_vox.mp3", duration( 4, 19 ) },
		{ "GModTower/balls/ballsmusicwmemories.mp3", duration( 4, 20 ) },
		{ "GModTower/balls/ballsmusicwsky.mp3", duration( 1, 23 ) },
		{ "GModTower/balls/ballsmusicwwater.mp3", duration( 3, 25 ) },
	},

	[51] = {
		{ "uch/music/round/round_music2.mp3", duration( 2, 14 ) },
		{ "uch/music/round/round_music3.mp3", duration( 0, 50 ) },
		{ "uch/music/round/round_music7.mp3", duration( 1, 43 ) },
	},

	[49] = {
		{ "gmodtower/zom/music/music_round2.mp3", duration( 4, 0 ) },
		{ "gmodtower/zom/music/music_round5.mp3", duration( 4, 1 ) },
		{ "gmodtower/zom/music/music_waiting3.mp3", duration( 0, 30 ) },
	},

	[50] = {
		{ "gmodtower/virus/roundplay2.mp3", duration( 2, 0 ) },
		{ "gmodtower/virus/roundplay4.mp3", duration( 2, 6 ) },
		{ "gmodtower/virus/roundplay3.mp3", duration( 2, 0 ) },
	},

}
