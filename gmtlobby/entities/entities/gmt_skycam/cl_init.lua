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
	local location = Location.Get(loc)
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
end



local SkyPos = Vector()

hook.Add("OverrideSkyCamera", "GMTSkyCameraTest", function(eyepos, eyeangles, skyboxscale )



	local locID = LocalPlayer().Location
	local offsets, isOffset = GetSkyBoxOffset(locID)


	if not offsets then return end





	local SkyPos = offsets.Pos

	if isOffset then SkyPos = SkyPos + DefaultPosition end



	local pos, ang = LocalToWorld(eyepos * offsets.Scale, eyeangles, SkyPos, offsets.Ang)



	return pos, ang, offsets.Scale

end )

