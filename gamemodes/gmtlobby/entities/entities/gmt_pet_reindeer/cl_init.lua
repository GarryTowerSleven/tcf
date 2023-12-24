
include("shared.lua")

CreateClientConVar( "gmt_petname_rndr", "", true, true )

function ENT:Draw()



	self:DrawModel()

end

local mat = Material( "sprites/glow04_noz" )

ENT.WantsTranslucency = true

function ENT:DrawTranslucent()


	local ang = EyeAngles()

	local pos, ang2 = self:GetBonePosition(1)



	ang:RotateAroundAxis( ang:Forward(), 90 )

	ang:RotateAroundAxis( ang:Right(), 90 )



	pos.z = pos.z + 20



	cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.05 )



		if self:GetPetName() and self:GetPetName() != "" then

			self:DrawText( self:GetPetName(), "PetName", 0, 0, 255, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		end



	cam.End3D2D()


        if self:GetPetName() == "Rudolph" then
            
            render.SetColorMaterial()
            render.DrawSphere( pos + ang2:Up() * 16 - ang2:Right() * 14, 2, 8, 4, Color( 255, 0, 0, 128 ) )
            render.SetMaterial( mat )
            render.DrawSprite( pos + ang2:Up() * 16 - ang2:Right() * 16, 16, 16, Color( 255, 0, 0 ) )

        end

end


function ENT:DrawText( text, font, x, y, alpha, xalign, yalign )



	if !text then return end



	draw.DrawText( text, font, x + 1, y + 1, Color( 0, 0, 0, alpha ), xalign, yalign )

	draw.DrawText( text, font, x, y, Color( 255, 255, 255, alpha ), xalign, yalign )



end