
-----------------------------------------------------
ENT.Type 				= "anim"
ENT.Base 				= "base_anim"

ENT.PrintName			= "Lobby Sale Sign"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

ENT.Model				= Model( "models/map_detail/lobby_salesign.mdl")


-- Only use this function because the client and server might implement their own Initialize
function ENT:SetupDataTables()

	-- Network the event name so we know what current event we get to be a part of
	self:NetworkVar("Int", 0, "StoreID")
end

