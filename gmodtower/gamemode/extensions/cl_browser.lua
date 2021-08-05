module( "browser", package.seeall )

Browser = nil
HTMLFrame = nil

function OpenURL( URL, title )
	
	if !ValidPanel( Browser ) then
		Browser = vgui.Create( "HTML" )
		Browser:SetSize( ScrW() * .75, ScrH() * .75 )
	end
		
	if !ValidPanel( HTMLFrame ) then
		local w, h = Browser:GetWide() + 10, Browser:GetTall() + 35

		HTMLFrame = vgui.Create( "DFrame" )
		HTMLFrame:SetSize( w, h )
		HTMLFrame:SetTitle( title )
		HTMLFrame:SetPos( ( ScrW() / 2 ) - ( w / 2 ), ( ScrH() / 2 ) - ( h / 2 ) )
		HTMLFrame:SetDraggable( true )
		HTMLFrame:ShowCloseButton( true )
		HTMLFrame:SetDeleteOnClose( false ) //Do not remove when the window is closed, just hide it
	end
		
	Browser:SetPaintedManually( false )
	Browser:SetParent( HTMLFrame )
	Browser:SetPos( 5, 25 )
	Browser:OpenURL( URL )
		
	HTMLFrame:SetVisible( true )
	HTMLFrame:MakePopup()

	HTMLFrame.Close = function( self )
		DFrame.Close( self )
		Close()
	end

	HTMLFrame.CloseSafe = function( self )
		DFrame.Close( self )
		Close()
	end

end

function Close()

	if ValidPanel( Browser ) then
		Browser:Remove()
	end
	
	if ValidPanel( HTMLFrame ) then
		HTMLFrame:Remove()
	end

end