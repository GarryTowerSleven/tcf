
-----------------------------------------------------
APP.NiceName = "Party"
APP.Icon = "party"

if CLIENT then

GradientDown = surface.GetTextureID( "VGUI/gradient_down" )
GradientUp = surface.GetTextureID( "VGUI/gradient_up" )
Cursor2D = surface.GetTextureID( "cursor/cursor_default" )

Backgrounds = {
	Material( "gmod_tower/panelos/backgrounds/background1.png", "unlitsmooth" ),
	Material( "gmod_tower/panelos/backgrounds/background2.png", "unlitsmooth" ),
	Material( "gmod_tower/panelos/backgrounds/background3.png", "unlitsmooth" ),
	Material( "gmod_tower/panelos/backgrounds/background4.png", "unlitsmooth" ),
	Material( "gmod_tower/panelos/backgrounds/background5.png", "unlitsmooth" ),
	Material( "gmod_tower/panelos/backgrounds/background6.png", "unlitsmooth" ),
	Material( "gmod_tower/panelos/backgrounds/background7.png", "unlitsmooth" ),
	Material( "gmod_tower/panelos/backgrounds/background8.png", "unlitsmooth" ),
	Material( "gmod_tower/panelos/backgrounds/background9.png", "unlitsmooth" ),
}

--Icons = GTowerIcons.Icons

local path = "gmod_tower/panelos/icons/"

local function Create( png, filter, path_override )
	return Material( (path_override or path).. png, filter or "unlitsmooth" )
end

local Icons = {
	["gmt"] = Create( "logo_flat.png", "unlitsmooth", "gmod_tower/hud/" ),
	["gmtsmall"] = Create( "gmt.png" ),
	["home"] = Create( "home.png" ),
	["back"] = Create( "back.png" ),
	["camera"] = Create( "video.png" ),
	["music"] = Create( "music.png" ),
	["options"] = Create( "settings.png" ),
	["lock"] = Create( "lock.png" ),
	["unlock"] = Create( "unlock.png" ),
	["alarm"] = Create( "alarms.png" ),
	["time"] = Create( "time.png" ),
	["backspace"] = Create( "backspace.png" ),
	["label"] = Create( "label.png" ),
	["about"] = Create( "about.png" ),
	["storage"] = Create( "storage.png" ),
	["skip"] = Create( "skip.png" ),
	["rewind"] = Create( "rewind.png" ),
	["pause"] = Create( "pause.png" ),
	["play"] = Create( "play.png" ),
	["shuffle"] = Create( "shuffle.png" ),
	["addqueue"] = Create( "addqueue.png" ),
	["images"] = Create( "images.png" ),
	["doorclose"] = Create( "door_closed.png" ),
	["dooropen"] = Create( "door_open.png" ),
	["condo"] = Create( "condo.png" ),
	["players"] = Create( "players.png" ),
	["controller"] = Create( "controller.png" ),
	["movies"] = Create( "movies.png" ),
	["beer"] = Create( "beer.png" ),
	["tv"] = Create( "tv.png" ),
	["party"] = Create( "party.png" ),
	["musicpage"] = Create( "musicpage.png" ),
	["instrument"] = Create( "instrument.png" ),
	["accept"] = Create( "accept.png" ),
	["cancel"] = Create( "cancel.png" ),
	["ban"] = Create( "ban.png" ),
	["heart"] = Create( "heart.png" ),
	["box"] = Create( "box.png" ),
	["broom"] = Create( "broom.png" ),
	["safe"] = Create( "safe.png" ),
	["money"] = Create( "money.png" ),
	["moneylost"] = Create( "money.png" ),
	["trophy"] = Create( "trophy.png" ),
	["present"] = Create( "present.png" ),
	["clipboard"] = Create( "clipboard.png" ),
	["hat"] = Create( "hat.png" ),
	["arcade"] = Create( "arcade.png" ),
	["cards"] = Create( "cards.png" ),
	["slots"] = Create( "slots.png" ),
	["pool"] = Create( "pool.png" ),
	["flag"] = Create( "flag.png" ),
	["admin"] = Create( "admin.png" ),
	["announce"] = Create( "announce.png" ),
	["exclamation"] = Create( "exclamation.png" ),
	["next"] = Create( "next.png" ),
	["light"] = Create( "light.png" ),
	["floor1"] = Create( "floor1.png" ),
	["floor2"] = Create( "floor2.png" ),
	["volume_on"] = Create( "volume_on.png" ),
	["volume_off"] = Create( "volume_off.png" ),
	["volume"] = Create( "volume.png" ),
	["volume16"] = Create( "volume16.png", "unlit" ),
	["chips"] = Create( "chip.png", nil, "gmod_tower/icons/" ),
}

Sounds = {
	["accept"] = "GModTower/ui/panel_accept.wav",
	["back"] = "GModTower/ui/panel_back.wav",
	["error"] = "GModTower/ui/panel_error.wav",
	["save"] = "GModTower/ui/panel_save.wav",
}

end

local sideBarWidth = 500
local options = {
	{
		icon = "beer",
		name = "Drinks"
	},
	{
		icon = "movies",
		name = "Movies"
	},
	{
		icon = "music",
		name = "Music"
	},
	{
		icon = "controller",
		name = "Games"
	},
	{
		icon = "tv",
		name = "TV Shows"
	},
	{
		icon = "musicpage",
		name = "Instruments"
	},
}

function APP:Start()

	if SERVER then self.BaseClass:Start() return end

	self.I.HomeBG = self.I.HomeBG or 1
	self:SetupOptions()

end

function APP:GetSelectedOptions()

    local flags = ""

    for id, option in pairs( options ) do

        if option.enabled then
        flags = flags .. id .. ","
        end

    end

    if flags != nil then
        flags = string.sub(flags,1,string.len(flags)-1)
    end

    return flags

end

function APP:ClearSelectedOptions()

	for id, option in pairs( options ) do
		if option.enabled then
			option.enabled = false
		end
	end

end

local function HasParty( refent )
	return LocalPlayer():GetNWBool("Party")--refent:GetParty()
end

local function Money()
    return LocalPlayer().GTMoney or 0
end

local function Afford( price )
	return Money() >= price
end

function APP:SetupOptions()

	self.buttons = {}

	local iconSize = 64
	local spacing = 2
	local x, y = 0, 200
	local w, h = sideBarWidth, iconSize + (spacing*2)
	local sideBarHeight = 0

	for k,v in pairs( options ) do

		self:CreateButton( v.name, x, y, w, h,
			function( btn, x, y, w, h, isover ) -- draw

				if HasParty(self.R()) then return end

				local afford = Afford(250)

				-- They cannot afford it, so don't let them select anything
				if not afford then
					isover = false
					v.enabled = false
				end

				local accepticon = nil
				if v.enabled then accepticon = Icons.accept end

				DrawButtonTab( v.name, Icons[v.icon], iconSize, x, y, w, h, isover, v.enabled, accepticon )

			end,
			function( btn ) -- onclick

				if HasParty(self.R()) then return end

				local afford = Afford(250)

				-- They cannot afford it, so don't let them select anything
				if not afford then
					return
				end

				v.enabled = not v.enabled

				if v.enabled then
					self.E:Sound(Sounds["accept"])
				else
					self.E:Sound(Sounds["back"])
				end
			end
		)

		sideBarHeight = sideBarHeight + h + (spacing*2)
		y = y + h + (spacing*2)

	end

	local color = Color( 0, 0, 0, 150 )
	local color_hovered = color_hovered or Color( 255, 255, 255, 50 )

	local function DrawBigButton( text, text2, x, y, w, h, isover, afford )

		if isover and afford then
			surface.SetDrawColor( color_hovered )
		else
			surface.SetDrawColor( color )
		end

		surface.DrawRect( x, y, w, h )

		surface.SetDrawColor( 0, 0, 0, 150 )
		if afford then
			local color = colorutil.Rainbow(150)
			surface.SetDrawColor( color.r, color.g, color.b, 50 )
		end

		surface.SetTexture( GradientUp )
		surface.DrawTexturedRect( x, y, w, h )

		-- They cannot afford it, tell them the amount they need
		if afford then
			draw.SimpleText( text, "AppBarLarge", x+w/2, y+h/2, nil, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			if text2 then draw.SimpleText( text2, "AppBarSmall", x+w/2, y+h/2 + 50, Color( 255, 255, 255, 150 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER ) end
		else
			draw.SimpleText( text, "AppBarLarge", x+w/2, y+h/2, Color( 255, 255, 255, 50 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			if text2 then draw.SimpleText( text2, "AppBarSmall", x+w/2, y+h/2 + 50, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER ) end
		end

	end

	local cost = 250

	self:CreateButton( "startparty", sideBarWidth + 20, 200, scrw-sideBarWidth-40, sideBarHeight,
		function( btn, x, y, w, h, isover ) -- draw

			if HasParty(self.R()) then return end

			local flags = self:GetSelectedOptions()
			local afford = Afford(250) and #flags > 0
			local text = "START PARTY!"
			local text2 = "Costs "..cost.." GMC"
			if not afford then text2 = "You need "..cost.." GMC to start a party." end
			if #flags == 0 then text2 = "Select what your party has first." end

			DrawBigButton( text, text2, x, y, w, h, isover, afford )

		end,
		function( btn ) -- onclick

			if HasParty(self.R()) then return end

			local flags = self:GetSelectedOptions()
			local afford = Afford(250) and #flags > 0
			if not afford then return end

			RunConsoleCommand( "gmt_startroomparty", flags )
			self:ClearSelectedOptions()

		end
	)

	self:CreateButton( "endparty", 100, 100, scrw-200, scrh-200,
		function( btn, x, y, w, h, isover ) -- draw

			if HasParty(self.R()) then
				local text = "END PARTY"
				DrawBigButton( text, nil, x, y, w, h, isover, true )
			end

		end,
		function( btn ) -- onclick

			if HasParty(self.R()) then
				RunConsoleCommand( "gmt_endroomparty" )
			end

		end
	)

end

function APP:Think()

end
function APP:DrawSideBar()

	surface.SetDrawColor( 0, 0, 0, 150 )
	surface.SetTexture( GradientUp )
	surface.DrawTexturedRect( 0, 0, sideBarWidth, scrh )

end

function APP:Draw()

	surface.SetMaterial( Backgrounds[self.I.HomeBG] )
	surface.SetDrawColor( 255, 255, 255, 100 )
	surface.DrawTexturedRect( 0, 0, scrw, scrh )

	self:DrawSideBar()
	self:DrawButtons()

	if not HasParty(self.R()) then

		DrawLabel( "Select what your party will have", 0, 150, sideBarWidth )

		if not Afford(250) then
			DrawPromptNotice( "Insufficient Funds", "You need 250 GMC to start a party" )
		end

	end

end

function APP:End()
	self.BaseClass.End(self)
end
