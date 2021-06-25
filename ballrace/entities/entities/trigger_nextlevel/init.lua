ENT.Base = "base_brush"
ENT.Type = "brush"

function ENT:Initialize()
	if self.Parent then
		local Parent = ents.FindByName( self.Parent )

		if IsValid(Parent[1]) then
			self:SetParent( Parent[1] )
		end
	end

	if self.Destination then
		local dest = ents.FindByName(self.Destination)
		if IsValid(dest[1]) then
			self.DestinationEnt = dest[1]
		end
	end
	
	if self.BonusNext then
		local dest = ents.FindByName(self.BonusNext)
		if IsValid(dest[1]) then
			self.BonusNextEnt = dest[1]
		end
	end

	if game.GetMap() == "gmt_ballracer_grassworld01" or game.GetMap() == "gmt_ballracer_skyworld01" or game.GetMap() == "gmt_ballracer_iceworld03" or game.GetMap() == "gmt_ballracer_facile" or game.GetMap() == "gmt_ballracer_sandworld02" or game.GetMap() == "gmt_ballracer_flyinhigh01" or game.GetMap() == "gmt_ballracer_nightball" or game.GetMap() == "gmt_ballracer_spaceworld01" or game.GetMap() == "gmt_ballracer_prism03" or game.GetMap() == "gmt_ballracer_waterworld02" then
		return
		else
		local arrow = ents.Create( "arrow" )
		if !IsValid( arrow ) then return end
	
		arrow:SetPos( self:GetPos() + Vector( 0, 0, 258.57 ) )
		arrow:SetParent( self )
		arrow:SetOwner( self )
		arrow:Spawn()
	end
end

function ENT:StartTouch( ply )
	if !self.DestinationEnt then return end
	if ply:GetClass() != "player_ball" then return end

	local ply = ply:GetOwner()

	ActiveTeleport = self.DestinationEnt
	BonusTeleport = self.BonusNextEnt

	if self.Relay then ents.FindByName( self.Relay )[1]:Fire( "Trigger", 0, 0 ) end

	GAMEMODE:PlayerComplete(ply)
end

function ENT:EndTouch( ply )
end

function ENT:Touch() 
end

function ENT:KeyValue( key, value )
	if key == "bonustarget" || key == "bonusstart" then
		self.Destination = value
	elseif key == "target" then
		self.Destination = value
		self.BonusNext = value
	elseif key == "parentname" then
		self.Parent = value
	elseif key == "relay" then
		self.Relay = value
	end
end

function ENT:AcceptInput( input, activator, ply )
end