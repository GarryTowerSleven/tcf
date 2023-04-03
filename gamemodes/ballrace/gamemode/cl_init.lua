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

local waitCams = {
	["gmt_ballracer_skyworld01"] = {
		origin = Vector( 714.98, -754.61, 83.3 ),
		angles = Angle( -4.82, 57.82, 0 ),
		fov = 70
	},

	["gmt_ballracer_paradise03"] = {
		origin = Vector( -2465.91, 3476.42, 97.37 ),
		angles = Angle( 3.06, -134.73, 0 ),
		fov = 70
	},

	["gmt_ballracer_grassworld01"] = {
		origin = Vector( -3589.29, 184.85, -270.66 ),
		angles = Angle( -2.88, -46.12, 0 ),
		fov = 70
	},

	["gmt_ballracer_iceworld03"] = {
		origin = Vector( 15316.54, -2407.59, 4563.8 ),
		angles = Angle( -3.5, 117.31, -0.94 ),
		fov = 70
	},

	["gmt_ballracer_khromidro02"] = {
		origin = Vector( -2436.78, -8172.88, 6.28 ),
		angles = Angle( -8.91, 37.8, 0 ),
		fov = 70
	},

	["gmt_ballracer_sandworld02"] = {
		origin = Vector( -2827.54, 169.35, 66.26 ),
		angles = Angle( -5, -115.5, 0 ),
		fov = 60
	},

	["gmt_ballracer_memories02"] = {
		origin = Vector( -7534.23, -6870.77, -1579.51 ),
		angles = Angle( -21.63, 49.83, 0 ),
		fov = 75
	},

	["gmt_ballracer_flyinhigh01"] = {
		origin = Vector( -2738.96, -12664.52, -184.47 ),
		angles = Angle( -5.27, 21.73, 0 ),
		fov = 70
	},

	["gmt_ballracer_neonlights01"] = {
		origin = Vector( -2098.01, 4244.77, 1703.15 ),
		angles = Angle( -2.29,-140.11, 0 ),
		fov = 70
	},

	["gmt_ballracer_waterworld02"] = {
		origin = Vector( 4271.66, 886.47, -2226.30 ),
		angles = Angle( -16.59, -51.16, 0 ),
		fov = 70
	},
	
	["gmt_ballracer_nightball"] = {
		origin = Vector( -3749.69, 11127.10, 328.33 ),
		angles = Angle( -2.2, 20, 0 ),
		fov = 70
	},

	["gmt_ballracer_metalworld"] = {
		origin = Vector( 13261.38, 2545.33, 191.68 ),
		angles = Angle( -3.54, -43.85, 0 ),
		fov = 70
	},
	
	["gmt_ballracer_spaceworld01"] = {
		origin = Vector( -1529.24, 1202.39, 194.8 ),
		angles = Angle( 1.54, -13, 0 ),
		fov = 70
	},

	["gmt_ballracer_facile"] = {
		origin = Vector( 6849.89, 4036.21, -1319.66 ),
		angles = Angle( 2.44, -112.38, 0 ),
		fov = 70
	},
	
	["gmt_ballracer_tranquil01"] = {
		origin = Vector( -11684.64, 13856.83, 36.693 ),
		angles = Angle( -6.044, -130.5, 0 ),
		fov = 70
	},
	
	["gmt_ballracer_midori02"] = {
		origin = Vector( -9218.5, -2028.57, 2675.98 ),
		angles = Angle( 19.06, 81.8, 0 ),
		fov = 70
	}
}

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
local convar = CreateClientConVar("gmt_ballrace_ms", "0", true)

function GM:HUDPaint()

	local lives, speed = 0, 0

	if IsValid( LocalPlayer() ) then
		lives = LocalPlayer():Deaths()

		lastBanana = bananas
		bananas = LocalPlayer():Frags()

		lastSpeed = speed
		speed = LocalPlayer().Speed or 0
	end

	local state = self:GetState()
	local endtime = self:GetTime() or 0

	local timeleft = endtime - CurTime()
	local ms = convar:GetBool() and ".%02i" or ""
	local timeformat = string.FormattedTime(timeleft, "%02i:%02i" .. ms)

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


			surface.SetFont("BallFont")
			local tw = surface.GetTextSize(!convar:GetBool() && timeformat || "88:88:88")
			// Text
			if timeleft <= 10 then
				draw.SimpleTextOutlined( timeformat, "BallFont", (ScrW() / 2) - tw / 2, 105, Color( 255, 0, 0, 255 ), 0, 1, 2, Color( 255, 255, 255, 255 ) )
			else
				draw.SimpleTextOutlined( timeformat, "BallFont", (ScrW() / 2) - tw / 2, 105, Color( 255, 255, 255, 255 ), 0, 1, 2, OUTLINE_COLOR )
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
local tilt = Angle(0, 0, 0)
local convar = CreateClientConVar("gmt_ballrace_tilt", "0", true, false, "Tilting the camera, for extra fun (and sickness!)", -24, 24)

function GM:CalcView( ply, origin, angles, fov )
	local ball = ply:GetBall()

	local view = {}
	view.origin 	= origin
	view.angles	= angles
	view.fov 	= fov

	eyepos = origin

	if !IsValid(ball) || !ball.Center || !ply:Alive() then

		if self:GetState() == STATE_WAITING and waitCams[ game.GetMap() ] then
			return waitCams[ game.GetMap() ]
		end

		view.origin = ply:CameraTrace(nil, dist, angles)
		view.angles = IsValid(ball) and ball.Center and (ball:Center() - view.origin):Angle() or angles

		return view
	end

	view.origin, dist = ply:CameraTrace(ball, dist, angles)
	view.origin = view.origin + Vector(0, 0, 8)

	lastview = view
	lastball = ball:Center()
	eyepos = view.origin

	local a = convar:GetInt()

	if a ~= 0 && !ply.Spectating then
		local tilta = Angle(0, 0, 0)
		tilta.r = ply:KeyDown(IN_MOVERIGHT) and -a or ply:KeyDown(IN_MOVELEFT) and a or 0
		tilta.p = ply:KeyDown(IN_FORWARD) and -a or ply:KeyDown(IN_BACK) and a or 0

		tilt = LerpAngle(FrameTime() * 4, tilt, tilta)
		view.angles = view.angles + tilt
		view.origin = view.origin + angles:Up() * tilt.p * 2 + angles:Right() * tilt.r * 0.4
	end

	return view
end

local skies = {
	lf = "",
	rt = "",
	up = "",
	dn = "",
	ft = "",
	bk = ""
}

local skybox = GetConVar("sv_skyname"):GetString()



SETUPSKY = true
function GM:PostDraw2DSkyBox()
	if !convar:GetBool() then return end
	if SETUPSKY then
		for _, sky in pairs(skies) do
			skies[_] = Material("skybox/" .. skybox .. _)
		end

		SETUPSKY = false
	end

	render.SetColorMaterial()
	render.CullMode(MATERIAL_CULLMODE_CW)
	render.DrawSphere(EyePos(), 128, 4, 4, color_black)
	render.SetMaterial(skies["rt"])
	render.CullMode(MATERIAL_CULLMODE_CCW)
	cam.Start3D(eyepos, EyeAngles() - tilt)
	local s = 64
	local s2 = s / 2
	render.DrawQuadEasy( eyepos + Vector(s2, 0, 0), Vector(-1,0,0), s, s, Color(255,255,255), 180 )
	render.SetMaterial(skies["lf"])
	render.DrawQuadEasy( eyepos - Vector(s2, 0, 0), Vector(1,0,0), s, s, Color(255,255,255), 180 )

	render.SetMaterial(skies["bk"])
	render.DrawQuadEasy( eyepos + Vector(0, s2, 0), Vector(0,-1,0), s, s, Color(255,255,255), 180 )
	render.SetMaterial(skies["ft"])
	render.DrawQuadEasy( eyepos - Vector(0, s2, 0), Vector(0,1,0), s, s, Color(255,255,255), 180 )

	render.SetMaterial(skies["dn"])
	render.DrawQuadEasy( eyepos - Vector(0, 0, s2), Vector(0,0,1), s, s, Color(255,255,255), 0 )
	render.SetMaterial(skies["up"])
	render.DrawQuadEasy( eyepos + Vector(0, 0, s2), Vector(0,0,-1), s, s, Color(255,255,255), 0 )
	render.CullMode(MATERIAL_CULLMODE_CCW)
	cam.End3D()
	return true
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

ConVarPlayerFade = CreateClientConVar( "gmt_ballrace_fade", 0, true )

hook.Add( "PostDrawTranslucentRenderables", "BallraceBall", function( bDrawingDepth, bDrawingSkybox )
	EyePos()

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

			if !ply:Alive() && ply == LocalPlayer() then
				cam.IgnoreZ(true)
				ball:Draw()
				cam.IgnoreZ(false)
			end
		end
	end

end )