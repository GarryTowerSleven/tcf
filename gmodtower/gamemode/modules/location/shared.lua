---------------------------------
GTowerLocation = GTowerLocation or {}
GTowerLocation.DEBUG = false

include("maps/gmt_alpha.lua")

if SERVER then
	AddCSLuaFile("maps/gmt_alpha.lua")
end

GTowerLocation.SUITETELEPORTERS = 33

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

function GTowerLocation:IsSuite( id )
	return id >= 11 && id <= 30 or id >= 70 && id <= 73
end

function GTowerLocation:IsTheater( id )
	return id == 32 or id == 33
end

GTowerLocation.TeleportLocations = {
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

function GTowerLocation:Add( id, name )

	if type( id ) != "number" then
		Msg("Adding location that is not a number")
		return
	end

	if self.Locations[ id ] then
		Msg("GTowerLocation: ATTENTION: Adding the same location twice for id: " .. id .. " OldName:" .. self.Locations[ id ] .. ", new name: " .. name)
	end

	self.Locations[ id ] = name

end

function GTowerLocation:GetName( id )
	if self.Locations[ id ] == "Suites 10-16"  then
	    return "Suites 10-15"
	elseif self.Locations[ id ] == "Suites 17-24" then
	    return "Suites 16-24"
	end

	if self.Locations[ id ] == "Hat Store" then
		return "Appearance Store"
	end
	return self.Locations[ id ]
end

function GTowerLocation:FindPlacePos( pos )
	local HookTbl = hook.GetTable().FindLocation

	if HookTbl then
		for _, v in pairs( HookTbl ) do

			local b, location = SafeCall( v, pos )

			if b && location then
				return location
			end
		end
	end

	return GTowerLocation:DefaultLocation( pos )
end

function GTowerLocation:GetPlyLocation( ply )
	return (ply.GLocation || 0)
end

function GTowerLocation:InBox( pos, vec1, vec2 )
	return pos.x >= vec1.x && pos.x <= vec2.x &&
		pos.y >= vec1.y && pos.y <= vec2.y &&
		pos.z >= vec1.z && pos.z <= vec2.z
end

local function LocationChanged( ply, var, old, new )
	hook.Call("Location", GAMEMODE, ply, new )
end

function GTowerLocation:GetPlayersInLocation( location )

	if isstring( location ) then

		location = GetName( location )

	end

	local players = {}

	for _, ply in pairs( player.GetAll() ) do
		if not IsValid(ply) then continue end

		-- Same location
		if GTowerLocation:GetPlyLocation( ply ) == location then
			table.insert(players, ply)
			continue
		end
	end

	return players

end

RegisterNWTablePlayer({
	{"GLocation", 0, NWTYPE_CHAR, REPL_EVERYONE, LocationChanged },
})
