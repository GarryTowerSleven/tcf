local meta = FindMetaTable( "Player" )
if !meta then
	Msg("ALERT! Could not hook Player Meta Table\n")
	return
end

function meta:GetRankName()

	if !self:GetNet( "Rank" ) || !GAMEMODE.Ranks[ self:GetNet( "Rank" ) ] then return "Invalid" end

	local name = GAMEMODE.Ranks[ self:GetNet( "Rank" ) ].Name

	if self:GetNet( "IsChimera" ) then
		name = "Ultimate Chimera"
	end

	return name

end

function meta:GetRankColor()

	local color = Color( 250, 180, 180 )

	if !self:GetNet( "Rank" ) then return color end

	color = GAMEMODE.Ranks[ self:GetNet( "Rank" ) ].Color

	if self:GetNet( "IsChimera" ) then
		color = Color( 230, 30, 110 )
	end
	
	if self:IsGhost() then
		color = Color( 250, 250, 250 )
	end

	return color

end

function meta:GetRankColorSat()

	local color = Color( 255, 255, 255 )

	if !self:GetNet( "Rank" ) then return color end

	color = GAMEMODE.Ranks[ self:GetNet( "Rank" ) ].SatColor

	return color

end

function meta:SetRank( num )

	local num = math.Clamp( num, 1, 4 )

	self:SetNet( "Rank", num )

	if !self:IsGhost() then
		self:SetRankModels()
	end

end

function meta:SetRankModels()

	local rank = self:GetNet( "Rank" )

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

	self:SetNet( "NextRank", math.Clamp( self:GetNet( "Rank" ) + 1, 1, 4 ) )

end

function meta:RankDown()

	self:SetNet( "NextRank", math.Clamp( self:GetNet( "Rank" ) - 1, 1, 4 ) )

end

function meta:ResetRank()

	self:SetNet( "NextRank", 1 )

end