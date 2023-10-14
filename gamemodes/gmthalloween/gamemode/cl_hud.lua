local function CanPlayerUse( arg1, arg2 )

	local ply, ent
	if CLIENT and !IsValid( arg2 ) then

		-- one argument can only be done clientside
		ply = LocalPlayer()
		ent = arg1

	else

		-- two args: ply and ent
		ply = arg1
		ent = arg2

	end
	if !IsValid( ply ) or !IsValid( ent ) then return nil end

	if ply:InVehicle() then return nil end
	if ent.HideTooltip then return nil end

	local class = ent:GetClass()

	-- Seats
    if seats and seats.ChairOffsets[ ent:GetModel() ] then return "SIT" end

	-- Support custom entities
	if ent.CanUse then
		local enter, message = ent:CanUse( ply )
		return message, not enter
	end

	-- Any props should be ignored
	if class == "prop_physics" or class == "prop_dynamic" or class == "prop_dynamic_override" then
		return nil
	end

	-- Just in case
	if ent.OnUse then
		return "USE"
	end

	return nil

end

local function PlayerUseTrace( ply, filter )

	if !filter then
		filter = ply
	end

	local pos = ply:EyePos()
	local trace = util.TraceLine({
		["start"] = pos, 
		["endpos"] = pos + ( ply:GetAimVector() * 96 ), 
		["filter"] = filter
	})

	return trace.Entity

end

local function DrawUseMessage( ent, x, w, h )

	if not IsValid( ent ) then return end

	local use, nokey = CanPlayerUse( ent )
	if not use then return end

	if use then

        surface.SetFont( "GTowerHUDMain" )
        local tw, th = surface.GetTextSize(use)
        local offset = -(tw/2)

        if not nokey then

            local usekey = string.upper( input.LookupBinding( 'use' ) or "e" )

            surface.SetFont( "GTowerHUDMainLarge" )
            tw, th = surface.GetTextSize(usekey)
            tw = math.max(tw+8,th)
            offset = tw/2

            surface.SetDrawColor( 0, 0, 0, 200 )
            surface.DrawRect( w + x - tw/2, h - th/2 + 2, tw, th )

            draw.SimpleText( usekey, "GTowerHUDMainLarge", w + x, h - th/2, Color( 255, 255, 255, 255 ), 1 )

        end

        draw.SimpleShadowText( use, "GTowerHUDMain", w + x + 4 + offset, h, Color( 255, 255, 255, 255 ), Color( 0, 0, 0, 230 ), TEXT_ALIGN_LEFT, 1, 1 )

	end

end

hook.Add( "HUDPaint", "UsePrompts", function()

    local ent = PlayerUseTrace( LocalPlayer() )
	if IsValid( ent ) and CanPlayerUse( ent ) then
		DrawUseMessage( ent, 0, ScrW() / 2, ScrH() / 2 )
		return
	end

end )