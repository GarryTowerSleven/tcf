APP.Icon = "condo"
APP.Purpose = "Manage condo functions."
APP.NiceName = "Condo Management"

if CLIENT then
	local sideBarWidth = 500

	local tabs = {
		{
			icon = "condo",
			name = "Condo Customization"
		},
	}

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

		self:SetupTabs()

		if self.currentTab then
			self:Repl("SetCurrentTab", self.currentTab )
		else
			self.currentTab = "Condo Customization"
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

	function APP:Think()

	end

	function APP:End()
		self.BaseClass.End(self)
	end

	function APP:DrawSideBar()
		surface.SetDrawColor( 0, 0, 0, 150 )
		surface.SetTexture( GradientUp )
		surface.DrawTexturedRect( 0, 0, sideBarWidth, scrh )
	end

	function APP:Think()

	end

	function APP:StartTab( tab )
		self:SetupTabs()

		if tab == "Condo Customization" then
			local spacing = 2
			local padding = 6

			local x, y = sideBarWidth+32, 250
			local w, h = 200, 64

			local color = Color( 0, 0, 0, 150 )
			local color_hovered = color_hovered or Color( 255, 255, 255, 50 )
			local c, columns = 1, 4

			self:CreateButton( "Default", x, y, w, h,
				function( btn, x, y, w, h, isover ) -- draw
					if CondoSkyBox:GetInt() == 1 then
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
					surface.DrawText( "Default" )
				end,
				function( btn ) -- onclick
					RunConsoleCommand("gmt_condoskybox","1")
					self.E:Sound( "gmodtower/ui/select.wav" )
				end
			)

			self:CreateButton( "Beach", x + w + 16, y, w, h,
				function( btn, x, y, w, h, isover ) -- draw
					if CondoSkyBox:GetInt() == 2 then
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
					surface.DrawText( "Beach" )
				end,
				function( btn ) -- onclick
					RunConsoleCommand("gmt_condoskybox","2")
					self.E:Sound( "gmodtower/ui/select.wav" )
				end
			)
			
			self:CreateButton( "On", x, y + 200, w, h,
				function( btn, x, y, w, h, isover ) -- draw
					if CondoBlinds:GetInt() == 1 then
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
					surface.DrawText( "Opened" )

				end,
				function( btn ) -- onclick
					self.E:Sound( "gmodtower/ui/select.wav" )
					RunConsoleCommand("gmt_condoblinds","1")
				end
			)

			self:CreateButton( "Off", x + w + 16, y + 200, w, h,
				function( btn, x, y, w, h, isover ) -- draw
					if CondoBlinds:GetInt() == 2 then
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
					surface.DrawText( "Closed" )
				end,
				function( btn ) -- onclick
					self.E:Sound( "gmodtower/ui/select.wav" )
					RunConsoleCommand("gmt_condoblinds","2")
				end
			)
		end
	end

	function APP:Draw()
		surface.SetMaterial( Backgrounds[self.I.HomeBG or 1] )
		surface.SetDrawColor( 255, 255, 255, 100 )
		surface.DrawTexturedRect( 0, 0, scrw, scrh )

		self:DrawSideBar()

		if self.currentTab != "" then
			surface.SetDrawColor( 0, 0, 0, 255 )
			surface.SetTexture( GradientUp )
			surface.DrawTexturedRect( sideBarWidth, 0, scrw, scrh )
		end

		if self.currentTab == "Condo Customization" then
			DrawLabel( "Condo Skybox", sideBarWidth+20, 200, scrw )
			DrawLabel( "Master Bedroom - Window Blinds", sideBarWidth+20, 400, scrw )
		end

		self:DrawButtons()
	end
end