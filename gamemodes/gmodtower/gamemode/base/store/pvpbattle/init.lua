AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")
include("sql.lua")

module( "PVPBattle", package.seeall )

function printweapons( ply, tbl )
    for k, v in pairs( tbl or ply._PVPLoadout ) do
        LogPrint( Format( "tbl[%s] = %s - %s", k, v, WeaponsIDs[v] ), nil, "PVPBattle.printweapons" )
    end
end

function SendToClient( ply )
    net.Start( "PVPBattle.ClientLoadout" )
        net.WriteTable( ply:PVPGetLoadout() )
    net.Send( ply )
end

function SetWeapons( ply, tbl )
    if ( DEBUG ) then
        LogPrint( "Setting weapons for " .. ply:Nick() .. "...", nil, "PVPBattle.SetWeapons" )
        printweapons( ply, tbl )
    end

    ply._PVPLoadout = tbl
    SendToClient( ply )
end

function GiveWeapons( ply )
    if ( DEBUG ) then
        LogPrint( "Giving weapons to " .. ply:Nick() .. "...", nil, "PVPBattle.GiveWeapons" )
    end

    local weps = {}

    for _, v in pairs( ply:PVPGetLoadout() ) do
		local classname = WeaponsIDs[ v ]

		if classname then
			ply:Give( classname )
			table.insert( weps, classname )
		end
	end

    if ( DEBUG ) then
        PrintTable( weps )
    end

	return weps
end

function Serialize( tbl )
    return util.TableToJSON( tbl ) or ""
end

function Deserialize( str )
    return util.JSONToTable( str ) or nil
end

function Load( ply, str )
    local loadout = Deserialize( str )
    if ( not loadout ) then
        if ( DEBUG ) then
            LogPrint( "Loadout Invalid for " .. ply:Nick() .. "! (" .. (str or "nil") .. ") Setting defaults...", nil, "PVPBattle.Load" )
        end
        loadout = DefaultWeapons
    end

    SetWeapons( ply, loadout )
end

function OpenStore( ply )
	GTowerStore:SendItemsOfStore( ply, StoreID )
	SendToClient( ply, true )

    net.Start( "PVPBattle.OpenStore" )
        net.WriteFloat(GTowerStore.Discount[StoreID] or 0)
    net.Send( ply )
end

util.AddNetworkString( "PVPBattle.ClientLoadout" )
util.AddNetworkString( "PVPBattle.OpenStore" )

// helpers if needed
local meta = FindMetaTable( "Player" )
if ( not meta ) then return end

function meta:PVPGetLoadout()
    return self._PVPLoadout or DefaultWeapons
end

function meta:PVPSetLoadout( tbl )
    SetWeapons( self, tbl )
end

function meta:PVPEquipLoadout()
    GiveWeapons( self )
end
