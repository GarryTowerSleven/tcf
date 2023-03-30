GTowerHUD = {}

-- draw the hud?
GTowerHUD.Enabled = CreateClientConVar( "gmt_hud", 1, true, false )
local HideBetaMessage = CreateClientConVar( "gmt_admin_hidebetamsg", 0, true, false )

-- because native weapons don't have a way of giving us a max clip count
-- we need to cache the highest values we see
GTowerHUD.MaxAmmo = {}

-- Main HUD
GTowerHUD.Info = {
	Enabled = CreateClientConVar( "gmt_hud_info", 1, true, false ),
	Texture = GTowerIcons2.GetIcon("gmt"),
	TextureWidth = 64,
	TextureHeight = 64,
	X = 10,
	Y = ScrH() - 90,
	Height = 70,
	Width = 250,
	OffHeight = 48,
	Background = Material( "gmod_tower/hud/bg_gradient.png", "unlightsmooth" )
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


--[[GTowerHUD.Notice = {
	Enabled = CreateClientConVar( "gmt_notice", 1, true, false ),
	Title = "GMod 13 Notice!",
	Text = "Expect lots of bugs, Lua errors, and things just generally not working.\n "..
			"TVs, some Arcades, and Radios do not work. Please check our website for updates.\n "..
			"You can disable this notice in the settings.",
	--Text = "CHANGING LEVEL, REJOIN IF IT BREAKS!!",
}

GTowerHUD.Notice = {
	Enabled = CreateClientConVar( "gmt_gmnotice", 1, true, false ),
	Title = "No Gamemodes Notice!",
	Text = "This is server is lobby only. There are no gamemodes on this server.\n "..
			"Join server #1 for gamemodes - IP: join.gmtower.org\n"..
			"You can disable this notice in the settings.",
	--Text = "CHANGING LEVEL, REJOIN IF IT BREAKS!!",
}]]

--[[GTowerHUD.News = {
	Enabled = CreateClientConVar( "gmt_newsticker", 1, true, false ),
	FeedURL = "http://www.gmtower.org/ticker.txt",
	Current = "No news."
}]]

--[[GTowerHUD.BallRace = {
	Texture = surface.GetTextureID( "gmod_tower/balls/hud_icon_antlion" ),
	LastSpeed = 0,
	Speed = 0,
	Rotation = 0,
}]]

-- Health
--[[GTowerHUD.Health = {
	Texture = surface.GetTextureID( "gmod_tower/lobby/hud/bar" ),
	Size = 0, -- this is changed in the think, because it's approached
	Height = 12,
	Font = "GTowerHUDMainSmall",
	MaxSize = GTowerHUD.Info.Width - 50,
	EnabledY = GTowerHUD.Info.Y + GTowerHUD.Info.Height - 8 - (12*2),
	DisabledY = GTowerHUD.Info.Y + GTowerHUD.Info.Height + 6,
	CurY = GTowerHUD.Info.Y + GTowerHUD.Info.Height + 6, -- approached in think
}]]

-- util func to cache unknown max clip values
function GTowerHUD.GetMaxAmmo( wepName, clip )
	
	-- if we haven't cached it, or it's larger
	if !GTowerHUD.MaxAmmo[ wepName ] || clip > GTowerHUD.MaxAmmo[ wepName ] then
		GTowerHUD.MaxAmmo[ wepName ] = clip
		return clip
	end
	
	return GTowerHUD.MaxAmmo[ wepName ]
end

local gradientUp = surface.GetTextureID( "VGUI/gradient_up" )
function GTowerHUD.DrawInfo()

	if !GTowerHUD.Info.Enabled:GetBool() then return end
	if hook.Call( "DisableHUD", GAMEMODE, ply ) then return end

	surface.SetMaterial( GTowerHUD.Info.Background )
	surface.SetDrawColor( 0, 0, 0, 200 )
	surface.DrawTexturedRect( 0, GTowerHUD.Info.Y-2, GTowerHUD.Info.Width, GTowerHUD.Info.TextureHeight+4 )

	surface.SetMaterial( GTowerHUD.Info.Texture )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( GTowerHUD.Info.X, GTowerHUD.Info.Y, GTowerHUD.Info.TextureWidth, GTowerHUD.Info.TextureHeight )
	
	-- Ease money
    local function Money()
        return LocalPlayer():getDarkRPVar("money")
    end
	if GTowerHUD.Money.LastAmount != Money() then
		GTowerHUD.Money.LastAmount = Money()
	end

	if GTowerHUD.Money.Amount != Money() then
		local diffMoney = GTowerHUD.Money.Amount - GTowerHUD.Money.LastAmount
		local increaseAmount = math.ceil( math.abs( diffMoney * .1 ) )
		GTowerHUD.Money.Amount = math.Approach( GTowerHUD.Money.Amount, Money(), increaseAmount )
	end

	-- GMC
	local money = string.Comma( GTowerHUD.Money.Amount )
	surface.SetFont( GTowerHUD.Money.Font )
	local tw, th = surface.GetTextSize( money )

	local x = GTowerHUD.Info.X + 75
	local y = GTowerHUD.Info.Y + 22

	draw.SimpleShadowText( money, GTowerHUD.Money.Font, x, y, color_white, color_black, TEXT_ALIGN_LEFT, 1, 1 )
	draw.SimpleShadowText( "GMC", GTowerHUD.Location.Font, x + tw + 4, y + 6, color_white, color_black, TEXT_ALIGN_LEFT, 1, 1 )

	-- Icon
	--[[draw.SimpleShadowText( money, GTowerHUD.Money.Font, x + 32 - 8, y, color_white, color_black, TEXT_ALIGN_LEFT, 1, 1 )
	
	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( GTowerIcons2.GetIcon("money") )
	surface.DrawTexturedRect( x - 6, y - 15, 32, 32 )]]

	-- Location
	y = y + 24
	local location = string.upper(LocalPlayer():getDarkRPVar("job")) or "SOMEWHERE" // string.upper( LocalPlayer():LocationName() )
	draw.SimpleShadowText( location, GTowerHUD.Location.Font, x, y, color_white, color_black, TEXT_ALIGN_LEFT, 1, 1 )

	-- Condo
	local roomid = LocalPlayer():GetNWInt("RoomID")

	if roomid and roomid > 0 then
		GTowerHUD.DrawExtraInfo( GTowerIcons2.GetIcon("condo"), "#" .. tostring(roomid) )
	end

end

function GTowerHUD.DrawExtraInfo( icon, text, iconSize )

	local x = GTowerHUD.Info.X - 10
	local y = GTowerHUD.Info.Y + GTowerHUD.Info.TextureHeight + 4
	local tall = 20

	iconSize = iconSize or 32

	surface.SetDrawColor( 0,0,0, 200 )
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

function GTowerHUD.DrawCrosshair()

	if LocalPlayer():ShouldDrawLocalPlayer() || !LocalPlayer():Alive() then return end

	local w, h = ScrW() / 2, ScrH() / 2
	local color = Color( 255, 255, 255 )
	local x = 0


		local size = GTowerHUD.Crosshair.Size
		surface.SetMaterial( GTowerHUD.Crosshair.Material )
		surface.SetDrawColor( color.r, color.g, color.b, 100 )
		surface.DrawTexturedRect( w - size/2, h - size/2, size, size )

		--[[if GTowerHUD.Crosshair.Action:GetBool() then
			GTowerHUD.DrawActionCrosshair()
		end]]


end

local curSpread = 5
local curAlpha = 180
function GTowerHUD.DrawActionCrosshair()

	local x = ScrW() / 2
	local y = ScrH() / 2
	local spread = 5
	local alpha = 180

	if LocalPlayer():KeyDown( IN_ATTACK ) then
		spread = 15
		alpha = 255
	end

	curSpread = math.Approach( curSpread, spread, FrameTime() * 60 )
	curAlpha = math.Approach( curAlpha, alpha, FrameTime() * 180 )

	local thickness = 4
	local width = 3
	local height = 3
	local halfWidth = width / 2
	local halfHeight = height / 2


	-- Black
	surface.SetDrawColor( 0, 0, 0, curAlpha * .85 )

	surface.DrawRect( x - halfWidth, y - halfHeight, width, height )

	-- Sides
	surface.DrawRect( x - curSpread - thickness - 1, y - halfHeight - 1.5, thickness + 2, height + 2 )
	surface.DrawRect( x + curSpread - 2, y - halfHeight - 1.5, thickness + 2, height + 2 )

	-- Top
	surface.DrawRect( x - halfWidth - 1.5, y - curSpread - thickness - 1, width + 2, thickness + 2 )
	surface.DrawRect( x - halfWidth - 1.5, y + curSpread - 2, width + 2, thickness + 2 )


	-- White
	surface.SetDrawColor( 255, 255, 255, curAlpha )

	-- Sides
	surface.DrawRect( x - curSpread - thickness, y - halfHeight, thickness, height )
	surface.DrawRect( x + curSpread - 1, y - halfHeight, thickness, height )

	-- Top
	surface.DrawRect( x - halfWidth, y - curSpread - thickness, width, thickness )
	surface.DrawRect( x - halfWidth, y + curSpread - 1, width, thickness )

end

function GTowerHUD.DrawHealth()

	// if !Location.Is( LocalPlayer():Location(), "duelarena" ) then return end

	local w = GTowerHUD.Info.Width
	local h = 8
	local x = 0 --GTowerHUD.Info.X - 6
	local y = GTowerHUD.Info.Y - h - 6
	local iconSize = 32
	local health = LocalPlayer():Health()
	if health < 0 then health = 0 end
	local maxHealth = 100
	if Dueling && Dueling.IsDueling( LocalPlayer() ) then
		maxHealth = 300
	end
	local percent = ( health / maxHealth )
	local ratio = 1 - ( percent )
	local oppred = 200 - ratio * math.sin( CurTime() * ratio * 3 ) * 55 + ( 1 - ratio ) * 55

	-- Gradient background
	surface.SetDrawColor( 0,0,0, 200 )
	surface.SetMaterial( GTowerHUD.Info.Background )
	surface.DrawTexturedRect( 0, y-10, w, 20 )

	-- Draw heart
	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( GTowerIcons2.GetIcon("heart") )
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
	local currentMax = 100 -- default max
	local currentAmmoType = weapon:GetPrimaryAmmoType()
	local currentAmmoLeft = LocalPlayer():GetAmmoCount( currentAmmoType )
	
	if !currentMag then return end --there's no ammo
	if currentMag <= 0 && currentAmmoLeft <= 0 then return end  --we're out of ammo - don't display this
	
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
	
	if currentMag != -1 then
		-- draw ammo text
		-- draw how much current ammo we have
		surface.SetFont( GTowerHUD.Ammo.MainFont )

		local curMagW, curMagH = surface.GetTextSize( currentMag )
		local curMagX, curMagY = ammoBarX - ( curMagW / 2 ), ammoBarY - ( curMagH / 2 )

		surface.SetTextPos( curMagX + 3, curMagY + 3 )
		surface.SetTextColor( 0, 0, 0, 40 )
		surface.DrawText( currentMag )

		surface.SetTextPos( curMagX, curMagY )
		surface.SetTextColor( 255, 255, 255, 255 )
		surface.DrawText( currentMag )
	end

	-- draw how much the mag can contain/how much ammo is left
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

function GTowerHUD.DrawNotice( title, message )

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
	draw.SimpleText( title, "GTowerHudCText", w, h + 20, Color( 255, 255, 255, 255 ), 1, 1 )

	-- Draw text
	draw.DrawText( message or "", "GTowerHudCSubText", w, h + 40, Color( 255, 255, 255, 255 ), 1 )

end

function GTowerHUD.DrawLocationChange( title, message )

	if !GTowerHUD.LocationChangeNotice.Enabled:GetBool() then return end
	if GTowerHUD.LocationChangeNotice.Alpha == 0 then return end

	local alpha = GTowerHUD.LocationChangeNotice.Alpha
	GTowerHUD.LocationChangeNotice.Alpha = math.Approach( alpha, 1, .002 )

	-- Handle notice
	local w, h = ScrW() / 2, ScrH() - 150

	-- Draw gradient boxes
	draw.GradientBox( w - 512, h, 256, 110, 0, Color( 0, 0, 0, 0 ), Color( 0, 0, 0, alpha*230 ) )
	draw.GradientBox( w + 256, h, 256, 110, 0, Color( 0, 0, 0, alpha*230 ), Color( 0, 0, 0, 0 ) )
	
	surface.SetDrawColor( 0, 0, 0, 230 )
	surface.DrawRect( w - 512, h, 1024, 110 )


	draw.DrawText( "YOU ARE NOW IN", "GTowerHudCSubText", w, h + 10, Color( 200, 200, 200, alpha*255 ), 1 )

	-- Draw title
	draw.SimpleText( title, "GTowerHudCText", w, h + 20, Color( 255, 255, 255, alpha*255 ), 1, 1 )

	-- Draw text
	draw.DrawText( message or "", "GTowerHudCSubText", w, h + 30, Color( 255, 255, 255, alpha*255 ), 1 )

end

--[[function GTowerHUD.DrawBallRace()

	GTowerHUD.BallRace.LastSpeed = GTowerHUD.BallRace.Speed or 0 
	GTowerHUD.BallRace.Speed = LocalPlayer()._BallRaceSpeed or 0

	local changeSpeed = math.floor( ( GTowerHUD.BallRace.LastSpeed - GTowerHUD.BallRace.Speed ) )

	if changeSpeed < -9 then
		changeSpeed = changeSpeed * .009 -- yay magic numbers!! this is to lower the speed for rotation
		GTowerHUD.BallRace.Rotation = GTowerHUD.BallRace.Rotation + changeSpeed
	end

	LocalPlayer():ChatPrint( tostring( GTowerHUD.BallRace.Rotation ) )

	surface.SetTexture( GTowerHUD.BallRace.Texture )
	surface.SetTextColor( 255, 255, 255, 255 )
	surface.DrawTexturedRectRotated( GTowerHUD.Info.X + GTowerHUD.Info.Width + 32, GTowerHUD.Info.Y + ( GTowerHUD.Info.Width / 2 ), 64, 64, GTowerHUD.BallRace.Rotation )

end]]

--[[function GTowerHUD.DrawNotice()

	if !GTowerHUD.Notice.Enabled:GetBool() then return end

	-- Handle notice
	local w, h = ScrW() / 2, ScrH() / 2
	h = ( h * 2 ) - 150

	-- Draw gradient boxes
	draw.GradientBox( w - 512, h, 256, 110, 0, Color( 0, 0, 0, 0 ), Color( 0, 0, 0, 230 ) )
	draw.GradientBox( w + 256, h, 256, 110, 0, Color( 0, 0, 0, 230 ), Color( 0, 0, 0, 0 ) )
	surface.SetDrawColor( 0, 0, 0, 230 )
	surface.DrawRect( w - 255, h, 512, 110 )

	-- Draw title
	draw.SimpleText( GTowerHUD.Notice.Title, "GTowerHudCText", w, h + 20, Color( 255, 255, 255, 255 ), 1, 1 )

	-- Draw text
	draw.DrawText( GTowerHUD.Notice.Text or "", "GTowerHudCSubText", w, h + 50, Color( 255, 255, 255, 255 ), 1 )


end

function GTowerHUD.DrawNoGamemodeNotice()

	if GetConVarNumber("port") == "27015" then return end
	if !GTowerHUD.GMNotice.Enabled:GetBool() then return end

	-- Handle notice
	local w, h = ScrW() / 2, ScrH() / 2
	h = ( h * 2 ) - 150

	-- Draw gradient boxes
	draw.GradientBox( w - 512, h, 256, 110, 0, Color( 0, 0, 0, 0 ), Color( 0, 0, 0, 230 ) )
	draw.GradientBox( w + 256, h, 256, 110, 0, Color( 0, 0, 0, 230 ), Color( 0, 0, 0, 0 ) )
	surface.SetDrawColor( 0, 0, 0, 230 )
	surface.DrawRect( w - 255, h, 512, 110 )

	-- Draw title
	draw.SimpleText( GTowerHUD.GMNotice.Title, "GTowerHudCText", w, h + 20, Color( 255, 255, 255, 255 ), 1, 1 )

	-- Draw text
	draw.DrawText( GTowerHUD.GMNotice.Text or "", "GTowerHudCSubText", w, h + 50, Color( 255, 255, 255, 255 ), 1 )

end]]

--[[function GTowerHUD.DrawNews()

	if !GTowerHUD.News.Enabled:GetBool() then return end

	surface.SetDrawColor( 0, 0, 0, 230 )
	surface.DrawRect( 0, ScrH() - 20, ScrW(), 20 )

	draw.SimpleText( "Latest News", "GTowerHudCSubText", 50 + 2, ScrH() - 25 + 2, Color( 0, 0, 0, 255 ), 1, 1 )
	draw.SimpleText( "Latest News", "GTowerHudCSubText", 50, ScrH() - 25, Color( 255, 255, 255, 255 ), 1, 1 )


	local news = GTowerHUD.News.Current or "No news."

	surface.SetFont( "GTowerHudCNewsText" )
	surface.SetTextColor( 255, 255, 255, 255 )

	local w, h = surface.GetTextSize( news )
	local xpos = 4

	-- Marquee scroll text
	if w > ScrW() then

		if !LocalPlayer()._MarqueeDelay then
			LocalPlayer()._MarqueeDelay = CurTime() + math.random( 2, 3 )
		end

		if LocalPlayer()._MarqueeDelay < CurTime() then

			if LocalPlayer()._MarqueeDir == 1 then -- Right

				local pos = ScrW() - w - 2

				if xpos != pos then
					xpos = math.Approach( xpos, pos, FrameTime() * 10 )
				else
					LocalPlayer()._MarqueeDir = 0
					LocalPlayer()._MarqueeDelay = CurTime() + math.random( 2, 3 )
				end

			else -- Left

				local pos = 4

				if xpos != pos then
					xpos = math.Approach( xpos, pos, FrameTime() * 10 )
				else
					LocalPlayer()._MarqueeDir = 1
					LocalPlayer()._MarqueeDelay = CurTime() + math.random( 2, 3 )
				end

			end

		end

	end

	surface.SetTextPos( xpos, ScrH() - 19 )
	surface.DrawText( news )

end

function GTowerHUD.NewsThink()

	if !GTowerHUD.News.Enabled:GetBool() then return end

	if !LocalPlayer()._LastTickerUpdate || LocalPlayer()._LastTickerUpdate < CurTime() then

		http.Fetch( GTowerHUD.News.FeedURL,
			function( content )
				GTowerHUD.News.Current = content
			end,
			function() ErrorNoHalt( "Failed to get news feed." ) end
		)

		LocalPlayer()._LastTickerUpdate = CurTime() + ( 60 * 5 )

	end

end]]

--local gradientUp = surface.GetTextureID( "VGUI/gradient_up" )
--local award = surface.GetTextureID( "gmod_tower/ui/award" )

function GTowerHUD.ShouldDraw()

	if !IsValid( LocalPlayer() ) then return false end

	if not hook.Run( "GTowerHUDShouldDraw" ) then return false end

	if !GTowerHUD.Enabled:GetBool() then return false end

	local weapon = LocalPlayer():GetActiveWeapon()
	if IsValid( weapon ) && weapon:GetClass() == "gmt_camera" then return false end

	return true

end

function GTowerHUD.Paint()

	if GTowerHUD.ShouldDraw() then

		//jetpack.JetpackFuelDraw( GTowerHUD.Info.X, GTowerHUD.Info.Y, GTowerHUD.Info.Width, GTowerHUD.Info.Height-4 )

		GTowerHUD.DrawHealth()
		GTowerHUD.DrawInfo()
		// GTowerHUD.DrawVolumeIcon()
	    hook.Call( "GTowerHUDPaint", GAMEMODE )

		GTowerHUD.DrawAmmo()
		--GTowerHUD.DrawNotice()
		--GTowerHUD.DrawNews()
		GTowerHUD.DrawCrosshair()

	end

	--[[if !( HideBetaMessage:GetBool() and LocalPlayer():IsAdmin()  ) then
		draw.SimpleShadowText( "This game is still a work in progress, this beta may not represent the final quality of the product.", "GTowerHudCSubText", ScrW()/2, ScrH() - 50, Color( 255, 255, 255, 255 ), Color( 0, 0, 0, 230 ), 1, 1, 1 )
		draw.SimpleShadowText( "Follow us at http://www.gmtower.org/", "GTowerHudCSubText", ScrW()/2, ScrH() - 25, Color( 255, 255, 255, 255 ), Color( 0, 0, 0, 230 ), 1, 1, 1 )
	end]]

	--[[local time = RealTime() * 150

	surface.SetTexture( award )
	surface.SetDrawColor( 255, 255, 255, 255 )

	local size = 512+32
	surface.DrawTexturedRectRotated( ScrW()/2, ScrH()/2, size, size, time+35 )

	local size = 512
	surface.DrawTexturedRectRotated( ScrW()/2, ScrH()/2, size, size, time )]]

	--[[local notice = "Your microphone levels are low. People may not be able to hear you."
	surface.SetFont( "GTowerHudCNoticeText" )
	local tw, th = surface.GetTextSize( notice ) + 16, 28

	local w, h = ScrW() / 2, ScrH() - 64
	local x, y = w - (tw/2), h

	local col = colorutil.Rainbow(50)
	surface.SetDrawColor( col.r, col.g, col.b, 230 )
	surface.DrawRect( x, y, tw, th )

	surface.SetDrawColor( 40, 40, 40, 250 )
	surface.DrawRect( x+1, y+1, tw-2, th-2 )

	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.SetTexture( gradientUp )
	surface.DrawTexturedRect( x+1, y+1, tw-2, th-2 )

	-- Draw title
	draw.SimpleText( notice, "GTowerHudCNoticeText", w, h+(th/2), Color( 255, 255, 255, 255 ), 1, 1 )]]

	--[[local y = h + 31
	local p = 2
	for i=1, 50 do
		surface.SetDrawColor( i/p, i/p, i/p, math.Fit( i, 1, 50, 200, 0 ) )
		surface.DrawRect( x+i, y + ( i / p ), 512-(i*2), 1 )
	end]]

end

function GTowerHUD.Think()

	if !IsValid( LocalPlayer() ) then return end

	-- Ammo
	if GTowerHUD.AmmoBar.CurrentRotation != GTowerHUD.AmmoBar.TargetRotation then
	
		GTowerHUD.AmmoBar.CurrentRotation = math.Approach(
			GTowerHUD.AmmoBar.CurrentRotation,
			GTowerHUD.AmmoBar.TargetRotation,
			( math.abs( GTowerHUD.AmmoBar.CurrentRotation - GTowerHUD.AmmoBar.TargetRotation ) + 1 ) * 3 * FrameTime()
		)
		
	end

	--GTowerHUD.NewsThink()
	
end

hook.Add( "Think", "GTowerHUDThink", GTowerHUD.Think )
hook.Add( "HUDPaint", "GTowerHUDPaint", GTowerHUD.Paint )

function GM:GTowerHUDShouldDraw()
	return true
end

local e = {
    ["CHudMenu"] = true,
    ["CHudGMod"] = true,
    ["CHudChat"] = true
}

function GM:HUDShouldDraw(element)
    return e[element]
end