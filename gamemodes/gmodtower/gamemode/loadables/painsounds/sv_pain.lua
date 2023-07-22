hook.Add("EntityTakeDamage", "PainSounds", function(e, dmg)
    if e:IsPlayer() then
        local d = dmg:GetDamage()
        if d >= e:Health() then return end
        local t = d > 40 and "Large" or d > 20 and "Medium" or "Small"
        voicelines.Emit(e, "Pain," .. t)
    end
end)

hook.Add("PlayerDeath", "PainSounds", function(ply)
    voicelines.Emit(ply, "Death")
end)

hook.Add("PlayerDeathSound", "PainSounds", function()
    return true
end)