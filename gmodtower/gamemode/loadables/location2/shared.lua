module("Location", package.seeall )

DEBUG = false
Locations = Locations or {}

plynet.Register( "Int", "Location" )

function LoadMapData( data )

	MsgC( Color( 0, 255, 255 ), "Loaded location data successfully from: maps/" .. game.GetMap() .. ".lua.\n" )

	Locations = data

	-- Don't waste entity space
	for _, loc in pairs( ents.FindByClass( "gmt_location" ) ) do
		--loc:Remove()
	end

end

function IncludeMap()

	local map = game.GetMap()
	local mappath = "GModTower/gamemode/loadables/location2/maps/" .. map .. ".lua"

	if not file.Exists(mappath, "LUA") then
		ErrorNoHalt("LOCATION: No map locations found for '" .. map .. "'\n")
		return
	end

	include( "maps/" .. map .. ".lua" )

	if SERVER then
		AddCSLuaFile( "maps/" .. map .. ".lua" )
	end

end
IncludeMap()

function GetByName( name )

	for id, loc in pairs( Locations ) do

		-- Found a matching existing location
		if loc.Name == name then
			return loc
		end

	end

end

function GetIDByName( name )

	for id, loc in pairs( Locations ) do

		-- Found a matching existing location
		if loc.Name == name then
			return id
		end

	end

end

function GetByCondoID( condoid )

	for id, loc in pairs( Locations ) do

		-- Found a matching existing location
		if loc.CondoID == condoid then
			return id
		end

	end

end

function GetCondoID( location )

	local loc = Get( location )
	if loc then
		return loc.CondoID
	end

end

function Get( location )
	return Locations[location]
end

function GetFriendlyName( location )

	local location = Get( location )

	if location then
		return location.FriendlyName
	end

	return "Somewhere"

end

function GetGroup( location )

	local location = Get( location )

	if location then
		return location.Group
	end

	return ""

end

function Is( location, name )

	local location = Get( location )

	if location then
		return location.Name == name
	end
	return false

end

function IsGroup( location, name )

	local location = Get( location )

	if location then
		return location.Group == name
	end
	return false

end

function IsTheater( id )
	return Is( id, "theater1" ) or Is( id, "theater2" ) --IsGroup( id, "theater" )
end

function IsVoiceNotAllowed( id )
	return IsTheater( id ) or Is( id, "nightclub" )
end

function IsCasino( id )
	return Is( id, "casino" )
end

function IsArcade( id )
	return Is( id, "arcade" )
end

function IsNightclub( id )
	return IsGroup( id, "nightclub" )
end

function IsCondo( id, condoid )
	return Is( id, "condo" .. condoid )
end

function IsEquippablesNotAllowed( id )
	return IsArcade( id ) or IsTheater( id ) or Is( id, "duelarena" )
end

function IsSuicideNotAllowed( id, ply )
	return IsTheater( id ) or Is( id, "duelarena" ) or ( IsValid( ply ) and ply:GetRoom() and IsCondo( ply:Location(), ply:GetRoom().Id ) )
end

function IsDrivablesNotAllowed( id ) -- ball race orb
	return Is( id, "topofslides" ) or Is( id, "slides" ) or Is( id, "pool" ) or Is( id, "ferriswheel" ) or Is( id, "elevator" ) or IsNightclub( id )
end

function IsWeaponsNotAllowed( id )
	return IsEquippablesNotAllowed( id ) or IsCasino( id ) or IsNightclub( id )
end

function IsDropNotAllowed( id ) -- fireworks
	return IsEquippablesNotAllowed( id ) or IsCasino( id ) or IsNightclub( id )
end

function Find( pos )

	local currentLocation = 0
	local highestPriority = -1

	for id, loc in ipairs( Locations ) do

		-- Go through regions of a location

		for rid, region in ipairs( loc.Regions ) do

			if region.planes then

				--quick aabb reject
				if InBox( pos, region.min, region.max ) then
					local inside = true

					--test against each plane
					for i=1, #region.planes do
						local plane = region.planes[i]
						if pos:Dot(plane.normal) - plane.dist > 0 then
							inside = false
						end
					end

					-- Are we in it and is it highest priority?
					if inside and loc.Priority > highestPriority then
						highestPriority = loc.Priority
						currentLocation = id
					end

				end

			else
				-- Are we in it and is it highest priority?
				if InBox( pos, region.Min, region.Max ) and loc.Priority > highestPriority then
					highestPriority = loc.Priority
					currentLocation = id

					--if DEBUG then MsgN( "assn[" .. id .. " -> " .. rid .. "]: " .. loc.Name ) end
				end

			end

		end

	end

	return currentLocation

end

function InBox( pos, vec1, vec2 )
	return pos.x >= vec1.x && pos.x <= vec2.x &&
		pos.y >= vec1.y && pos.y <= vec2.y &&
		pos.z >= vec1.z && pos.z <= vec2.z
end

function GetEntitiesInLocation( location, checkGroup )
	if isstring( location ) then

		location = GetIDByName( location )

	end
	local group = Locations[location] and Locations[location].Group
	local entities = {}

	for _, ent in pairs( ents.GetAll() ) do
		if not IsValid(ent) then continue end 

		-- Same location
		if ent:Location() == location then
			table.insert(entities,ent)
			continue 
		end 

		-- Same location group
		if checkGroup and GetGroup(ent:Location()) == group then
			table.insert(entities, ent)
			continue
		end
	end

	return entities
end

function GetMediaPlayersInLocation( location )

	local mediaplayers = {}

	for _, mp in pairs( MediaPlayer.GetAll() ) do

		if IsValid( mp.Entity ) then
			local mploc = mp.Entity:Location()
			if location == mploc then -- TODO: Support groups
				table.insert( mediaplayers, mp )
			end
		end

	end

	return mediaplayers

end

function GetPlayersInLocation( location, checkGroup )

	if isstring( location ) then

		location = GetIDByName( location )

	end
	local group = Locations[location] and Locations[location].Group
	local players = {}

	for _, ply in pairs( player.GetAll() ) do
		if not IsValid(ply) then continue end 

		-- Same location
		if ply:Location() == location then
			table.insert(players, ply)
			continue
		end

		-- Same location group
		if checkGroup and GetGroup(ply:Location()) == group then
			table.insert(players, ply)
			continue
		end
	end

	return players

end

function TeleportToCenter( ply, location )

	-- TODO?
	/*local loc = Locations[location]

	if loc then

		local a = loc.Min
		local b = loc.Max
		OrderVectors( a, b )

		local centerPos = a + (b-a)/2
		ply:SetPos( centerPos )

	end*/

end