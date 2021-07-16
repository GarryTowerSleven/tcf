local meta = FindMetaTable( "Player" )

if !meta then
	Msg( "Unable to get player meta table!\n" )
	return
end

function meta:IsVIP()
	//return self:GetNWBool("VIP") --self:GetNet( "VIP" )
	return true
end

function meta:GetGlowColor()
	return self:GetNWVector("GlowColor") --self:GetNet( "GlowColor" )
end
