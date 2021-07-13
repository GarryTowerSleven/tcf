AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_appbase.lua")
AddCSLuaFile("sh_panelos.lua")
AddCSLuaFile("mp/shared.lua")
AddCSLuaFile("mp/cl_init.lua")
AddCSLuaFile("cl_graphics.lua")

include("shared.lua")
include("sh_appbase.lua")
include("sh_panelos.lua")
include("mp/shared.lua")

//util.AddNetworkString("gmt_update_skybox")

//timer.Create( "UpdateSkyboxes", 5, 0, function()
//  for k,v in pairs( player.GetHumans() ) do
//    if v.GRoom != nil then
//      SetGlobalInt( "condoSky" .. tostring(v.GRoom.Id), v:GetInfoNum("gmt_condoskybox",1) )
//    end
//  end
//end )

//net.Receive("gmt_update_skybox", function()
//  local ID = net.ReadInt(16)
//  local SkyID = net.ReadInt(16)
//
//  if ID && SkyID then
//    SetGlobalInt( "condoSky" .. tostring(ID), SkyID )
//  end
//
//end)
