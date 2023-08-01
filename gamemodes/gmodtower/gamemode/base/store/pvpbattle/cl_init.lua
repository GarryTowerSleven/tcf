include("shared.lua")

module( "PVPBattle", package.seeall )

SelectedItems = SelectedItems or {}

function ReceiveWeapons( len )
    SelectedItems = net.ReadTable()
    hook.Run("PVPBattle.WeaponsUpdated" )
end

net.Receive( "PVPBattle.ClientLoadout", ReceiveWeapons )

function ReceiveStore( len )
    hook.Run( "PVPBattle.OpenStore", net.ReadFloat() )
end

net.Receive( "PVPBattle.OpenStore", ReceiveStore )
