module( "arcade", package.seeall )
GMCPerCredit = 2

local TicketSuffix = "Ticket"
Suffix = {
	Ticket = TicketSuffix,
}
if SERVER then resource.AddFile( "materials/gmodtower/lobby/arcade/logo.png" ) end
//Database = {} for saving, which i failed at
local function dprint( ... )
	// print( ... )
end
local PLY = FindMetaTable( "Player" )
function PLY:GetTickets()
	return self:GetNWFloat( "ArcadeTickets" )
end
if SERVER then
	function PLY:SetTickets( x  )
		self:SetNWFloat( "ArcadeTickets", x )
	end
end
function PLY:CanAffordTickets( x )
	return self:GetTickets() >= x
end
function PLY:CanAffordCredits( x )
	return self:Money() / GMCPerCredit >= x
end
function PLY:GiveTickets( x )
	self:SetTickets( math.Clamp( self:GetTickets() + x, 0, 2 ^ 31 - 1 ) )
	if x < 0 then
		self:MsgT( "ArcadeLoseTickets", string.Comma( x ), x != -1 and "s" or "" )
	elseif x > 0 then
		self:MsgT( "ArcadeGetTickets", string.Comma( x ), x != 1 and "s" or "" )
	end
	return self:GetTickets()
end
function PLY:TakeCredits( x )
	self:GiveMoney( -x * GMCPerCredit )
end
function Currency( tickets )

	// converts 1234 to "1,234 TICKETS" and 1 to "1 TICKET"
	tickets = string.Comma( tickets ) .. " " .. TicketSuffix
	return tickets == "1" and tickets or tickets .. "s"

end
function SetupArcadeGame( ent, name, cost, pos, ang ) // call this in SetupDataTables and before any NetworkVar calls

	// this function creates the functions on the entity needed to work properly
	/*
		args:
			entity ent
			string name of arcade game
			float cost to play in credits
			vector pos offset from ent for screen
			angle ang offset from ent for screen
	*/

	if ent.OldNetworkVar then ent.NetworkVar = ent.OldNetworkVar end // just in case we're being set up multiple times

	ent:NetworkVar( "Bool", 0, "InGame" )
	ent:NetworkVar( "Bool", 1, "InResume" ) // when true, you will be able to insert credits while the game is going. useful for 'insert credits to continue'
	ent:NetworkVar( "Float", 0, "Tickets" )
	ent:NetworkVar( "Float", 1, "Credits" )
	ent:NetworkVar( "Float", 2, "Cost" )
	ent:NetworkVar( "Entity", 0, "Player" )
	ent:SetCost( cost or 2 )
	ent:SetTickets( -1 )

	if !isfunction( ent.OnGameStart ) then
		function ent:OnGameStart( ply ) logger.error( string.format("OnGameStart not present! (%s)", ent:GetClass()), "Arcade" ) end
	end
	if !isfunction( ent.OnGameResume ) then
		function ent:OnGameResume() logger.error( string.format("OnGameResume not present! (%s)", ent:GetClass()), "Arcade" ) end
	end
	if !isfunction( ent.OnCreditInsert ) then
		function ent:OnCreditInsert() logger.error( string.format("OnCreditInsert not present! (%s)", ent:GetClass()), "Arcade" ) end
	end
	if !isfunction( ent.OnGameEnd ) then
		function ent:OnGameEnd() logger.error( string.format("OnGameEnd not present! (%s)", ent:GetClass()), "Arcade" ) end
	end
	function ent:GiveTickets( amount )

		if !self:GetInGame() or self:GetTickets() > 0 or !IsValid( self:GetPlayer() ) then return end
		self:GetPlayer():GiveTickets( amount )
		self:SetTickets( 0 )
		local ind = self:EntIndex()
		local delay = 0.01
		local add = math.ceil( amount / 1000 * 5 )
		dprint( "delay", delay )
		dprint( "add", add )
		timer.Create( "TicketSpew_" .. ind, delay, amount + 1, function()
			if !IsValid( self ) then timer.Destroy( "TicketSpew_" .. ind ) return end
			if self:GetTickets() < amount then
				local pitch = Lerp( self:GetTickets() / amount, 70, 255 )
				self:EmitSound( "gmodtower/ui/panel_back.wav", 100, pitch )

				if self:GetTickets() + add > amount then
					self:SetTickets( amount )
				else
					self:SetTickets( self:GetTickets() + add )
				end
			else
				timer.Destroy( "TicketSpew_" .. ind ) // make sure we stopped
				timer.Simple( 5, function()

					if IsValid( self ) then

						self:SetPlayer( nil )
						self:SetTickets( -1 )
						self:SetInGame( false )
						self:OnGameEnd()

					end

				end )
			end
		end )

	end

	ent.OldNetworkVar = ent.NetworkVar
	function ent:NetworkVar( type, ind, name ) // overwrite the function so i don't have to remember to start at 3 for a float

		if type == "Bool" then ind = ind + 2
		elseif type == "Float" then ind = ind + 3
		elseif type == "Entity" then ind = ind + 1
		end

		self:OldNetworkVar( type, ind, name )

	end

	local sc = screen.New()
	sc:SetPos( ent:LocalToWorld( pos ) )
	sc:SetAngles( ent:LocalToWorldAngles( ang ) )
	sc:SetSize( 8, 8 )
	sc:SetRes( 240, 240 )
	sc:SetMaxDist( 128 )
	sc:SetCull( true )
	sc:SetFade( 200, 300 )
	sc:EnableInput( true )
	sc:TrapMouseButtons( true )
	sc:SetFacadeColor( Color( 50, 100, 200 ) )
	sc:SetParent( ent )
	sc:SetDrawFunc(
		function( scr, w, h )

			if !IsValid( ent ) then

				sc:RemoveFromScene()
				return

			end

			local mx, my, visible = sc:GetMouse()
			local mouseDown = input.IsMouseDown( MOUSE_LEFT ) or LocalPlayer():KeyDown( IN_USE )
			// Main drawing here

			local Sufficient = ent:GetCredits() >= ent:GetCost()

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

			outbox( 8, 0, 0, w, h, Color( 50, 100, 200 ), 6 )

			outlinetext( name, "arcade_1", w / 2, 6, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, nil, 2, Color( 0, 0, 0 ) )

			local BGCol = Sufficient and Color( 0, 50, 0 ) or Color( 50, 0, 0 )
			local FGCol = Sufficient and Color( 0, 255, 0 ) or Color( 255, 0, 0 )
			local TCol = Sufficient and Color( 150, 255, 150 ) or Color( 255, 150, 150 )
			outbox( 0, 16, 48, w / 2 - 32, 19 * 2, BGCol, 4 )
			draw.DrawText( ent:GetCredits(), "arcade_1", 16 + ( w / 2 - 32 ) / 2, 26 * 2, FGCol, TEXT_ALIGN_CENTER )

			outbox( 0, w - 16 - ( w / 2 - 32 ), 48, w / 2 - 32, 19 * 2, BGCol, 4 )
			draw.DrawText( ent:GetCost(), "arcade_1", w - 16 - ( w / 2 - 32 ) / 2, 26 * 2, FGCol, TEXT_ALIGN_CENTER )

			draw.DrawText( "/", "arcade_large", w / 2, 24 * 2 - 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER )

			outlinetext( "CREDITS", "arcade_large", w / 2, 24 * 2 + 22 * 2, TCol, TEXT_ALIGN_CENTER, nil, 2, Color( 0, 0, 0 ) )
			if ent:GetInResume() and IsValid( ent:GetPlayer() ) then

				outlinetext( ent:GetPlayer():Name() .. " is playing", "arcade_3", w / 2, 24 * 2 + 75, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, nil, 2, Color( 0, 0, 0 ) )

			end


			local function mouseon( x, y, w, h )

				local x2, y2 = x + w, y + h
				return mx > x and mx < x2 and my > y and my < y2

			end

			local OnButton = false
			local function button( x, y, w, h, col, tcol, text, corner, bcol, bsize, func )

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
					surface.SetFont( "arcade_2" )
					local w2, h2 = surface.GetTextSize( text, "arcade_2" )
					draw.DrawText( text, "arcade_2", x + w / 2 - w2 / 2, y + h / 2 - h2 / 2, tcol or Color( 255, 255, 255 ) )
				end
			end

			if !ent:GetInGame() or ent:GetInResume() then

				button(
					8 * 2,
					74 * 2,
					w / 2.5,
					60,
					Color( 0, 150, 0 ),
					nil,
					"INSERT\nCREDIT",
					0,
					nil,
					4,
					function()
						logger.debug( "Action: false", "Arcade" )
						net.Start( "arcade_action" )
							net.WriteEntity( ent )
							net.WriteBit( false )
						net.SendToServer()
					end
				)
				button(
					w - 16 - w / 2.5,
					74 * 2,
					w / 2.5,
					60,
					Sufficient and Color( 0, math.sin( RealTime() * 10 ) * 70 + 110, 0 ) or Color( 50, 0, 0 ),
					Sufficient and Color( 255, 255, 255 ) or Color( 255, 0, 0 ),
					"START\nGAME",
					nil,
					nil,
					4,
					function()
						logger.debug( "Action: true", "Arcade" )
						net.Start( "arcade_action" )
							net.WriteEntity( ent )
							net.WriteBit( true )
						net.SendToServer()
					end
				)
				// the fine print
				draw.DrawText( "1 credit = " .. GMCPerCredit .. " GMC", "arcade_3", w / 2, h - 30, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER )

			else

				if ent:GetTickets() == -1 then

					outbox( 0, 16, 74 * 2, w - 32, 70, Color( 0, 150, 0 ), 4 )
					draw.DrawText( "BEING PLAYED BY\n" .. ( IsValid( ent:GetPlayer() ) and ent:GetPlayer():Name() or "unknown" ), "arcade_2", w / 2, ( 74 + 5 ) * 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER )

				else

					outbox( 0, 16, 74 * 2, w - 32, 70, Color( 210, 150, 0 ), 4 )
					draw.DrawText( "TICKETS WON:", "arcade_2", w / 2, ( 74 + 5 ) * 2, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER )
					draw.DrawText( string.Comma( ent:GetTickets() ), "arcade_large", w / 2, ( 74 + 15 ) * 2, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER )

				end


			end
			if !OnButton then
				sc.PressedButton = nil
			end

			local cursorSize = 32
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

		end
	)
	function sc:OnMousePressed( id )
		if self.PressedButton and id == 1 then
			self.PressedButton()
		end
	end
	sc:AddToScene( true )
	ent.ArcadeScreen = sc
end
if CLIENT then
	local BaseFont = "Franklin Gothic Demi"
	surface.CreateFont( "arcade", {
		font = "DermaLarge",
		size = 36,
		weight = 900
	} )
	surface.CreateFont( "arcade_large", {
		font = BaseFont,
		weight = 900,
		size = 36
	} )
	surface.CreateFont( "arcade_1", {
		font = BaseFont,
		weight = 900,
		size = 30
	} )
	surface.CreateFont( "arcade_2", {
		font = BaseFont,
		weight = 900,
		size = 24,
	} )
	surface.CreateFont( "arcade_3", {
		font = BaseFont,
		weight = 900,
		size = 20,
	} )

	return
end
util.AddNetworkString( "arcade_action" )
net.Receive( "arcade_action", function( len, ply )
	local self = net.ReadEntity()
	local starting = net.ReadBit()

	logger.debug( string.format( "Action Received: %s | %s", self:GetClass(), tostring(starting) ), "Arcade" )

	if !IsValid( self ) then return end
	if self:GetInResume() and ply != self:GetPlayer() then return end
	if starting == 0 then
		if ply:CanAffordCredits( 1 ) then
			ply:TakeCredits( 1 )
			self:SetCredits( self:GetCredits() + 1 )
			self:EmitSound( "ambient/levels/labs/coinslot1.wav", 75, 100 )
		else
			ply:MsgT( "ArcadeNoAfford", GMCPerCredit )
		end
		return
	end
	local creds = self:GetCredits()
	if creds < self:GetCost() then
		ply:SendLua( "surface.PlaySound( 'buttons/button10.wav' )" )
		ply:MsgT( "ArcadeNoCredits" )
		return
	end
	self:SetCredits( self:GetCredits() - self:GetCost() )
	self:EmitSound( "buttons/button3.wav", 100, 100 )
	if self:GetInResume() then
		self:SetInResume( false )
		self:OnGameResume()
	else
		self:OnGameStart( ply )
		self:SetInGame( true )
		self:SetPlayer( ply )
	end
end )
/*
	i had attempted to make a saving system, but i failed to.
	feel free to add yours

if not file.Exists( "gmtower", "DATA" ) then
	file.CreateDir( "gmtower" )
end
if not file.Exists( "gmtower/arcade", "DATA" ) then
	file.CreateDir( "gmtower/arcade" )
end
timer.Destroy( "Arcade" )
timer.Create( "Arcade", 1, 0, function()
	local f=file.Read( "gmtower/arcade/database.txt", "DATA" )
	if f then
		f=util.JSONToTable( f )
		Database=f
	else
		Database={}
		print( "NOTE: could not locate database.txt, writing .. ." )
	end
	for k, ply in pairs( player.GetAll() )do
		local db=Database[ply:SteamID()]
		if db then
			if ply:GetNWFloat( "ArcadeTickets" ) != db.Tickets then
				print( "> set tickets to " .. db.Tickets )
				ply:SetNWFloat( "ArcadeTickets", db.Tickets )
			end
			if ply:GetNWFloat( "ArcadeCredits" ) != db.Credits then
				print( "> set creds to " .. db.Credits )
				ply:SetNWFloat( "ArcadeCredits", db.Credits )
			end
		else
			Database[ply:SteamID()]={
				Credits=0,
				Tickets=0
			}
			ply.ArcadeData=Database[ply:SteamID()]
		end
	end
	file.Write( "gmtower/arcade/database.txt", util.TableToJSON( Database ) )
end )
timer.Start( "Arcade" )
*/
