include("shared.lua")

local KeyMat = Material("gmod_tower/ui/key.png")

local FadeSpeed = 350

hook.Add( "HUDPaint", "PaintHints", function()

  local Position, Key, Message

  for k,v in pairs( HintLocations ) do
    local Position, Key, Message = v[1], v[2], v[3]

    local dist = LocalPlayer():GetPos():Distance(Position)

    v.FadeOut = false

    if dist > 750 or dist < 250 then
      v.FadeOut = true
      v.Visible = false
    end

    if !v.StartAlpha then
      v.StartAlpha = 0
    end

    if v.FadeOut then
      v.HeightOffset = (v.HeightOffset or 0) + (FrameTime() * 150)
      v.StartAlpha = math.Clamp(v.StartAlpha - (FrameTime() * (FadeSpeed*2)), 0, 255)
      --if v.Sound then v.Sound = false end
    else
      v.HeightOffset = 0

      if !v.Sound then
        v.Sound = true
        surface.PlaySound("gmodtower/ui/beepclear.wav")
      end

      v.StartAlpha = math.Clamp(v.StartAlpha + (FrameTime() * FadeSpeed), 0, 255)
    end

    v.Visible = true

    local sPos = Position:ToScreen()

    sPos.x = math.Clamp( sPos.x, 50, ScrW() - 50 )
    sPos.y = math.Clamp( sPos.y, 50, ScrH() - 50 )

    surface.SetDrawColor( 0, 0, 0, math.Clamp( v.StartAlpha, 0, 150 ) )

    local w = 60 --+ dist/ScrW()
    local h = 60 --+ dist/ScrH()
    local x = sPos.x - (w/2)
    local y = sPos.y - (h/2) + (v.HeightOffset or 0)

    local padding = 5

    surface.DrawRect( x-padding, y-padding, w+padding*2, h+padding*2 )
    surface.SetDrawColor( 255, 255, 255, v.StartAlpha )
    surface.SetMaterial(KeyMat)
    surface.DrawTexturedRect( x, y, w, h )
    draw.DrawText(Message,"GTowerSkyMsgSmall",x+w+8,y-(h/8),Color( 255, 255, 255, v.StartAlpha ),TEXT_ALIGN_LEFT)
    draw.DrawText(Key,"GTowerSkyMsgSmall",x+(w/2),y-(h/8),Color( 15, 15, 15, v.StartAlpha ),TEXT_ALIGN_CENTER)

  end
end)
