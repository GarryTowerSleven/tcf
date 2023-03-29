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

Items = {
    ["ITEM_PISTOL"] = {
        Name = "Pistol",
        Description = "Painful firearm!!!!!!!!!!!!!!!!!!",
        Model = "models/weapons/w_pistol.mdl"
    }
}

function GetItem(name)
    local item = table.Copy(Items[name])
    return item
end

function meta:GiveItem(item)
    local empty

    for i = 1, #self.Inventory do
        for i2 = 1, #self.Inventory[1] do
            if !self.Inventory[i][i2].Name and (empty and empty[2] == 1 or !empty) then
                empty = {i, i2}
            end
        end
    end

    if empty then
        local item = GetItem(item)
        self.Inventory[empty[1]][empty[2]] = item
        self:SendInventory()
    end
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

net.Receive("Inventory", function(_, ply)
    local msg = net.ReadInt(8)

    if msg == 1 then
        local t = net.ReadTable()
        local item = ply.Inventory[t[1]][t[2]]
        ply.Inventory[t[1]][t[2]] = ply.Inventory[t[3]][t[4]]
        ply.Inventory[t[3]][t[4]] = item
    end

    ply:SendInventory()

end)