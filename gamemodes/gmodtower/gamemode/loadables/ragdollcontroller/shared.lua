local meta = FindMetaTable("Player")

function meta:IsRagdoll()
	return self.Ragdoll
end

plynet.Register( "Bool", "Ragdolled" )