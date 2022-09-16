
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

util.AddNetworkString( "gmt_boss" )

concommand.Add( "gmt_startboss", function( ply )

  if !ply:IsAdmin() then return end

  net.Start("gmt_boss")
  net.Broadcast()

  BossEntity = ents.Create("gmt_boss_ai")
  BossEntity:SetPos(Vector("2693.066650 -0.110434 -190.466278"))
  BossEntity:Spawn()

end )
