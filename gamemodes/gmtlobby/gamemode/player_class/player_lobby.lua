AddCSLuaFile()
DEFINE_BASECLASS( "player_gmt" )

local PLAYER = {}

PLAYER.DisplayName			= "Lobby"

PLAYER.CanUseFlashlight     = true		-- Can we use the flashlight
PLAYER.MaxHealth			= 100		-- Max health we can have
PLAYER.StartHealth			= 100		-- How much health we start with
PLAYER.StartArmor			= 0			-- How much armour we start with
PLAYER.DropWeaponOnDie		= false		-- Do we drop our weapon when we die
PLAYER.TeammateNoCollide 	= true		-- Do we collide with teammates or run straight through them
PLAYER.AvoidPlayers			= false		-- Automatically swerves around other players

PLAYER.DuckSpeed			= .3		-- How fast to go from not ducking, to ducking
PLAYER.UnDuckSpeed			= .25		-- How fast to go from ducking, to not ducking

PLAYER.WalkSpeed 			= 180
PLAYER.RunSpeed				= 320
PLAYER.SlowWalkSpeed		= 100

function PLAYER:Spawn()

	self.Player:AllowFlashlight( true )
	self.Player:SetShouldPlayPickupSound( false )

	-- self.Player:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self.Player:SetDSP( 0 )
	self.Player:CrosshairDisable()

end

--
-- Called on spawn to give the player their default loadout
--
function PLAYER:Loadout()

	local hands = "gmt_hands"

	self.Player.CanPickupWeapons = true
		self.Player:Give( hands )
	self.Player.CanPickupWeapons = false

	self.Player:SelectWeapon( hands )

end

function PLAYER:SetModel()
end

player_manager.RegisterClass( "player_lobby", PLAYER, "player_gmt" )