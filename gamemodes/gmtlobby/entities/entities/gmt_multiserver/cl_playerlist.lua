---------------------------------
local function CalculateYPos( self, Tbl )

	if !Tbl.MinList then
		Tbl.MinList = table.Count( Tbl.PlayerList )
	end

	Tbl.Height = Tbl.MinList * self.DefaultTextHeight
	Tbl.y = self.PlayerStartY

end

function ENT:UpdatePlayerList()

	local EachHeight = self.DefaultTextHeight + 64
	local MaxSpace = math.floor( (self.TotalHeight - self.TopHeight) / EachHeight ) - 2

	self.PlayerGui =  {
		Title = "Current Game",
		x = self.TotalMinX + self.TotalWidth * (2/4) - self.PlayerWidth / 2 + 612,
		PlayerList = self.ServerPlayers or {},
		MinList = self.ServerMaxPlayers or 0,
		EachHeight = EachHeight,
		Type = "current"
	}

	local PlayerList, ColorList = self:MakeList( self.WaitingList, MaxSpace )

	self.WaitingGui = {
		Title = "Queue",
		x = self.TotalMinX + 100,
		PlayerList = PlayerList,
		ColorList = ColorList,
		EachHeight = EachHeight,
		Type = "queue"
	}

	CalculateYPos( self, self.PlayerGui )
	CalculateYPos( self, self.WaitingGui )

	// Fill the empty slots with something
	local Difference = self.PlayerGui.MinList - table.Count( self.PlayerGui.PlayerList )
	for i=1, Difference do
		table.insert( self.PlayerGui.PlayerList, "" )
	end

end

function ENT:DrawPlayers()

	if !self.ServerOnline then return end

	if self.PlayerGui then self:DrawPlayerList( self.PlayerGui ) end
	if self.WaitingGui then  self:DrawPlayerList( self.WaitingGui, self.ServerMinPlayers ) end

end

function ENT:DrawPlayerList( List, PlyCount )

	local x, y = List.x, List.y + 92

	local players = List.PlayerList

	local Count = math.max( table.Count( players ), List.MinList ) + 1
	local TotalHeight = Count * List.EachHeight
	local CurY = y + 2

	local realPlyCount = #players

	draw.DrawText( List.Title, "MultiQueueTitleDeluxe", x, CurY - 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )

	local plyText

	// Draw player count
	if #players > 0 || PlyCount then

		count = #players
		local cx = x + 155

		if PlyCount && PlyCount > 0 then
			count = count .. "/" .. PlyCount
			cx = x + 125
		end

		plyText = count
	else
		plyText = "0"
	end

	draw.DrawText( plyText .. " players", "MultiQueueTitleDeluxe", x + 830, CurY - 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT )

	CurY = CurY + List.EachHeight

	if !self.OldPlayerCount then self.OldPlayerCount = 0 end
	if !self.JoinOffset then self.JoinOffset = 0 end

	if ( #players > 0 || PlyCount ) && ( self.OldPlayerCount != #players ) && List.Type == "queue" then
		self.OldPlayerCount = #players
		self.JoinOffset = 0
	end

	self.JoinOffset = Lerp( FrameTime() * 2, self.JoinOffset, 255 )

	for k, v in pairs( players ) do

		local offset = 0
		local opacity = 255
		local currentHeightOffset = 0

		if k == #players then
			offset = self.JoinOffset / 2 - (255 / 2)
			opacity = self.JoinOffset
		end

		if List.Type == "current" then
			currentHeightOffset = 590
			List.EachHeight = 64
		else
			draw.RoundedBox( 12, x + offset, CurY - 2 + (k * 12) + currentHeightOffset, self.PlayerWidth / 1.22, List.EachHeight, Color(0, 0, 0, opacity - 155) )
		end

		if v != "" then
			if List.ColorList then
				if List.ColorList[k] == true then
					surface.SetFont("MultiQueuePlayerBDeluxe")
					surface.SetTextColor( 175 + math.sin( CurTime() * 6 ) * 80, 255, 175 + math.sin( CurTime() * 6 ) * 80, opacity )
				else
					surface.SetFont("MultiQueuePlayerDeluxe")
					surface.SetTextColor( 255, 255, 255, opacity )
				end
			end

			if List.Type == "current" && k > 4 then
				currentHeightOffset = currentHeightOffset - 304
				offset = 400

				if string.len(v) > 8 then
					v = string.sub(v,1,8) .. "..."
				end

				if k == 8 then
					v = "And " .. #players - 8 .. " more!"
				elseif k > 8 then
					return
				end
			end

			surface.SetTextPos( x + 24 + offset, CurY + 8 + (k * 12) + currentHeightOffset)
			surface.DrawText( v )
		end

		CurY = CurY + List.EachHeight
		//DrawDark = not DrawDark
	end

end
