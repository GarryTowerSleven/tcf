AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:KeyValue(key, value)
	if key == "skin" then
		self.Skin = tonumber(value)
	end
end

function ENT:Initialize()

	if self.Skin == nil then
		self.Skin = 0
	end

	self.Entity:SetModel( self.Model )

	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_NONE )

	local phys = self:GetPhysicsObject()

	if IsValid( phys ) then
		phys:EnableMotion( false )
	end

	self.NextUse = 0

	self:SetSkin(self.Skin)
end

local games = {}
games[3] = "the_fancy_pants_adventures"
games[8] = "portal"
// games[19] = "hoverkart"
games[9] = "thegame"
games[6] = "supermario63"
games[5] = "neverendinglight"
games[7] = "shift"
games[12] = "thelaststand"
//games[10] = "dinorun"
games[13] = "superkaroshi"
// games[14] = "ngame"
games[4] = "gogohappysmile"
//games[21] = "mirrorsedge2d"
//games[2] = "patapon"
games[15] = "spritesmash"
games[16] = "heavyweapons"
//games[17] = "metalslug"
games[0] = "sorry"

local nicenames = {
	[3] = "The Fancy Pants Adventures",
	[8] = "Portal",
	[19] = "Hoverkart",
	[9] = "The Game",
	[6] = "Super Mario 63",
	[5] = "Neverending Light",
	[7] = "Shift",
	[12] = "The Last Stand",
	[10] = "Dino Run",
	[13] = "Super Karoshi",
	[14] = "N Game",
	[4] = "GoGo Happy & Smile",
	[21] = "Mirror's Edge 2D",
	[2] = "Patapon",
	[15] = "Sprite Smash",
	[16] = "Heavy Weapons",
	[17] = "Metal Slug",
	[0] = "Game Not Found",
}

function ENT:Use( ply )
	if CurTime() < self.NextUse then return end
	self.NextUse = CurTime() + 1

	/*umsg.Start("StartGame", ply)
		umsg.Entity(self.Entity)
	umsg.End()*/

	local game = games[self:GetSkin()]
	local nicename = nicenames[self:GetSkin()]

	if game then
		ply:SendLua("RunConsoleCommand(\"gmt_arcade_open\", \"" ..  game .. "\", \"" .. (nicename or "Arcade") .. "\")")
	else
		ply:Msg2( "This machine is currently out of service, try again later!" )
	end

	// ply:Msg2( T( "ArcadeDisable" ) )

	if game == "the_fancy_pants_adventures" and ( Hats.IsWearing( ply, "gmodtophat" ) or Hats.IsWearing( ply, "hattophat" ) ) then
		ply:SetAchievement( ACHIEVEMENTS.FANCYPANTS, 1 )
	end
	
end