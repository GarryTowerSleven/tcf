include('shared.lua')

RunConsoleCommand( "gmt_clearwebboard" )

local S = 1
SetupBrowser( ENT, 800/S, 700/S, .5*S )

ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Material = nil

function ENT:DrawTranslucent()

	local pos, ang = self:GetPosBrowser(), self:GetAngles()
	local up, right = self:GetUp(), self:GetRight()

	pos = pos + (up * self.Height * self.Scale) + (right * (self.Width/2) * self.Scale)

	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 90)

	cam.Start3D2D(pos,ang,self.Scale)
		pcall( self.DrawMaterial, self )
	cam.End3D2D()

end

function ENT:Initialize()
	self:StartBrowser()
	self:SetRenderBounds( Vector( 2, 200, 0 ), Vector( -2, -200, 350 ) )
end
 
function ENT:DrawMaterial()

	if !self.Material then return end
	draw.HTMLMaterial( self.Material, self.Width, self.Height )

end

function ENT:Draw()
end

function ENT:StartBrowser()

	self:InitBrowser( self:GetTable() )
	self.Browser:LoadURL( self.Webpage )

	timer.Simple( 2, function() 
	
		if !self.Material then

			if self.Browser then
				self.Browser:UpdateHTMLTexture()
				self.Material = self.Browser:GetHTMLMaterial()

				self:EndBrowser()
			end

		end

	end )

end

function ENT:EndBrowser()
	self:RemoveBrowser()
end

function ENT:OnRemove()
	self:EndBrowser()
end

/*function ENT:CanUse( ply )
	return true, "MORE INFO"
end*/

concommand.Add( "gmt_clearwebboard", function( ply, cmd, args )

	for _, ent in pairs( ents.FindByClass( "gmt_webboard" ) ) do

		ent:EndBrowser()
		ent.Material = nil
		ent:StartBrowser()

	end

end )

/*usermessage.Hook( "OpenTowerUnite", function( um ) 

	local URL = "http://www.gmtower.org/reunion/play/towerunite/"
	local Title = "Buy Tower Unite Today"

	browser.OpenURL( URL, Title )

end )*/