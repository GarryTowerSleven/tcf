include("shared.lua")

local musicActive = false

gui.EnableScreenClicker( true )

hook.Add("Think","MusicThink",function()
	if !musicActive then
		musicActive = true
		surface.PlaySound("chickensong.mp3")
	end
end)

surface.CreateFont( "ChickenFont", {
	font = "Arial",
	extended = false,
	size = 48,
	weight = 1500,
})

surface.CreateFont( "ChickenFontSmall", {
	font = "Arial",
	extended = false,
	size = 24,
	weight = 1500,
})

hook.Add("PostDrawTranslucentRenderables","PlayerNames",function()
	for k,v in pairs( player.GetAll() ) do
		cam.Start3D2D(v:GetPos() + Vector(0,0,25),Angle(0,0,90),.2)
			draw.DrawText(v:Name(),"ChickenFont",0,0,Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
end)

hook.Add( "HUDPaint", "HUDText", function()
	draw.DrawText("CROSS THE ROAD!! (W TO MOVE!!!)","ChickenFont",ScrW()/2,ScrH()/4,Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER)
end)

hook.Add( "CalcView", "MyCalcView", function( ply, pos, angles, fov )
	local view = {
		origin = pos + Vector(0,-120,-30),
		angles = Angle(0,90,0),
		fov = 60,
		drawviewer = true
	}

	return view
end )
