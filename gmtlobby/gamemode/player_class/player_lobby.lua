AddCSLuaFile()
DEFINE_BASECLASS( "player_default" )

if ( CLIENT ) then

	CreateConVar( "cl_playercolor", "0.24 0.34 0.41", { FCVAR_ARCHIVE, FCVAR_USERINFO }, "The value is a Vector - so between 0-1 - not between 0-255" )
	CreateConVar( "cl_playerbodygroups", "0", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The bodygroups to use, if the model has any" )
	-- CreateConVar( "cl_weaponcolor", "0.30 1.80 2.10", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The value is a Vector - so between 0-1 - not between 0-255" )

end

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


--
-- Set up the network table accessors
--
function PLAYER:SetupDataTables()

	BaseClass.SetupDataTables( self )

end

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

player_manager.RegisterClass( "player_lobby", PLAYER, "player_default" )