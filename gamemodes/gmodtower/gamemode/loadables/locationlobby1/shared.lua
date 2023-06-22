module("Location", package.seeall )

DEBUG = false
Locations = {}

plynet.Register( "Int", "Location" )

function GetLocations()
	return Locations
end

function GetLocationByIndex( id )
	return Locations[id]
end

function Add( id, name, group, min, max, issuite, suiteid )
	
	if type( id ) != "number" then
		Msg("Adding location that is not a number")
		return
	end
	
	if Locations[ id ] then
		LogPrint("ATTENTION: Adding the same location twice for id: " .. id .. " OldName:" .. Locations[ id ].Name .. ", new name: " .. name, color_red, "GTowerLocation")
	end

	//Msg( "Adding location... " .. id .. " - " .. name, "\n" )
	
	Locations[ id ] = {}
	Locations[ id ].Name = name
	Locations[ id ].Min = min or Vector(0,0,0)
	Locations[ id ].Max = max or Vector(0,0,0)
	Locations[ id ].IsSuite = issuite
	Locations[ id ].SuiteID = suiteid or 0

	Locations[ id ].Group = group or nil
	
end

function AddKeyValue( id, key, value )
	
	if not tonumber(id) then return end
	
	Locations[ id ] = Locations[ id ] or {}
	Locations[ id ][ key ] = value
	
end

function ResortVectors()

	for id, loc in pairs( Locations ) do

		if !loc.Min || !loc.Max then continue end
		OrderVectors( loc.Min, loc.Max )

	end

end

function IncludeMap()

	include("maps/" .. game.GetMap() .. ".lua")

	if SERVER then
		AddCSLuaFile("maps/" .. game.GetMap() .. ".lua")
	end

end
IncludeMap()

function GetIDByName( name )

	for id, loc in pairs( Locations ) do

		-- Found a matching existing location
		if loc.Name == name then
			return id //loc
		end

	end

end

function GetByName( name )
	return Locations[ GetIDByName( name ) or 0 ] or nil
end

function GetName( id )
	return Locations[ id ].Name
end

function GetSuiteLocations()
	local tbl = {}

	for id, loc in pairs( Locations ) do

		if !loc.IsSuite then continue end
		table.insert( tbl, id )

	end

	return tbl
end

function IsSuite( id )
	local loc = Locations[ id ]
	if loc then
		return loc.IsSuite
	else
		return false
	end
end

function GetBySuiteID( suiteid )

	for id, loc in pairs( Locations ) do

		-- Found a matching existing location
		if loc.SuiteID == suiteid then
			return id
		end

	end

end

GetByCondoID = GetBySuiteID

function GetSuiteID( location )

	local loc = Get( location )
	if loc then
		return loc.SuiteID
	end

end

GetCondoID = GetSuiteID

function Get( location )
	return Locations[location]
end

function GetFriendlyName( location )

	local location = Get( location )

	if location then
		return location.Name
	end

	return "Somewhere"

end

function GetGroup( location )

	local location = Get( location )

	if location then
		return (location.Group != nil) and location.Group or ""
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
	return id == 41 or id == 50 or id == 42
end

function IsCasino( id )
	return id == 10
end

function IsArcade( id )
	return id == 38
end

function IsNarnia( id )
	return id == 51
end

function IsCondo( id, condoid )
	return Is( id, "Suite #" .. condoid )
end

function IsEquippablesNotAllowed( id )
	return IsTheater( id ) or IsNarnia( id )
end

function IsSuicideNotAllowed( id, ply )
	return IsTheater( id ) or ( IsValid( ply ) and ply:GetRoom() and IsCondo( ply:Location(), ply:GetRoom().Id ) )
end

function IsDrivablesNotAllowed( id ) -- ball race orb
	return true
end

function IsWeaponsNotAllowed( id )
	return ( IsEquippablesNotAllowed( id ) or IsArcade( id ) or IsCasino( id ) ) && !IsNarnia( id )
end

function IsDropNotAllowed( id ) -- fireworks
	return IsEquippablesNotAllowed( id ) or IsArcade( id ) or IsCasino( id ) or id == 52
end

function IsEntsNotAllowed( id )
	return IsArcade( id ) or IsTheater( id ) or IsNarnia( id ) or id == 52
end

function IsVoiceNotAllowed( id )
	return IsTheater( id )
end

function IsNightclub()
	return false
end

function Find( pos )
	local HookTbl = hook.GetTable().FindLocation
	
	if HookTbl then
		for _, v in pairs( HookTbl ) do
			
			local b, location = SafeCall( v, pos )
			
			if b && location then 
				return location
			end		
		end
	end
	
	return DefaultLocation( pos )
end

function InBox( pos, vec1, vec2 )
	return pos.x >= vec1.x && pos.x <= vec2.x &&
		pos.y >= vec1.y && pos.y <= vec2.y &&
		pos.z >= vec1.z && pos.z <= vec2.z
end

function DefaultLocation( pos )

	for id, loc in pairs( Locations ) do

		if !loc.Min || !loc.Max then continue end

		if InBox( pos, loc.Min, loc.Max ) then
			return id
		end

	end
	
	return 0

end

function GetEntitiesInLocation( location )

	local entities = {}

	for _, ent in pairs( ents.GetAll() ) do
		if IsValid(ent) and ent:Location() == location then
			table.insert(entities,ent)
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

function GetPlayersInLocation( location )

	local players = {}

	for _, ply in pairs( player.GetAll() ) do
		if ply:Location() == location then
			table.insert(players, ply)
		end
	end

	return players

end

function TeleportToCenter( ply, location )

	local loc = Locations[location]

	if loc then

		local a = loc.Min
		local b = loc.Max
		OrderVectors( a, b )

		local centerPos = a + (b-a)/2
		ply:SetPos( centerPos )

	end

end