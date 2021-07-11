
-----------------------------------------------------
APP.NiceName = "Guest Management"
APP.Icon = "players"

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

Icons = {
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

local sideBarWidth = 300
local tabs = {
	{
		icon = "players",
		name = "Guests"
	},
	--[[{
		icon = "heart",
		name = "Friends"
	},]]
	{
		icon = "ban",
		name = "Banned"
	},
}

--Called once
function APP:Init()
end

function APP:SetCurrentTab(tab)
	if tab != "" then
		self.E:Sound(Sounds["accept"])
	end

	self:StartTab(tab)
end

function APP:Start()

	self.I.HomeBG = self.I.HomeBG or 1
	self.BaseClass:Start()

	if SERVER then return end

	self:GetBannedGuests()
	self:SetupTabs()

	if self.currentTab then
		self:Repl("SetCurrentTab", self.currentTab )
	else
		self.currentTab = "Guests"
		self:Repl("SetCurrentTab", self.currentTab )
	end

end
local iconSize = 64
local spacing = 2

function APP:SetupTabs()

	self.buttons = {}

	local x, y = 0, 200
	local w, h = sideBarWidth, iconSize + (spacing*2)

	for k,v in pairs( tabs ) do

		self:CreateButton( v.name, x, y, w, h,
			function( btn, x, y, w, h, isover ) -- draw
				DrawButtonTab( v.name, Icons[v.icon], iconSize, x, y, w, h, isover, v.name == self.currentTab )
			end,
			function( btn ) -- onclick
				self.currentTab = v.name
				self:Repl("SetCurrentTab", self.currentTab )
			end
		)

		y = y + h + (spacing*2)

	end

	self:CreateButton( "kickall2", x, y + 25, w, h,
		function( btn, x, y, w, h, isover ) -- draw
			DrawButtonTab( "Kick All", Icons["doorclose"], iconSize, x, y, w, h, isover )
		end,
		function( btn ) -- onclick
			RunConsoleCommand("gmt_roomkick")
		end
	)

end

function APP:GetGuests()

	local loc = self.E:GetNWInt("condoID") + 1
	--local players = GTowerLocation:GetPlayersInLocation( loc )
	local playerfiltered = {}

	for _, ply in pairs( player.GetAll() ) do
		if ply == LocalPlayer() then continue end
		if ply.GLocation != loc then continue end
		table.insert( playerfiltered, ply )
	end

	return playerfiltered

end

if CLIENT then

	net.Receive( "NetworkScores", function( length, ply )
		local ply = net.ReadEntity()
		local bans = net.ReadTable()
		LocalPlayer()._RoomBans = bans

	end )

end

function APP:GetBannedGuests()

	net.Start("RequestRoomBans")
	net.SendToServer()

	return LocalPlayer()._RoomBans

end

function APP:StartTab( tab )

	self:SetupTabs()
	self.PlayerList = {}

	-- Load everyone who is in the condo
	if tab == "Guests" then
		self.PlayerList = self:GetGuests() or {}
	end

	-- Load just the ban list
	if tab == "Banned" then
		self.PlayerList = self:GetBannedGuests() or {}
	end

	-- Kick all
	local w, h = sideBarWidth, iconSize + (spacing*2)
	local x, y = 0, scrh-h-20

	/*self:CreateButton( "kickall", x, y, w, h,
		function( btn, x, y, w, h, isover ) -- draw
			DrawButtonTab( "Kick All", Icons["doorclose"], iconSize, x, y, w, h, isover )
		end,
		function( btn ) -- onclick
			Msg2("WE GOT CLICKED")
			RunConsoleCommand("gmt_roomkick")
		end
	)*/

	if not self.PlayerList then return end

	-- Kick/ban
	local iconSize = 64
	local spacing = 2
	local w, h = iconSize+32, iconSize + (spacing*2)
	local x, y = scrw-w*2-20, 80

	for plyid, ply in pairs( self.PlayerList ) do

		self:CreateButton( "ply_kick"..plyid, x, y, w, h,
			function( btn, x, y, w, h, isover ) -- draw
				DrawButtonTab( "KICK", nil, iconSize, x, y, w, h, isover )
			end,
			function( btn ) -- onclick
				RunConsoleCommand( "gmt_roomkick", ply:EntIndex() )
			end
		)

		local x2 = x + iconSize+32 + (spacing*2)

		self:CreateButton( "ply_ban"..plyid, x2, y, w, h,
			function( btn, x, y, w, h, isover ) -- draw
				DrawButtonTab( "BAN", nil, iconSize, x, y, w, h, isover )
			end,
			function( btn ) -- onclick
				RunConsoleCommand( "gmt_roomban", ply:EntIndex() )
				self:GetBannedGuests()
			end
		)

		y = y + h + (spacing*2)

	end

end

function APP:Think()

end

function APP:Draw()

	surface.SetMaterial( Backgrounds[self.I.HomeBG] )
	surface.SetDrawColor( 255, 255, 255, 100 )
	surface.DrawTexturedRect( 0, 0, scrw, scrh )

	self:DrawSideBar()
	self:DrawPlayerCount()

	if self.currentTab != "" then
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.SetTexture( GradientUp )
		surface.DrawTexturedRect( sideBarWidth, 0, scrw, scrh )
	end

	-- Draw names
	local iconSize = 64
	local spacing = 2
	local x, y = sideBarWidth+20, 80
	local w, h = scrw-sideBarWidth-40, iconSize + (spacing*2)

	for plyid, ply in pairs( self.PlayerList ) do
		DrawButtonTab( ply:GetName(), nil, iconSize, x, y, w, h, isover )
		y = y + h + (spacing*2)
	end

	self:DrawButtons()

	--[[if #self:GetGuests() == 0 then
		DrawPromptNotice( "No Guests", "You currently have no guests in your condo" )
	end]]

end

function APP:DrawPlayerCount()

	local count = tostring(#self:GetGuests())
	DrawLabel( "GUEST COUNT: " .. count, 0, 70, sideBarWidth )

end

function APP:DrawSideBar()

	surface.SetDrawColor( 0, 0, 0, 150 )
	surface.SetTexture( GradientUp )
	surface.DrawTexturedRect( 0, 0, sideBarWidth, scrh )

end

function APP:End()
	self.BaseClass.End(self)
end
