AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_meta.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("minecraft_skin_updated")
util.AddNetworkString("minecraft_send_updates")

net.Receive("minecraft_skin_updated", function(len, ply)

  local skin = net.ReadString()

  ply:SetNWString( "MinecraftSkin", skin )

  net.Start( "minecraft_send_updates" )
    net.WriteInt( ply:EntIndex(), 16 )
  net.Broadcast()

end )

hook.Add( "PlayerInitialSpawn", "JoinMCSkin", function(ply)
  timer.Simple(10,function()
    if IsValid(ply) && ply:GetModel() == mcmdl then
      local skin = ply:GetInfo("cl_minecraftskin")
      ply:SetNWString("MinecraftSkin",skin)
      net.Start( "minecraft_send_updates" )
        net.WriteInt( ply:EntIndex(), 16 )
      net.Broadcast()
    end
  end)
end)
