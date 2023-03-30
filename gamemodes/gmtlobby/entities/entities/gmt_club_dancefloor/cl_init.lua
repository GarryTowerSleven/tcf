
include( "shared.lua" )
ENT.RenderGroup = RENDERGROUP_OPAQUE

ENT.Offset = Vector(0,0,5)

-- How sensitive squares are to changing color
ENT.SquareColorIntensity = 0.50

-- How quickly to scale up the frequency as you get farther from the center 
ENT.FrequencyScale = 2

-- Ignore indices lower than this (will change if you change the sample size)
ENT.BassCutoffNum = 2

-- Change whether to have a monochromatic floor design or rainbow
ENT.MonochromaticFloor = false 

-- Numbers less than one will increase the visibility of lower frequencies and decrease the visibility of higher frequencies
-- Numbers greater than one will do the opposite
ENT.BiasAmount = 0.75

-- The model to be repeated as the floor tile
local SquareModel = Model("models/map_detail/nightclub_dance_square.mdl") --Model("models/hunter/blocks/cube025x025x025.mdl") --Model("models/map_detail/nightclub_dance_square.mdl") 
local MeshMaterial = Material("models/debug/debugwhite")

-- Each pixel of the RTexture is a dance tile
-- Overlaid on top is a material that must match the number of tiles!
local RTSize = 16
local RTex = GetRenderTarget("GMTClubDancefloor", RTSize, RTSize)
local MeshMaterial = CreateMaterial( "GMTClubDancefloorMaterial", "UnlitGeneric", 
{
	["$basetexture"] = "GMTClubDancefloor", 
} )
function ENT:Initialize()
	--self:RebuildSquares()
	self.FFT = {}
	self.TotalAverage = 0

	self:CreateMeshSquare()
	self:CreateSquare()
end

local function dist2D( x1, y1, x2, y2)
	return math.sqrt( (x2-x1)^2 + (y2-y1)^2)
end

function ENT:ColorSquares(channel, w, h)
	local Controller = self:GetOwner()
	if not IsValidController( Controller) then return end

	local oldW = ScrW()
	local oldH = ScrH()
	local oldRT = render.GetRenderTarget()

	render.SetRenderTarget( RTex )
	render.SetViewPort(0,0,RTSize,RTSize)
	cam.Start2D()

	local xScale = w / RTSize
	local yScale = h / RTSize

	for x=1, RTSize do
		for y =1, RTSize do

			local fft = Controller.FFTSmoothed
			local height = fft[ math.Clamp( math.floor(dist2D(x, y, RTSize/2+0.5, RTSize/2+0.5) * self.FrequencyScale ) + self.BassCutoffNum, 1, #fft-1)] * self.SquareColorIntensity 
			height = math.pow(height, self.BiasAmount) * h
			-- Get the current theme color from the controller
			local color = Controller:GetThemeColor()
			if self.MonochromaticFloor then
				height = (height + 3)/ 25
				color.r = math.Clamp(color.r * height + 50, 0, 255)
				color.g = math.Clamp(color.g * height + 50, 0, 255)
				color.b = math.Clamp(color.b * height + 50, 0, 255)

			else 
				color = Controller:GetThemeColor(height)
			end

			surface.SetDrawColor( color, 255 )
			surface.DrawRect( x-1, y-1, 1, 1 )

		end
	end

	cam.End2D()

	render.SetRenderTarget(oldRT)
	render.SetViewPort(0, 0, oldW, oldH)
end

function ENT:Think()
	local Controller = self:GetOwner()
	if !IsValid(Controller) then
		for k,v in pairs( ents.FindByClass("gmt_club_dj") ) do
			if IsValid(v) then self:SetOwner(v) end
		end
	end

	-- Goddamn why doesn't slapping this in init keep it around
	self:SetRenderBounds( Vector(-self.Width/2, -self.Height/2, -1) + self.Offset,
						  Vector( self.Width/2,  self.Height/2,  1) + self.Offset)


	if IsValidController( Controller ) then
		self.Stream = Controller:GetStream()
	end

	-- If we moved, reposition the squares
	if self.LastPosition ~= self:GetPos() then
		self.LastPosition = self:GetPos()
		self:PositionSquare()
	end

	if not IsValid( self.SquareModel ) then
		self:CreateSquare()
	end

	--Do the thing
	self:ColorSquares(self.Stream, self.Width, self.Height)

end

function ENT:CreateSquare()
	self.SquareModel = ClientsideModel(SquareModel)

	local min, max = self.SquareModel:GetRenderBounds()
	local size = max - min

	-- Create the matrix that will scale our model to the area of the dancefloor
	local matrix = Matrix()
	matrix:SetTranslation( self.Offset )
	matrix:Scale( Vector( self.Width / size.x, self.Height / size.y, 1))

	self.SquareModel:EnableMatrix( "RenderMultiply", matrix )

	-- Double check to make sure our renderbounds are correct
	self:SetRenderBounds( Vector(-self.Width/2, -self.Height/2, -1) + self.Offset,
						  Vector( self.Width/2,  self.Height/2,  1) + self.Offset)

		-- Double check to make sure our renderbounds are correct
	self.SquareModel:SetRenderBounds( Vector(-self.Width/2, -self.Height/2, -1) + self.Offset,
						  Vector( self.Width/2,  self.Height/2,  1) + self.Offset)

	self:PositionSquare()
end

function ENT:Draw()

	-- Make sure this stuff is valid as well
	if not IsValid( self.SquareModel ) or not self.SquareMesh 
		or not self.SquareMatrix then return end 

	-- Don't draw the colors if there's no valid controller yet
	if not IsValidController(self:GetOwner()) then return end

	cam.PushModelMatrix(self.SquareMatrix)
	render.PushFilterMin(TEXFILTER.POINT)
	render.PushFilterMag(TEXFILTER.POINT )
	render.SetMaterial(MeshMaterial)
	self.SquareMesh:Draw()
	render.PopFilterMag()
	render.PopFilterMin()
	cam.PopModelMatrix()
end

function ENT:OnRemove()
	if IsValid(self.SquareModel) then
		self.SquareModel:Remove()
	end
end

-- Called when it's time to re-place the squares
function ENT:PositionSquare()
	if IsValid( self.SquareModel ) then
		self.SquareModel:SetPos(self:GetPos())
		self.SquareModel:SetAngles(self:GetAngles())
	end

	local matrix = self.SquareMatrix or Matrix()
	matrix:SetScale(Vector(1,1,1))
	matrix:SetTranslation(self:GetPos())
	matrix:SetAngles(self:GetAngles())
	matrix:Translate( self.Offset - Vector(0,0,0.1) )
	matrix:SetScale( Vector( self.Width, self.Height, 1))

	self.SquareMatrix = matrix
end

local function Vertex(Pos, U, V )
	return 
	{
		pos = Pos,
		u = U,
		v = V,
	}
end

function ENT:CreateMeshSquare()
	local verts = {}
	table.insert(verts, Vertex(Vector(-0.5, -0.5, 0), 0, 0))
	table.insert(verts, Vertex(Vector(-0.5,  0.5, 0), 0, 1))
	table.insert(verts, Vertex(Vector( 0.5,  0.5, 0), 1, 1))

	table.insert(verts, Vertex(Vector( 0.5,  0.5, 0), 1, 1))
	table.insert(verts, Vertex(Vector( 0.5, -0.5, 0), 1, 0))
	table.insert(verts, Vertex(Vector(-0.5, -0.5, 0), 0 ,0))

	local m = Mesh()
	m:BuildFromTriangles(verts)

	self.SquareMesh = m
end
