local meta = FindMetaTable( "Player" )
if not meta then return end

function meta:SetSkyboxEntity( entity )
	self:SetNWEntity( "SkyboxEntity", entity )
end

function meta:GetSkyboxEntity()
	return self:GetNWEntity( "SkyboxEntity" )
end