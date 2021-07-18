
local HeartMat  = Material( "gmod_tower/halloween/hud_heart" )
local CircleMat = Material( "vgui/circle" )
local StaticMat = Material( "room209/static" )

local ShouldDrawHW = IsHalloweenMap()

surface.CreateFont( "HalloweenFontSmall", {
	font = "Roboto Cn",
	size = 72,
	weight = 1500,
	antialias = true,
  bold = true,
} )

surface.CreateFont( "HalloweenFontSmaller", {
	font = "Roboto Cn",
	size = 32,
	weight = 1500,
	antialias = true,
} )

local tab = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = -0.15,
	["$pp_colour_contrast"] = 2,
	["$pp_colour_colour"] = 0.05,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

hook.Add( "RenderScreenspaceEffects", "SpookyTower", function()
  if (!ShouldDrawHW || (LocalPlayer().Location != 15 && LocalPlayer().Location != 14)) then return end
	DrawColorModify( tab ) --Draws Color Modify effect
end)

local function DrawStatic( amount )
  surface.SetMaterial( StaticMat )
  surface.SetDrawColor( Color( 255, 255, 255, amount ) )
  surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
end

local function Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end


local function DrawRecord( x, y )
  surface.SetFont("HalloweenFontSmall")
  surface.SetTextColor( 255, 255, 255, 255 )
  local TextX, TextY = surface.GetTextSize("REC")
  surface.SetTextPos( x - (TextX / 2), y )
  surface.DrawText("REC")

  local a = 255

  if (CurTime() % 2 < 1 ) then a = 0 end

  surface.SetDrawColor( Color( 255, 0, 0, a ) )
  surface.SetMaterial( CircleMat )
  Circle( x - TextX, y + ( TextY / 2 ), 16, 128 )

end

local function DrawHeart()
  local Beat = math.sin( CurTime() * 10 ) * 12

  surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
  surface.SetMaterial( HeartMat )
  surface.DrawTexturedRect( ScrW() / 50 - Beat / 2, ScrH() / 1.175 - Beat / 2, 128 + Beat, 128 + Beat )
end

local function DrawLines()
  surface.SetDrawColor( Color( 255, 255, 255, 255 ) )

  // Top Left
  surface.DrawLine( ScrW() / 4, ScrH() / 4, ScrW() / 4 + 100, ScrH() / 4 )
  surface.DrawLine( ScrW() / 4, ScrH() / 4, ScrW() / 4, ScrH() / 4 + 100 )

  // Bottom Left
  surface.DrawLine( ScrW() / 4, ScrH() - ScrH() / 4, ScrW() / 4 + 100, ScrH() - ScrH() / 4 )
  surface.DrawLine( ScrW() / 4, ScrH() - ScrH() / 4, ScrW() / 4, ScrH() - ScrH() / 4 - 100 )

  // Top Right
  surface.DrawLine( ScrW() - ScrW() / 4, ScrH() / 4, ScrW() - ScrW() / 4 - 100, ScrH() / 4 )
  surface.DrawLine( ScrW() - ScrW() / 4, ScrH() / 4, ScrW() - ScrW() / 4, ScrH() / 4 + 100 )

  // Bottom Right
  surface.DrawLine( ScrW() - ScrW() / 4, ScrH() - ScrH() / 4, ScrW() - ScrW() / 4 - 100, ScrH() - ScrH() / 4 )
  surface.DrawLine( ScrW() - ScrW() / 4, ScrH() - ScrH() / 4, ScrW() - ScrW() / 4, ScrH() - ScrH() / 4 - 100 )

end

local function DrawBattery( x, y, percent )

	local w, h = 34 * 2, 16 * 2

	surface.SetDrawColor(255,255,255,255)

	if percent <= .2 then

		surface.SetDrawColor(255,0,0,SinBetween(50,255, RealTime() * 20))

	end

	local thickness = 3

  surface.SetFont( "HalloweenFontSmaller" )
  surface.SetTextPos( x - surface.GetTextSize( "DETECTOR BATTERY:  " ), y )
  surface.SetTextColor(255,255,255,255)
  surface.DrawText( "DETECTOR BATTERY: " )

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

hook.Add("HUDPaint", "HWHUDPaint", function()

    if (!ShouldDrawHW || (LocalPlayer().Location != 15 && LocalPlayer().Location != 14)) then return end

    // DRAW STUFF

    if LocalPlayer():InVehicle() then return end

    --self:DrawHeart()
    DrawLines()

    --self:DrawBattery( ScrW() - ScrW() / 8, ScrH() - ScrH() / 8, LocalPlayer():GetBattery() )

    DrawRecord( ScrW() - (ScrW() / 8), ScrH() / 16 )

    local Health = LocalPlayer():Health()
    local dist = LocalPlayer():GetPos():Distance( Vector(8199.96875, -1176.5666503906, -607.96875) )
    local amount = 255 - dist/4
    DrawStatic( math.Clamp( amount, 100, 255 ) )

end)
