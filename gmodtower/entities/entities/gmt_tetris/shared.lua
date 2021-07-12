---------------------------------
ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName		= "Tetris door"
ENT.Author			= "Nican"
ENT.Contact			= ""
ENT.Purpose			= "For GMod Tower"
ENT.Instructions	= ""
ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.Model		= "models/gmod_tower/gba.mdl"

GtowerPrecacheModel( ENT.Model )

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

GtowerPrecacheSoundTable( ENT.SoundList )

ENT.MusicLength = 38

ENT.DoorHeight = 77
ENT.DoorWidth = 44

ENT.NegativeStartX = ENT.DoorWidth / -2
ENT.NegativeStartY = -ENT.DoorHeight


hook.Add("LoadAchivements","AchiTetris", function ()

	GtowerAchivements:Add( ACHIVEMENTS.TETRISMANYPOINTS, {
		Name = "Tetris Jesus",
		Description = "Gain more than 5000 points in Tetris.",
		Value = 5000,
		Group = 4
	})

	GtowerAchivements:Add( ACHIVEMENTS.TETRISMUCHTIME, {
		Name = "Tetris Lover",
		Description = "Play Tetris for more than 4 hours.",
		Value = 240,
		Group = 4
	})

	GtowerAchivements:Add( ACHIVEMENTS.TETRIS4ONETIME, {
		Name = "Long Savior",
		Description = "Clean 4 rows at once.",
		Value = 1,
		Group = 4
	})

	GtowerAchivements:Add( ACHIVEMENTS.TETRIS1000AGAME, {
		Name = "Patience and Skill",
		Description = "Get more than 1000 points in one game.",
		Value = 1000,
		Group = 4
	})


end )

hook.Add( "PlayerFootstep", "TetrisFootstep", function(ply)

	if ply.InTetris then return true end

end)

function ENT:NumToXY( num )

	local NumBlocks = 10 //self:WidthSize()

	local x = num % NumBlocks
	local y = (num - x) / NumBlocks

	return x,y

end

function ENT:NumToXY2( num1, num2 )

	local NumBlocks = 8 //self:WidthSize()

	local x = ( (num1*NumBlocks) / NumBlocks ) + 7
	local y = ( num2 % NumBlocks ) + 2

	return x,y

end

function ENT:XYToNum( x, y )

	local NumBlocks = 10 //self:WidthSize()

	return y * NumBlocks + x
end

ENT.WidthSize = 10


function ENT:OnGame()
	return self:GetNetworkedBool("initGame")
end

hook.Add("GTowerPhysgunPickup", "DisableTetris", function(pl, ent)
	if IsValid( ent ) && ent:GetClass() == "gmt_tetris" then
		return !IsValid( ent.Ply )
	end
end )

function ENT:CanUse( ply )
		return true, "PLAY"
end
