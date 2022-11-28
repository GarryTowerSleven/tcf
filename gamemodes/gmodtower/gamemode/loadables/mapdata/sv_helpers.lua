module( "MapData", package.seeall )

BeachChairColors = {
	Color( 230, 25, 75 ),	-- Red
	Color( 60, 180, 75 ),	-- Green
	Color( 255, 225, 25 ),	-- Yellow
	Color( 0, 130, 200 ),	-- Blue
	Color( 245, 130, 48 ),	-- Orange
	Color( 145, 30, 180 ),	-- Purple
	Color( 70, 240, 240 ),	-- Cyan
	Color( 240, 50, 230 ),	-- Magenta
	Color( 210, 245, 60 )	-- Lime
}

function GetNearestCondo( pos )

	local doors = {}

	for _, v in ipairs( ents.FindByClass("gmt_condo_door") ) do
		if v:GetCondoDoorType() == 1 then
			doors[v] = v:GetPos():Distance(pos)
		end
	end

	local value = unpack( doors )
	local door = table.KeyFromValue( doors, value )

	if !IsValid(door) then return end

	return door:GetCondoID()

end

function AddCondoCamera( pos, ang )
	local cam = ents.Create("gmt_condo_camera")
	cam:SetPos( pos )
	cam:SetAngles( ang )
	cam:Spawn()

	cam:SetNWInt( "Condo", (GetNearestCondo( pos ) or 0) )
end

function AddSeat( model, pos, angle, skin, color )
	local seat = ents.Create( "prop_physics_multiplayer" )
	seat:SetPos( pos )
	seat:SetAngles( angle )
	seat:SetModel( model )
	seat:SetSkin( skin )
	seat:Spawn()
  
	seat:SetKeyValue("spawnflags",2)
  
	if model == "models/map_detail/beach_chair.mdl" then
		seat:SetColor( table.Random( BeachChairColors ) )
	end
  
	if color != Color(255, 255, 255) then
		seat:SetColor( color )
	end
  
	seat:SetSaveValue("fademindist", 2048)
	seat:SetSaveValue("fademaxdist", 4096)

	local phys = seat:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end
end

function AddModel( model, pos, ang, shadow )

	if !model then return end

	if !pos then
		print("Not spawning map model " .. model .. ". No position specified.")
		return
	end

	local e = ents.Create("prop_dynamic")
	e:SetPos( pos )
	e:SetAngles( ang or Angle(0,0,0) )
	e:SetModel( model )
	e:Spawn()

	e:DrawShadow( shadow or true )
end

function AddEntity( class, pos, ang )

	if !class then return end

	if !pos then
		print("Not spawning map entity " .. class .. ". No position specified.")
		return
	end

	local e = ents.Create( class )
	e:SetPos( pos )
	e:SetAngles( ang or Angle(0,0,0) )
	e:Spawn()
end

function AddTheaterPreview( loc, ang, key, w, h )
	local preview = ents.Create("gmt_theater_preview")
	preview:SetPos( loc )
	preview:SetAngles( ang or Angle( 0,0,0 ) )
	preview:SetKeyValue( "theater", key )
	preview:SetKeyValue( "width", tostring(w) or "79" )
	preview:SetKeyValue( "height", tostring(h) or "82" )
	preview:Spawn()
end

function NetworkCondoPanelIDs()
	for k,v in pairs(ents.FindByClass("gmt_condo_panel")) do
		local entloc = Location.Find( v:GetPos() )
		local condoID = entloc

		v:SetNWInt( "condoID", condoID )
	end
end

function SpawnCondoPlayers()
	for k,v in pairs(ents.FindByClass("gmt_roomloc")) do
		local entloc = Location.Find( v:GetPos() )
		local condoID = entloc

		local e = ents.Create("gmt_condoplayer")
		e:SetPos(v:GetPos())
		e:Spawn()
		e:SetNWInt( "condoID", condoID )

		e:SetNoDraw(true)
		e:SetSolid(SOLID_NONE)
	end
end

function RePosition( class, pos, ang, respawn )
	local entities = ents.FindByClass( class )
	
	if ( table.Count( entities ) > 1 ) then
		return
	end

	local ent = entities[1]
	local ent_old = nil

	local pos = pos or ent:GetPos()
	local ang = ang or ent:GetAngles()

	if ( respawn ) then
		ent_old = ent
		ent = ents.Create( ent_old:GetClass() )
	end

	ent:SetPos( pos )
	ent:SetAngles( ang )

	if ( respawn ) then
		ent:Spawn()
		ent_old:Remove()
	end
end