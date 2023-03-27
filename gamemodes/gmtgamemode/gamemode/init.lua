AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_load.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

hook.Add( "PlayerShouldTaunt", "DisableTaunts", function( ply )
  return false
end )