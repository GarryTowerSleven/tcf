local m = FindMetaTable("Player")

function m:Taunt()
    if !self:Alive() or !self.LastKillTime or (self.LastKillTime + 5) < CurTime() then return end
    self.LastKillTime = nil
    return voicelines.Emit(self, "Taunts,Kill")
end

hook.Add("EntityTakeDamage", "LetsAllowATaunt", function(e, dmg)
    if e:IsPlayer() && dmg:GetDamage() >= e:Health() && e != dmg:GetAttacker() then
        dmg:GetAttacker().LastKillTime = CurTime()
    end
end)

hook.Add( "PlayerDeath", "GlobalDeathMessage", function( victim, inflictor, attacker )
    if self.LastKillTime then
        self.LastKillTime = nil
    end
end )

util.AddNetworkString("Taunt")
net.Receive("Taunt", function(_, ply)
    ply:Taunt()
end)

concommand.Add("taunt", function(ply)
    ply:Taunt()
end)