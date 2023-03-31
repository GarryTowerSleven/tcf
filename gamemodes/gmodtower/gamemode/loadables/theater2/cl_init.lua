include "player/cl_init.lua"
include "shared.lua"

module( "GTowerTheater", package.seeall )

VotePanel = nil

local function GetTime( time )

	local Info = string.FormattedTime( time )
	
	if time > 60*60 then
		return string.format( "%2i:%02i:%02i", Info.h, Info.m, Info.s )
	else
		return string.format( "%2i:%02i", Info.m, Info.s )
	end
	
end

function OpenVote( mp )

    local mp = mp or hook.Run( "GetMediaPlayer" )
    if ( not IsValid( mp ) ) then return end

    CloseVote()

    local Main = vgui.Create( "DFrame" )
    VotePanel = Main
    Main:SetSize( 400, 500 )
	Main:Center()
	Main:MakePopup()
	Main:SetTitle( "Theater" )

    Main.Close = function() CloseVote() end

    local ListView = vgui.Create( "DListView", Main )

    local Col1 = ListView:AddColumn( "Video" )
	local Col2 = ListView:AddColumn( "Length" )
	local Col3 = ListView:AddColumn( "Votes" )

    Col2:SetFixedWidth( 40 )
	Col3:SetFixedWidth( 40 )

    if AllowControl( LocalPlayer() ) then
        local Col4 = ListView:AddColumn( "R" )
        
        Col4:SetFixedWidth( 10 )
    end

    ListView:SetPos( 5, 25 )
	ListView:SetSize( Main:GetWide() - 10, Main:GetTall() - 25 - 30 )
	Main.ListView = ListView

    Main.VideoLines = {}
    local function GetAdminButtons(i)
		if AllowControl( LocalPlayer() ) then
			local RemoveButton = vgui.Create("DButton")
			RemoveButton:SetText( "R" ) 
			RemoveButton.VideoId = i
			RemoveButton.DoClick = RemoveThisVideo
			
			return RemoveButton
		end
	end

    local queue = mp:GetMediaQueue()

    for _, v in ipairs( queue ) do
		local Vote = vgui.Create("DButton")
		Vote:SetText( /*Data.votes*/ "420" ) 
		Vote.DoClick = function()
			//VoteId( tostring(i) )
		end

		local Line = ListView:AddLine( v:Title(), GetTime( v:Duration() ), Vote, GetAdminButtons(i) )
		local Id = Line:GetID()
		
		Line.OnMousePressed = EmptyFunction
		Line.OnCursorMoved = EmptyFunction
		Main.VideoLines[ Id ] = Line
		Main.VideoLines[ Id ].VoteButton = Vote
    end

    local AddButton = vgui.Create( "DButton", Main )
	AddButton:SetText( "ADD" )
	AddButton:SetPos( 10, Main:GetTall() - 25 )
	AddButton:SetSize( 100, 20 )
	AddButton.DoClick = function() end
	Main.AddButton = AddButton

    ListView:SortByColumn()
	//ThinkHideButtons()

end

function CloseVote()
	if IsValid( VotePanel ) then
		VotePanel:SetVisible( false )
		VotePanel:Remove()
	end
	
	VotePanel = nil
end