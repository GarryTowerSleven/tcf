---------------------------------
GTowerLocation = GTowerLocation or {}
GTowerLocation.DEBUG = false

function ResortVectors()
	for _, v in pairs( GTowerLocation.MapPositions ) do
		OrderVectors( v[2], v[3] )
	end
end

function IncludeMaps()
	include( "maps/"..game.GetMap()..".lua" )

	if SERVER then
		AddCSLuaFile( "maps/"..game.GetMap()..".lua" )
	end
end
IncludeMaps()

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

function GTowerLocation:GetCondoID( location )
	// this sucks but it'll do until we switch to lobby 2's systems
	local na = GTowerLocation:GetName( location )
	if na then
		if !string.StartWith( string.lower( na ), "condo #" ) then return end

		return tonumber( string.Replace( string.lower( na ), "condo #", "" ) )
	end
end

RegisterNWTablePlayer({
	{"GLocation", 0, NWTYPE_CHAR, REPL_EVERYONE, LocationChanged },
})



local locDebug = false

function ShowGMTALPHALocations()
	locDebug = !locDebug
end

concommand.Add("gmt_showlocations", function( ply, cmd, args )

	for k, v in ipairs( MapPositions ) do
		Msg( k .. ". " , GTowerLocation:GetName( v[1] ), " (".. v[1] ..")\n" )
		Msg("\t", v[2], "\n" )
		Msg("\t", v[3], "\n" )
	end

	if GetConVarNumber("sv_cheats") != 1 then
		Msg("Sorry, cheats needs to be on to draw boxes")
	end

	ShowGMTALPHALocations()
end )

hook.Add("PostDrawOpaqueRenderables", "DrawDebugLoc", function(depth, sky)

	if sky then return end

	if not locDebug then return end



	local i, c = 0, table.Count(MapPositions)

	for k, v in pairs(MapPositions) do

		i = i + 1

		render.SetColorMaterial()

		local col = HSVToColor(360/c * i, 1, 1)

		col.a = 128

		render.DrawBox((v[2]+v[3])/2, Angle(), (v[2]+v[3])/2 - v[2], (v[2]+v[3])/2 - v[3], col, false)

		render.DrawBox((v[2]+v[3])/2, Angle(), - ((v[2]+v[3])/2 - v[2]), -((v[2]+v[3])/2 - v[3]), col, false)

		render.DrawWireframeBox((v[2]+v[3])/2, Angle(), - ((v[2]+v[3])/2 - v[2]), -((v[2]+v[3])/2 - v[3]), ColorAlpha(col, 64), true)

	end

end)