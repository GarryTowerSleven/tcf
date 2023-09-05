include('shared.lua')

ENT.RenderGroup = RENDERGROUP_OPAQUE
local DEBUG = false

ENT.PlayerConfig = {
	angle = Angle(-90, 90, 0),
	offset = Vector(1.1, 25.535, 35.06),
	width = 51.19,
	height = 27.928 --51.1 * 9/16
}

ENT.DrawTextScale = 1/18

function ENT:Initialize()
	if self.Base == "gmt_mediaplayer_relay" then
		self.BaseClass.Initialize(self)
	else
		self.BaseClass.BaseClass.Initialize(self)
	end

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

	hook.Remove("PostDrawOpaqueRenderables", mp)

	if !self.On then return end

	mp:Draw()

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

hook.Remove( "OpenSideMenu", "OpenTVVolume", function()

	local TVOnInLocation = false
	for _, tv in pairs( ents.FindByClass( "gmt_room_tv*" ) ) do
		if Location and tv:Location() == LocalPlayer():Location() then
			TVOnInLocation = true
			break
		end
	end

	if not TVOnInLocation then return end

	local ent = LocalPlayer():GetEyeTrace().Entity

	local Form = vgui.Create( "DForm" )
	Form:SetName( "TV Controls" )

	local VolumeSlider = vgui.Create( "DNumSlider2", Form )
	VolumeSlider:SetText( "Volume" )
	VolumeSlider:SetMinMax( 0, 100 )
	VolumeSlider:SetDecimals( 0 )
	VolumeSlider:SetConVar( Volume.VarVideo ) -- TODO: set this to gmt_mediaplayer_volume
	VolumeSlider:SizeToContents()
	Form:AddItem( VolumeSlider, nil )
	
	local function ToggleFullscreen()
		local name = MediaPlayer.Cvars.Fullscreen:GetName()
		local value = MediaPlayer.Cvars.Fullscreen:GetBool() and 0 or 1
		RunConsoleCommand( name, value )
	end

	if false /*IsValid( ent ) and ent.IsTV*/ then

		local mp = ent:GetMediaPlayer()

		-- Mediaplayer is valid and the TV is turned on
		if IsValid(mp) then

			-- Owner only commands
			if ent:IsOwner( LocalPlayer() ) then

				local mpRequest = Form:Button( "Request Video" )
				mpRequest.DoClick = function()
					MediaPlayer.OpenRequestMenu( ent )
				end

			end

			local state = mp:GetPlayerState()

			-- Currently playing media
			if state >= MP_STATE_PLAYING then

				local copyUrl = Form:Button( "Copy Media URL" )
				copyUrl.DoClick = function()
					local media = mp and mp:CurrentMedia()
					if not IsValid(media) then return end

					SetClipboardText( media:Url() )
					Msg2( "Media URL has been copied into your clipboard." )
				end

				-- Owner controls
				if ent:IsOwner( LocalPlayer() ) then

					local mpPause

					if state == MP_STATE_PLAYING then
						mpPause = Form:Button( "Pause" )
					elseif state == MP_STATE_PAUSED then
						mpPause = Form:Button( "Resume" )
					end

					mpPause.DoClick = function()
						MediaPlayer.Pause( ent )
					end

					local mpSkip = Form:Button( "Skip" )
					mpSkip.DoClick = function()
						MediaPlayer.Skip( ent )
					end
					
					local mpSeek = Form:Button( "Seek" )
					mpSeek.DoClick = function()
						Derma_StringRequest(
							"Media Player",
							"Enter a time in HH:MM:SS format (hours, minutes, seconds):",
							"", -- Default text
							function( time )
								MediaPlayer.Seek( ent, time )
							end,
							function() end,
							"Seek",
							"Cancel"
						)
					end

				end

			end

			local ToggleFullscreenForm = Form:Button( "Toggle Fullscreen" )
			ToggleFullscreenForm.DoClick = ToggleFullscreen

			local TurnOffTV = Form:Button( "Turn Off" )
			TurnOffTV.DoClick = function()
				MediaPlayer.RequestListen( ent )
			end

		else

			local TurnOnTV = Form:Button( "Turn On" )
			TurnOnTV.DoClick = function()
				MediaPlayer.RequestListen( ent )
			end

		end

	else

		-- Show fullscreen option if it's enabled and the user is looking away
		-- from the TV
		if MediaPlayer.Cvars.Fullscreen:GetBool() then

			local ToggleFullscreenForm = Form:Button( "Toggle Fullscreen" )
			ToggleFullscreenForm.DoClick = ToggleFullscreen

		end

		local HowTo = vgui.Create( "DLabel", Form )
		HowTo:SetText( "For more controls, look at\n   a TV and hold Q again.\n" )
		HowTo:SizeToContents()
		HowTo:SetContentAlignment( 5 )
		HowTo:SetTextColor( color_white )
		Form:AddItem( HowTo, nil )

	end

	return Form

end )