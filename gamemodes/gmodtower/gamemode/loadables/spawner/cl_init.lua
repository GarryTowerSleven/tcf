include( "shared.lua" )

module( "Spawner", package.seeall )

surface.CreateFont( "CandyFont", { font = "AlphaFridgeMagnets ", size = 48, weight = 500 } )

function DrawHUDCandy()

	// draw candy text
	local candy = LocalPlayer():GetNet( "Candy", 0 )
	if candy <= 0 then return end

	candy = "Candy: " .. candy

	local tx, ty = ( ScrW() - 100 ), ( ScrH() - 100 )
	draw.SimpleText( candy, "CandyFont", tx + 2, ty + 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
	draw.SimpleText( candy, "CandyFont", tx, ty, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

end

hook.Add( "GTowerHUDPaint", "DrawCandy", function()

	DrawHUDCandy()

end )