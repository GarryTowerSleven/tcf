include("shared.lua")

local color_black = Color( 0, 0, 0 )

ENT.Screen = nil

ENT.Choice = nil

ENT.Cursor = {
    x = nil,
    y = nil,
    hit = nil,
}

ENT.CursorCollisions = {}

ENT.ColorBlue = colorutil.Brighten( Color( 50, 125, 240 ), 1 )

ENT.ColorMain = nil
ENT.ColorCorrect = Color( 50, 240, 95)
ENT.ColorInCorrect = Color( 240, 50, 50)
ENT.ColorBorder = color_white

ENT.ColorBackground = colorutil.Brighten( ENT.ColorBlue, .5 )
ENT.ColorBackgroundWaiting = colorutil.Alpha( color_black, 70 )

ENT.Margin = 10

surface.CreateFont( "TriviaName", {
    font = "Oswald",
    size = 150,
    weight = 400,
} )

surface.CreateFont( "TriviaSmall", {
    font = "Oswald",
    size = 30,
    weight = 400,
} )

surface.CreateFont( "TriviaHeader", {
    font = "Oswald",
    size = 100,
    weight = 800,
} )

surface.CreateFont( "TriviaLetter", {
    font = "Oswald",
    size = 90,
    weight = 400,
} )

surface.CreateFont( "TriviaStatTitle", {
    font = "Oswald",
    size = 38,
    weight = 400,
} )

surface.CreateFont( "TriviaQuestion", {
    font = "Oswald",
    size = 33,
    weight = 400,
} )

surface.CreateFont( "TriviaStatValue", {
    font = "Oswald",
    size = 75,
    weight = 800,
} )

function ENT:SetCollision( name, x, y, w, h, func )
    if ( self.CursorCollisions[name] ) then return end

    self.CursorCollisions[name] = {
        x = x,
        y = y,
        w = w,
        h = h,

        func = func,
    }
end

function ENT:ResetCollisions()
    self.CursorCollisions = {}
end

function ENT:MyPodium()
    return self == LocalPlayer():GetNet( "TriviaPodium" )
end

function ENT:DoMouse( scr, x, y )
    if ( not self:MyPodium() ) then return end

    self.Cursor.x, self.Cursor.y, _ = scr:GetMouse()
    self.Cursor.hit = self:CheckCollision( self.Cursor.x, self.Cursor.y )
end

function ENT:CheckCollision( x, y )
    for name, tbl in pairs( self.CursorCollisions ) do
        if ( x >= tbl.x and x <= tbl.x + tbl.w and y >= tbl.y and y <= tbl.y + tbl.h ) then
            return name
        end
    end

    return nil
end

function ENT:DrawButton( x, y, w, h, ident, str, id )
    local hovered = self.Cursor.hit == ident
    local alpha = hovered and 200 or 50

    local correct = self.Controller:GetCorrect()
    local choice = self:GetChoice() > 0 and self:GetChoice() or self.Choice
    if ( choice and choice > 0 ) then
        alpha = (choice == id or correct == id) and 200 or 20 
    end

    if ( self.Controller:GetState() == trivia.STATE_PLAY ) then
        if ( not self:MyPodium() and self:GetAnswered() ) then
            alpha = 20
        end
    end

    local color = colorutil.Alpha( self.ColorMain, alpha )

    if ( self.Controller:GetState() == trivia.STATE_INTERMISSION ) then
        if ( id == correct ) then
            color = colorutil.Alpha( self.ColorCorrect, alpha )
        end
    end

    surface.SetDrawColor( color )
    surface.DrawRect( x, y, w, h )
    draw.GradientBox( x, y, w, h, colorutil.Alpha( color_black, 128 ), DOWN )
    
    surface.SetDrawColor( color )
    surface.DrawOutlinedRect( x, y, w, h, self.Margin )

    local text_alpha = alpha > 20 and 200 or alpha //(self.Controller:GetState() == trivia.STATE_PLAY) and ((choice and choice > 0) and alpha or 200) or alpha
    local font = ( ident == "btn_true" or ident == "btn_false" ) and "TriviaLetter" or "TriviaStatTitle"

    local shadow = alpha > 20 and 2 or 0

    draw.WordWrapped( self.Controller:GetQuestionChoice( id ), font, x + (w*.5), y + (h*.5), w*.85, colorutil.Alpha( color_white, text_alpha ), shadow )

    self:SetCollision( ident, x, y, w, h, function() self:MakeChoice( id ) end )
end

function ENT:DrawStat( x, y, w, h, title, value )
    local color = colorutil.Alpha( self.ColorMain, 75 )

    surface.SetDrawColor( color )
    surface.DrawRect( x, y, w, h )

    local headH = w * .185
    draw.Rectangle( x, y, w, headH, color )
    draw.Rectangle( x, y + headH, self.Margin, math.ceil( h - headH - self.Margin ), color )
    draw.Rectangle( x + w - self.Margin, y + headH, self.Margin, math.ceil( h - headH - self.Margin ), color )
    draw.Rectangle( x, y + h - self.Margin, w, self.Margin, color )

    local tX, tY = x + (w*.5), y + (headH*.5)
    draw.SimpleText( title, "TriviaStatTitle", tX + 2, tY + 2, colorutil.Alpha( color_black, 150 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    draw.SimpleText( title, "TriviaStatTitle", tX, tY, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    
    tX, tY = x + (w*.5), y + headH + ((h-headH)*.5) - self.Margin
    draw.SimpleText( value, "TriviaStatValue", tX + 2, tY + 2, colorutil.Alpha( color_black, 150 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    draw.SimpleText( value, "TriviaStatValue", tX, tY, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

    //surface.DrawOutlinedRect( x, y, w, h, self.Margin )
end

function ENT:DrawGame( w, h )
    local controller = self.Controller
    local ply = Entity(1) //self:GetPlayer()

    self.ColorMain = controller:GetState() == trivia.STATE_INTERMISSION and (self:GetCorrect() and self.ColorCorrect or self.ColorInCorrect) or self.ColorBlue

    self:DrawBackground( w, h, colorutil.Alpha( color_black, 70 ) )

    local x, y = self.Margin, self.Margin
    w, h = w - ( self.Margin * 2 ), h - ( self.Margin * 2 )

    local margin = self.Margin

    // header
    local header_height = h*.25

        // name
    local leftW = w*.75
    surface.SetDrawColor( colorutil.Alpha( self.ColorMain, 75 ) )
    surface.DrawRect( x, y, w, header_height )
    surface.DrawOutlinedRect( x, y, w, header_height, margin )

    if ( controller:GetState() == trivia.STATE_PLAY ) then
        self:DrawTimer( x + margin, y + margin, w - (margin*2), header_height - (margin*2), colorutil.Alpha( color_black, 120 ) )
    end

    surface.SetTextColor( colorutil.Alpha( color_white, 250 ) )
    draw.WordWrapped( self.Controller:GetQuestionString(), "TriviaQuestion", x + (w*.5), y + (header_height*.5), w*.85, color_white, 2 )

        // points
    //surface.SetDrawColor( colorutil.Alpha( self.ColorMain, 75 ) )
    //surface.DrawRect( x + leftW, y, w - leftW, header_height )
    //surface.DrawOutlinedRect( x + leftW, y, w - leftW, header_height, margin )

    //surface.SetTextColor( colorutil.Alpha( color_white, 175 ) )
    //draw.TextInBox( string.FormatNumber(self:GetPoints()), "TriviaHeader", x + leftW, y, w - leftW, header_height )

    // buttons
    local btnX, btnY = x, y + header_height + margin
    local btnW, btnH = leftW - margin, h - header_height - margin

    local btnIW, btnIH = btnW*.5 - (margin*.5), btnH*.5 - (margin*.5)

    if ( controller.ClientNetwork.question.choices ) then
        if ( table.Count( controller.ClientNetwork.question.choices ) == 2 ) then
            self:DrawButton( btnX, btnY, btnIW, btnH, "btn_true", "True", 1 )
            self:DrawButton( btnX + btnIW + margin, btnY, btnIW, btnH, "btn_false", "False", 2 )
        else
            self:DrawButton( btnX, btnY, btnIW, btnIH, "btn_1", "A", 1 )
            self:DrawButton( btnX + btnIW + margin, btnY, btnIW, btnIH, "btn_2", "B", 2 )
            self:DrawButton( btnX, btnY + btnIH + margin, btnIW, btnIH, "btn_3", "C", 3 )
            self:DrawButton( btnX + btnIW + margin, btnY + btnIH + margin, btnIW, btnIH, "btn_4", "D", 4 )
        end
    end

    // stats
    local statX, statY = btnW + (margin*2), btnY
    local statW, statH = w - leftW, btnH

    local statIH = ((statH - (margin*2)) / 3)

    local incorrect = math.Clamp( (controller:GetQuestion() - 1 + ((controller:GetState() == trivia.STATE_END or controller:GetState() == trivia.STATE_INTERMISSION) and 1 or 0)) - self:GetNumCorrect(), 0, self.Controller.QuestionCount )

    self:DrawStat( statX, statY, statW, statIH, "Points", string.FormatNumber( self:GetPoints() ) or 0 )
    self:DrawStat( statX, statY + statIH + margin, statW, statIH, "Correct", self:GetNumCorrect() or 0 )
    self:DrawStat( statX, statY + (statIH*2) + (margin*2) - 1 /* lol */, statW, statIH, "Incorrect", incorrect or 0 )
end

function ENT:DrawTimer( x, y, w, h, color )
    local timeLeft = self.Controller:TimeLeft( true )

    draw.Rectangle( x, y, w * timeLeft, h, color )

    return timeLeft
end

function ENT:DrawWaiting( w, h )
    local font = "TriviaHeader"
    local font2 = "TriviaStatTitle"

    local ply = self:GetPlayer()
    local isValid = IsValid( ply )

    local color = isValid and colorutil.Alpha( self.ColorBackground, 200 ) or self.ColorBackgroundWaiting
    self:DrawBackground( w, h, color )

    if ( self.Controller:GetError() ) then
        draw.SimpleText( "Out of Order", font, w*.5, h*.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        return
    end

    if ( self.Controller:GetState() != trivia.STATE_IDLE ) then
        local color_timer = colorutil.Alpha( color_black, 100 )
        local t = self:DrawTimer( self.Margin, self.Margin, w - (self.Margin*2), h - (self.Margin*2), colorutil.Alpha( color_timer, 100 ) )
    
        if ( t <= 0 ) then
            draw.Rectangle( 0, 0, w, h, color_timer )
        end
    end

    if ( isValid ) then

        local name = ply:GetName()

        draw.TextInBox( name, "TriviaName", (w * .25) * .5, 0, w * .75, h )
        draw.SimpleText( "[Use] again to leave.", "TriviaSmall", w*.5, h - 30, colorutil.Alpha( color_white, 30 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
        
        local playersNeeded = self.Controller:PlayersNeeded()
        local time = math.floor( self.Controller:TimeLeft() )
        local str = self.Controller:GetState() == trivia.STATE_WAITING and "Starting in " .. time .. " " .. string.Pluralize( "second", time ) or playersNeeded .. " more " .. string.Pluralize( "player", playersNeeded ) .. " needed"
        
        draw.SimpleText( str, "TriviaSmall", w*.5, (h * .75), colorutil.Alpha( color_white, 30 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
    
    else
        local str = self.Controller:GetState() == trivia.STATE_WAITING and "Starting Soon!" or "Waiting for players..."
        local str2 = "[Use] to join!"

        local margin = 100

        local x, y = w*.5, h*.5

        surface.SetTextColor( color_white )

        surface.SetFont( font )
        local tTopW, tTopH = surface.GetTextSize( str )

        surface.SetFont( font2 )
        local tBotW, tBotH = surface.GetTextSize( str2 )

        surface.SetFont( font )
        surface.SetTextPos( x - tTopW*.5, (y - tTopH*.5) - margin*.5 )
        surface.DrawText( str )

        surface.SetFont( font2 )
        surface.SetTextPos( x - tBotW*.5, (y - (tBotH*.5) + margin) - margin*.5 )
        surface.DrawText( str2 )
    end

    local border_color = isValid and colorutil.Brighten( self.ColorBackground, 1.25 ) or colorutil.Alpha( color_white, 150 )
    draw.RectBorder( 0, 0, w, h, self.Margin, border_color )
end

function ENT:DrawEnd( w, h )
    self:DrawBackground( w, h )

    draw.SimpleText( "Thanks for playing!", "TriviaHeader", w*.5, h*.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

    draw.RectBorder( 0, 0, w, h, self.Margin, colorutil.Alpha( color_white, 150 ) )
end

function ENT:DrawLoading( w, h )
    self:DrawBackground( w, h, colorutil.Alpha( color_black, 180 ) )

    draw.SimpleText( "Loading...", "TriviaHeader", w*.5, h*.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

function ENT:DrawBackground( w, h, color )
    draw.Rectangle( 0, 0, w, h, color or colorutil.Alpha( color_black, 100 ) )
    draw.GradientBox( 0, 0, w, h, colorutil.Alpha( color_black, 150 ), DOWN )
end

function ENT:DrawScreen( scr, w, h )
    local controller = self.Controller
    if ( IsValid( controller ) ) then
        local state = controller:GetState()
        local pregame = state == trivia.STATE_IDLE or state == trivia.STATE_WAITING
        local ingame = state == trivia.STATE_PLAY or state == trivia.STATE_INTERMISSION
        local endgame = state == trivia.STATE_END
        local ply = self:GetPlayer()

        if ( pregame ) then
            self:DrawWaiting( w, h )
        end

        if ( IsValid( ply ) ) then
            if ( controller:GetLoading() ) then
                self:DrawLoading( w, h )
            end

            if ( ingame ) then
                self:DrawGame( w, h )
            elseif ( endgame ) then 
                self:DrawEnd( w, h )
            end
        elseif ( not IsValid( ply ) and not pregame ) then
            self:DrawBackground( w, h )
            draw.SimpleText( "Game Active", "TriviaHeader", w*.5, h*.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            draw.RectBorder( 0, 0, w, h, self.Margin, colorutil.Alpha( color_black, 80 ) )
        end
    end

    // draw.SimpleText( self.Cursor.x, nil, 20, 20, color_white )
    // draw.SimpleText( self.Cursor.y, nil, 20, 30, color_white )
    // draw.SimpleText( self.Cursor.hit, nil, 20, 40, color_white )
end

function ENT:DoClick()
    if ( self.Controller:GetState() == trivia.STATE_WAITING or self.Controller:GetState() == trivia.STATE_IDLE ) then
        self:RequestJoin()
        return
    end

    local hit_tbl = self.CursorCollisions[ self.Cursor.hit ]

    if ( hit_tbl and hit_tbl.func ) then
        hit_tbl.func()
    end
end

function ENT:SetupScreen()
    local sc = screen.New()

    local pos = self:GetPos()

    pos = pos + (self:GetUp() * 42.5)
    pos = pos + (self:GetForward() * -6.5)

    local angles = self:GetAngles()

    angles:RotateAroundAxis( self:GetRight(), 90 )

    local resW, resH = 108, 63
    local scale = 0.125

    sc:SetPos( pos )
	sc:SetAngles( angles )

	sc:SetSize( resW, resH )
	sc:SetRes( resW / scale, resH / scale )

	sc:SetCull( true )
	sc:SetFade( 700, 1024 )

	sc:EnableInput( true )
	sc:TrapMouseButtons( true )
	sc:SetMaxDist( 70 )

	sc:SetParent( self )

    sc:SetDrawFunc(
		function( scr, w, h )
            self:DrawScreen( scr, w, h )
        end
    )

    sc:AddToScene( true )

    sc.OnMousePressed = function( scr, id )
        if ( id != 1 ) then return end // no right click

        self:DoClick()
    end

    sc.OnMouseMoved = function( scr, x, y, ox, oy )
        self:DoMouse( scr, x, y )
    end

    sc.OnFocusState = function( src, state )
        if ( not state ) then
            self.Cursor.x = nil
            self.Cursor.y = nil
            self.Cursor.hit = false
        end
    end

    self.Screen = sc
end

function ENT:Initialize()
    self.ColorMain = self.ColorMain or self.ColorBlue

    self:SetupScreen()

    // add to base
    if ( self:GetController() ) then
        table.insert( self:GetController().Podiums, self )
    end
end

function ENT:RequestJoin()
    net.Start( "trivia.Join" )
        net.WriteEntity( self )
    net.SendToServer()
end

function ENT:RequestLeave()
    net.Start( "trivia.Leave" )
    net.SendToServer()
end

concommand.Add( "trivia_leave", function()
    net.Start( "trivia.Leave" )
    net.SendToServer()
end )

function ENT:MakeChoice( choice )
    if ( self.Choice or self.Controller:GetState() != trivia.STATE_PLAY ) then return end

    net.Start( "trivia.Choice" )
        net.WriteUInt( choice, 3 )
    net.SendToServer()
end

net.Receive( "trivia.Choice", function( len, ply )
    local ent = net.ReadEntity()
    ent.Choice = net.ReadUInt( 3 )
end )