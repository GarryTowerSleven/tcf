DeriveGamemode("darkrp")

function InCondo(pos)
    return pos.z > 11000
end

function GM:SpawnMenuOpen()
    if !InCondo(LocalPlayer():GetPos()) then
        notification.AddLegacy("Build in a Condo, or find Building Supplies!", NOTIFY_ERROR, 8)
        return false
    end

    return true
end

function GM:ContextMenuOpen()
    return false
end

ACHIEVEMENTS = {}
ACHIEVEMENTS.AddAchievement = function() end

local meta = FindMetaTable("Player")
local meta2 = FindMetaTable("Entity")

meta.AddAchievement = function() end

string.FormatNumber = string.Comma

meta.Afford = meta.canAfford

meta.AddMoney = meta.addMoney

meta.MsgI = function(self, _, msg)
    self:ChatPrint(msg)
end

meta.Location = function()
    return 0
end

meta.GetCondoID = function()
    return 0
end

meta2.GetCondoID = function()
    return 0
end

local meta3 = FindMetaTable("Vector")
meta3.WithinDistance = function() end

Location = {}
Location.Find = function() end
Location.GetCondoID = function() return 0 end
Location.Is = function() return 0 end
Location.Get = function() return end

GtowerRooms = {}
GtowerRooms.Get = function() return end

local meta = FindMetaTable("Entity")
local plyMeta = FindMetaTable("Player")

local ownableDoors = {
    ["func_door"] = true,
    ["func_door_rotating"] = true,
    ["prop_door_rotating"] = true,
    ["gmt_condo_door"] = true
}
local unOwnableDoors = {
    ["func_door"] = true,
    ["func_door_rotating"] = true,
    ["prop_door_rotating"] = true,
    ["func_movelinear"] = true,
    ["prop_dynamic"] = true,
    ["gmt_condo_door"] = true
}
function meta:isKeysOwnable()
    if not IsValid(self) then return false end

    local class = self:GetClass()

    if (ownableDoors[class] or
            (GAMEMODE.Config.allowvehicleowning and self:IsVehicle() and (not IsValid(self:GetParent()) or not self:GetParent():IsVehicle()))) then
        return true
    end

    return false
end

function meta:isDoor()
    local class = self:GetClass()

    if unOwnableDoors[class] then
        return true
    end

    return false
end

hook.Add("getDoorCost", "test", function(ent)
    return 100
end)