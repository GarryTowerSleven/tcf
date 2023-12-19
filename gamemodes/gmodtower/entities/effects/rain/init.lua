local raindrop = Material( "particle/warp2_warp" )
local raindrop2 = Material( "particle/water/waterdrop_001a" )

local rain = {}
local drops = {}
local drops2 = {}
local drop_color = Color( 255, 255, 255, 5 )
local rain_amount = 0

function EFFECT:Init( data )

    local flags = data:GetFlags()
    local raining = flags == 1
    local suite = flags == 3
    local outside = flags == 4
	local pos = data:GetOrigin()
	local amount = outside && 128 || suite && 8 || rain && 32 || 16

    if raining then

        if !IsValid(WEmitter) then
            WEmitter = ParticleEmitter(LocalPlayer():GetPos())
        end
    
        local emitter = WEmitter
    
        if !IsValid(WEmitter) then return end
        if #rain >= 250 then return end
    
        local ply = LocalPlayer()
        local pos = LocalPlayer():GetPos()
        local vel = Vector(64, 64, -1000)
        local amount = 16
    
        for i1 = 0, amount do

            if math.random(2) == 1 then continue end
    
            for i = 1, 1 do

                local dir = Angle(0, math.random(-180, 180), 0):Forward() * (Lerp(i / amount, 128, 2048) + math.random(-200, 256))
                local rpos = Vector(pos.x + dir.x, pos.y + dir.y, pos.z + math.random(900, 950))
                local particle = emitter:Add("particle/water/waterdrop_001a", rpos)
    
                if !util.QuickTrace(util.QuickTrace(rpos, vel, LocalPlayer()).HitPos, Vector(0, 0, 10000), ents.GetAll()).HitSky then continue end
    
                table.insert(rain, {
                    Start = rpos,
                    End = util.QuickTrace(rpos, vel, LocalPlayer()).HitPos,
                    Time = CurTime() + 0.75
                })
    
                // debugoverlay.Line(util.QuickTrace(rpos, Vector(0, 0, -1024), LocalPlayer()).HitPos, util.QuickTrace(rpos, Vector(0, 0, -1024), LocalPlayer()).HitPos + Vector(0, 0, 8), 1, color_white)
                
            end
    
        end

        return

    end


	local emitter = ParticleEmitter( pos )

	for i = 0, amount do

		local particle = emitter:Add( rain && "particle/rain" || "particle/snow", pos + Vector(math.random(-256, 256), math.random(-256, 256), 0) * (outside && 8 || 1) )

		if ( particle ) then

			particle:SetDieTime( suite && 6 || 18 )
			particle:SetStartAlpha( outside && 200 || 100 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 2 )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand( 0, 360 ) )
			particle:SetRollDelta( math.Rand( -200, 200 ) )
			particle:SetAirResistance( outside && 200 || 400 )
			particle:SetGravity( Vector( math.random(-100, 100), math.random(-100, 100), -800 ) )
            particle:SetCollide( true )

		end

	end

	emitter:Finish()

end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end

hook.Add( "PostDrawTranslucentRenderables", "Rain", function()

    render.SetBlend( 0.5 )
    render.SetMaterial( raindrop2 )

    local ply = LocalPlayer()

    for i, rain2 in ipairs(rain) do

        local t = ( rain2.Time - CurTime() ) / 0.75
        local start = LerpVector( t, rain2.End, rain2.Start )
        local endpos = LerpVector( t + 0.1, rain2.End, rain2.Start ) // start - Vector(0, 0, 64)

        render.DrawBeam(start, endpos, Lerp(t, 4, 2), 0.9, 1, Color(75, 75, 75, Lerp(t, 75, 25)))

        if rain2.Time < CurTime() then

            table.remove( rain, i )

            if math.random( 20 ) == 1 then

                sound.Play( "ambient/water/rain_drip" .. math.random(4) .. ".wav", rain2.End, 70, math.random( 65, 85 ), 0.4 )

            end

        end

    end
    
    render.SetBlend( 1 )

end)