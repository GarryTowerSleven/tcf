
-----------------------------------------------------
include('shared.lua')



ENT.RenderGroup = RENDERGROUP_TRANSLUCENT


local Cursor2D = surface.GetTextureID( "cursor/cursor_default.vtf" )

surface.CreateFont( "MapLabelSmall", {

	font      = "Clear Sans Medium",

	size      = 24,

	weight    = 800,

	antialias = true

})



surface.CreateFont( "SelectMapLabel", {

	font      = "Clear Sans Medium",

	size      = 40,

	weight    = 800,

	antialias = true

})



ENT.ModelInfo = {

	["default"] = {

		doubleSided = false,

		size = {128,128},

		res = {1706,853},

		scr_offset_local = Vector(0,0,0),

		scr_rotate_local = Angle(0,0,0),

	},

	["models/map_detail/billboard.mdl"] = {

		doubleSided = false,

		size = {121,63.45},

		res = {1706,853},

		scr_offset_local = Vector(.35,-0.01,70.43),

		scr_rotate_local = Angle(0,90,0),

	},

	["models/map_detail/station_billboard.mdl"] = {

		doubleSided = true,

		front = {

			size = {136,77},

			res = {1706,853},

			scr_offset_local = Vector(1.1,0,85.1),

			scr_rotate_local = Angle(0,90,0),

		},

		back = {

			size = {136,77},

			res = {1706,853},

			scr_offset_local = Vector(1.1,0,85.1),

			scr_rotate_local = Angle(0,-90,0),

		}

	}

}



function ENT:GetModelInfo()

	local id = self:GetModel()

	return self.ModelInfo[ id ] or self.ModelInfo[ "default" ]

end



function ENT:Initialize()



	--self:SetRenderBounds( Vector( 0, 75, 0 ), Vector( 0, -75, 125 ) )


	self:SetupScreen()

	self:InitXML()



end



function ENT:TranslateID(id)

	return string.gsub(id, "_", " ")

end



function ENT:Teleport(locationstring)

	net.Start("MapBoardTeleport")

		net.WriteEntity(self.Entity)

		net.WriteString(locationstring)

	net.SendToServer()

end



local UI_SCALE = 0.074

local MAX_USE_DIST = 80



function ENT:MakeScreen( info )

	local ang = self:GetAngles()

	local pos = self:GetPos()

	ang:RotateAroundAxis(Vector(0,0,1), info.scr_rotate_local.y)

	ang:RotateAroundAxis(ang:Right(), info.scr_rotate_local.p)

	ang:RotateAroundAxis(ang:Forward(), info.scr_rotate_local.r)

	pos = pos + ang:Forward() * info.scr_offset_local.x

	pos = pos + ang:Right() * info.scr_offset_local.y

	pos = pos + ang:Up() * info.scr_offset_local.z



	local screen = screen.New()					--create 3D2D screen

	screen:SetPos(pos)							--center of screen

	screen:SetAngles(ang)						--forward angle

	screen:SetSize( unpack(info.size) )			--screen size

	screen:SetRes( unpack(info.res) ) 			--document size

	screen:AddToScene(false)					--for callback support (false means don't automatically draw)

	screen:SetMaxDist(128)						--max distance a player can use

	screen:SetCull(true)						--only use/draw from front

	screen:EnableInput(true)					--use input callbacks

	screen:TrapMouseButtons(true)				--trap the mouse buttons

	screen:SetDrawFunc(							--2D draw function

		function(scr,w,h) self:Draw2D(scr,w,h) end

	)



	screen.OnMousePressed = function(screen, id)

		if id == 1 then self:ButtonPress() end

	end



	return screen

end



function ENT:SetupScreen()

	local info = self:GetModelInfo()

	self.screens = {}



	if info.doubleSided then

		table.insert( self.screens, self:MakeScreen( info.back ) )

		table.insert( self.screens, self:MakeScreen( info.front ) )

	else

		table.insert( self.screens, self:MakeScreen( info ) )

	end

end



function ENT:DrawTranslucent()

	self:DrawModel()


	if !LocalPlayer():GetPos():WithinDistance(self:GetPos(), 1000) then return end

	self.screen = nil


	for k,v in pairs( self.screens ) do

		if v:CanUse() then

			self.screen = v

		end

		v:Draw()

	end



	if not self.screen then self.btnfade = 0 return end



end



function ENT:Draw2D(scr,w,h)

	local mx, my, vis = scr:GetMouse()

	local b = 10

	surface.SetDrawColor(Color(255,255,255,25))

	surface.DrawRect(b,0,w-b,b)

	surface.DrawRect(0,0,b,h-b)

	surface.DrawRect(0,h-b,w-b,b)

	surface.DrawRect(w-b,b,b,h-b)



	//draw.SimpleText(":" .. self:EntIndex(), "SelectMapLabel", 5 + b, 5 + b)



	self:CheckMapButtons(mx,my)

	self:DrawMap(scr,mx,my,w,h)

	self:DrawCursor(mx,my)



end



function ENT:CheckMapButtons(mx,my)

	--self.selectedButton = nil

	//draw.SimpleText( math.Round( mx ) .. ", " .. math.Round( my ), "SelectMapLabel", mx + 10, my + 10, Color( 255, 0, 255 ) )

	self.buttonOver = false

	self.Loc = nil

	for k,v in pairs(self.rects) do

		local pos = self:TranslateID( k )

		pos = self.Lookup[ pos ][1]



		if pos:WithinDistance( LocalPlayer():GetPos(), 500 ) then

			self.Loc = {v, self:TranslateID(k), self.DrawMapRect}

		elseif mx > v.x and mx < v.x + v.w and my > v.y and my < v.y + v.h then

			self.selectedButton = {v, self:TranslateID(k), self.DrawMapRect}

			self.buttonOver = true

		end

	end



	local q = Vec2(mx, my)

	for k,v in pairs(self.polys) do

		for _,points in pairs(v.polys) do

			local pos = self.Lookup[ self:TranslateID( k ) ][1]

			if pos:WithinDistance( LocalPlayer():GetPos(), 500 ) then

				self.Loc = {v, self:TranslateID(k), self.DrawMapPoly}

			elseif shape2D.isInsideConvex(points, q) then

				self.selectedButton = {v, self:TranslateID(k), self.DrawMapPoly}

				self.buttonOver = true

			end

		end

	end

end



function ENT:DrawMapRect( scr, rect )

	surface.DrawRect( rect.x, rect.y, rect.w, rect.h )

end



function ENT:DrawMapPoly( scr, poly )

	local c = Color(255,100,100)

	for _,obj in pairs(poly.shape) do

		--surface.DrawPoly( points )

		obj:Draw(nil, false, scr.mtx2, true, true)

	end

end



local youarehere = surface.GetTextureID( "gmod_tower/ui/youarehere" )



function ENT:DrawMap(scr,mx,my,w,h)



	local fadeRate = 5

	self.btnfade = self.btnfade or 0



	local fg = Color(255,255,255,255 * self.btnfade)

	local bg = Color(0,0,0,35 * self.btnfade)

	if self.Loc then



		local btn = self.Loc

		local sin = math.sin( CurTime() * 5 ) * 50 + 75

		surface.SetDrawColor( 0, 200, 0, sin )

		btn[3]( self, scr, btn[1] )

		local cx,cy

		if btn[1].x then

			cx = btn[1].x + btn[1].w / 2

			cy = btn[1].y + btn[1].h / 2

		else

			cx = self.center[table.KeyFromValue( self.polys, btn[1] )][1]

			cy = self.center[table.KeyFromValue( self.polys, btn[1] )][2]

		end



		local size = 64

		sin = math.sin( CurTime() * 5 ) * 5

		surface.SetTexture( youarehere )

		surface.SetDrawColor(255,255,255,255)

		surface.DrawTexturedRect( cx-size/2, cy-size/2-30 + sin, size, size )



	end



	if self.selectedButton then

		local btn = self.selectedButton

		surface.SetDrawColor(Color(255,255,255,100 * self.btnfade))

		btn[3](self, scr, btn[1])

	end



	--For testing alignment

--[[surface.SetDrawColor(Color(255,255,100,80))

	for k,v in pairs(self.rects) do

		self:DrawMapRect( scr, v )

	end



	for k,v in pairs(self.polys) do

		self:DrawMapPoly( scr, v )

	end


	surface.SetDrawColor(Color(0,0,0,170 * self.btnfade))

	surface.DrawRect( 0,0,w,h )
]]


	if self.selectedButton then

		local btn = self.selectedButton
		surface.SetFont("MapLabelSmall")
		btnsize1 = surface.GetTextSize( "GO TO")

		local manglebet = {
			"╜","▓","ì","╛","φ","ï","₧","←",
			"≥","╜","╔","ƒ","Ω","‼","┌","÷",
			"¢","¿","�","￼","Ë","?","ß","█",
			"▄","©","ÿ"
		}
		local buttonMangle = function()
			local s = ""
			for i=1, 4 do s = s .. manglebet[ math.random(1, #manglebet ) ] end
			return s
		end

		local btntext = btn[2]
		while btntext == "Unknown" do
			btntext = buttonMangle()
		end

		surface.SetFont("SelectMapLabel")
		btnsize2 = surface.GetTextSize(btntext)

		draw.SimpleTextOutlined(
			"GO TO",
			"MapLabelSmall",
			mx-(btnsize1/2),
			my-30,
			fg,
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_TOP,
			2,
			bg
		)

		draw.SimpleTextOutlined(
			btntext,
			"SelectMapLabel",
			mx-(btnsize2/2),
			my,
			fg,
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_TOP,
			2,
			bg )
	end



	if self.buttonOver then

		self.btnfade = math.min(self.btnfade + FrameTime()*fadeRate, 1)

	else

		self.btnfade = math.max(self.btnfade - FrameTime()*fadeRate, 0)

	end



end



function ENT:ButtonPress()

	if self.buttonOver then self:Teleport(self.selectedButton[2]) end

end



hook.Add( "PlayerBindPress", "PlayerMapboardUse", function( ply, bind, pressed )



	local ent = ply:GetEyeTrace().Entity


	if IsValid( ent ) and ent:GetClass() == "gmt_mapboard" then



		if bind == "+use" and pressed then

			if ent.ButtonPress then

				ent:ButtonPress()

			end

		end



	end



end )



function ENT:DrawCursor(mx,my)

	local cursorSize = 32

	surface.SetDrawColor(Color(255,255,255,255))

	surface.SetTexture( Cursor2D )

	local offset = cursorSize / 2

	surface.DrawTexturedRect( mx - offset + 4, my - offset + 9, cursorSize, cursorSize )



	--surface.SetDrawColor(Color(255,0,0,255))

	--surface.DrawRect(mx-1,my-1,2,2)

end



function ENT:MakePolygons(t_polygons)

	local shape = {}

	for key, poly in pairs( t_polygons ) do

		local obj = polygon.New()

		for _, vert in pairs( poly ) do

			obj:AddVertex( vert.x, vert.y )

		end

		table.insert(shape, obj)

	end

	return shape

end



function ENT:InitXML()

	local XMLStr = [[

	<g id="Foohy Nightclub">
		<rect x="656" y="468" fill="#6A8CBA" width="53" height="25"/>
	</g>
	<g id="Theatre">
		<polygon fill-rule="evenodd" clip-rule="evenodd" cx="862" cy="78" fill="#6A8CBA" points="774,51 774,110 807,110 807,204 838,204 
			838,216 889,216 889,204 919,204 919,110 952,110 952,51 952,52			"/>
	</g>
	<g id="South_Stores">
		<rect x="551" y="467.866" fill="#6ABA6C" width="105" height="51.134"/>
	</g>
	<g id="North_Stores">
		<rect x="551" y="240" fill="#6ABA6C" width="105" height="51.134"/>
	</g>
	<g id="Tower Condos">
		<rect x="969" y="284" fill="#6A8CBA" width="191" height="192"/>
	</g>
	<g id="Transit Station">
		<rect x="909" y="363" fill="#6A8CBA" width="36" height="33"/>
	</g>
	<g id="Tower Casino">
		<rect x="656" y="493" fill="#6A8CBA" width="117" height="77"/>
	</g>
	<g id="Gamemode Ports">
		<polygon fill-rule="evenodd" clip-rule="evenodd" fill="#6A8CBA" cx="860" cy="666" points="945,613 945,570 901.844,545 817,545 773.844,570 
			773,570 773,613 681,613 681,806 1037,806 1037,613 			"/>
	</g>
	<g id="Boardwalk">
		<rect x="149" y="178" fill="#6A8CBA" width="314" height="341"/>
	</g>
	<g id="Sweet Suites">
		<polygon fill-rule="evenodd" clip-rule="evenodd" fill="#6ABA6C" cx="465" cy="385" points="485,413 465,433 465,468 485,468 551,468 551,413" />
	</g>

	<g id="Arcade">
		<rect x="690" y="187" fill="#6A8CBA" width="85" height="70"/>
	</g>
	<g id="Trivia">
		<rect x="690" y="257" fill="#6A8CBA" width="30" height="35"/>
	</g>
	<g id="Tower Garden">
		<rect x="969" y="187" fill="#6A8CBA" width="138" height="100"/>
	</g>
	<g id="Smoothie Bar">
		<rect x="463" y="289" fill="#6A8CBA" width="85" height="38"/>
	</g>
	<g id="Basical's Goods">
		<rect x="463" y="325" fill="#6A8CBA" width="85" height="20"/>
	</g>

	]]



	--[[

	<g id="Rect_General">

		<rect x="1264.118" y="592.938" fill="#6A8CBA" width="32" height="32"/>

	</g>

	<g id="Rect_Entertainment">

		<rect x="1264.118" y="638.938" fill="#996ABA" width="32" height="32"/>

	</g>

	<g id="Rect_Shopping">

		<rect x="1264.118" y="685.938" fill="#6ABA6C" width="32" height="32"/>

	</g>

	]]



	local parser = xml.Parser()

	local graphic = parser:ParseXmlText(XMLStr)



	local function fillColor(str)

		local n = tonumber(string.sub(str,2,string.len(str)), 16)

		return Color(

			bit.band(bit.rshift(n, 16), 0xFF),

			bit.band(bit.rshift(n, 8), 0xFF),

			bit.band(n, 0xFF)

		)

	end



	self.rects = {}

	self.polys = {}

	self.center = {}



	--local xform = Matrix()

	--xform:Translate(Vector(-4,-3,0))

	--xform:Scale(Vector(0.961,1.008,1.0))



	for k,v in pairs(graphic.g) do

		if v.rect then

			local r = v.rect

			local x = tonumber(r["@x"])

			local y = tonumber(r["@y"])

			local w = tonumber(r["@width"])

			local h = tonumber(r["@height"])

			local fill = r["@fill"]



			--x,y = xform:Transform2(x,y,1)

			--w,h = xform:Transform2(w,h,0)

			--print("Rect: " .. tostring(v.rect) .. " : " .. tostring(v.rect["@fill"]))

			self.rects[v["@id"]] = { c = fillColor(fill), x = x, y = y, w = w, h = h }

		end

		if v.polygon then

			local p = v.polygon

			local points = p["@points"]

			local fill = p["@fill"]



			local vpoints = {}

			local p = {}



	        value = string.gsub(points, "[+-]?[%d%.]+,[+-]?[%d%.]+",

	        function(h)

	        	local x = tonumber(string.match(h, "[%d%.]+"))

	        	local y = tonumber(string.match(h, "[%d%.]+", string.len(x)+1))

	        	--x,y = xform:Transform2(x,y,1)

	        	table.insert(vpoints, 1, Vec2(x,y))

	        end)



	        local b,e = pcall(shape2D.SplitConvex, vpoints)



	        if not b then

	        	print(v["@id"] .. " : " .. e)

	        	p.polys = {vpoints}

	        else

	        	p.polys = e

	        end



	        p.shape = self:MakePolygons( p.polys )



	        p.points = vpoints

	        p.c = fillColor(fill)



	        self.polys[v["@id"]] = p

	    	self.center[v["@id"]] = { ( tonumber( v.polygon["@cx"] ) or 0 ), ( tonumber( v.polygon["@cy"] ) or 0 ) }

		end

	end

end
