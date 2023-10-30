AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_load.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

hook.Add( "PlayerShouldTaunt", "DisableTaunts", function( ply )
    return false
end )

// FIXME: THIS NEEDS TO BE A MODULE!!!
records = records or {}

hook.Add("StartCommand", "Playback", function(ply, cmd)
    if ply:IsBot() then
        local playback = ply.Playback
        if !playback then return end

        ply.Start = ply.Start or CurTime()

        local cur
        local i = 0

        for _, a in pairs(playback) do
            if a.Time and a.Time - 0.1 < (CurTime() - ply.Start) then
                i = i + 1
                cur = a
            end
        end

        if !cur then
            ply:Kick("TERMINATED.")
            return
        end

        ply:SetEyeAngles(cur.Angles)
        cmd:SetButtons(cur.Buttons)
        cmd:SetForwardMove(cur.Move[1])
        cmd:SetSideMove(cur.Move[2])
        cmd:SelectWeapon(ply:GetWeapon(cur.Weapon))

    elseif ply.Recording then
         
        local buttons = cmd:GetButtons()
        local move1, move2 = cmd:GetForwardMove(), cmd:GetSideMove()
        local ang = ply:EyeAngles()

        ply:ChatPrint(buttons)

        local data = {
            Time = CurTime() - ply.Start,
            Move = {move1, move2},
            Angles = ang,
            Buttons = buttons,
            Weapon = ply:GetActiveWeapon():GetClass()
        }

        table.insert(ply.Record, data)
    end
end)

concommand.Add("StartRecord", function(ply)
    if !MACHINIMA then return end

    if ply.Recording then
        local i = table.insert(records, ply.Record)
        ply.Record = nil
        ply.Recording = nil
        ply:ChatPrint("RECORDED AT INDEX " .. i)

        return
    end

    ply.Recording = {}
    ply.Start = CurTime()
    ply.Record = {
        [0] = {
        Pos = ply.Ball and ply.Ball:GetPos() or ply:GetPos(),
        Team = ply:Team()
        }
    }
end)

concommand.Add("Playback", function(ply, _, args)
    local data = tonumber(args[1] or 0)
    data = records[data]

    if !data then return end

    local bot = player.CreateNextBot("PLAYBACK")
    bot:SetTeam(data[0].Team)
    bot:Freeze(true)
    bot:Spawn()

    timer.Simple(1, function()
        bot:SetPos(data[0].Pos)

        if bot.Ball then
            bot.Ball:SetPos(data[0].Pos)
        end

        bot:Freeze(false)
        bot.Playback = data
    end)
end)