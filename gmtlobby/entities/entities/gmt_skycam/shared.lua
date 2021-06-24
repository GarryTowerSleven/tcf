
-----------------------------------------------------
ENT.Base = "base_entity"
ENT.Type = "anim"

local RoomRefOffset = Vector(0,0,0)

local SKYMODE_SET = 0 -- Set the new origin of the skybox with zero regard for the old position
local SKYMODE_CONDO = 1 -- Offset for condos

function ENT:SetupDataTables()

	-- Unique name of the skybox
	self:NetworkVar( "String", 0, "SkyboxName" )

	-- Skybox scale, or how much to offset the camera to player movement
	self:NetworkVar("Float", 0, "SkyboxScale")

	-- The new origin relative to the player.
	-- If the player's position is exactly at this position, the skybox will have no offset
	self:NetworkVar("Vector", 0, "MoveOrigin")

	-- The mode to override the skybox with
	self:NetworkVar("Int", 0, "Mode")
end

--plynet.Register( "Entity", "SkyboxEntity" )

-- Utility function to easily grab the room reference entity without stepping on anyone's shoes
local function GetCurrentRoomEntity(ply)
	local loc = Location.Get(ply:Location())
	if not loc or not loc.CondoID then return end

	local room = GTowerRooms:Get(loc.CondoID)

	if not room or not IsValid(room.RefEnt) then return end

	return room.RefEnt
end


------------------------------------------------------------
-- HOOK: QuerySkyboxEntity
------------------------------------------------------------
-- Create a hook to query which skybox entity should be active
-- This hook will be called at each location change or at other important times
-- This prevents conflict from multiple codepoints resetting the skybox when it should just be set to something else
hook.Add("Location", "SetSkyboxOverrideLocation", function(ply, loc)
	local ent = hook.Call("QuerySkyboxEntity", GAMEMODE, ply, loc )
	--ply:SetSkyboxEntity(ent)
	ply:SetNWEntity( "SkyboxEntity", ent )
end )


if SERVER then

	-- Add the origin of the skybox entity to the player's PVS
	hook.Add("SetupPlayerVisibility", "AddSkyboxOriginEntity", function(ply)
		local curEnt = ply:GetNWEntity("SkyboxEntity")--ply:GetNet("SkyboxEntity")
		if not IsValid(curEnt) then return end

		-- Add the skycam to the PVS so we see what's going on there
		--AddOriginToPVS( curEnt:GetPos() )
	end )

	-- Hook into location changes so when they enter a condo their skybox is set
	--[[
	hook.Add("Location", "SetCondoSkybox", function(ply, loc)
		local location = Location.Get(loc)
		if location and location.CondoID then
			ply:SetSkyboxEntity()
	end )
	]]
else

	-- Override the skybox with the current active condo skybox entity
	hook.Add("OverrideSkyCamera", "GMTCondoSkyOverride", function(eyepos, eyeangles, skyboxscale )

		-- Grab the current sky entity, if it exists
		local skyEnt = LocalPlayer():GetNWEntity("SkyboxEntity") --LocalPlayer():GetNet("SkyboxEntity")

		if not IsValid(skyEnt)  then return end -- Don't override

		-- Gather up some info
		local SkyPos = skyEnt:GetPos()
		local SkyAng = skyEnt:GetAngles()
		local SkyScale =  skyEnt.GetSkyboxScale and skyEnt:GetSkyboxScale() or 1/16
		local CenterOffset = -eyepos

		-- If it's in condo mode, check condo stuff
		local mode = skyEnt.GetMode and skyEnt:GetMode() or SKYMODE_CONDO
		if mode == SKYMODE_CONDO then
			local curRoomEnt = GetCurrentRoomEntity(LocalPlayer())
			if not IsValid(curRoomEnt) then return end -- Exit out, we're not in a room

			CenterOffset = CenterOffset + curRoomEnt:GetPos()
		elseif mode == SKYMODE_SET then
			CenterOffset = CenterOffset + skyEnt:GetMoveOrigin()
		end

		-- Gross, will only work for condos for now. Figure out how to network a proper origin later
		--local CenterOffset = curRoomEnt:GetPos() - (eyepos + RoomRefOffset )

		-- Set the information, and rotate everything relative to the skyent's rotation as well
		-- This can make the world sideways if we really wanted (Or parented to something, anything is possible!!!!)
		local pos, ang = LocalToWorld(-CenterOffset * SkyScale, eyeangles, SkyPos, SkyAng)

		-- GO
		return pos, ang , SkyScale
	end )

end

--ImplementNW() -- Implement transmit tools instead of DTVars
