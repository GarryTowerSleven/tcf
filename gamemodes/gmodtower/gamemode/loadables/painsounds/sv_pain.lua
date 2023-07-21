hook.Add("EntityTakeDamage", "PainSounds", function(e, dmg)
    if e:IsPlayer() then
        local d = dmg:GetDamage()
        local t = d > 40 and "Large" or d > 20 and "Medium" or "Small"
        voicelines.Emit(e, "Pain," .. t)
    end
end)