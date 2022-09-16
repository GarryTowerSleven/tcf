---------------------------------
ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName		= "Galaga"
ENT.Contact			= ""
ENT.Purpose			= "GMT: Deluxe"
ENT.Instructions	= ""
ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.Model		= "models/gmod_tower/gba.mdl"

util.PrecacheModel( ENT.Model )

ENT.SoundList = {
	"GModTower/arcade/Tetris_Music.mp3",
	"GModTower/arcade/Tetris_Gameover.wav", // when lose
	"GModTower/arcade/Tetris_Clear.wav", // When a row has be removed
	"GModTower/arcade/Tetris_Full.wav", // before gameover
	"GModTower/arcade/Tetris_Rotate.wav", // Rotate
	"GModTower/arcade/Tetris_Gamestart.wav", //
	"GModTower/arcade/Tetris_HitBottom.wav", // when a piece is stopped
	"GModTower/arcade/Tetris_Move.wav"
}

ENT.DoorHeight = 77
ENT.DoorWidth = 44

ENT.NegativeStartX = ENT.DoorWidth / -2
ENT.NegativeStartY = -ENT.DoorHeight

ENT.WidthSize = 10

function ENT:OnGame()
	return self:GetNWBool("initGame")
end

hook.Add("GTowerPhysgunPickup", "DisableTetris", function(pl, ent)
	if IsValid( ent ) && ent:GetClass() == "gmt_tetris" then
		return !IsValid( ent.Ply )
	end
end )

function ENT:CanUse( ply )

		return true, "PLAY"
end

