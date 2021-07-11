
-----------------------------------------------------
APP.NiceName = "Ballrace"

APP.Icon = "storage"

APP.Order = 99


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
	["ballrace"] = Create( "gamemode_ballrace.png" ),
}

Sounds = {

	["accept"] = "GModTower/ui/panel_accept.wav",

	["back"] = "GModTower/ui/panel_back.wav",

	["error"] = "GModTower/ui/panel_error.wav",

	["save"] = "GModTower/ui/panel_save.wav",

}


end

local sideBarWidth = 500


local maps = {
	["gmt_ballracer_grassworld01"] = "Grass World",
	["gmt_ballracer_iceworld03"] = "Ice World",
	["gmt_ballracer_khromidro02"] = "Khromidro",
	["gmt_ballracer_memories02"] = "Memories",
	["gmt_ballracer_midori02"] = "Midori",
	["gmt_ballracer_neonlights01"] = "Neon Lights",
	["gmt_ballracer_paradise03"] = "Paradise",
	["gmt_ballracer_sandworld02"] = "Sand World",
	["gmt_ballracer_skyworld01"] = "Sky World",
	["gmt_ballracer_spaceworld01"] = "Space World",
	["gmt_ballracer_tranquil01"] = "Tranquil",
	["gmt_ballracer_waterworld02"] = "Water World",
	["gmt_ballracer_iceworld03"] = "Ice World",
}

local mapsLevels = {
	["gmt_ballracer_grassworld01"] = 8,
	["gmt_ballracer_iceworld03"] = 10,
	["gmt_ballracer_khromidro02"] = 11,
	["gmt_ballracer_memories02"] = 18,
	["gmt_ballracer_midori02"] = 13,
	["gmt_ballracer_neonlights01"] = 7,
	["gmt_ballracer_paradise03"] = 13,
	["gmt_ballracer_sandworld02"] = 10,
	["gmt_ballracer_skyworld01"] = 9,
	["gmt_ballracer_spaceworld01"] = 7,
	["gmt_ballracer_tranquil01"] = 13,
	["gmt_ballracer_waterworld02"] = 7,
	["gmt_ballracer_iceworld03"] = 10,
}

local tabs = {
}


for name1, nicename in pairs( maps ) do
	local tbl = 	{

		icon = "stop",

		name = nicename,
		dbname = name1,
	}

	table.insert(tabs, tbl)

end


--Called once

function APP:Init()

end



function APP:SetBackground(id)

	self.E:Sound(Sounds["save"])

	self.I.HomeBG = id

	if CLIENT then

		self.E:SetScreenFacade(Backgrounds[self.I.HomeBG])

	end

end



function APP:SetDoorbell( doorbell )



	if SERVER then

		local room = self.E:GetCondo()

		if room then

			room:SetDoorbell( doorbell )

		end

	end



	self.C().Doorbell = doorbell



end



function APP:SetCondoNameTag( name )



	if SERVER then

		local room = self.E:GetCondo()

		if room then

			room:SetTag(tostring(name))

		end

	else

		local owner = self.C().Owner

		if IsValid( owner ) and owner == LocalPlayer() then

			RunConsoleCommand("gmt_condotag", name)

		end

	end



	self.E:GetCondo().Tag = name



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

	self.C().Tag = GetConVarString( "gmt_condotag" )



	if SERVER then return end



	self:SetupTabs()



end



function APP:SetupTabs()



	self.buttons = {}



	local iconSize = 40
	local spacing = 2

	local x, y = 0, 100

	local w, h = sideBarWidth, iconSize + (spacing*2)



	for k,v in pairs( tabs ) do



		self:CreateButton( v.name, x, y, w, h,

			function( btn, x, y, w, h, isover ) -- draw

				DrawButtonTab( v.name, Icons[v.icon], iconSize, x, y, w, h, isover, v.name == self.currentTab )

			end,

			function( btn ) -- onclick

				self.currentTab = v.name

				self.currentName = v.dbname
				self:Repl("SetCurrentTab", self.currentTab )

			end

		)



		y = y + h + (spacing*2)



	end



end



function APP:StartTab( tab )



	self:SetupTabs()



	--if tab == "Sky World" then



		local spacing = 2

		local padding = 6

		local x, y = sideBarWidth+32, 500
		local w, h = 150, 50
		local color = Color( 0, 0, 0, 150 )

		local color_hovered = color_hovered or Color( 255, 255, 255, 50 )

		local c, columns = 1, 5



		for i=1,mapsLevels[self.currentName] do



			self:CreateButton( "Level "..tostring(i), x, y, w, h,

				function( btn, x, y, w, h, isover ) -- draw

					/*if self.C().Doorbell == k then

						surface.SetDrawColor( 255, 255, 255, 255 )

						surface.DrawRect( x-2, y-2, w+4, h+4 )

						surface.SetTextColor( 0, 0, 0 )

					else
*/
						surface.SetTextColor( 255, 255, 255 )

					--end



					if isover then

						surface.SetDrawColor( color_hovered )

					else

						surface.SetDrawColor( color )

					end



					surface.DrawRect( x, y, w, h )



					surface.SetFont( "AppBarSmall" )

					surface.SetTextPos( x+padding*2, y+padding*2-10 )

					surface.DrawText( "Level "..tostring(i) )

				end,

				function( btn ) -- onclick

					RunConsoleCommand( "gmt_requeststats", self.currentName, tostring(i) )
				end

			)



			x = x + w + spacing



			if c >= columns then

				x = sideBarWidth+32

				y = y + h + spacing

				c = 0

			end



			c = c + 1



		end



	--end



end



function APP:Think()



end


local Worlds = {

}

local TestNames = {}

local TestTimes = {}

net.Receive("gmt_statnetwork",function()
	local length = net.ReadInt(16)
	local compressed = net.ReadData(length)

	local decompressed = util.Decompress(compressed)
	local table = util.JSONToTable(decompressed)

	TestNames = {}
	TestTimes = {}

	for k,v in pairs( table ) do
		TestNames[k] = v[1]
		TestTimes[k] = v[2]
	end

end)

function APP:Draw()



	surface.SetMaterial( Backgrounds[self.I.HomeBG] )

	surface.SetDrawColor( 255, 255, 255, 100 )

	surface.DrawTexturedRect( 0, 0, scrw, scrh )



	self:DrawSideBar()

	self:DrawItemStatus()



	if self.currentTab != "" then

		surface.SetDrawColor( 0, 0, 0, 255 )

		surface.SetTexture( GradientUp )

		surface.DrawTexturedRect( sideBarWidth, 0, scrw, scrh )

	end


	local string = ""

	for k,v in pairs( TestNames ) do
		string = string .. "#" .. tostring( k ) .. " " .. v .. "\n"
	end

	local TimeString = ""

	for k,v in pairs( TestTimes ) do
		TimeString = TimeString .. tostring( v ) .. "\n"
	end

	draw.DrawText(string,
	"AppBarSmall",
	scrw/2.5,
	scrh/8,
	Color( 255, 255, 255, 255 )
	)

	draw.DrawText(TimeString,
	"AppBarSmall",
	scrw/1.1,
	scrh/8,
	Color( 255, 255, 255, 255 ),
	TEXT_ALIGN_RIGHT
	)

	for i=1,9 do
		surface.SetDrawColor(255,255,255,200)
		surface.DrawRect(scrw/2.5, scrh/8 + (40*(i)), 710, 2)
	end


	self:DrawButtons()



end



function APP:DrawItemStatus()

end



function APP:DrawSideBar()



	surface.SetDrawColor( 0, 0, 0, 150 )

	surface.SetTexture( GradientUp )

	surface.DrawTexturedRect( 0, 0, sideBarWidth, scrh )



end



function APP:End()

	self.BaseClass.End(self)

end
