if ( not vrmod ) then return end

AddCSLuaFile("cl_hud.lua")

hook.Add("PlayerCanPickupWeapon", "a", function(ply, wep)
    if wep:GetClass() == "weapon_vrmod_empty" then
        wep:Remove()
        return false
    end
end)

function vrmod.UsingEmptyHands(ply)
    return !IsValid(ply:GetActiveWeapon())
end

local vrmod = vrmod

module("vr", package.seeall)

function InVR(ply)
    return vrmod.IsPlayerInVR(ply)
end