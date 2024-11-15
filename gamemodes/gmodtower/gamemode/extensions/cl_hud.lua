surface.CreateFont( "TargetIDText", { font = "Impact", size = 32, weight = 500, antialias = true } )
surface.CreateFont( "TargetIDTextSmall", { font = "Impact", size = 20, weight = 500, antialias = true } )

local static = CreateClientConVar( "gmt_targetid_static", 0, true, false, false, 0, 1 )
local classic = CreateClientConVar( "gmt_targetid_classic", 0, true, false, false, 0, 1 )

local function ShouldDrawClassic()
	return classic:GetBool() or LocalPlayer():GetNWBool( "InLimbo" )
end

local function ShouldDrawStatic()
	return ShouldDrawClassic() or static:GetBool()
end

HudToHide = {}
function GM:HUDShouldDraw( name )
	return !table.HasValue( HudToHide, name )
end

local DrawnPlayerNames = {}
local DrawPlayerNamesFor = 2 -- 2 seconds
local DrawPlayerDist = 500

local function GetValidPlayer( ent )

	if not IsValid( ent ) or ent:GetNoDraw() or ent:GetColor().a == 0 then return end

	local ply = nil

	-- Get normal player
	if ent:IsPlayer() and ent.Name then
		ply = ent
	end

	-- Get vehicle owner players
	if ent:IsVehicle() or ent.Drivable then
		local owner = ent:GetOwner()
		if IsValid( owner ) && owner:IsPlayer() and owner.Name then
			ply = owner
		end
	end

	return ply

end

function GM:HUDDrawPlayerName( ply, fade, remain, x, y )

	if not IsValid( ply ) then return end

	local classic_draw = ShouldDrawClassic()

	local text = "ERROR"
	local font = classic_draw and "TargetID" or "TargetIDText"
	local opacity = 1

	-- Fade based on distance
	if fade then

		local dist = LocalPlayer():GetPos():Distance( ply:GetPos() )
		if ( dist >= DrawPlayerDist ) then return end // no need to draw anything if the player is far away
		opacity = math.Fit( dist, 100, DrawPlayerDist, 1, 0 )

	end

	-- Fade based on time
	if remain then
		opacity = 1-remain
	end

	-- Get player name
	text = ply:Name()

	-- Get position
	local pos = { x = 0, y = 0 }

	if x and y then
		pos = { x = x, y = y }
	else 
		pos = util.GetCenterPos( ply ):ToScreen()
	end

	-- Append AFK
	if ply:GetNet("AFK") then
		text = "*AFK* " .. text
	end
	
	-- Draw text shadow
	draw.SimpleText( text, font, pos.x+1, pos.y+1, Color( 0, 0, 0, 120 * opacity ), TEXT_ALIGN_CENTER )
	draw.SimpleText( text, font, pos.x+2, pos.y+2, Color( 0, 0, 0, 50 * opacity ), TEXT_ALIGN_CENTER )

	-- Get color
	local color = Color( 255, 255, 255 )
	if ply.GetDisplayTextColor then color = ply:GetDisplayTextColor() end -- Get display color
	local realcolor = Color( color.r, color.g, color.b, color.a * opacity )

	-- Draw name
	draw.SimpleText( text, font, pos.x, pos.y, realcolor, TEXT_ALIGN_CENTER )

	if classic_draw then return end

	-- Lobby HUD
	if IsLobby then

		-- Show Rank
		local respect = ply:GetRespectName()
		if respect then
			draw.SimpleText( respect, "TargetIDTextSmall", pos.x, pos.y + 28, realcolor, TEXT_ALIGN_CENTER )
		end

		-- Room number
		local roomid = ply:GetNet("RoomID")
		if roomid && roomid > 0 then
			local room = tostring( roomid ) or ""
			if room != "" then
				local dark = colorutil.Brighten( realcolor, .75 )
				surface.SetDrawColor( dark )
				surface.DrawRect( pos.x - 40, pos.y + 28 + 20, 80, 2 )
				draw.SimpleText( "SUITE " .. room, "TargetIDTextSmall", pos.x, pos.y + 28 + 20, dark, TEXT_ALIGN_CENTER )
			end
		end

	end

end

local function AddNewPlayerToDraw( ply )

	local add = true
	for id, plyname in pairs( DrawnPlayerNames ) do
		-- Update existing player name
		if plyname.ply == ply then
			plyname.time = RealTime()
			add = false
		end
	end

	if add then
		table.insert( DrawnPlayerNames, { ply = ply, time = RealTime() } )
	end

end

function GM:HUDDrawTargetID()

	-- Hide while the camera is out
	if LocalPlayer():IsCameraOut() then return end

	local draw_static = ShouldDrawStatic()
	local draw_classic = ShouldDrawClassic()

	if not draw_static then
		
		-- Draw all player names when Q is held
		if GTowerMainGui.MenuEnabled then
			if IsLobby then
				for _, ent in pairs( ents.GetAll() ) do
					local ply = GetValidPlayer( ent )
					if ply == LocalPlayer() or not ply then continue end
					self:HUDDrawPlayerName( ply, true )
				end
			end
		end

		-- Draw recently rolled over players
		if DrawnPlayerNames then
			for id, plyname in pairs( DrawnPlayerNames ) do

				-- Auto remove name
				if plyname.duration and plyname.duration >= 1 then
					table.remove( DrawnPlayerNames, id )
					continue
				end

				-- Draw the name
				if plyname.time then 
					plyname.duration = math.min( RealTime() - plyname.time, DrawPlayerNamesFor ) / DrawPlayerNamesFor
				end

				self:HUDDrawPlayerName( plyname.ply, false, plyname.duration )

			end
		end

	end

	-- Add new player to draw name tag of
	local tr = util.GetPlayerTrace( LocalPlayer(), draw_static and LocalPlayer():GetAimVector() or GetMouseAimVector() )
	local trace = util.TraceLine( tr )
	if (!trace.Hit) then return end
	if (!trace.HitNonWorld) then return end

	local ply = GetValidPlayer( trace.Entity )
	if ply and ply != LocalPlayer() then

		if draw_static then
			self:HUDDrawPlayerName( ply, false, nil, ScrW() / 2, ScrH() / 2 + ( draw_classic and 15 or 30) )

			return
		end

		AddNewPlayerToDraw( ply )
	end

end