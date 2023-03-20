AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )
include( "teleport.lua" )

local Player = FindMetaTable("Player")
if Player then
    function Player:LastLocation()
        return self._LastLocation
    end
end

local _LocationDelay = 1
local _LastLocationThink = CurTime() + _LocationDelay
hook.Add( "Think", "GTowerLocation", function()
    if ( CurTime() < _LastLocationThink ) then
        return
    end

    _LastLocationThink = CurTime() + _LocationDelay

    local players = player.GetAll()

    for _, ply in ipairs( players ) do
        local loc = Location.Find( ply:GetPos() + Vector(0,0,5) )

        if ply._Location != loc then
		    ply._LastLocation = ply._Location
            ply._Location = loc

            ply:SetNWInt( "Location", loc )
            hook.Call( "Location", GAMEMODE, ply, loc, ply._LastLocation or 0 )
        end
    end
end )