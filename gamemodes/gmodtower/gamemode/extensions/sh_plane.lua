module( "math", package.seeall )

function Plane(normal, dist)
	return { normal = normal, dist = dist }
end

function PlanesToVertices( planes )

	local num_planes = #planes
	local verts = {}

	for i=1, num_planes do local p1 = planes[i]
	for j=i+1, num_planes do local p2 = planes[j]
	for k=j+1, num_planes do local p3 = planes[k]


		local n23 = p2.normal:Cross(p3.normal)
		local n31 = p3.normal:Cross(p1.normal)
		local n12 = p1.normal:Cross(p2.normal)

		if (n23:LengthSqr() > EPSILON and 
			n31:LengthSqr() > EPSILON and
			n12:LengthSqr() > EPSILON) then


			local quotient = p1.normal:Dot(n23)
			if math.abs(quotient) > EPSILON then

				quotient = -1.0 / quotient
				n23 = n23 * -p1.dist
				n31 = n31 * -p2.dist
				n12 = n12 * -p3.dist

				local vertex = {}
				local valid = true
				vertex.pos = (n23 + n31 + n12) * quotient

				for l=1, num_planes do
					if planes[l].normal:Dot(vertex.pos) - planes[l].dist > EPSILON then
						valid = false
						break
					end
				end

				if valid then
					vertex.normal = (p1.normal + p2.normal + p3.normal) / 3.0
					table.insert(verts, vertex)
				end
			end
		end


	end
	end
	end

	return verts

end

function PlanesToFaces( planes, uscale, vscale )

	local faces = {}
	local verts = PlanesToVertices(planes)
	local num_planes = #planes
	local num_verts =  #verts

	uscale = uscale or 32
	vscale = vscale or 32


	for i=1, num_planes do

		local face = { normal = planes[i].normal, dist = planes[i].dist, verts = {} }

		face.center = Vector(0,0,0)
		face.uaxis = face.normal:GetPerpendicular()
		face.vaxis = face.normal:Cross(face.uaxis)

		face.uaxis = face.uaxis / uscale
		face.vaxis = face.vaxis / vscale

		for j=1, num_verts do
			local v = verts[j]
			if math.abs(face.normal:Dot(v.pos) - face.dist) < EPSILON then
				table.insert(face.verts, table.Copy(v))
				face.center = face.center + v.pos
			end
		end

		face.center = face.center / #face.verts

		for j=1, #face.verts do
			local v = face.verts[j]
			v.u = v.pos:Dot(face.uaxis)
			v.v = v.pos:Dot(face.vaxis)
		end

		SolveVertexWinding(face.verts, face.normal)
		table.insert(faces, face)

	end

	return faces

end

function TransformPlanes( planes, matrix )

	local function txPlane(p, m)
		m = Matrix(m:ToTable())
		local o = Vec4(p.normal * p.dist, 1)
		local n = Vec4(p.normal, 0)
		o = m:Transform4(o)
		m:Invert() m:Transpose()
		n = m:Transform4(n)
		p.normal = Vector(n[1], n[2], n[3])
		p.dist = Vector(o[1], o[2], o[3]):Dot(p.normal)
	end

	for i=1, #planes do
		txPlane(planes[i], matrix)
	end

end

function GetBrushAABB( planes )
	local min = Vector(99999,99999,99999)
	local max = Vector(-99999,-99999,-99999)
	local verts = PlanesToVertices( planes )
	for i=1, #verts do
		min:Min(verts[i].pos)
		max:Max(verts[i].pos)
	end
	return min, max
end

function BoundingBoxToBrush( min, max )
	local planes = {}
	
	table.insert(planes, Plane(Vector(-1,0,0), -min.x))
	table.insert(planes, Plane(Vector(0,-1,0), -min.y))
	table.insert(planes, Plane(Vector(0,0,-1), -min.z))

	table.insert(planes, Plane(Vector(1,0,0), max.x))
	table.insert(planes, Plane(Vector(0,1,0), max.y))
	table.insert(planes, Plane(Vector(0,0,1), max.z))

	return planes
end