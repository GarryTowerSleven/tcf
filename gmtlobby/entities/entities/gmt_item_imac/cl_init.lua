
-----------------------------------------------------
include( "shared.lua" )

ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Draw()
	self:DrawModel()
end

net.Receive("imac_open",function()
	local Arcades = vgui.Create( "DFrame" )
	Arcades:SetTitle("iMac")
	Arcades:SetSize( 1000, 600 )
	Arcades:Center()
	Arcades:MakePopup()

	local html = vgui.Create( "HTML", Arcades )
	html:Dock( FILL )
	html:OpenURL( "https://windows93.net" )
end)
