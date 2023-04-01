local VMatrix = FindMetaTable("VMatrix")

function Vec4(v3, w)
	return {v3.x, v3.y, v3.z, w}
end

function VMatrix:GetColumn(c)
	return {
		self:GetField(1,c),
		self:GetField(2,c),
		self:GetField(3,c),
		self:GetField(4,c)
	}
end

function VMatrix:GetRow(r)
	return {
		self:GetField(r,1),
		self:GetField(r,2),
		self:GetField(r,3),
		self:GetField(r,4)
	}
end

function VMatrix:Transform4( v, o )

	local m = self
	local mv = m:ToTable()

	o = o or Vec4(Vector(0,0,0), 0)

	o[1] = mv[1][1] * v[1] + mv[1][2] * v[2] + mv[1][3] * v[3] + mv[1][4] * v[4]
	o[2] = mv[2][1] * v[1] + mv[2][2] * v[2] + mv[2][3] * v[3] + mv[2][4] * v[4]
	o[3] = mv[3][1] * v[1] + mv[3][2] * v[2] + mv[3][3] * v[3] + mv[3][4] * v[4]
	o[4] = mv[4][1] * v[1] + mv[4][2] * v[2] + mv[4][3] * v[3] + mv[4][4] * v[4]

	return o

end

function VMatrix:Transform3( v, w, o )

	local m = self
	local mv = m:ToTable()

	w = w or 1
	o = o or Vector(0,0,0)

	o.x = mv[1][1] * v[1] + mv[1][2] * v[2] + mv[1][3] * v[3] + mv[1][4] * w
	o.y = mv[2][1] * v[1] + mv[2][2] * v[2] + mv[2][3] * v[3] + mv[2][4] * w
	o.z = mv[3][1] * v[1] + mv[3][2] * v[2] + mv[3][3] * v[3] + mv[3][4] * w
	w   = mv[4][1] * v[1] + mv[4][2] * v[2] + mv[4][3] * v[3] + mv[4][4] * w

	local i = 1/w
	o.x = o.x * i
	o.y = o.y * i
	o.z = o.z * i

	return o, w

end

function VMatrix:Transform2( x, y, w )

	local m = self
	local mv = m:ToTable()

	w = w or 1

	local ox = mv[1][1] * x + mv[1][2] * y + mv[1][4] * w
	local oy = mv[2][1] * x + mv[2][2] * y + mv[2][4] * w

	return ox, oy

end

function VMatrix:GetXForm2D()

	local mv = self:ToTable()
	return {
		mv[1][1], mv[1][2], mv[1][4],
		mv[2][1], mv[2][2], mv[2][4]
	}

end

function VMatrix:SetXForm2D(xform)

	self:Identity()
	self:SetField( 1,1,xform[1] )
	self:SetField( 1,2,xform[2] )
	self:SetField( 1,4,xform[3] )

	self:SetField( 2,1,xform[4] )
	self:SetField( 2,2,xform[5] )
	self:SetField( 2,4,xform[6] )

end

function VMatrix:NormalizeLinear2D()
	local mv = self:ToTable()

	local ux = mv[1][1]
	local uy = mv[2][1]

	local vx = mv[1][2]
	local vy = mv[2][2]

	local uLen = math.sqrt(ux * ux + uy * uy)
	local vLen = math.sqrt(vx * vx + vy * vy)

	if uLen > 0 and vLen > 0 then
		local ud = 1/uLen
		local vd = 1/vLen

		self:SetField( 1,1,ux * ud )
		self:SetField( 2,1,uy * ud )
		self:SetField( 1,2,vx * vd )
		self:SetField( 2,2,vy * vd )
	end
end

function VMatrix:Transpose()
	local m = self
	local mv = m:ToTable()

	m:SetField(1,2, mv[2][1])
	m:SetField(1,3, mv[3][1])
	m:SetField(1,4, mv[4][1])

	m:SetField(2,1, mv[1][2])
	m:SetField(2,3, mv[3][2])
	m:SetField(2,4, mv[4][2])

	m:SetField(3,1, mv[1][3])
	m:SetField(3,2, mv[2][3])
	m:SetField(3,4, mv[4][3])

	m:SetField(4,1, mv[1][4])
	m:SetField(4,2, mv[2][4])
	m:SetField(4,3, mv[3][4])
end