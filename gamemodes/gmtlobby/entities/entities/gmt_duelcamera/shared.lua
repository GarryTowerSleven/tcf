
-----------------------------------------------------
ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "GMT Duel Arena Camera"
ENT.Information		= "It spins around"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.Model			= Model("models/map_detail/toystore_plane.mdl")

/*hook.Add("QuerySkyboxEntity", "DuelSkyboxOverride", function(ply, loc)
	if Location.Find( LocalPlayer():GetPos() ) == 30 then
		return util.FindSkyboxEnt("duels_skycam")
	end
end )*/