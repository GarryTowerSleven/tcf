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

net.Receive( "LocationRefresh", function( len, pl )
	local loc = net.ReadInt(10)
	local lastloc = net.ReadInt(10)
	pl._Location = loc
	pl._LastLocation = lastloc
	pl:SetNWInt( "Location", loc )
	hook.Call( "Location", GAMEMODE, pl, loc )
end )

/*local kickoutTime = 2
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
	
end)*/

util.AddNetworkString( "LocationRefresh" )