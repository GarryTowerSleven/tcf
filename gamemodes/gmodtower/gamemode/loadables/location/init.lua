AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "sh_meta.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )
include( "sh_meta.lua" )

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

        if ply._LastLocation != loc then
            ply._Location = loc
		    ply._LastLocation = loc

            ply:SetNWInt( "Location", loc )
            hook.Call( "Location", GAMEMODE, ply, loc, ply._LastLocation or 0 )
        end
    end
end )

local kickoutTime = 2
hook.Add( "Location", "KickOut", function( ply, loc )

    if ply:IsAdmin() then return end

    if loc != 0 then
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

util.AddNetworkString( "LocationRefresh" )