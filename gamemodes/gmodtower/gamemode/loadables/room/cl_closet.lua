GTowerRooms.ClosetEnts = {}
GTowerRooms.MovingEnts = {}
GTowerRooms.ClosetRoom = nil
GTowerRooms.RefEnt = nil

hook.Add("Location", "GTowerRoomCloset", function( ply, location )

	if ply != LocalPlayer() then
		return
	end
	
	if GTowerRooms.ClosetRoom == location then
		return
	end
	
	for k, v in pairs( Location.GetSuiteLocations() ) do
		local loc = Location.GetLocationByIndex( v )
		if !loc || !loc.SuiteID then continue end

		if v == location then
			timer.Create( "GTowerRoomCloset", 2.0, 1, function() GTowerRooms.PrepareCloset( loc.SuiteID ) end )
			return
		end
	end

	
	GTowerRooms:CleanCloset()
	
end )

function GTowerRooms.PrepareCloset( room )
	
	GTowerRooms:CleanCloset()

	GTowerRooms:FindRefEnts()
	
	local MapData = GTowerRooms.RoomMapData[ game.GetMap() ]
	local RoomData = GTowerRooms:Get( room )
	GTowerRooms.ClosetEnts = {}
	
	if !MapData || !MapData.closethats then 
		Msg("GTowerRooms: Closet: Something was not data for map\n")
		return 
	end
	
	if !IsValid( RoomData.RefEnt ) then 
		Msg("GTowerRooms: Closet: Entity not found\n")
		return 
	end
	
	if !RoomData.Hats then
		Msg("GTowerRooms: Closet: Not hat data found\n")
		return
	end
	
	local function CanCreateHats()
		for hatid, tbl in pairs( Hats.List ) do
			if RoomData.Hats[ hatid ] == true && hatid != 0 then
				return true
			end
		end
		return false
	end
	
	if CanCreateHats() == false then
		return
	end
	
	GTowerRooms.RefEnt = RoomData.RefEnt
	GTowerRooms.BaseAngle = GTowerRooms.RefEnt:GetAngles()
	
	GTowerRooms.BaseAngle:RotateAroundAxis( GTowerRooms.BaseAngle:Up(), 180 )
	
	for k, v in pairs( MapData.closethats ) do
		OrderVectors( v[1], v[2] )
		
		local NewPos, PosDir
		local HatList = {}
		
		NewPos = Vector( 
			(v[1].x + v[2].x) / 2,
			v[1].y,
			(v[1].z + v[2].z) / 2
		)
		
		PosDir = Vector(
			0,
			v[1].y - v[2].y,
			0
		)
		
		PosDir:Rotate( GTowerRooms.BaseAngle )
		
		for hatid, tbl in pairs( Hats.List ) do
			if tbl.closetrow == k && RoomData.Hats[ hatid ] == true then
				HatList[ hatid ] = tbl
			end
		end
		
		local Min, Max = GTowerRooms.RefEnt:LocalToWorld( v[1] ), GTowerRooms.RefEnt:LocalToWorld( v[2] )
		
		OrderVectors( Min, Max )
		
		table.insert( GTowerRooms.ClosetEnts, { 
			StartPos =	GTowerRooms.RefEnt:LocalToWorld( NewPos ), 
			PosDir   = 	PosDir, 
			HatList  =	HatList,
			Min = Min,
			Max = Max,
			Ents = {}
		} )
		
		if GTowerRooms.DEBUG then
			// DEBUG:Box( GTowerRooms.RefEnt:LocalToWorld(v[1]), GTowerRooms.RefEnt:LocalToWorld(v[2]) )
		end
	end
	
	for _, v in pairs( GTowerRooms.ClosetEnts ) do
	
		local HatCount = table.Count( v.HatList ) + 1
		local Count = 1
		
		for id, hat in pairs( v.HatList ) do
		
			local ent = ClientsideModel( hat.model,  RENDERGROUP_TRANSLUCENT )
			local RenderMin, RenderMax = ent:GetRenderBounds()
			
			local StartTracePos =  v.StartPos + v.PosDir * ( Count / HatCount )
			local Trace = util.QuickTrace( StartTracePos, Vector(0,0,-200) )
			local EntPos  = Trace.HitPos + Vector(0,0, -RenderMin.z + 0.15) + (GTowerRooms.BaseAngle:Forward() * (hat.MoveForward or 0))
			
			ent:SetPos( EntPos )
			ent:SetAngles( GTowerRooms.BaseAngle + Angle( 0, hat.rotation or 0, 0 ) )
			
			ent.UniqueName = 	hat.unique_name
			ent.HatId = id
			ent.MaxRad = 		ent:OBBMaxs():Length()
			ent.ExtraRot = hat.rotation or 0
			ent.Slot = hat.slot
			
			if hat.ModelSkin then
				ent:SetSkin( hat.ModelSkin )
			end
			
			ent:Spawn()
			
			table.insert( v.Ents, ent )
			
			if GTowerRooms.DEBUG then 
				// DEBUG:Box( StartTracePos + Vector(-2,-2,-2), StartTracePos + Vector(2,2,2) )
				// DEBUG:Box( EntPos + Vector(-1,-1,-1), EntPos + Vector(1,1,1) )
				Msg("Room closet: Creating ent: " .. tostring( ent ) .. "( " .. tostring(Trace.HitPos) .. " )\n")
			end
			
			Count = Count + 1

		end		
	end
	

	GTowerRooms.ClosetRoom = room
	hook.Add("Think", "GTowerRoomCloset", GTowerRooms.ClosetThink )
	hook.Add("KeyPress", "GTowerRoomClosetPress", GTowerRooms.ClosetKeyPress )
	
end

function GTowerRooms:CleanCloset()

	timer.Destroy("GTowerRoomCloset")

	if GTowerRooms.ClosetRoom then
		for _, v in pairs( GTowerRooms.ClosetEnts ) do
			for _, ent in pairs( v.Ents ) do
				ent:Remove()
			end
		end
		
		GTowerRooms.ClosetEnts = {}
		GTowerRooms.MovingEnts = {}
		GTowerRooms.RefEnt = nil
		hook.Remove("Think", "GTowerRoomCloset")
		hook.Remove("KeyPress", "GTowerRoomClosetPress")
	end
	
end


function GTowerRooms:GetEyeHat( ply )
	if !IsValid(LocalPlayer()) then return nil end

	local EyeTrace = LocalPlayer():GetEyeTrace()
	
	for k, v in pairs( GTowerRooms.ClosetEnts ) do
	
		if GTowerRooms.PosInBox and GTowerRooms.PosInBox( EyeTrace.HitPos, v.Min, v.Max ) then
		
			local LowestDistance = 2048
			local LowEnt = nil
			
			for _, ent in pairs( v.Ents ) do
				if IsValid( ent ) then
					local Dis = ent:GetPos():Distance( EyeTrace.HitPos )
				
					if Dis < 18 && Dis < LowestDistance then
						LowestDistance = Dis
						LowEnt = ent
					end
				end			
			end
			
			return LowEnt			
		end
	end

end

function GTowerRooms:EmitClosetParticle( ent )

	local emitter = ParticleEmitter( ent:GetPos() )	
	local particle = emitter:Add( "sprites/pickup_light", ent:GetPos() + ( VectorRand() * ( ent.MaxRad or 0 ) ) )
        
	if particle then
		particle:SetVelocity( VectorRand() * math.max( ent:BoundingRadius(), 5 ) )
		particle:SetDieTime( math.Rand( 1, 3 ) )
		particle:SetStartAlpha( 100 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 12 )
		particle:SetEndSize( 0 )
		particle:SetCollide( true )
		particle:SetRoll( math.Rand( 0, 360 ) )
		particle:SetRollDelta( math.Rand( -5.5, 5.5 ) )
		if ent.HatId == 0 then
			particle:SetColor( 255, 70, 90 )
		else
			particle:SetColor( 90, 70, 255 )
		end
	end
	
	emitter:Finish()

end

local NextParticleCloset = 0
local NextEntityExist = 0
function GTowerRooms:ClosetThink()

	if CurTime() > NextEntityExist then
		
		for _, v in  pairs( GTowerRooms.ClosetEnts ) do
			for _, ent in pairs( v.Ents ) do
				
				if !IsValid( ent ) then
					Msg("A closet ent is gone! Recreating closet ents!") 
				
					GTowerRooms:PrepareCloset( GTowerRooms.ClosetRoom )
					
					return
				end
				
			end			
		end
		
		NextEntityExist = CurTime() + 10.0
	end
	
	local ent = GTowerRooms:GetEyeHat( GTowerRooms:RoomOwner( GTowerRooms.ClosetRoom ) or LocalPlayer() )
	local Addangle = Angle( 0, 270 * FrameTime(), 0 )
	
	if ent then
		ent:SetAngles( ent:GetAngles() + Addangle )
		
		if !table.HasValue( GTowerRooms.MovingEnts, ent ) then
			table.insert( GTowerRooms.MovingEnts, ent )
		end
		
		if CurTime() > NextParticleCloset then
			NextParticleCloset = CurTime() + 0.1
			GTowerRooms:EmitClosetParticle( ent )
		end
		
	end
	
	for k, v in pairs( GTowerRooms.MovingEnts ) do
		if v != ent then
			local NewAngle = v:GetAngles() + Addangle
			
			if math.abs( math.NormalizeAngle( NewAngle.y ) - (GTowerRooms.BaseAngle.y+v.ExtraRot) ) < 4 then
				table.remove( GTowerRooms.MovingEnts, k )
				v:SetAngles( GTowerRooms.BaseAngle + Angle( 0, v.ExtraRot, 0 ) )
			else
				v:SetAngles( NewAngle )
			end
		end	
	end
	
end

local NextHatEntUse = 0

GTowerRooms.ClosetKeyPress = function( ply, press )
	
	if GTowerRooms:RoomOwner( GTowerRooms.ClosetRoom ) == LocalPlayer() && ply == LocalPlayer() && press == IN_USE then
	
		local ent = GTowerRooms:GetEyeHat( ply )

		if IsValid( ent ) && CurTime() > NextHatEntUse then
			if ent.HatId == 0 then
				RunConsoleCommand("gmt_sethat", 0, SLOT_HEAD )
				RunConsoleCommand("gmt_sethat", 0, SLOT_FACE )
			else
				RunConsoleCommand("gmt_sethat", ent.HatId, ent.Slot )
			end

			NextHatEntUse = CurTime() + 1.2
		end
		
	end

end

hook.Add("GtowerMouseEnt", "RoomClosetSetHat", function( entity, mc )
	
	if GTowerRooms:RoomOwner( GTowerRooms.ClosetRoom ) == LocalPlayer() then
	
		local ent = GTowerRooms:GetEyeHat( ply )

		if IsValid( ent ) && CurTime() > NextHatEntUse then
			if ent.HatId == 0 then
				RunConsoleCommand("gmt_sethat", 0, SLOT_HEAD )
				RunConsoleCommand("gmt_sethat", 0, SLOT_FACE )
			else
				RunConsoleCommand("gmt_sethat", ent.HatId, ent.Slot )
			end

			NextHatEntUse = CurTime() + 1.2

			return true
		end
		
	end

end )