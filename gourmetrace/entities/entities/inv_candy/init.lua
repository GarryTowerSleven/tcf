AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

sound.Add( {
	name = "Invincibility",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 100,
	pitch = 100,
	sound = "gmodtower/gourmetrace/music/invincibility.wav"
} )

function ENT:CustomTouch( ply )

	ply:SetNet( "Invincible", true )
	music.Play( 1, MUSIC_INVINCIBLE, ply )

	ply:AddAchievement( ACHIEVEMENTS.GRUNTOUCHABLE, 1 )

	timer.Create( "FlashyShit"..ply:EntIndex(), 0.1, 160, function()
		if IsValid(ply) and ply:GetNet( "Invincible" ) then
			if ply:GetMaterial() == "models/props/surf_lt_unicorn/pure_white_nocull" then
				ply:SetMaterial( "", true )
			else
				ply:SetMaterial( "models/props/surf_lt_unicorn/pure_white_nocull", true )

				local vPoint = ply:GetPos() + Vector(0,0,25)
				local effectdata = EffectData()
				effectdata:SetOrigin( vPoint )
				util.Effect( "stars", effectdata )
			end
		end
	end )

	timer.Simple( self.CoolDownTime, function()
		if IsValid( ply ) and ply:GetNet( "Invincible" ) then
			ply:SetNet( "Invincible", false )
			GAMEMODE:ResumeMusic( ply )
			ply:SetMaterial( "", true )
		end
	end )

end
