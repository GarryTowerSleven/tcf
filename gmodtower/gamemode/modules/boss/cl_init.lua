
include("shared.lua")

net.Receive( "gmt_boss", function()
  StartBossBattle()
end)

local MusicLocs = {
[16] = true,
[17] = true,
[18] = true,
}

function KickInBeats()

  if !MusicLocs[LocalPlayer().GLocation] then return end

  sound.PlayURL("http://k007.kiwi6.com/hotlink/2zpezorup1/aiboss.mp3",
  "",
  function(s) s:Play() end)

end

function ShakeThemScreens()

end

function StartBossBattle()
  Msg2("Defeat the AI in the plaza!")
  KickInBeats()
end

local gradientUp = surface.GetTextureID( "VGUI/gradient_up" )
local maxBarHealth = 100
local deltaVelocity = 0.08 -- [0-1]
local bw = 12 -- bar segment width
local padding = 2
local curPercent = nil

function DrawHealthBarBoss( ent )
	local name = string.upper( BossName )
	local health = ent:GetNWFloat("Health") or 0
	local maxHealth = 100

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

hook.Add( "HUDPaint", "HUDPaintBoss", function()
  if IsValid(ents.FindByClass("gmt_boss_ai")[1]) then
    DrawHealthBarBoss( ents.FindByClass("gmt_boss_ai")[1] )
  end
end )
