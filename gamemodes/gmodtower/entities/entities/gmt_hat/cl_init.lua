include('shared.lua')

function ENT:Initialize()

	local Pos = self.dt.HatPos
	if !self.Data || Pos.x != self.Data[1] then

		local Ang = self.dt.HatAng

		self.Data = {
			Pos.x, Pos.y, Pos.z,
			Ang.x, Ang.y, Ang.z,
			self.dt.HatScale,
			0,
		}

		if self.dt.HatID and self.dt.HatID != 0 and IsValid( self:GetOwner() ) then
			local item = Hats.GetItem( self.dt.HatID )
			if not item then return end

			local name = string.lower( item.unique_Name )
			local model = string.lower( Hats.FindPlayerModelByName( self:GetOwner():GetModel() ) )

			if not Hats.Data[ model ] then
				Hats.Data[ model ] = {}
			end

			Hats.Data[ model ][ name ] = self.Data
		end

	end

	self:SetLegacyTransform( true ) -- Because they suck

	// Get if the hat needs fixin'
	local HatData = Hats.GetItemFromModel( self:GetModel() )
	if HatData then
		self.FixedScale = HatData.fixscale
	end

end

function ENT:PositionItem(ent)

	if !IsValid( ent ) then return end

	-- ent.Ragdoll is used for bonemerged models
	ent = ent.Ragdoll and ent.Ragdoll or ent

	local Pos, Ang, PlyScale = Hats.ApplyTranslation( ent, self.Data )
	local Scale = self.Data[7] * PlyScale

	-- Fix bad hats
	-- This is because some of the hats have bones which offsets the scaling due to hierarchy.
	if self.FixedScale then Scale = math.sqrt( Scale ) end


	// Override for fancy stuff
	if engine.ActiveGamemode() == "minigolf" then
		local newPos, newAng, newScale = hook.Call( "PositionHatOverride", GAMEMODE, ent, self.Data, Pos, Ang, Scale )
		Pos = newPos or Pos
		Ang = newAng or Ang
		Scale = newScale or Scale
	end

	return Pos, Ang, Scale

end