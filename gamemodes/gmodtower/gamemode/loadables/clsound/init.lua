AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

module( "clsound", package.seeall )

function GetSoundID( snd )
    for k, v in ipairs( ClientSounds ) do
        if ( v:lower() == snd:lower() ) then
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

    // print( "[CLSound]", "Playing ID:", id, "|", ClientSounds[ id ], "in location:", Location.GetFriendlyName( loc ) )

    net.Start( "CLSound" )
        net.WriteEntity( self )
        net.WriteInt( id, 8 )
        net.WriteInt( vol or 0, 9 )
        net.WriteInt( pitch or 0, 9 )
    net.Send( Location.GetPlayersInLocation( loc ) )
end

function meta:EmitSoundToPlayer( ply, snd, vol, pitch )
    if ( not IsValid( ply ) ) then return end

    local id = GetSoundID( snd )
    if ( not id ) then return end

    net.Start( "CLSound" )
        net.WriteEntity( self )
        net.WriteInt( id, 8 )
        net.WriteInt( vol or 0, 9 )
        net.WriteInt( pitch or 0, 9 )
    net.Send( ply )
end

util.AddNetworkString( "CLSound" )