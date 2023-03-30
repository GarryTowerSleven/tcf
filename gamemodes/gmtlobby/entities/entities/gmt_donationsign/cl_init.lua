include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
	self:DrawModel()
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
