module("shape2D", package.seeall)

function cloneTable(t)
	local tt = {}
	for k,v in pairs(t) do tt[k] = v end
	return tt
end

function isConcaveEdge(p1,p2,p3)

	return (p2.x - p1.x) * (p3.y - p1.y) - (p2.y - p1.y) * (p3.x - p1.x) <= 0

end

function mergePoly(p,q, idxp, idxq)
	local ret = {}
	for i=1,idxp do ret[#ret+1] = p[i] end
	for i=2,#q-1 do
		local k = i + idxq - 1
		if k > #q then k = k - #q end
		ret[#ret+1] = q[k]
	end
	for i=idxp+1,#p do ret[#ret+1] = p[i] end
	return ret
end

function isConvexPoly(poly)
	for i=1,#poly do
		local l,p,r = i==1 and poly[#poly] or poly[i-1], poly[i], i==#poly and poly[1] or poly[i+1]
		if isConcaveEdge(r,p,l) then
			return false
		end
	end
	return true
end

function inTriangle(q, p1,p2,p3)
	local v1, v2 = p2 - p1, p3 - p1
	local qp = q - p1
	local dv = v1:Cross(v2)
	local l, m = qp:Cross(v2) / dv, v1:Cross(qp) / dv
	return l > 0 and m > 0 and l+m < 1
end

function isInsideConvex(poly, point)

	for i=1, #poly do
		local v1 = poly[i] - point
		local v2 = poly[i % #poly + 1] - point
		local edge = v2 - v1
		if edge:Cross(v1) < 0 then return false end
	end
	return true

end

function MakeConvexHull(points)

	if #points < 3 then return points end
	points = cloneTable(points)

	table.sort(points)

	local upper = {points[1], points[2]}
	for i=3,#points do
		upper[#upper+1] = points[i]
		while #upper > 2 and isConcaveEdge(upper[#upper-2], upper[#upper-1], upper[#upper]) do
			table.remove(upper, #upper-1)
		end
	end

	local lower = {points[#points], points[#points-1]}
	for i = #points-2,1,-1 do
		lower[#lower+1] = points[i]
		while #lower > 2 and isConcaveEdge(lower[#lower-2], lower[#lower-1], lower[#lower]) do
			table.remove(lower, #lower-1)
		end
	end

	local hull = upper
	for i=2,#lower-1 do hull[#hull+1] = lower[i] end
	return hull

end

function BoxHull(points)

	local mins = Vec2(10000,10000)
	local maxs = Vec2(-10000,-10000)

	for i=1, #points do

		mins:Min(points[i])
		maxs:Max(points[i])

	end

	local box = {
		Vec2(mins.x,mins.y),
		Vec2(maxs.x,mins.y),
		Vec2(maxs.x,maxs.y),
		Vec2(mins.x,maxs.y),
	}

	return box

end

function Trianglulate(poly)
	if #poly <= 3 then return {poly} end
	local triangles = {}
	local concave = {}
	local adj = {}

	for i,p in ipairs(poly) do
		local l, r  = (i == 1) and poly[#poly] or poly[i-1], (i == #poly) and poly[1] or poly[i+1]
		adj[p] = {p = p, l = l, r = r}
		if isConcaveEdge(l,p,r) then concave[p] = p end
	end

	local function isEar(p1,p2,p3)
		if isConcaveEdge(p1,p2,p3) then return false end
		for q,_ in pairs(concave) do
			if inTriangle(q, p1,p2,p3) then return false end
		end
		return true
	end

	local nPoints = #poly
	local p, lastP = adj[poly[2]], adj[poly[2]]
	while nPoints > 3 do
		if not concave[p.p] and isEar(p.l, p.p, p.r) then
			triangles[#triangles+1] = {p.r,p.p,p.l}
			if concave[p.l] and not isConcaveEdge(adj[p.l].l, p.l, p.r) then
				concave[p.l] = nil
			end
			if concave[p.r] and not isConcaveEdge(p.l, p.r, adj[p.r].r) then
				concave[p.r] = nil
			end
			adj[p] = nil
			adj[p.l].r = p.r
			adj[p.r].l = p.l
			nPoints = nPoints - 1
			p = adj[p.l]
			lastP = p
		else
			p = adj[p.r]
			if p == lastP then
				error("Cannot trianglulate")
			end
		end
	end
	triangles[#triangles+1] = {p.r,p.p,p.l}

	return triangles
end

function SplitConvex(poly)
	local function shareEdge(p, q)
		local vertices = {}
		for i,v in ipairs(q) do vertices[v] = i end
		for i,v in ipairs(p) do
			local w = i == #p and p[1] or p[i+1]
			if vertices[v] and vertices[w] then
				return true, i, vertices[v]
			end
		end
		return false
	end

	if #poly <= 3 then return {poly} end
	local convex = Trianglulate(poly)
	local i = 1
	repeat
		local p = convex[i]
		local k = i + 1
		while k <= #convex do
			local q = convex[k]
			local doShareEdge, idxp, idxq = shareEdge(p,q)
			if doShareEdge then
				local merged = mergePoly(p,q, idxp,idxq)
				if isConvexPoly(merged) then
					convex[i] = merged
					p = convex[i]
					table.remove(convex, k)
				else
					k = k + 1
				end
			else
				k = k + 1
			end
		end
		i = i + 1
	until i >= #convex

	return convex
end