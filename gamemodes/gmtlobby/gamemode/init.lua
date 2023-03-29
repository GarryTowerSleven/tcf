include("shared.lua")
AddCSLuaFile("shared.lua")

function GM:PlayerSpawnProp(ply)
    return InCondo(ply:GetPos())
end

local meta = FindMetaTable("Player")

util.AddNetworkString("Inventory")

function meta:SendInventory()
    net.Start("Inventory")
    net.WriteTable(self.Inventory)
    net.Send(self)
end

function GM:PlayerSpawn(ply)
    ply.Inventory = {}
    for i = 1, 9 do
        ply.Inventory[i] = {}

        for i2 = 1, 5 do
            ply.Inventory[i][i2] = {}
        end
    end
    ply:SendInventory()
    GAMEMODE:PlayerLoadout(ply)
end