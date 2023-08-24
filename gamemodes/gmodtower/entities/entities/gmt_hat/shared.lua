ENT.Type = "anim"
ENT.Base = "gmt_cosmeticbase"

function ENT:SetupDataTables()

	self:NetworkVar( "Vector", 0, "HatPos" )
	self:NetworkVar( "Vector", 1, "HatAng" )
	self:NetworkVar( "Float", 0, "HatScale" )
	self:NetworkVar( "Int", 1, "HatAtt" )

end

function ENT:SetHatData( data )

	self:SetHatPos( Vector( data[1], data[2], data[3] ) )
	self:SetHatAng( Vector( data[4], data[5], data[6] ) )
	self:SetHatScale( math.floor( ( data[7] or 1 ) * 100 ) / 100 )
	self:SetHatAtt( data[8] or 1 )
	
	// self.dt.HatPos = Vector( data[1], data[2], data[3] )
	// self.dt.HatAng = Vector( data[4], data[5], data[6] )
	// self.dt.HatScale = math.floor( ( data[7] or 1 ) * 100 ) / 100
	// self.dt.HatAtt = data[8] or 1

end

-- ImplementNW() -- Implement transmit tools instead of DTVars