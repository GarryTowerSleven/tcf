module( "particle_system", package.seeall )

function LoadBaseParticles( ... )

	local tbl = {...}
	for _, file in pairs( tbl ) do

		local realFile = "particles/" .. file .. ".lua"
		if !file.Exists( realFile, "LUA" ) then MsgN( file .. " doesn't exist!" ) continue end

		if CLIENT then
			include( realFile )
		else
			AddCSLuaFile( realFile )
		end

	end

end