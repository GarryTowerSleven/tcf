module("GtowerRooms", package.seeall )

DEBUG = false
StoreId = 1
NPCClassName = "gmt_npc_roomlady"
NPCMaxTalkDistance = 128

DefaultSkybox = util.FindSkyboxEnt( "condo_normal" )
PartyCost = 250

-- Doorbells
local DoorbellPath = "GModTower/lobby/condo/doorbells/"
local function NewDoorbell( name, wav )
	local snd = nil
	if wav then snd = clsound.Register( DoorbellPath .. wav .. ".wav" ) end
	return { name = name, snd = snd }
end
Doorbells = {
	NewDoorbell( "Standard", "standard1" ),
	NewDoorbell( "Silent", nil ),

	NewDoorbell( "Ding-Dong", "standard2" ),
	NewDoorbell( "Ambient", "Ambient1" ),

	NewDoorbell( "Happy", "happy1" ),
	NewDoorbell( "Happy 2", "happy2" ),

	NewDoorbell( "Spooky", "spooky1" ),
	NewDoorbell( "Spooky 2", "spooky2" ),
	NewDoorbell( "Spooky 3", "spooky3" ),

	NewDoorbell( "Disco", "disco1" ),
	NewDoorbell( "Disco 2", "disco2" ),
	NewDoorbell( "Disco 3", "disco3" ),

	NewDoorbell( "French", "french1" ),
	NewDoorbell( "French 2", "french2" ),
	NewDoorbell( "French 3", "french3" ),

	NewDoorbell( "Jazzy", "jazzy1" ),
	NewDoorbell( "Jazzy 2", "jazzy2" ),
	NewDoorbell( "Jazzy 3", "jazzy3" ),

	NewDoorbell( "Funky", "funky1" ),
	NewDoorbell( "Funky 2", "funky2" ),
	NewDoorbell( "Funky 3", "funky3" ),
	NewDoorbell( "Funky 4", "funky4" ),

	NewDoorbell( "Robot", "robot1" ),
	NewDoorbell( "Robot 2", "robot2" ),

	NewDoorbell( "Vocoder", "vocoder1" ),
	NewDoorbell( "Vocoder 2", "vocoder2" ),
}

-- Skyboxes
local SkyboxPreviewPath = "gmod_tower/panelos/skys/"
local function NewSkybox( name, cam, preview )
	return { name = name, cam = cam, preview = Material( SkyboxPreviewPath .. preview .. ".png" ) }
end
Skyboxes = {
	NewSkybox( "Default", DefaultSkybox, "default.png" ),
	NewSkybox( "Beach", "condo_beach", "beach.png" ),
}

function CanManagePanel( room, ply )

	if not room then return false end

	local canuse = room.RefEnt and ply == room.RefEnt:GetOwner()
	if ply:IsAdmin() then return true, not canuse end -- Admins can always use panels.

	return canuse

end

hook.Add("LoadAchivements","AchiSuite", function ()

	GtowerAchivements:Add( ACHIVEMENTS.SUITEOCD, {
		Name = "OCD",
		Description = "Move any furniture item more than 100 times.",
		Value = 100,
		Group = 3
	})

	GtowerAchivements:Add( ACHIVEMENTS.SUITEPICKUPLINE, {
		Name = "Best Pickup Line",
		Description = "Talk to the condo lady while drunk.",
		Value = 1,
		Group = 3
	})

	GtowerAchivements:Add( ACHIVEMENTS.SUITELADYAFF, {
		Name = "Condo Lady Affixation",
		Description = "Talk to the condo lady more than 250 times.",
		Value = 250,
		Group = 3
	})

	GtowerAchivements:Add( ACHIVEMENTS.SUITEYOUTUBE, {
		Name = "YouTube Addiction",
		Description = "Watch TV for more than 10 hours.",
		Value = 10 * 60,
		Group = 3,
		GiveItem = "trophy_youtubeaddiction"
	})

	GtowerAchivements:Add( ACHIVEMENTS.SUITELEAVEMEALONE, {
		Name = "Leave Me Alone",
		Description = "Kick more than 15 players out of your condo.",
		Value = 15,
		Group = 3
	})

	GtowerAchivements:Add( ACHIVEMENTS.SUITEPARTY, {
		Name = "Party Animal",
		Description = "Have 4 or more players in your condo for an hour total.",
		Value = 60,
		Group = 3
	})

end )

function PositionInRoom( pos )

	for k, room in pairs( Rooms ) do

		if room.EndPos && room.StartPos then
			if IsVecInRoom( room, pos ) then
				return k
			end
		end

	end

	return nil
end

function IsVecInRoom( roomtable, vec )
	return PosInBox( vec, roomtable.EndPos, roomtable.StartPos )
end

function PosInBox( pos, min, max )
	return pos.x > min.x and pos.y > min.y and pos.z > min.z and
           pos.x < max.x and pos.y < max.y and pos.z < max.z
end

function RecvPlayerRoom(ply, name, old, new)
	if new > 0 then
		ReceiveOwner(ply, new)
	end
end

RegisterNWTablePlayer({
	{"GRoomLock", false, NWTYPE_BOOLEAN, REPL_EVERYONE },
	{"GRoomId", 0, NWTYPE_CHAR, REPL_EVERYONE, RecvPlayerRoom },
	{"GRoomEntityCount", 999, NWTYPE_NUMBER, REPL_PLAYERONLY },
})
