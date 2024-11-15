function GM:NewSaturn() //setup the timer

	self.SaturnSpawn = CurTime() + math.random( 20, 60 )
	
end

/*local function InMap( pos, min, max )
	return pos.x > min.x and pos.y > min.y and pos.z > min.z and
           pos.x < max.x and pos.y < max.y and pos.z < max.z
end

local function SaturnInMap( map )

	if map == "gmt_uch_tazmily" then
	
		local min = Vector( 0, 0, 0 )
		local max = Vector( 0, 0, 0 )
		local saturn = ents.FindByClass( "mr_saturn" )[1]
		local pos = saturn:GetPos()
		
		if !InMap( pos, min, max ) then
			saturn:Remove()
		end

	end

end*/

hook.Add( "Think", "SaturnThink", function()

	local alive = #team.GetPlayers( TEAM_PIGS )
	local amount = player.GetCount() - 1

	if GAMEMODE:IsPlaying() && !GAMEMODE.SpawnedSaturn then

		if amount <= 3 || alive <= amount / 2 then

			GAMEMODE:NewSaturn()
			GAMEMODE.SpawnedSaturn = true

		elseif GAMEMODE:GetTimeLeft() <= 30 then

			GAMEMODE:SpawnSaturn()
			GAMEMODE.SpawnedSaturn = true

		end

	end

	if GAMEMODE.SaturnSpawn then

		if !GAMEMODE:IsPlaying() then

			GAMEMODE.SaturnSpawn = nil
			return

		end
	
		if GAMEMODE.SaturnSpawn < CurTime() then

			GAMEMODE.SaturnSpawn = nil
			GAMEMODE:SpawnSaturn()

		end

	end
	
end )

function GM:ActiveSaturn() //is there a saturn on the map?

	local satnum = #ents.FindByClass( "mr_saturn" ) + #ents.FindByClass( "saturn_held" )
	
	return satnum >= 1
	
end

function GM:SpawnSaturn()  //actually spawn him

	if !self:IsPlaying() then return end //game ended, don't spawn him
	if self:ActiveSaturn() then return end  //whoops, seems there's already a saturn on the map

	local spawns = ents.FindByClass( "info_player*" )
	//spawns = table.Add( spawns, ents.FindByClass( "chimera_spawn" ) )
	
	local availspawns = {}
	
	for _, ent in ipairs( spawns ) do
	
		if self:IsValidSpawn( ent ) then
			table.insert( availspawns, ent )
		end
		
	end

	local spawn = spawns[ math.random( #spawns ) ]

	if #availspawns > 0 then
		spawn = availspawns[ math.random( #availspawns ) ]
	end

	local radius = 50

	local area = table.Random(navmesh.GetAllNavAreas())
	local areapos

	for i = 1, 128 do

		if areapos then continue end
		
		local pos = area:GetRandomPoint() + Vector( 0, 0, 8 )

		if !util.TraceHull({
			start = pos,
		endpos = pos,
		mins = Vector( -16, -16, 0 ),
		maxs = Vector( 16, 16, 32 )
		}).Hit then

			areapos = pos

		end

	end

	local pos = areapos || spawn:GetPos() + Vector( math.random( -radius, radius ), math.random( -radius, radius ), 5 )
	
	local saturn = ents.Create( "mr_saturn" )
	if IsValid( saturn ) then

		saturn:SetPos( pos )
		saturn:Spawn()
		saturn:Activate()

	end

	for _,ply in ipairs( player.GetAll() ) do
	
		self:HUDMessage( ply, MSG_MRSATURN, 6 )
		self:SetMusic( ply, MUSIC_MRSATURN )

	end

end