ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.Spawnable		= true
ENT.AdminSpawnable  = true
ENT.PrintName		= "Name"
ENT.Category 		= "Arcade"
ENT.Model			= "models/props_phx/rt_screen.mdl"
ENT.HideTooltip		= true // hides "E PLAY"

ENT.States = {
	IDLE = 0,
	PICK = 1,
	CONTINUE = 2,
	INSERT = 3,
	END = 4,
	TICKETS = 5,
}
ENT.LoseReasons = {
	BADNUMBER = 0,
	IDLE = 1,
	NOAFFORD = 2,
	MAXROUNDS = 3,
}
ENT.LoseReasonsStrings = {
	[ENT.LoseReasons.BADNUMBER] = "Your number was greater than five!",
	[ENT.LoseReasons.IDLE] = "You were idle for more than 20 seconds!",
	[ENT.LoseReasons.NOAFFORD] = "You cannot afford to continue!",
	[ENT.LoseReasons.MAXROUNDS] = "You finished the last round!"
}
ENT.Net = {
	STOP = 0,
	DEAL = 1,
	STAND = 2,
}
ENT.MaxRounds = 20
local a_c = TEXT_ALIGN_CENTER
local a_r = TEXT_ALIGN_RIGHT

local netTrans = {
	"STOP",
	"DEAL",
	"STAND"
}

function ENT:SetupDataTables()

	arcade.SetupArcadeGame( self, "Deal or Stand", 2, Vector( 9.5, 0, -1 ), Angle( -45, 0, 0 ) )
	self:NetworkVar( "Int", 0, "Prize" )
	self:NetworkVar( "Int", 1, "Round" )
	self:NetworkVar( "Int", 2, "State" )
	self:NetworkVar( "Int", 3, "PickedNumber" )
	self:NetworkVar( "Int", 4, "LoseReason" )
	self:NetworkVar( "Float", 0, "Timeout" )

	local sc = screen.New()
	sc:SetPos( self:LocalToWorld( Vector( 6.191631, 0.04217, 19.188477 - 0.5 ) ) )
	sc:SetAngles( self:LocalToWorldAngles( Angle( 0, 0, 0 ) ) )
	sc:SetSize( 56, 33.06 )
	sc:SetMaxDist( 128 )
	sc:SetRes( 800, 450 )
	sc:SetCull( true )
	sc:SetFade( 500, 600 )
	sc:EnableInput( true )
	sc:TrapMouseButtons( true )
	sc:SetParent( self )
	local function action( act )

		logger.debug(  "Act: " .. ( netTrans[act] or tostring(act) ), "DealOrStand" )

		net.Start( "dos_net" )
			net.WriteEntity( self )
			net.WriteInt( act, 4 )
		net.SendToServer()

	end
	sc:SetDrawFunc( function( scr, w, h )

		local mx, my, visible = sc:GetMouse()
		local mouseDown = input.IsMouseDown( MOUSE_LEFT ) or LocalPlayer():KeyDown( IN_USE )

		local function mouseon( x, y, w, h )

			if !visible then return false end
			local x2, y2 = x + w, y + h
			return mx > x and mx < x2 and my > y and my < y2

		end
		local function outbox( corner, x, y, wide, high, col, thick, bcol )
			draw.RoundedBox( corner, x, y, wide, high, bcol or Color( 0, 0, 0 ) )
			draw.RoundedBox( corner, x + thick, y + thick, wide - thick * 2, high - thick * 2, col )
		end
		local function outlinetext( text, font, x, y, col, ax, ay, thick, bcol )

			for x2 = x - thick, x + thick do
				for y2 = y - thick, y + thick do
					if x2 == x and y2 == y then continue end
					draw.DrawText( text, font, x2, y2, bcol or Color( 0, 0, 0 ), ax, ay )
				end
			end
			draw.DrawText( text, font, x, y, col, ax, ay )

		end
		local OnButton = false
		local function button( x, y, w, h, col, tcol, text, font, corner, bcol, bsize, func )

			local isOn = mouseon( x, y, w, h )
			if isOn then
				sc.PressedButton = func
				OnButton = true
			end
			if isOn and !mouseDown then
				col.r = col.r * 0.7
				col.g = col.g * 0.7
				col.b = col.b * 0.7
			elseif isOn and mouseDown then
				col.r = col.r * 0.9
				col.g = col.g * 0.9
				col.b = col.b * 0.9
			end
			outbox( corner or 0, x, y, w, h, col, bsize or 0, bcol or Color( 0, 0, 0 ) )
			if text then
				surface.SetFont( font or "default" )
				local w2, h2 = surface.GetTextSize( text, font or "default" )
				draw.DrawText( text, font or "default", x + w / 2, y + h / 2 - h2 / 2, tcol or Color( 255, 255, 255 ), a_c )
			end
		end

		// start code here

		local state = self:GetState()
		local round = self:GetRound()
		local picked = self:GetPickedNumber()
		local prize = self:GetPrize()

		local BGCol = Color( 72, 60, 50 )
		if state == self.States.CONTINUE then
			BGCol = Color( 0, 100, 0 )
		elseif state == self.States.END then
			BGCol = Color( 100, 0, 0 )
		elseif state == self.States.INSERT then
			local percent = math.Clamp( math.TimeFraction( self:GetTimeout() - 20, self:GetTimeout(), CurTime() ), 0, 1 )
			if percent < 0.5 then
				BGCol = Color( percent * 2 * 255, 255, 0 )
			else
				BGCol = Color( 255, ( 1 - ( percent - 0.5 ) / 0.5 ) * 255, 0 )
			end
			BGCol.r = BGCol.r * 0.5
			BGCol.g = BGCol.g * 0.5
		elseif state == self.States.TICKETS then
			BGCol = Color( 210, 150, 0 )
		end
		outbox( 0, 0, 0, w, h, BGCol, 8, Color( BGCol.r * 2, BGCol.g * 2, BGCol.b * 2 ) )
		draw.SimpleTextOutlined( "Deal or Stand", "dos_1", w / 2, -10, Color( 255, 255, 255 ), a_c, nil, 4, Color( 0, 0, 0 ) )
		if self:GetTimeout() > CurTime() and state != self.States.INSERT then

			draw.SimpleTextOutlined( math.abs( math.Clamp( math.ceil( self:GetTimeout() - CurTime() ), 0, 20 ) ), "dos_4", 24, 8, Color( 255, 255, 255 ), a_c, nil, 2, Color( 0, 0, 0 ) )

		end

		if state == self.States.IDLE then
		elseif state == self.States.PICK then

			local chance = math.Round( self:CalculateChance() * 1000 ) / 10
			button( w / 2 - 64, h - 230, 128, 128, Color( 100, 0, 0 ), Color( 255, 0, 0 ), "PUSH TO\nSTOP", "dos_4", 16, Color( 255, 0, 0 ), 8, function()
				action( self.Net.STOP )
			end )
			draw.SimpleTextOutlined( math.random( self:GetChances() ), "dos_1", w / 2, 90, Color( 255, 255, 255 ), a_c, nil, 8, Color( 0, 0, 0 ) )

			draw.DrawText( "You have a", "dos_4", 20, 95, Color( 255, 255, 255 ) )
			draw.SimpleTextOutlined( chance .. "%", "dos_2", 20, 110, Color( 255, 255, 255 ), nil, nil, 4, Color( 0, 0, 0 ) )
			draw.DrawText( "chance of winning", "dos_4", 20, 190, Color( 255, 255, 255 ) )

			draw.DrawText( "The odds are", "dos_4", w - 20, 95, Color( 255, 255, 255 ), a_r )
			local a, b = self:GetChances()
			draw.SimpleTextOutlined( a .. " in " .. b, "dos_2", w - 20, 110, Color( 255, 255, 255 ), a_r, nil, 4, Color( 0, 0, 0 ) )
			draw.SimpleTextOutlined( "Round " .. round, "dos_2", w / 2, h - 110, Color( 255, 255, 255 ), a_c, nil, 4, Color( 0, 0, 0 ) )

		elseif state == self.States.CONTINUE then

			outlinetext( self:GetPickedNumber(), "dos_1", w / 2, 90, Color( 0, math.sin( RealTime() * 16 ) * 50 + 205, 0 ), a_c, nil, 8, Color( 0, 0, 0 ) )

			draw.DrawText( [[Great job!
Would you like to keep going and try to win ]] .. string.Comma( self:GetPrize() * 2 ) .. [[ tickets?
Or do you want to stand with the ]] .. string.Comma( self:GetPrize() ) .. [[ tickets and stop?
To continue, you must insert 2 credits]], "dos_4", w / 2, 200, Color( 255, 255, 255 ), a_c )

			local deal = Color( 0, 50, 0 )
			if sc.DealPush and ( RealTime() - sc.DealPush ) % 0.065 < 0.0325 then
				deal = Color( 0, 125 + math.sin( RealTime() * math.pi / 2 * 0.065 ) * 25, 0 )
			end
			local stand = Color( 50, 0, 0 )
			if sc.StandPush and ( RealTime() - sc.StandPush ) % 0.065 < 0.0325 then
				stand = Color( 125 + math.sin( RealTime() * math.pi / 2 * 0.065 ) * 25, 0, 0 )
			end
			if sc.DealPush and RealTime() > sc.DealPush + 1 then
				sc.DealPush = nil
			end
			if sc.StandPush and RealTime() > sc.StandPush + 1 then
				sc.StandPush = nil
			end
			if sc.DealPush or sc.StandPush then visible = false end

			button( w / 2 - 350, h - 120, 300, 100, deal, Color( 255, 255, 255 ), "DEAL", "dos_2", 8, Color( 0, 255, 0 ), 8, function()
				sc.DealPush = RealTime()
				action( self.Net.DEAL )
			end )
			button( w / 2 + 350 - 300, h - 120, 300, 100, stand, Color( 255, 255, 255 ), "STAND", "dos_2", 8, Color( 255, 0, 0 ), 8, function()
				sc.StandPush = RealTime()
				action( self.Net.STAND )
			end )
			draw.DrawText( "Try for", "dos_4", 48, 100, Color( 255, 255, 255 ) )
			draw.SimpleTextOutlined( string.Comma( self:GetPrize() * 2 ) .. " tickets", "dos_3", 48, 125, Color( 255, 255, 255 ), nil, nil, 2, Color( 0, 0, 0 ) )
			
			draw.DrawText( "Keep the", "dos_4", w - 48, 100, Color( 255, 255, 255 ), a_r )
			draw.SimpleTextOutlined( string.Comma( self:GetPrize() ) .. " tickets", "dos_3", w - 48, 125, Color( 255, 255, 255 ), a_r, nil, 2, Color( 0, 0, 0 ) )

			//draw.DrawText( "Take the", "dos_4", w / 2 - 350 + 150, h - 140 + 10, Color( 255, 255, 255 ), a_c )
			//draw.DrawText( "and try for " .. string.Comma( self:GetPrize() * 2 ) .. " tickets", "dos_5", w / 2 - 350 + 150, h - 140 + 128 - 35, Color( 255, 255, 255 ), a_c )
			//draw.DrawText( "and win " .. string.Comma( self:GetPrize() ) .. " tickets", "dos_5", w / 2 + 350 - 150, h - 140 + 128 - 35, Color( 255, 255, 255 ), a_c )

		elseif state == self.States.INSERT then

			outlinetext(  math.abs( math.Clamp( math.ceil( self:GetTimeout() - CurTime() ), 0, 20 ) ), "dos_2", w / 2, 95, Color( 255, 255, 255 ), a_c, nil, 4, Color( 0, 0, 0 ) )
			draw.DrawText( "Insert credits to continue.\n" .. self:GetCredits() .. " / " .. self:GetCost() .. " inserted.", "dos_3", w / 2, 200, Color( 255, 255, 255 ), a_c )

			if self:GetCredits() >= self:GetCost() and RealTime() % 1 < 0.5 then

				draw.DrawText( "PRESS START!", "dos_3", w / 2, h - 100, Color( 255, 255, 255 ), a_c )

			end


		elseif state == self.States.END then

			if self:GetPickedNumber() > 0 then

				outlinetext( self:GetPickedNumber(), "dos_1", w / 2, 90, Color( math.sin( RealTime() * 16 ) * 50 + 205, 0, 0 ), a_c, nil, 8, Color( 0, 0, 0 ) )

			end
			draw.SimpleTextOutlined( "Game Over!", "dos_3", w / 2, 210, Color( 255, 255, 255 ), a_c, nil, 2, Color( 0, 0, 0 ) )
			local reason = self.LoseReasonsStrings[self:GetLoseReason()]
			draw.DrawText( reason, "dos_4", w / 2, 280, Color( 255, 255, 255 ), a_c )
			draw.SimpleTextOutlined( "Better luck next time!", "dos_3", w / 2, 320, Color( 255, 255, 255 ), a_c, nil, 2, Color( 0, 0, 0 ) )

		elseif state == self.States.TICKETS then

			draw.SimpleTextOutlined( "Thanks for playing!", "dos_3", w / 2, 105, Color( 255, 255, 255 ), a_c, nil, 2, Color( 0, 0, 0 ) )
			if self:GetTickets() != -1 then

				draw.DrawText( "You won", "dos_4", w / 2, 95 + 84, Color( 255, 255, 255 ), a_c )
				local font = "dos_2"
				local text = string.Comma( self:GetTickets() ) .. " ticket" .. ( self:GetTickets() == 1 and "" or "s" ) .. "!"
				surface.SetFont( font )
				local tw, th = surface.GetTextSize( text )
				if tw > w - 16 then
					font = "dos_3"
				end
				draw.SimpleTextOutlined( text, font, w / 2, 95 + 84 + 50, Color( 0, 255, 0 ), a_c, nil, 4, Color( 0, 0, 0 ) )

			end

		end

		// end code here

		if !OnButton then
			sc.PressedButton = nil
		end

		local cursorSize = 64
		if mouseDown then

			cursorSize = cursorSize * 0.90625

		end

		local offset = cursorSize / 2

		mx, my = mx - offset + 11 * ( cursorSize / 64 ), my - offset + 16 * ( cursorSize / 64 )

		if visible then
			surface.SetDrawColor( 255, 255, 255 )
			surface.SetTexture( Cursor2D )

			surface.DrawTexturedRect( mx, my, cursorSize, cursorSize )
		end

	end )
	function sc:OnMousePressed( id )
		if self.PressedButton and id == 1 then
			self.PressedButton()
		end
	end
	sc:AddToScene( true )
	self.GameScreen = sc

end
function ENT:GetChances()

	return 5, 9 + self:GetRound()

end
function ENT:CalculateChance()

	return 5 / ( 9 + self:GetRound() )

end
function ENT:IsWinningNumber()

	return self:GetPickedNumber() <= 5

end