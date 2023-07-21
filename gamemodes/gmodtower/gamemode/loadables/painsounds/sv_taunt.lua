local m = FindMetaTable("Player")

function m:Taunt()
    if !self.LastKillTime or self.LastKillTime + 8 < CurTime() then return end
    return voicelines.Emit(self, "Taunts,Kill")
end

hook.Add("EntityTakeDamage", "a", function(e, dmg)
    if dmg:GetDamage() >= e:Health() then
        dmg:GetAttacker().LastKillTIme = CurTime() + 8
    end
end)

function GM:CanUndo(ply)
    print("!")
end

util.AddNetworkString("Taunt")
net.Receive("Taunt", function(_, ply)
    ply:Taunt()
end)

concommand.Add("taunt", function(ply)
    ply:Taunt()
end)