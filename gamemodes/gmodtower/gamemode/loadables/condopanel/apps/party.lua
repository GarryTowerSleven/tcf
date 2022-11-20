APP.NiceName = "Party"
APP.Icon = "party"

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

	local flags = string.sub( flags, 1, #flags - 1 )

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

				local afford = Afford(GtowerRooms.PartyCost)

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

				local afford = Afford(GtowerRooms.PartyCost)
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

	local cost = GtowerRooms.PartyCost

	self:CreateButton( "startparty", sideBarWidth + 20, 200, scrw-sideBarWidth-40, sideBarHeight,
		function( btn, x, y, w, h, isover ) -- draw

			if HasParty(self.R()) then return end

			local flags = self:GetSelectedOptions()
			local afford = Afford(cost) and #flags > 0
			local text = "START PARTY!"
			local text2 = "Costs "..cost.." GMC"
			if not afford then text2 = "You need "..cost.." GMC to start a party." end
			if #flags == 0 then text2 = "Select what your party has first." end

			DrawBigButton( text, text2, x, y, w, h, isover, afford )

		end,
		function( btn ) -- onclick

			if HasParty(self.R()) then return end

			local flags = self:GetSelectedOptions()
			local afford = Afford(cost) and #flags > 0
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

		if not Afford(GtowerRooms.PartyCost) then
			DrawPromptNotice( "Insufficient Funds", "You need " .. tostring(GtowerRooms.PartyCost) .. " GMC to start a party" )
		end

	end

end

function APP:End()
	self.BaseClass.End(self)
end
