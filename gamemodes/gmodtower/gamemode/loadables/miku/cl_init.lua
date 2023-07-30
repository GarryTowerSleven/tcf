include("shared.lua")

local ENT = {}

ENT.Type = "anim"

function ENT:IsHidden()
    return self.Visible
end

function ENT:Name()
    return "Hatsune Miku"
end

function ENT:Ping()
    return math.random(666, 667)
end

function ENT:IsMuted()
    return false
end

function ENT:GetRespectName()
    return math.random(4) == 1 and "GOD" or "dead"
end

function ENT:IsBot()
    return true
end

function ENT:IsAdmin()
    return false
end

function ENT:GetNet()
    return false
end

function ENT:IsModerator()
    return false
end

function ENT:Think()
    // Rendering
    self:SetRenderFX(15)
    self:SetRenderMode(RENDERMODE_TRANSALPHA)

    if self.Visible then
        self:SetSubMaterial()
        PrintTable(self:GetMaterials())


        for i = 0, 24 do
            self:SetSubMaterial(i, "models/debug/debugwhite")
        end
        
        for i = 2, 4 do
            self:SetSubMaterial(i)
        end

        self:SetMaterial()

        if math.random(3) == 1 and (!self.VisibleTime or self.VisibleTime + 400 < CurTime()) then
        self.VisibleTime = CurTime()
        end
    else
        self:SetSolid(SOLID_NONE)
        self:SetMaterial()
    end

    if CLIENT then
        
        if math.random(999) == 1 && (!self.LastSight or self.LastSight < CurTime()) then
            self.Visible = true
            self.LastSight = CurTime() + (player.GetCount() < 4 and math.random(3, 8) or math.random(3, 300))
            timer.Simple(0.1, function()
                self.Visible = false
            end)
        end

        if !self.Visible then
        self:SetSequence(math.random(1000))
    for i = 0, self:GetBoneCount() - 1 do
        self:ManipulateBoneAngles(i, AngleRand() * 0.1)
        self:ManipulateBonePosition(i, VectorRand() * 0.01 + Vector(0, math.sin(CurTime() * 8) * 2, 0))
    end
end

    local head = self:LookupBone("ValveBiped.Bip01_Head1")

    if head then
        local pos = self:GetBonePosition(head)
        local a = (LocalPlayer():EyePos() - pos):Angle()
        a:RotateAroundAxis(a:Right(), 90)
        a:RotateAroundAxis(a:Forward(), 90)
        self:SetBonePosition(head, self:GetPos() + Vector(0, 0, 64), a)
    end
        
        return end
end

local m = Material("models/debug/debugwhite")

function ENT:Draw()
    self.Pos = self.Pos or {}
    m:SetVector("$color2", Vector(0, 0, 0))
    render.SetBlend(1.9)
    if self.Visible then
    self:DrawModel()
    end
    render.RenderFlashlights( function() self:DrawModel() end)
    render.SetBlend(1)
    m:SetVector("$color2", Vector(1, 1, 1))
end

hook.Add("PreDrawHalos", "a", function()
    local v = {}
    for _, m in ipairs(ents.FindByClass("miku")) do
        table.insert(v, m)
    end
    halo.Add(v, Color(0, 0, 0), 0, 0, 2, true, false)
    halo.Add(v, Color(0, 0, 0), 2, 2, 2, false, false)
end)

scripted_ents.Register(ENT, "miku")