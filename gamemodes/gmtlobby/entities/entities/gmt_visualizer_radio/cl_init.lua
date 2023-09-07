include('shared.lua')

ENT.OffsetForward = 4
ENT.OffsetUp = -5
ENT.DefaultTitle = T("RadioTurnedOff")

local GreenBox	= Color( 50, 175, 50, 50 )
local RedBox	= Color( 175, 50, 50, 50 )

ENT.RenderGroup = RENDERGROUP_BOTH

local s = 8
surface.CreateFont("Radio", {
	size = 18 * s,
	shadow = false,
	weight = 0,
	font = "Verdana"
})

function ENT:DrawTranslucent()

	local EntPos = self:GetPos() + ( self:GetForward() * self.OffsetForward ) + self:GetUp() * ( self.OffsetUp + 1 )
	local PlayerEyePos = LocalPlayer():EyePos()
	local PlyDistance = EntPos:Distance( PlayerEyePos )
	
	if PlyDistance > 350 then return end
	
	local ang = self:GetAngles()

	if ( PlayerEyePos - EntPos ):DotProduct( ang:Forward() ) < 0 then
		return
	end

	local Alpha = 175 - math.Clamp( PlyDistance / 256 * 175 ,0, 175 )
	local Alpha2 = 255 - math.Clamp( PlyDistance / 256 * 255 ,0, 255 )
	local MaxNameLenght = 32
	
	ang:RotateAroundAxis(ang:Right(), 	-90 )
	ang:RotateAroundAxis(ang:Up(), 		90 )

	cam.Start3D2D( EntPos , ang, 0.1 / s)
		
		pcall( function()
			local Stream = self:GetStream()
			if not Stream or not self.MediaPlayer then return end

			local Media = self.MediaPlayer:GetMedia()
			local Title = self.DefaultTitle
			local Color = RedBox
			
			if ( Media != nil ) then
				
				Color = GreenBox
				Title = T( "RadioPlaying" ) .. " " .. Media:Title()
				
				self:DrawSpectrumAnalyzer(Alpha, Alpha2)

				if Media:IsTimed() then
					self:DrawDuration( Media, Alpha, Alpha2 )
				end

			else -- there should also be a check for if a file is still loading here. where'd that go?

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
			
			surface.SetFont( "Radio" )

			local w,h = surface.GetTextSize( Title ) 
			Color.a = Alpha

			surface.SetDrawColor( Color )
			draw.RoundedBox(4, -100 * s , -145 * s, w + 16 * s, h + 8 * s, Color )
			surface.SetTextColor( 0, 0, 0, Alpha2 ) 
			surface.SetTextPos( (-100 + 8 + 1) * s, (-145 + 4 + 1) * s ) 	
			surface.DrawText( Title )
			surface.SetTextColor( 255, 255, 255, Alpha2 ) 
			surface.SetTextPos( (-100 + 8) * s, (-145 + 4) * s ) 	
			surface.DrawText( Title )
		end )
		
	cam.End3D2D()
	
end

function ENT:Draw()
	self:DrawModel()
end

local SPECHEIGHT= 54
local SPECWIDTH	= 300
local BANDS	= 28
local ox, oy	= -100, -65

function ENT:DrawSpectrumAnalyzer(Alpha, Alpha2)


	local ox, oy = ox * s, oy * s
	local fft = self:GetFFTFromStream()
	local b0 = 0

	local Col = Color( 0, 255, 255 )
	for x = 0, BANDS-2 do
		Col = colorutil.TweenColor( Col, Color( 0, 0, 255), 0.07, Alpha2 )
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
		surface.DrawRect(ox + (x*8)*s, oy - (y - 1)*s, 7*s, (y + 1)*s)
	end

end

function ENT:DrawDuration(Media, Alpha, Alpha2)

	local ox, oy = ox * s, oy * s
	surface.SetDrawColor( 50, 50, 50, Alpha )
	surface.DrawRect( ox, oy + s, 8*(BANDS-1)*s, 18*s )

	surface.SetDrawColor( 255, 0, 0, Alpha )

	local duration = Media:Duration()
	local curTime = Media:CurrentTime()

	local TimeLeft = duration - curTime
	local lval = 1 - TimeLeft / duration
	local sTime = string.FormatSeconds(math.Clamp(math.Round(curTime), 0, duration))

	surface.DrawRect( ox + (2*s), oy + (3*s), Lerp(lval, 0, 8*(BANDS-1) - 4)*s, 14*s )

	surface.SetFont( "Radio" )
	local w,h = surface.GetTextSize( sTime ) 

	surface.SetTextPos( (ox + (((8*(BANDS-1))/2)*s - w/2))+1*s, (oy + (0*s))+1*s )
	surface.SetTextColor( 0, 0, 0, Alpha2 )
	
	surface.DrawText( sTime )

	surface.SetTextPos( (ox + (((8*(BANDS-1))/2)*s - w/2)), (oy + (0*s)) )
	surface.SetTextColor( 255, 255, 255, Alpha2 )
	
	surface.DrawText( sTime )

end