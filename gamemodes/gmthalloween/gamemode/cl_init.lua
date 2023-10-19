include("shared.lua")
include("cl_hud.lua")
include("cl_tracker.lua")
include("cl_post_events.lua")
// include("cl_ragdoll_manager.lua")

local HeartbeatConvar = CreateClientConVar( "gmt_halloween_heartbeat", "1", true, false, nil, 0, 1 )

local hud_hp = surface.GetTextureID( "gmod_tower/halloween/hud_hp" )
local hud_heart = surface.GetTextureID( "gmod_tower/halloween/hud_heart" )
local hud_heart2 = surface.GetTextureID( "gmod_tower/halloween/hud_heart2" )

function GM:HUDPaint()

	self.BaseClass.HUDPaint( self )

	--[[surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetTexture( hud_hp )
	surface.DrawTexturedRect( 0, ScrH()-256, 256, 256 )]]

	if not LocalPlayer():InVehicle() then

		if ( LocalPlayer():Health() > 0 ) then
			local size = math.abs( 15 * math.sin( RealTime() * (10 - (4 * LocalPlayer():Health()/100 ) ) ) )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetTexture( hud_heart )
			surface.DrawTexturedRect(  16 - size, ScrH()-148 - size, 128 + ( size * 2 ), 128 + ( size * 2 ) )
		else
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetTexture( hud_heart2 )
			surface.DrawTexturedRect(  16, ScrH()-148, 128, 128 )
		end

	end

end

local VignetteMat = Material("gmod_tower/halloween/vignette")
local StaticMat = Material("gmod_tower/halloween/static")

function GM:HUDPaintBackground()

	self.BaseClass.HUDPaintBackground( self )

	surface.SetDrawColor(0,0,0,255)
	surface.SetMaterial(VignetteMat)
	surface.DrawTexturedRect(0,0,ScrW(),ScrH())

	draw.SimpleText( math.Clamp( LocalPlayer():Health(), 0, 100 ), nil, 15, 150 )

	if ( LocalPlayer():Health() < 25 and LocalPlayer():Alive() ) then
		
		local mult = math.Remap( LocalPlayer():Health(), 0, 25, 0, 1 )
		local sin = math.Remap( math.sin( RealTime() * 5 ), -1, 1, 0, 1 )

		surface.SetDrawColor( 200 - (50 * sin), 0, 0, 255 * (1 - mult) )
		surface.SetMaterial( VignetteMat )
		surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )

	end

end

local WalkTimer = 0
local VelSmooth = 0
local CurViewPunch = Angle(0,0,0)

function GM:CalcView( ply, origin, angle, fov )

	-- Follow ragdoll eyes
	local rag = ply:GetRagdollEntity() 

	if IsValid( rag ) then 
		local att = rag:GetAttachment( rag:LookupAttachment("eyes") ) 
 		return self.BaseClass:CalcView( ply, att.Pos, att.Ang, fov ) 
 	end

	if ply:Alive() then

		-- Head bobbing
		local vel = ply:GetVelocity()
		local ang = ply:EyeAngles()

		VelSmooth = VelSmooth * 0.9 + vel:Length() * 0.075
		WalkTimer = WalkTimer + VelSmooth * FrameTime() * 0.05

		angle.roll = angle.roll + ang:Right():DotProduct( vel ) * 0.01

		if ( ply:GetGroundEntity() != NULL ) then	
			angle.roll = angle.roll + math.sin( WalkTimer ) * VelSmooth * 0.001
			angle.pitch = angle.pitch + math.sin( WalkTimer * 0.5 ) * VelSmooth * 0.001
		end

		-- Handle falling
		if ply.Falling then
			if !ply._NextFallSound || ply._NextFallSound < CurTime() then
				ply._NextFallSound = CurTime() + 5
				ply:EmitSound( "ambient/wind/wind_snippet" .. math.random( 3, 4 ) .. ".wav", 100, math.random( 120, 150 ) )
			end
			origin = origin + Vector( math.random( -10, 10 ), math.random( -10, 10 ), math.random( -10, 10 ) )
		end

		-- Handle view punch
		if ply.ViewPunchAngle then
			if CurViewPunch == ply.ViewPunchAngle then
				ply.ViewPunchAngle = Angle( 0,0,0 )
			end

			CurViewPunch.p = math.Approach( CurViewPunch.p, ply.ViewPunchAngle.p, FrameTime() * 5 )
			CurViewPunch.r = math.Approach( CurViewPunch.r, ply.ViewPunchAngle.r, FrameTime() * 5 )
			CurViewPunch.y = math.Approach( CurViewPunch.y, ply.ViewPunchAngle.y, FrameTime() * 5 )
			angle = angle + CurViewPunch
		end

	end

	return self.BaseClass:CalcView( ply, origin, angle, fov )

end

function GM:AdjustMouseSensitivity( fDefault ) return 1 end
function GM:HUDWeaponPickedUp() return false end
function GM:HUDItemPickedUp() return false end
function GM:HUDAmmoPickedUp() return false end
function GM:DrawDeathNotice( x, y ) end

function GM:PlayerBindPress( ply, bind, pressed )

	if not pressed then return false end

	if bind == "+zoom" then 
		return true
	end
	
	if bind == "+menu" then
		RunConsoleCommand( "toggleghosttracker" )
	end
	
	if bind == "impulse 100" then 
		RunConsoleCommand( "toggleflashlight" )
	end

end

local MaterialGhost = Material( "sprites/heatwave" )
local MaterialGhostVisible = Material( "smodels/props_combine/cit_corebright" )
function GM:PostDrawTranslucentRenderables()

	for _, v in pairs( ents.FindByClass("gmt_halloween_npc*") ) do

		v:SetMaterial( "" )

		--[[if IsValid( v:GetCurrentEnemy() ) then
			self:DrawModelMaterial( v, v:GetModelScale(), MaterialGhostVisible )
		else]]
			self:DrawModelMaterial( v, v:GetModelScale(), MaterialGhost )
		--end

	end

end

function GM:DrawModelMaterial( ent, scale, material )

	// start stencil
	render.SetStencilEnable( true )
	
	// render the model normally, and into the stencil buffer
	render.ClearStencil()
	render.SetStencilFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
	render.SetStencilWriteMask( 1 )
	render.SetStencilReferenceValue( 1 )
	
	// render model
	/*ent:SetModelScale( 1, 0 )
	ent:SetupBones()
	ent:DrawModel()*/
	
	// render the outline everywhere the model isn't
	render.SetStencilReferenceValue( 0 )
	render.SetStencilTestMask( 1 )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilPassOperation( STENCILOPERATION_ZERO )
	
	// render black model
	render.SuppressEngineLighting( true )
	render.MaterialOverride( material )
	
		// render model
		ent:SetModelScale( scale, 0 )
		ent:SetupBones()
		ent:DrawModel()
		
	// clear
	render.MaterialOverride()
	render.SuppressEngineLighting( false )
	
	// end stencil buffer
	render.SetStencilEnable( false )

end

local HeartBeatPitch = 100
local HeartBeatVolume = 0
local HeartBeatSound = nil
local BreathingPitch = 100
local BreathingVolume = 0
local BreathingSound = nil
local CameraShake = 0
local LightBrightness = 0
local ScareLevel = 0
local function AddScare( scare )
	ScareLevel = math.Clamp( ScareLevel + scare, 0, 1 )
end

hook.Add( "Think", "DevHQSpook", function()
	
	if LocalPlayer():InVehicle() then return end

	-- Handle light brightness
	local LightColor = render.GetLightColor( LocalPlayer():GetPos() ) * 255
	LightBrightness = LightColor:Length() * .001

	if LightBrightness < 10 and ScareLevel < .45 then
		AddScare(.01)
	end

	-- Decrease scare level over time
	if ScareLevel > 0 then
		ScareLevel = math.Approach( ScareLevel, 0, .0001 )
	end

	-- Change heart beat volume/pitch based on scare level
	HeartBeatVolume = math.Approach( HeartBeatVolume, math.Fit(ScareLevel, 0, .5, 0, .5), .1 )
	HeartBeatPitch = math.Approach( HeartBeatPitch, math.Fit(ScareLevel, 0, 1, 100, 150), .1 )
	BreathingVolume = math.Approach( BreathingVolume, math.Fit(ScareLevel, .5, 1, 0, .85), .1 )
	BreathingPitch = math.Approach( BreathingPitch, math.Fit(ScareLevel, 0, 1, 80, 100), .1 )
	CameraShake = math.Approach( CameraShake, math.Fit(ScareLevel, 0, 1, 0, .15), .1 )

	-- Handle heart beat
	if HeartbeatConvar:GetBool() and HeartBeatVolume > 0 and LocalPlayer():Alive() then
		if HeartBeatSound then
			HeartBeatSound:ChangeVolume(HeartBeatVolume, 0)
			HeartBeatSound:ChangePitch(HeartBeatPitch, 0)
		else
			HeartBeatSound = CreateSound( LocalPlayer(), "room209/heartbeat.wav" )
			HeartBeatSound:PlayEx( HeartBeatVolume, HeartBeatPitch )
		end
	else
		if HeartBeatSound then
			HeartBeatSound:FadeOut(1)
			HeartBeatSound = nil
		end
	end

	-- Handle breathing
	if BreathingVolume > 0 then
		if BreathingSound then
			BreathingSound:ChangeVolume(BreathingVolume, 0)
			BreathingSound:ChangePitch(BreathingPitch, 0)
		else
			BreathingSound = CreateSound( LocalPlayer(), "player/breathe1.wav" ) // CreateSound( LocalPlayer(), "room209/breathing.wav" )
			BreathingSound:PlayEx( HeartBeatVolume, BreathingPitch )
		end
	else
		if BreathingSound then
			BreathingSound:FadeOut(1)
			BreathingSound = nil
		end
	end

end )


local UICircle = Material( "room209/white_circle" )
local StaticOpacity = 0
local HeartBeatRate = 100
local HeartBeatX = 0

local ScreenRT = CreateMaterial( "ScreenSpaceRT" .. CurTime(), "UnlitGeneric",{
	["$basetexture"] = "_rt_FullFrameFB", 
	["$selfillum"] = 1,
	["$ignorez"] = 1,
	["$additive"] = 1,
	["$vertexcolor"] = 1,
} )


local function GhostStatic()

	local radius = 64
	local enemy = nil

	for _, npc in ipairs( ents.FindByClass("gmt_halloween_ghost*") ) do

		local dist = npc:GetPos():Distance( LocalPlayer():GetPos() )

		if dist < radius then
			enemy = npc
			radius = dist
		end

	end

	if enemy then

		surface.SetDrawColor(255,255,255,50)
		surface.SetMaterial(StaticMat)
		surface.DrawTexturedRect(0,0,ScrW(),ScrH())

	end

end
surface.CreateFont( "HUDVid", { font = "Digital-7 Mono", size = 50, weight = 500 } )
surface.CreateFont( "HUDVidSmall", { font = "Digital-7 Mono", size = 32, weight = 500 } )

local function DrawREC()

	-- Draw REC
	local x = ScrW()-256
	local size = 32
	surface.SetDrawColor(255,0,0,255)
	surface.SetMaterial(UICircle)

	local beep = SinBetween(0,1,RealTime()*5)
	if beep >= .5 then
		surface.DrawTexturedRect(x - (size/2),size+(size/2),size,size)
	end

	draw.SimpleText( "REC", "HUDVid", x + size + 16, size + 4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )

end

local function DrawCameraLines()

	-- Draw Camera lines
	local w, h = ScrW()/2, ScrH()/2
	local length, thickness = 64, 2
	local x, y = ScrW()/2 - w/2, ScrH()/2 - h/2

	surface.SetDrawColor(255,255,255,255)

	-- Top left
	surface.DrawRect(x,y,length,thickness)
	surface.DrawRect(x,y,thickness,length)

	-- Top right
	surface.DrawRect(x+w-length-thickness,y,length,thickness)
	surface.DrawRect(x+w-thickness,y,thickness,length)

	-- Bottom left
	surface.DrawRect(x,y+h-thickness,length,thickness)
	surface.DrawRect(x,y+h-length-thickness,thickness,length)

	-- Bottom right
	surface.DrawRect(x+w-length-thickness,y+h-thickness,length,thickness)
	surface.DrawRect(x+w-thickness,y+h-length,thickness,length)

end

local chromaScreen = render.GetScreenEffectTexture()
// local chromaScreenLow = render.GetRefractTexture()
// local chromaBlurRT = GetRenderTarget( "ChromaBlur", 256, 256 )
local chromaMat = Material( "pp/add" )

local chromaBrightness = .4
local chromaAbberationOffset = 1
// local chromaAbberationBlur = 1
// local chromaAbberationPasses = 2
local function ChromaticAbberation()
	
	/*render.CopyTexture( chromaScreen, chromaBlurRT )
	render.PushRenderTarget( chromaBlurRT )
		render.DrawTextureToScreen( chromaScreen )
		render.BlurRenderTarget( chromaBlurRT, chromaAbberationBlur, chromaAbberationBlur, chromaAbberationPasses )
	render.PopRenderTarget()

	chromaMat:SetTexture( "$basetexture", chromaBlurRT:GetName() )
	render.SetMaterial( chromaMat )

	chromaMat:SetVector( "$color", Vector( 1, chromaBrightness, chromaBrightness ) )
	render.DrawScreenQuadEx( -chromaAbberationOffset, -chromaAbberationOffset, ScrW() + chromaAbberationOffset, ScrH() + chromaAbberationOffset )
	
	chromaMat:SetVector( "$color", Vector( chromaBrightness, chromaBrightness, 1 ) )
	render.DrawScreenQuadEx( 0, 0, ScrW() + chromaAbberationOffset, ScrH() + chromaAbberationOffset )*/

	render.SetMaterial( chromaMat )
	chromaMat:SetTexture( "$basetexture", chromaScreen )

	chromaMat:SetVector( "$color", Vector( 1, chromaBrightness, chromaBrightness ) )
	render.DrawScreenQuadEx( -chromaAbberationOffset, -chromaAbberationOffset, ScrW(), ScrH() )
	
	chromaMat:SetVector( "$color", Vector( chromaBrightness, chromaBrightness, 1 ) )
	render.DrawScreenQuadEx( chromaAbberationOffset, chromaAbberationOffset, ScrW(), ScrH() )

end

local function DrawBattery( percent )

	local w, h = 64, 24
	local x, y = ScrW() - 128, ScrH() - 96 - h - 14
	local thickness = 4

	surface.SetDrawColor(255,255,255,255)

	if percent <= .2 then
		surface.SetDrawColor(255,0,0,SinBetween(50,255, RealTime() * 20))
	end

	draw.SimpleText( "DETECTOR BATTERY: ", "HUDVidSmall", ScrW() - 256, ScrH() - 138, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )

	-- Top
	surface.DrawRect( x, y, w, thickness )

	-- Bottom
	surface.DrawRect( x, y + h - thickness, w, thickness )

	-- Left
	surface.DrawRect( x, y + thickness, thickness, h - thickness )

	-- Right
	surface.DrawRect( x + w - thickness, y + thickness, thickness, h - thickness )

	-- Fill
	surface.DrawRect( x + thickness + 1, y + thickness + 1, ( w - ( thickness * 2 ) ) * percent - 2, h - ( thickness * 2 ) - 2 )

	-- Ground
	surface.DrawRect( x + w - thickness, y + thickness, thickness * 2, h - ( thickness * 2 ) )

end

local KillAlpha = 0
local KillAlphaTarget = 0
local KillMaterial = Material( "sprites/powerup_effects" )
function DrawKill()

	if KillAlphaTarget == KillAlpha then return end
	KillAlpha = math.Approach( KillAlpha, KillAlphaTarget, RealFrameTime() * 1.25 )

	local size = 45
	local alpha = math.ease.InOutCubic( KillAlpha )

	surface.SetDrawColor( 125, 125, 255, 255 * alpha )
	surface.SetMaterial( KillMaterial )
	surface.DrawTexturedRect( (ScrW() / 2) - (size / 2), (ScrH() / 2) - (size / 2), size, size )
	
	local size = size / 1.75

	surface.SetDrawColor( 255, 255, 255, 200 * alpha )
	surface.DrawTexturedRect( (ScrW() / 2) - (size / 2), (ScrH() / 2) - (size / 2), size, size )

end

net.Receive( "HalloweenNPCKilled", function()
	KillAlpha = 1
end )

hook.Add( "HUDPaint", "DevHQSpook", function() 

	if not LocalPlayer():InVehicle() then

		ChromaticAbberation()
		DrawREC()
		DrawCameraLines()
		DrawKill()

		if LocalPlayer():HasWeapon( "tracker" ) then
			DrawBattery( LocalPlayer():GetAmmoCount( "Battery" ) / 100 )
		end

	end

end )

hook.Add( "HUDPaintBackground", "DevHQSpook", function() 

	if not LocalPlayer():InVehicle() then

		surface.SetDrawColor(0,0,0,255)
		surface.SetMaterial(VignetteMat)
		surface.DrawTexturedRect(0,0,ScrW(),ScrH())

		StaticOpacity = math.Approach( StaticOpacity, math.Fit(LightBrightness, 0, 80, 15, 2), .1 )

		surface.SetDrawColor(255,255,255,StaticOpacity)
		surface.SetMaterial(StaticMat)
		surface.DrawTexturedRect(0,0,ScrW(),ScrH())

		if StaticScareEnabled then
			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial(StaticMat)
			surface.DrawTexturedRect(0,0,ScrW(),ScrH())
		end

		GhostStatic()

	end

end )