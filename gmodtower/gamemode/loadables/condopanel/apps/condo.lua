APP.Icon = "condo"
APP.Purpose = "Manage condo upgrades and other functions."
APP.NiceName = "Condo Management/Upgrades"

local sideBarWidth = 250

local floor1 = Material( "gmod_tower/panelos/maps/condo_floor1.png", "unlitsmooth" )
local floor2 = Material( "gmod_tower/panelos/maps/condo_floor2.png", "unlitsmooth" )
local upgradeBG = Material( "gmod_tower/hud/bg_gradient.png", "unlightsmooth" )

local mapScale = .75
local mapWidth = 790 * mapScale
local mapHeight = 1024 * mapScale
local mapX, mapY = sideBarWidth + (mapWidth/2) - 100, -12
local mapXAddMax = 300 -- how far to move the map to the right

local tabs = {
	{
		icon = "floor1",
		name = "Floor 1"
	},
	{
		icon = "floor2",
		name = "Floor 2"
	},
	--[[{
		icon = Icons["images"],
		name = "Sky"
	},]]
}

local rooms = {
	{
		name = "Closet",
		unique_name = "condo_closet",
		floor = 1,
		x = 419, y = 562,
		w = 56, h = 256,
		buttons = {
			{ name = "Purchase", icon = "money", func = function() end, visible = function() return true end }
		}
	},
	{
		name = "Outside",
		unique_name = "condo_outside",
		floor = 1,
		x = -46, y = 222,
		w = 209, h = 600,
		buttons = {
			{ name = "Purchase", icon = "money", func = function() end, visible = function() return true end }
		}
	},
	{
		name = "Dim Room",
		unique_name = "condo_dimroom",
		floor = 2,
		x = 482, y = 398,
		w = 202, h = 351,
		buttons = {
			{ name = "Purchase", icon = "money", func = function() end, visible = function() return true end }
		}
	},
	{
		name = "Garden",
		unique_name = "condo_garden",
		floor = 2,
		x = 281, y = 0,
		w = 365, h = 214,
		buttons = {
			{ name = "Purchase", icon = "money", func = function() end, visible = function() return true end }
		}
	},
	{
		name = "Master Bedroom",
		unique_name = "condo_bedroom",
		floor = 2,
		x = 170, y = 712,
		w = 273, h = 157,
		buttons = {
			{ name = "Purchase", icon = "money", func = function() end, visible = function() return true end }
			--{ name = "Toggle Blinds", icon = "condo", func = function() end, visible = function() return true end }
		}
	}
}

function APP:Start()

	if SERVER then return end

	if self.currentTab then
		self:Repl("SetCurrentTab", self.currentTab )
	else
		self.currentTab = "Floor 1"
		self:Repl("SetCurrentTab", self.currentTab )
	end

end

function APP:Think()

end

function APP:StartTab( tab )

	self:SetupTabs()

	if tab == "Floor 1" then
		self:SetupFloor(1)
	end
	if tab == "Floor 2" then
		self:SetupFloor(2)
	end

	if tab == "Sky" then

		self:ClearFloorButtons()
		self:ClearRoomButtons()

		local iconSize = 256
		local spacing = 6
		local x, y = sideBarWidth+32, 250
		local w, h = iconSize, iconSize
		local c, columns = 1, 5

		for id, skybox in pairs(GtowerRooms.Skyboxes) do

			-- todo: support for: skybox.cam, skybox.name

			self:CreateButton( "bg"..id, x, y, w, h,
				function( btn, x, y, w, h, isover ) -- draw

					if self.I.Skybox == id then
						surface.SetDrawColor( 255, 255, 255, 255 )
						surface.DrawRect( x-2, y-2, w+4, h+4 )
					end

					surface.SetMaterial( skybox.preview )
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.DrawTexturedRect( x, y, w, h )

				end,
				function( btn ) -- onclick
					self.I.Skybox = id
					self:Repl("SetSkybox", self.I.Skybox)
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

end

function APP:SetSkybox(id)
	self.E:Sound(Sounds["save"])
	self.I.Skybox = id
end

function APP:SetCurrentTab(tab)
	if tab != "" then
		self.E:Sound(Sounds["accept"])
	end

	self:StartTab(tab)
end

local function GetRoomData( roomname )
	for _, room in pairs( rooms ) do
		if roomname == room.name then
			return room
		end
	end
end

local function GetUpgrade( unique_name )

	if not unique_name then return end

	for _, item in pairs( CondoUpgrades.List ) do
		if item.unique_name == unique_name then
			return item
		end
	end

end

function APP:SetCurrentRoom(roomname)

	if roomname != "" then
		self.E:Sound(Sounds["accept"])
	end

	local iconSize = 64
	local spacing = 2
	local x, y = sideBarWidth+20+15, 200
	local w, h = 355+50, iconSize + (spacing*2)

	self:ClearRoomButtons()

	local roomdata = GetRoomData( roomname )

	if roomdata and roomdata.buttons then
		
		for _, roombtn in pairs( roomdata.buttons ) do

			y = y + h
			local unique_name = roomdata.unique_name
			local upgrade = GetUpgrade( unique_name )

			self:CreateButton( "roombtn_"..roombtn.name, x, y, w, h,
				function( btn, x, y, w, h, isover ) -- draw
					if self:IsRoomsShown() then

						local unlocked = unique_name and ( CondoUpgrades.HasUpgrade( LocalPlayer(), unique_name ) == 1 )

						-- Afford
						local afford = true
						if upgrade and not Afford( upgrade.price ) then
							afford = false
						end

						DrawButtonTab( roombtn.name, Icons[roombtn.icon], iconSize, x, y, w, h, isover and afford and not unlocked, nil, nil, not afford or unlocked )

						-- Cost
						if upgrade and upgrade.price and not unlocked then
							DrawCostLabel( upgrade.price, x+w, y+(h/2) )
						end

						-- Can't afford
						if isover and not afford and not unlocked then
							surface.SetDrawColor( Color( 0, 0, 0, 50 ) )
							surface.DrawRect( x, y, w, h )
							DrawSimpleLabel( x+(w/2), y+(h/2), "CAN'T AFFORD", Color( 255, 0, 0, 200 ) )
						end

						-- Already unlocked
						if isover and unlocked then
							surface.SetDrawColor( Color( 0, 0, 0, 50 ) )
							surface.DrawRect( x, y, w, h )
							DrawSimpleLabel( x+(w/2), y+(h/2), "UNLOCKED", Color( 0, 255, 0, 200 ) )
						end

					end
				end,
				function( btn ) -- onclick
					local unlocked = unique_name and ( CondoUpgrades.HasUpgrade( LocalPlayer(), unique_name ) == 1 )
					local purchase = upgrade and Afford( upgrade.price ) and not unlocked
					if self:IsRoomsShown() or purchase then
						if purchase and not unlocked then
							self:CreateConfirmation( 
								"PURCHASE " .. roomname .. " for " .. stringmod.FormatNumber( upgrade.price ) .. " GMC?", 
								function() CondoUpgrades.BuyUpgrade( LocalPlayer(), unique_name ) end
							)
						end
						roombtn.func()
					end
				end
			)

			table.insert( self.RoomButtons, "roombtn_"..roombtn.name )

		end

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
				DrawButtonTab( v.name, Icons[v.icon], iconSize, x, y, w, h, isover, ( v.name == self.currentTab ) )
			end,
			function( btn ) -- onclick
				self.currentTab = v.name
				self:Repl("SetCurrentTab", self.currentTab )
			end
		)

		y = y + h + (spacing*2)

	end

end

function APP:SetupFloor( floor )

	self.I.currentRoom = ""
	self:ClearFloorButtons()

	for _, room in pairs( rooms ) do

		if room.floor != floor then continue end

		self:CreateButton( "room_" .. room.name, mapX + (room.x * mapScale), mapY + (room.y * mapScale), (room.w * mapScale), (room.h * mapScale),
			function( btn, x, y, w, h, isover ) -- draw
				if room.name == self.I.currentRoom then
					surface.SetDrawColor( 0, 125, 173, 200 )
					surface.DrawRect( x, y, w, h )
				end
				if isover then
					surface.SetDrawColor( 0, 0, 0, 100 )
					surface.DrawRect( x, y, w, h )
					draw.RectBorder( x, y, w, h, 6, Color( 0, 125, 173, 255 ) )
				else
					surface.SetDrawColor( 0, 125, 173, 100 )
					surface.DrawRect( x, y, w, h )
				end
			end,
			function( btn ) -- onclick
				if room.name != self.I.currentRoom then
					self.I.currentRoom = room.name
					self:Repl( "SetCurrentRoom", self.I.currentRoom )
				else
					self.I.currentRoom = ""
					self:Repl("SetCurrentTab", self.currentTab )
				end
			end
		)

		table.insert( self.FloorButtons, "room_" .. room.name )

	end

	self:ClearRoomButtons()

end

function APP:ClearRoomButtons()

	if self.RoomButtons then
		for _, btn in pairs( self.RoomButtons ) do
			self.buttons[btn] = nil
		end
	end

	self.RoomButtons = {}

end

function APP:ClearFloorButtons()

	if self.FloorButtons then
		for _, btn in pairs( self.FloorButtons ) do
			self.buttons[btn] = nil
		end
	end

	self.FloorButtons = {}

end

function APP:DrawSideBar()

	surface.SetDrawColor( 0, 0, 0, 150 )
	surface.SetTexture( GradientUp )
	surface.DrawTexturedRect( 0, 0, sideBarWidth, scrh )

end

local mapXAdd = 0

function APP:Think()

	local room = self.I.currentRoom or ""
	if room != "" then mapXAdd = ApproachSupport( mapXAdd, mapXAddMax, 5 ) else mapXAdd = ApproachSupport( mapXAdd, 0, 5 ) end

	if self.FloorButtons then
		for _, btn in pairs( self.FloorButtons ) do
			self.buttons[btn].x = self.buttons[btn].originx + mapXAdd
		end
	end

end

function APP:IsRoomsShown()

	local room = self.I.currentRoom
	return room and mapXAdd >= mapXAddMax

end

function APP:Draw()

	surface.SetDrawColor( 255, 255, 255, 100 )
	surface.DrawRect( 0, 0, scrw, scrh )

	self:DrawSideBar()

	local tab = self.currentTab
	local room = self.I.currentRoom or ""

	-- Upgrade BG
	surface.SetDrawColor( 0, 0, 0, 200 )
	surface.SetMaterial( upgradeBG )
	surface.DrawTexturedRect( sideBarWidth, 64, mapXAdd, scrh-64 )

	surface.SetDrawColor( 255, 255, 255, 255 )

	-- Map
	if tab == "Floor 1" then
		surface.SetMaterial( floor1 )
		surface.DrawTexturedRect( mapX + mapXAdd, mapY, mapWidth, mapHeight )
	end

	-- Map
	if tab == "Floor 2" then
		surface.SetMaterial( floor2 )
		surface.DrawTexturedRect( mapX + mapXAdd, mapY, mapWidth, mapHeight )
	end

	-- Floor
	if self:IsRoomsShown() then
		DrawLabel( "Manage: " .. room, sideBarWidth+20, 200, 150, nil, Color( 255, 255, 255, 150 ) )
	end

	-- Buttons
	self:DrawButtons()

	-- Confirmation
	self:DrawConfirmation()

end