local meta = FindMetaTable( "Player" )

if !meta then
	Msg( "Unable to get player meta table!\n" )
	return
end

function meta:IsVIP()
	return self:IsStaff() || self:GetNet( "VIP" )
end

function meta:IsGlowEnabled()
	return self:GetNet( "GlowEnabled" )
end

function meta:GetGlowColor()
	return self:GetNet( "GlowColor" )
end