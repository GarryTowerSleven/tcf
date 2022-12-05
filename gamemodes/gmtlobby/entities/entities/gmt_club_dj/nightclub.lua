
-----------------------------------------------------
function _G.IsValidController( ent )
	return IsValid( ent ) and ent:GetClass() == "gmt_club_dj" -- TODO: Convert fft funcs to a generic library and let this work with any media player
end