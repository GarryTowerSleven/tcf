local Vector, Angle = Vector, Angle
local CurTime = CurTime

local IsValid = IsValid

local Location = Location

module("minigames.chainsaw")

MinigameName = "Chainsaw Battle"
MinigameLocation = "centerplaza"
MinigameMessage = "MiniBattleGameStart"
MinigameArg1 = MinigameName
MinigameArg2 = Location.GetFriendlyName( Location.GetIDByName( MinigameLocation ) )

WeaponName = "weapon_chainsaw"
SpawnPos = Vector(2676.160889, -18.642038, -887.967468)
SpawnThrow = Angle(10,90,0)
