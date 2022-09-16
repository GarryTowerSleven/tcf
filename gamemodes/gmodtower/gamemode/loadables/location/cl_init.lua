include("shared.lua")
include("sh_meta.lua")

module("Location", package.seeall )

hook.Add( "Think", "GTowerLocationClient", function()

	if LocalPlayer():IsBot() then return end

	local PlyPlace = Find( LocalPlayer():GetPos() + Vector(0,0,5) )

	if LocalPlayer()._LastLocation != PlyPlace then

		hook.Call("Location", GAMEMODE, LocalPlayer(), PlyPlace, LocalPlayer()._LastLocation or 0 )
		LocalPlayer()._Location = PlyPlace
		LocalPlayer()._LastLocation = PlyPlace
		
		net.Start( "LocationRefresh" )
			net.WriteInt( PlyPlace, 10 )
			net.WriteInt( LocalPlayer()._LastLocation, 10 )
		net.SendToServer()
	end

end )

local FacesGenerated = false
local DebugEnabled = CreateClientConVar( "gmt_admin_locations", "0", false, false )
local DebugTraceDist = CreateClientConVar( "gmt_admin_locations_tracedist", "600", false, false )
local DebugCullBack = CreateClientConVar( "gmt_admin_locations_backcull", "1", false, false )
local DebugDepthOn = CreateClientConVar( "gmt_admin_locations_depthtest", "1", false, false )
local DebugCondo = CreateClientConVar( "gmt_admin_locations_condo", "0", false, false )
--local colorMaterial = Material( "color.vmt" )
local colorMaterial = CreateMaterial("ZoneDebugTex_008", "UnlitGeneric", {
	["$basetexture"] = "hlmv/floor",
	["$vertexcolor"] = 1,
	["$vertexalpha"] = 1,
	["$model"] 		 = 1,
	["$translucent"] = 0,
} )

local function projectPoint(p, origin, normal)
	local a = (p - origin):Dot(normal)
	local v = p - (normal * a)

	return v, a
end

local function projectVector(p, pnormal, origin, normal)
	local a = (origin - p):Dot(normal)
	local b = pnormal:Dot(normal)
	local c = a / b
	local v = p + pnormal * c

	return v, c
end

local function pointInConvex(p, faces)
	local inside = true
	for k,v in pairs(faces) do
		local t = (p:Dot(v.normal) - v.dist) < EPSILON
		if not t then inside = false break end
	end
	return inside
end

local function renderFaces(depth, backCull)
	local eye = LocalPlayer():EyePos()
	for id, loc in pairs( Locations ) do
		for rid, region in pairs( loc.Regions ) do
			--Seriously Garry?
			render.OverrideDepthEnable( true, depth )
			region.mesh:Draw()
			render.OverrideDepthEnable( false, false )

			if not backCull and pointInConvex(eye, region.faces) then
				render.CullMode(MATERIAL_CULLMODE_CW)
				region.mesh:Draw()
				render.CullMode(MATERIAL_CULLMODE_CCW)
			end
		end
	end
end

local function renderDebugText(regionPrints, top)

	if not top then return end
	local n = #regionPrints
	local y = 10 * n
	for k,v in pairs(regionPrints) do

		local origin = top.origin + top.angle:Right() * (y * top.scale)
		y = y - 10
		Debug3D.DrawText( origin, string.format("%s - %s [%0.1f]", v.loc.Name, v.loc.FriendlyName, v.dist ), "Default", v.col, top.scale, top.angle )

		if v.loc.Group != "" then
			local origin = top.origin + top.angle:Right() * (y * top.scale)
			y = y - 10
			Debug3D.DrawText( origin, "Group: " .. v.loc.Group, "Default", v.col, top.scale, top.angle )
		end

		if v.loc.Priority != 0 then
			local origin = top.origin + top.angle:Right() * (y * top.scale)
			y = y - 10
			Debug3D.DrawText( origin, "Priority: " .. v.loc.Priority, "Default", v.col, top.scale, top.angle )
		end

		if k ~= n then
			local origin = top.origin + top.angle:Right() * (y * top.scale)
			y = y - 10
			Debug3D.DrawText( origin, "___________", "Default", nil, top.scale, top.angle )
		end
	end
end

local function generateFaces()
	FacesGenerated = true

	for id, loc in pairs( Locations ) do

		for rid, region in pairs( loc.Regions ) do
			if region.planes and (not region.faces) then
				region.faces = math.PlanesToFaces(region.planes, 64, 64)
				region.color = HSVToColor( math.fmod(id * 90, 360), 1, .5 )
				region.mesh = Mesh()

				local mverts = {}
				for i=1, #region.faces do
					table.Add(mverts, math.PolysToTriangles(region.faces[i].verts))
				end

				local rcolor = Color(region.color.r, region.color.g, region.color.b, 120)
				for i=1, #mverts do mverts[i].color = rcolor end
				region.mesh:BuildFromTriangles(mverts)
			end
		end
	end
end

hook.Remove( "PostRender", "GMTDebugLocations" )
hook.Remove( "PostDrawEffects", "GMTDebugLocations" )
hook.Add( "PostDrawTranslucentRenderables", "GMTDebugLocations", function()

	if ( !DebugEnabled:GetBool() ) || ( !LocalPlayer():IsAdmin() && !LocalPlayer():IsDeveloper() ) then return end

	-- Condo
	if DebugCondo:GetBool() then
		local roomloc = ents.FindByClass('gmt_roomloc')[1]

		if roomloc then
			local min, max = Vector(-1120, 0, -150), Vector(1056, -1326, 416)
			local offmin, offmax = Vector(-125,0,0), Vector(-28,0,0)

			min:Rotate(roomloc:GetAngles())
			max:Rotate(roomloc:GetAngles())

			min = min + roomloc:GetPos() - offmin
			max = max + roomloc:GetPos() + offmax

			-- Draw box
			local color = Color( 255, 0, 0 )
			Debug3D.DrawBox( min, max, Color( 255, 0, 0 ) )

			-- Draw origin
			local pos = roomloc:GetPos()
			local angle = roomloc:GetAngles()
			Debug3D.DrawAxis(pos, angle:Forward(), angle:Right(), angle:Up(), 10)
			Debug3D.DrawSolidBox( pos, angle, Vector(-5,-5,-5), Vector(5,5,5) )
		end
	end

	local regionPrints = {}
	local maxTraceDist = DebugTraceDist:GetFloat()
	local backCull = DebugCullBack:GetBool()
	local depthTest = DebugDepthOn:GetBool()
	local prevFog = render.GetFogMode()

	for id, loc in pairs( Locations ) do

		for rid, region in pairs( loc.Regions ) do

			local center = ( region.min + region.max ) / 2

			if not region.planes then
				// Mix up the color a bit so we can see different boxes easier
				local color = Color( 255, 0, 0 )
				local color2 = Color( 255, 0, 255 )

				if id % 2 == 0 then
					color = color2
				end

				--Debug3D.DrawBox( region.min, region.max, color )

							--vecPos, strText, strFont, color, scale, angle
				Debug3D.DrawText( center, loc.Name .. " - " .. loc.FriendlyName, "Default" )

				if loc.Group != "" then
					Debug3D.DrawText( center + Vector(0,0,10), "Group: " .. loc.Group, "Default" )
				end

				if loc.Priority != 0 then
					Debug3D.DrawText( center + Vector(0,0,-10), "Priority: " .. loc.Priority, "Default" )
				end
			else
				--Debug3D.DrawBox( region.min, region.max, color )
				if region.faces then
					for k,v in pairs(region.faces) do
						local eyeangles = LocalPlayer():EyeAngles()
						local eyeforward = eyeangles:Forward()
						local dot = eyeforward:Dot(v.normal)

						if dot < 0 then
							local origin = v.center
							local rpos, dist = projectVector(LocalPlayer():EyePos(), eyeforward, v.normal * v.dist, v.normal)
							origin = rpos

							if dist > 0 and dist < maxTraceDist and pointInConvex(origin, region.faces) then
								local angle = v.normal:Angle()
								local udot = v.normal:Dot(Vector(0,0,1))
								angle:RotateAroundAxis(angle:Up(), 90)
								angle:RotateAroundAxis(angle:Forward(), 90)
								if math.abs(udot) == 1 then
								--angle = Angle(24,0,0)
									angle:RotateAroundAxis(angle:Up(), (eyeangles.y + 180) * udot)
								end

								table.insert(regionPrints, {
									origin=origin + v.normal,
									angle=angle, 
									scale=math.sqrt(dist)/20, 
									dist=dist, 
									loc=loc,
									id=id,
									col=HSVToColor( math.fmod(id * 90, 360), .5, 1 )})
							end
						end
					end
				end
			end

		end

	end

	table.sort(regionPrints, function(a,b) return a.dist < b.dist end)

	local num = #regionPrints
	local top = regionPrints[1]
	for i=1, num do
		for j=i+1, #regionPrints do

			if regionPrints[i].loc == regionPrints[j].loc then
				table.remove(regionPrints, i)
				i = i - 1
				break
			end

		end
	end
	
	table.sort(regionPrints, function(a,b) return 
		a.loc.Priority == b.loc.Priority and a.id > b.id or a.loc.Priority < b.loc.Priority end)

	if not depthTest then
		render.ClearDepth()
	end

	if not FacesGenerated then 
		generateFaces()
	else
		render.SetMaterial( colorMaterial )
		render.FogMode(MATERIAL_FOG_NONE)
		renderFaces(false, backCull)
		renderFaces(true, true)
		render.FogMode(prevFog)
		render.ClearDepth()
		renderDebugText(regionPrints, top)
	end

end )