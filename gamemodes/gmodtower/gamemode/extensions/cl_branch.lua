local WebpageURL = "http://www.gmodtower.org/game/branch.html"

local function ShowBranchMessage()

	local frame = vgui.Create( "DFrame" )
	frame:SetSize( math.min( 1280, ScrW() ), math.min( 720, ScrH() ) )
	frame:Center()
	frame:SetTitle( "Warning" )

	frame.OnClose = function()
		LocalPlayer():ChatPrint( "Link has been copied to your clipboard." )
	end

	local html = vgui.Create( "DHTML", frame )
	html:Dock( FILL )
	html:OpenURL( WebpageURL )

	frame:MakePopup()

	SetClipboardText( WebpageURL )

end

hook.Add( "CalcView", "hh", function()
    hook.Remove( "CalcView", "hh" )
    if BRANCH != "x86-64" then
        ShowBranchMessage()
    end
end )