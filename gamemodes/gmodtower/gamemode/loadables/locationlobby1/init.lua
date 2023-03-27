AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "sh_meta.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )
include( "sh_meta.lua" )
include( "teleport.lua" )

local Player = FindMetaTable("Player")
if Player then
    function Player:LastLocation()
        return self._LastLocation
    end
end

hook.Add( "PlayerThink", "GTowerLocation", function()
    local players = player.GetAll()

    for _, ply in ipairs( players ) do
        local loc = Location.Find( ply:GetPos() + Vector(0,0,5) )

        if ply._Location != loc then
		    ply._LastLocation = ply._Location
            ply._Location = loc

            ply:SetNet( "Location", loc or 0 )
            hook.Call( "Location", GAMEMODE, ply, loc, ply._LastLocation or 0 )
        end
    end
end )