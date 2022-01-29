net.Receive( "CustomDeath", function( len, ply )
	local victim = net.ReadEntity()
	local inflictor = net.ReadString()
	local attacker = net.ReadEntity()

	if !IsValid( victim ) || !inflictor || !IsValid( attacker ) then return end

	GAMEMODE:AddDeathNotice( victim:Name(), -1, inflictor, attacker:Name(), -1 )
	GAMEMODE:PlayDeathSound( attacker, inflictor, victim )
end )

local messagetable = {
	// melee
	weapon_toyhammer	= "%attacker squeaked %victim to death",
	weapon_sword		= "%attacker out skilled %victim in a furious sword duel",
	weapon_pulsesmartpen = "%attacker recorded %victim's death",
	weapon_chainsaw		= "%attacker sliced and diced %victim with a chainsaw",

	// pistol
	weapon_neszapper	= "%attacker old skool'd %victim",
	weapon_ragingbull	= "%attacker richocheted %victim",
	weapon_stealthpistol = "%attacker silently assassinated %victim",
	weapon_semiauto		= "%attacker pistol whipped %victim",
	weapon_akimbo		= "%attacker used the mighty akimbo on %victim",

	// smg
	weapon_xm8			= "%attacker tore %victim to shreds using a futuristic gun",
	weapon_thompson		= "%attacker killed %victim in a true gangster fashion",
	weapon_patriot		= "%attacker turned %victim into swiss cheese",

	// shotguns
	weapon_supershotty	= "%attacker blew %victim in half",
	weapon_spas12		= "%attacker pumped %victim full of lead",

	// snipers
	weapon_m1grand		= "%attacker taught %victim how to play COD",
	weapon_sniper		= "%attacker cleverly sniped %victim",
	
	// grenades
	pvp_glauncher_nade	= "%attacker luckily exploded %victim",
	pvp_glauncher_stickynade = "%attacker turned %victim into a human firework",

	// misc
	pvp_babynade		= "%attacker baby'd %victim into pieces",
	pvp_tripmine		= "%attacker made a mockery out of %victim",
	pvp_grenade			= "%attacker exploded %victim with a well placed grenade",
	pvp_chainsaw		= "%attacker ripped %victim apart with a flying chainsaw",

	// special
	weapon_rage			= "%attacker punched the $%&# out of %victim",
	pvp_candycorn		= "%attacker filled %victim with candy",
	suicide				= "%victim suicided",
	tele				= "%attacker telefragged %victim!",
	fall				= "%victim fell to their death",
	fall_gmt_pvp_shard		= "%victim lost their footing",
	fall_gmt_pvp_oneslip	= "%victim drifted off into space",
	fall_gmt_pvp_aether	= "%victim joined the mile die club",
}

local overrideSuicideMessage = { "tele", "fall" }

function GM:AddDeathNotice( Attacker, team1, Inflictor, Victim, team2 )
	local death	= {
		["victim"]	 = Victim,
		["attacker"] = Attacker,
		["weapon"]	 = Inflictor,
	}

	if Attacker == Victim && !table.HasValue( overrideSuicideMessage, death.weapon ) then
		death.weapon = "suicide"
	end

	local message = messagetable[death.weapon] or "%victim mysteriously died" 

	if death.weapon == "fall" then
		message = messagetable[ "fall_" .. Maps.GetCurrentMap() ] || messagetable[ "fall_" .. game.GetMap() ] || messagetable["fall"]
	end

	message = string.gsub(message, "%%(%w+)", death)
	
	if !GTowerChat.Chat then CreateGChat(true) end
	GTowerChat.Chat:AddText( message, Color( 155, 200, 255, 255 ) )

	//chat.AddText(Color( 155, 200, 255, 255 ), message)
end

local death_sound = {
	weapon_neszapper	= "GModTower/pvpbattle/NESZapper/NESKill.wav",
	weapon_patriot		= "GModTower/pvpbattle/Patriot/PatriotKill.wav",
	//weapon_sword		= "GModTower/pvpbattle/Sword/SwordVKill.wav",
	weapon_pulsesmartpen = {
			"GModTower/pvpbattle/PulseSmartPen/YouGotThat1.wav", 
			"GModTower/pvpbattle/PulseSmartPen/YouGotThat2.wav", 
			"GModTower/pvpbattle/PulseSmartPen/YouGotThat3.wav"
	}
}

function GM:PlayDeathSound( victim, inflictor, attacker )
	local sound = death_sound[inflictor]

	if sound then
		if type(sound) == "table" then
			attacker:EmitSound(table.Random(sound))
		else
			victim:EmitSound(sound)
		end
	end
end

function GM:DrawDeathNotice( x, y )
end
