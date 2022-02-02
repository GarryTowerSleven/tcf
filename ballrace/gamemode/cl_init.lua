include("shared.lua")
include("cl_choose.lua")
include("cl_message.lua")

local hud_lives = surface.GetTextureID( "gmod_tower/balls/hud_main_lives" )
local hud_bananas = surface.GetTextureID( "gmod_tower/balls/hud_main_bananas" )
local hud_timer = surface.GetTextureID( "gmod_tower/balls/hud_main_timer" )

local hud_icon_clock = surface.GetTextureID( "gmod_tower/balls/hud_icon_clock" )
local hud_icon_banana = surface.GetTextureID( "gmod_tower/balls/hud_icon_banana" )
local hud_icon_antlion = surface.GetTextureID( "gmod_tower/balls/hud_icon_antlion" )

local OUTLINE_COLOR = Color( 166, 117, 80 )

surface.CreateFont( "BallMessage", { font = "Bebas Neue", size = 48, weight = 200 } )
surface.CreateFont( "BallMessageCaption", { font = "Bebas Neue", size = 26, weight = 200 } )
surface.CreateFont( "BallPlayerName", { font = "Coolvetica", size = 32, weight = 500 } )
surface.CreateFont( "BallFont", { font = "Coolvetica", size = 48, weight = 200 } )

hook.Add( "OverrideHatEntity", "OverrideHat", function( ply ) 

	if !ply.GetBall then return false end

	local ball = ply:GetBall()

	if ply:Team() == TEAM_PLAYERS && IsValid(ball) && ball:GetOwner() == ply then
		return ball.PlayerModel
	end

end )

hook.Add( "ShouldHideHats", "ShouldHideHats", function( ply ) 

	if !ply.GetBall then return true end

	local ball = ply:GetBall()
	if ply:Team() != TEAM_PLAYERS || !IsValid(ball) then
		return true
	end

end )

local chat_offset = Vector(0, 0, 64)
hook.Add( "ChatBubbleOverride", "OverrideChatBubble", function( ply )

	if !IsValid( ply ) then
		return false
	end

	if !ply.GetBall then return false end

	local ball = ply:GetBall()

	if ply:Team() == TEAM_PLAYERS && IsValid(ball) && ball:GetOwner() == ply then
		return ball:GetPos() + chat_offset
	end

	return false

end )

hook.Add( "AFKDrawOverride", "BallRaceAFKDraw", function( ply )

	if !ply.GetBall then return Vector( 0, 0, 0 ) end

	local ball = ply:GetBall()
	if IsValid( ball ) && IsValid( ball.PlayerModel ) then
		return ball.PlayerModel:GetPos() + Vector( 0, 0, 0 )
	end

end )

// Speed HUD
local lastSpeed = 0
local antlionRot = 0

// Banana HUD
local bananas = 0
local lastBanana = 0
local bananaTime = 0
local bananaRot = 0
local bananaSize = 0
local curRot = 0

// Timer HUD
local timerSize = 0

function GM:HUDPaint()

	local lives, speed = 0, 0

	if IsValid( LocalPlayer() ) then
		lives = LocalPlayer():Deaths()

		lastBanana = bananas
		bananas = LocalPlayer():Frags()

		lastSpeed = speed
		speed = LocalPlayer().Speed or 0
	end

	local state = GetState()
	local endtime = GetTime() or 0

	local timeleft = endtime - CurTime()
	local timeformat = string.FormattedTime(timeleft, "%02i:%02i")

	local buffer = ""
	if state == STATE_WAITING then
		buffer = "WAITING FOR PLAYERS"
	elseif (state == STATE_PLAYING || state == STATE_PLAYINGBONUS) then

		if IsValid(LocalPlayer()) then
			local ball = LocalPlayer():GetBall()
			local team = LocalPlayer():Team()

			if IsValid(ball) && ball:GetClass() == "player_ball" then
				if ball:GetOwner() != LocalPlayer() then
					buffer = "SPECTATING " .. string.upper( tostring( ball:GetOwner():Name() ) )
				end
			else
				if team == TEAM_PLAYERS then
					buffer = "YOU ARE DEAD"
				else
					buffer = "SPECTATING"
				end
			end
		end

	/*elseif state == STATE_INTERMISSION then
		buffer = "Intermission"*/
	end

	if state != STATE_INTERMISSION then
		surface.SetDrawColor( 255, 255, 255, 255 )

		if state != STATE_WAITING then

			// Lives BG
			local livesX, livesY = 12, 12
			surface.SetTexture( hud_lives )
			surface.DrawTexturedRect( livesX, livesY, 256, 128 )

			// Lives Icon
			if LocalPlayer():Alive() && LocalPlayer():Team() == TEAM_PLAYERS then
				local changeSpeed = math.floor( ( lastSpeed - speed ) )
				if changeSpeed < -9 then
					changeSpeed = changeSpeed * .009 // yay magic numbers!! this is to lower the speed for rotation
					antlionRot = antlionRot + changeSpeed
				end

				surface.SetTexture( hud_icon_antlion )
				surface.DrawTexturedRectRotated( livesX + 51, livesY + 52, 128, 128, antlionRot )
			end

			// Banana BG
			local bananaX, bananaY = ScrW() - 268, 12
			surface.SetTexture( hud_bananas )
			surface.DrawTexturedRect( bananaX, bananaY, 256, 128 )

			// Banana Icon
			if lastBanana != bananas then // check bananas for animation
				curRot = bananaRot
				bananaTime = CurTime() + 1
			end

			if CurTime() > bananaTime then
				bananaRot = math.Approach( bananaRot, 0, .09 ) // halt animation
				bananaSize = math.Approach( bananaSize, 0, .09 ) // halt animation
			else
				bananaRot = curRot + ( 10 * math.sin( CurTime() * 5 ) ) // animate!
				bananaSize = 30 * math.sin( CurTime() * 5 ) // animate!
			end

			surface.SetTexture( hud_icon_banana )
			surface.DrawTexturedRectRotated( ScrW() - 63, bananaY + 52, 128 + ( bananaSize * 2 ), 128 + ( bananaSize * 2 ), bananaRot )


			// Text
			draw.SimpleTextOutlined( lives, "BallFont", 150, 95, Color( 255, 255, 255, 255), 1, 1, 2, OUTLINE_COLOR )
			draw.SimpleTextOutlined( bananas, "BallFont", ScrW() - 180, 95, Color( 255, 255, 255, 255), 1, 1, 2, OUTLINE_COLOR )
		end

		if timeleft >= 0 then

			// Timer BG
			local timerX, timerY = (ScrW() / 2) - 128, 10
			surface.SetTexture( hud_timer )
			surface.DrawTexturedRect( timerX, timerY, 256, 128 )

			// Timer Icon
			local sway = 6 * math.sin( CurTime() * 2 )
			local color = Color( 255, 255, 255, 255 )

			if timeleft <= 10 then
				color = Color( 255, 0, 0, 255 )
				timerSize = math.abs( 15 * math.sin( CurTime() * ( timeleft/60 * 2 ) ) ) // animate!
			else
				timerSize = math.Approach( timerSize, 0, .09 ) // halt animation
			end

			surface.SetTexture( hud_icon_clock )
			surface.SetDrawColor( color.r, color.g, color.b, color.a )
			surface.DrawTexturedRectRotated( ScrW() / 2, timerY + 40, 128 + ( timerSize * 2 ), 128 + ( timerSize * 2 ), sway )


			// Text
			if timeleft <= 10 then
				draw.SimpleTextOutlined( timeformat, "BallFont", (ScrW() / 2), 105, Color( 255, 0, 0, 255 ), 1, 1, 2, Color( 255, 255, 255, 255 ) )
			else
				draw.SimpleTextOutlined( timeformat, "BallFont", (ScrW() / 2), 105, Color( 255, 255, 255, 255 ), 1, 1, 2, OUTLINE_COLOR )
			end
		end
	end

	if buffer != "" then
	//if (state != STATE_PLAYING && state != STATE_PLAYINGBONUS) then
		surface.SetDrawColor( 0, 0, 0, 250 )
		surface.DrawRect( 0, ScrH() - 60, ScrW(), 60 )

		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect( 0, ScrH() - 60, ScrW(), 3 )

		draw.SimpleText( buffer, "BallMessage", ScrW() / 2, ScrH() - 30, Color( 255, 255, 255, 255 ), 1, 1 )
	end
end

local dist = 200
local wantdist = 200

function ZoomCam(ply, bind, pressed)
	local amt = 20

	local ball = ply:GetBall()

	if !IsValid(ball) then return end

	local distmin = ball:BoundingRadius()

	if dist == 0 then
		dist = distmin * 2
		wantdist = dist
	end

	if bind == "invnext" then
		wantdist = dist + amt
	elseif bind == "invprev" then
		wantdist = dist - amt
	end

	wantdist = math.Clamp(wantdist, distmin, 500)
end

function ZoomThink()
	dist = math.Approach(dist, wantdist, 500 * FrameTime())
end

hook.Add("PlayerBindPress", "ZoomCam", ZoomCam)
hook.Add("Think", "ZoomThink", ZoomThink)

local lastview = nil

function GM:CalcView( ply, origin, angles, fov )
	local ball = ply:GetBall()

	local view = {}
	view.origin 	= origin
	view.angles	= angles
	view.fov 	= fov

	if !IsValid(ball) || !ball.Center then
		return lastview or view
	end

	view.origin, dist = ply:CameraTrace(ball, dist, angles)

	lastview = view

	return view
end

function MouseEnable(ply, key)
	if key == IN_WALK then
		RestoreCursorPosition()
		gui.EnableScreenClicker(true)
	end
end

function MouseDisable(ply, key)
	if key == IN_WALK then
		RememberCursorPosition()
		gui.EnableScreenClicker(false)
	end
end

function MouseClick(mc)
	if mc == MOUSE_LEFT && lastview then
		local cursorvec = GetMouseVector()

		local origin = lastview.origin
		local trace = util.TraceLine({start=origin, endpos=origin + cursorvec * 9000, filter=ball})

		if IsValid(trace.Entity) && trace.Entity:GetClass() == "player_ball" then
			GTowerClick:ClickOnPlayer( trace.Entity:GetOwner(), mc )
		else
			RunConsoleCommand("mouse_click", dist, cursorvec.x, cursorvec.y, cursorvec.z)
		end
	end
end

hook.Add("KeyPress", "MouseEnable", MouseEnable)
hook.Add("KeyRelease", "MouseDisable", MouseDisable)
hook.Add("GUIMousePressed", "MouseClick", MouseClick)

local hide = {
	CHudHealth = true,
	CHudBattery = true,
	CHudAmmo = true,
}

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if ( hide[ name ] ) then return false end
end )

ConVarPlayerFade = CreateClientConVar( "gmt_ballrace_fade", 0, true )

hook.Add( "PostDrawTranslucentRenderables", "BallraceBall", function( bDrawingDepth, bDrawingSkybox )
	local pf = ConVarPlayerFade:GetInt()
	if pf < 1 then return end // Fk player fade man

	for _, ply in pairs( player.GetAll() ) do
		local ball = ply:GetBall()
		local opacity = 255

		if ply:Alive() and ply:Team() == TEAM_PLAYERS then // Leave dem spectators alone
			if ply == LocalPlayer() then continue end // Skip ourselves
			
			if IsValid( ball ) then
				if !LocalPlayer():Alive() or LocalPlayer():Team() != TEAM_PLAYERS then // Spectating
					ball:SetRenderMode( RENDERMODE_TRANSALPHA )
					ball:SetColor( Color( 255, 255, 255, 255 ) )
					continue
				end
				local distance = LocalPlayer():EyePos():Distance( ball:GetPos() )
				opacity = math.Clamp( (distance / math.Clamp(pf, 1, 2048)) * 255, 0, 255 ) // Close enough

				ball:SetRenderMode( RENDERMODE_TRANSALPHA )
				--ball:SetColor( Color( 255, 255, 255, opacity ) )
			end
		end

		if IsValid( ball ) then
			ball:SetColor( Color( 255, 255, 255, opacity ) )
		end
	end

end )