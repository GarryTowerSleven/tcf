
-----------------------------------------------------
APP.NiceName = "Settings"

APP.Icon = "options"

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
}

Sounds = {

	["accept"] = "GModTower/ui/panel_accept.wav",

	["back"] = "GModTower/ui/panel_back.wav",

	["error"] = "GModTower/ui/panel_error.wav",

	["save"] = "GModTower/ui/panel_save.wav",

}


end

local sideBarWidth = 500



local tabs = {

	{

		icon = "label",

		name = "Name Tag"

	},

	{

		icon = "images",

		name = "Background"

	},

	{

		icon = "alarm",

		name = "Doorbell"

	},

}



if CLIENT then

	CreateClientConVar( "gmt_condotag", "", true, true )

end



--Called once

function APP:Init()


	-- Doorbells
local DoorbellPath = "GModTower/lobby/condo/doorbells/"
local function NewDoorbell( name, wav )
	local snd = nil
	if wav then snd = clsound.Register( DoorbellPath .. wav .. ".wav" ) end
	return { name = name, snd = snd }
end

Doorbells = {
	NewDoorbell( "Standard", "standard1" ),
	NewDoorbell( "Silent", nil ),

	NewDoorbell( "Ding-Dong", "standard2" ),
	NewDoorbell( "Ambient", "Ambient1" ),

	NewDoorbell( "Happy", "happy1" ),
	NewDoorbell( "Happy 2", "happy2" ),

	NewDoorbell( "Spooky", "spooky1" ),
	NewDoorbell( "Spooky 2", "spooky2" ),
	NewDoorbell( "Spooky 3", "spooky3" ),

	NewDoorbell( "Disco", "disco1" ),
	NewDoorbell( "Disco 2", "disco2" ),
	NewDoorbell( "Disco 3", "disco3" ),

	NewDoorbell( "French", "french1" ),
	NewDoorbell( "French 2", "french2" ),
	NewDoorbell( "French 3", "french3" ),

	NewDoorbell( "Jazzy", "jazzy1" ),
	NewDoorbell( "Jazzy 2", "jazzy2" ),
	NewDoorbell( "Jazzy 3", "jazzy3" ),

	NewDoorbell( "Funky", "funky1" ),
	NewDoorbell( "Funky 2", "funky2" ),
	NewDoorbell( "Funky 3", "funky3" ),
	NewDoorbell( "Funky 4", "funky4" ),

	NewDoorbell( "Robot", "robot1" ),
	NewDoorbell( "Robot 2", "robot2" ),

	NewDoorbell( "Vocoder", "vocoder1" ),
	NewDoorbell( "Vocoder 2", "vocoder2" ),

}

	if SERVER and IsValid(self.C()) and IsValid( self.C().Owner ) then

		local text = self.C().Owner:GetInfo( "gmt_condotag" ) or ""

		self:SetCondoNameTag( text )

	end



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



	if self.currentTab then

		self:Repl("SetCurrentTab", self.currentTab )

	else

		self.currentTab = "Name Tag"

		self:Repl("SetCurrentTab", self.currentTab )

	end



end



function APP:SetupTabs()



	self.buttons = {}



	local iconSize = 64

	local spacing = 2

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



end



function APP:StartTab( tab )



	self:SetupTabs()



	if tab == "Name Tag" then



		local padding = 6

		local x, y = sideBarWidth+32, 250

		local w, h = scrw-x-32, 56

		local color = Color( 0, 0, 0, 150 )

		local color_hovered = color_hovered or Color( 255, 255, 255, 50 )

		local screen = self.E.screen



		self:CreateButton( "nameinput", x, y, w, h,

			function( btn, x, y, w, h, isover ) -- draw



				surface.SetTextColor( 255, 255, 255 )



				if isover then

					surface.SetDrawColor( color_hovered )

				else

					surface.SetDrawColor( color )

				end



				surface.DrawRect( x, y, w, h )



				surface.SetFont( "AppBarSmall" )

				surface.SetTextPos( x+padding*2, y+padding*2-2 )



				--local name = ""

				--if IsValid( self.R() ) then

					--name = self.R():GetTag() or ""

				--end


				local name = GetConVarString( "gmt_condotag" )

				if new != nil then
					RunConsoleCommand("gmt_condotag", new)
				end


				if screen:IsEditingText() then

					self.NameTagEditing = true

					name = screen:GetCaretString()

				end

				if !screen:IsEditingText() and self.NameTagEditing then

					self.NameTagEditing = nil

					self.E:Sound( Sounds["save"] )

				end



				surface.DrawText( name )



			end,

			function( btn ) -- onclick

				self.E:Sound( Sounds["accept"] )

				screen.OnTextChanged = function(screen, old, new)

					if #new > 36 then

						self.E:Sound( Sounds["error"] )

						return false

					else

						RunConsoleCommand("gmt_condotag", new)
						self:Repl3("SetCondoNameTag", new)

					end

				end

				screen:StartTextEntry(self.C().Tag, true)

			end

		)



	end

	if tab == "Background" then



		local iconSize = 128

		local spacing = 6

		local x, y = sideBarWidth+32, 250

		local w, h = iconSize, iconSize

		local c, columns = 1, 5



		for k,v in pairs(Backgrounds) do



			if type(v) == "number" then continue end -- WHY THE FUCK



			self:CreateButton( "bg"..k, x, y, w, h,

				function( btn, x, y, w, h, isover ) -- draw



					if CondoBackground:GetInt() == k then

						surface.SetDrawColor( 255, 255, 255, 255 )

						surface.DrawRect( x-2, y-2, w+4, h+4 )

					end



					surface.SetMaterial( v )

					surface.SetDrawColor( 255, 255, 255, 255 )

					surface.DrawTexturedRect( x, y, w, h )



				end,

				function( btn ) -- onclick

					self.I.HomeBG = k

					RunConsoleCommand("gmt_condobg",tostring(k))
					self:Repl("SetBackground", self.I.HomeBG)

				end

			)



			x = x + iconSize + spacing



			if c >= columns then

				x = sideBarWidth+32

				y = y + iconSize + spacing

				c = 0

			end



			c = c + 1



		end



	end



	if tab == "Doorbell" then



		local spacing = 2

		local padding = 6

		local x, y = sideBarWidth+32, 250-32

		local w, h = 200, 64

		local color = Color( 0, 0, 0, 150 )

		local color_hovered = color_hovered or Color( 255, 255, 255, 50 )

		local c, columns = 1, 4



		for k,v in pairs(Doorbells) do


			if v.name == 'Assi' and !LocalPlayer():IsAdmin() then continue end

			self:CreateButton( v.name, x, y, w, h,

				function( btn, x, y, w, h, isover ) -- draw

					if CondoDoorbell:GetInt() == k then

						surface.SetDrawColor( 255, 255, 255, 255 )

						surface.DrawRect( x-2, y-2, w+4, h+4 )

						surface.SetTextColor( 0, 0, 0 )

					else

						surface.SetTextColor( 255, 255, 255 )

					end



					if isover then

						surface.SetDrawColor( color_hovered )

					else
						surface.SetDrawColor( color )

					end


					if v.name == "Assi" then

					if isover then

						surface.SetDrawColor( Color(255,150,150,255) )
					else
						surface.SetDrawColor( Color(255,50,50,255) )
					end


					end


					surface.DrawRect( x, y, w, h )



					surface.SetFont( "AppBarSmall" )

					surface.SetTextPos( x+padding*2, y+padding*2-2 )

					surface.DrawText( v.name )

				end,

				function( btn ) -- onclick

					self:Repl3("SetDoorbell", k)

					if v.snd then

						self.E:Sound( v.snd )

					end

					RunConsoleCommand( "gmt_condodoorbell", tostring(k) )
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



	end



end



function APP:Think()


	self.I.HomeBG = (math.Clamp(CondoBackground:GetInt(),1,9) or 1)
end



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



	if self.currentTab == "Name Tag" then

		DrawLabel( "Set a name for your condo", sideBarWidth+20, 200, scrw )

		if self.E.screen:IsEditingText() then
			DrawPromptHelp( "Press ENTER to finish typing", sideBarWidth+20, 320, scrw )
		end

	end



	self:DrawButtons()



end



function APP:DrawItemStatus()



	-- Storage meter

	DrawLabel( "CONDO STORAGE", 0, 70, sideBarWidth )



	local items, max = 0, 100

	local room = LocalPlayer().GLocation - 1

	if room and IsValid( GtowerRooms:RoomOwner(room) ) then

		items = GtowerRooms:RoomOwner(room).GRoomEntityCount
		max = GtowerRooms:RoomOwner(room):GetSetting("GTSuiteEntityLimit")
	end



	draw.RectFillBorder( 16, 120, sideBarWidth-16, 32, 1, (items/max), Color( 31, 31, 31 ), Color( 255, 255, 255 ) )



	local text = items .. "/" .. max

	surface.SetFont( "AppBarLabelSmall" )

	local tw, th = surface.GetTextSize( text )

	surface.SetTextPos( sideBarWidth-tw, 155 )

	surface.DrawText( text )



end



function APP:DrawSideBar()



	surface.SetDrawColor( 0, 0, 0, 150 )

	surface.SetTexture( GradientUp )

	surface.DrawTexturedRect( 0, 0, sideBarWidth, scrh )



end



function APP:End()

	self.BaseClass.End(self)

end
