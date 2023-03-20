local meta = FindMetaTable( "Player" )
if !meta then
	Msg("ALERT! Could not hook Player Meta Table\n")
	return
end

function meta:GetRankName()

	if !self:GetNWInt( "Rank" ) || !GAMEMODE.Ranks[ self:GetNWInt( "Rank" ) ] then return "Invalid" end

	local name = GAMEMODE.Ranks[ self:GetNWInt( "Rank" ) ].Name

	if self:GetNWBool( "IsChimera" ) then
		name = "Ultimate Chimera"
	end

	return name

end

function meta:GetRankColor()

	local color = Color( 250, 180, 180 )

	if !self:GetNWInt( "Rank" ) then return color end

	color = GAMEMODE.Ranks[ self:GetNWInt( "Rank" ) ].Color

	if self:GetNWBool( "IsChimera" ) then
		color = Color( 230, 30, 110 )
	end
	
	if self:GetNWBool( "IsGhost" ) then
		color = Color( 250, 250, 250 )
	end

	return color

end

function meta:GetRankColorSat()

	local color = Color( 255, 255, 255 )

	if !self:GetNWInt( "Rank" ) then return color end

	color = GAMEMODE.Ranks[ self:GetNWInt( "Rank" ) ].SatColor

	return color

end

function meta:SetRank( num )

	local num = math.Clamp( num, 1, 4 )

	self:SetNWInt( "Rank", num )

	if !self:GetNWBool( "IsGhost" ) then
		self:SetRankModels()
	end

end

function meta:SetRankModels()

	local rank = self:GetNWInt( "Rank" )

	if rank > 3 then
		self:SetBodygroup( 2, 1 )
		self:SetBodygroup( 1, 0 )
	else
		self:SetBodygroup( 2, 0 )
		self:SetBodygroup( 1, rank - 1 )
	end

	self:SetSkin( ( rank - 1 ) or 1 )

end

function meta:RankUp()

	self:SetNWInt( "NextRank", math.Clamp( self:GetNWInt( "Rank" ) + 1, 1, 4 ) )

end

function meta:RankDown()

	self:SetNWInt( "NextRank", math.Clamp( self:GetNWInt( "Rank" ) - 1, 1, 4 ) )

end

function meta:ResetRank()

	self:SetNWInt( "NextRank", 1 )

end