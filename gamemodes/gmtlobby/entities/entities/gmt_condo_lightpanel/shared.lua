ENT.Type 				= "anim"
ENT.Base 				= "base_anim"

ENT.Model				= Model( "models/map_detail/condo_lightswitch.mdl" )

function ENT:SetupDataTables()
	self:NetworkVar("Float", 1, "LightValue")
	self:NetworkVar("Int", 1, "LightID")
	self:NetworkVar("Int", 2, "LightColorR")
	self:NetworkVar("Int", 3, "LightColorG")
	self:NetworkVar("Int", 4, "LightColorB")
end

function ENT:PhysicsUpdate() end
function ENT:PhysicsCollide(data,phys) end

function ENT:GetCondoID()

	if not self.CondoID then
		self.CondoID = Location.GetCondoID( self:Location() )
	end

	return self.CondoID

end

function ENT:GetCondo()

	local condoid = self:GetCondoID()
	return GTowerRooms:Get( condoid )

end

hook.Add( "PhysgunPickup", "CondoLightpanelGrab", function( ply, ent )

	if ent:GetClass() == "gmt_condo_lightpanel" then return false end

end )
