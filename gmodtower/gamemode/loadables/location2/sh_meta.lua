module("Location", package.seeall )

local EntityMeta = FindMetaTable( "Entity" )

if DEBUG then
	print("Adding location to entity meta: ", EntityMeta )
end
	
if EntityMeta then
	
	function EntityMeta:Location( force )

		if !IsValid( self ) then return 1 end

		if force != true && self._NextLocationTime && self._NextLocationTime > CurTime() then
			return self._CurrentLocation
		end
		
		self._NextLocationTime = CurTime() + 1.0		
		self._CurrentLocation = Find( self:GetPos() ) or 1
		
		return self._CurrentLocation
		
	end

	function EntityMeta:GetLocationRP()
		return Location.LocationRP( self:Location() )
	end
	
	function EntityMeta:LocationName()
		return Location.GetFriendlyName( self:Location() )
	end	
	
	function EntityMeta:LocationGroup()
		return Location.GetGroup( self:Location() )
	end	
	
end


local Player = FindMetaTable("Player")

if Player then
	function Player:Location( force )
		if force == true then
			return Find( self:GetPos() )
		end

		-- Instant update for local player
		if CLIENT and LocalPlayer() == self then
			return self._Location
		end

		return self:GetNWInt("Location")
	end
end