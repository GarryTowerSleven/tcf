include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
	self:DrawModel()

	print(self:GetPos())
	cam.Start3D2D(self:GetPos() + self:GetRight() * -128 - Vector(0, 0, 0) + self:GetForward() * 24, self:GetAngles() + Angle(90, 0, 0), 1)
	if !IsValid(TowerUnite) then
		TowerUnite = vgui.Create("DHTML")
		TowerUnite:SetSize(640, 480)
		TowerUnite:SetPos(0, 0)
		TowerUnite:SetPaintedManually(true)
		TowerUnite:OpenURL("https://store.steampowered.com/widget/394690/")
	else
		TowerUnite:PaintManual()
	end

	cam.End3D2D()
end

function ENT:Think()
	self:SetSkin( 2 )
end

net.Receive( "OpenDiscord", function()

	//local URL = "http://www.towerunite.com"
	//local Title = "TOWER UNITE - HELP US TODAY!"

	--[[local URL = "http://www.gmtower.org/index.php?p=donations&app=1&hide=1&si=" .. LocalPlayer():SteamID()
	local Title = "Donate"

	if LocalPlayer().IsVIP && LocalPlayer():IsVIP() then
		URL = "http://www.gmtower.org/forums/index.php?board=14.0"
		Title = "VIP Forums"
	end]]

	local URL = "https://discord.gg/CYJG7paNH9"
	local Title = "GMTower: Deluxe - Discord"

	--browser.OpenURL( URL, Title )
	gui.OpenURL( URL )	

end )
