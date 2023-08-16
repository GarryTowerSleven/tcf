include("shared.lua")

ENT.Podiums = {}
ENT.Screen = nil

ENT.Margin = 20

ENT.ColorMain = colorutil.Brighten( Color( 50, 125, 240 ), 1 )

ENT.ColorCorrect = Color(35, 155, 60)
ENT.ColorInCorrect = Color(165, 0, 0)
ENT.ColorBorder = color_white

surface.CreateFont( "TriviaScreenLarge", {
    font = "Oswald",
    size = 150,
    weight = 800,
} )

surface.CreateFont( "TriviaScreenBig", {
    font = "Oswald",
    size = 115,
    weight = 400,
} )

surface.CreateFont( "TriviaScreenMedium", {
    font = "Oswald",
    size = 100,
    weight = 400,
} )

surface.CreateFont( "TriviaScreenSmall", {
    font = "Oswald",
    size = 75,
    weight = 400,
} )

surface.CreateFont( "TriviaScreenSmaller", {
    font = "Oswald",
    size = 65,
    weight = 400,
} )

function ENT:GetQuestionInfo()
	return self.ClientNetwork.question
end

function ENT:GetQuestionString()
    return self:GetQuestionInfo().str or "Unknown"
end

function ENT:GetQuestionDifficulty()
    return self:GetQuestionInfo().difficulty or "Unknown"
end

function ENT:GetQuestionCategory()
    local cat = self:GetQuestionInfo().category or "Unknown"

    local split = string.Split( cat, ": " )
    if ( split[2] ) then
        return split[2]
    end

    return cat
end

function ENT:GetQuestionChoices()
    return self:GetQuestionInfo().choices
end

function ENT:GetQuestionChoice( num )
    return self:GetQuestionChoices()[num] or "Unknown"
end

function ENT:GetCorrect()
    return self.ClientNetwork.question.correct or 0
end

function ENT:ClearPodiums()
    local podiums = self:GetPodiums()

    for _, v in ipairs( podiums ) do
        v:ResetCollisions()
        v.Choice = nil
    end
end

function ENT:DrawBackground( w, h, color )
    draw.Rectangle( 0, 0, w, h, color or colorutil.Alpha( color_black, 200 ) )
    draw.GradientBox( 0, 0, w, h, colorutil.Alpha( color_black, 150 ), DOWN )
end

function ENT:DrawLoading( w, h )
    self:DrawBackground( w, h )
    draw.SimpleText( "Loading...", "TriviaScreenLarge", w*.5, h*.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

function ENT:DrawWaiting( w, h )
    local playersNeeded = self:PlayersNeeded()
    local time = math.floor( self:TimeLeft() )
    local str = self:GetState() == trivia.STATE_WAITING and "Starting in " .. time .. " " .. string.Pluralize( "second", time ) or playersNeeded .. " more " .. string.Pluralize( "player", playersNeeded ) .. " needed"
    
    draw.SimpleText( str, "TriviaScreenLarge", w*.5, h*.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

function ENT:DrawPodium( k, podium, x, y, w, h )
    if ( not IsValid( podium ) ) then return end

    local ply = podium:GetPlayer()
    local isValid = IsValid( ply )

    local spacing = self.Margin *.3

    local alpha = 50
    local color = color_black
    if ( isValid ) then
        alpha = podium:GetAnswered() and 150 or 100
        
        if ( self:GetState() == trivia.STATE_INTERMISSION ) then
            color = podium:GetCorrect() and self.ColorCorrect or self.ColorInCorrect
            alpha = 200
        end
    else
        
    end

    surface.SetDrawColor( colorutil.Alpha( colorutil.Brighten( color, .75 ), alpha ) )
    surface.DrawRect( x - spacing, y - spacing, w + (spacing*2), h + (spacing*2) )
    surface.SetDrawColor( colorutil.Alpha( color, alpha ) )
    surface.DrawRect( x, y, w, h )

    if ( isValid ) then        
        draw.SimpleText( ply:Name(), "TriviaScreenSmaller", x + self.Margin, y + (h*.5), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        draw.SimpleText( string.FormatNumber( podium:GetPoints() ), "TriviaScreenSmaller", x + w - self.Margin, y + (h*.5), color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
    end
end

function ENT:DrawGame( w, h )
    draw.GradientBox( 0, 0, w, h, colorutil.Alpha( color_black, 128 ), DOWN )

    surface.SetDrawColor( colorutil.Alpha( self.ColorMain, 100 ) )
    surface.DrawRect( 0, 0, w, h )
    surface.SetDrawColor( self.ColorMain )
    surface.DrawOutlinedRect( 0, 0, w, h, self.Margin )

    local x, y = (self.Margin*2), (self.Margin*2)
    w, h = w - (self.Margin*4), h - (self.Margin*4)

    local header_height = h*.125

    local circle_size = (header_height*.5)*.9
    draw.Shape( x + w*.5, y + header_height*.5, 24, circle_size*1.1, 1, self.ColorMain )
    draw.Shape( x + w*.5, y + header_height*.5, 16, circle_size, 1, colorutil.Alpha( color_black, 100 ) )
    draw.Shape( x + w*.5, y + header_height*.5, 8, circle_size*1.075, self:TimeLeft( true ), self.ColorMain )
    
    local header_module_width = (w*.5) - circle_size - self.Margin
    surface.SetDrawColor( colorutil.Alpha( color_black, 128 ) )

    surface.DrawRect( x, y, header_module_width, header_height )
    draw.TextInBox( self:GetQuestionCategory(), "TriviaScreenMedium", x, y, header_module_width, header_height, color_white, 4, color_black )
    
    surface.DrawRect( x + w - header_module_width, y, header_module_width, header_height )
    draw.TextInBox( string.upper( self:GetQuestionDifficulty() ), "TriviaScreenMedium", x + w - header_module_width, y, header_module_width, header_height, color_white, 4, color_black )

    local time = math.floor( self:TimeLeft() )

    if ( time < 10 ) then
        draw.SimpleShadowText( time, "TriviaScreenMedium", x + (w*.5) + 1, y + (header_height*.5), color_white, nil, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2 )
    else 
        draw.SimpleShadowText( math.floor( time / 10 ), "TriviaScreenMedium", x + (w*.5) - 19, y + (header_height*.5), color_white, nil, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2 )
        draw.SimpleShadowText( time % 10, "TriviaScreenMedium", x + (w*.5) + 19, y + (header_height*.5), color_white, nil, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2 )
    end

    local question_height = h*.5
    local question_y = x + header_height + self.Margin

    surface.DrawRect( x, question_y, w, question_height )
    //surface.DrawOutlinedRect( x, question_y, w, question_height, self.Margin )
    
    local str = self:GetQuestionString()
    draw.WordWrapped( str, "TriviaScreenBig", w*.5, question_y + (question_height*.5), w*.85, color_white, 4, color_black )

    local score_y = question_y + question_height + self.Margin
    local score_h = h - header_height - question_height - (self.Margin*2)
    local score_w = w * .75

    local podiums = self:GetPodiums()
    local podium_count = table.Count( podiums )

    local spacing = self.Margin * .5

    for k, v in ipairs( podiums ) do
        local player_height = math.ceil( score_h / math.ceil( podium_count / 2 ) )
        local player_width = score_w / 2

        local player_x = x + (w*.5) - (score_w*.5) + ( ((k % 2) == 1) and 0 or player_width )
        local player_y = score_y + ( player_height * (math.ceil( k / 2 ) - 1) )

        player_x = player_x + spacing
        player_y = player_y + spacing

        player_height = player_height - (spacing*2)
        player_width = player_width - (spacing*2)

        self:DrawPodium( k, v, player_x, player_y, player_width, player_height )
    end

    /*local v = Entity(1)
    local c = 8
    local spacing = self.Margin * .5
    for k=1, c do
        local player_height = math.ceil( score_h / math.ceil( c / 2 ) )
        local player_width = score_w / 2

        local player_x = x + (w*.5) - (score_w*.5) + ( ((k % 2) == 1) and 0 or player_width )
        local player_y = score_y + ( player_height * (math.ceil( k / 2 ) - 1) )

        player_x = player_x + spacing
        player_y = player_y + spacing

        player_height = player_height - (spacing*2)
        player_width = player_width - (spacing*2)

        self:DrawPodium( k, v, player_x, player_y, player_width, player_height )
    end*/

    //self:DrawPodium( Entity(1), 0, 0, 128, 64 )
end

function ENT:DrawEnd( w, h )
    //draw.SimpleText( "Thanks for playing!", "TriviaScreenLarge", w*.5, h*.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    draw.WaveyText( "Thanks for playing!", "TriviaScreenLarge", w*.5, h*.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 10, 50, .25 )
end

ENT.ErrorBackground = Color( 0, 0, 255 )
ENT.ErrorFont = "TriviaErrorTitle"
ENT.ErrorFont2 = "TriviaErrorMessage"
ENT.ErrorText = color_white
ENT.ErrorTextBackground = Color( 170, 170, 170 )

surface.CreateFont( "TriviaErrorTitle", {
    font = "FixedSys",
    size = 45,

    weight = 800,

    antialias = false,
} )

surface.CreateFont( "TriviaErrorMessage", {
    font = "FixedSys",
    size = 35,

    weight = 400,

    antialias = false,
} )

function ENT:DrawError( w, h )
    surface.SetDrawColor( self.ErrorBackground )
    surface.DrawRect( 0, 0, w, h )

    local tX, tY = w*.5, 256

    surface.SetFont( self.ErrorFont )
    local tW, tH = surface.GetTextSize( "TriviaOS" )

    local tP = 15

    surface.SetDrawColor( self.ErrorTextBackground )
    surface.DrawRect( tX - (tW*.5) - tP, tY, tW + (tP*2), tH )

    surface.SetTextColor( self.ErrorBackground )
    surface.SetTextPos( tX - (tW*.5), tY )
    surface.DrawText( "TriviaOS" )

    local cY = tY + tH + 64

    draw.SimpleText( "An error has occured.", self.ErrorFont2, w*.2, cY, self.ErrorText, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( "Please tell a staff member.", self.ErrorFont2, w*.2, cY + 45, self.ErrorText, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    
    
    local iY = cY + (64*3)
    draw.SimpleText( "Information:", self.ErrorFont2, w*.2, iY, self.ErrorText, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( tostring( self ), self.ErrorFont2, w*.2, iY + 45, self.ErrorText, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    
    local error_string = trivia.ErrorStrings[ self:GetErrorCode() ] or "UNKNOWN"
    draw.SimpleText( "Error: " .. error_string, self.ErrorFont2, w*.2, iY + (45*2), self.ErrorText, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    
    draw.SimpleText( "Restarting in " .. string.NiceTime( math.Clamp( self:GetErrorTime() - CurTime(), 0, self.ErrorTimeout ) ) .. "...", self.ErrorFont2, w*.5, iY + (45*8), self.ErrorText, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
end

function ENT:DrawScreen( scr, w, h )
    if ( self:GetError() and self:GetErrorTime() > 0 ) then
        self:DrawError( w, h )
        return
    end

    local state = self:GetState()
    local pregame = state == trivia.STATE_IDLE or state == trivia.STATE_WAITING
    local ingame = state == trivia.STATE_PLAY or state == trivia.STATE_INTERMISSION
    local endgame = state == trivia.STATE_END

    self:DrawBackground( w, h )

    if ( pregame ) then
        self:DrawWaiting( w, h )
    elseif ( ingame ) then
        self:DrawGame( w, h )
    elseif ( endgame ) then
        self:DrawEnd( w, h )
    end

    if ( self:GetLoading() ) then
        self:DrawLoading( w, h )
    end
end

function ENT:SetupScreen()
    local sc = screen.New()

    local pos = self:GetPos()

    pos = pos + (self:GetUp() * 120)
    pos = pos + (self:GetForward() * 5)

    local angles = self:GetAngles()

    //angles:RotateAroundAxis( self:GetRight(), 90 )

    local resW, resH = 200, 150
    local scale = 0.125

    sc:SetPos( pos )
	sc:SetAngles( angles )

	sc:SetSize( resW, resH )
	sc:SetRes( resW / scale, resH / scale )

	sc:SetCull( true )
	sc:SetFade( 1200, 1200 )

	sc:SetParent( self )

    sc:SetDrawFunc(
		function( scr, w, h )
            self:DrawScreen( scr, w, h )
        end
    )

    sc:AddToScene( true )

    self.Screen = sc
end

function ENT:Initialize()
    self.ClientNetwork = {
        question = {
            str = "",
            category = "",
            difficulty = "",
            choices = {},
            correct = 0,
        },
        // choice = 0,
    }

    self:SetupScreen()
end

function ENT:NetworkRound()
    local question = net.ReadString()
    local category = net.ReadString()
    local difficulty = net.ReadString()

    local choices = {}

    for i=1, net.ReadUInt( 3 ) do
        choices[net.ReadUInt( 3 )] = net.ReadString()
    end

    self.ClientNetwork.question.str = question
    self.ClientNetwork.question.category = category
    self.ClientNetwork.question.difficulty = difficulty
    self.ClientNetwork.question.choices = choices
    self.ClientNetwork.question.correct = 0
end

net.Receive( "trivia.Round", function( len, ply )
    local ent = net.ReadEntity()

    if ( not IsValid( ent ) or not ent.NetworkRound ) then return end

    ent:NetworkRound()
    ent:ClearPodiums()
end )

function ENT:NetworkIntermission()
    self.ClientNetwork.question.correct = net.ReadUInt( 3 )
end

net.Receive( "trivia.Intermission", function( len, ply )
    local ent = net.ReadEntity()
    if ( not IsValid( ent ) ) then return end

    ent:NetworkIntermission()
end )

/*function ENT:NetworkPodiums()
    local count = net.ReadUInt( 6 )

    local podiums = {}
    for i=1, count do
        table.insert( podiums, net.ReadEntity() )
    end

    self.Podiums = podiums
end

net.Receive( "trivia.Podiums", function( len, ply )
    local ent = net.ReadEntity()
    if ( not IsValid( ent ) ) then return end

    ent:NetworkPodiums()
end )*/