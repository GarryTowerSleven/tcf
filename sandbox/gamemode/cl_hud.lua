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

// the blue info background
GTowerHUD.Info = {
	Enabled = CreateClientConVar( "gmt_hud_info", 1, true, false ),
	Texture = surface.GetTextureID("gmod_tower/lobby/hud/mainhud"),
	--Texture = surface.GetTextureID("gmod_tower/lobby/hud/mainhud_halloween"),
	--Texture = surface.GetTextureID("gmod_tower/lobby/hud/mainhud_christmas"),
	Width = 256,
	Height = 128,
}

// health texture
GTowerHUD.Health = {
	Texture = surface.GetTextureID( "gmod_tower/lobby/hud/bar" ),
	Size = 0, // this is changed in the think, because it's approached
	MaxSize = 212,
	Height = 15,
	Font = "Gtowermidbold",
}

// money stuff
GTowerHUD.Money = {
	Font = "Gtowerboldbig",
}

GTowerHUD.Location = {
	Enabled = CreateClientConVar( "gmt_hud_location", 1, true, false ),
	Font = "Gtowerbiglocation",
}

// ammo
GTowerHUD.Ammo = {
	Enabled = CreateClientConVar( "gmt_hud_ammo", 1, true, false ),
	Texture = surface.GetTextureID( "gmod_tower/lobby/hud/ammo" ),
	Width = 256,
	Height = 256,
	MainFont =  "Gtowerhuge",
	SecondaryFont = "Gtowerbigbold",
}

// ammo bar
GTowerHUD.AmmoBar = {
	Texture = surface.GetTextureID("gmod_tower/lobby/hud/ammobar"),
	Width = 130 - 4,
	Height = 130 - 4,
	CurrentRotation = 0, // approached in think
	TargetRotation = 0, // updated in draw
}

-- Crosshair
GTowerHUD.Crosshair = {
	Enabled = CreateClientConVar( "gmt_hud_crosshair", 1, true, false ),
	AlwaysOn = CreateClientConVar( "gmt_hud_crosshair_always", 0, true, false ),
	Action = CreateClientConVar( "gmt_hud_crosshair_action", 0, true, false ),
	Material = Material( "gmod_tower/hud/crosshair.png" ),
	Size = 4,
	MaxSize = 16,
}

GTowerHUD.UseEnts = {
  "gmt_presentbag",
  "gmt_multiserver",
  "func_suitepanel",
  "func_door",
  "func_door_rotating",
  "gmt_entuse",
  "gmt_auctiontable",
  "gmt_casino_videopoker", "gmt_slotmachine", "gmt_casino_spinner",
  "gmt_item_",
  "gmt_money_button",
  "gmt_pet",
  "gmt_raveball", "gmt_disco",
  "gmt_vending_machine",
  "gmt_rc_boat",
  "gmt_statueofbreen",
  "gmt_toyslots",
  "firework_",
  "gmt_arcade",
  "gmt_beer",
  "gmt_christmas_present",
  "gmt_comfybed", "gmt_simsbed", "gmt_suitebed",
  "gmt_cow",
  "gmt_tetris",
  "gmt_tictactoe",
  "gmt_trunk",
  "mysterycatsack",
  "gmt_instrument_", "gmt_piano",
  "gmt_room_lamp", "gmt_lantern", "gmt_lightsaber",
  "gmt_magicscroll", "gmt_modelrocket", "gmt_modernlamp", "gmt_nesguitar", "gmt_painkiller", "gmt_pooltube", "gmt_radio", "gmt_room_remote", "gmt_spigot", "gmt_room_tv", "gmt_room_tv_large"
}

local useable = {}

for k,v in pairs(GTowerHUD.UseEnts) do
  useable[v] = true
end

// this is required for client notifications
function GetAmmoYPos()

	if IsValid( LocalPlayer():GetActiveWeapon() ) then
		return ScrH() - 200
	end

    return ScrH() - 70

end

function PlayerUseTrace( ply, filter )

	if !filter then
		filter = ply
	end

	local pos = ply:EyePos()
	local trace = util.TraceLine({
		["start"] = pos,
		["endpos"] = pos + ( ply:GetAimVector() * 96 ),
		["filter"] = filter
	})

	return trace.Entity

end

function CanPlayerUse(ent)

  if string.match(ent,"firework_*") then return true end
  if string.match(ent,"gmt_item_*") then return true end
  if string.match(ent,"gmt_npc_*") then return true end

  if useable[ent] then
    return true
  end

  return false
end

function GTowerHUD.DrawCrosshair()

	if LocalPlayer():ShouldDrawLocalPlayer() || !LocalPlayer():Alive() then return end

	local w, h = ScrW() / 2, ScrH() / 2
	local color = Color( 255, 255, 255 )
	local x = 0

	if GTowerHUD.Crosshair.AlwaysOn:GetBool() then
    local size = GTowerHUD.Crosshair.Size
    surface.SetMaterial( GTowerHUD.Crosshair.Material )
    surface.SetDrawColor( color.r, color.g, color.b, 100 )
    surface.DrawTexturedRect( w - size/2, h - size/2, size, size )
    return
  end

	-- Draw Use message
	local ent = PlayerUseTrace( LocalPlayer() )

	-- Draw crosshair
	if IsValid( ent ) and CanPlayerUse( ent:GetClass() ) then

		local size = GTowerHUD.Crosshair.Size
		surface.SetMaterial( GTowerHUD.Crosshair.Material )
		surface.SetDrawColor( color.r, color.g, color.b, 100 )
		surface.DrawTexturedRect( w - size/2, h - size/2, size, size )

		--[[if GTowerHUD.Crosshair.Action:GetBool() then
			GTowerHUD.DrawActionCrosshair()
		end]]

	end

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

function GTowerHUD.DrawInfo()

	if !GTowerHUD.Info.Enabled:GetBool() then return end

  local health = LocalPlayer():Health()



	// draw info bg
	local infoX = 25
	local infoY = ScrH() - 150

  // draw health bar
  local healthX = 69
  local healthY = infoY + 35 // the bar is 81 units below the top of the bg
  local ratio = 1 - ( GTowerHUD.Health.Size / GTowerHUD.Health.MaxSize )
  local oppred = 200 - ratio * math.sin( CurTime() * ratio * 3 ) * 55 + ( 1 - ratio ) * 55

  if GTowerLocation:FindPlacePos(LocalPlayer():GetPos()) == 51 then
  surface.SetTexture( GTowerHUD.Health.Texture )
  surface.SetDrawColor( 255, oppred, oppred, 255 )
  surface.DrawTexturedRect( healthX, healthY, GTowerHUD.Health.Size, GTowerHUD.Health.Height )



  // draw health text
  surface.SetFont( GTowerHUD.Health.Font )

  local HealthSub = 255 - ( 1 - ( health / 100 ) ) * 100
  local hTextW, hTextH = surface.GetTextSize( health )
  local hTextX = healthX + ( GTowerHUD.Health.MaxSize / 2 ) - ( hTextW / 2 )
  local hTextY = healthY + ( GTowerHUD.Health.Height / 2 ) - ( hTextH / 2 )

  surface.SetTextColor( 255, HealthSub, HealthSub, 255 )
  surface.SetTextPos( hTextX, hTextY )
  surface.DrawText( health )
  end

	surface.SetTexture( GTowerHUD.Info.Texture )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( infoX, infoY, GTowerHUD.Info.Width, GTowerHUD.Info.Height )

	// draw money text
	surface.SetTextColor(255, 255, 255, 255)
		if mLastAmount != Money() then
		mLastAmount = Money()
	end

	if mAmount != Money() then

		local diffMoney = mAmount - mLastAmount
		local increaseAmount = math.ceil( math.abs( diffMoney * .1 ) )

		mAmount = math.Approach( mAmount, Money(), increaseAmount )

	end

	local money = string.FormatNumber( mAmount )

	surface.SetFont("GTowerHUDMainLarge")
		local mTextW, mTextH = surface.GetTextSize( money )
		local mTextX = 25 + 110

		local mTextY = ScrH() - 150 + 75 - ( mTextH / 2 )


		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos( mTextX, mTextY )
	surface.DrawText( money )


end

function GTowerHUD.DrawNotice()

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
	draw.SimpleText( GTowerHUD.Notice.Title, "GTowerHudCText", w, h + 20, Color( 255, 255, 255, 255 ), 1, 1 )

	-- Draw text
	draw.DrawText( GTowerHUD.Notice.Text or "", "GTowerHudCSubText", w, h + 50, Color( 255, 255, 255, 255 ), 1 )


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

	if !GTowerHUD.Location.Enabled:GetBool() then return end

	surface.SetFont("GTowerHUDMainSmall")
	surface.SetDrawColor( 255, 255, 255, 255 )
	w, h = surface.GetTextSize( GTowerLocation:GetName( GTowerLocation:GetPlyLocation( LocalPlayer() ) ) or "Unknown" )
	surface.SetTextPos( 91 +25, ScrH() - 57 )
	surface.DrawText( string.upper( GTowerLocation:GetName( GTowerLocation:GetPlyLocation( LocalPlayer() ) ) or "Unknown" ) )

end

local MsgTime = CurTime()
local MsgState = true

function GTowerHUD.Paint()

	if !GTowerHUD.Enabled:GetBool() then return end

	// disable hud for camera swep
	local weapon = LocalPlayer():GetActiveWeapon()
	if IsValid( weapon ) && weapon.Classname == "gmt_camera" then return end

	GTowerHUD.DrawInfo()
	GTowerHUD.DrawLocation()
	GTowerHUD.DrawAmmo()
	--GTowerHUD.DrawNotice()

  if !( HideBetaMessage:GetBool() ) then
    if CurTime() > MsgTime then
      MsgTime = CurTime() + 10
      MsgState = !MsgState
    end

    draw.SimpleShadowText( "GMod Tower: Classic is currently in beta, expect lots of bugs.", "GTowerHudCSubText", ScrW()/2, ScrH() - 50, Color( 255, 255, 255, 255 ), Color( 0, 0, 0, 230 ), 1, 1, 1 )

    if MsgState then
      draw.SimpleShadowText( "Known bugs: TVs don't work, Trivia is broken, pool tubes don't work.", "GTowerHudCSubText", ScrW()/2, ScrH() - 25, Color( 255, 255, 255, 255 ), Color( 0, 0, 0, 230 ), 1, 1, 1 )
    else
      draw.SimpleShadowText( "You can disable this message in the settings.", "GTowerHudCSubText", ScrW()/2, ScrH() - 25, Color( 255, 255, 255, 255 ), Color( 0, 0, 0, 230 ), 1, 1, 1 )
    end

  end

  GTowerHUD.DrawCrosshair()

end



function GTowerHUD.Think()

	if !IsValid( LocalPlayer() ) then return end

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

	end

end


hook.Add( "Think", "GTowerHUDThink", GTowerHUD.Think )
hook.Add( "HUDPaint", "GTowerHUDPaint", GTowerHUD.Paint )
