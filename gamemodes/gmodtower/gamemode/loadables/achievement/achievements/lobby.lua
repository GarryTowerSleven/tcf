GTowerAchievements:Add( ACHIEVEMENTS.GTOWERADDICTION, {
	Name = "Tower Addiction", 
	Description = "Play on Tower for 7 days (".. (60*24*7) .." minutes)", 
	Value = 60*24*7,
	GiveItem = "trophy_gmodtoweraddiction",
	GMC = 25000
})

GTowerAchievements:Add( ACHIEVEMENTS.HUMANBLUR, {
	Name = "Human Blur", 
	Description = "Fall from the top of the lobby.", 
	Value = 1,
	GiveItem = "trophy_humanblur"
})

GTowerAchievements:Add( ACHIEVEMENTS.WALKTOOLONG, {
	Name = "Long Walk Through GMT",
	Description = "Walk more than 200,000 feet.", 
	Value = 200000,
	GiveItem = "trophy_longwalk",
	GMC = 10000
})

GTowerAchievements:Add( ACHIEVEMENTS.ZOMBIERP, {
	Name = "Zombie RP", 
	Description = "Roleplay as a zombie.",
	GMC = 100,	
	Value = 1
})

GTowerAchievements:Add( ACHIEVEMENTS.JUMPINGJACK, {
	Name = "Jumping Jack Rabbit", 
	Description = "Jump 100,000 times.", 
	Value = 100000,
	GiveItem = "trophy_jackrabbit",
	GMC = 25000
})

GTowerAchievements:Add( ACHIEVEMENTS.SUITEOCD, {
	Name = "OCD",
	Description = "Move any furniture item more than 100 times.", 
	Value = 100,
	GMC = 100,
	Group = 3
})
	
GTowerAchievements:Add( ACHIEVEMENTS.SUITEPICKUPLINE, {
	Name = "Best Pickup Line",
	Description = "Talk to the suite lady while drunk.", 
	Value = 1,
	GMC = 150,
	Group = 3
})

GTowerAchievements:Add( ACHIEVEMENTS.SUITELADYAFF, {
	Name = "Suite Lady Affixation",
	Description = "Talk to the suite lady more than 250 times.", 
	Value = 250,
	Group = 3
})

GTowerAchievements:Add( ACHIEVEMENTS.SUITEYOUTUBE, {
	Name = "YouTube Addiction",
	Description = "Watch TV for more than 10 hours.", 
	Value = 10 * 60,
	Group = 3,
	GMC = 1500,
	GiveItem = "trophy_youtubeaddiction"
})

GTowerAchievements:Add( ACHIEVEMENTS.SUITELEAVEMEALONE, {
	Name = "Leave Me Alone",
	Description = "Kick more than 15 players out of your suite.", 
	Value = 15,
	GMC = 150,
	Group = 3
})

GTowerAchievements:Add( ACHIEVEMENTS.SUITEBARTENDER, {
	Name = "Give Me A Drink, Bartender",
	Description = "Blend more than 50 drinks using a blender.", 
	Value = 50,
	Group = 3
})

GTowerAchievements:Add( ACHIEVEMENTS.SUITEPARTY, {
	Name = "Party Animal",
	Description = "Have 4 or more players in your suite for an hour total.", 
	Value = 60,
	GMC = 1000,
	Group = 3
})

GTowerAchievements:Add( ACHIEVEMENTS.DRUNKENBASTARD, {
	Name = "Drunken Bastard", 
	Description = "Be drunk for more than 10 minutes straight in one go.", 
	Value = 10*60,
	GiveItem = "trophy_drunkenbastard"
})

GTowerAchievements:Add( ACHIEVEMENTS.CURIOUSCAT, {
	Name = "Curious Cat", 
	Description = "Open 50 mysterious cat sacks.", 
	GMC = 250,
	Value = 50
})

GTowerAchievements:Add( ACHIEVEMENTS.PILLSHERE, {
	Name = "Hardcore Detective", 
	Description = "Eat 50 painkillers.", 
	GMC = 250,
	Value = 50
})

GTowerAchievements:Add( ACHIEVEMENTS.DOMESTICABUSE, {
	Name = "Domestic Abuse", 
	Description = "Break an empty bottle with your body, willingly, or unwillingly.", 
	GMC = 100,
	Value = 1
})

GTowerAchievements:Add( ACHIEVEMENTS.TRASHCOMPACTOR, {
	Name = "Trash Compactor", 
	Description = "Break 100 empty bottles.",
	Value = 100
})

GTowerAchievements:Add( ACHIEVEMENTS.LONGSEATGETALIFE, {
	Name = "Get a Life",
	Description = "Sit for more than 5 hours.",
	Value = 5 * 60
})

GTowerAchievements:Add( ACHIEVEMENTS.SMARTINVESTER, {
	Name = "'Smart' Investor", 
	Description = "Spend a total of 1,000 GMC on beer.",
	GMC = 1001,
	Value = 1000
})

GTowerAchievements:Add( ACHIEVEMENTS.HOLEINPOCKET, {
	Name = "Hole In Your Pocket", 
	Description = "Spend a total of 5,000 GMC.", 
	Value = 5000
})

/*GTowerAchievements:Add( ACHIEVEMENTS.TRIVIAMASTER, {
	Name = "Trivia Master", 
	Description = "Win a round of GMT Trivia.", 
	Value = 1,
	Group = 4
})

GTowerAchievements:Add( ACHIEVEMENTS.MILLIONAIRE, {
	Name = "Trivia Millionaire", 
	Description = "Win 100 GMT Trivia games.", 
	Value = 100,
	Group = 4
})*/

GTowerAchievements:Add( ACHIEVEMENTS.ZELDAFANBOY, {
	Name = "Zelda Fanboy", 
	Description = "Buy all Zelda-related hats.", 
	Value = 3,
	GMC = 250,
	GiveItem = "trophy_zeldafanboy"
})

GTowerAchievements:Add( ACHIEVEMENTS.FANCYPANTS, {
	Name = "Fancy Pants", 
	Description = "Play Fancy Pants Adventure while wearing a top hat.", 
	Value = 1,
	Group = 4,
	GMC = 250,
	GiveItem = "trophy_fancypants"
})

GTowerAchievements:Add( ACHIEVEMENTS.TETRISMANYPOINTS, {
	Name = "Tetris Jesus", 
	Description = "Gain more than 5000 points in Tetris.", 
	Value = 5000,
	GMC = 1000,
	Group = 4
})
	
GTowerAchievements:Add( ACHIEVEMENTS.TETRISMUCHTIME, {
	Name = "Tetris Lover", 
	Description = "Play Tetris for more than 4 hours.", 
	Value = 240,
	GMC = 1500,
	Group = 4
})

GTowerAchievements:Add( ACHIEVEMENTS.TETRIS4ONETIME, {
	Name = "Long Savior", 
	Description = "Clean 4 rows at once in Tetris.", 
	Value = 1,
	Group = 4
})

GTowerAchievements:Add( ACHIEVEMENTS.TETRIS1000AGAME, {
	Name = "Patience and Skill", 
	Description = "Get more than 1000 points in one Tetris game.", 
	Value = 1000,
	Group = 4
})

GTowerAchievements:Add( ACHIEVEMENTS.TICTACTOEWIN, {
	Name = "30 Tic-Tacs", 
	Description = "Win a total of 30 Tic-Tac-Toe games.", 
	Value = 30,
	Group = 4
})
	
GTowerAchievements:Add( ACHIEVEMENTS.TICTACTOEPERSITANT, {
	Name = "Tic-Tac-Toe Master", 
	Description = "Play 100 Tic-Tac-Toe games.", 
	Value = 100,
	Group = 4
})

GTowerAchievements:Add( ACHIEVEMENTS.HUGMYLIFE, {
	Name = "Hug My Life", 
	Description = "Suicide gun yourself 200 times.",
	GMC = 200,
	Value = 200
})

GTowerAchievements:Add( ACHIEVEMENTS.GEOMETRICALLY, {
	Name = "Geometrically Impossible", 
	Description = "Purchase all the orbs available in the Ball Race store.", 
	Value = 7,
	GMC = 1000,
	GiveItem = "trophy_geometricallyimpossible"	
})

GTowerAchievements:Add( ACHIEVEMENTS.PLAYERMODEL, {
	Name = "My Own Man", 
	Description = "Purchase a new player model.", 
	Value = 1,
})

/*GTowerAchievements:Add( ACHIEVEMENTS.SUITEPOKERFACE, {
	Name = "Poker Face© 2009",
	Description = "Play a song about poker faces.", 
	Value = 1,
	Group = "Suite",
})*/

/*GTowerAchievements:Add( ACHIEVEMENTS.DVNO, {
	Name = "DVNO 2010",
	Description = "Hear a song about four capital letters printed in gold.", 
	Value = 1
})*/

GTowerAchievements:Add( ACHIEVEMENTS.SIDEBYSIDE, {
	Name = "Fighting Side by Side",
	Description = "Go into a duel while there already is a duel active.",
	Value = 1,
})

GTowerAchievements:Add( ACHIEVEMENTS.ITCHING, {
	Name = "Itching For Fights",
	Description = "Commence in more than 15 duels.",
	Value = 15,
})

/* the achievement has issues + the arcades aren't all there
GTowerAchievements:Add( ACHIEVEMENTS.ARCADEJUNKIE, {
	Name = "Arcade Junkie", 
	Description = "Play each flash arcade game. ", 
	Value = Count,
	Group = 4,
	BitValue = true,
	GiveItem = "trophy_arcadejunkie"
})
*/

/*GTowerAchievements:Add( ACHIEVEMENTS.CANDYCORNCONSUMER, {
	Name = "Candy Corn Consumer",
	Description = "Consume one million candy corns.", 
	Value = 1000000,
	Group = 1,
})*/

GTowerAchievements:Add( ACHIEVEMENTS.ONESMALLSTEP, {
	Name = "One Small Step for Man", 
	Description = "Explore deep space.", 
	Value = 1
})

/*GTowerAchievements:Add( ACHIEVEMENTS.ADMINABUSE, {
	Name = "Admin Abuse",
	Description = "Be slapped by an admin twice.", 
	Value = 2
})*/

// LOGIC OF ACHIEVEMENTS---------------------
if CLIENT then return end

// GMT Addict
timer.Create( "AchiGTowerAddict", 60.0, 0, function()

	for _, v in ipairs( player.GetAll() ) do
		if v:AchievementLoaded() then
			v:AddAchievement(  ACHIEVEMENTS.GTOWERADDICTION, 1 )
		end
	end

end )

// Jumping jack rabbit
hook.Add( "KeyPress", "CheckJumpAchievement", function( ply, key )

	if ply:AchievementLoaded() && key == IN_JUMP && 
		ply:OnGround() && !ply:InVehicle() && 
		ply:Alive() && (!ply.NextJump || CurTime() > ply.NextJump) then

		ply.NextJump = CurTime() + 0.5
		ply:AddAchievement( ACHIEVEMENTS.JUMPINGJACK, 1 )

	end

end )

local PlysLastPlace = {}

hook.Add( "PlayerThink", "PlayerThinkAchievements", function( ply )

	if ply:AchievementLoaded() && ply:Alive() then

		// Long Walk
		local PlyIndex = ply:EntIndex()
		local CurPos = ply:GetPos()

		if ( ply:IsOnGround() ) then
			if PlysLastPlace[ PlyIndex ] then
				
				local Distance = PlysLastPlace[ PlyIndex ]:Distance( CurPos )
			
				if Distance > 0 then -- Unsure why && Distance > 150 was in here.. Anyone know? Will need to test myself but I believe a LESS THAN check would be proper.
					ply:AddAchievement( ACHIEVEMENTS.WALKTOOLONG, Distance / 16 )
				end
			end
			
			PlysLastPlace[ PlyIndex ] = CurPos
		else
			PlysLastPlace[ PlyIndex ] = nil
		end
		

		// Zombie RP
		if ply:GetModel() == "models/player/zombie_classic.mdl" && GTowerHats:IsWearing( ply, "hatheadcrab" ) then

			ply:SetAchievement( ACHIEVEMENTS.ZOMBIERP, 1 )

			if IsLobby then
				ply._WasZombie = true
				ply:SetWalkSpeed( 45 )
			end

		else

			if IsLobby then
				if ply._WasZombie then
					ply:ResetSpeeds()
					ply._WasZombie = false
				end
			end

		end

	end

end )

hook.Add( "PlayerDisconnected", "ResetLongWalk", function( ply )
	
	PlysLastPlace[ ply:EntIndex() ] = nil
	
end )

hook.Add( "PlayerLevel", "PlayerLevelAchievement", function( ply )

	if GTowerAchievements then

		// Zelda Fanboy
		if !ply:Achived( ACHIEVEMENTS.ZELDAFANBOY ) then

			local addition = ply:GetLevel("hatlinkhat") + ply:GetLevel("hatfairywings" /* Midna's Mask */) + ply:GetLevel("hatmajorasmask") + ply:GetLevel("keatonmask") + ply:GetLevel("makarmask")
			ply:SetAchievement( ACHIEVEMENTS.ZELDAFANBOY, addition )

		end

		// Geometrically impossible
		if !ply:Achived( ACHIEVEMENTS.GEOMETRICALLY ) then

			local addition = ply:GetLevel("BallRacerCube") + ply:GetLevel("BallRacerIcosahedron") + ply:GetLevel("BallRacerCatBall") +
							 ply:GetLevel("BallRacerBomb") + ply:GetLevel("BallRacerGeo") + ply:GetLevel("BallRacerSoccerBall") + 
							 ply:GetLevel("BallRacerSpikedd")

			ply:SetAchievement( ACHIEVEMENTS.GEOMETRICALLY, addition )

		end
		
	end

end )

// Player model purchase, smart invester, hole in pocket
hook.Add( "StorePurchaseFinish", "PlayerModelAchievement", function( ply, item, money )

	local storeid = item.storeid

	if storeid == GTowerStore.PLAYERMODEL then

		if !ply:Achived( ACHIEVEMENTS.PLAYERMODEL ) then
			ply:SetAchievement( ACHIEVEMENTS.PLAYERMODEL, 1 )
		end

	end

	if storeid == GTowerStore.BAR && item.Name != "Empty Bottle" then
		ply:AddAchievement( ACHIEVEMENTS.SMARTINVESTER, money )
	end

	ply:AddAchievement( ACHIEVEMENTS.HOLEINPOCKET, money )

end )

if IsLobby then 
	// Human Blur
	hook.Add( "OnPlayerHitGround", "HumanBlurCheck", function( ply )

		if ( !ply:Achived( ACHIEVEMENTS.HUMANBLUR ) && Location.Is( ply:Location(), "Lobby" ) && Location.Is( ply._LastLocation, "Lobby Roof" ) ) then
			ply:SetAchievement( ACHIEVEMENTS.HUMANBLUR, 1 )
		end

	end)

	// One Small Step
	hook.Add( "Location", "MoonAchiCheck", function( ply, loc, lastloc )

		if IsValid( ply ) then

			if Location.Is( loc, "Moon" ) then
				if ( !ply:Achived( ACHIEVEMENTS.ONESMALLSTEP ) ) then
					ply:SetAchievement( ACHIEVEMENTS.ONESMALLSTEP, 1 )
				end
				ply.MoonStoreModel = ply:GetModel()
				ply:SetModel("models/player/spacesuit.mdl")
				ply:SetGravity(0.4)
			elseif !Location.Is( loc, "Moon" ) && Location.Is( lastloc, "Moon" ) then
				ply:SetGravity(0)
				ply:SetModel(ply.MoonStoreModel)
			end

		end

	end )
end
