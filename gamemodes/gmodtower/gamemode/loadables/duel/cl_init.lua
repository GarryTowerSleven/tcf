include( "cl_panel.lua" )
include( "shared.lua" )
include( "sh_player.lua" )

module( "Dueling", package.seeall )

surface.CreateFont( "DuelType", { font = "Oswald", size = 42, weight = 400 } )
surface.CreateFont( "DuelName", { font = "Oswald", size = 54, weight = 600 } )
surface.CreateFont( "DuelTime", { font = "Oswald", size = 52, weight = 400 } )
surface.CreateFont( "DuelBigName", { font = "Oswald", size = 48, weight = 400 } )
surface.CreateFont( "DuelExtraLarge", { font = "Oswald", size = 72, weight = 400 } )
surface.CreateFont( "DuelHealthName", { font = "Oswald", size = 24, weight = 400 } )

local ignoreDuel = CreateClientConVar( "gmt_ignore_duel", 0, true, false )

DuelVGUI = nil
DuelStartTime = nil
DuelTime = nil
DuelEndTime = nil
DuelWinText = ""

DuelMusic = nil
DuelMusicTime = 60

function StartDuelClient()
	GTowerMainGui.HideMenus()
	DuelStartTime = CurTime() + DuelStartDelay
	DuelTime = CurTime() + MaxDuelTime + DuelStartDelay
	DuelVGUI = vgui.Create( "DuelScreen" )
	DuelVGUI:SetPlayers( LocalPlayer(), LocalPlayer().DuelOpponent )

	timer.Simple(DuelStartDelay, function()
		PlayDuelMusic()
	end)

 	vgui.CloseDermaMenus()
end

local function EndDuelClient( won )
	if IsValid( DuelVGUI ) then
		DuelVGUI:Remove()
		DuelVGUI = nil
	end

	if DuelMusic then
		DuelMusic:Stop()
		DuelMusic = nil
	end


	if !IsDueling( LocalPlayer() ) then return end

	DuelEndTime = CurTime() + 5

	DuelWinText = "YOU LOST"

	DuelTime = nil

	ShowWinText = true

	timer.Simple(6,function() ShowWinText = false end)

	if won then
		surface.PlaySound( "GModTower/lobby/duel/duel_win.mp3" )

		DuelWinText = "YOU WIN!"
	else
		surface.PlaySound( "GModTower/lobby/duel/duel_lose.mp3" )
	end
end

net.Receive("EndDuelClient", function()
	local won = net.ReadBool()
	local Opponent = net.ReadEntity()

	EndDuelClient( won )

	Opponent.DuelOpponent = nil
	LocalPlayer().DuelOpponent = nil
end)

function PlayDuelMusic()
	local song = "GModTower/lobby/duel/duel_song" .. math.random( 1, 8 ) .. ".mp3"

	DuelMusic = CreateSound( LocalPlayer(), song )

	if DuelMusic then
		DuelMusic:Play()
	end
end

function DrawHUDTimer()
	if !DuelTime then return end

	local TimeLeft = DuelTime - CurTime()

	if TimeLeft < 0 then
		TimeLeft = 0
		if LocalPlayer():Alive() and IsValid( LocalPlayer().DuelOpponent ) and LocalPlayer().DuelOpponent:Alive() then
			net.Start("SuddenDeath")
			net.SendToServer()
		end
	end

	/*local ElapsedTime = string.FormattedTime( TimeLeft )
	ElapsedTime = math.Round( ElapsedTime.s )*/

	local ElapsedTime = string.FormattedTime( TimeLeft, "%02i:%02i")

	draw.SimpleTextOutlined( ElapsedTime, "DuelTime", ScrW() / 2, 20, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, nil, 2, Color( 0, 0, 0 ) )
end

local gradientUp = surface.GetTextureID( "VGUI/gradient_up" )
local maxBarHealth = 100
local deltaVelocity = 0.08 -- [0-1]
local bw = 12 -- bar segment width
local padding = 2
local curPercent = nil

function DrawHealthBar( ply )
	if !DuelTime then return end

	local name = string.upper( ply:Name() )
	local health = ply:Health()
	local maxHealth = 300

	-- Let's do some calculations first
	maxBarHealth = maxHealth
	local curHealthBar = math.floor( health / maxBarHealth )

	if health % maxBarHealth == 0 then
		curHealthBar = curHealthBar - 1
	end

	local percent = ( health - curHealthBar * maxBarHealth ) / maxBarHealth
	curPercent = !curPercent and 1 or math.Approach( curPercent, percent, math.abs( curPercent - percent ) * 0.08 )

	local x, y = ScrW() / 2, 80
	local w, h = ScrW() / 3, 20

	-- Name
	surface.SetFont( "DuelHealthName" )
	local tw, th = surface.GetTextSize( name )
	local x3, y3 = x-(w/2), y + h - padding * 2
	local w3, h3 = tw + padding*4, th + padding

	draw.RoundedBox( 4, x3, y3, w3, h3, Color( 0, 0, 0, 200 ) )
	draw.SimpleText( name, "DuelHealthName", x3 + padding*2, y3 + padding, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

	-- Health bar background
	draw.RoundedBox( 4, x-(w/2), y, w, h, Color( 0, 0, 0, 200 ) )

	-- Health bar
	//local color = ply:GetPlayerColor() * 255
	//color = Color( math.Clamp( color.r, 30, 255 ), math.Clamp( color.g, 30, 255 ), math.Clamp( color.b, 30, 255 ) )

	//local darkColor = Color( color.r - 25, color.g - 25, color.b - 25 )

	local x2, y2 = x-(w/2) + padding, y + padding
	local w2, h2 = w - padding * 2, h - padding * 2
	draw.RoundedBox( 4, x2, y2, w2, h2, Color(31, 31, 31), 50 )
	draw.RoundedBox( 0, x2, y2, w * curPercent - padding * 2, h2, Color(255, 0, 0) )

	surface.SetDrawColor( 0, 0, 0, 100 )
	surface.SetTexture( gradientUp )
	surface.DrawTexturedRect( x2, y2, w2, h2 )
end

hook.Add( "HUDPaint", "HUDPaintDueling", function()
	DrawHUDTimer()

	if LocalPlayer().DuelOpponent then
		DrawHealthBar( LocalPlayer().DuelOpponent )
		--DrawHealth( LocalPlayer().DuelOpponent )
	end

	if ShowWinText then

			local tx, ty = ScrW() / 2, ScrH() / 2
			draw.SimpleText( DuelWinText, "DuelExtraLarge", tx + 2, ty + 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( DuelWinText, "DuelExtraLarge", tx, ty, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	end
end )

hook.Add( "PreDrawHalos", "DuelHalo", function()

	if LocalPlayer().DuelOpponent then

		local l = LocalPlayer().DuelOpponent:Health() / 300 // LocalPlayer().DuelOpponent:GetMaxHealth()
		local c = Color( 255, 255, 255 )
		c.r = 255 * ( 1 - l )
		c.g = 255 * l
		c.b = 0
		halo.Add( {LocalPlayer().DuelOpponent}, c, 1, 1, 2, true, false )

	end

end )

hook.Add( "Think", "DuelMusicThink", function()
	if !Dueling.IsDueling( LocalPlayer() ) && DuelMusic then
		DuelMusic:Stop()
	end
end )

net.Receive( "StartDuel", function( len )
	local req = net.ReadEntity()
	local ply = net.ReadEntity()

	if IsValid( req ) and LocalPlayer() == req then
		LocalPlayer().DuelOpponent = ply
		StartDuelClient()
	end

	if IsValid( ply ) and LocalPlayer() == ply then
		LocalPlayer().DuelOpponent = req
		StartDuelClient()
	end
end )

net.Receive( "InviteDuel", function( len )
	local amount = net.ReadInt(32)
	local arriver = net.ReadEntity()
	local Inviter = net.ReadEntity()
	local weapon = net.ReadString()

	if LocalPlayer() != arriver then return end

	if ignoreDuel:GetBool() then

		RunConsoleCommand( "gmt_dueldeny", Inviter:EntIndex() )
		return

	end

	local Question = Msg2( T( "DuelRequest", Inviter:GetName(), weapon, amount ), 25.0 )

	Question:SetupQuestion(
		function() RunConsoleCommand( "gmt_duelaccept", Inviter:EntIndex() ) end, //accept
		function() RunConsoleCommand( "gmt_dueldeny", Inviter:EntIndex() ) end, //decline
		function() RunConsoleCommand( "gmt_dueldeny", Inviter:EntIndex() ) end, //timeout
		nil,
		{120, 160, 120},
		{160, 120, 120}
	)
end )
