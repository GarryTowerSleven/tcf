---------------------------------
ENT.Type 	= "anim"
ENT.Base 	= "base_anim"

ENT.Model	= Model("models/gmod_tower/mikuclock.mdl")

ENT.Songs = {"GModTower/lobby/mikuclock/mikuclock_song|.mp3", 18} --Second value is the amount of songs, starting from 01.

function ENT:Precache()
	local tbl, str, strSong = {}, string.Explode("|", self.Songs[1])
	
	local function convertNum(num)
		if num >= 0 and num <= 9 then return tostring(0 .. num) end
		return num
	end
	
	for i = 1, self.Songs[2] do
		strSong = str[1] .. convertNum(i) .. str[2]
		table.insert(tbl, strSong)
	end
	
	self.Songs = tbl
end