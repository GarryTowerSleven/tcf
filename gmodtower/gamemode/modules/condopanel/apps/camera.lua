
-----------------------------------------------------

APP.Icon = "camera"
APP.Purpose = "To look at players outside your suite."
APP.NiceName = "Camera"

if CLIENT then

GradientDown = surface.GetTextureID( "VGUI/gradient_down" )
GradientUp = surface.GetTextureID( "VGUI/gradient_up" )
Cursor2D = surface.GetTextureID( "cursor/cursor_default" )

Backgrounds = {
	Material( "gmod_tower/panelos/backgrounds/background1.png", "unlitsmooth" ),
	Material( "gmod_tower/panelos/backgrounds/background2.png", "unlitsmooth" ),
	Material( "gmod_tower/panelos/backgrounds/background3.png", "unlitsmooth" ),
	Material( "gmod_tower/panelos/backgrounds/background4.png", "unlitsmooth" ),
	Material( "gmod_tower/panelos/backgrounds/background5.png", "unlitsmooth" ),
	Material( "gmod_tower/panelos/backgrounds/background6.png", "unlitsmooth" ),
	Material( "gmod_tower/panelos/backgrounds/background7.png", "unlitsmooth" ),
	Material( "gmod_tower/panelos/backgrounds/background8.png", "unlitsmooth" ),
	Material( "gmod_tower/panelos/backgrounds/background9.png", "unlitsmooth" ),
}

--Icons = GTowerIcons.Icons

local path = "gmod_tower/panelos/icons/"

local function Create( png, filter, path_override )
	return Material( (path_override or path).. png, filter or "unlitsmooth" )
end

Icons = {
	["gmt"] = Create( "logo_flat.png", "unlitsmooth", "gmod_tower/hud/" ),
	["gmtsmall"] = Create( "gmt.png" ),
	["home"] = Create( "home.png" ),
	["back"] = Create( "back.png" ),
	["camera"] = Create( "video.png" ),
	["music"] = Create( "music.png" ),
	["options"] = Create( "settings.png" ),
	["lock"] = Create( "lock.png" ),
	["unlock"] = Create( "unlock.png" ),
	["alarm"] = Create( "alarms.png" ),
	["time"] = Create( "time.png" ),
	["backspace"] = Create( "backspace.png" ),
	["label"] = Create( "label.png" ),
	["about"] = Create( "about.png" ),
	["storage"] = Create( "storage.png" ),
	["skip"] = Create( "skip.png" ),
	["rewind"] = Create( "rewind.png" ),
	["pause"] = Create( "pause.png" ),
	["play"] = Create( "play.png" ),
	["shuffle"] = Create( "shuffle.png" ),
	["addqueue"] = Create( "addqueue.png" ),
	["images"] = Create( "images.png" ),
	["doorclose"] = Create( "door_closed.png" ),
	["dooropen"] = Create( "door_open.png" ),
	["condo"] = Create( "condo.png" ),
	["players"] = Create( "players.png" ),
	["controller"] = Create( "controller.png" ),
	["movies"] = Create( "movies.png" ),
	["beer"] = Create( "beer.png" ),
	["tv"] = Create( "tv.png" ),
	["party"] = Create( "party.png" ),
	["musicpage"] = Create( "musicpage.png" ),
	["instrument"] = Create( "instrument.png" ),
	["accept"] = Create( "accept.png" ),
	["cancel"] = Create( "cancel.png" ),
	["ban"] = Create( "ban.png" ),
	["heart"] = Create( "heart.png" ),
	["box"] = Create( "box.png" ),
	["broom"] = Create( "broom.png" ),
	["safe"] = Create( "safe.png" ),
	["money"] = Create( "money.png" ),
	["moneylost"] = Create( "money.png" ),
	["trophy"] = Create( "trophy.png" ),
	["present"] = Create( "present.png" ),
	["clipboard"] = Create( "clipboard.png" ),
	["hat"] = Create( "hat.png" ),
	["arcade"] = Create( "arcade.png" ),
	["cards"] = Create( "cards.png" ),
	["slots"] = Create( "slots.png" ),
	["pool"] = Create( "pool.png" ),
	["flag"] = Create( "flag.png" ),
	["admin"] = Create( "admin.png" ),
	["announce"] = Create( "announce.png" ),
	["exclamation"] = Create( "exclamation.png" ),
	["next"] = Create( "next.png" ),
	["light"] = Create( "light.png" ),
	["floor1"] = Create( "floor1.png" ),
	["floor2"] = Create( "floor2.png" ),
	["volume_on"] = Create( "volume_on.png" ),
	["volume_off"] = Create( "volume_off.png" ),
	["volume"] = Create( "volume.png" ),
	["volume16"] = Create( "volume16.png", "unlit" ),
	["chips"] = Create( "chip.png", nil, "gmod_tower/icons/" ),
}

Sounds = {
	["accept"] = "GModTower/ui/panel_accept.wav",
	["back"] = "GModTower/ui/panel_back.wav",
	["error"] = "GModTower/ui/panel_error.wav",
	["save"] = "GModTower/ui/panel_save.wav",
}

end

-- This is the entity that will control our view
local CameraClassName = "gmt_condo_camera"

if CLIENT then

	surface.CreateFont( "CameraName", {
		font = "Oswald",
		size = 80,
		weight = 400
	} )

end

function APP:Start()

	self.CameraIndex = nil

	self.BaseClass:Start()
	if CLIENT then return end
	local loc = self.E:GetNWInt("condoID")
	local cameraIndex = -1 -- Default camera index in case we don't find one

	-- If our owning condo has a camera, send that entity index to the client
	if loc then

		-- Get the room object and the door camera within
		local room = GtowerRooms:Get(loc)

		if (room and IsValid(room.DoorCam)) then
			self.Camera = room.DoorCam
			cameraIndex = room.DoorCam:EntIndex()
		end
	end

	self:Repl("SetCameraIndex", cameraIndex)
end

-- Store the entity index of the camera we'll be lookin out of
function APP:SetCameraIndex(index)
	--print("CAMERA SETTINGS: " .. index)
	self.CameraIndex = index

	self:TryGetCameraEntity()
end

-- Try retreiving a valid camera entity via it's entindex
function APP:TryGetCameraEntity()

	for k,v in pairs( ents.FindByClass("gmt_condo_camera") ) do
		if v:GetNWInt("condoID") == self.E:GetNWInt("condoID") then
			self.Camera = v
		end
	end

	self.E:SetNWEntity( "Camera", self.Camera )

	/*if not self.CameraIndex or self.CameraIndex == -1 then return end

	local camEnt = Entity( self.CameraIndex )
	if IsValid(camEnt) and camEnt:GetClass() == CameraClassName then
		self.Camera = camEnt
	end*/
end

function APP:End()
	self.BaseClass.End(self)
end

if CLIENT then
	-- Queue up whether the RT should be updated
	local ShouldUpdateCamera = false

	-- Size of the rendertexture of the camera
	-- MUST be a power of 2
	local RTSize = 512

	-- Just keep modifying this table
	local CamData =
	{
		x = 0,
		y = 0,
		drawhud = true,
		dopostprocess = false,
		drawmonitors = false,
		drawviewmodel = false,
	}

	-- Define these as they're no longer defined in gmod (wtf??)
	local TEXTURE_FLAGS_CLAMP_S = 0x0004
	local TEXTURE_FLAGS_CLAMP_T = 0x0008
	local MATERIAL_RT_DEPTH_SEPERATE = 1

	-- This is the actual render texture, custom fit for accepting the data of a RenderView call
	local RT = GetRenderTargetEx("CondoCamRTT", RTSize, RTSize/2,
		RT_SIZE_OFFSCREEN, MATERIAL_RT_DEPTH_SEPERATE,
		bit.bor(TEXTURE_FLAGS_CLAMP_S, TEXTURE_FLAGS_CLAMP_T),
		CREATERENDERTARGETFLAGS_UNFILTERABLE_OK, IMAGE_FORMAT_RGBA8888 )

	-- This is the material we'll draw onto the screen
	local CamMaterial = CreateMaterial("CondoCamMaterial" .. CurTime(),"UnlitGeneric",{
		["$basetexture"] = "CondoCamRTT",
		["$selfillum"] = 1,
		["$ignorez"] = 1,
	})

	-- Update the rendertarget with some new positions
	local function DrawRenderTarget( self )

		-- Store these so we can restore them later
		local oldW = ScrW()
		local oldH = ScrH()
		local oldRT = render.GetRenderTarget()

		render.SetRenderTarget( RT )
		render.Clear(0, 0, 0, 255)
		render.ClearDepth()
		render.ClearStencil()
		cam.Start2D()
			surface.SetMaterial( Backgrounds[ 1] )
			surface.SetDrawColor( 255, 255, 255, 100 )
			surface.DrawTexturedRect( 0, 0, scrw, scrh )
			render.RenderView(CamData)

			local pos
			for _, ply in pairs( GTowerLocation:GetPlayersInLocation( GTowerLocation:FindPlacePos(CamData.origin) ) ) do

				if ply:GetNoDraw() then continue end
				pos = util.GetCenterPos( ply )
				pos = pos:ToScreen()
				if pos.visible then

					local w, h = ScrW(), ScrH()
					local Alpha = 255
					local Dist = math.Distance( w / 2, h / 2, pos.x, pos.y )
					local StartFade = 300
					if Dist > StartFade then
						Alpha = math.Clamp( 255 - ( Dist - StartFade ) * 0.7, 0, 255 )
					end
					local col = ply:GetDisplayTextColor()
					col = Color( col.r, col.g, col.b )
					draw.SimpleTextOutlined( ply:Name(), "CameraName", pos.x, pos.y, col, 1, nil, 3, Color(0,0,0) )
				end

			end

		cam.End2D()
		render.SetRenderTarget(oldRT)
		render.SetViewPort(0, 0, oldW, oldH)
	end

	function APP:Think()
		if not IsValid(self.Camera) then
			self:TryGetCameraEntity()
			return
		end

		-- Check if the local player is in the same room as this
		local plyLoc = LocalPlayer().GLocation--Location.Get(LocalPlayer():Location())
		local selfLoc = self.E:GetNWInt("condoID")+1--Location.Get(self.E:Location())
		if not plyLoc or not selfLoc then
			return
		end


		-- Set up the camera data
		CamData.w = ScrW()
		CamData.h = ScrH()
		CamData.fov = 100
		CamData.origin = self.Camera:GetPos()
		CamData.angles = self.Camera:GetAngles()

		-- Store the current camera the player is looking out from so we can filter it
		LocalPlayer().CurrentCamera = self.Camera

		-- Queue an update to the render texture
		ShouldUpdateCamera = true

	end

	function APP:Draw()

		local iconSize = 64

		local spacing = 2

		local x, y = scrw/2-32, 80

		local w, h = 200, iconSize + (spacing*2)

		if not IsValid(self.Camera) then
			-- If the server gave us a negative camera index, the suite does not have a camera at all
			if self.CameraIndex == -1 then
				error("No camera installed!")
			-- However, if we were given an index, it's just not valid on the client yet
			else
				draw.DrawText("Loading...", "AppBarSmall", scrw/2, scrh/2 - 50, Color(100,100,100), TEXT_ALIGN_CENTER)
			end
		else
			surface.SetMaterial( CamMaterial )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawTexturedRect( 0, 0, scrw, scrh )
		end

		local spacing = 2
		local padding = 6

		local w, h = scrw/3, 60
		local x, y = scrw/2-(w/2),20

		local color = Color( 255, 0, 0, 150 )
		local color_hovered = color_hovered or Color( 200, 100, 100, 200 )
		local c, columns = 1, 4

		if LocalPlayer():IsAdmin() then

				self:CreateButton( "Default", x, y, w, h,
				function( btn, x, y, w, h, isover ) -- draw
					surface.SetTextColor( 255, 255, 255 )

					if isover then
						surface.SetDrawColor( color_hovered )
					else
						surface.SetDrawColor( color )
					end

					surface.DrawRect( x, y, w, h )

					surface.SetFont( "AppBarSmall" )
					surface.SetTextPos( w + 65, h - 30 )
					surface.DrawText( "CLICK TO FIRE MISSILE" )
				end,
				function( btn ) -- onclick
					RunConsoleCommand( "gmt_condorocket", tostring( self.Camera:EntIndex() ) )
				end
			)

		self:DrawButtons()

		end

	end

	-- Control the rendering of the camera's rendertexture
	hook.Add("RenderScene", "UpdateCameraTexture", function()
		if not ShouldUpdateCamera then return end

		LocalPlayer().IsRenderingCamView = true
		DrawRenderTarget()
		LocalPlayer().IsRenderingCamView = false

		ShouldUpdateCamera = false
	end )

end

if SERVER then
	-- Since the camera is in a different part of the map, the client needs to know about it
	hook.Add("SetupPlayerVisibility", "GMTViewCurrentCamera", function(ply)
		local loc = ply.GLocation--Location.Get(ply:Location())

		if Location.IsCondo(loc) then
			AddOriginToPVS( Vector(-2013.2415771484, 300.142578125, 15113.93359375) )
		end
	end )

	-- Spawn the camera entity if they own it
	local CameraSpawnOffsets = Vector( 16,40, 116)
	local Opposites = {
		4, 5, 6, 7, 8, 9, 13, 14, 15, 16, 17, 18
	}
	function CreateCamera(room)
		local door = room.OuterDoor
		if /*not room.HasCamera or*/ not IsValid(door) then return end

		--First try to get the outer door of the suite
		local camera = ents.Create(CameraClassName)
		if not camera then return end

		local offsetPos = CameraSpawnOffsets * 1.0
		offsetPos:Rotate(door:GetAngles())
		camera:SetPos(door:GetPos() + offsetPos)
		local ang = door:GetAngles()
		camera:SetAngles(ang) -- Spawn facing forward out the door
		camera:Spawn()
		camera:Activate()

		-- Store it on the room object to be removed later
		room.DoorCam = camera
	end


	/*hook.Add("RoomLoaded", "GMTCreateCondoCamera", function(ply, room)
		CreateCamera(room)
	end )

	-- Remove the camera entity when the room is checked out of
	hook.Add("RoomUnLoaded", "GMTRemoveCondoCamera", function(room)
		if IsValid(room.DoorCam) then
			room.DoorCam:Remove()
			room.DoorCam = nil
		end
	end )*/
end
