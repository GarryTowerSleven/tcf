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
	/*if location.Group == "theater" and location.Name ~= "theatermain" then
		return "theater_inside"
	end*/

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

soundscape.Register("hallway",
{
	-- Tell the soundscape system that when this is usually removed and faded out, keep it alive
	dsp = 0,

	-- Select a random song to play every once in a while
	{
		type = "playlooping",
		volume = 1,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = { Sound( "gmodtower/music/secret.mp3" ), 80 },
	},
})
