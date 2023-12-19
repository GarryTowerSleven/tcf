include('shared.lua')

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

local FONT = "GTowerSkyLarge"
local SMALLFONT = "GTowerSkySmall"
local s = 1.8
surface.CreateFont( FONT, { font = "Oswald", size = 144*s, weight = 400 } )
surface.CreateFont( SMALLFONT, { font = "Oswald", size = 64*s, weight = 400 } )



function ENT:Initialize()
	self:SetModel( self.Model )
	
	self.NegativeX = 0
	self.PositiveY = 0
	self.TextWidth = 0
	self.TextHeight = 0
	self.StrText = ""
	self.IsTheater = false
	self.TColor = Color(255,255,255,255)
	
	self:DrawShadow( false )
	
end

function ENT:Think()
	
	local Skin = tonumber( self:GetSkin() )
	
	if Skin != 0 then
		self:TextChanged( Skin )
		
		self.Think = EmptyFunction
	end
	
end

function ENT:TextChanged( id )

	surface.SetFont( FONT )
	
	if !self.Messages[ id ] then
		return
	end

	if self.OverrideMessages[ id ] then
		self.StrText = self.OverrideMessages[ id ]
	else
		self.StrText = self.Messages[ id ]
	end
	
	if type( self.StrText ) == "table" then
		self.TColor = self.StrText.Color or Color(255,255,255,255)
		
		self.StrText = self.StrText.Name
	end
	
	if self.StrText == "Theatre" then
		self.StrText = T("Theater")
		self.IsTheater = true
	end
	
	local w,h = surface.GetTextSize( self.StrText )
	
	self.NegativeX = -w / 2
	self.PositiveY = -h
	
	self.TextWidth, self.TextHeight = w, h
	

	local min = Vector(0, self.NegativeX, 0)
	local max = Vector(0, -self.NegativeX, h )

	self:SetRenderBounds(min, max)
	
	if self.IsTheater then
		self.DrawExtra = self.DrawTheaterVideo
	end
	
end

function ENT:DrawTranslucent()

	// Aim the screen forward
	local ang = self.Entity:GetAngles()
	local pos = self.Entity:GetPos() + ang:Up() * math.sin( CurTime() ) * 2
	
	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 90 )
	
	if (LocalPlayer():EyePos() - pos ):DotProduct( ang:Up() ) < 0 then
		ang:RotateAroundAxis( ang:Right(), 180 )
	end
	
	// Start the fun
	cam.Start3D2D( pos, ang, 0.5/s )
		
		if self.StrText == "Party Suite" then

			surface.SetFont( FONT )
			local tw, th = surface.GetTextSize("Party ")
			surface.SetTextColor( self.TColor.r, self.TColor.g, self.TColor.b, self.TColor.a )
			surface.SetTextPos( tw + self.NegativeX, self.PositiveY )
			surface.DrawText( "Suite" )
			draw.WaveyText( "Party", FONT, self.NegativeX, self.NegativeY, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 4, 4, 1, 24 )
			
			self:DrawExtra()

		else

			surface.SetFont( FONT )
			surface.SetTextColor( self.TColor.r, self.TColor.g, self.TColor.b, self.TColor.a )
			surface.SetTextPos( self.NegativeX, self.PositiveY )
			surface.DrawText( self.StrText )
			
			self:DrawExtra()

			if self.StrText == "Casino" then

				draw.SimpleText("Orlok's", "DermaLarge", self.NegativeX + 16, self.PositiveY + 16, color_white)

			end

		end
		
	cam.End3D2D()
	
end

function ENT:DrawExtra()
	
end

function ENT:DrawTheaterVideo()

	--if GTowerTheater.CurentlyPlaying == 0 then
	--	return
	--end

	--local Video = GTowerTheater.VoteData[ GTowerTheater.CurentlyPlaying ]

	--if !Video || !Video.name then
	--	return
	--end

	local title = globalnet.GetNet( "CurVideo" ) or "No Video Playing"

	if ( #title > 48 ) then
		title = title:sub( 1, 48 ):Trim() .. "..."
	end

	surface.SetFont( SMALLFONT )
	local w,h = surface.GetTextSize( title )

	surface.SetTextColor( 255, 255, 255, 255 )
	surface.SetTextPos( self.NegativeX + self.TextWidth / 2 - w / 2, self.PositiveY + self.TextHeight + 10 )
	surface.DrawText( title )

end
