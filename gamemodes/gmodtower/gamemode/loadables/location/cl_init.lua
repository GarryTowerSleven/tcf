include("shared.lua")
include( "sh_meta.lua" )

module("Location", package.seeall )

TheaterDrawPlayers = CreateClientConVar( "gmt_theater_drawplayers", 1, true, false )

hook.Add( "Think", "GTowerLocationClient", function()

	if LocalPlayer():IsBot() then return end
	
	if !TheaterDrawPlayers:GetBool() && LocalPlayer()._Location == Location.GetIDByName( "Theater" ) then
		print("Lets hide people!")
		for k,v in ipairs(player.GetAll()) do
			if v != LocalPlayer() then
				v:SetNoDrawAll(true)
			end
		end
	else
		for k,v in ipairs(player.GetAll()) do
			if v._WasLocalBlocked == false then
				v:SetNoDrawAll(false)
			end
		end
	end
	
	local PlyPlace = Find( LocalPlayer():GetPos() + Vector(0,0,5) )

	if LocalPlayer()._Location != PlyPlace then

		hook.Call("Location", GAMEMODE, LocalPlayer(), PlyPlace, LocalPlayer()._LastLocation or 0 )
		LocalPlayer()._LastLocation = LocalPlayer()._Location
		LocalPlayer()._Location = PlyPlace

	end

end )

DebugEnabled = CreateClientConVar( "gmt_admin_locations", "0", false, false )
DebugLocStart = nil
DebugLocEnd = nil

// we use this so that the bottom of a box will be lower than the player's position
FootOffset = Vector( 0, 0, -5 )

/*
	Location editing utilities
	
	These two concommands are designed to simplify location creation.
	Simply run gmt_loc_start, move to create a desired box, then run gmt_loc_end and grab the lua printed to the console.
	This requires you to be an admin!
*/

concommand.Add( "gmt_loc_start", function( ply, cmd, args )
	if !ply:IsAdmin() then return end
	
	DebugLocStart = LocalPlayer():GetPos() + FootOffset
	
	hook.Add( "PostDrawTranslucentRenderables", "PhxDebugLocation", function()
		Debug3D.DrawBox( DebugLocStart, LocalPlayer():GetPos() )
	end	)
	
end )

concommand.Add( "gmt_loc_end", function ( ply, cmd, args )
	if !ply:IsAdmin() then return end
	
	DebugLocEnd = LocalPlayer():GetPos() + FootOffset
	hook.Remove( "PostDrawTranslucentRenderables", "PhxDebugLocation" )
	
	local min = DebugLocStart
	local max = DebugLocEnd
	
	if ( min:Length() > max:Length() ) then
		local temp = min
		min = max
		max = temp
	end
	
	OrderVectors( min, max )
	
	MsgN( "====LOCATION CREATED====" )
	MsgN( "Add( ID, NAME, Vector( " .. min.x .. ", " .. min.y .. ", " .. min.z .. " ), Vector( " .. max.x .. ", " .. max.y .. ", " .. max.z .. " ) \n" )
	
end )

hook.Add( "PostDrawTranslucentRenderables", "GMTDebugLocations", function()

	if ( !DebugEnabled:GetBool() ) || ( !LocalPlayer():IsAdmin() && !LocalPlayer():IsDeveloper() ) then return end

	for id, loc in pairs( Locations ) do
	
		local center = ( loc.Min + loc.Max ) / 2

		// Mix up the color a bit so we can see different boxes easier
		local color = Color( 255, 0, 0 )
		local color2 = Color( 255, 0, 255 )

		if id % 2 == 0 then
			color = color2
		end
		
		Debug3D.DrawBox( loc.Min, loc.Max, color )
		Debug3D.DrawText( center, id .. " - " .. GetName( id ), "Default" )

	end
	
end )