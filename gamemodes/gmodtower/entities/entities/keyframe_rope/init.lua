AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    if CLIENT then
        self:SetRenderBounds( -Vector(-2048, -2048, -2048), Vector( 2048, 2048, 2048 ) )
        return
    end
    self:SetMaterial( "null" )
    self:DrawShadow( false )
end

local keys = {
    Width = "RopeWidth",
    RopeMaterial = "RopeMaterial",
    StartOffset = "RopeStart",
    EndOffset = "RopeEnd",
    Slack = "RopeLength"
}

function ENT:KeyValue(key, value)
    if keys[key] then
        self["Set" .. keys[key]](self, string.find(key, "Offset") && Vector(value) || value)
    end

    if key == "Length" then
        self:SetRopeLength(tonumber(value) - (self:GetRopeStart() - self:GetRopeEnd()):Length())
    end
end