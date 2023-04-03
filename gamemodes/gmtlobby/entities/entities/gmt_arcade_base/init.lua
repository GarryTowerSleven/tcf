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
games[10] = "dinorun"
games[13] = "superkaroshi"
games[14] = "ngame"
games[4] = "gogohappysmile"
games[21] = "mirrorsedge2d"
games[2] = "patapon"
games[15] = "spritesmash"
games[16] = "heavyweapons"
games[17] = "metalslug"
games[0] = "sorry"

function ENT:Use( ply )
	if CurTime() < self.NextUse then return end
	self.NextUse = CurTime() + 1

	/*umsg.Start("StartGame", ply)
		umsg.Entity(self.Entity)
	umsg.End()*/

	local game = games[self:GetSkin()]

	if game then
		ply:SendLua("RunConsoleCommand(\"gmt_arcade_open\", \"" ..  game .. "\")")
	else
		ply:Msg2( "This machine is currently out of service, try again later!" )
	end

	// ply:Msg2( T( "ArcadeDisable" ) )
	
	local PlyHat = GTowerHats:GetHat( ply )

	if PlyHat != nil then

		if self.Entity.GameIDs[ self.Entity:GetSkin() - 1 ] == "Fancy Pants" && GTowerHats.Hats[ PlyHat ] && GTowerHats.Hats[ PlyHat ].Name == "Top Hat"  then
			ply:SetAchievement( ACHIEVEMENTS.FANCYPANTS, 1 )
		end

	end
end