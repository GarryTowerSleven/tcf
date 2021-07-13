ENT.Base = "base_brush"
ENT.Type = "brush"

function ENT:Initialize()
	if self.Parent then
		local Parent = ents.FindByName( self.Parent )

		if IsValid(Parent[1]) then
			self:SetParent( Parent[1] )
		end
	end

	if game.GetMap() == "gmt_ballracer_grassworld01" or game.GetMap() == "gmt_ballracer_skyworld01" or game.GetMap() == "gmt_ballracer_iceworld03" or game.GetMap() == "gmt_ballracer_sandworld02" then
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
	if ply:GetClass() != "player_ball" then return end
	
	local ply = ply:GetOwner()

	NextMap = true

	GAMEMODE:PlayerComplete(ply)

end

function ENT:EndTouch( ply )
end

function ENT:Touch() 
end

function ENT:KeyValue( key, value )
	if key == "parentname" then
		self.Parent = value
	end
end

function ENT:AcceptInput( input, activator, ply )

end