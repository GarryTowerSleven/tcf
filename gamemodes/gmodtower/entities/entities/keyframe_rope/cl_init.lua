include("shared.lua")

ENT.WantsTranslucency = true
local mats = {}
local light = {
    {
        Material("effects/christmas_bulb"),
        Material("effects/christmas_bulb2"),
        Material("effects/christmas_bulb3"),
    },
    {
        Material("effects/christmas_bulb_up"),
        Material("effects/christmas_bulb_up2"),
        Material("effects/christmas_bulb_up3"),
    }
}
local pos_cache = {}
local rot_cache = {}
local ropes = {}
local LastThink = 0

function ENT:Think()
    
    if self.Setup then return end

    self.Setup = true

    local startpos, endpos = self:GetRopeStart(), self:GetRopeEnd()

    local min = startpos
    local max = endpos - Vector( 0, 0, self:GetRopeLength() / 1.75 )

    local highz = startpos.z < endpos.z && endpos.z || startpos.z

    min.z = highz

    self:SetRenderBoundsWS( min, max )

end

hook.Add( "Think", "Ropes", function()
    if LastThink > CurTime() then return end

    for _, rope in ipairs(ents.FindByClass("keyframe_rope")) do
        rope.Setup = false
    end

    LastThink = CurTime() + 1
end)

function ENT:DrawTranslucent()
    local _ = self:EntIndex()

    if self:GetPos():DistToSqr(EyePos()) > ( 2048 * 2048 ) then return end

    local mat = self:GetRopeMaterial()
    mats[mat] = mats[mat] || Material(mat)
    local mat = mats[mat]
    local segs = 8
    local roof = self:GetRopeStart():WithinAABox(Vector(100, 31, 1575), Vector(1678, 2249, 560))

    if !ropes[_] then
        ropes[_] = {}
        local startpos, endpos = self:GetRopeStart(), self:GetRopeEnd()
        local len = self:GetRopeLength() / 2

        local add = endpos - startpos
        local spline = {
            startpos
        }

        for i = 1, segs do
            table.insert(spline, startpos + add * (i / segs) - Vector(0, 0, len * math.sin(i / segs * 3)))
        end

        table.insert(spline, endpoint)

        for i = 1, segs do
            local l = i == 1 && 0 || i / segs
            local lpos = LerpVector(l, self:GetRopeStart(), self:GetRopeEnd())
            lpos = lpos - Vector( 0, 0, (i == 1 || i == segs) && 0 || 64 )
            local lc = render.GetLightColor(lpos)

            table.insert(ropes[_], {i == 1 && startpos || i == segs && endpos || math.BSplinePoint(l, spline, 1), l, lc})
        end

    else
        local t = SysTime()
        render.StartBeam(segs)

        for _, pos in ipairs(ropes[_]) do
            render.AddBeam(pos[1], self:GetRopeWidth(), pos[2], pos[3])
        end

        render.SetMaterial(mat)
        render.EndBeam()

        local eyepos = EyePos()

        for _2, pos in ipairs(ropes[_]) do
            local endpos = ropes[_][_2 + 1]

            if endpos then
                local segs2 = (pos[1] - endpos[1]):Length() / ( roof && 24 || 8 )

                for i = 1, segs2 do
                    local seed = self:EntIndex() .. _2 .. i
    
                    if !pos_cache[seed] then
                        local l = i / segs2
                        pos_cache[seed] = LerpVector(l, pos[1], endpos[1])
                    end

                    local s = roof && 3 || self:GetRopeWidth()
                    local pos = pos_cache[seed]
                    local dist = pos:DistToSqr( eyepos )

                    if dist > 1098304 * ( roof && 4 || 2 ) then continue end

                    if !rot_cache[seed] then
                        local flip = seed % 2 == 1 && 2 || 1
                        local rand = util.SharedRandom( seed, 1, 3 )
                        rand = math.Round( rand )
                        rot_cache[seed] = {light[flip][rand], rand != 1}
                    end

                    local color = HSVToColor(math.fmod(seed * 9999, 360), 1, math.fmod(math.floor(CurTime() + seed * 0.4), 2) == 0 && 0.2 || 1)
                    local rand = rot_cache[seed]
                    render.SetMaterial(rand[1])
                    render.DrawSprite( pos, s * (rand[2] && 8 || 2), s * 8, color )
                    //render.DrawQuadEasy(pos, ang:Forward(), s * 2, s * 8, HSVToColor(math.fmod(seed * 9999, 360), 1, math.fmod(math.floor(CurTime() + seed * 0.4), 2) == 0 && 0.2 || 1), rot)
                end
            end
        end
    end
end