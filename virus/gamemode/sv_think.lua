GM.RankRefresh = 0
GM.NextMapThink = 0

function GM:Think()

	if self:GetState() == 3 then
		for _, v in ipairs( player.GetAll() ) do
			
			if v:GetNet( "IsVirus" ) then
				self:VirusThink( v )
			else
				self:PlayerThink( v )
			end

			if self.RankRefresh < CurTime() then
				self:ProcessRank( v )
				self.RankRefresh = CurTime() + 2
			end

		end
	end

	if self:GetState() == 3 && #team.GetPlayers( TEAM_PLAYERS ) == 0 then
		self:EndRound( true )
	elseif self:GetState() == 1 && self:GetTimeLeft() <= 0 then
		if #player.GetAll() < 2 then return end
		self:RoundReset()
	elseif self:GetState() == 2 && self:GetTimeLeft() <= 0 then
		if #player.GetAll() < 2 then self:EndServer() end
		self:StartRound()
	elseif self:GetState() == 3 && self:GetTimeLeft() <= 0 then
		self:EndRound( false )
	elseif self:GetState() == 4 && self:GetTimeLeft() <= 0 then
		if GetWorldEntity():GetNet( "Round" ) < 10 then
			self:RoundReset()
		else
			self:EndServer()
		end
	end

	self:MapThink()

end

// map specific logic
function GM:MapThink()

	if ( CurTime() >= self.NextMapThink ) then

		local mapName = game.GetMap()

		//sewage water kill (for survivors)
		if mapName == "gmt_virus_sewage01" then
		
			for _, v in ipairs( player.GetAll() ) do

				if v:WaterLevel() != 0 then
					if !v:Alive() then return end
			
					if v:IsPlayer() && v:Alive() then
						v:Kill()
					end
				end
				
			end

		end

		self.NextMapThink = CurTime() + 0.1

	end

end

function GM:PlayerDeathThink( ply )

	if !IsValid( ply ) then return end
	if ply:Alive() then return end

	if ply.RespawnTime < CurTime() then
		ply:Spawn()
	end

end

function GM:PlayerThink( ply )

	if ( !IsValid( ply ) || !ply:Alive() ) then return end

	if self:GetState() == 1 then
		ply:CrosshairDisable()
	end

end

function GM:VirusThink( ply ) 

	if ( !IsValid( ply ) || !ply:Alive() ) then return end
	if ( self:GetState() != 3 ) then return end

	self:PlayerDeathThink( v )

	if ply.Flame != nil then
		local objs = ents.FindInSphere( ply:GetPos() + Vector( 0, 0, 40 ), 40 )

		if ( ply:GetVelocity():Length() <= 0 ) then return end  //standing still fuckers
		
		for _, v in ipairs( objs ) do
			if ( IsValid( v ) && v:IsPlayer() && !v:GetNet( "IsVirus" ) ) then	
				self:Infect( v, ply )
			end
		end
	end

	local NumVirus = #team.GetPlayers( TEAM_INFECTED )

	if NumVirus == 1 then 
		
		for k,v in pairs(player.GetAll()) do
			if ( v:GetNet( "IsVirus" ) && v:Deaths() >= 2 && v.enraged != true ) then
				
				v.enraged = true
				
				v:SetWalkSpeed( 500 )
				v:SetRunSpeed( 500 )
				
			elseif v.enraged == true then
			
				v:SetWalkSpeed( 500 )
				v:SetRunSpeed( 500 )
				
			end
		end
		
	elseif NumVirus >= 2 then
		
		for _, v in ipairs( player.GetAll() ) do
			if v:GetNet( "IsVirus" ) || v.enraged == true then
				
				v.enraged = false
				v:SetWalkSpeed( self.VirusSpeed )
				v:SetRunSpeed( self.VirusSpeed )
				
			end
		end
		
	end

end