---------------------------------
//local BackgroundColor = Color( 0x16, 0x34, 0x55, 0.5 * 255 )
local BackgroundColorOnline = Color( 0x16, 0x70, 0x55, 0.5 * 255 )
local BackgroundColorOffline = Color( 255, 23, 68, 0.5 * 255 )
local BackgroundColor = Color( 0x16, 0x34, 0x55, 0.5 * 255 )

local MainTextFont = "GTowerHUDHuge"

function ENT:GetMainText()
	if !self.ServerOnline then
		return "Gamemode Offline"
	end
	return self.ServerName
end

function ENT:ProcessMain()

	surface.SetFont("MultiTitleDeluxe")
	local w, h = surface.GetTextSize( self:GetMainText() )

	self.MainTextTitleX = self.TotalMinX + self.TotalWidth / 2 - w / 2
	self.MainTextTitleY = self.TotalMinY + 15

	if !self.ServerOnline then
		self.MainTextTitleY = self.TotalMinY + 30
	end

	//local w,h = surface.GetTextSize( self.ServerStatus )

end

function ENT:DrawMain()

	local Server = self:GetServer()
	local BGColor = BackgroundColor
	local TitleOffset = 0

	if Server && Server.Ready then
		BGColor = self.ThemeColor
	elseif !self.ServerOnline then
		BGColor = BackgroundColorOffline
	end

	surface.SetFont( "MultiTitleDeluxe" )
	surface.SetTextColor( 255, 255, 255, 255 )

	if !self.ServerOnline then
		TitleOffset = 42
	end

	surface.SetTextPos( self.MainTextTitleX, self.MainTextTitleY + TitleOffset )
	surface.DrawText( self:GetMainText() )

	if self.DrawGamemodeData then
		self:DrawGamemodeData()
	end

	--local Server = self:GetServer()

	if Server && Server.RedirectingTime  then
		local TimeLeft = math.Clamp( Server.RedirectingTime - CurTime(), 0, 15 ) / 15

		surface.SetDrawColor( 30, 200, 30, 150 )
		surface.DrawRect( self.TotalMinX + 5, self.TotalMinY + self.TopHeight + 5, TimeLeft * (self.TotalWidth-10), 10 )

	end

end
