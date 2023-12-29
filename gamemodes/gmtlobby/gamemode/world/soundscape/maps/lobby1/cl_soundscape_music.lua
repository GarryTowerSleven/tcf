local function isEmpty(str)
	return str == nil or str == ""
end

local lastRand 
local curRand 
local function uniqueRandom(min, max )

	-- Prevent infinite loop
	if min == max then return min end

	-- Repeat until we have a new unique number 
	repeat
		curRand = math.random(min, max)
	until (curRand ~= lastRand )

	return curRand 
end

local Enabled = CreateClientConVar("gmt_bgmusic_enable", "1", true, false )
local Volume = CreateClientConVar("gmt_bgmusic_volume", "50", true, false )

-- Hook into when these babies change
cvars.AddChangeCallback(Enabled:GetName(), function(name, old, new )
	if not tobool(new) then
		soundscape.StopChannel("music", 0.5, true)
	else/*if not soundscape.IsPlaying("music_global_ambient") then
		soundscape.Play("music_global_ambient", "music", true)*/

		local scape = soundscape.GetMusicSoundscape( LocalPlayer():Location() ) or ""
		soundscape.Play( scape, "music", true )
	end
end )

cvars.AddChangeCallback(Volume:GetName(), function(name, old, new )
	soundscape.SetVolume("music", math.Clamp(tonumber(new), 0, 100) / 100)
end )

-- Set initial volume
soundscape.SetVolume("music", math.Clamp(Volume:GetInt(), 0, 100) / 100)

-- Some locations call for certain behavior of soundscapes, more than just groups
-- This function is fine-tuned for background music, not just generic soundscapes
-- To define a custom musicscape, name it exactly as you would a normal soundscape, prefixed with "music_"
-- For example, a custom musicscape for the "lobby" location would be named "music_lobby"
soundscape = soundscape or {}
function soundscape.GetMusicSoundscape(loc)
	local location = Location.Get(loc)
	if not location then return end

	-- First, see if there's a soundscape defined for the current specific location
	local scape = soundscape.IsDefined("music_" .. location.Name) and "music_" .. location.Name or nil 
	scape = scape and scape or nil 

	-- if it's registered, return
	if not isEmpty(scape) then return scape end

	-- Move on to any overrides before we get to a 'group' soundscape
	-- Play a super quiet soundscape when they're in the movie theater itself
	if location.Group == "theater" and location.Name ~= "theatermain" then
		return "music_theater_inside"
	end

	-- When in the stores, stop playing the plaza soundscape
	if location.Group == "store" and location.Name ~= "store" then
		return "music_stores_inside"
	end

	-- Fix for the suites
	if location.SuiteID and location.SuiteID > 0 then
		return "music_suite"
	end

	-- halloween
	-- if location.Group == "eplaza" or location.Group == "pool" or location.Group == "lakeside" then
	-- 	return "music_lobby"
	-- end

	-- Just use default methods to find the soundscape
 	scape = Location.GetGroup(loc)

	if IsChristmas then

		if scape == "pool" then

			scape = "lakeside"

		end

	end

	-- Return what we've got
	return (scape and soundscape.IsDefined("music_" .. scape) ) and string.lower("music_" .. scape) or nil
end

-- Very similar to the one in cl_soundscape.lua
-- However, this one changes PASSIVELY, so that it's only changed when it's set to change
-- This keeps the music going even in new locations, whereas the other does not
hook.Add("Location", "MusicscapeChangeLocation", function(ply, loc)
	if not Enabled:GetBool() then return end

	-- Retrieve the two locations
	local newGroup = string.lower(Location.GetGroup(loc))

	-- Get the soundscape matching this location
	local sndscape = soundscape.GetMusicSoundscape(loc)

	-- if there's no soundscapes for this location stop the presses
	if isEmpty(sndscape) or not soundscape.IsDefined(sndscape) then
		 -- Only stop the soundscape if they're in no man's land
		if loc == 0 or Location.Get(loc) == nil then
			soundscape.StopChannel("music")

		-- Just play an ambient music track if there's no music override here
		elseif not soundscape.IsPlaying("music_global_ambient") then
			soundscape.StopChannel("music")
			//soundscape.Play("music_global_ambient", "music", true)
		end
		return
	end

	-- If there is an actual defined soundscape for this location, use that
	if not soundscape.IsPlaying(sndscape) then
		soundscape.StopChannel("music")
		soundscape.Play(sndscape, "music")
	end
end )

function soundscape.PlayOptimal()
	if not Enabled:GetBool() then return end

	local scape = soundscape.GetMusicSoundscape( LocalPlayer():Location() ) or ""

	if ( not soundscape.IsPlaying(scape) ) then
		soundscape.StopChannel("music")
		soundscape.Play( scape, "music" )
	end
end

-- for da stores
hook.Add( "GTowerOpenStore", "PlayStoreMusic", function()
	//print( "open" )

	if not Enabled:GetBool() then return end
	if GTowerStore.StoreId == GTowerStore.MERCHANT then return end

	soundscape.StopChannel("music")
	soundscape.Play("music_store", "music")
end )

hook.Add( "GTowerCloseStore", "StopStoreMusic", function()
	//print( "close" )

	if ( soundscape.IsPlaying("music_store") ) then
		soundscape.StopChannel("music")
	end

	soundscape.PlayOptimal()
end )

--------------------------------------
--      SOUNDSCAPE DEFINITIONS      --
-- TODO: Better place to put these? --
--------------------------------------

/*local LobbyMusicName = "gmodtower/soundscapes/music/lobby"
local LobbyMusicCount = 10 -- Define the number of music files for ambient lobby jams
local LobbySongs = {}
for n=1, LobbyMusicCount do 
	table.insert(LobbySongs, {LobbyMusicName .. n .. ".mp3", 10} )
end
soundscape.Register("music_global_ambient", 
{
	-- Tell the soundscape system that when this is usually removed and faded out, keep it alive
	idle = true, 

	-- Select a random song to play every once in a while
	{
	type = "playlist",
		time = {60 * 0.5, 60 * 5}, -- Play the next song 0.5 to 5 minutes after the song ends

		-- Override the sound selector function with our own
		sounds = LobbySongs,
	},
})*/

-- Dynamically create the soundscapes based on gamemode names
for _, v in pairs(Location.Locations) do
	local gmode = GTowerServers:GetGamemode( v.Group )
	if not gmode then continue end 

	-- Format the songs so they're in { song, length } format 
	local formattedSongs = {}
	for __, song in pairs(gmode.Music) do
		table.insert(formattedSongs, {song, 10})
	end

	-- Create the rule to insert into the soundscape system
	print("Registering soundscape", v.Group)
	soundscape.Register("music_" .. v.Group, 
	{ 
		dsp = 0,

		{
			type = "playrandom_bass",
			volume = 0.70,
			sounds = formattedSongs,
		},
	})
end

soundscape.Register("music_lobby",
{
	-- Tell the soundscape system that when this is usually removed and faded out, keep it alive
	idle = false,

	-- Select a random song to play every once in a while
	{
		type = "playlist",
		time = {60 * 0.5, 60 * 5}, -- Play the next song 0.5 to 5 minutes after the song ends

		-- Override the sound selector function with our own
		sounds = {
			{ "gmodtower/music/christmas/lobby1_fix.mp3" },
			{ "gmodtower/music/christmas/lobby2.mp3" },

			// halloween
			// { "gmodtower/music/halloween/lobby1.mp3", 189 },
			// { "gmodtower/music/halloween/lobby2.mp3", 158 },
		},
	},
})

soundscape.Register("music_lobbyroof",
{
	-- Tell the soundscape system that when this is usually removed and faded out, keep it alive
	idle = false,

	-- Select a random song to play every once in a while
	{
		type = "playlist",
		time = {60 * 0.5, 60 * 1}, -- Play the next song 0.5 to 1 minute after the song ends

		-- Override the sound selector function with our own
		sounds = {
			{ "gmodtower/music/christmas/roof1.mp3" }

			// halloween
			// { "gmodtower/music/halloween/roof.mp3", 65 },
		},
	},
})

soundscape.Register("music_eplaza",
{
	-- Tell the soundscape system that when this is usually removed and faded out, keep it alive
	idle = false,

	-- Select a random song to play every once in a while
	{
	type = "playlist",
		time = {60 * 0.5, 60 * 5}, -- Play the next song 0.5 to 5 minutes after the song ends

		-- Override the sound selector function with our own
		sounds = {
			{ "gmodtower/music/christmas/entertainment1.mp3" },
		},
	},
})

soundscape.Register("music_gamemodeports",
{
	-- Tell the soundscape system that when this is usually removed and faded out, keep it alive
	idle = false,

	-- Select a random song to play every once in a while
	{
		type = "playlist",
		volume = 0.125,
		time = {60 * 0.5, 60 * 2}, -- Play the next song 0.5 to 2 minutes after the song ends

		-- Override the sound selector function with our own
		sounds = {
			{ "gmodtower/music/christmas/store2.mp3" },
		},
	},
})

soundscape.Register("music_suites",
{
	-- Tell the soundscape system that when this is usually removed and faded out, keep it alive
	idle = false,

	-- Select a random song to play every once in a while
	{
		type = "playlist",
		time = {60 * 0.5, 60 * 2}, -- Play the next song 0.5 to 2 minutes after the song ends

		-- Override the sound selector function with our own
		sounds = {
			{ "gmodtower/music/christmas/suite1.mp3" },
			{ "gmodtower/music/christmas/suite2.mp3" },

			// { "gmodtower/music/halloween/suite1.mp3", 163 },
		},
	},
})

soundscape.Register("music_theaterhallway",
{
	-- Tell the soundscape system that when this is usually removed and faded out, keep it alive
	idle = false,

	-- Select a random song to play every once in a while
	{
		type = "playlooping",
		volume = .1,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = { Sound( "gmodtower/music/theater.mp3" ), 636 },
	},
})

soundscape.Register("music_arcade",
{
	-- Tell the soundscape system that when this is usually removed and faded out, keep it alive
	idle = false,

	-- Select a random song to play every once in a while
	{
		type = "playlooping",
		volume = .5,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = { Sound( "gmodtower/music/arcade.mp3" ), 237 },
	},
})

soundscape.Register("music_lakeside",
{
	-- Tell the soundscape system that when this is usually removed and faded out, keep it alive
	idle = false,

	-- Select a random song to play every once in a while
	{
		type = "playlist",
		time = {60 * 0.5, 60 * 2}, -- Play the next song 0.5 to 2 minutes after the song ends

		-- Override the sound selector function with our own
		sounds = {
			{ "gmodtower/music/christmas/lake1.mp3" },
		},
	},
})

soundscape.Register("music_pool",
{
	-- Tell the soundscape system that when this is usually removed and faded out, keep it alive
	idle = false,

	-- Select a random song to play every once in a while
	{
	type = "playlist",
		time = {60 * 0.5, 60 * 2}, -- Play the next song 0.5 to 2 minutes after the song ends

		-- Override the sound selector function with our own
		sounds = {
			{ "gmodtower/music/pool1.mp3", 197 },
			{ "gmodtower/music/pool2.mp3", 210 },
		},
	},
})

soundscape.Register("music_store",
{
	-- Tell the soundscape system that when this is usually removed and faded out, keep it alive
	idle = false,

	-- Select a random song to play every once in a while
	{
		type = "playlooping",
		volume = 1,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = { Sound( "gmodtower/music/christmas/store1.mp3" ) },

		// halloween
		// sound = { Sound( "gmodtower/music/halloween/store.mp3" ), 63 },
	},
})

soundscape.Register("music_Lakeside Cabin",
{
	-- Tell the soundscape system that when this is usually removed and faded out, keep it alive
	idle = false,

	-- Select a random song to play every once in a while
	{
		type = "playlooping",
		volume = 0.25,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = { Sound( "gmodtower/music/merchant.mp3" ), 10 },

		// halloween
		// sound = { Sound( "gmodtower/music/halloween/store.mp3" ), 63 },
	},
})

soundscape.Register("music_merchant", {} )

-- Mute any music in the theater
soundscape.Register("music_theater_inside", {} )

-- Mute any music in the suite
soundscape.Register("music_suite", {})

-- Mute any music in the casino
soundscape.Register("music_casino", {
	-- Tell the soundscape system that when this is usually removed and faded out, keep it alive
	idle = false,

	-- Select a random song to play every once in a while
	{
	type = "playlist",
		time = {60 * 0.5, 60 * 2}, -- Play the next song 0.5 to 2 minutes after the song ends

		-- Override the sound selector function with our own
		sounds = {
			{ "gmodtower/music/christmas/casino1.mp3" },
			{ "gmodtower/music/christmas/casino2.mp3" },
		},
	},
})

-- Mute any music in the bar
soundscape.Register("music_bar", {
	-- Tell the soundscape system that when this is usually removed and faded out, keep it alive
	idle = false,
	
	-- Select a random song to play every once in a while
	{
		type = "playlooping",
		volume = 1,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {
			Sound( "gmodtower/music/bar.mp3" ), 147
		},
	},
})

-- Mute any music in narnia
soundscape.Register("music_narnia", {})

-- Halloween Dev HQ
/*soundscape.Register("music_olddevhq", {
	-- Tell the soundscape system that when this is usually removed and faded out, keep it alive
	idle = false,

	-- Select a random song to play every once in a while
	{
		type = "playlooping",
		volume = 1,

		// halloween
		sound = { Sound( "gmodtower/lobby/halloween/devhq_ambience.mp3" ), 157 },
	},
})*/