include('shared.lua')

ENT.OffsetForward = 4
ENT.OffsetUp = -5
ENT.DefaultTitle = T("RadioTurnedOff")

local GreenBox	= Color( 0, 255, 0, 50 )
local RedBox	= Color( 255, 0, 0, 50 )

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:DrawTranslucent()

	local EntPos = self:GetPos() + ( self:GetForward() * self.OffsetForward ) + self:GetUp() * ( self.OffsetUp + 1 )
	local PlayerEyePos = LocalPlayer():EyePos()
	local PlyDistance = EntPos:Distance( PlayerEyePos )
	
	if PlyDistance > 350 then return end
	
	local ang = self:GetAngles()

	if ( PlayerEyePos - EntPos ):DotProduct( ang:Forward() ) < 0 then
		return
	end

	local Alpha = 255 - math.Clamp( PlyDistance / 300 * 255 ,0, 255 )
	local MaxNameLenght = 32
	
	ang:RotateAroundAxis(ang:Right(), 	-90 )
	ang:RotateAroundAxis(ang:Up(), 		90 )

	cam.Start3D2D( EntPos , ang, 0.1)
		
		pcall( function()
			local Title
			local Color
			local Media = self:GetFirstMediaPlayerInLocation():GetMedia()
			
			if ( Media != nil ) then
				
				Color = GreenBox
				Title = T( "RadioPlaying" ) .. " " .. Media:Title()
				
				self:DrawSpectrumAnalyzer(Alpha)

				if Media:IsTimed() then
					self:DrawDuration( Media, Alpha )
				end

			else

				Title = self.DefaultTitle
				Color = RedBox

			end
			
			local TitleLenght = string.len( Title )
			
			if TitleLenght > MaxNameLenght then

				local DelayedTime = 4
				local Difference = TitleLenght - MaxNameLenght
				
				local Time = math.fmod( math.Round( CurTime() ), (Difference + DelayedTime ) * 2  )
				local Start = math.Clamp( -math.abs(Time-DelayedTime-Difference) + Difference + DelayedTime / 2 , 0, Difference )
			
				Title = string.sub( Title, Start, Start + MaxNameLenght )

			end
			
			surface.SetFont( "ChatFont" )

			local w,h = surface.GetTextSize( Title ) 
			Color.a = Alpha

			surface.SetDrawColor( Color )
			surface.DrawRect(-100, -145, w + 16, h + 8 )

			surface.SetTextColor( 255, 255, 255, Alpha ) 
			surface.SetTextPos( -100 + 8, -145 + 4 ) 	
			surface.DrawText( Title )
		end )
		
	cam.End3D2D()
	
end

function ENT:Draw()
	self:DrawModel()
end

local SPECHEIGHT= 64
local SPECWIDTH	= 300
local BANDS	= 28
local ox, oy	= -100, -65

function ENT:DrawSpectrumAnalyzer(Alpha)

	local fft = self:GetFFTFromStream()
	local b0 = 0

	local Col = Color( 0, 255, 255 )
	for x = 0, BANDS-2 do
		Col = colorutil.TweenColor( Col, Color( 0, 0, 255), 0.07, Alpha )
		surface.SetDrawColor(Col)
		local sum = 0
		local sc = 0
		local b1 = math.pow(2,x*10.0/(BANDS-1))

		if (b1>1023) then b1=1023 end
		if (b1<=b0) then b1=b0+1 end
		sc=10+b1-b0
		while b0 < b1 do
			sum = sum + fft[2+b0]
			b0 = b0 + 1
		end
		y = (math.sqrt(sum/math.log10(sc))*1.7*SPECHEIGHT)-4
		y = math.Clamp(y, 0, SPECHEIGHT)
		surface.DrawRect(ox + x*8, oy - y - 1, 7, y + 1)
	end

end

function ENT:DrawDuration(Media, Alpha)

	surface.SetDrawColor( 50, 50, 50, Alpha )
	surface.DrawRect( ox, oy + 1, 8*(BANDS-1), 18 )

	surface.SetDrawColor( 255, 0, 0, Alpha )

	local duration = Media:Duration()
	local curTime = Media:CurrentTime()

	local TimeLeft = duration - curTime
	local lval = 1 - TimeLeft / duration
	local sTime = stringmod.FormatSeconds(math.Clamp(math.Round(curTime), 0, duration))

	surface.DrawRect( ox + 2, oy + 3, Lerp(lval, 0, 8*(BANDS-1) - 4), 14 )

	surface.SetFont( "ChatFont" )
	local w,h = surface.GetTextSize( sTime ) 

	surface.SetTextPos( ox + (8*(BANDS-1))/2 - w/2, oy + 2 )
	surface.SetTextColor( 255, 255, 255, Alpha )
	
	surface.DrawText( sTime )

end