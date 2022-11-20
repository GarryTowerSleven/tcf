
APP.Icon = "camera"
APP.Purpose = "To look at players outside your suite."
APP.NiceName = "Camera"

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
			for _, ply in pairs( Location.GetPlayersInLocation( Location.Find(CamData.origin) ) ) do

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
		local plyLoc = LocalPlayer():Location()--Location.Get(LocalPlayer():Location())
		local selfLoc = self.E:GetNWInt("condoID")--Location.Get(self.E:Location())
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
		local loc = Location.Get(Location.Find(ply:GetPos()))
		if not loc or not loc.CondoID then return end 

		-- Get the room object and the door camera within
		local room = loc
		if (room and IsValid(room.DoorCam)) then
			-- Add the door camera position to the pvs so clients can see it 
			AddOriginToPVS( room.DoorCam:GetPos() )
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
	end )
*/
end
