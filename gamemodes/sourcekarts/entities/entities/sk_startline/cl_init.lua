
-----------------------------------------------------
include("shared.lua")



// ========================================================

// SETUP/DEFINES

// ========================================================



ENT.Mat = {

	Flare = Material( "sprites/powerup_effects" ),

	Logo = surface.GetTextureID( "gmod_tower/logos/sourcekarts" ),

	Flag = surface.GetTextureID( "gmod_tower/sourcekarts/flag" ),

}



function ENT:Initialize()



end



// ========================================================

// ENTITY

// ========================================================



function ENT:OnRemove()



end



function ENT:DLight( pos, color, uniquename )



	uniquename = uniquename or "main"



	local dlight = DynamicLight( self:EntIndex() .. uniquename )

	if dlight then

		dlight.Pos = pos

		dlight.r = color.r

		dlight.g = color.g

		dlight.b = color.b

		dlight.Brightness = 5

		dlight.Decay = 1024

		dlight.size = 512

		dlight.DieTime = CurTime() + 1

	end



end



function ENT:DrawBasicSprite( mat, pos, ang, scale, color )



	render.SetMaterial( mat )

	//render.DrawSprite( pos, 80, 200, Color( 255, 255, 255, math.random( 0, 255 ) ) )

	render.DrawQuadEasy( pos - ang:Forward() * 1, ang:Forward() * -1, 80, 200, Color( color.r, color.g, color.b, math.random( 0, 255 ) ) )

	render.DrawQuadEasy( pos - ang:Forward() * 1, ang:Forward() * -1, scale, scale, color )



end



function ENT:Draw()

	local dist = LocalPlayer():GetPos():Distance( self:GetPos() )
	if dist > (4096*2) then return end

	self:DrawModel()
	self:UpdateAttachments()

	local dist = LocalPlayer():GetPos():Distance( self:GetPos() )
	if dist > 4096 then return end

	self:DrawScreens()

	// Draw lights
	if countdown_started then

		local dt = ( RealTime() - countdown_start ) --Time since countdown started
		local timescale = 2.5 --Timescale (maintains sync to each second)
		local duration = 4 * timescale --Duration of the countdown (realtime)

		dt = math.min(dt*timescale, duration) --Clamp input to duration

		// Green
		if dt - timescale*2 > 1 then
			for _, att in pairs( self.Att.Lights ) do
				self:DrawBasicSprite( self.Mat.Flare, att.pos, att.ang, 150, Color( 0, 255, 0 ) )
			end

			return
		end

		// Yellow
		if dt - timescale > 1 then
			local att = self.Att.Lights[2]
			self:DrawBasicSprite( self.Mat.Flare, att.pos, att.ang, 150, Color( 255, 255, 0 ) )

			return
		end

		// Red
		if dt > 1 then
			local att = self.Att.Lights[1]
			self:DrawBasicSprite( self.Mat.Flare, att.pos, att.ang, 150, Color( 255, 0, 0 ) )
		end

	end

end

// ========================================================
// SCREENS
// ========================================================


function ENT:DrawScreens()

	local ang = self:GetAngles()
	local right = ang:Forward() --right from screen
	local forward = ang:Right() * -1.5 --in to screen
	local up = right:Cross(forward) --up from screen

	local screenAngle = forward:Angle()
	screenAngle:RotateAroundAxis( screenAngle:Forward(), 90 + .5 )
	screenAngle:RotateAroundAxis( screenAngle:Right(), -90 )

	// Draw screen
	cam.Start3D2D( ( self.Att.Screens[1].pos + ang:Right() * .5 ) + forward, screenAngle, .25 )
		pcall( self.DrawScreen, self, 412 * 4, 68 * 4, 4 )
	cam.End3D2D()

end

surface.CreateFont( "HudStartline", { font = "Days", size = 48 } )
surface.CreateFont( "HudStartlineLarge", { font = "Days", size = 56 } )
surface.CreateFont( "HudStartlineHuge", { font = "Days", size = 80 } )
surface.CreateFont( "HudStartlinePosition", { font = "Days", size = 148 } )

local HUDBattleName = surface.GetTextureID( "gmod_tower/sourcekarts/hud_battlename" )



CAMERA_RT = CAMERA_RT or GetRenderTarget("rt_camera02", 512, 512, false)

DrawRT = false



local params = {

	["$basetexture"] = nil,

	["$additive"] = 0,

	["$vertexcolor"] = 1,

	["$vertexalpha"] = 0,

	["$translucent"] = 0,

	["$alpha"] = 1,

}

local cameraTexture = CreateMaterial("CameraTexture", "UnlitGeneric", params)

local hasLeader = false
local shouldChangeLeader = false

local bgAlpha

local logoX = 0

function ENT:SetNextLeader()
	if GAMEMODE.CurrentLeaderNum >= #GAMEMODE.Leaders then
		GAMEMODE.CurrentLeader = GAMEMODE.Leaders[1]
		GAMEMODE.CurrentLeaderNum = 1
		return
	end

	GAMEMODE.CurrentLeaderNum = GAMEMODE.CurrentLeaderNum + 1
	GAMEMODE.CurrentLeader = GAMEMODE.Leaders[GAMEMODE.CurrentLeaderNum]
end

function ENT:DrawScreen( w, h, s )

	DrawRT = false

	// Leader cam
	if hasLeader then

		cameraTexture:SetTexture( "$basetexture", CAMERA_RT )

		local x = w/2
		local cw, ch = 400, h
		local cos = CosBetween( -10, 10, RealTime() * 2 )

		surface.SetDrawColor( 255,255,255,255 )
		surface.SetMaterial( cameraTexture )
		surface.DrawTexturedRect( 0, 0, 1650, ch )

		--surface.SetDrawColor( 0, 0, 0, 150 )
		--surface.DrawRect( x + cos - ( cw / 2 ), 0, cw, 60 )

		--draw.SimpleShadowText( "LEADER CAM", "HudStartlineLarge", x + cos, 30, Color( 255, 255, 255 ), Color( 0, 0, 0, 220 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 5 )
		DrawRT = true

	end
	
	// BG Color
	local mul = SinBetween( -10, 10, RealTime() * 5 )

	surface.SetDrawColor( 30 + mul, 109 + mul, 150 + mul, 50 + (mul/10) )
	surface.DrawRect( 0, 0, w, h )

	// Progress
	if !GAMEMODE.Leaders then 
		GAMEMODE.Leaders = {}
		GAMEMODE.CurrentLeaderNum = 1
	end

	local showIdle = GAMEMODE:GetState() != STATE_PLAYING or LocalPlayer():Team() != TEAM_PLAYING
	local players = player.GetAll()
	
	table.sort( players, function( a, b )
		if a:GetPosition() == 0 || b:GetPosition() == 0 then
			return false
		end

		return a:GetPosition() < b:GetPosition()
	end)

	local max = 5
	local ph = ( max ) * 50
	local x, y = 0, ( h / 2 ) - ( ph / 2 )

	for id, ply in pairs( players ) do
		if id > max then continue end

		GAMEMODE.Leaders[id] = ply

		local color = Color( 7, 34, 48, 125 )

		if ply == GAMEMODE.CurrentLeader then
			color = Color( 30 + mul, 109 + mul, 150 + mul, 200 )
		end

		surface.SetDrawColor( color.r, color.g, color.b, color.a )
		surface.SetTexture( HUDBattleName )
		surface.DrawTexturedRect( 0, y, 512, 70 )

		draw.SimpleShadowText( ( ply:GetPosition() or 1 ) .. ". " .. ply:Name(), "HudStartline", x + 10, y + 20, Color( 255, 255, 255 ), Color( 0, 0, 0, 220 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2 )
		
		y = y + 50
	end

	local x = w/2 - 250
	local y = 60

	local cos = CosBetween( -5, 5, RealTime() * 1 )
	local sin = SinBetween( -10, 10, RealTime() * 2.5 ) + 50
	local color = Color( 7, 34, 48, 100 )

	surface.SetDrawColor( color.r, color.g, color.b, color.a )
	surface.SetTexture( HUDBattleName )
	surface.DrawTexturedRect( x + 40, y - 50, 512, 100 )

	draw.SimpleShadowText( "YOU ARE",
							"HudStartlineHuge",
							x + cos + 1024,
							y + sin - 40,
							Color( 255, 255, 255 ),
							Color( 0, 0, 0, 220 ),
							TEXT_ALIGN_RIGHT,
							TEXT_ALIGN_CENTER, 2 )

	draw.SimpleShadowText( LocalPlayer():GetPosition() .. string.upper( NumberToNth( LocalPlayer():GetPosition() ) ),
							"HudStartlinePosition",
							x + cos + 1024,
							y + sin + 48,
							Color( 255, 255, 255 ),
							Color( 0, 0, 0, 220 ),
							TEXT_ALIGN_RIGHT,
							TEXT_ALIGN_CENTER, 2 )

	draw.SimpleShadowText( "LAP "..LocalPlayer():GetLap().."/3",
							"HudStartlineHuge",
							x + 225,
							y - 20,
							Color( 255, 255, 255 ),
							Color( 0, 0, 0, 220 ),
							TEXT_ALIGN_CENTER,
							TEXT_ALIGN_CENTER, 2 )

	// Transition background.
	local mul = SinBetween( -10, 10, RealTime() * 5 )
	local initialAlpha = 0
	local targetAlpha = initialAlpha

	// Every 5.5 seconds, increase alpha to 255 for a 1.5, then back.
	if RealTime() % 7 > 6 or showIdle then
		targetAlpha = 255
	end

	bgAlpha = ApproachSupport2( bgAlpha or 255, targetAlpha, 1 )

	surface.SetDrawColor( 30 + mul, 109 + mul, 150 + mul, bgAlpha )
	surface.DrawRect( 0, 0, w, h )

	// Logo
	surface.SetDrawColor( 255, 255, 255, bgAlpha )
	surface.SetTexture( self.Mat.Logo )

	local x = ( w / 2 ) - ( 128 * s / 2 ) + SinBetween( -10 * s, 10 * s, RealTime() * 3 )

	// During fade in at 5.5 seconds, have the X position move from the left to where it is now.
	if showIdle then
		logoX = 550 + math.sin( RealTime() * 2 ) * 128
	elseif RealTime() % 7 > 6 then
		logoX = ApproachSupport2( logoX, 512, 1 )
	elseif RealTime() % 7 > 3 then
		logoX = 200
		shouldChangeLeader = true
	else
		logoX = ApproachSupport2( logoX, 1000, .8 )

		if shouldChangeLeader then
			shouldChangeLeader = false
			self:SetNextLeader()
		end
	end

	surface.DrawTexturedRect( logoX, 0, 128 * s, 128 * s )

	// Finish line
	-- surface.SetDrawColor( 255, 255, 255, 50 )
	-- surface.SetTexture( self.Mat.Flag )
	-- surface.DrawTexturedRect( -300, 880, w + 600, 150 )

end

local SelfCam = Material( "SelfCam" )

hook.Add( "HUDPaint", "SelfCamPaint", function()

	if GAMEMODE:GetState() != STATE_PLAYING then return end

	local oldW, oldH = ScrW(), ScrH()
	local OldRT = render.GetRenderTarget()

	render.CopyRenderTargetToTexture( CAMERA_RT )
	render.SetViewPort( 0, 0, 1024, 512 )
	render.SetRenderTarget( CAMERA_RT )

	cam.Start2D()
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(SelfCam)
		surface.DrawTexturedRect(0,-100,1024,512)
	cam.End2D()

	pcall( function()

		if GAMEMODE:GetState() == STATE_PLAYING then

			hasLeader = false

			// Get the leader
			local leader = GAMEMODE.CurrentLeader
			if !IsValid( leader ) then return end

			local kart = leader:GetKart()
			if !IsValid( kart ) then return end

			local camera = {}
				camera.angles = kart:GetAngles() + Angle( 15, RealTime() * 30, 0 )
				camera.origin = kart:GetPos() + kart:GetUp() * 24 + camera.angles:Forward() * -180
				camera.x = 0
				camera.y = 0
				camera.w = 512
				camera.h = 512

				// Super ultrawide.
				camera.aspect = 32/6

			pcall( render.RenderView, camera )

			hasLeader = true

		end

	end )

	render.SetRenderTarget( OldRT )
	render.SetViewPort( 0, 0, oldW, oldH )

end)
