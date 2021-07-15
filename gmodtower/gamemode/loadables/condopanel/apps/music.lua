APP.Icon     = "music"
APP.Purpose  = "Play music throughout the condo."
APP.NiceName = "Music"


function APP:Start()
	self.BaseClass:Start()

	local ent
	for k,v in pairs( ents.FindByClass("gmt_condoplayer") ) do
		if v:GetNWInt("condoID") == self.E:GetNWInt("condoID") then ent = v end
	end
	self.mp = ent:GetMediaPlayer()

	if CLIENT then
		self:SetupControls()
	end

end


function APP:Think()
	if not self.mp then
		-- wait for media player to be networked to the client
		--self.mp = ent:GetCondoMediaPlayer()
		local ent
		for k,v in pairs( ents.FindByClass("gmt_condoplayer") ) do
			if v:GetNWInt("condoID") == self.E:GetNWInt("condoID") then ent = v end
		end
		if IsValid(ent) then
			self.mp = ent:GetMediaPlayer()
		end
	end

end

function APP:End()
	self.BaseClass.End(self)
end

if CLIENT then

	local vis_mountains = surface.GetTextureID( "gmod_tower/nightclub/panel_mountains" )
	local ListX, ListY = 0, 300

	local color = Color( 20, 20, 20 )
	local gradient = surface.GetTextureID( "VGUI/gradient_up" )

	function APP:Draw()

		if not self.mp then return end

		surface.SetMaterial( Backgrounds[self.I.HomeBG or 1] )
		surface.SetDrawColor( 255, 255, 255, 100 )
		surface.DrawTexturedRect( 0, 0, scrw, scrh )

		local media = self.mp:GetMedia()
		local queue = self.mp:GetMediaQueue()
		if not media or not queue or #queue == 0 then
			ListY = 200
		else
			ListY = 300
		end

		self:DrawVisualizer( scrw, scrh )
		self:DrawMediaInfo( scrw-ListX, ListY )
		self:DrawButtons()
		self:DrawMediaQueue( scrw-ListX, scrh )

		-- Divider
		local TextBoxBorderColor = colorutil.Brighten( color, .25, 150 )
		surface.SetDrawColor( TextBoxBorderColor )
		surface.DrawRect( ListX-3, 0, 3, scrh )

	end

	function APP:SetupControls()

		self.buttons = {}

		self.controls = {
			--[[{
				icon = Icons["shuffle"],
				func = function()
					MediaPlayer.RequestShuffle( self.mp )
				end,
				alwayson = false,
				enabled = function()
					return self.mp:GetShuffle()
				end
			},]]
			{
				icon = Icons["addqueue"],
				text = "ADD MUSIC",
				func = function()
					if not self.mp then return end
					MediaPlayer.OpenRequestMenu( self.mp )
				end,
				alwayson = true
			},
			{
				icon = Icons["pause"],
				func = function()
					if not self.mp then return end
					MediaPlayer.Pause( self.mp )
					if self.controls[2].icon == Icons["play"] then
						self.controls[2].icon = Icons["pause"]
					else
						self.controls[2].icon = Icons["play"]
					end
				end,
				alwayson = false
			},
			{
				icon = Icons["skip"],
				func = function()
					if not self.mp then return end
					local media = self.mp:GetMedia()
					MediaPlayer.RequestRemove( self.mp, media:UniqueID() )
				end,
				alwayson = false
			},
		}

		local iconSize = 64
		local spacing = 10
		local x = (scrw-(scrw-ListX)/2) - ((spacing/2 + iconSize) * #self.controls)/2
		local y = 85

		for k,v in pairs( self.controls ) do

			self:CreateButton( "music" .. k, x, y, iconSize, iconSize,
				function( btn, x, y, w, h, isover ) -- draw
					local media = self.mp:GetMedia()
					local alpha = nil
					local color = Color( 255, 255, 255 )

					-- Disable when no media is on
					if not media and not v.alwayson then
						alpha = 50
					end

					if isover then
						color = Color( 255, 255, 255, 50 )
					end

					-- Toggle enable/disable state
					if v.enabled and v.enabled() then
						color = Color( 0, 125, 173 )
					end

					if v.text then
						draw.SimpleText( v.text, "AppBarLabelSmall", x-spacing, y+h/2, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
					end

					DrawButton( v.icon, x, y, w, Color( color.r, color.g, color.b, alpha ), Color( 255, 255, 255, alpha or 50 ) )
				end,
				function( btn ) -- onclick
					local media = self.mp:GetMedia()
					if not media and not v.alwayson then
						return
					end
					v.func()
				end
			)

			x = x + iconSize + (spacing*2)

		end

	end

	function APP:CreateSlider( name )

		local slide = {
			w = 12,
			h = 24,
			dragging = false
		}

		if not self.sliders then self.sliders = {} end
		self.sliders[name] = slide

	end

	function APP:DrawSlider( name, x, y, w, enddrag, onmove )

		surface.SetDrawColor( 255, 255, 255, 255 )

		if not self.sliders or not self.sliders[name] then
			self:CreateSlider(name)
		end

		local slide = self.sliders[name]
		slide.x = x
		slide.y = y

		-- Determine dragging
		if IsMouseOver( slide.x, slide.y, slide.w, slide.h ) and not slide.dragging then
			if input.IsMouseDown(MOUSE_LEFT) then
				slide.dragging = true
			end
		end

		-- End dragging
		if not input.IsMouseDown(MOUSE_LEFT) and slide.dragging then
			slide.dragging  = false
			enddrag(slide)
		end

		-- Set dragging color
		if IsMouseOver( slide.x, slide.y, slide.w, slide.h ) or slide.dragging then
			surface.SetDrawColor( 0, 125, 173, 255 )
		end

		-- Update drag position
		if slide.dragging then
			slide.x = math.Clamp( mx, 0, w - slide.w - 12 )
			onmove(slide)
		end

		-- Draw slider
		surface.DrawRect( slide.x + 6, slide.y, slide.w, slide.h )

		return slide

	end

	function APP:DrawMediaInfo( w, h )

		local media = self.mp:GetMedia()
		if not media then return end

		local tx, ty = ListX, 75
		local padding = 90

		-- Container background
		surface.SetDrawColor( 30, 30, 30, 200 )
		surface.DrawRect( tx, ty, w, h )


		-- Track bar
		if media and media:IsTimed() then

			-- Duration bar bg
			surface.SetDrawColor( 0, 0, 0, 150 )
			surface.DrawRect( tx, ty + 160, w, 8 )

			-- Slider
			local duration = media:Duration()
			local curTime = media:CurrentTime()
			local percent = math.Clamp( curTime / duration, 0, 1 )
			local slidew = w * percent - 6

			local function ondrag(slide)
				if slide.value then
					MediaPlayer.Seek( self.mp, slide.value )
					slide.value = 0
				end
			end

			local function onmove(slide)
				slide.value = math.ceil( ( slide.x / w ) * duration )
				draw.SimpleText( string.FormatSeconds( slide.value ), "AppBarLabelSmall", slide.x + slide.w, slide.y + 36, Color( 255, 255, 255, 25 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end

			-- Draw slider
			local slide = self:DrawSlider( "seektime", slidew, (ty + 160) - 9, w, ondrag, onmove )

			-- Direct set slider
			if IsMouseOver( tx, ty + 160, w, 24 ) and input.IsMouseDown(MOUSE_LEFT) and not self.wasmousedown then
				local seektime = math.ceil( ( mx / w ) * duration )
				MediaPlayer.Seek( self.mp, seektime )
			end


			-- Duration bar
			surface.SetDrawColor( 0, 125, 173, 255 )
			surface.DrawRect( tx, ty + 160, slide.x + 6, 8 )


			-- Current time
			local durationStr = string.FormatSeconds( duration )
			draw.SimpleText( durationStr, "AppBarLabelSmall", tx + w - 16, ty + 120 + 5, Color( 255, 255, 255, 25 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )

			-- Duration
			local curTimeStr = string.FormatSeconds(math.Clamp(math.Round(curTime), 0, duration))
			draw.SimpleText( curTimeStr, "AppBarLabelSmall", tx + 16, ty + 120 + 5, Color( 255, 255, 255, 25 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

		end

		-- Title
		local title = "No music currenting playing. Add some music above."
		local align = TEXT_ALIGN_CENTER
		local titlex = scrw/2
		if media then
			title = string.RestrictStringWidth( media:Title(), "AppBarSmall", w - (padding*2) )
			align = TEXT_ALIGN_LEFT
			titlex = tx + padding
		end
		draw.SimpleText( title, "AppBarLabel", titlex, ty + 120, Color( 255, 255, 255, 200 ), align, TEXT_ALIGN_CENTER )

		self.wasmousedown = input.IsMouseDown(MOUSE_LEFT)

	end

	function APP:DrawMediaQueue( w, h )

		local mp = self.mp

		-- Queue
		local queue = mp:GetMediaQueue()
		if not queue then return end

		local padding, spacing = 20, 64
		local tx, ty = ListX, ListY

		local arrowh = 32
		local additional = 0

		if #queue > 0 then
			draw.SimpleText( "UP NEXT", "AppBarLabel", tx+w/2, ty, Color( 255, 255, 255, 25 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

		ty = ty + 28

		for i, media in pairs( queue ) do

	 		-- Ignore songs if the list goes beyond and draw an arrow
	 		local maxheight = (ty + spacing + arrowh)
			if maxheight > h then
				additional = i-1
				break
			end

			ty = ty - 2

			-- Container
			surface.SetDrawColor( 30, 30, 30, 255 )
			surface.DrawRect( tx, ty, w, spacing )

			-- Gradient
			surface.SetDrawColor( 0, 0, 0, 150 )
			surface.SetTexture( GradientUp )
			surface.DrawTexturedRect( tx, ty, w, spacing )

			-- Dividers
			surface.SetDrawColor( 60, 60, 60, 255 )
			surface.DrawRect( tx, ty+spacing-2, w, 1 ) -- middle
			if i == 1 then surface.DrawRect( tx, ty, w, 1 ) end -- top
			if i == (#queue) then surface.DrawRect( tx, ty+spacing, w, 1 ) end -- bottom

			-- Number
			local numw = padding
			draw.SimpleText( i, "AppBarLabel", tx + numw, ty+(spacing/2), Color( 255, 255, 255, 25 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

			-- Duration
			if media:IsTimed() then
				local duration = string.FormatSeconds(media:Duration())
				draw.SimpleText( duration, "AppBarLabelSmall", tx + (w - padding), ty+(spacing/2), Color( 255, 255, 255, 25 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			end

			-- Title
			local title = string.RestrictStringWidth( media:Title(), "AppBarLabel", w - padding )
			draw.SimpleText( title, "AppBarLabelSmall", tx + (numw + (padding*2)), ty+(spacing/2), Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

			-- Highlight shuffle item
			//if self.mp:GetShuffle() and self.mp:GetNextShuffle() == i then
			//	surface.SetDrawColor( 255, 255, 255, 50 )
			//	surface.DrawRect( tx, ty, w, spacing )
			//end

			ty = ty + spacing + 2

		end

		-- Arrow (if there's too many songs)
		if additional > 0 then
			local songs = (#queue-additional)
			local songstr = songs .. " more " .. string.Pluralize( "track", songs )
		end

	end

	function APP:DrawVisualizer( w, h )

		local color = colorutil.Rainbow( 50 )

		-- Mountains
		surface.SetTexture( vis_mountains )
		surface.SetDrawColor( 255, 255, 255, 50 )
		surface.DrawTexturedRect( 0, 0, w, h )

	end


end