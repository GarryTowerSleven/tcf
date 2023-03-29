include("shared.lua")
AddCSLuaFile("shared.lua")

function GM:PlayerSpawnProp(ply)
    return InCondo(ply:GetPos())
end