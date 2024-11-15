local AllowButton = CreateClientConVar( "gmt_thirdpersonbutton", 1, true, false )

local PANEL = {}
local OpenTime = 1 / 0.5 // 0.5 seconds

function PANEL:Init()

	self.TargeYPos = 0
	self.CurYPos = self.TargeYPos

	self:SetSize( 80, 32 )
	
	self.Button = vgui.Create( "DButton", self )
	self.Button:SetText( "" )
	self.Button:SetFont( "GTowerHUDMainSmall" )
	self.Button:SetConsoleCommand( "gmt_thirdperson" )

	self.Button:SetTextColor(Color(255, 255, 255))
	self:SetAlpha( 200 )
	
	self.Button.Paint = function(self, w, h)
		local boxcolor = Color(40, 110, 160) -- Color(50, 120, 170)
		local color = Color(70, 140, 190)
		local alpha = 0

		if self:IsMouseOver() and self:IsMouseInputEnabled() then
			alpha = 1

			if input.IsMouseDown(MOUSE_LEFT) then
				alpha = -1
				if !self.Sound then
					self.Sound = true
				end
			elseif self.Sound then
				self.Sound = nil
				surface.PlaySound("ui/buttonclickrelease.wav")
			end
		end

		local l = alpha / 1
		draw.RoundedBoxEx(6, 0, 0, w, h, Color(Lerp(l, boxcolor.r, color.r), Lerp(l, boxcolor.g, color.g), Lerp(l, boxcolor.b, color.b)), false, false, true, true)
		draw.SimpleText((LocalPlayer().ThirdPerson and "FIRST PERSON") or "THIRD PERSON", "GTowerHUDMainSmall", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

function PANEL:ChangingThink()

	local NewYPos = math.Approach( self.CurYPos, self.TargeYPos, FrameTime() * self:GetTall() * OpenTime )
	
	if NewYPos == self.TargeYPos then
		self.Think = EmptyFunction
		
		if NewYPos < 0 then
			self:SetVisible( false )
		end
	end
	
	self:SetPos( self.x, NewYPos - 6 )
	self.CurYPos = NewYPos

end

function PANEL:Paint( w, h )
	//surface.SetDrawColor( 255, 0, 0, 255 )
	//surface.DrawOutlinedRect( 0,0, self:GetWide(), self:GetTall() )
end

function PANEL:PerformLayout()
	
	self:SetPos( ( ScrW() / 2 ) - 360, self.CurYPos - 6 )
	self:SetZPos( 2 )
	
	self.Button:SetSize( self:GetWide() - 4, self:GetTall() - 4 )
	self.Button:SetPos( 0, 0 )
		
end

function PANEL:Open()
	
	self.IsOpen = true
	self:UpdateChangingThink()
	self.TargeYPos = 0
	
	self:SetVisible( true )

end

function PANEL:Close()

	self.IsOpen = false
	self:UpdateChangingThink()
	self.TargeYPos = -self:GetTall()
	
end

function PANEL:ForceClose()
	self.CurYPos = self:GetTall() * -1
	self:SetPos( self.x, self.CurYPos - 6 )
	self:SetVisible( false )
end


function PANEL:UpdateChangingThink()
	self.Think = self.ChangingThink
end

vgui.Register( "GThirdPersonPanel", PANEL, "Panel" )


function ThirdPerson.ShowMenu()
	
	if !ThirdPerson.Panel then
	
		ThirdPerson.Panel = vgui.Create( "GThirdPersonPanel" )
		ThirdPerson.Panel:ForceClose()
	end
	
	ThirdPerson.Panel:Open()
	ThirdPerson.Panel:InvalidateLayout()
	
end

function ThirdPerson.CloseMenu()

	if ThirdPerson.Panel then
		ThirdPerson.Panel:Close()
	end
	
end

hook.Add( "GTowerShowMenus", "OpenTPPanel", function()
	if AllowButton:GetBool() then
		ThirdPerson.ShowMenu()
	else
		ThirdPerson.CloseMenu()
	end
end )

hook.Add( "GTowerHideMenus", "CloseTPPanel", function()
	ThirdPerson.CloseMenu()
end )