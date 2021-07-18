local Vector, Angle = Vector, Angle
local CurTime = CurTime

local IsValid = IsValid

local Location = Location

module("minigames.snowbattle")

MinigameName = "Blizzard Storm"
MinigameLocation = 45
MinigameMessage = "MiniBattleGameStart"
MinigameArg1 = "Snowball Fight"
MinigameArg2 = Location.GetFriendlyName( MinigameLocation )

WeaponName = "weapon_snowball_death"
SpawnPos = Vector(-3986.153564, 733.518677, -754.026855)
SpawnThrow = Angle(10,90,0)
