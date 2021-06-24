AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_passenger.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:Initialize()
  self:SetModel(self.Model)
  self:SetNoDraw(true)
end

local meta = FindMetaTable( "Player" )

function meta:GetClientBranch()
  return self.ClientBranch
end

net.Receive( "CLIENTBRANCH", function( len, ply )
  ply.ClientBranch = net.ReadString()
end )

util.AddNetworkString( "CLIENTBRANCH" )
