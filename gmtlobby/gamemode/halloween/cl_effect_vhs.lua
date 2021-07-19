--Render assets
local screenRT = nil
local vhsMaterial = nil
local screenEffectMaterial = nil

--screen effect texture needs to be scaled down slightly, adjust this if the screen coordinates are incorrect
local TEX_COORD_FIX = 0.032

--Copies the screen effect texture to a rendertarget to fix alpha issues
local function CopyScreenToVHS()

	render.UpdateScreenEffectTexture()
	render.PushRenderTarget( screenRT )

	render.Clear(0,0,0,255,true,true)
	render.SetWriteDepthToDestAlpha( false )

	cam.Start2D()

	local b,e = pcall(function()

		surface.SetMaterial( screenEffectMaterial )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRectUV( 0, 0, ScrW(), ScrH(), 
			0.0 - TEX_COORD_FIX,
			0.0 - TEX_COORD_FIX, 
			1.0 + TEX_COORD_FIX, 
			1.0 + TEX_COORD_FIX 
		)

	end)

	if not b then print(e) end

	cam.End2D()
	render.PopRenderTarget()

end

--Draw a rectangle of VHS footage, u and v parameters offset the coordinates
local function DrawVHS_UVSubRect( x, y, w, h, u, v )

	local usx = x / ScrW()
	local usy = y / ScrH()

	local ux = w / ScrW()
	local vx = h / ScrH()

	surface.DrawTexturedRectUV( x, y, w, h, 
		usx + u,
		usy + v, 
		usx + ux + u, 
		usy + vx + v
	)

end

--State variables
local changeTime = 0
local phaseOffset = 0
local shiftY = 200
local shiftHeight = 100

local function GetDistortionValueBasedOnMonsters( range_min, range_max )

	local closestDist = nil
	for _, monster in pairs( ents.FindByClass( "ghost_ghost" ) ) do

		local distance = monster:GetPos():Distance(LocalPlayer():GetPos())
		if not closestDist or ( distance < closestDist ) then

			closestDist = distance

		end

	end

	if not closestDist then return 0 end
	return 1.0 - math.Clamp( ( closestDist - range_min ) / (range_max - range_min), 0, 1 )

end

local function VHSOverlay()

	if not LocalPlayer()._InDevHQ then return end

	--Wait for rendertargets to load
	if not vhsMaterial then return end
	if not screenEffectMaterial then return end
	if not screenRT then return end

	-- Distort based on ghost
	local distortFactor = GetDistortionValueBasedOnMonsters( 0, 1024 )
	if distortFactor == 0 then distortFactor = SinBetween(.05,.25,CurTime()) end

	--How much distortion
	local distortScale = distortFactor

	--Update rendertarget ( call this less often to control framerate of 'video feed' )
	CopyScreenToVHS()

	--Randomize values occasionally
	if CurTime() - changeTime > 0 then

		--Next time to randomize
		changeTime = CurTime() + math.random(1,20)/40

		--Phasing offset
		phaseOffset = math.random(0,100)/40

		--Traveling scan box location
		shiftHeight = math.random(100,400)
		shiftY = math.random(-shiftHeight,ScrH() + shiftHeight)

	end

	--Set VHS material for rendering
	surface.SetMaterial( vhsMaterial )
	surface.SetDrawColor( 255, 255, 255, 255 )

	--Amount of horizontal phasing
	local phasing = math.sin( CurTime() + phaseOffset )

	--Draw horizontal scan lines
	local scanHeight = 2
	for i=1, ScrH(), scanHeight do

		--Randomize color on each scanline
		surface.SetDrawColor( 
			255 - math.random(0,40) * distortScale, 
			255 - math.random(0,40) * distortScale, 
			255 - math.random(0,40) * distortScale, 255 )

		--Generate offset U coordinate
		local ru = (math.random(-100,100)*.0001) * phasing * distortScale

		--Draw VHS box
		DrawVHS_UVSubRect(0,i,ScrW(),scanHeight, ru,0)

	end

	--Randomize color on traveling scan box
	surface.SetDrawColor( 
		255 - math.random(0,20) * distortScale, 
		255, 
		255 - math.random(0,20) * distortScale, 100 )

	--Draw scan box at randomized location
	DrawVHS_UVSubRect(0,shiftY,ScrW(),shiftHeight, (phasing/50) * distortScale,0)

	-- Handle ghost
	for _, ent in pairs( ents.FindByClass( "ghost_ghost") ) do

		local pos = ( ent:GetPos() + Vector( 0, 0, 64 ) ):ToScreen()

		for i=1, 10 do
			surface.SetDrawColor( 255, 255, 255, 255 )
			local ru = (math.random(-100,100)*.0001) * .75
			DrawVHS_UVSubRect(0,pos.y+(i*10),ScrW(),shiftHeight, ru,ru)
		end

	end

end
hook.Add( "RenderScreenspaceEffects", "RenderVHSOverlay", VHSOverlay )

--Render initialization flag
local renderInitialized = false

--Initialize rendertarget and materials
hook.Add( "PreRender", "InitializeVHSOverlay", function()

	if renderInitialized then return end
	renderInitialized = true

	--Screen rendertarget
	screenRT = GetRenderTargetEx(
		"VHSOverlayEffect_RTX4", 
		1024, 
		1024,
		RT_SIZE_FULL_FRAME_BUFFER,
		MATERIAL_RT_DEPTH_SEPARATE,
		1,
		CREATERENDERTARGETFLAGS_UNFILTERABLE_OK,
		IMAGE_FORMAT_RGB888
	)

	--Material for VHS rendering
	vhsMaterial = CreateMaterial("VHSMaterial", "UnlitGeneric",
	{
		["$vertexcolor"] = 1,
		["$vertexalpha"] = 1,
		["$ignorez"] = 1,
		["$additive"] = 0,
		["$translucent"] = 0,
	})
	vhsMaterial:SetTexture( "$basetexture", screenRT )

	--Material for screen effect texture (must have alpha disabled)
	screenEffectMaterial = CreateMaterial("VHSScreenEffectMaterial3", "UnlitGeneric",
	{
		["$vertexcolor"] = 1,
		["$vertexalpha"] = 0,
		["$ignorez"] = 1,
		["$additive"] = 0,
		["$translucent"] = 0,
	})
	screenEffectMaterial:SetTexture( "$basetexture", render.GetScreenEffectTexture() )

end)