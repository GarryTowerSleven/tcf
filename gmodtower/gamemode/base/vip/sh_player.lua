local meta = FindMetaTable( "Player" )

if !meta then
	Msg( "Unable to get player meta table!\n" )
	return
end

function meta:IsVIP()
	return self:GetNWBool( "VIP" )
end

function meta:GetGlowColor()
	return self:GetNWVector( "GlowColor" )
end