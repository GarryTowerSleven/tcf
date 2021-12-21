local pScoreBoard = nil
module( "Scoreboard.Customization", package.seeall )

// COLORS
ColorFont = color_white
ColorFontShadow = Color( 6, 76, 127, 255 )

ColorNormal = Color( 34, 100, 156, 255 )
ColorBright = Color( 57, 131, 181, 255 )
ColorDark = Color( 17, 50, 78, 255 )

ColorBackground = colorutil.Brighten( ColorNormal, 0.75 )

ColorTabActive = Color( 0, 0, 64, 64 )
ColorTabDivider = ColorBright
ColorTabInnerActive = colorutil.Brighten( ColorDark, 0.75, 200 )
ColorTabHighlight = Color( 77, 151, 201, 255 )

ColorAwardsDescription = Color( 162, 203, 233, 255 )
ColorAwardsBarAchieved = Color( 178, 215, 243, 255 )
ColorAwardsBarNotAchieved = Color( 3 + 10, 67 + 10, 114 + 10, 200 )
ColorAwardsAchievedIcon = Color( 32, 255, 4, 150 )


// HEADER
HeaderTitle = "GMTower"
HeaderMatHeader = Scoreboard.GenTexture( "ScoreboardLogo", "main_header" )
HeaderMatFiller = Scoreboard.GenTexture( "ScoreboardFiller", "main_filler" )
HeaderMatRightBorder = Scoreboard.GenTexture( "ScoreboardRightBorder", "main_rightborder" )

/*---------------------------------------------------------
   Name: gamemode:CreateScoreboard( )
   Desc: Creates/Recreates the scoreboard
---------------------------------------------------------*/
function GM:CreateScoreboard()

	if ( pScoreBoard ) then
	
		pScoreBoard:Remove()
		pScoreBoard = nil
	
	end

	pScoreBoard = vgui.Create( "ScoreBoard" )
	
	if !GtowerScoreBoard then
		return
	end
	
	GtowerScoreBoard.Players.SortPlayers = function( a, b )
		return string.lower( a:GetPlayer():Name() ) < string.lower( b:GetPlayer():Name() )
	end

end

/*---------------------------------------------------------
   Name: gamemode:ScoreboardShow( )
   Desc: Sets the scoreboard to visible
---------------------------------------------------------*/
function GM:ScoreboardShow()

	GAMEMODE.ShowScoreboard = true
	gui.EnableScreenClicker( true )
	
	if ( !pScoreBoard ) then
		self:CreateScoreboard()
	end
	
	pScoreBoard:SetVisible( true )
	pScoreBoard:UpdateScoreboard( true )
	
end

/*---------------------------------------------------------
   Name: gamemode:ScoreboardHide( )
   Desc: Hides the scoreboard
---------------------------------------------------------*/
function GM:ScoreboardHide()

	GtowerMenu:CloseAll()

	GAMEMODE.ShowScoreboard = false
	gui.EnableScreenClicker( false )
	
	if ( pScoreBoard ) then 
	    pScoreBoard:UpdateScoreboard( false )
        pScoreBoard:SetVisible( false ) 
    end
	
end

function GM:HUDDrawScoreBoard()

	// Do nothing (We're vgui'd up)
	
end

PlayerSubtitleRightText = function( ply )
	if !ply.GRoomId then return end

	local roomid = ply.GRoomId

	if roomid && roomid > 0 then
		local room = tostring( roomid ) or ""

		if room != "" then
			return "Condo #".. room
		end
	end
end

PlayerNotificationIcon = function( ply )
	if ply.IsAFK && ply:IsAFK() then
		return Scoreboard.PlayerList.MATERIALS.Timer
	end

	if GTowerGroup then
		if GTowerGroup.GroupOwner == ply && GTowerGroup:IsInGroup( LocalPlayer() ) then
			return Scoreboard.PlayerList.MATERIALS.Crown
		end
	end
end