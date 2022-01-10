GTower = {}

function GTower:Kick( kicked, kicker, reason )
    if !kicked || !kicker then return end
    if !reason then
        reason = "No reason given."
    end

    AdminNotif.SendStaff( kicker:Nick() .. " has kicked " .. kicked:NickID() .. " for reason: " .. reason, 15, "RED" )

    if !kicker:IsSecretAdmin() then
        reason = "Kicked by " .. kicker:Nick() .. " | Reason: " .. reason
    else
        reason = "Kicked by staff | Reason: " .. reason
    end

    kicked:Kick( reason )
end

concommand.Add("gmt_kick", function( ply, cmd, args )
    if !ply:IsStaff() then return end

    local kicked, kicker, reason
    local kicker = ply
    if args[1] && IsValid(ents.GetByIndex(args[1])) && ents.GetByIndex(args[1]):IsPlayer() then
        kicked = ents.GetByIndex(args[1])
    else
        return
    end
    if !ply:IsAdmin() && kicked:IsStaff() then
        AdminNotif.Send( ply, "You do not have permission to kick " .. kicked:Nick() .. ".", nil, "RED" )
        return
    end
    if !args[2] then
        reason = "No reason given."
    else
        reason = args[2]
    end

    GTower:Kick( kicked, kicker, reason )
end)

function GTower:Ban( banned, length, banner, reason )
    if !banned || !banner then return end
    if !length then
        length = 0 // perm ban
    end
    if !reason then
        reason = "No reason given."
    end

    local rawReason = reason

    // For user's ban reason
    bannerName = banner:Nick()
    if banner:IsSecretAdmin() then
        bannerName = "staff"
    end

    if length == 0 then
        AdminNotif.SendStaff( banner:Nick() .. " has BANNED " .. banned:NickID() .. " PERMANENTLY for reason: " .. reason, 30, "RED" )
        
        reason = "Banned permanently by " .. bannerName .. " | Reason: " .. reason
    else
        local readableLength = string.NiceTimeLong(length)
        AdminNotif.SendStaff( banner:Nick() .. " has BANNED " .. banned:NickID() .. " for ".. readableLength .." for reason: " .. reason, 30, "RED" )
        reason = "Banned for " .. readableLength .. " by " .. bannerName .. " | Reason: " .. reason
    end

    gateKeep:AddBan( banned:SteamID(), banned:Nick(), banned:IPAddress(), rawReason, length )
    GTower:Kick( banned, banner, reason )
end

concommand.Add("gmt_ban", function( ply, cmd, args )
    if !ply:IsStaff() then return end

    local banned, length, banner, reason
    local banner = ply
    if args[1] && IsValid(ents.GetByIndex(args[1])) && ents.GetByIndex(args[1]):IsPlayer() then
        banned = ents.GetByIndex(args[1])
    else
        return
    end
    if !ply:IsAdmin() && banned:IsStaff() then
        AdminNotif.Send( ply, "You do not have permission to ban " .. banned:Nick() .. ".", nil, "RED" )
        return
    end
    if !args[2] || (args[2] && !tonumber(args[2])) then
        length = 0
    else
        length = tonumber(args[2])
    end
    if !args[3] then
        reason = "No reason given."
    else
        reason = args[3]
    end

    GTower:Ban( banned, length, banner, reason )
end)