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
surface.CreateFont( "TextHatFontGlow", { font = "Arial", size = 60, weight = 800, blursize = 8 } )

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

local json = {}

local transitions = {}

function DrawTable(table, x, y, font, alpha, xalign, yalign, ent)

	x = x || 0
	y = y || 0
	font = font || "TextHatFont"
	xalign = xalign || 0
	yalign = yalign || 0

	local text = {
		text = table.text || text || "",
		color = table.color || color_white,
		wavy = tonumber( table.wavy ) || false,
		rainbow = false
	}

	if ent and !ent:GetCustom() then

		text = {
			text = text.text,
			color = color_white
		}

		table = text

	end

	if table.rainbow && table.rainbow < 0 then

		text.color = HSVToColor( math.fmod( CurTime() * (math.abs( tonumber( table.rainbow ) ) || 1), 360 ), 1, 1 )
		text.rainbow = false

	else

		text.rainbow = tonumber( table.rainbow )

	end

	if table.trans then

		local id = util.TableToJSON( text )

		transitions[id] = transitions[id] || {
			old = Color( 255, 255, 255 ),
			new = table.trans[2][1],
			time = CurTime() + table.trans[1],
			id = 1
		}

		local trans = transitions[id]

		if trans.time < CurTime() then
			transitions[id].old = transitions[id].new
			transitions[id].new = table.trans[2][trans.id + 1] || table.trans[2][1]
			transitions[id].time = CurTime() + table.trans[1]
			transitions[id].id = math.fmod( trans.id + 1, #table.trans[2] )

		end

		local h1, s1, v1 = ColorToHSV(trans.old)
		local h2, s2, v2 = ColorToHSV(trans.new)

		local l = ( ( CurTime() - trans.time ) / table.trans[1] )
		l = 1 - math.abs(l)
		local result = Color( Lerp( l, trans.old.r, trans.new.r ), Lerp( l, trans.old.g, trans.new.g ), Lerp( l, trans.old.b, trans.new.b ) )

		text.color = result

	end

	local func = text.wavy && draw.WaveyText || text.rainbow && draw.RainbowText || draw.SimpleText

	if table.blur then
	
		func( text.text, font .. "Glow", x + 1, y + 1, Color( text.color.r, text.color.g, text.color.b, text.color.a / 2 ), xalign, yalign, text.wavy || text.rainbow, false, false, table.rainbow )

	else
	
		func( text.text, font, x + 1, y + 1, Color( 0, 0, 0, text.color.a ), xalign, yalign, text.wavy || text.rainbow, false, false, table.rainbow )
	
	end
	
	func( text.text, font, x, y, text.color, xalign, yalign, text.wavy || text.rainbow, false, false, table.rainbow )


end

function ENT:DrawText( text, font, x, y, alpha, xalign, yalign )

	if !text then return end

	if string.StartsWith( text, "{" ) && string.EndsWith( text, "}" ) then

		local table = json[text] || util.JSONToTable( string.Replace( text, "'", "\"" ) )

		if table then

			json[text] = table

			DrawTable( table, x, y, font, alpha, xalign, yalign )

			return

		end

	end

	draw.DrawText( text, font, x + 1, y + 1, Color( 0, 0, 0, alpha ), xalign, yalign )
	draw.DrawText( text, font, x, y, Color( 255, 255, 255, alpha ), xalign, yalign )

end

concommand.Add( "gmt_hat_edit", function()

	if IsValid(hat) then
		hat:Remove()
	end

	local text = {
		text = "Text Hat",
		color = Color( 255, 255, 255 )
	}

	local tab = util.JSONToTable( string.Replace( GetConVar( "gmt_hattext" ):GetString(), "'", "\"" ) )

	if tab then

		text = tab

	end

	local w, h = ScrW(), ScrH()

	hat = vgui.Create( "DFrame" )

	hat:SetSize( h * 0.4, h * 0.4 )
	hat:Center()

	hat:MakePopup()

	hat.PaintOver = function()

		DrawTable( text, hat:GetWide() * 0.5, hat:GetTall() * 0.175, nil, nil, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	end

	local textentry = vgui.Create( "DTextEntry", hat )

	textentry:SetSize( hat:GetWide() * 0.975, hat:GetTall() * 0.05 )
	textentry:SetPos( hat:GetWide() * 0.015, hat:GetTall() * 0.35 )
	textentry:SetPlaceholderText( "Text" )
	textentry:SetText( text.text )

	function textentry:OnChange( val )

		text.text = self:GetText()

	end

	local rgb = vgui.Create( "DColorMixer", hat )

	rgb:SetSize( hat:GetWide() - hat:GetWide() * 0.015 * 2, hat:GetTall() / 2.5 )
	rgb:SetPos( hat:GetWide() * 0.015, hat:GetTall() * 0.4 )
	rgb:SetPalette( false )
	rgb:SetColor( text.color )

	function rgb:ValueChanged( color )

		text.color = color

	end

	local rainbow = vgui.Create( "DNumSlider", hat )

	rainbow:SetSize( hat:GetWide(), hat:GetTall() * 0.05 )
	rainbow:SetPos( hat:GetWide() * 0.015, hat:GetTall() * 0.8 )
	rainbow:SetText("Rainbowify!")
	rainbow:SetMinMax( -180, 180 )
	rainbow:SetDecimals( false )
	rainbow:SetValue( text.rainbow )

	function rainbow:OnValueChanged( val )

		val = math.floor( val )
		text.rainbow = val != 0 && val

	end

	local wavy = vgui.Create( "DNumSlider", hat )

	wavy:SetSize( hat:GetWide(), hat:GetTall() * 0.05 )
	wavy:SetPos( hat:GetWide() * 0.015, hat:GetTall() * 0.85 )
	wavy:SetText("Wavify!")
	wavy:SetMinMax( 0, 24 )
	wavy:SetDecimals( false )
	wavy:SetValue( text.wavy )

	function wavy:OnValueChanged( val )

		val = math.floor( val )
		text.wavy = val != 0 && val

	end

	local confirm = vgui.Create( "DButton", hat )

	confirm:SetText( "Confirm" )
	confirm:Dock( BOTTOM )

	confirm.DoClick = function()

		GetConVar( "gmt_hattext" ):SetString( string.Replace( util.TableToJSON( text ), "\"", "'" ) )
		hat:Close()

	end

end)