local Vector, Angle = Vector, Angle
local CurTime = CurTime

local IsValid = IsValid
local Location = Location

module("minigames.balloonpop")

MinigameName = "Balloon Pop"
MinigameLocation = Location.GetIDByName( "Lobby" )
MinigameMessage = "MiniBalloonGameStart"

WeaponName = "weapon_crossbow"
WeaponAmmo = "XBowBolt"
