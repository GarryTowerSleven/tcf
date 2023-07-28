--

local meta = FindMetaTable("Player")

if !SM then
    SM = FindMetaTable("Entity").SetModel
end

GetModel = GetModel or FindMetaTable("Entity").GetModel

function meta:SetModel2(mdl, layer)
    if layer == 0 then
        return SM(self, mdl)
    end

    if layer == 1 then
        self:SetModel("models/player/kleiner.mdl", 0)
    end

    self:SetNWString("MDL" .. layer, mdl)
end

function meta:SetModel(mdl, layer)
    return self:SetModel2(mdl, layer or 1)
end

function meta:GetModel2(layer)
    return self:GetNWString("MDL" .. layer)
end

function meta:GetModel(layer)
    if layer == 0 then
        return GetModel(self)
    end

    return self:GetNWString("MDL" .. (layer || 1))
end