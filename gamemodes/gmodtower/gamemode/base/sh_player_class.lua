AddCSLuaFile()
DEFINE_BASECLASS( "player_default" )

local PLAYER = {}

PLAYER.DisplayName = "GMT Player"

PLAYER.WalkSpeed 			= 200
PLAYER.RunSpeed				= 320
PLAYER.SlowWalkSpeed		= 100

function PLAYER:SetupDataTables()

    BaseClass.SetupDataTables( self )
    plynet.Initialize( self.Player )

end

function PLAYER:Loadout() end

player_manager.RegisterClass( "player_gmt", PLAYER, "player_default" )