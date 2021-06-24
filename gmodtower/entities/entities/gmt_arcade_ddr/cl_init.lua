---------------------------------
include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH

/*hook.Add("CanMousePress", "DisableArcadeCabinet", function()

	for _, v in pairs( ents.FindByClass( "gmt_arcade_lightgun" ) ) do
		if v.Browser && v.MouseRayInteresct && v:MouseRayInteresct() then
			return false
		end
	end

end )*/

usermessage.Hook("StartDDR", function(umsg)
	DDR = vgui.Create("DFrame")
	DDR:SetSize(830, 550)
	DDR:Center()
	DDR:SetDraggable(true)
	DDR:MakePopup()
	--DDR:SetTitle("DDR Triple Pack: DDR, Heretic, Hexen")
	DDR:SetTitle("DDR")
	DDR.btnMaxim:Hide()
	DDR.btnMinim:Hide()
	DDR.Paint = function(self, w, h)
	draw.RoundedBox(0,0,0,w,h,Color(0,80,161))
	draw.RoundedBox(0,0,0,w,25,Color(0,65,129))
	end

	Chat = vgui.Create("DButton", DDR)
	Chat:SetPos(681, 3)
	Chat:SetText( "Chat" )
	Chat:SetSize(40, 18)
	Chat.DoClick = function() chat.Open(1) end

	MissingPlugIn = vgui.Create("DButton", DDR)
	MissingPlugIn:SetPos(720, 3)
	MissingPlugIn:SetText( "Blue Screen ?" )
	MissingPlugIn:SetSize(75, 18)
	MissingPlugIn.DoClick = function()
	 gui.OpenURL("https://swampservers.net/video/plugin-guide.html")
	end

	local html = vgui.Create( "HTML", DDR )
	html:Dock( FILL )
	html:OpenURL( "http://www.flashflashrevolution.com/FFR_the_Game_Simple.php?ver=r3" )

	DDR.OnClose = function()
	DDR:SetVisible(false)
	end
end)

function ENT:Draw()
	self:DrawModel()
end
