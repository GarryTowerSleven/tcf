
-----------------------------------------------------
include('shared.lua')



ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
	self:DrawModel()
end



function ENT:Think()


	self:SetSkin( 2 )

	/*if LocalPlayer().IsVIP and LocalPlayer():IsVIP() then

		self:SetSkin( 2 )

	else

		self:SetSkin( 1 )

	end
*/


end



net.Receive( "OpenDiscord", function()


	local URL = "https://discord.gg/CYJG7paNH9"
	local Title = "GMTower: Deluxe - Discord"



	--browser.OpenURL( URL, Title )

	gui.OpenURL( URL )


end )
