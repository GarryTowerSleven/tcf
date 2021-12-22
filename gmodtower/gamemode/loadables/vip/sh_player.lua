---------------------------------

local meta = FindMetaTable( "Player" )

if !meta then
	Msg( "Unable to get player meta table!\n" )
	return
end

meta.IsVip = meta.IsVIP