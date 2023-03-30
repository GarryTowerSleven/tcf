AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

module( "clsound", package.seeall )

function GetSoundID( snd )
    for k, v in ipairs( ClientSounds ) do
        if ( v == snd ) then
            return k
        end
    end

    return nil
end

local meta = FindMetaTable( "Entity" )
if !meta then return end

function meta:EmitSoundInLocation( snd, vol, pitch )
	local loc = self:Location()
    if ( not loc or loc < 0 ) then return end

    local id = GetSoundID( snd )
    if ( not id ) then return end

    net.Start( "CLSound" )
        net.WriteEntity( self )
        net.WriteInt( id, 8 )
        net.WriteInt( vol, 9 )
        net.WriteInt( pitch, 9 )
    net.Send( Location.GetPlayersInLocation( loc ) )
end

util.AddNetworkString( "CLSound" )