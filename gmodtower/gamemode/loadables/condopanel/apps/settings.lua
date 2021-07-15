APP.NiceName = "Settings"
APP.Icon = "options"
APP.Order = 99

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

		for k,v in pairs(GtowerRooms.Doorbells) do

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
