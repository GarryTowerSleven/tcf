---------------------------------
include('shared.lua')
include('cl_network.lua')
include("cl_playerlist.lua")
include("cl_map.lua")
include("cl_list.lua")
include("cl_mainobj.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
end

function ENT:Id()
	return tonumber( self:GetSkin() )
end

function ENT:GetServer()
	local Id = self:Id()

	if GTowerServers.Servers[ Id ] then
		return GTowerServers:Get( Id )
	end

end

function ENT:UpdateBoundries()


	self.TotalMinX   = -self.NegativeX   / self.ImageZoom
	self.TotalMinY   = -self.NegativeY   / self.ImageZoom
	self.TotalWidth  =  self.TableWidth  / self.ImageZoom
	self.TotalHeight =  self.TableHeight / self.ImageZoom

	//The size of the player board width
	self.PlayerWidth = self.TotalWidth * 0.3

	//Top height of the main object
	self.TopHeight = self.TotalHeight * 0.3

	//Start Y Posistion for the player boards
	self.PlayerStartY = self.TotalMinY + self.TopHeight + 20

end

function ENT:ReloadPositions()
	self:UpdateBoundries()
	self:ProcessMain()
	self:ProcessMapPos()
	self:UpdatePlayerList()
end

function ENT:DrawTranslucent()

end

local MainBackground = Color(14, 48, 74, 50)

function ENT:Draw()
end

function ENT:DrawTranslucent()

	if true then return end

	if CurTime() > self.NextUpdate then
		self:UpdateData()
	end

	local EntPos = self.Entity:GetPos()
	local Eye = self.Entity:EyeAngles()

	local ang = self.Entity:GetAngles()
	ang:RotateAroundAxis(ang:Up(), 		90 )
	ang:RotateAroundAxis(ang:Forward(), 90 )

	local pos = EntPos + Eye:Up() * self.UpPos + Eye:Forward() * self.FowardsPos + Eye:Right()

	cam.Start3D2D( pos, ang, self.ImageZoom )
	
		draw.RoundedBox( 2, 
			self.TotalMinX, 
			self.TotalMinY, 
			self.TotalWidth, 
			self.TotalHeight, 
			MainBackground
		)
		
	cam.End3D2D()

	local pos = EntPos + Eye:Up() * self.UpPos + Eye:Forward() * ( self.FowardsPos + 5 ) + Eye:Right()

	cam.Start3D2D( pos, ang, self.ImageZoom )
		self:DrawPlayers()
		self:DrawMap()
		self:DrawMain()
	cam.End3D2D()

end

function ENT:DrawMainGuiOffline()
	surface.SetTextColor( 255, 50, 50, 255 )
	surface.SetFont("GTowerHUDHuge")

	local w,h = surface.GetTextSize( "OFFLINE" )

	surface.SetTextPos(
		self.TotalMinX + self.TotalWidth / 2 - w / 2,
		self.TotalMinY + self.TotalHeight * 0.15 - h / 2
	)

	surface.DrawText( "OFFLINE" )
end

ENT.DrawMainGui = ENT.DrawMainGuiOffline
