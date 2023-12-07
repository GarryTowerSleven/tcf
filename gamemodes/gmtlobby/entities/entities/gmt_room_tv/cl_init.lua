include('shared.lua')

ENT.RenderGroup = RENDERGROUP_OPAQUE
local DEBUG = false

local BaseClass = baseclass.Get( "mediaplayer_base" )

ENT.PlayerConfig = {
	angle = Angle(-90, 90, 0),
	offset = Vector(1.1, 25.535, 35.06),
	width = 51.19,
	height = 27.928 --51.1 * 9/16
}

ENT.DrawTextScale = 1/18

function ENT:Initialize()
	BaseClass.Initialize(self)
	self.IsTV = true
end

function ENT:IsOwner( ply )

	if DEBUG then
		print("Checking owner: ", ply )
	end

	return true // Temp fix

	/*if ply:IsAdmin() then
		return true
	end

	if GTowerRooms then

		local RoomId = GTowerRooms.PositionInRoom( self:GetPos() )
		
		if DEBUG then
			print("\tFound room: ", RoomId )
		end
		
		if RoomId then
			local Room = GTowerRooms:Get( RoomId )
			
			if DEBUG then
				print("\tRoom: ", Room, Room.Owner )
			end
			
			if Room and Room.Owner == ply then
				return true
			end
		end
	
	end*/

end

local color_white = color_white
local HTMLMaterial = HTMLMaterial
local surface = surface
local Start3D = cam.Start3D
local Start3D2D = cam.Start3D2D
local End3D2D = cam.End3D2D

local thumbStyle = 'suitetv-thumb'

-- TODO: 16:9 dimensions
AddHTMLMaterialStyle(thumbStyle, {
	css = [[img { -webkit-filter: blur(2px) brightness(0.6); }]],
	width = 128,
	height = 128-- * 9/16
})

local StaticMat = Material( "theater/STATIC" )

-- local NoiseMat = Material("dev/dev_tvmonitor1a")
-- local ScanlineTexture = surface.GetTextureID("dev/dev_scanline")

function ENT:Draw()

	self:DrawModel()

	if LocalPlayer():Location() ~= self:Location() then return end

	local mp = self:GetMediaPlayer()
	if mp then return end

	local thumbnail = self:GetThumbnail()
	if thumbnail == "" then return end

	local mat

	if thumbnail == "static" then
		mat = StaticMat
	else
		mat = HTMLMaterial(thumbnail, thumbStyle)
	end

	local w, h, pos, ang = self:GetMediaPlayerPosition()

	Start3D2D( pos, ang, 1 )
		surface.SetMaterial( mat )
		surface.SetDrawColor( color_white )
		surface.DrawTexturedRect( 0, 0, w, h )

		-- surface.SetTexture( ScanlineTexture )
		-- surface.SetDrawColor( color_white )
		-- surface.DrawTexturedRect( 0, 0, w, h )
	End3D2D()

	local textScale = self.DrawTextScale

	Start3D2D( pos, ang, textScale )
		local tw, th = w / textScale, h / textScale
		draw.SimpleText( "Press E to begin watching", "MediaTitle",
			tw/2, th/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	End3D2D()

end