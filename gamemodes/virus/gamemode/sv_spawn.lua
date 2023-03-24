function GM:LateJoin( ply )
	ply:SetTeam( TEAM_INFECTED )
	ply:SetNet( "IsVirus", true )
end

function GM:PlayerInitialSpawn( ply )

	hook.Call( "PlayerSetModel", GAMEMODE, ply )

	if self:GetState() <= 1 then
		if #player.GetAll() >= 1 && !ply:IsBot() then
			self:SetState( STATE_WAITING )
			self:SetTime( self.RoundTime )
		end
	end

	if self:GetState() == STATE_PLAYING then
		self:LateJoin( ply )

		music.Play( EVENT_PLAY, MUSIC_ROUNDPLAY, ply )
	end

	if self:GetState() == STATE_INTERMISSION then
		self:LateJoin( ply )
		self:PlayerFreeze( true, ply )

		music.Play( EVENT_PLAY, MUSIC_WAITING_FOR_INFECTION, ply )
	end

	if self:GetState() == STATE_WAITING then
		music.Play( EVENT_PLAY, MUSIC_WAITING_FOR_PLAYERS, ply )
	end

	self:ProcessRank( ply )

end

function GM:VirusSpawn( ply )

	local numVirus = team.NumPlayers( TEAM_INFECTED )
	
	local healthScale = math.Clamp( 15 * ( #player.GetAll() / numVirus ) + 30, 50, 100 )
	
	ply:SetModel( "models/player/virusi.mdl" )
	
	ply:SetWalkSpeed( self.VirusSpeed )
	ply:SetRunSpeed( self.VirusSpeed )
	
	ply:SetHealth( healthScale )
	ply:SetNet( "MaxHealth" , healthScale )
	
	ply:StripWeapons()
	ply:RemoveAllAmmo()
	
	ply:CrosshairDisable()
	
	if ( !ply:Alive() ) then
		ply:Spawn()
	end
	
	PostEvent( ply, "infection_on" )

	timer.Simple( 2, function()
		if IsValid( ply ) && ply:Alive() then
			local pos = ply:GetPos( ) + Vector( 0, 0, 50 )

			//flame OOOONNN!!
			//yeah fuck me leave it like this it looks fine
			if ( ply.Flame == nil ) then
				local sprite = ents.Create( "env_sprite" )
				sprite:SetPos( pos )
				sprite:SetKeyValue( "rendercolor", "70 255 70" )
				sprite:SetKeyValue( "renderamt", "150" )
				sprite:SetKeyValue( "rendermode", "5" )
				sprite:SetKeyValue( "renderfx", "0" )
				sprite:SetKeyValue( "model", "sprites/fire1.spr" )
				sprite:SetKeyValue( "glowproxysize", "32" )
				sprite:SetKeyValue( "scale", "0.4" )
				sprite:SetKeyValue( "framerate", "20" )
				sprite:SetKeyValue( "spawnflags", "1" )
				sprite:SetParent( ply )
				sprite:Spawn( )
				
				ply.Flame = sprite
				
				sprite = ents.Create( "env_sprite" )
				sprite:SetPos( pos )
				sprite:SetKeyValue( "rendercolor", "110 255 110" )
				sprite:SetKeyValue( "renderamt", "150" )
				sprite:SetKeyValue( "rendermode", "5" )
				sprite:SetKeyValue( "renderfx", "0" )
				sprite:SetKeyValue( "model", "sprites/fire1.spr" )
				sprite:SetKeyValue( "glowproxysize", "32" )
				sprite:SetKeyValue( "scale", "0.5" )
				sprite:SetKeyValue( "framerate", "14" )
				sprite:SetKeyValue( "spawnflags", "1" )
				sprite:SetParent( ply )
				sprite:Spawn( )
				
				ply.Flame2 = sprite
				
				ply:SetNetworkedEntity( "Flame1", ply.Flame )
				ply:SetNetworkedEntity( "Flame2", ply.Flame2 )
			end

			ply:EmitSound( "ambient/fire/ignite.wav", 75, 95, 1, CHAN_AUTO )
		end
	end )
	
	if ( IsValid( ply ) && ply:GetNet( "IsVirus" ) && ply:Deaths() == 2 && numVirus == 1 ) then
		self:HudMessage( nil, 19 /* Infected has become enraged */, 5 )
	end
	
end

/*hook.Add( "PlayerDeath", "PlayerIgnite", function( ply )
	if ( ply:GetNet( "IsVirus" ) ) then
		net.Start( "IgnitePlayer" )
			net.WriteEntity( ply )
			net.WriteBool( false )
		net.Broadcast()
	end
end )

util.AddNetworkString( "IgnitePlayer" )*/

function GM:HumanSpawn( ply )

	ply:SetWalkSpeed( self.HumanSpeed )
	ply:SetRunSpeed( self.HumanSpeed )

	ply:SetFrags( 0 )
	ply:SetDeaths( 0 )

	PostEvent( ply, "lastman_off" )
	PostEvent( ply, "infection_off" )
	ply._Shell = 0  // yeah yeah shell yourself

	local ViewModel = ply:GetViewModel()
	if IsValid( ViewModel ) then
		ViewModel:SetColor( Color( 255, 255, 255, 255 ) )
	end

end


function GM:PlayerSelectSpawn( ply )
 
    local spawns = ents.FindByClass( "info_player*" )
	local availspawns = {}
	
	for _, ent in ipairs( spawns ) do
	
		if self:IsValidSpawn( ent ) then
			table.insert( availspawns, ent )
		end
		
	end
	
	if #availspawns > 0 then
		return availspawns[ math.random( #availspawns ) ]
	else
		return spawns[ math.random( #spawns ) ]
	end
 
end

function GM:IsValidSpawn( ent )

	for _, v in ipairs( ents.FindInSphere( ent:GetPos(), 100 ) ) do
		return false
	end
	
	return true

end

function GM:PlayerSpawn( ply )

	if ( self:GetState() != STATE_PLAYING && !ply:GetNet( "IsVirus" ) ) then
		hook.Call( "PlayerSetModel", GAMEMODE, ply )
	end
	
	ply:SetJumpPower( 0 )
	ply:SetWalkSpeed( 300 )
	ply:SetRunSpeed( 300 )
	
	net.Start( "Spawn" )
	net.Send( ply )
	
	local vm = ply:GetViewModel()
	if IsValid( vm ) then
		vm:SetColor( Color( 255, 255, 255, 255 ) )
	end

	ply:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	
	if ( self:GetState() == STATE_WAITING ) then return end
	
	if ( ply.Flame != nil ) then
		ply.Flame:Remove()
		ply.Flame = nil
		
		ply.Flame2:Remove()
		ply.Flame2 = nil
	end

	if ( ply:GetNet( "IsVirus" ) ) then
		self:VirusSpawn( ply )
	else
		self:HumanSpawn( ply )
		if #ply:GetWeapons() == 0 then
			self:GiveLoadout( ply )
		end
	end
	
	//Do some sweet effects.
	ply:EmitSound( "GModTower/virus/player_spawn.wav" )
	local spawnent = ents.Create( "spawn" )
	if IsValid( spawnent ) then
		spawnent:SetPos( ply:GetPos() + Vector( 0, 0, 40 ) )
		spawnent:SetOwner( ply )
		spawnent:SetSpawnOwner( ply )
		spawnent:ShouldRemove( true )
		spawnent:Spawn()
		spawnent:Activate()
	end
	
	PostEvent( ply, game.GetMap() )
	PostEvent( ply, "adrenaline_off" )
	
end

function GM:RoundRespawn()

	for k,v in pairs(player.GetAll()) do
		v:Spawn()
	end

end