local m = FindMetaTable("Player")

function m:Taunt()
    return voicelines.Emit(self, "Taunts,Generic")
end

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