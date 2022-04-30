AddCSLuaFile()

ENT.PrintName = "Theater Preview"

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.Model = Model( "models/props_junk/popcan01a.mdl" )

if SERVER then

    function ENT:KeyValue( key, value )
        if key == "theater" then
            self:SetNWString( "theater", value )
        elseif key == "width" then
            self:SetNWInt( "width", tonumber(value) )
        elseif key == "height" then
            self:SetNWInt( "height", tonumber(value) )
        end
    end

end

function ENT:Initialize()
    self:SetModel(self.Model)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)

    self.TheaterID = self:GetNWString( "theater" )

    self.Width = self:GetNWInt("width", 79)
    self.Height = self:GetNWInt("height", 82)
end

if CLIENT then

    local TheaterStatic = Material("theater/static")

    function ENT:DrawTranslucent()
        if !GTowerTheater.PreviewsEnabled:GetBool() then return end

        local imgui = GTowerUI.imgui
    
        if !GTowerTheater.data[self.TheaterID] then return end

        local thumb = GTowerTheater.data[self.TheaterID].thumbMat or TheaterStatic
        local title = GTowerTheater.data[self.TheaterID].title or 0

        local s = .2
        local w, h = self.Width, self.Height

        if w > 95 then
            self._Long = true
        end

        w, h = w/s, h/s

        local thumbH, thumbW = 720, 1280

        local fontS = 50
        local font = imgui.xFont("!Roboto@"..fontS)

        local font2S = 24
        local font2 = imgui.xFont("!Roboto@"..font2S)

        if imgui.Entity3D2D(self, Vector(0,0,0), Angle(0, 0, 90), s, 4096, 2048) then

            if thumb != 0 then                
                if self._Long || thumb:Width() != 2048 then
                    draw.Rectangle( 0, 0, w, h, color_white, thumb, true )
                else
                    draw.OffsetTexture( 0, 0, w, h, (thumbW/2)-(thumbH/2), 0, thumbH, thumbH, color_white, thumb, true )
                end
                
                draw.Rectangle( 0, 0, w, h, Color( 0,0,0,100 ) )
                draw.GradientBox( 0, 0, w, h, Color( 0,0,0,255 ), DOWN )

                local y = h - fontS/2 - 40

                draw.Rectangle( 0, y-(fontS/2), w, fontS+font2S, Color( 0,0,0,175 ) )
                draw.SimpleText( "NOW PLAYING", font, w/2, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                draw.SimpleText( string.reduce2(title, font2, w-35), font2, w/2, y+(fontS/2)+6, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            else
                draw.Rectangle( 0, 0, w, h, color_white, TheaterStatic, true )

                local y = h/2

                draw.RectCenter( w/2, y, w, fontS, Color( 0,0,0,175 ) )
                draw.SimpleText( "No Video Playing", font, w/2, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end

            //draw.SimpleText( "TheaterID: " .. (self.TheaterID or 0) )
            //draw.SimpleText( "Title: " .. (title or 0), nil, 0, 15 )
            //draw.SimpleText( "Thumb: " .. (tostring(self._Thumbnail)), nil, 0, 30 )

            imgui.ExpandRenderBoundsFromRect(0, 0, w, h)
            imgui.End3D2D()
        end
    end

end