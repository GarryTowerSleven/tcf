AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
include("teleport.lua")
module("Location", package.seeall)
local lastupdate = 0

hook.Add("Think", "GTowerLocation", function(ply)
    if lastupdate < CurTime() then
        for _, ply in ipairs(player.GetAll()) do
            local PlyPlace = Location.Find(ply:GetPos())

            if PlyPlace != ply.Location then
                ply.LastLocation = ply.Location
                ply.Location = PlyPlace
                hook.Call("Location", GAMEMODE, ply, ply.Location)
            end
        end

        lastupdate = CurTime() + 0.1
    end
end)

/* We'll fix later since there's no players anyway lol */
//hook.Add("PlayerCanHearPlayersVoice", "GMTBarTalk", function(listener, talker) 
//	local group = talker:GetGroup() --Maybe i should add some check if groups module turned on?
//	if group then return end
//	if (listener:Location() == 39 and talker:Location() == 39) or (listener:Location() == 40 and talker:Location() == 40) then
//		return true
//	end
//end)
function LocationRP(pos)
    local rp = RecipientFilter()

    for _, v in pairs(player.GetAll()) do
        if v:Location() == pos then
            rp:AddPlayer(v)
        end
    end

    return rp
end

RP = LocationRP //Alias to get RP
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