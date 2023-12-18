include("shared.lua")

local mats = {}
local light = Material("effects/christmas_bulb")
local vis = {}
local pos_cache = {}

hook.Add("PostDrawTranslucentRenderables", "Rope", function()
    for _, rope in ipairs(ents.FindByClass("keyframe_rope")) do
        local mat = rope:GetRopeMaterial()
        mats[mat] = mats[mat] || Material(mat)
        local mat = mats[mat]
        local startpos, endpos = rope:GetRopeStart(), rope:GetRopeEnd()
        local segs = 4
        local len = rope:GetRopeLength() / 2

        render.StartBeam(segs)

        for i = 1, segs do
            local l = i == 1 && 0 || i / segs
            local lpos = LerpVector(l, rope:GetRopeStart(), rope:GetRopeEnd())
            lpos = lpos - Vector( 0, 0, (i == 1 || i == segs) && 0 || len )

            local lc = render.GetLightColor(lpos)


            render.AddBeam(lpos, rope:GetRopeWidth(), l, lc:ToColor())
        end

        render.SetMaterial(mat)
        render.EndBeam()

        local s = rope:GetRopeWidth()
        local segs2 = (rope:GetRopeStart() - rope:GetRopeEnd()):Length() / 128

        for i = 1, segs - 1 do
            for i2 = 1, segs2 - (i == segs - 1 && 1 || 0) do
                local seed = i2 + i * 64 + rope:EntIndex() * 128

                render.SetMaterial(light)

                if !pos_cache[seed] then
                    local l = i == 1 && 0 || i / segs
                    local l2 = i2 / segs2
                    local pos = LerpVector(l, rope:GetRopeStart(), rope:GetRopeEnd()) - LerpVector((i == 1 || i == 4) && 0 || 1, vector_origin, Vector( 0, 0, len ))
                    pos = LerpVector(l2, pos, LerpVector((i + 1) / segs, rope:GetRopeStart(), rope:GetRopeEnd()) - LerpVector((i + 1 == 4) && 0 || 1, vector_origin, Vector( 0, 0, len )))
                    pos_cache[seed] = pos
                end

                local pos = pos_cache[seed]
                local ang = pos - EyePos()
                local dot = EyeVector():Dot(ang) / ang:Length()

                if dot <= 0 then continue end
                // render.DrawSprite(pos, 24, 24, color_white)

                local rot = 180 * ( math.fmod(seed, 2) == 0 && 1 || 0 ) + util.SharedRandom(seed, -25, 25)
                local ang = pos - EyePos()
                ang = ang:Angle()
                ang.p = 0
                ang.r = 0
                ang:RotateAroundAxis(ang:Up(), 180)

                render.DrawQuadEasy(pos, ang:Forward(), s * 2, s * 8, HSVToColor(math.fmod(seed * 9999, 360), 1, math.fmod(math.floor(CurTime() + seed * 0.4), 2) == 0 && 0.2 || 1), rot)
            end

        end
    end
end)