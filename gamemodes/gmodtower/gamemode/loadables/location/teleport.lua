module("Location", package.seeall )

local function TestForEntity( ent, minp, maxp )

	if !IsValid( ent ) then
		return false
	end
	
	local min, max = ent:LocalToWorld( minp ), ent:LocalToWorld( maxp )
	local BoxList = ents.FindInBox( min, max )
		
	for _, ply in pairs( BoxList ) do
		
		if ply:IsPlayer() then
			return false
		end
		
	end
	
	return true
	
end

local function HookCall( ply, goplace )
	hook.Call("PlayerTeleport", GAMEMODE, ply, goplace )
end

local function GetBoundingBox( source, ply )
	if source then
		return source:WorldToLocal( ply:LocalToWorld( ply:OBBMins() ) ), source:WorldToLocal( ply:LocalToWorld( ply:OBBMaxs() ) )
	end
	
	return Vector( 13.3958, 20.8986, 3.0313 ), Vector(-3.9583, -20.8968, 75.0313 )
end

local function GetLocalPos( source, ply )
	if source then
		return source:WorldToLocal( ply:GetPos() )
	end
	return Vector( 4.7188, 0.0009, 3.0313 )
end

local function SetTeleportPlayer( ply, source, target )

	local pos = GetLocalPos( source, ply )
	local ang = target:GetAngles()
	
	ang.p = 0 //Make sure the player does not ger rotated
	ang.r = 0
	
	//source:EmitSound("ambient/levels/citadel/weapon_disintegrate2.wav", 60, 125)

	ply:SetPos( target:LocalToWorld( pos ) )
	ply:SetEyeAngles( ang )

	/*ply:ScreenFade(SCREENFADE.IN, Color(255, 255, 255, 25), 0.1, 0)
	timer.Simple( 0.05, function()
		target:EmitSound("ambient/levels/citadel/weapon_disintegrate2.wav", 60, 125)
	end )*/

	//MAC, I WANT THIS BACK - I love people getting confused
	//ply:SetEyeAngles( target:LocalToWorldAngles( ang ) )
end



function TeleportPlayer( ply, source, goplace )
	
	if DEBUG then
		Msg("Teleporting ", ply, " from ", source, " to ", goplace , "\n")
	end
	
	local Tbl = Location.TeleportLocations[ goplace ]

	if !Tbl then
		print("Could not find teleport place: " , goplace )
		return
	end
	
	ply:ExitDriving()
	
	local EntList = table.Copy( Tbl.ents )
	local min, max =  GetBoundingBox( source, ply )
	
	if EntList then
		while #EntList > 0 do
			local v = table.remove( EntList, math.random( 1, #EntList ) )
			
			if TestForEntity( v, min, max ) == true then
				SetTeleportPlayer( ply, source, v )
				HookCall( ply, goplace )
				return
			end
			
		end
	end
	
	local failsafe = Tbl.failpos
	
	if failsafe then
		HookCall( ply, goplace )
		ply:SetPos( failsafe )
		return
	end

end

function AddEnt( ent, place )

	if place == nil then
		Msg("No place found for ent: ", ent , "\n")
		return
	end

	local Tbl = Location.TeleportLocations[ place ]

	if !Tbl then
		Tbl = {"No place #" .. place, "MISSING PLACE " .. place, {} }
		Location.TeleportLocations[ place ] = Tbl
	end

	table.insert( Tbl.ents, ent )
	
end