
-----------------------------------------------------
module("polygon", package.seeall)

local defaultNumVertexAttributes = 2

local Meta = {}
Meta.__index = Meta

function New(...)
	return setmetatable({}, Meta):Init(...)
end

function Meta:Init(vertexList, xform)
	self.verts = {}
	self.verts.numVertexAttributes = defaultNumVertexAttributes
	util.MakeTransformable2D(self)
	if xform then self:SetXForm(xform) end
	if vertexList then
		self.verts.numVertexAttributes = vertexList.numVertexAttributes
		self:AddVertices(vertexList)
	end
	return self
end

function Meta:NumVertexAttributes()
	return self.verts.numVertexAttributes
end

function Meta:EnableUV(bUV)
	self.verts = {}
	self.verts.numVertexAttributes = bUV and 4 or 2
	return self
end

function Meta:AddVertices(vertexList)
	for i=1, #vertexList do table.insert(self.verts, vertexList[i]) end
end

function Meta:AddVertex(x,y,u,v)
	table.insert(self.verts, x)
	table.insert(self.verts, y)
	if self:NumVertexAttributes() == 4 then
		if type(u) == "function" then
			local u,v = u(x,y)
			table.insert(self.verts, u or 0)
			table.insert(self.verts, v or 0)
		else
			table.insert(self.verts, u or 0)
			table.insert(self.verts, v or 0)
		end
	end
end

function Meta:GetBounds()
	local minx = 10000
	local miny = 10000
	local maxx = -10000
	local maxy = -10000

	local xform = self:GetTransform()
	local verts = self.verts
	local attributes = self:NumVertexAttributes()
	for i=1, #verts, attributes do
		local x,y = xform:Transform2(verts[i], verts[i+1])

		minx = (x < minx) and x or minx
		miny = (y < miny) and y or miny
		maxx = (x > maxx) and x or maxx
		maxy = (y > maxy) and y or maxy
	end

	return minx,miny,maxx,maxy
end

function Meta:Copy()
	return New(self.verts, self:GetXForm())
end

function Meta:Rect(w,h,center)
	w = center and (w/2) or w
	h = center and (h/2) or h

	if not center then
		self:AddVertex(0,0)
		self:AddVertex(w,0)
		self:AddVertex(w,h)
		self:AddVertex(0,h)
	else
		self:AddVertex(-w,-h)
		self:AddVertex(w,-h)
		self:AddVertex(w,h)
		self:AddVertex(-w,h)
	end

	return self

end

function Meta:Circle(radius,segs,start,range,tc)

	segs = segs or 30

	if range and range ~= 360 then self:AddVertex(0,0,tc) end

	start = math.rad( start or 0 )
	range = math.rad( range or 360 )
	radius = radius or 10

	local r = range / segs
	local x,y,t = math.cos(start) * radius, math.sin(start) * radius
	local rs,rc = math.sin(r), math.cos(r)

	for i=0, segs do
		self:AddVertex(x,y,tc)

		t = x
		x = x * rc + y * -rs
		y = t * rs + y * rc
	end

	return self

end

if not CLIENT then return end

local _white = Color(255,255,255)

function Meta:SetPreTransform( bPre )
	self.pretransform = bPre
end

function Meta:Render( color, outline, srcmtx, backCull, noAutoCull )

	local vec = Vector(0,0,0)
	local verts = self.verts
	local cfunc = type( color ) == "function"

	color = color or surface.GetDrawColor()
	backCull = backCull or false

	local mtx = self:GetTransform()
	if srcmtx then
		srcmtx = srcmtx * mtx
		mtx = srcmtx
	end

	if not noAutoCull then
		local xInv = mtx:GetField(1,1) < 0
		local yInv = mtx:GetField(2,2) < 0

		if (xInv and not yInv) or (yInv and not xInv) then backCull = not backCull end
	end

	if backCull then
		render.CullMode(MATERIAL_CULLMODE_CW)
	end

	local attributes = self:NumVertexAttributes()
	local uvenabled = attributes == 4

	if not uvenabled then render.SetColorMaterialIgnoreZ( ) end
	cam.PushModelMatrix( mtx, self.pretransform )

	mesh.Begin( outline and MATERIAL_LINE_LOOP or MATERIAL_POLYGON, ( #verts ) / attributes )

	local b,e = pcall( function()

		for i=1, #verts, attributes do

			vec.x = verts[i  ]
			vec.y = verts[i+1]
			vec.z = 0

			local u = uvenabled and verts[i+2] or vec.x*.1
			local v = uvenabled and verts[i+3] or vec.y*.1
			local c = cfunc and color( vec.x, vec.y ) or color

			mesh.Position( vec )
			mesh.Color( c.r, c.g, c.b, c.a )
			mesh.TexCoord( 0, u, v )
			mesh.AdvanceVertex()

		end

	end)

	mesh.End()

	cam.PopModelMatrix()

	if backCull then
		render.CullMode(MATERIAL_CULLMODE_CCW)
	end

	if not b then error(e) end

end

function Meta:Draw( ... )

	--cam.StartOrthoView( 0, 0, ScrW(), ScrH() )
	local b,e = pcall( self.Render, self, ... )
	--cam.EndOrthoView()

	if not b then error(e) end

end
