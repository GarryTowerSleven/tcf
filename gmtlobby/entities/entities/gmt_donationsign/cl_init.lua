include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
	self:DrawModel()
end

function ENT:Think()
	self:SetSkin( 2 )
end

net.Receive( "OpenDiscord", function()
	local URL = "https://www.gmtdeluxe.org/chat"
	local Title = "GMod Tower: Deluxe - Discord"

	gui.OpenURL( URL )	
end )
