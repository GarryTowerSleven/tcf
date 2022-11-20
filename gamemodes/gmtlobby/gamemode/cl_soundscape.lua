local function isEmpty(str)
	return str == nil or str == ""
end

-- Some locations call for certain behavior of soundscapes, more than just groups
soundscape = soundscape or {}
function soundscape.GetSoundscape(loc)
	local location = Location.Get(loc)
	if not location then return end

	-- First, see if there's a soundscape defined for the current specific location
	local scape = soundscape.IsDefined(location.Name) and location.Name or nil 
	scape = scape and string.lower(scape) or nil 

	-- if it's registered, return
	if not isEmpty(scape) then return scape end

	-- Move on to any overrides before we get to a 'group' soundscape
	-- Play a super quiet soundscape when they're in the movie theater itself
	if location.Group == "theater" and location.Name ~= "theatermain" then
		return "theater_inside"
	end

	-- When in the stores, stop playing the plaza soundscape
	if location.Group == "stores" and location.Name ~= "stores" then
		return "stores_inside"
	end

	-- Fix for the condos
	if location.CondoID then
		return "condo"
	end

	-- Just use default methods to find the soundscape
 	scape = Location.GetGroup(loc)

	-- Return what we've got
	return scape and string.lower(scape) or nil
end

-- Set the soundscapes automatically depending on their location
hook.Add("Location", "SoundscapeChangeLocation", function(ply, loc)

	-- Retrieve the two locations
	local newGroup = string.lower(Location.GetGroup(loc))

	-- Get the soundscape matching this location
	local sndscape = soundscape.GetSoundscape(loc)

	-- if there's no soundscapes for this location stop the presses
	if isEmpty(sndscape) then
		soundscape.StopChannel("background")
		
		 -- spook their pants off
		if loc == 0 or Location.Get(loc) == nil then
			soundscape.Play("somewhere", "background")
		end
		return
	end
	-- If the soundscape wasn't playing, stop current soundscapes to play it
	if not soundscape.IsPlaying(sndscape) then
		soundscape.StopChannel("background")
		soundscape.Play(sndscape, "background")
	end
end )


--------------------------------------
--      SOUNDSCAPE DEFINITIONS      --
-- TODO: Better place to put these? --
--------------------------------------

local STATE_IDLE 		= 1
local STATE_ARRIVING 	= 2
local STATE_UNLOADING 	= 3
local STATE_LEAVING 	= 4

local PSASounds = 
{
	{Sound("GModTower/voice/station/psa1.mp3"), 7},
	{Sound("GModTower/voice/station/psa2.mp3"), 10},
	{Sound("GModTower/voice/station/psa3.mp3"), 5},
	{Sound("GModTower/voice/station/psa4.mp3"), 7},
	{Sound("GModTower/voice/station/psa5.mp3"), 11},
}
local ApproachSound = { Sound("GModTower/voice/station/approaching.mp3"), 8}

soundscape.Register("transit", 
{
	dsp = 0,
	--dsp = 2,

	-- Create a new rule that plays a random sound
	{
	type = "playrandom_bass",
		time = {90, 120}, -- Rule is run every 90 to 120 seconds
		volume = 0.55, -- Full volume
		pitch = 100, -- Normal pitch
		--soundlevel = 100000, -- Sound level in decibels

		-- Override the sound selector function with our own
		sounds = function()
		
			-- If the train is approaching, play the arrival sound
			for _, v in pairs(ents.FindByClass("gmt_maglev")) do
				if v and v.State == STATE_ARRIVING or v.State == STATE_UNLOADING then

					-- Return the approaching file and length
					return ApproachSound[1], ApproachSound[2]
				end
			end

			-- If the train wasn't approaching, play a random other sound
			local rnd = table.Random(PSASounds)
			return rnd[1], rnd[2]
		end,
	},

	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.80,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/trainstation.wav"), 3},
	},
})


local ElevatorMusicName = "GModTower/soundscapes/music/elevator"
local ElevatorMusicCount = 21 -- Define the number of music files for ambient lobby jams
local ElevatorSongs = {}
for n=1, ElevatorMusicCount do 
	table.insert(ElevatorSongs, {ElevatorMusicName .. n .. ".mp3", 10} )
end
soundscape.Register("elevator", 
{
	-- Tell the soundscape system that when this is usually removed and faded out, keep it alive
	--idle = true, 

	-- Select a random song to play every once in a while
	{
	type = "playlist",
		time = 2, -- Play the next sound 2 seconds after this one ends
		pitch = 100, -- Normal pitch

		-- Override the sound selector function with our own
		sounds = ElevatorSongs,
	},
})


soundscape.Register("lobby", 
{
	dsp = 0,
	--dsp = 3,

	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 1,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/tower_lobby.wav"), 2},
	},

})

soundscape.Register("theater", 
{
	dsp = 0,
	--dsp = 2,
	
	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 1,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/theatre_lobby.wav"), 2},
	},

	{
	type = "playlooping",
		volume = 1,
		position = Vector(4864.0913085938, 4366.1127929688, -874.30322265625),
		soundlevel = 150,

		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {"GModTower/music/theater.mp3", 2},
	},
	{
	type = "playlooping",
		volume = 1,
		position = Vector(3946.9204101563, 4366.6865234375, -872.61047363281),
		soundlevel = 150,

		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {"GModTower/music/theater.mp3", 2},
	},

	
	{
	type = "playrandom",

		time = {300, 600},
		volume = {0.5, 0.75},
		pitch = {90, 110},
		soundlevel = 140, -- Sound level in decibels
		position = 1500,
		sounds = 
		{
			{"ambient/levels/citadel/strange_talk7.wav", 10 },
			{"ambient/levels/citadel/strange_talk8.wav", 10 },
			{"ambient/levels/citadel/strange_talk9.wav", 10 },
			{"ambient/levels/citadel/strange_talk10.wav", 10 },
			{"ambient/levels/citadel/strange_talk11.wav", 10 },
		},
	},
})

soundscape.Register("theaterarcade", 
{
	dsp = 0,
	--dsp = 2,
	
	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 1,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {"GModTower/music/arcade.mp3", 2},
	},	
	{
	type = "playrandom",

		time = {300, 600},
		volume = {0.5, 0.75},
		pitch = {90, 110},
		soundlevel = 140, -- Sound level in decibels
		position = 1500,
		sounds = 
		{
			{"ambient/levels/citadel/strange_talk7.wav", 10 },
			{"ambient/levels/citadel/strange_talk8.wav", 10 },
			{"ambient/levels/citadel/strange_talk9.wav", 10 },
			{"ambient/levels/citadel/strange_talk10.wav", 10 },
			{"ambient/levels/citadel/strange_talk11.wav", 10 },
		},
	},
})

soundscape.Register("theater_inside", 
{
	dsp = 0,
})

soundscape.Register("monorail", 
{
	dsp = 0,
})

soundscape.Register("casino", 
{
	dsp = 0,
	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 1,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/tower_lobby.wav"), 2},
	},

	-- Create a looping sound rule
	--[[{
	type = "playlooping",
		-- Limit the volume
		volume = 0.00, --
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/casinobase.wav"), 2},
	},]]
})

soundscape.Register("casinoloft", 
{
	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.25,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/plaza.wav"), 8},
	},

	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.8,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/tower_lobby.wav"), 2},
	},
})

soundscape.Register("duels", 
{
	dsp = 0,

	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = .1,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/tower_lobby.wav"), 2},
	},
})

soundscape.Register("plaza", 
{
	dsp = 0,
	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 1,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/plaza.wav"), 8},
	},

	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.87,

		-- Worldsound position of the looping sound
		position = Vector(1685.487793, -1691.865723, -771.9),

		-- Control the falloff of the sound
		-- Note the values are different than source's builtin soundlevel, I need to figure out the math for this
		soundlevel = 300,

		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/lobby/club/club_exterior.mp3"), 10},
	},

})

soundscape.Register("games", 
{
	dsp = 0,

	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.65,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("ambient/construct_tone.wav"), 8},
	},
		-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.20,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/plaza.wav"), 8},
	},

	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.006,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("ambient/forest_day.wav"), 16},
	},

})

soundscape.Register("gameslobby", 
{
	dsp = 0,

	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.30,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("ambient/construct_tone.wav"), 8},
	},
	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.30,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/plaza.wav"), 8},
	},

	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.003,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("ambient/forest_day.wav"), 16},
	},

})

soundscape.Register("boardwalk", 
{
	dsp = 0,
	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.8,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/boardwalk.mp3"), 8},
	},

	{
	type = "playrandom",

		time = {2, 8},
		volume = 0.32,
		pitch = {90, 110},
		soundlevel = 110, -- Sound level in decibels
		position = 5500,
		sounds = 
		{
			{"ambient/levels/coast/seagulls_ambient1.wav", 10 },
			{"ambient/levels/coast/seagulls_ambient2.wav", 10 },
			{"ambient/levels/coast/seagulls_ambient3.wav", 10 },
			{"ambient/levels/coast/seagulls_ambient4.wav", 10 },
			{"ambient/levels/coast/seagulls_ambient5.wav", 10 },
		},
	},
})

soundscape.Register("pool", 
{
	dsp = 0,

	-- Poolwater lapping
	{
	type = "playrandom",

		time = {1, 4},
		volume = 1,
		pitch = {90, 110},
		soundlevel = 140, -- Sound level in decibels
		position = 500,
		sounds = 
		{
			{"GModTower/pool/lap1.mp3", 10 },
			{"GModTower/pool/lap2.mp3", 10 },
			{"GModTower/pool/lap3.mp3", 10 },
			{"GModTower/pool/lap4.mp3", 10 },
			{"GModTower/pool/lap5.mp3", 10 },
			{"GModTower/pool/lap6.mp3", 10 },
			{"GModTower/pool/lap7.mp3", 10 },
			{"GModTower/pool/lap8.mp3", 10 },
		},
	},

	
	-- Duplicate the beach soundscape
	-- TODO: make a 'playsoundscape' rule so we don't have to do this
	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.80,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/boardwalk.mp3"), 8},
	},

	{
	type = "playrandom",

		time = {2, 8},
		volume = 0.32,
		pitch = {90, 110},
		soundlevel = 110, -- Sound level in decibels
		position = 5500,
		sounds = 
		{
			{"ambient/levels/coast/seagulls_ambient1.wav", 10 },
			{"ambient/levels/coast/seagulls_ambient2.wav", 10 },
			{"ambient/levels/coast/seagulls_ambient3.wav", 10 },
			{"ambient/levels/coast/seagulls_ambient4.wav", 10 },
			{"ambient/levels/coast/seagulls_ambient5.wav", 10 },
		},
	},
})


soundscape.Register("stores", 
{
	dsp = 0,
	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 1,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/plaza.wav"), 8},
	},
})

soundscape.Register("stores_inside", 
{
	dsp = 0,
	--dsp = 104,

	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.25,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/tower_lobby.wav"), 4},
	},
})


soundscape.Register("condolobby", 
{
	dsp = 0,
	--dsp = 2,

	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 1,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/condocorridor.wav"), 4},
	},
})
soundscape.Register("condo", 
{
	dsp = 0,
})

-- TODO: Add playsoundscape rule
soundscape.Register("duels", 
{
	dsp = 0,

	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.05,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("ambient/atmosphere/town_ambience.wav"), 9.2833560090703},
	},

	{
	type = "playrandom",

		time = {6, 12},
		volume = 1,
		pitch = {50, 140},
		soundlevel = 140, -- Sound level in decibels
		position = 1500,
		sounds = 
		{
			{"GModTower/lobby/void/void1.mp3", 10 },
			{"GModTower/lobby/void/void2.mp3", 10 },
			{"GModTower/lobby/void/void3.mp3", 10 },
			{"GModTower/lobby/void/void4.mp3", 10 },
			{"GModTower/lobby/void/void5.mp3", 10 },
		},
	},
})



-- SPOOK ZONE: ACTIVATE
soundscape.Register("somewhere", 
{
	dsp = 0,

	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.05,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("ambient/atmosphere/town_ambience.wav"), 9.2833560090703},
	},

	{
	type = "playrandom",

		time = {6, 12},
		volume = 1,
		pitch = {50, 140},
		soundlevel = 140, -- Sound level in decibels
		position = 1500,
		sounds = 
		{
			{"GModTower/lobby/void/void1.mp3", 10 },
			{"GModTower/lobby/void/void2.mp3", 10 },
			{"GModTower/lobby/void/void3.mp3", 10 },
			{"GModTower/lobby/void/void4.mp3", 10 },
			{"GModTower/lobby/void/void5.mp3", 10 },
		},
	},
})
