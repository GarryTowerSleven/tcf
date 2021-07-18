
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString( "CondoLightUpdate" )

function ENT:Initialize()
    self:SetModel( self.Model )
    self:SetSolid( SOLID_VPHYSICS )
    self:DrawShadow(false)
	
    self:SetLightColorR(255)
    self:SetLightColorG(255)
    self:SetLightColorB(255)
end

local IDS = {
  ["dim"] = 1,
  ["basement"] = 2
}

function ENT:Think()
    if self:GetNWInt("condoID") == 0 then
      local loc = Location.Find( self:GetPos() )
      self:SetNWInt( "condoID", loc-1 )
    end
end

function ENT:KeyValue( key, val )
    if key == "light" then
      self:SetLightID( IDS[val] )
    end
end

net.Receive( "CondoLightUpdate", function()

  local self = net.ReadEntity()
  local val = net.ReadUInt( 8 )

  local r = net.ReadUInt( 8 )
  local g =	net.ReadUInt( 8 )
  local b =	net.ReadUInt( 8 )

  self:SetLightColorR(r)
  self:SetLightColorG(g)
  self:SetLightColorB(b)

  self:SetLightValue(val/255)

end)