DeriveGamemode("darkrp")

function InCondo(pos)
    return pos.z > 11000
end

function GM:SpawnMenuOpen()
    if !InCondo(LocalPlayer():GetPos()) then
        notification.AddLegacy("Building is only allowed in Condos!", NOTIFY_ERROR, 8)
        return false
    end

    return true
end

function GM:ContextMenuOpen()
    return false
end