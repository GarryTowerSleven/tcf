---------------------------------

local meta = FindMetaTable( "Player" )

if !meta then
	Msg( "Unable to get player meta table!\n" )
	return
end


function meta:IsVIP()
	//return self.Vip == 1
	return true
end

meta.IsVip = meta.IsVIP