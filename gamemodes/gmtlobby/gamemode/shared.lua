DeriveGamemode("darkrp")

function InCondo(pos)
    return pos.z > 11000
end

function GM:SpawnMenuOpen()
    if !InCondo(LocalPlayer():GetPos()) then
        notification.AddLegacy("Build in a Condo, or find Building Supplies!", NOTIFY_ERROR, 8)
        return false
    end

    return true
end

function GM:ContextMenuOpen()
    return false
end

ACHIEVEMENTS = {}
ACHIEVEMENTS.AddAchievement = function() end

local meta = FindMetaTable("Player")
local meta2 = FindMetaTable("Entity")

meta.AddAchievement = function() end

string.FormatNumber = string.Comma

meta.Afford = meta.canAfford

meta.AddMoney = meta.addMoney

meta.MsgI = function(self, _, msg)
    self:ChatPrint(msg)
end

meta.Location = function()
    return 0
end

meta.GetCondoID = function()
    return 0
end

meta2.GetCondoID = function()
    return 0
end

local meta3 = FindMetaTable("Vector")
meta3.WithinDistance = function() end

Location = {}
Location.Find = function() end
Location.GetCondoID = function() return 0 end
Location.Is = function() return 0 end
Location.Get = function() return end

GtowerRooms = {}
GtowerRooms.Get = function() return end

local meta = FindMetaTable("Entity")
local plyMeta = FindMetaTable("Player")

local ownableDoors = {
    ["func_door"] = true,
    ["func_door_rotating"] = true,
    ["prop_door_rotating"] = true,
    ["gmt_condo_door"] = true
}
local unOwnableDoors = {
    ["func_door"] = true,
    ["func_door_rotating"] = true,
    ["prop_door_rotating"] = true,
    ["func_movelinear"] = true,
    ["prop_dynamic"] = true,
    ["gmt_condo_door"] = true
}
function meta:isKeysOwnable()
    if not IsValid(self) then return false end

    local class = self:GetClass()

    if (ownableDoors[class] or
            (GAMEMODE.Config.allowvehicleowning and self:IsVehicle() and (not IsValid(self:GetParent()) or not self:GetParent():IsVehicle()))) then
        return true
    end

    return false
end

function meta:isDoor()
    local class = self:GetClass()

    if unOwnableDoors[class] then
        return true
    end

    return false
end

hook.Add("getDoorCost", "test", function(ent)
    return 100
end)


-----------------------------------------------------
AddCSLuaFile()

-- Object for managing, calculating, and (de)serializing bezier curves

-- Super basic functionaltiy, add additional functionality as necessary



local CURVE = {}

CURVE.__index = CURVE

CURVE.SaveDirectory = "Curves/"



local point

-- Utility function to create the point structure

local function CreatePoint( position, angle, premag, postmag, props, targetSpeed )

	return

	{

		Pos = position,

		Angle = angle,

		PreMagnitude = premag,

		PostMagnitude = postmag,

		User = props,

		Speed = targetSpeed
	}

end



----

-- Get the world position of the anchor controlling after this node

----

function CURVE:GetNextAnchor(index)

	assert(index > 0 and index <= #self.Points, "Index out of range of table!")

	point = self.Points[index]



	-- Cache the angles, only change when something changes

	if point.LastAngle ~= point.Angle or

	point.LastPostMagnitude ~= point.PostMagnitude or

	point.LastPos ~= point.Pos or

	not point.CachedNextAnchor then

		point.LastAngle = point.Angle

		point.LastPos = point.Pos

		point.LastPostMagnitude = point.PostMagnitude



		point.CachedNextAnchor = point.Angle:Forward() * point.PostMagnitude + point.Pos

	end



	return point.CachedNextAnchor

end



----

-- Get the world position of the anchor controlling before this node

----

function CURVE:GetPreviousAnchor(index)

	assert(index > 0 and index <= #self.Points,  "Index out of range of table!")

	point = self.Points[index]



	-- Cache the angles, only change when something changes

	if point.LastAngle ~= point.Angle or

	point.LastPreMagnitude ~= point.PreMagnitude or

	point.LastPos ~= point.Pos or

	not point.CachedPreviousAnchor then

		point.LastAngle = point.Angle

		point.LastPos = point.Pos

		point.LastPreMagnitude = point.PreMagnitude



		point.CachedPreviousAnchor = -point.Angle:Forward() * point.LastPreMagnitude + point.Pos

	end



	return point.CachedPreviousAnchor

end



----

-- Add a new point to the curve at the end of the list

-- Optionally add it to a specific index

----

function CURVE:Add(position, angle, premag, postmag, index, nodeProps, targetSpeed)

	assert(position, "Invalid argument #1. Position expected, got nil")



	local point = CreatePoint(position, angle or Angle(), premag or 1, postmag or 1, nodeProps, targetSpeed or 1)



	if index ~= nil then

		table.insert(self.Points, index, point )

	else

		table.insert(self.Points, point)

	end

end



----

-- Store specific information per node

-- Useful for code that perhaps has different types/properties of nodes

----

function CURVE:SetUserobject(index, userobject )

	assert(index > 0 and index <= #self.Points,  "Index out of range of table!")



	point = self.Points[index]

	point.User = userobject

end



----

-- Retrieve stored user information about a node

----

function CURVE:GetUserobject(index, userobject )

	assert(index > 0 and index <= #self.Points,  "Index out of range of table!")



	return self.Points[index].User

end





---

-- Linearize the curve by creating a bunch of sub-points along the path

---

function CURVE:CalculateKeyPoints(tesselation)

	-- Reset the curve points

	self.KeyPoints = {}

	self.KeyPointTesselation = tesselation -- Store this so we always know the current tesselation



	-- Localize some variables

	local point, forward, right, angle, perc, dist, tdist
, index


	for i = 0, tesselation * (#self.Points-1) do

		perc = i / tesselation



		-- Calculate some useful stuff to store

		point, forward, right, index = self:Calculate(

			math.floor(perc) % (#self.Points-1) + 1,

		 	perc % 1)



		angle = self:CalculateAngle(forward, right)



		if i > 0 then

			dist = self.KeyPoints[i].Pos:Distance(point)

			tdist = (self.KeyPoints[i].TotalDistance or 0) + dist



		end



		-- Store it all in our table

		table.insert(self.KeyPoints,

		{

			Pos = point,

			Angle = angle,

			Distance = (dist or 1),

			TotalDistance = (tdist or 0)
,
			PointNum = index
		})

	end



end









-- Relocate these variables outside the function

-- Just so they aren't constantly being recreated

local u, tt, uu, uuu, ttt

local nextPoint, p, forward, ang, right

local curPoint, PosUUU, uutNext3, uttprev3, PosTTT

----

-- Calculate the position, forward, and right vectors of a percent after a given point

----

function CURVE:Calculate( index, t )

	u = 1 - t

	tt = t *t

	uu = u*u

	uuu = uu * u

	ttt = tt * t



	curPoint = self.Points[index]

	nextPoint = self.Points[index+1]



	-- Calculate the forward vector

	forward = -3 * curPoint.Pos * uu +

		3 * (1.0 - 4.0 * t + 3.0 * t * t) * self:GetNextAnchor(index) +

		3 * (2.0 * t - 3.0 * t * t) * self:GetPreviousAnchor(index+1) +

		3 * nextPoint.Pos * tt



	-- Calculate the right vector

	--ang = LerpAngle( t, curPoint.Angle, nextPoint.Angle)

	--right = forward:Cross(ang:Up())



	-- We purposefully don't normalize these vectors as their length is potentially useful

	-- Also, we calculate it here to save on a few variables



	-- The position

	return curPoint.Pos * uuu +

		3 * uu * t * self:GetNextAnchor(index) +

		3 * u * tt * self:GetPreviousAnchor(index+1) +

		ttt * nextPoint.Pos,



	-- The forward vector

	forward,



	-- The right vector

	forward:Cross(LerpAngle( t, curPoint.Angle, nextPoint.Angle):Up())
,

	-- The Index
	index
end



-- Utility function to find the closest index of the lookup table

function CURVE:FindStartIndex(distance, startIndex)



	-- It's pretty shitty we have to loop through, so we let them choose the index to start looking from

	-- Make sure it's not invalid or the last one

	startIndex = startIndex or 1

	local keyPoint = self.KeyPoints[startIndex-1]

	if not keyPoint or keyPoint.TotalDistance > distance or startIndex >= #self.KeyPoints then

		startIndex = 1

	end



	-- Given a distance, find the closest keypoint to it

	-- While we have to loop through it, we have been hinted its position so it shouldn't be bad

	local num = -1

	for k=startIndex, #self.KeyPoints do

		if self.KeyPoints[k].TotalDistance > distance then

			num = k

			break

		end

	end



	return num

end



---

-- Calculate using a cached 'linearized' version of the curve.

-- Accepts the distance along the linear curve and the start index to look from

-- It also returns the index the position was found, so that will be a hint for the loop next time around

---

function CURVE:CalculateLinear( distance, startIndex )

	local num = self:FindStartIndex(distance, startIndex)



	-- Uhh, someone wonked up

	if num < 1 then return Vector(), Angle, -1 end



	-- Store the current and next key points to interpolate across

	curPoint 	= self.KeyPoints[num-1]

	nextPoint 	= self.KeyPoints[num]



	-- Get just the percentage bit

	p = (distance - curPoint.TotalDistance) / (nextPoint.TotalDistance - curPoint.TotalDistance)



	-- Wrap around if necessary

	if not nextPoint then nextPoint = self.KeyPoints[1] end



	-- Return only position and angle

	return  LerpVector(p, curPoint.Pos, nextPoint.Pos),

			LerpAngle(p, curPoint.Angle, nextPoint.Angle),

			num
,
			self.Points[curPoint.PointNum].Speed or 1
end





-- Relocate these variables outside the function

-- Just so they aren't constantly being recreated

local up, absAngle, cross, rollAngle

----

-- Calculate the euler angle given proper forward and right vectors

----

function CURVE:CalculateAngle(forward, right)

	up = forward:Cross(right)



	absAngle = right:AngleEx(up)

	cross = right:Cross(up)

	rollAngle = forward:DotProduct(cross) >= 0 and absAngle or -absAngle

	rollAngle:RotateAroundAxis(rollAngle:Forward(), 180)



	return rollAngle

end



----

-- Serialize the points table to a text string

----

function CURVE:Serialize()

	return util.TableToJSON( self.Points )

end



local function TypeToLuaString( obj )

	local t = type(obj)



	if t == "Vector" then

		return "Vector(" .. obj.x .. ","..obj.y..","..obj.z..")"

	elseif t == "Angle" then

		return "Angle(" .. obj.p .. ","..obj.y..","..obj.r..")"

	elseif t == "number" then

		return tostring(obj)

	elseif t == "table" then

		return "util.JSONToTable([[" .. util.TableToJSON(obj) .. "]])"

	end

	-- welp

	return tostring(obj)

end



---

-- Alternate function to save as a series of points to be created with lua

---

function CURVE:SerializeLua(name)

	-- Create each line

	local lines = {}

	for _, v in pairs( self.Points ) do

		local lineStr = "curve:Add(" .. TypeToLuaString(v.Pos) ..", " ..

									  TypeToLuaString(v.Angle) ..", " ..

			 				   TypeToLuaString(v.PreMagnitude) ..", " ..

			  				  TypeToLuaString(v.PostMagnitude) ..", " ..

			   								 "nil, " ..

			    						   (v.User and TypeToLuaString(v.User) or "nil") .. ")"

		print(lineStr)

		table.insert(lines, lineStr)



	end



	-- Assemble the bigass string

	local str = "STORED_CURVES = STORED_CURVES or {}\n" ..

				"local curve = CreateBezierCurve()\n\n"



	str = str .. string.Implode("\n", lines)



	str = str .. "\n\nSTORED_CURVES[\"" .. name .. "\"] = curve"



	return str

end



----

-- Deserialize a table of points, loading the points in yonder

----

function CURVE:Deserialize( str )

	self.Points = {}

	self.Points = util.JSONToTable( str )



	-- Return if the operation was successful

	return self.Points ~= nil

end



----

-- Generic function for saving to a file, to load for later

----

function CURVE:Save(filename, shouldSaveLua)

	local fullPath = self.SaveDirectory .. filename .. ".txt"

	local fullPathLua = self.SaveDirectory .. filename .. "_lua.txt"



	-- Create the folder to make sure we can write there

	file.CreateDir(self.SaveDirectory)



	-- Write to the file

	file.Write(fullPath, self:Serialize())



	if shouldSaveLua then

		file.Write(fullPathLua, self:SerializeLua(filename) )

	end

end



----

-- Generic function for loading from a file using the previously used Save func

----

function CURVE:Load(filename)

	local fullPath = self.SaveDirectory .. filename .. ".txt"

	local json = file.Read(fullPath, "DATA")



	-- If we weren't able to load the file return false

	if not json then return false end



	-- Load it UP

	return self:Deserialize(json)

end



function CURVE:__tostring()

	return "Bezier curve of " .. #self.Points .. " points."

end



----

-- Create a new instance of our bezier curve object

----

function CreateBezierCurve()

	local tbl = {}

	tbl = setmetatable(tbl, CURVE)



	tbl.Points = {}

	tbl.KeyPoints = {}



	return tbl

end

concommand.Add("gmt_storespline",function(ply)
	if !ply:IsAdmin() then return end
	ply:ChatPrint("curve:Add(Vector("..tostring(ply:GetPos()).."), Angle("..tostring(ply:GetAngles()).."), 1, 1, nil, nil)")
end)
