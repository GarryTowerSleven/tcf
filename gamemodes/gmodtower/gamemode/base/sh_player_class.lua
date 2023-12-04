AddCSLuaFile()
DEFINE_BASECLASS( "player_default" )

if ( CLIENT ) then

	CreateConVar( "gmt_playercolor", "0.24 0.34 0.41", { FCVAR_ARCHIVE, FCVAR_USERINFO }, "The value is a Vector - so between 0-1 - not between 0-255" )
	CreateConVar( "cl_playerbodygroups", "0", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The bodygroups to use, if the model has any" )
	CreateConVar( "cl_weaponcolor", "0.30 1.80 2.10", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The value is a Vector - so between 0-1 - not between 0-255" )

end

local PLAYER = {}

PLAYER.DisplayName = "GMT Player"

PLAYER.WalkSpeed 			= 200
PLAYER.RunSpeed				= 320
PLAYER.SlowWalkSpeed		= 100

function PLAYER:SetupDataTables()

    BaseClass.SetupDataTables( self )

end

function PLAYER:Loadout() end

function PLAYER:Spawn()

	BaseClass.Spawn( self )

	local plyclr = self.Player:GetInfo( "gmt_playercolor" )
	self.Player:SetPlayerColor( Vector( plyclr ) )

	local wepclr = Vector( self.Player:GetInfo( "cl_weaponcolor" ) )
	if ( wepclr:Length() < 0.001 ) then
		wepclr = Vector( 0.001, 0.001, 0.001 )
	end
	self.Player:SetWeaponColor( wepclr )

end

player_manager.RegisterClass( "player_gmt", PLAYER, "player_default" )