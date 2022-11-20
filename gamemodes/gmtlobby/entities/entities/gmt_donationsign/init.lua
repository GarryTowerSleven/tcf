AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("OpenDiscord")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetSolid(SOLID_VPHYSICS)
    self:DrawShadow(false)
    self:SetUseType(SIMPLE_USE)

    self:SetSubMaterial(3,"models/map_detail/deluxe_discord")
end

function ENT:Use(ply)
  net.Start("OpenDiscord")
  net.Send(ply)
end
