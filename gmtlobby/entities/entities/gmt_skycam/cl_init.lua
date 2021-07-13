include("shared.lua")
include("playermeta.lua")

-- Set the skybox scale, defaulting to 1/16th normal scale
local SKYBOX_SCALE = 1/16
local CurrentScale = SKYBOX_SCALE

-- Is there a way to easily get these values? For now they're hardcoded to match
local DefaultColor = Color(255, 214, 193)
local DefaultDensity = 0.5
local DefaultPosition = Vector(8352, -10240, -9503 )

-- Store our camera structure table
local camData = {
	origin = pos, 
	dopostprocess = false,
	drawhud = false,
	drawmonitors = false,
	drawviewmodel = false,
}

-- Define these as they're no longer defined in gmod (wtf??)
local TEXTURE_FLAGS_CLAMP_S = 0x0004
local TEXTURE_FLAGS_CLAMP_T = 0x0008
local MATERIAL_RT_DEPTH_SEPERATE = 1

-- This is the actual render texture, custom fit for accepting the data of a RenderView call
local rt = GetRenderTargetEx("GMTSkyCamera", ScrW(), ScrH(), 
	RT_SIZE_OFFSCREEN, MATERIAL_RT_DEPTH_SEPERATE,
	bit.bor(TEXTURE_FLAGS_CLAMP_S, TEXTURE_FLAGS_CLAMP_T),
	CREATERENDERTARGETFLAGS_UNFILTERABLE_OK, IMAGE_FORMAT_RGBA8888 )

-- This is the material we'll draw onto the screen
local CamMaterial = CreateMaterial("GMTSkyCameraMaterial" .. CurTime(),"UnlitGeneric",{
	["$basetexture"] = "GMTSkyCamera", 
})

-- Render our custom skybox here
local ShouldOverride = false 
hook.Add("RenderScene", "GMT_SkyboxRender", function(eyepos, eyeangles, fov )
	ShouldOverride = false -- By default disable overriding skybox stuff
	if not util.IsSkyboxVisibleFromPoint(eyepos) then return end 

	local newOrigin, newAngles, scale = hook.Call("OverrideSkyCamera", GAMEMODE, eyepos,eyeangles,SKYBOX_SCALE )
	if not newOrigin and not newAngles then
		return 
	end
	newOrigin = newOrigin or eyepos 
	newAngles = newAngles or eyeangles 
	CurrentScale = scale or SKYBOX_SCALE

	ShouldOverride = true 

	local oldRT = render.GetRenderTarget()
	render.SetRenderTarget( rt )

	render.Clear( 0, 0, 0, 255 )
	render.ClearDepth()
	render.ClearStencil()

	camData.origin = newOrigin or eyepos 
	camData.angles = newAngles or eyeangles 
	--camData.origin = pos + eyepos * SKYBOX_SCALE 

	render.RenderView(camData)
	--render.BlurRenderTarget(rt, 2, 2, 3)
	render.SetRenderTarget( oldRT )

end )

--[[hook.Add("SetupWorldFog", "GMTSkyCameraFogOverride", function()
	if not ShouldOverride then return end 

	local start, stop = render.GetFogDistances()
	render.FogMode(MATERIAL_FOG_LINEAR)
	render.FogMaxDensity(DefaultDensity)
	render.FogStart(start * CurrentScale)
	render.FogEnd(stop * CurrentScale)
	render.FogColor(DefaultColor.r, DefaultColor.g, DefaultColor.b)

	-- Let them override fog drawing if they want
	hook.Call("OverrideSkyFog", GAMEMODE)

	return true 
end )]]

local function SkyboxOverride()
	render.OverrideDepthEnable( true, false )

	-- Draw the fullscreen material of whatever was rendered in the skybox
	render.SetMaterial( CamMaterial )
	render.DrawScreenQuad()

	render.OverrideDepthEnable( false, false )
end

-- Actually draw the custom skybox here
hook.Add("PreDrawSkyBox", "GMT_Override_Skybox", function()
	if not ShouldOverride then return end 

	SkyboxOverride()

	return true 
end )

hook.Add("PostDraw2DSkyBox", "GMT_Override_Skybox", function()
	if not ShouldOverride then return end

	SkyboxOverride()

end )


---

-- OVERRIDES

-- Quick fixes for the map because they DON'T WANT TO RECOMPILE

---

local LocationOffsets = {}

LocationOffsets["games"] = {Pos = Vector(0,0,100), Ang = Angle(), Scale = SKYBOX_SCALE}
LocationOffsets["gameslobby"] = {Pos = Vector(0,0,100), Ang = Angle(), Scale = SKYBOX_SCALE}
LocationOffsets["condolobby"] = {Pos = Vector(700,0,100),Ang = Angle(), Scale = SKYBOX_SCALE}



local LocationHardcodes = {}

LocationHardcodes["duels"] = { Pos = Vector(2000, -11670, 11500), Ang = Angle(0,180,0), Scale = 1}


CondoSkyLoc = {}
CondoSkyLoc[1] = Vector(-11904, 3408, 14600)
CondoSkyLoc[2] = Vector(-9376, 9144, 14600)


local function GetSkyBoxOffset(loc)


	if GTowerLocation:GetGroup(loc) == "condos" then
		return LocationOffsets["condolobby"], true
	end

	if Location.IsCondo(loc) then
		local e
		for k,v in pairs( ents.FindByClass("gmt_condoplayer") ) do
			if v:GetNWInt("condoID") == (loc - 1) then e = v end
		end

		if e then

			return { Pos = Vector(-11904, 3408, 14600) - e:GetPos(), Ang = Angle(0,0,0), Scale = 1}, false
		end

	end

	if Location.IsMonorail(loc) then

		local CamFound = false

		local monorail

		for k,v in pairs( ents.FindByClass("gmt_monorail") ) do
			if v.Cars != nil then
				pos = v.Cars[1]:GetPos()
				ang = v.Cars[1]:GetAngles()
				scl = 1
				CamFound = true
				monorail = v
			end
		end

		if CamFound /*&& RefFound*/ then
			return { Pos = pos-Vector(3152, -1344, 2060), Ang = Angle(0,0,0), Scale = scl }, false
		end
	end

	if Location.IsDuelLobby(loc) then

		local CamFound = false

		local cam

		for k,v in pairs( ents.FindByClass("gmt_duelcamera") ) do
			pos = v:GetPos()
			ang = v:GetAngles()
			scl = 1
			CamFound = true
			cam = v
		end
		if CamFound then

			if !DOldPos then DOldPos = pos end

			DNewPos = LerpVector( FrameTime() * 4, DOldPos, pos )

			DOldPos = DNewPos

			return { Pos = DNewPos - Vector(4913.728515625, -708.27087402344, -3487.96875), Ang = ang, Scale = scl }, false
		else
			return LocationHardcodes["duels"], false
		end
	elseif LocationOffsets[GTowerLocation:GetGroup(loc)] then
		return LocationOffsets[GTowerLocation:GetGroup(loc)], true
	end

	local name = GTowerLocation:GetGroup( loc )
	local gmode = GTowerServers:GetGamemode( name )

	if gmode then
		return LocationOffsets["games"], true
	end

	/*local location = Location.Get(loc)

	if not location then return end



	local locName = string.lower(location.Name)



	-- Location has priority

	if locName then

		if LocationOffsets[locName] then

			return LocationOffsets[locName], true

		elseif LocationHardcodes[locName] then

			return LocationHardcodes[locName], false

		end

	end



	-- If the name matches a group, use that

	locName = string.lower(location.Group) or ""

	if locName then

		if LocationOffsets[locName] then

			return LocationOffsets[locName], true

		elseif LocationHardcodes[locName] then

			return LocationHardcodes[locName], false

		end

	end
*/


end



local SkyPos = Vector()

hook.Add("OverrideSkyCamera", "GMTSkyCameraTest", function(eyepos, eyeangles, skyboxscale )



	local locID = LocalPlayer().GLocation
	local offsets, isOffset = GetSkyBoxOffset(locID)


	if not offsets then return end





	local SkyPos = offsets.Pos

	if isOffset then SkyPos = SkyPos + DefaultPosition end



	local pos, ang = LocalToWorld(eyepos * offsets.Scale, eyeangles, SkyPos, offsets.Ang)



	return pos, ang, offsets.Scale

end )

