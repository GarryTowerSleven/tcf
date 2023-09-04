AddCSLuaFile()

ENT.PrintName = "Jukebox"

ENT.Type = "anim"
ENT.Base = "gmt_mediaplayer_relay"

ENT.RenderGroup = RENDERGROUP_OPAQUE

ENT.Model = Model( "models/gmod_tower/jukebox.mdl")

ENT.PlayerConfig = {
	angle = Angle(0, 0, 0),
	offset = Vector(0,0,0),
	width = 0,
	height = 0
}

if SERVER then return end
local glow = Material("sprites/glow04_noz")

function ENT:Draw()
	self:DrawModel()

	local mp = self:GetMediaPlayer()
	if ( not mp ) then return end
	local media = mp:GetMedia()

	local b = 0

	if media and media.fft then
		for i = 1, 20 do
			b = b + media.fft[i]
		end

		b = b / 20
	end
	self.Lerp = self.Lerp or 0
	self.Lerp = math.Approach(self.Lerp, b, FrameTime() * (0.1 + (b > 0.08 and 0.2 or 0)))
	self.Sine = self.Sine or 0
	self.Sine = self.Sine + FrameTime() * b * 32
	
	local offset 	= Vector( 0,0, math.sin( CurTime() * 4 ) * 2 )
	local pos 		= self:GetPos() + self:GetUp() * (80 - (media and 4 - self.Lerp * 32 or 0)) + offset * (media and media.fft and 0 or 1)
	local ang 		= self:GetAngles()
	
	local scale 	= .15

	local c = colorutil.Rainbow(b * 512)
	c = HSVToColor(self.Sine * 256 or ColorToHSV(c), self.Lerp == 0 and 0 or self.Lerp + 0.4, 1)
	if media then
		render.SetMaterial(glow)
		local x, y = 24 + self.Lerp * 48, 24 + self.Lerp * 48
		local c2 = Color(c.r, c.g, c.b, 128 + 255 * self.Lerp)
		local r = self.Sine * 8
		for i = 1, 8 do
		render.DrawQuadEasy(self:GetPos() + ang:Forward() * (6.25 + ((i - 1) * 0.25)) + ang:Up() * (48 + (self:GetManipulateBoneScale(0).z - 1) * 48), self:GetForward(), x, y, c2, r)
		end
	end

	self:ManipulateBoneScale(0, Vector(1, 1, 1 + self.Lerp * 0.5 + math.sin(self.Sine * 2) * 0.04))
	self:SetRenderAngles()

	self:SetRenderOrigin(self:GetNetworkOrigin() + Vector(0, 0, self.Lerp * 24) + self:GetForward() * self.Lerp * 8)
	self:SetRenderAngles(self:GetNetworkAngles() + Angle(0, 0, math.sin(self.Sine or SysTime() * 2) * self.Lerp * 64))
	ang:RotateAroundAxis( ang:Forward(), 90 + math.sin(self.Sine) * -8 * self.Lerp * 6 )
	ang:RotateAroundAxis( ang:Up(), 0 )
	ang:RotateAroundAxis( ang:Right(), -90 or self.Lerp * 24 )
	pos = pos + self:GetRight() * math.sin(self.Sine or SysTime() * 2) * self.Lerp * 84
	
	cam.Start3D2D( pos - ang:Right() * self.Lerp * 32, ang, media and scale / 2 or scale )
		draw.DrawText( "HOLD Q TO REQUEST MUSIC",
		"GTowerSkyMsgSmall",
		0,
		0,
		HSVToColor(self.Sine * 256, self.Lerp, 1 - self.Lerp) or Color(255,255,255,255),
		TEXT_ALIGN_CENTER
		)
	cam.End3D2D()

	if !media then return end

	name = media._metadata.title or media.Name 
	
	if string.len( name ) >= 32 then
		name = string.sub(name, 1, 32) .. "..."
	end
	
	cam.Start3D2D( pos - ang:Right() * self.Lerp * 84, ang, media and scale / 1.5 + self.Lerp or scale )
	// draw.SimpleText(b, "DebugFixed", 0, 0, color_white)
	draw.DrawText( name or "HOLD Q TO REQUEST MUSIC",
	"GTowerSkyMsgSmall",
	0,
	32,
	c or Color(255,255,255,255),
	TEXT_ALIGN_CENTER
	)
cam.End3D2D()

local light = DynamicLight(self:EntIndex())

if light then
	light.pos= self:WorldSpaceCenter() + self:GetForward() * 8
	light.size = 200
	light.brightness = 2
	light.r = c.r
	light.g = c.g
	light.b = c.b
	light.decay = 64
	light.dietime = CurTime() + 0.1
end
end