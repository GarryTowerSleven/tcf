if ( not vrmod ) then return end

hook.Add("PlayerCanPickupWeapon", "a", function(ply, wep)
    if wep:GetClass() == "weapon_vrmod_empty" then
        wep:Remove()
        return false
    end
end)

function vrmod.UsingEmptyHands(ply)
    return !IsValid(ply:GetActiveWeapon())
end