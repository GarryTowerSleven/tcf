SPAWN_WAITING = 1
SPAWN_STARTLINE = 2
SPAWN_LOSERS = 3
SPAWN_1ST = 4
SPAWN_2ND = 5
SPAWN_3RD = 6

/*function GM:SetupSpawns()

	self.Spawns = {

		[SPAWN_WAITING] = ents.FindByClass( "gr_spawn_waiting" ),
		[SPAWN_STARTLINE] = ents.FindByClass( "gr_spawn_start" ),
		[SPAWN_LOSERS] = ents.FindByClass( "gr_spawn_losers" ),
		[SPAWN_1ST] = ents.FindByClass( "gr_spawn_1st" )[1],
		[SPAWN_2ND] = ents.FindByClass( "gr_spawn_2nd" )[1],
		[SPAWN_3RD] = ents.FindByClass( "gr_spawn_3rd" )[1],

	}

end*/

local function RandomSpawn( array )

	local spawns = ents.FindByClass( array )
	return spawns[ math.random( 1, #spawns ) ]

end

function GM:SetSpawn( idx, ply )

	local spawn
	
	//spawn = self.Spawns[idx]
	//spawn = self.Spawns[idx][ math.random( 1, #self.Spawns[idx] ) ]

	if idx == SPAWN_1ST then

		spawn = ents.FindByClass( "gr_spawn_1st" )[1]

	elseif idx == SPAWN_2ND then

		spawn = ents.FindByClass( "gr_spawn_2nd" )[1]

	elseif idx == SPAWN_3RD then

		spawn = ents.FindByClass( "gr_spawn_3rd" )[1]

	elseif idx == SPAWN_WAITING then

		spawn = RandomSpawn( "gr_spawn_waiting" )

	elseif idx == SPAWN_STARTLINE then

		spawn = RandomSpawn( "gr_spawn_start" )

	elseif idx == SPAWN_LOSERS then
	
		spawn = RandomSpawn( "gr_spawn_losers" )

	end

	if IsValid( spawn ) && IsValid( ply ) then

		ply:SetPos( spawn:GetPos() )

	end

end

function GM:SetAllSpawn( idx )

	for _,ply in ipairs( player.GetAll() ) do
	
		self:SetSpawn( idx, ply )
	
	end
	
end

function GM:SetRankSpawn( ply )

	if ply:GetNet( "Rank" ) == 1 then

		self:SetSpawn( SPAWN_1ST, ply )
		return
		
	end

	if ply:GetNet( "Rank" ) == 2 then

		self:SetSpawn( SPAWN_2ND, ply )
		return
		
	end

	if ply:GetNet( "Rank" ) == 3 then

		self:SetSpawn( SPAWN_3RD, ply )
		return

	end

	self:SetSpawn( SPAWN_LOSERS, ply )

end