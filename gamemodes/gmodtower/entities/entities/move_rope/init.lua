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

    timer.Simple(1, function()
        if IsValid(self) then
            self:Remove()
        end
    end)
end

local keys = {
    Width = "RopeWidth",
    RopeMaterial = "RopeMaterial",
    StartOffset = "RopeStart",
    EndOffset = "RopeEnd",
    Slack = "RopeLength"
}

function ENT:KeyValue(key, value)
    if !IsValid(self.Rope) then
        self.Rope = ents.Create("keyframe_rope")
        self.Rope:SetPos(self:GetPos())
        self.Rope:Spawn()
    end

    if key == "NextKey" then
        timer.Simple(0.1, function()
            if IsValid(self) && IsValid(self.Rope) then
                local ent = ents.FindByName(value)[1]
                self.Rope:SetRopeStart(self:GetPos())
                self.Rope:SetRopeEnd(ent:GetPos())
            end
        end)
    end

    if keys[key] then
        self.Rope["Set" .. keys[key]](self.Rope, string.find(key, "Offset") && Vector(value) || tonumber(value) || value)
    end
end