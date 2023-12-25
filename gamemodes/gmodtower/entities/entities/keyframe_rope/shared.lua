ENT.Type = "anim"
ENT.Author = "Lead"

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "RopeMaterial")
    self:NetworkVar("Int", 0, "RopeWidth")
    self:NetworkVar("Int", 1, "RopeLength")
    self:NetworkVar("Vector", 0, "RopeStart")
    self:NetworkVar("Vector", 1, "RopeEnd")
end