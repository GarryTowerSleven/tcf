include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_icons.lua")
AddCSLuaFile("cl_draw.lua")

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
    ["pistol"] = {
        Name = "Pistol",
        Description = "Painful firearm!!!!!!!!!!!!!!!!!!",
        Model = "models/weapons/w_pistol.mdl",
        Weapon = "weapon_pistol"
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

    ply:ScreenFade(SCREENFADE.IN, color_black, 1, 2)
    ply:EmitSound("gmodtower/lobby/elevator/elevator_bell.wav")
    ply:EmitSound("gmodtower/lobby/elevator/elevator_doorclose.wav")
    ply:EmitSound("gmodtower/lobby/elevator/elevator_arrive.wav")
    // ply:EmitSound("gmodtower/lobby/condo/vault_close.wav")

    timer.Simple(1.8, function()
        ply:ViewPunch(Angle(-4, 0, 0))
    end)

    for i = 1, 9 do
        ply.Inventory[i] = {}

        for i2 = 1, 5 do
            ply.Inventory[i][i2] = {}
        end
    end

    ply:SendInventory()
    // GAMEMODE:PlayerLoadout(ply)
    self.BaseClass.PlayerSpawn(self, ply)
end

net.Receive("Inventory", function(_, ply)
    local msg = net.ReadInt(8)

    if msg == 1 then
        local t = net.ReadTable()
        local item = ply.Inventory[t[1]][t[2]]
        ply.Inventory[t[1]][t[2]] = ply.Inventory[t[3]][t[4]]
        ply.Inventory[t[3]][t[4]] = item
    elseif msg == 2 then
        local class = IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() or ""
        ply:StripWeapons()
        local xy = net.ReadTable()
        local x, y = xy[1], xy[2]
        print(xy, x, y)
        local item = ply.Inventory[x] and ply.Inventory[x][y]
        if !item then return end
        print(item)
        if !item.Weapon then return end
        print("?")
        if class == item.Weapon then return end
        print(item.Weapon)
        ply:Give(item.Weapon)
        ply:SelectWeapon(ply:GetWeapon(item.Weapon))
    end

    ply:SendInventory()

end)