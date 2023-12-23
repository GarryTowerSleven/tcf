include("shared.lua")

local mats = {}
local light = {
    Material("effects/christmas_bulb"),
    Material("effects/christmas_bulb_up")
}
local pos_cache = {}
local ropes = {}

function ENT:Draw()
end

hook.Add("PostDrawTranslucentRenderables", "Rope", function()
    for _, rope in ipairs(ents.FindByClass("keyframe_rope")) do
        local mat = rope:GetRopeMaterial()
        mats[mat] = mats[mat] || Material(mat)
        local mat = mats[mat]
        local segs = 8
        local roof = rope:GetRopeStart():WithinAABox(Vector(100, 31, 1575), Vector(1678, 2249, 560))

        if !ropes[_] then
            ropes[_] = {}
            local startpos, endpos = rope:GetRopeStart(), rope:GetRopeEnd()
            local len = rope:GetRopeLength() / 2

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
                local lpos = LerpVector(l, rope:GetRopeStart(), rope:GetRopeEnd())
                lpos = lpos - Vector( 0, 0, (i == 1 || i == segs) && 0 || 64 )
                local lc = render.GetLightColor(lpos)

                table.insert(ropes[_], {i == 1 && startpos || i == segs && endpos || math.BSplinePoint(l, spline, 1), l, lc})
            end

        else
            local t = SysTime()
            render.StartBeam(segs)

            for _, pos in ipairs(ropes[_]) do
                render.AddBeam(pos[1], rope:GetRopeWidth(), pos[2], pos[3])
            end

            render.SetMaterial(mat)
            render.EndBeam()

            for _2, pos in ipairs(ropes[_]) do
                local endpos = ropes[_][_2 + 1]

                if endpos then
                    local segs2 = roof && 4 || (pos[1] - endpos[1]):Length() / 8

                    for i = 1, segs2 do
                        local seed = rope:EntIndex() .. _2 .. i
        
                        if !pos_cache[seed] then
                            local l = i / segs2
                            pos_cache[seed] = LerpVector(l, pos[1], endpos[1])
                        end

                        local s = roof && 3 || rope:GetRopeWidth()
                        local pos = pos_cache[seed]
                        local dist = pos:DistToSqr( EyePos() )

                        if !roof && dist > 1098304 * 2 then continue end

                        local ang = pos - EyePos()
                        local dot = EyeVector():Dot(ang) / ang:Length()

                        if dot <= 0 then continue end
                        // render.DrawSprite(pos, 24, 24, color_white)

                        if !roof && dist < 400080 then
                            local rot = 180 * ( math.fmod(math.floor(seed), 2) == 0 && 1 || 0 ) + util.SharedRandom(seed, -25, 25)
                            local ang = pos - EyePos()
                            ang = ang:Angle()
                            ang.p = 0
                            ang.r = 0
                            ang:RotateAroundAxis(ang:Up(), 180)
    
                            local color = HSVToColor(math.fmod(seed * 9999, 360), 1, math.fmod(math.floor(CurTime() + seed * 0.4), 2) == 0 && 0.2 || 1)
    
                            // render.DrawSprite( pos, 4, 8, color )
                            render.SetMaterial(light[2])
                            render.DrawQuadEasy(pos, ang:Forward(), s * 2, s * 8, HSVToColor(math.fmod(seed * 9999, 360), 1, math.fmod(math.floor(CurTime() + seed * 0.4), 2) == 0 && 0.2 || 1), rot)

                            continue
                        end

                        local color = HSVToColor(math.fmod(seed * 9999, 360), 1, math.fmod(math.floor(CurTime() + seed * 0.4), 2) == 0 && 0.2 || 1)
                        render.SetMaterial(light[roof && 1 || i % 2 == 1 && 1 || 2])
                        render.DrawSprite( pos, s * 2, s * 8, color )
                        //render.DrawQuadEasy(pos, ang:Forward(), s * 2, s * 8, HSVToColor(math.fmod(seed * 9999, 360), 1, math.fmod(math.floor(CurTime() + seed * 0.4), 2) == 0 && 0.2 || 1), rot)
                    end
                end
            end
        end
    end
end)