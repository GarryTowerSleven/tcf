surface.CreateFont( "ChangelogItem", { font = "Oswald", size = 24, weight = 400 } )

local progress
local CurPage
local SwipeOffset = Vector( 0, 0, 0 )
local SwipeOffsetNum = 0
local CanSwipe = false
local NewPageArriving = false

local HasRequestedChangelog = false

function GetChangelog()
    http.Fetch( "https://www.gmodtower.org/apps/changelog.json",
    function( body, len, headers, code )
        Changelog = util.JSONToTable(body)
    end,
    function( error )
			timer.Simple(30,function()
				GetChangelog()
			end)
    end
    )
end

local mat = Material( "gmod_tower/nightclub/bar_gradient" )
local mat2 = Material( "gmod_tower/nightclub/panel_mountains" )

local pos = Vector( 7511, 172.5, -967 )
local ang = Angle( 180, 90, -90 )
local scale = 1

hook.Add( "PostDrawOpaqueRenderables", "ChangeLog", function()

	if !Changelog && !HasRequestedChangelog then
		HasRequestedChangelog = true
		GetChangelog()
	end

	if !LocalPlayer():GetPos():WithinDistance(pos, 2500) then return end

	local wave = math.sin( CurTime() * 2 ) * 16

	local x,y = 515, 125

	cam.Start3D2D( pos, ang, scale )

		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )

		surface.SetMaterial(mat)
		surface.DrawTexturedRect(0, 0, x, y)

		surface.SetDrawColor( Color( 255, 255, 255, 125  ) )

		surface.SetMaterial(mat2)
		surface.DrawTexturedRect(0, 0, x, y)

		surface.SetDrawColor( Color(25,25,25,125 + wave) )
		surface.DrawRect(0, 0, x, y)

	cam.End3D2D()

	local pos = Vector( "7511 122.5 -967" )
	local scale = 0.25

	cam.Start3D2D( pos, ang, scale )

		// Title
		-----------------
		draw.DrawText("GMod Tower: Deluxe Changelog",
		"GTowerSkyMsgSmall",
		-125,
		0,
		Color( 255, 255, 255, 255 ),
		TEXT_ALIGN_LEFT)

		// Date
		-----------------
		local date
		if Changelog then date = Changelog["date"] else date = "Unknown" end
		draw.DrawText(date,
		"GTowerSkyMsgSmall",
		1100,
		0,
		Color( 255, 255, 255, 255 ),
		TEXT_ALIGN_RIGHT)

	cam.End3D2D()

	if !Changelog then
		cam.Start3D2D( pos, ang, 0.2 )
			draw.DrawText("The changelog is currently unavailable...",
			"GTowerSkyMsg",
			625,
			200,
			Color( 255, 255, 255, 255 ),
			TEXT_ALIGN_CENTER)
			cam.End3D2D()
		return
	end

	cam.Start3D2D( pos + SwipeOffset, ang, scale )

		// Backdrop
		-----------------
		surface.SetDrawColor( Color( 25, 25, 25, 125 ) )
		surface.DrawRect( -125, 70, 1225, 350 )

		// Progress bar
		-----------------
		surface.SetDrawColor( Color( 25, 25, 25, 200 ) )
		surface.DrawRect( -125, 70 + 350, 1225, 15 )

		surface.SetDrawColor( Color( 225, 225, 225, 200 ) )

		if !progress then progress = 0 end

		if !CurPage then CurPage = 1 end

		// Progress bar is full
		if progress > 1225 then
			// NEXT PAGE

			// Increases the swipe offset
			SwipeOffsetNum = SwipeOffsetNum - FrameTime() * 120

			// Panel is outside screen, teleport it back
			if SwipeOffsetNum < -350 then
				CanSwipe = true
				SwipeOffsetNum = SwipeOffsetNum + 700

				// Change page, end of pages? Loop back.
				if CurPage != #Changelog then CurPage = CurPage + 1 else CurPage = 1 end
				NewPageArriving = true
			end

			// Back to normal state after done swiping.
			if CanSwipe && SwipeOffsetNum < 0 then
				CanSwipe = false
				progress = 0
				NewPageArriving = false
			end

			SwipeOffset.y = SwipeOffsetNum

		elseif #Changelog > 1 then
			progress = progress + FrameTime() * 15
		end

		if !NewPageArriving then
			surface.DrawRect( -125, 70 + 350, progress, 15 )
		end

		// Title
		-----------------
		surface.SetTextColor( Color( 255, 255, 255, 255 ) )
		surface.SetFont("GTowerSkyMsgSmall")
		surface.SetTextPos(-100, 75)

		surface.DrawText( Changelog[ CurPage ][1] )

		// Items
		-----------------

		local str = ""

		for k,v in pairs( Changelog ) do

			if k != CurPage then continue end

			for num, item in pairs( v ) do
				if num == 1 then continue end

				// Adds newline every so many characters
				item = (item):gsub(("."):rep(175),"%1\n")

				str = str .. "• " .. item .. "\n"
			end
		end

		draw.DrawText(str,
		"ChangelogItem",
		-100, 145,
		Color( 255, 255, 255, 255 ),
		TEXT_ALIGN_LEFT)

		draw.DrawText( tostring( CurPage ) .. "/" .. tostring( #Changelog ) ,
		"GTowerSkyMsgSmall",
		1075, 355,
		Color( 255, 255, 255, 255 ),
		TEXT_ALIGN_RIGHT)

	cam.End3D2D()

end )