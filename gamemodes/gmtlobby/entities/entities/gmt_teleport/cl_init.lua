---------------------------------
include("shared.lua")

local rts = {}

hook.Add( "RenderScene", "Teleport", function()

    local w, h = ScrW(), ScrH()

    for _, teleport in ipairs( ents.FindByClass( "gmt_teleport" ) ) do
        
        if teleport then

            if !rts[teleport] then

                rts[teleport] = {
                    GetRenderTarget( "Teleport" .. teleport:EntIndex(), w / 2, h / 2 )
                }

                rts[teleport][2] = CreateMaterial( "Teleport" .. teleport:EntIndex(), "UnlitGeneric", {
                    ["$basetexture"] = rts[teleport][1]:GetName()
                })

            else

                cam.Start2D()

                render.PushRenderTarget( rts[teleport][1] )

                render.RenderView({
                    origin = teleport:GetRenderPos() + (LocalPlayer():GetPos() - teleport:GetPos()),
                    aspectratio = 128 / 128
                })

                render.PopRenderTarget()

                cam.End2D()

            end

        end

    end

end )

function ENT:Draw()
end

ENT.WantsTranslucency = true

function ENT:DrawTranslucent()

    render.SetColorMaterial()


    local ang = self:WorldSpaceCenter() - EyePos()
    ang = ang:Angle()
    ang:RotateAroundAxis( ang:Up(), -90 )

    ang = Angle( 0, ang.y, 0 )

    local pos = self:WorldSpaceCenter()
    local h = 128
    render.SetMaterial( rts[self][2] )
    render.DrawQuadEasy( self:GetPos() + Vector( 0, 0, h / 2 ), self:GetAngles():Forward(), 128, h, color_white, 180 )

end