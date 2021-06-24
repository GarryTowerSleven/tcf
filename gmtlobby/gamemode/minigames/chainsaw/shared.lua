local Vector, Angle = Vector, Angle
local CurTime = CurTime

local IsValid = IsValid

local GTowerLocation = GTowerLocation

module("minigames.chainsaw")

MinigameName = "Chainsaw Battle"
MinigameLocation = 16
MinigameMessage = "MiniBattleGameStart"
MinigameArg1 = MinigameName
MinigameArg2 = GTowerLocation:GetName( MinigameLocation )

WeaponName = "weapon_chainsaw"
SpawnPos = Vector(2676.160889, -18.642038, -887.967468)
SpawnThrow = Angle(10,90,0)
