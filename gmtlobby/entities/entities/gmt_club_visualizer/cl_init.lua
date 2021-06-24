
-----------------------------------------------------
include( "shared.lua" )
include("queue.lua")
-- Visualizer settings
ENT.Resolution = 24 -- The number of frequencies to sample from (eg. 10 would have 10 bars on the bar graph)

-- The number of segments along the histogram
-- This is 1/6 the number of actual polygons there will be, so don't set it too high
ENT.Tesselation = 15

-- The speed that the histogram moves through the uv
ENT.HistogramSpeed = 1

-- Multiplier for how bright the dynamic light should be
ENT.DynamicLightIntensity = 50

-- The base amount of light intensity
ENT.DynamicLightBaseIntensity = 2

-- The sensitivity of the background behind the pulse mesh thing
ENT.PulseBackgroundSensitivity = 7

-- Should we draw the dynamic light?
local DrawDynLightConvar = CreateClientConVar("gmt_club_dlight", "0", true, false)
local ShouldDrawDynamicLight = DrawDynLightConvar and DrawDynLightConvar:GetBool()

-- The amount of vertical blur applied to the visualizer
-- Adds a nice motion blur effect
local BlurAmount = 6

local RTSize = 256
local RTex = GetRenderTarget("GMTClubVisualizer", RTSize, RTSize)
local MeshMaterial = CreateMaterial( "GMTClubVisualizerMaterial", "VertexLitGeneric",
{
	["$basetexture"] = "GMTClubVisualizer",
	["$selfillum"] = 1,

} )
local whiteTex = surface.GetTextureID( "models/debug/debugwhite" )
local errorMaterial = Material("models/debug/debugwhite")

function ENT:Initialize()
	self.TotalAverage = 0
	self.PulseVertices = {}
end

function ENT:Draw()

	-- Draw the visualizer mesh
	self:DrawVisualizer(self.Stream)

end

function ENT:AdvancePulsePoints( newPointSize )
	-- Create our points list as necessary
	self.PulseQueue = self.PulseQueue or queue.create()

	-- Push it to the top
	self.PulseQueue:Push(newPointSize)

	-- Pop the last one out
	if self.PulseQueue.Count > self.Tesselation then
		self.PulseQueue:Pop()
	end

end

function ENT:AdjustMeshOffsets()

	local Controller = self:GetOwner()

	-- The number of seconds between each point
	local segmentTimeInterval = 1 / (self.Tesselation * self.HistogramSpeed )

	-- This is pretty required yo
	if not self.LastPulseMove then self.LastPulseMove = RealTime() end

	-- Store the change in time since we were last run
	local pulseMoveDT = (RealTime()-self.LastPulseMove)

	-- The intensity of the thing
	local size = 1
	if IsValidController(Controller ) then
		Controller:SetSmoothAmount("bass", 25)
		size = Controller:GetSmoothedAverage("bass", true) * 160 + 1
	end

	-- If the last time we rendered we're more than one point's distance behind
	-- Advance ourselves until we're about on time
	if pulseMoveDT > segmentTimeInterval then
		local advanceCount = math.floor(pulseMoveDT/segmentTimeInterval)

		for i=1, advanceCount do
			self:AdvancePulsePoints(size)
		end

		-- Set the time we last did a thunk
		self.LastPulseMove = RealTime()
	elseif self.PulseQueue.Count > 0 then
		-- If we're not updating the points, always keep the first point updated
		-- With the newest bass value
		self.PulseQueue:Set(self.PulseQueue.Count, size)
	end

	-- Advance the physical mesh to make up for the remainder
	self.MeshTimeOffset = pulseMoveDT % segmentTimeInterval

	self.MeshTimeOffset = self.MeshTimeOffset * self.HistogramSpeed * RTSize
end

function ENT:PulseThink()

	-- Create our points list as necessary
	self.PulseQueue = self.PulseQueue or queue.create()
	-- (re)create some tables if they don't exist or the size changed
	if not self.PulseQueue or not self.PulseVertices or self.PulseQueue.Count > self.Tesselation then
		self.PulseVertices =  {}

		-- Create our points list as necessary
		self.PulseQueue = queue.create()
	end

	self:AdjustMeshOffsets()


	local verts = {}
	-- Go through each point, calculate its value, and create the corresponding vertex data
	for i=2, self.PulseQueue.Count do

		-- Generate the vertices
		local vCount = #verts
		local xLast = ((i-2) / (self.Tesselation)) * RTSize + self.MeshTimeOffset - self.Tesselation/RTSize
		local xNext = ((i-1) / (self.Tesselation)) * RTSize + self.MeshTimeOffset - self.Tesselation/RTSize

		local LastSize = self.PulseQueue:Get( self.PulseQueue.Count - i + 2)
		local CurrentSize = self.PulseQueue:Get(self.PulseQueue.Count - i + 1)

		if self.PulseQueue.Count > 2 then
			verts[vCount + 1] = Vector( LastSize, xLast,0)
			verts[vCount + 2] = Vector( CurrentSize, xNext,0)
			verts[vCount + 3] = Vector( -CurrentSize, xNext,0)

			verts[vCount + 4] = Vector( -CurrentSize, xNext,0)
			verts[vCount + 5] = Vector( -LastSize, xLast,0)
			verts[vCount + 6] = Vector( LastSize, xLast,0)
		end

		-- Bit of a hack to tie off the loose ends of the vertices, but blehg it looks nice
		-- Because we're moving the mesh for the frames where we can't just slide over the polygons
		-- the whole mesh is shifted. Double the beginning width here
		if i == 2 then
			local size = self.PulseQueue:Get(self.PulseQueue.Count )

			verts[vCount + 7] = Vector( size, xLast,0)
			verts[vCount + 8] = Vector( size, 0,0)
			verts[vCount + 9] = Vector( -size, 0,0)

			verts[vCount + 10] = Vector( -size, 0,0)
			verts[vCount + 11] = Vector( -size, xLast,0)
			verts[vCount + 12] = Vector( size, xLast,0)
		end

		-- Because of the same reason, we've gotta double the ending here
		if i == self.PulseQueue.Count then
			verts[vCount + 7] = Vector( CurrentSize, RTSize,0)
			verts[vCount + 8] = Vector( CurrentSize, xNext,0)
			verts[vCount + 9] = Vector( -CurrentSize, xNext,0)

			verts[vCount + 10] = Vector( -CurrentSize, xNext,0)
			verts[vCount + 11] = Vector( -CurrentSize, RTSize,0)
			verts[vCount + 12] = Vector( CurrentSize, RTSize,0)
		end
	end

	self.PulseVertices = verts
end

local function DrawHistogramMesh( vertices, offset, color )
	mesh.Begin(MATERIAL_TRIANGLES, #vertices / 3)
		for k, vert in pairs( vertices) do

			mesh.Position( vert + offset )
			mesh.Color(color.r, color.g, color.b, 255)
			mesh.AdvanceVertex()

		end
	mesh.End()
end

function ENT:DrawVisualizer(channel)
	local Controller = self:GetOwner()

	local oldW = ScrW()
	local oldH = ScrH()
	local oldRT = render.GetRenderTarget()

	render.SetRenderTarget( RTex )
	render.SetViewPort(0,0,RTSize,RTSize)
	cam.Start2D()
		-- Create a tesselated drawpoly so we can do some SICK stuff
		local themeColor = Color(255,255,255)
		local multiplier = 0.2

		local color = Color(0,0,0)
		if IsValidController( Controller ) then
			themeColor = Controller:GetThemeColor()
			color = Controller:GetThemeColor( 0.01 )
			multiplier = Controller:GetRange("bass").SmoothedAverage * self.PulseBackgroundSensitivity
		end

		color.r = math.Clamp( color.r * multiplier, 0, 255 )
		color.g = math.Clamp( color.g * multiplier, 0, 255 )
		color.b = math.Clamp( color.b * multiplier, 0, 255 )
		surface.SetDrawColor( color, 255 )
		surface.DrawRect( 0, 0, RTSize, RTSize )

		surface.SetTexture(whiteTex)

		-- Construct a mesh real quick
		local offset = -RTSize/8
		DrawHistogramMesh(self.PulseVertices,Vector((1 * RTSize / 4) + offset, 40, 0), themeColor )
		DrawHistogramMesh(self.PulseVertices,Vector((2 * RTSize / 4) + offset, 40, 0), themeColor )
		DrawHistogramMesh(self.PulseVertices,Vector((3 * RTSize / 4) + offset, 40, 0), themeColor )
		DrawHistogramMesh(self.PulseVertices,Vector((4 * RTSize / 4) + offset, 40, 0), themeColor )

	cam.End2D()

	-- Blur that shit
	if BlurAmount > 0 then
		render.BlurRenderTarget(RTex, 0, BlurAmount, 0 )
	end

	render.SetRenderTarget(oldRT)
	render.SetViewPort(0, 0, oldW, oldH)

	render.MaterialOverride(MeshMaterial)
	self:DrawModel()
	render.MaterialOverride()
end


function ENT:SetResolution(res)

	self.Resolution = res
	self.FFTSmoothed = {} -- Just recreate the table, it now has the wrong number of indices (probably)
end

function ENT:Think()
	local Controller = self:GetOwner()

	if !IsValid(Controller) then
		for k,v in pairs( ents.FindByClass("gmt_club_dj") ) do
			if IsValid(v) then self:SetOwner(v) end
		end
	end

	if IsValidController( Controller ) then
		self.Stream = Controller:GetStream()
	end

	-- Think about the values of each pulse section
	self:PulseThink()

	-- Require that the controller be valid from here on out
	if not IsValidController( Controller ) then return end

	-- Draw the dynamic light
	if ShouldDrawDynamicLight then

		local dlight = DynamicLight( self:EntIndex())
		if dlight then
			local color = Controller:GetThemeColor()
			dlight.Pos = self:GetPos()
			dlight.r = color.r
			dlight.g = color.g
			dlight.b = color.b
			dlight.Brightness = Controller:GetSmoothedAverage("bass") * self.DynamicLightIntensity + self.DynamicLightBaseIntensity
			dlight.Size = 1200
			dlight.DieTime = CurTime() + 0.25
			--dlight.NoWorld = true
		end
	end

end

cvars.AddChangeCallback(DrawDynLightConvar and DrawDynLightConvar:GetName() or "gmt_club_dlight", function(name, oldval, newval)
	ShouldDrawDynamicLight = tostring(newval) == "1"
end )
