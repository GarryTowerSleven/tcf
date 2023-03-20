local Location = Location

module("minigames.pvpnarnia",package.seeall )

MinigameName = "PVP Narnia"
MinigameLocation = Location.GetIDByName( "Narnia" )
MinigameMessage = "MiniBattleGameStart"
MinigameArg1 = "PVP Battle"
MinigameArg2 = Location.GetFriendlyName( MinigameLocation )
