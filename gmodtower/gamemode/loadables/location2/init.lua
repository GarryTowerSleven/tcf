AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "sh_meta.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )
include( "sh_meta.lua" )

local lastupdate = 0

hook.Add("Think", "GTowerLocation", function(ply)
    if lastupdate < CurTime() then
        for _, ply in ipairs( player.GetAll() ) do
            local PlyPlace = Location.Find( ply:GetPos() )
            local friendlyname = Location.GetFriendlyName( PlyPlace )

            if PlyPlace != ply.Location then
                ply.LastLocation = ply.Location
                ply.LocationName = friendlyname
                ply.Location = PlyPlace
                hook.Call("Location", GAMEMODE, ply, ply.Location)
            end
        end

        lastupdate = CurTime() + 0.1
    end
end)

local Player = FindMetaTable("Player")
if Player then
    function Player:LastLocation()
        return self._LastLocation
    end
end

local kickoutTime = 2
hook.Add( "Location", "KickOut", function( ply, loc )

    if ply:IsAdmin() then return end

    if loc != 1 then
        ply.OutOfBounds = false
        return
    end

    if !ply.OutOfBounds then
        ply:Msg2( T( "LocationIsNil", tostring( kickoutTime ) ), "exclamation" )
    end

    ply.OutOfBounds = true

    timer.Simple( kickoutTime, function()
        if ply.OutOfBounds then
		    ply:Spawn()
            ply.OutOfBounds = false
        end
    end)
	
end)