AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetSolid(SOLID_VPHYSICS)
    self:DrawShadow(false)

    local dist = {}

    for k,v in pairs( ents.FindByClass("gmt_condo_door") ) do
      table.insert(dist, { ( v:GetPos():Distance( self:GetPos() ) ), v } )
    end

    table.sort( dist, function(a,b) return a[1] < b[1] end)

    local closestDoor = dist[1][2]
    local ID = closestDoor:GetNWInt("CondoID")

    self:SetNWInt("condoID",(ID or 0))
	
	Location.Get(ID).DoorCam = self.Entity

end
