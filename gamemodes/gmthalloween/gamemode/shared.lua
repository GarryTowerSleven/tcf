GM.Name 	= "GMod Tower: Halloween" // name the same so they stack in the server browser
GM.Author   = "GMod Tower Team"
GM.Website  = "http://www.gmtower.org/"

// === GMT SETUP ===
DeriveGamemode( "gmtgamemode" )
SetupGMTGamemode( "Halloween", "gmthalloween", {
	Loadables = { "weaponfix", "seats" }, // Additional loadables
	AFKDelay = 600, // Seconds before they will be marked as AFK
	DisableSmallModels = true,
	DisableJumping = true,
	DisableDucking = true,
} )

--[[function GM:PlayerFootstep( ply, vPos, iFoot, strSoundName, fVolume, pFilter )

	local rnd = math.random(1,2)
	if iFoot == 2 then rnd = math.random(3,4) end

	sound.Play( "room209/carpet"..rnd..".wav", vPos, 75, math.random( 90, 100 ), fVolume/2 )
	
	return true
	
end]]

GM.SpawnProtectDelay = 3
GM.NoSpawnRadius = 80
GM.SpawnRadius = 2048

function GM:IsValidSpawn( spawn )

	// Check if something is blocking it
	for _, ent in ipairs( ents.GetAll() ) do

		if ( ent:IsPlayer() || ent:IsNextBot() ) && self:IsInRadius( ent, spawn, self.NoSpawnRadius ) then
			return false
		end

	end

	// Find players near by
	for _, ply in pairs( player.GetAll() ) do

		if ply:Alive() && self:IsInRadius( ply, spawn, self.SpawnRadius ) then
			return true
		end

	end

	return false

end

function GM:IsInRadius( ent1, ent2, radius )
	return ent2:GetPos():Distance( ent1:GetPos() ) < radius
end