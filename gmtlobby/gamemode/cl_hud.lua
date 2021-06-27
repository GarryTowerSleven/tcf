local mainfont = "CenterPrintText"
surface.CreateFont( "tiny", { font = "Arial", size = 10, weight = 100 } )
surface.CreateFont( "smalltiny", { font = "Arial", size = 12, weight = 100 } )
surface.CreateFont( "small", { font = "Arial", size = 14, weight = 400 } )
surface.CreateFont( "smalltitle", { font = "Arial", size = 16, weight = 600 } )
surface.CreateFont( "Gtowerhuge", { font = mainfont, size = 45, weight = 100 } )
surface.CreateFont( "Gtowerbig", { font = mainfont, size = 28, weight = 125 } )
surface.CreateFont( "Gtowerbigbold", { font = mainfont, size = 20, weight = 1200 } )
surface.CreateFont( "Gtowerbiglocation", { font = mainfont, size = 28, weight = 125 } )
surface.CreateFont( "Gtowermidbold", { font = mainfont, size = 16, weight = 1200 } )
surface.CreateFont( "Gtowerbold", { font = mainfont, size = 14, weight = 700 } )
surface.CreateFont( "Gtowerboldbig", { font = mainfont, size = 20, weight = 700 } )

GTowerHUD = {}

table.insert( GtowerHudToHide, "CHudHealth" )
table.insert( GtowerHudToHide, "CHudAmmo" )
table.insert( GtowerHudToHide, "CHudSecondaryAmmo" )
table.insert( GtowerHudToHide, "CHudBattery" )
table.insert( GtowerHudToHide, "CHudZoom" )

// draw the hud?
GTowerHUD.Enabled = CreateClientConVar( "gmt_hud", 1, true, false )
local HideBetaMessage = CreateClientConVar( "gmt_hidebetamsg", 0, true, false )

--GTowerHUD.Notice = {
--	Enabled = CreateClientConVar( "gmt_notice", 1, true, false ),
--}

GTowerHUD.Notice = {
	Enabled = CreateClientConVar( "gmt_notice", 1, true, false ),
	Title = "BETA RELEASE - KNOWN BUGS:",
	Text = "TV's don't work, Trivia doesn't work, pool tubes don't work, models in the TAB menu don't work properly, emotes aren't done yet.",
	--Text = "CHANGING LEVEL, REJOIN IF IT BREAKS!!",
}

// because native weapons don't have a way of giving us a max clip count
// we need to cache the highest values we see
GTowerHUD.MaxAmmo = {}



-- Main HUD


local HUDBackground = Material( "gmod_tower/hud/bg_gradient_deluxe.png", "unlightsmooth" )
local HUDLogo = Material( "gmod_tower/hud/logo_flat_deluxe.png", "unlightsmooth" )

if IsHalloweenMap() then
  HUDBackground = Material( "gmod_tower/hud/bg_gradient_deluxe_h.png", "unlightsmooth" )
  HUDLogo = Material( "gmod_tower/hud/logo_flat_deluxe_h.png", "unlightsmooth" )
end

GTowerHUD.Info = {

	Enabled = CreateClientConVar( "gmt_hud_info", 1, true, false ),

	Texture = HUDLogo,
	TextureWidth = 64,

	TextureHeight = 64,

	X = 10,

	Y = ScrH() - 90,

	Height = 70,

	Width = 250,

	OffHeight = 48,

	Background = HUDBackground
}



-- Crosshair

GTowerHUD.Crosshair = {

	Enabled = CreateClientConVar( "gmt_hud_crosshair", 1, true, false ),

	AlwaysOn = CreateClientConVar( "gmt_hud_crosshair_always", 1, true, false ),

	Action = CreateClientConVar( "gmt_hud_crosshair_action", 0, true, false ),

	Material = Material( "gmod_tower/hud/crosshair.png" ),

	Size = 4,

	MaxSize = 16,

}



-- Money

GTowerHUD.Money = {

	LastAmount = 0,

	Amount = 0, -- this is approached

	Font = "GTowerHUDMainLarge",

}



-- Location

GTowerHUD.Location = {

	Font = "GTowerHUDMainSmall",

}



-- Ammo

GTowerHUD.Ammo = {

	Enabled = CreateClientConVar( "gmt_hud_ammo", 1, true, false ),

	Texture = surface.GetTextureID( "gmod_tower/lobby/hud/ammo" ),

	Width = 256,

	Height = 256,

	MainFont =  "GTowerhuge",

	SecondaryFont = "GTowerbigbold",

}



-- Ammo bar

GTowerHUD.AmmoBar = {

	Texture = surface.GetTextureID( "gmod_tower/lobby/hud/ammobar" ),

	Width = 130 - 4,

	Height = 130 - 4,

	CurrentRotation = 0, -- approached in think

	TargetRotation = 0, -- updated in draw

}



GTowerHUD.Notice = {

	Enabled = CreateClientConVar( "gmt_notice", 1, true, false ),

}



-- Location Change Notice

GTowerHUD.LocationChangeNotice = {

	Enabled = CreateClientConVar( "gmt_location_notice", 1, true, false ),

	Alpha = 0,

}

if GTowerHUD.VolumeSlider then GTowerHUD.VolumeSlider:Remove() GTowerHUD.VolumeSlider = nil end
GTowerHUD.VolumeSlider = vgui.Create( "DNumSlider2" )
GTowerHUD.VolumeSlider:SetMinMax( 0, 1 )
GTowerHUD.VolumeSlider:SetDecimals( 3 )
GTowerHUD.VolumeSlider:SetConVar( "mediaplayer_volume" )
GTowerHUD.VolumeSlider:SetSliderColor( Color( 200, 200, 200, 200 ) )
GTowerHUD.VolumeSlider:SetWidth( GTowerHUD.Info.Width - 44 )
GTowerHUD.VolumeSlider:SetPos( GTowerHUD.Info.X + 16 + 4, GTowerHUD.Info.Y - 24 )
GTowerHUD.VolumeSlider:SetVisible( false )

local StaticMat = Material( "room209/static" )

function GTowerHUD.DrawStatic( amount )

  amount = amount / 100 * 255

  surface.SetMaterial( StaticMat )
  surface.SetDrawColor( Color( 255, 255, 255, amount ) )
  surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
end

function GTowerHUD.DrawVolumeIcon()

	local x, y = GTowerHUD.Info.X, GTowerHUD.Info.Y - 32 - 4

	local showVolume = false

	for _, mp in pairs(MediaPlayer.GetAll()) do
		if mp:IsPlaying() then
			showVolume = true
		end
	end

  local weapon = LocalPlayer():GetActiveWeapon()
  if IsValid( weapon ) && weapon:GetClass() == "gmt_camera" then showVolume = false end

	if showVolume then
		surface.SetDrawColor( 125,125, 125, 200 )
		surface.SetMaterial( GTowerHUD.Info.Background )
		surface.DrawTexturedRect( 0, GTowerHUD.VolumeSlider.y - 6, GTowerHUD.Info.Width, GTowerHUD.VolumeSlider:GetTall() + 6 )

		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( GTowerIcoons.GetIcoon("volume16") )
		surface.DrawTexturedRect( x, y+11, 16, 16 )
	end

	GTowerHUD.VolumeSlider:SetVisible(showVolume)

end

// this is required for client notifications
function GetAmmoYPos()

	if IsValid( LocalPlayer():GetActiveWeapon() ) then
		return ScrH() - 200
	end

    return ScrH() - 70

end

function GTowerHUD.DrawCrosshair()

	if LocalPlayer():ShouldDrawLocalPlayer() || !LocalPlayer():Alive() then return end

	local w, h = ScrW() / 2, ScrH() / 2
	local color = Color( 255, 255, 255 )
	local x = 0

  -- Draw Use message
  local ent = GAMEMODE:PlayerUseTrace( LocalPlayer() )
  if IsValid( ent ) and CanPlayerUse( ent ) then
    GTowerHUD.DrawUseMessage( ent, x, w, h )
    return
  end

  local size = GTowerHUD.Crosshair.Size
  surface.SetMaterial( GTowerHUD.Crosshair.Material )
  surface.SetDrawColor( color.r, color.g, color.b, 100 )
  surface.DrawTexturedRect( w - size/2, h - size/2, size, size )

end

// util func to cache unknown max clip values
function GTowerHUD.GetMaxAmmo( wepName, clip )

	// if we haven't cached it, or it's larger
	if !GTowerHUD.MaxAmmo[ wepName ] || clip > GTowerHUD.MaxAmmo[ wepName ] then
		GTowerHUD.MaxAmmo[ wepName ] = clip
		return clip
	end

	return GTowerHUD.MaxAmmo[ wepName ]
end


local mLastAmount = 0
local mAmount = 0
local gradientUp = surface.GetTextureID( "VGUI/gradient_up" )

function GTowerHUD.DrawInfo()



	if !GTowerHUD.Info.Enabled:GetBool() then return end

	if hook.Call( "DisableHUD", GAMEMODE, ply ) then return end



	surface.SetMaterial( GTowerHUD.Info.Background )

	surface.SetDrawColor( 155, 155, 155, 200 )

	surface.DrawTexturedRect( 0, GTowerHUD.Info.Y-2, GTowerHUD.Info.Width, GTowerHUD.Info.TextureHeight+4 )



	surface.SetMaterial( GTowerHUD.Info.Texture )

	surface.SetDrawColor( 255, 255, 255, 255 )

	surface.DrawTexturedRect( GTowerHUD.Info.X, GTowerHUD.Info.Y, GTowerHUD.Info.TextureWidth, GTowerHUD.Info.TextureHeight )



	-- Ease money

	if GTowerHUD.Money.LastAmount != Money() then

		GTowerHUD.Money.LastAmount = Money()

	end



	if GTowerHUD.Money.Amount != Money() then

		local diffMoney = GTowerHUD.Money.Amount - GTowerHUD.Money.LastAmount

		local increaseAmount = math.ceil( math.abs( diffMoney * .1 ) )

		GTowerHUD.Money.Amount = math.Approach( GTowerHUD.Money.Amount, Money(), increaseAmount )

	end



	-- GMC

	local money = string.FormatNumber( GTowerHUD.Money.Amount )

	surface.SetFont( GTowerHUD.Money.Font )

	local tw, th = surface.GetTextSize( money )



	local x = GTowerHUD.Info.X + 75

	local y = GTowerHUD.Info.Y + 22



	draw.SimpleShadowText( money, GTowerHUD.Money.Font, x, y, color_white, color_black, TEXT_ALIGN_LEFT, 1, 1 )

	draw.SimpleShadowText( "GMC", GTowerHUD.Location.Font, x + tw + 4, y + 6, color_white, color_black, TEXT_ALIGN_LEFT, 1, 1 )



	-- Icon

	--[[draw.SimpleShadowText( money, GTowerHUD.Money.Font, x + 32 - 8, y, color_white, color_black, TEXT_ALIGN_LEFT, 1, 1 )



	surface.SetDrawColor( 255, 255, 255 )

	surface.SetMaterial( GTowerIcons.GetIcon("money") )

	surface.DrawTexturedRect( x - 6, y - 15, 32, 32 )]]



	-- Location

	y = y + 24

	local location = string.upper( GTowerLocation:GetName( GTowerLocation:GetPlyLocation( LocalPlayer() ) ) or "Unknown" )
	draw.SimpleShadowText( location, GTowerHUD.Location.Font, x, y, color_white, color_black, TEXT_ALIGN_LEFT, 1, 1 )



	-- Condo

	local locid = LocalPlayer().GRoomId

  if locid && locid != 0 then


		GTowerHUD.DrawExtraInfo( GTowerIcoons.GetIcoon("condo"), "#" .. tostring(locid) )


  end


end



function GTowerHUD.DrawExtraInfo( icon, text, iconSize )



	local x = GTowerHUD.Info.X - 10

	local y = GTowerHUD.Info.Y + GTowerHUD.Info.TextureHeight + 4

	local tall = 20



	iconSize = iconSize or 32



	surface.SetDrawColor( 125,125, 125, 200 )

	surface.SetMaterial( GTowerHUD.Info.Background )

	surface.DrawTexturedRect( 0, y, GTowerHUD.Info.Width, tall )



	surface.SetDrawColor( 255, 255, 255 )

	surface.SetMaterial( icon )

	surface.DrawTexturedRect( x, y + ( ( tall /2 ) - ( iconSize /2 ) ), iconSize, iconSize )



	draw.SimpleShadowText( text, "GTowerHUDMainSmall2", x+iconSize, y+10, color_white, color_black, TEXT_ALIGN_LEFT, 1, 1 )



end


function GTowerHUD.DrawUseMessage( ent, x, w, h )

	if not IsValid( ent ) then return end

	local use, nokey = CanPlayerUse( ent )
	if not use then return end

	if use then

		surface.SetFont( "GTowerHUDMain" )
		local tw, th = surface.GetTextSize(use)
		local offset = -(tw/2)

		if not nokey then

			local usekey = string.upper( input.LookupBinding( 'use' ) or "e" )

			surface.SetFont( "GTowerHUDMainLarge" )
			tw, th = surface.GetTextSize(usekey)
			tw = math.max(tw+8,th)
			offset = tw/2

			surface.SetDrawColor( 0, 0, 0, 200 )
			surface.DrawRect( w + x - tw/2, h - th/2 + 2, tw, th )

			draw.SimpleText( usekey, "GTowerHUDMainLarge", w + x, h - th/2, Color( 255, 255, 255, 255 ), 1 )

		end

		draw.SimpleShadowText( use, "GTowerHUDMain", w + x + 4 + offset, h, Color( 255, 255, 255, 255 ), Color( 0, 0, 0, 230 ), TEXT_ALIGN_LEFT, 1, 1 )

	end

end

RequiredGames = {
	[240] = "Counter-Strike: Source",
	[440] = "Team Fortress 2"
	--[420] = "HL2: Episode Two",
}

// Check for missing games
MissingGames = {}

// Find missing games, if any
for _, item in pairs( engine.GetGames() ) do

	local content = RequiredGames[item.depot]

	if content then

		//local model = RequiredModels[item.depot]

		if !item.mounted || !item.installed /*|| ( model && !util.IsValidModel( model ) )*/ then

			table.insert( MissingGames, content )

		end

	end

end

function GTowerHUD.DrawNotice(title,msg)

	if !GTowerHUD.Notice.Enabled:GetBool() then return end

	-- Handle notice
	local w, h = ScrW() / 2, ScrH() / 2
	h = ( h * 2 ) - 150

	-- Draw gradient boxes
	--draw.GradientBox( w - 512, h, 256, 110, 0, Color( 0, 0, 0, 0 ), Color( 0, 0, 0, 230 ) )
	--draw.GradientBox( w + 256, h, 256, 110, 0, Color( 0, 0, 0, 230 ), Color( 0, 0, 0, 0 ) )
	surface.SetDrawColor( 0, 0, 0, 230 )
	surface.DrawRect( w - 512, h, 1024, 110 )

	-- Draw title
	draw.SimpleText( title or "", "GTowerHudCText", w, h + 20, Color( 255, 255, 255, 255 ), 1, 1 )

	-- Draw text
	draw.DrawText( msg or "", "GTowerHudCSubText", w, h + 50, Color( 255, 255, 255, 255 ), 1 )


end

function GTowerHUD.DrawHealth()

	if GTowerLocation:FindPlacePos(LocalPlayer():GetPos()) != 41 then return end

	local w = GTowerHUD.Info.Width
	local h = 8
	local x = 0 --GTowerHUD.Info.X - 6
	local y = GTowerHUD.Info.Y - h - 6
	local iconSize = 32
	local health = LocalPlayer():Health()
	if health < 0 then health = 0 end
	local maxHealth = LocalPlayer():GetMaxHealth()
	--[[if Dueling && Dueling.IsDueling( LocalPlayer() ) then
		maxHealth = 300
	end--]]
	local percent = ( health / maxHealth )
	local ratio = 1 - ( percent )
	local oppred = 200 - ratio * math.sin( CurTime() * ratio * 3 ) * 55 + ( 1 - ratio ) * 55

	-- Gradient background
	surface.SetDrawColor( 155,155,155, 200 )
	surface.SetMaterial( GTowerHUD.Info.Background )
	surface.DrawTexturedRect( 0, y-10, w, 20 )

	-- Draw heart
	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( GTowerIcoons.GetIcoon("heart") )
	surface.DrawTexturedRect( x, y-16, iconSize, iconSize )

	-- Draw background
	surface.SetDrawColor( 80, 80, 80, 200 )
	surface.DrawRect( x+iconSize, y-4, w, h )

	-- Draw health bar
	surface.SetDrawColor( 255, 255, 255, 255 )
	draw.RectFillBorder( x+iconSize, y-4, w, h, 1, percent, Color( 125, 125, 125, 0 ), Color( 255, oppred, oppred ) )
end

function GTowerHUD.DrawAmmo()

	if !GTowerHUD.Ammo.Enabled:GetBool() then return end

	local weapon = LocalPlayer():GetActiveWeapon()

	if !IsValid( weapon ) then return end

	local name = weapon:GetPrintName()

	local currentMag = weapon:Clip1()
	local currentMax = 100 // default max
	local currentAmmoType = weapon:GetPrimaryAmmoType()
	local currentAmmoLeft = LocalPlayer():GetAmmoCount( currentAmmoType )

	// if we have uses, lets override the clip
	if LocalPlayer().UsesLeft != -1 then
		currentMag = LocalPlayer().UsesLeft
		currentMax = LocalPlayer().MaxUses
		currentAmmoLeft = currentMax
	else
		if weapon.Primary then
			currentMax = weapon.Primary.ClipSize
		else
			currentMax = GTowerHUD.GetMaxAmmo( name, currentMag )
		end
	end

	if !currentMag || currentMag == -1 then return end //there's no ammo
	if currentMag <= 0 && currentAmmoLeft <= 0 then return end  //we're out of ammo - don't display this

	local ammoX = ScrW() - 160
	local ammoY = ScrH() - 160

	local ammoBarX = ammoX + ( 130 / 2 ) + 8
	local ammoBarY = ammoY + ( 130 / 2 ) + 6
	local ammoBarRot = 180 - ( ( currentMag / ( currentMax or 1 ) ) * 180 )

	GTowerHUD.AmmoBar.TargetRotation = ammoBarRot

	surface.SetDrawColor( 255, 255, 255, 255 )

	surface.SetTexture( GTowerHUD.AmmoBar.Texture )
	surface.DrawTexturedRectRotated( ammoBarX, ammoBarY, GTowerHUD.AmmoBar.Width, GTowerHUD.AmmoBar.Height, GTowerHUD.AmmoBar.CurrentRotation )

	surface.SetTexture( GTowerHUD.Ammo.Texture )
	surface.DrawTexturedRect( ammoX, ammoY, GTowerHUD.Ammo.Width, GTowerHUD.Ammo.Height )

	// draw ammo text
	// draw how much current ammo we have
	surface.SetFont( GTowerHUD.Ammo.MainFont )

	local curMagW, curMagH = surface.GetTextSize( currentMag )
	local curMagX, curMagY = ammoBarX - ( curMagW / 2 ), ammoBarY - ( curMagH / 2 )

	surface.SetTextPos( curMagX + 3, curMagY + 3 )
	surface.SetTextColor( 0, 0, 0, 40 )
	surface.DrawText( currentMag )

	surface.SetTextPos( curMagX, curMagY )
	surface.SetTextColor( 255, 255, 255, 255 )
	surface.DrawText( currentMag )

	// draw how much the mag can contain/how much ammo is left
	surface.SetFont( GTowerHUD.Ammo.SecondaryFont )

	local fullMagW, fullMagH = surface.GetTextSize( currentAmmoLeft )
	local fullMagX, fullMagY = ammoX + 91 + ( 62 / 2 ) - ( fullMagW / 2 ), ammoY + 87 + ( 62 / 2 ) - ( fullMagH / 2 )

	surface.SetTextPos( fullMagX + 3, fullMagY + 3 )
	surface.SetTextColor( 0, 0, 0, 40 )
	surface.DrawText( currentAmmoLeft )

	surface.SetTextPos( fullMagX, fullMagY )
	surface.SetTextColor( 255, 255, 255, 255 )
	surface.DrawText( currentAmmoLeft )

end

function GTowerHUD.DrawLocation()

	/*if !GTowerHUD.Location.Enabled:GetBool() then return end

	surface.SetFont("GTowerHUDMainSmall")
	surface.SetDrawColor( 255, 255, 255, 255 )
	w, h = surface.GetTextSize( GTowerLocation:GetName( GTowerLocation:GetPlyLocation( LocalPlayer() ) ) or "Unknown" )
	surface.SetTextPos( 91 +25, ScrH() - 57 )
	surface.DrawText( string.upper( GTowerLocation:GetName( GTowerLocation:GetPlyLocation( LocalPlayer() ) ) or "Unknown" ) )*/

end

local MsgTime = CurTime()
local MsgState = true

function GTowerHUD.Paint()

  if LocalPlayer().GLocation == 60 then
    local dist = LocalPlayer():GetPos():Distance(Vector(2550, 5009, -780))
    GTowerHUD.DrawStatic( math.Clamp(255 - (dist/3),0,200) )
  end

	if !GTowerHUD.Enabled:GetBool() then return end

  // Missing Games!

  if #MissingGames > 0 then

    local gamesmissing = ""
    for id, gamename in pairs( MissingGames ) do
      gamesmissing = gamesmissing .. gamename

      if id != #MissingGames then
        gamesmissing = gamesmissing .. ", "
      end
    end

    message = "It appears that you are missing the required " .. Pluralize( "game", #MissingGames ) .. ": " .. gamesmissing .. "\n" ..
          "Please mount the "  .. Pluralize( "game", #MissingGames ) .. " to remove errors."

  end

  if message then
    GTowerHUD.DrawNotice( "Missing Content", message .. "\nYou can disable this notice in the settings." )
  end

	// disable hud for camera swep
	local weapon = LocalPlayer():GetActiveWeapon()
	if IsValid( weapon ) && weapon:GetClass() == "gmt_camera" then return end
	GTowerHUD.DrawInfo()
	GTowerHUD.DrawLocation()
	GTowerHUD.DrawAmmo()
  GTowerHUD.DrawHealth()
  GTowerHUD.DrawVolumeIcon()
	--GTowerHUD.DrawNotice()

  if LocalPlayer():GetNWBool("MinigameOn") then
    GTowerHUD.MinigameHUD()
  end

  GTowerHUD.DrawCrosshair()

end

local hud_icon_clock = Material( "gmod_tower/balls/hud_icon_clock" )
surface.CreateFont( "BallFont", { font = "Coolvetica", size = 48, weight = 200 } )

function GTowerHUD.MinigameHUD()
  local TimeLeft = (GetGlobalFloat("MinigameRoundTime") - CurTime())
  local TimeString = string.FormattedTime( TimeLeft, "%02i:%02i" )

  draw.DrawText("- MINIGAME -","GTowerSkyMsgSmall",24,0,Color( 255, 255, 255, 255 ),TEXT_ALIGN_LEFT)
  draw.DrawText( TimeString, "VoteTitle", 4 + 80, 60, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )

  draw.DrawText("- SCORE -","GTowerSkyMsgSmall",16,ScrH()/2-52,Color( 255, 255, 255, 255 ),TEXT_ALIGN_LEFT)
  draw.DrawText( LocalPlayer():GetNWInt("MinigameScore"), "VoteTitle", 16, ScrH()/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )

  surface.SetMaterial(GTowerIcoons.GetIcoon("time"))
  surface.SetDrawColor(255,255,255,255)
  surface.DrawTexturedRect(0,52,80,80)

end

function GTowerHUD.Think()

  if !LocalPlayer():Alive() then GtowerMainGui:GtowerHideMenus() end

	/*if !IsValid( LocalPlayer() ) then return end

  // to calculate health bar size approach value
  local health = LocalPlayer():Health()
  local healthValue = health * ( GTowerHUD.Health.MaxSize / 100 )
  local healthSize = math.Clamp( healthValue, 0, GTowerHUD.Health.MaxSize )

  if healthSize != GTowerHUD.Health.Size then

    GTowerHUD.Health.Size = math.Approach(
      GTowerHUD.Health.Size,
      healthSize,
      ( math.abs( GTowerHUD.Health.Size - healthSize ) + 1 ) * 3 * FrameTime()
    )

  end

	if GTowerHUD.AmmoBar.CurrentRotation != GTowerHUD.AmmoBar.TargetRotation then

		GTowerHUD.AmmoBar.CurrentRotation = math.Approach(
			GTowerHUD.AmmoBar.CurrentRotation,
			GTowerHUD.AmmoBar.TargetRotation,
			( math.abs( GTowerHUD.AmmoBar.CurrentRotation - GTowerHUD.AmmoBar.TargetRotation ) + 1 ) * 3 * FrameTime()
		)

	end*/

end


hook.Add( "Think", "GTowerHUDThink", GTowerHUD.Think )
hook.Add( "HUDPaint", "GTowerHUDPaint", GTowerHUD.Paint )

-----------------------------------------------------

if SERVER then return end

local Radar = {}



Radar.AlphaScale = 0.6



Radar.PlayerColor = Color( 240, 240, 240, 255 )

Radar.FriendlyColor = Color( 255, 20, 20, 255 )

Radar.NPCColor = Color( 255, 200, 20, 255 )



Radar.Radius = 1250



//local RadarVirus = surface.GetTextureID( "gmod_tower/virus/hud_infected_radar" )

local RadarHuman = surface.GetTextureID( "gmod_tower/virus/hud_survivor_radar" )





local ColorAScale = function( col, scale )

	return Color( col.r, col.g, col.b, col.a * math.pow( 1 - scale, 2 ) )

end



function DrawRadar()


	--if hook.Call( "DisableRadar", GAMEMODE, LocalPlayer() ) then return end

	--if LocalPlayer():GetSetting(29 --[["GTAllowVirusHUD"]]) != true then return end

	if !LocalPlayer():GetNWBool("VirusRadar") then return end

	Radar.w = 256

	Radar.h = 128

	Radar.x = ScrW() - Radar.w - 32

	Radar.y = 32



	surface.SetTexture( RadarHuman )

	surface.SetDrawColor( 255, 255, 255, 255 )

	surface.DrawTexturedRect( Radar.x, Radar.y, 256, 128 )



	for _, ply in pairs( player.GetAll() ) do

		DrawBlip( ply, Radar.PlayerColor )

	end



	for _, npc in pairs( ents.FindByClass( "gmt_npc_*" ) ) do

		DrawBlip( npc, Radar.NPCColor )

	end



	/*for _, npc in pairs( ents.GetAll() ) do

		DrawBlip( npc, Radar.EnemyColor )

	end*/



end



function DrawBlip( ent, color )



	if !IsValid( ent ) || LocalPlayer() == ent then return end



	local vdiff = ent:GetPos() - LocalPlayer():GetPos()

	if vdiff:Length() > Radar.Radius then return end



	local cx = Radar.x + Radar.w / 2

	local cy = Radar.y + Radar.h / 2



	local px = ( vdiff.x / Radar.Radius )

	local py = ( vdiff.y / Radar.Radius )



	local z = math.sqrt( px * px + py * py )

	local phi = math.rad( math.deg( math.atan2( px, py ) ) - math.deg( math.atan2( LocalPlayer():GetAimVector().x, LocalPlayer():GetAimVector().y ) ) - 90 )

	px = math.cos( phi ) * z

	py = math.sin( phi ) * z



	draw.RoundedBox( 4, ( cx + px * Radar.w / 2 - 4 ), cy + py * Radar.h / 2 - 4, 8, 8, ColorAScale( color, z ) )

	//draw.RoundedBox( 4, ( cx + px * Radar.w / 2 - 4 ), cy + py * Radar.h / 2 - 4, 8, 8, ColorAScale( color, 1 - z ) )



end



hook.Add( "HUDPaint", "VirDrawRadar", DrawRadar )
