include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
	self.BrowserState = false
end

function ENT:Draw()
	self:DrawModel()
end

net.Receive("ShowiMac",function()
	local imac = vgui.Create( "DFrame" )
	imac:SetTitle( "Windows 93" )
	imac:SetSize( 1000, 600 )
	imac:Center()
	imac:MakePopup()

	local html = vgui.Create( "HTML", imac )
	html:Dock( FILL )
	html:OpenURL( "https://windows93.net" )
end)