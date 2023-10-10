hook.Add("PostEntityTakeDamage", "PainSounds", function(e, dmg, took)
    if e:IsPlayer() && took then
		e.LastPainTime = e.LastPainTime or CurTime()
		if e.LastPainTime <= CurTime() then
			local d = dmg:GetDamage()
			if d >= e:Health() then return end
			local t = d > 40 and "Large" or d > 20 and "Medium" or "Small"
			if IsLobby and Dueling.IsDueling( e ) then return end
			voicelines.Emit(e, "Pain," .. t)
			e.LastPainTime = CurTime() + 1
		end
    end
end)

hook.Add("PlayerDeath", "PainSounds", function(ply)
	ply.LastPainTime = nil
    voicelines.Emit(ply, "Death")
end)

hook.Add("PlayerDeathSound", "PainSounds", function()
    return true
end)