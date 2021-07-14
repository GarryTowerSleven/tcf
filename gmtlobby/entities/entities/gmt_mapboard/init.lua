AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("MapBoardTeleport")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetSolid(SOLID_VPHYSICS)
end

function ENT:KeyValue(key,value)
    if key == "model" then
      self.Model = value
    end
end

local MapDestinations = {}
MapDestinations["Transit Station"] = { Vector(7126.890625,132.25148010254,-1087.96875), Angle(0,-90,0) }
MapDestinations["Tower Condos"] = { Vector(-2041.909058, 1270.038574, 15000.031250), Angle(0,0,0) }
MapDestinations["Gamemode Ports"] = { Vector(4733.1396484375,-5024.7153320313,-895.96875), Angle(0,0,0) }
MapDestinations["Theatre"] = { Vector(3841.5744628906,3586.1772460938,-895.96875), Angle(0,-133,0) }
MapDestinations["Tower Casino"] = { Vector(2404.8229980469,-10514.21875,-2623.96875), Angle(0,-90,0) }
MapDestinations["North Stores"] = { Vector(-179.2741394043,1159.744140625,-671.96875), Angle(0,-90,0) }
MapDestinations["South Stores"] = { Vector(-174.17324829102,-1154.1518554688,-671.96875), Angle(0,90,0) }
MapDestinations["Boardwalk"] = { Vector(-2513.4077148438,1.7793444395065,-895.96875), Angle(0,0,0) }
MapDestinations["Pulse Nightclub"] = { Vector(1536.000000,-5008.000000,-2624.000000), Angle(0,0,0) }
MapDestinations["Sweet Suites"] = { Vector(-1120.023560,-132.051636,-895.968750), Angle(0,90,0) }

MapDestinations["Unknown"] = { Vector(3310, 4112, -846), Angle(0,90,0) }

net.Receive("MapBoardTeleport",function( len, ply )
  local ent = net.ReadEntity()
  local Loc = net.ReadString()

  if IsValid(ent) && IsValid(ply) && MapDestinations[Loc] then
    net.Start("LoadingDoor")
    net.WriteEntity(ent)
    net.Send(ply)

    timer.Simple( (0.3) ,function()
      ply.UsingDoor = false

      local loc,ang = MapDestinations[Loc][1], MapDestinations[Loc][2]

      if ( ply.BallRaceBall && IsValid(ply.BallRaceBall) ) then
        ply.BallRaceBall:SetAngles(ang)
        ply:SetEyeAngles(ang)
        ply.BallRaceBall:SetPos( loc + Vector(0,0,35) )
      else
        ply:SetEyeAngles(ang)
        ply.DesiredPosition = loc
      end
    end)
  end

end)
