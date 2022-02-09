---------------------------------
local clip = include("cl_clip.lua")

local BackgroundColor = Color( 0x05, 0x015, 0x026, 0.8 * 255 )
local smallerBackgroundColor = Color( 0x0, 0x0, 0x0, 0.4 * 255 )

local CurrentMapFont = "GTowerHUDMainTiny"
local CurrentMapFontHeight = 10

local MapFont = "MultiMapDeluxe"
local MapFontHeight = 16

function ENT:ProcessMapPos()

	local MapBoxHeight = self.PlayerWidth * 0.9
	local SmallerBox = MapBoxHeight * 0.7

	local MapBoxYPos = math.max(
		self.PlayerStartY,
		self.TotalMinY + self.TopHeight + (self.TotalHeight-self.TopHeight) / 2 - MapBoxHeight / 2
	)

	local MapBoxXpos = self.TotalMinX + self.TotalWidth * (5/6) - MapBoxHeight / 2

	self.MapBoxSize = MapBoxHeight * 1.47
	self.MapBoxXpos = MapBoxXpos - 304
	self.MapBoxYPos = MapBoxYPos + 44

	self.SmallerBoxSize = SmallerBox
	self.SmallerBoxX = self.MapBoxXpos + MapBoxHeight * 0.5 - SmallerBox * 0.5
	self.SmallerBoxY = self.MapBoxYPos + MapBoxHeight - SmallerBox - 5

	surface.SetFont( CurrentMapFont )
	CurrentMapFontHeight = 512

	self.CurrentMapWidthSize = surface.GetTextSize( "CURRENT MAP" )

	surface.SetFont( MapFont )
	MapFontHeight = draw.GetFontHeight( MapFont )

	self.MapWidthSize = surface.GetTextSize( string.upper( Maps.GetName( self.ServerMap ) ) )

end

local mapCropSize = 2.025
function ENT:DrawMap()

	if self.MapTexture then
		surface.SetMaterial( self.MapTexture )
		surface.SetDrawColor( 225, 225, 225, 250 )

		clip:Scissor2D(self.MapBoxXpos + self.MapBoxSize - 358, self.MapBoxYPos + self.MapBoxSize / mapCropSize)
			surface.DrawTexturedRect( self.MapBoxXpos + 184, (self.MapBoxYPos + self.MapBoxYPos + 70) / mapCropSize, self.MapBoxSize / 1.663, self.MapBoxSize / 1.663 )
		clip()

		CasinoKit.getRemoteMaterial(self.MapGradientURL, function(mat)
			self.MapGradient = mat
		end, true)

		if self.MapGradient then
			surface.SetMaterial( self.MapGradient )
			surface.SetDrawColor(255,255,255,255)

			for i=1, 2 do
				surface.DrawTexturedRect( self.MapBoxXpos + 184, self.MapBoxYPos + 194, self.MapBoxSize / 1.667, 473 )
			end
		end
	end

	draw.SimpleShadowText( Maps.GetName( self.ServerMap ), MapFont, self.MapBoxXpos + 590,  self.MapBoxYPos + 650, Color( 255, 255, 255, 255 ), Color( 0, 0, 0, 150 ), TEXT_ALIGN_CENTER )

end
