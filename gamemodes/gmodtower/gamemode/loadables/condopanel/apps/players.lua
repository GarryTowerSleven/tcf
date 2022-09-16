APP.NiceName = "Guest Management"
APP.Icon = "players"

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

end

function APP:GetGuests()

	local loc = self.E:GetNWInt("condoID")
	local players = Location.GetPlayersInLocation( loc )
	local playerfiltered = {}

	for _, ply in pairs( player.GetAll() ) do
		if ply == LocalPlayer() then continue end
		if ply:Location() != loc then continue end
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

		-- Kick all
		local w, h = sideBarWidth, iconSize + (spacing*2)
		local x, y = 0, scrh-h-100

		self:CreateButton( "kickall", x, y, w, h,
			function( btn, x, y, w, h, isover ) -- draw
				DrawButtonTab( "Kick All", Icons["doorclose"], iconSize, x, y, w, h, isover )
			end,
			function( btn ) -- onclick
				RunConsoleCommand("gmt_roomkick")
			end
		)
	end

	-- Load just the ban list
	if tab == "Banned" then
		self.PlayerList = self:GetBannedGuests() or {}
	end

	if not self.PlayerList then return end

	-- Kick/ban
	local iconSize = 64
	local spacing = 2
	local w, h = iconSize+32, iconSize + (spacing*2)
	local x, y = scrw-w*2-20, 80
	local x2 = x + iconSize+32 + (spacing*2)

	for plyid, ply in pairs( self.PlayerList ) do

		if tab != "Banned" then
			self:CreateButton( "ply_kick"..plyid, x, y, w, h,
				function( btn, x, y, w, h, isover ) -- draw
					DrawButtonTab( "KICK", nil, iconSize, x, y, w, h, isover )
				end,
				function( btn ) -- onclick
					RunConsoleCommand( "gmt_roomkick", ply:EntIndex() )
				end
			)

			self:CreateButton( "ply_ban"..plyid, x2, y, w, h,
				function( btn, x, y, w, h, isover ) -- draw
					DrawButtonTab( "BAN", nil, iconSize, x, y, w, h, isover )
				end,
				function( btn ) -- onclick
					RunConsoleCommand( "gmt_roomban", ply:EntIndex() )
					self:GetBannedGuests()
				end
			)
		else
			self:CreateButton( "ply_unban"..plyid, x2, y, w, h,
				function( btn, x, y, w, h, isover ) -- draw
					DrawButtonTab( "LIFT", nil, iconSize, x, y, w, h, isover )
				end,
				function( btn ) -- onclick
					RunConsoleCommand( "gmt_roomunban", ply:EntIndex() )
					self:GetBannedGuests()
				end
			)
		end

		y = y + h + (spacing*2)

	end

end

function APP:Think()
	self:GetGuests()
	self:GetBannedGuests()
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
