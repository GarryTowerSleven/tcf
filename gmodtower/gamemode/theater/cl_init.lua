---------------------------------
-- Chat colors
ColDefault = Color( 200, 200, 200 )
ColHighlight = Color( 158, 37, 33 )

include( 'shared.lua' )

--[[---------------------------------------------------------
	Name: Theater Exterior 3D2D
	Desc: Draws a 3D2D outside which displays the current playing videos.
-----------------------------------------------------------]]

local screenPositions = {
	[1] = Vector(4110, 2677.75, -615),
	[2] = Vector(4607.75, 2677.75, -615)
}

local marquees = {}

for k,v in pairs(screenPositions) do
	local marq = marquee.New( 38, 0.1 )
	marq.Index = math.random( 1, 3 )

	function marq:Draw( text, x, y )
		draw.SimpleText( text, "poker_jackpot_1", x, y, Color( 255, 255, 255, 255 ), 1 )
	end

	marquees[k] = marq

end

surface.CreateFont( "TheaterExteriorBig", {
	font = "Roboto",
	size = 48,
	weight = 800
})

surface.CreateFont( "TheaterExterior", {
	font = "Roboto",
	size = 30,
	weight = 800
})

local LoadedMaterials = {}
local OldThumbnails = {}
local ThumbnailMaterials = {}

local TheaterStatic  = Material("theater/static")

local function GetThumbnail(theater)
	ZThumbnail = GetGlobalString( "CurVideoThumbnail" .. theater, "theater/static" )

	thumbnail_width, thumbnail_height = 325, 325

	if (ZThumbnail != "theater/static" and ZThumbnail != OldThumbnails[theater]) then
		OldThumbnails[theater] = ZThumbnail
		LoadedMaterials[theater] = false

		local ytIMG = "https://i.ytimg.com/vi/" .. ZThumbnail .. "/mqdefault.jpg"

		WebMat.Get(ytIMG, function(material, url)
			ThumbnailMaterials[theater] = material
			LoadedMaterials[theater] = true
		end, 320, 180)

	elseif ZThumbnail == "theater/static" then
		OldThumbnails[theater] = nil
		LoadedMaterials[theater] = false
	end
end

local function DrawThumbnail(theater)
	surface.SetDrawColor(0, 0, 0, 255)
		if LoadedMaterials[theater] then
			surface.SetMaterial(ThumbnailMaterials[theater])
			surface.DrawTexturedRectUV(0, 50, thumbnail_width, thumbnail_height, 0, 0, 0.6, 1)
		else
			surface.SetMaterial(TheaterStatic)
			surface.DrawTexturedRect(0, 0, thumbnail_width, thumbnail_height)
		end

		// Header
		surface.SetDrawColor(20, 20, 20, 255)
		surface.DrawRect(0, 0, 325, 50)

		draw.DrawText("Theater #" .. theater, "TheaterExteriorBig", thumbnail_width/2, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)

		local CurVideo = GetGlobalString( "CurVideo" .. theater, "No Video Playing" )

		if CurVideo == "No Video Playing" then
			return
		end

		// Footer
		surface.SetDrawColor(20, 20, 20, 255)
		surface.DrawRect(0, 278, 325, 50)

		//draw.DrawText(CurVideo, "TheaterExterior", thumbnail_width/2, thumbnail_height-37.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)

		marquees[theater]:SetPos( thumbnail_width/2, thumbnail_height-37.5 )
		marquees[theater]:SetData( {CurVideo} )

		render.ClearStencil()
    render.SetStencilEnable(true)

    render.SetStencilFailOperation(STENCILOPERATION_KEEP)
    render.SetStencilZFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
    render.SetStencilReferenceValue(1)

    surface.DrawRect(0, 278, 325, 50)

    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)

    -- Drawing screen stuff
		marquee.Draw( marquees[theater] )

    render.SetStencilEnable(false)

end

hook.Add("PostDrawOpaqueRenderables", "TheaterExterior3D2D", function(b, sky)
	-- Let's not draw this in the sky
	if sky or !IsLobby() then return end

	for k, pos in pairs(screenPositions) do
		if LocalPlayer():GetPos():WithinDistance(pos, 5000) then
			GetThumbnail(k)

			cam.Start3D2D(pos, Angle(0, 0, 90), 0.25)
				DrawThumbnail(k)
			cam.End3D2D()
		end
	end

end)
