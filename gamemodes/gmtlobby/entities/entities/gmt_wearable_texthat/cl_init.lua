ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "GMT"

ENT.Model = "models/gmod_tower/fedorahat.mdl"
ENT.RenderGroup = RENDERGROUP_BOTH

CreateClientConVar( "gmt_hattext", "", true, true )
CreateClientConVar( "gmt_hatheight", "0", true, true )

surface.CreateFont( "TextHatFont", { font = "Arial", size = 60, weight = 800 } )

function ENT:Initialize()

	self:SetRenderBounds( Vector( -1024, -1024, -1024 ), Vector( 1024, 1024, 1024 ) )

end

function ENT:GetText(o)

	if o == LocalPlayer() then
		return GetConVar( "gmt_hattext" ):GetString()
	else
		return self:GetNWString("Text")
	end

end

function ENT:GetHeight(o)

	if o == LocalPlayer() then
		return GetConVar( "gmt_hatheight" ):GetFloat()
	else
		return self:GetNWString("Height")
	end

end

function ENT:Draw()
end
function ENT:DrawTranslucent()

	local owner = self:GetOwner() //Either( IsValid( self:GetOwner():GetBallRaceBall() ), self:GetOwner():GetBallRaceBall().PlayerModel, self:GetOwner() )
	
	if ( !IsValid( owner ) || owner:IsPlayer() && !owner:Alive() ) then return end
	
	if ( ( owner == LocalPlayer() && !LocalPlayer().ThirdPerson ) || owner:IsNoDrawAll() ) then return end
	
	local title = self:GetText() or ""
	local height = self:GetHeight() or 0
	
	local attach = owner:LookupAttachment( "eyes" )
	local bone = owner:GetAttachment( attach )
	
	local ang = EyeAngles()
	local pos = nil
	
	if ( attach == 0 ) then
		if owner:GetModel() == "models/uch/mghost.mdl" && !owner:IsPlayer() then
			pos = util.GetHeadPos( owner ) - Vector( 0, 0, 16 )
		else
			pos = self:GetPos() + Vector( 0, 0, 70 )
		end
	else
		pos = bone.Pos + Vector( 0, 0, 10 )
	end
	
	if owner:GetModel() == "models/player/robot.mdl" then
		pos = pos + bone.Ang:Forward() * 71 + bone.Ang:Up() * 6
	end

	pos = pos + Vector( 0, 0, height )

	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 90 )

	cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.05 )
		self:DrawText( title, "TextHatFont", 0, 0, 255, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	cam.End3D2D()

end

function ENT:DrawText( text, font, x, y, alpha, xalign, yalign )

	if !text then return end

	if string.StartsWith( text, "*" ) && string.EndsWith( text, "*" ) then
		text = string.sub( text, 2, string.len( text ) - 1 )
		draw.WaveyText( text, font, x, y, color_white, xalign, yalign, 8 )
		return
	end

	draw.DrawText( text, font, x + 1, y + 1, Color( 0, 0, 0, alpha ), xalign, yalign )
	draw.DrawText( text, font, x, y, Color( 255, 255, 255, alpha ), xalign, yalign )

end