module("Hats", package.seeall )

Attachments = {
	EYES = 1,
	Spine = 2,
	Pelvis = 3,
	RHand = 4,
	LHand = 5,
	RFoot = 6,
	LFoot = 7
}

AttachmentsList = {
	[Attachments.EYES] = {
		Name = "Eyes",
		Key = "eyes",
		IsBone = false
	},
	[Attachments.Spine] = {
		Name = "Spine",
		Key = "ValveBiped.Bip01_Spine2",
		IsBone = true
	},
	[Attachments.Pelvis] = {
		Name = "Pelvis",
		Key = "ValveBiped.Bip01_Pelvis",
		IsBone = true
	},
	[Attachments.RHand] = {
		Name = "Right Hand",
		Key = "ValveBiped.Bip01_R_Hand",
		IsBone = true
	},
	[Attachments.RFoot] = {
		Name = "Right Foot",
		Key = "ValveBiped.Bip01_R_Foot",
		IsBone = true
	},
	[Attachments.LHand] = {
		Name = "Left Hand",
		Key = "ValveBiped.Bip01_L_Hand",
		IsBone = true
	},
	[Attachments.LFoot] = {
		Name = "Left Foot",
		Key = "ValveBiped.Bip01_L_Foot",
		IsBone = true
	}
}

List = {
	[0] = {
			name = "No Hat",
			description = "Remove hat.",
			price = 0,     
			model = "models/gmod_tower/no_hat.mdl",
			closetrow = 3,
			rotation = -90
	},
	[1] = {
			name = "Pimp Hat",
			description = "Own your domain with this pimped out accessory.",
			unique_name = "hatpimphat",
			price = 150,   
			model = "models/gmod_tower/pimphat.mdl",
			closetrow = 2,
			slot = SLOT_HEAD
	},
	[2] = {
			name = "Fedora (black)",
			description = "Now you too can be a 1950's gangster.",
			unique_name = "hatfedorahat",
			price = 150,   
			model = "models/gmod_tower/fedorahat.mdl",
			ModelSkinId = 0,
			closetrow = 2,
			slot = SLOT_HEAD
	},
	[3] = {
			name = "Dr. Seuss Hat",
			description = "The style might be old, but it's a sight to behold!",
			unique_name = "hatseusshat",
			price = 150,   
			model = "models/gmod_tower/seusshat.mdl",
			closetrow = 2,
			slot = SLOT_HEAD
	},
	[4] = {
			name = "Top Hat",
			description = "Look like a true gentlemen with this fancy top hat.",
			unique_name = "hattophat",
			price = 150,   
			model = "models/gmod_tower/tophat.mdl",
			closetrow = 2,
			slot = SLOT_HEAD
	},
	[5] = {
			name = "Fedora (indy)",
			description = "Don't forget to grab it before the door closes.",
			unique_name = "hatfedorahatindy",
			price = 150,
			model = "models/gmod_tower/fedorahat.mdl",
			ModelSkinId = 1,
			closetrow = 2,
			slot = SLOT_HEAD
	},
	[6] = {
			name = "Link's Cap",
			description = "Putting this on turns you into a mute who can only communicate with grunts.",
			unique_name = "hatlinkhat",
			price = 150,   
			model = "models/gmod_tower/linkhat.mdl",
			closetrow = 3,
			MoveForward = 2,
			slot = SLOT_HEAD
	},
	[7] = {
			name = "Cat Ears",
			description = "These cute feline ears will have you meowing all day long.",
			unique_name = "hatcatear",
			price = 300,   
			model = "models/gmod_tower/catears.mdl",
			closetrow = 3,
			slot = SLOT_HEAD
	},
	[8] = {
			name = "Toro-chan Mask",
			description = "The Sony Cat everyone in Japan loves - in mask form.",
			unique_name = "hattoromask",
			price = 150,   
			model = "models/gmod_tower/hats/toro_mask.mdl",
			closetrow = 3,
			slot = SLOT_FACE,
			fixscale = true
	},
	[9] = {
			name = "Midna's Mask",
			description = "The shattered remnants of the Fused Shadow (featured in Twilight Princess).",
			unique_name = "hatmidnasmask",
			price = 150,
			model = "models/gmod_tower/midnahat.mdl",
			closetrow = 3,
			slot = SLOT_HEAD
	},
	[10] = {
			name = "Majora's Mask",
			description = "Stolen from a mysterious young child, this mask will be your last.",
			unique_name = "hatmajorasmask",
			price = 300,   
			model = "models/lordvipes/majoramask/majoramask.mdl",
			closetrow = 3,
			slot = SLOT_FACE,
			dateadded = 1406026703
	},
	[11] = {
			name = "Afro",
			description = "Does not improve dance skills.",
			unique_name = "hathairafro",
			price = 500,   
			model = "models/gmod_tower/afro.mdl",
			closetrow = 1,
			slot = SLOT_HEAD,
			fixscale = true,
	},
	[12] = {
			name = "Drink Cap",
			description = "Drink up, you lazy bastard!",
			unique_name = "hatdrinkhat",
			price = 250,   
			model = "models/gmod_tower/drinkcap.mdl",
			closetrow = 2,
			slot = SLOT_HEAD,
			fixscale = true,
	},
	[13] = {
			name = "Sombrero",
			description = "Get in touch with the mexican inside you.",
			unique_name = "hatsombrero",
			price = 200,   
			model = "models/gmod_tower/sombrero.mdl",
			closetrow = 3,
			slot = SLOT_HEAD,
			fixscale = true,
	},
	[14] = {
			name = "Kleiner's Glasses",
			description = "A must have for all scientists.",
			unique_name = "hatkleinerglass",
			price = 100,   
			model = "models/gmod_tower/klienerglasses.mdl",
			closetrow = 2,
			Bodygroup = 0,
			slot = SLOT_FACE,
			fixscale = true,
	},
	[15] = {
			name = "Headcrab",
			description = "The worst it might do is attempt to couple with your head.",
			unique_name = "hatheadcrab",
			price = 300,   
			model = "models/gmod_tower/headcrabhat.mdl",
			closetrow = 2,
			slot = SLOT_HEAD,
			fixscale = true,
	},
	[16] = {
			name = "Witch Hat",
			description = "This witch hat is the perfect way to dress up any look on Halloween.",
			unique_name = "hatwitchhat",
			price = 150,
			model = "models/gmod_tower/witchhat.mdl",
			closetrow = 1,
			storeid = GTowerStore.HALLOWEEN,
			slot = SLOT_HEAD,
			fixscale = true,
	},
	[17] = {
			name = "KFC Bucket",
			description = "It's finger lickin' good.",
			unique_name = "hatkfcbucket",
			price = 50,
			model = "models/gmod_tower/kfcbucket.mdl",
			closetrow = 1,
			slot = SLOT_HEAD,
			fixscale = true,
	},
	[18] = {
			name = "Santa Hat",
			description = "Be part of the holidays with this warming Santa cap.",
			unique_name = "santahat",
			price = 150,
			model = "models/gmod_tower/santahat.mdl",
			closetrow = 1,
			storeid = GTowerStore.HOLIDAY,
			slot = SLOT_HEAD
	},
	[19] = {
			name = "Party Hat",
			description = "A celebrative hat for parties.",
			unique_name = "hatbirthdayhat",
			price = 50,
			model = "models/gmod_tower/partyhat.mdl",
			closetrow = 1,
			slot = SLOT_HEAD
	},
	[20] = {
			name = "Cat Beanie",
			description = "A comfy beanie that really shows your feline side.",
			unique_name = "toetohat",
			price = 300,
			model = "models/gmod_tower/toetohat.mdl",
			closetrow = 1,
			slot = SLOT_HEAD
	},
	[21] = {
			name = "Aviators",
			description = "Look like a badass.",
			unique_name = "aviatorhat",
			price = 300,
			model = "models/gmod_tower/aviators.mdl",
			closetrow = 1,
			Bodygroup = 0,
			slot = SLOT_FACE,
			fixscale = true,
	},
	[22] = {
			name = "3D Glasses",
			description = "Now you can play GMT... in 3D! Only in select theaters.™",
			unique_name = "3dglasseshat",
			price = 200,
			model = "models/gmod_tower/3dglasses.mdl",
			closetrow = 1,
			Bodygroup = 0,
			slot = SLOT_FACE,
			fixscale = true,
	},
	[23] = {
			name = "Star Glasses",
			description = "If you're going for that FAB-U-LOUS look, these are for you!",
			unique_name = "starglasseshat",
			price = 250,
			model = "models/gmod_tower/starglasses.mdl",
			closetrow = 1,
			Bodygroup = 0,
			slot = SLOT_FACE,
			fixscale = true,
	},
	[24] = {
			name = "Andross Mask",
			description = "Now you will feel true pain...",
			unique_name = "androssmaskhat",
			price = 1000,
			model = "models/gmod_tower/androssmask.mdl",
			closetrow = 3,
			Bodygroup = 0,
			slot = SLOT_FACE,
			fixscale = true,
	},
	[25] = {
			name = "Samus Helmet",
			description = "The last Metroid is in captivity.  The galaxy is at peace.",
			unique_name = "samushat",
			price = 500,
			model = "models/gmod_tower/samushelmet.mdl",
			closetrow = 3,
			slot = SLOT_HEAD,
			fixscale = true,
	},
	[26] = {
			name = "King Boo's Crown",
			description = "It's true what they say about fine art... it takes utterly refined sensibilities to truly appreciate it!",
			unique_name = "kingboocrown",
			price = 2000,
			model = "models/gmod_tower/king_boos_crown.mdl",
			closetrow = 1,
			slot = SLOT_HEAD,
			fixscale = true,
	},
	[27] = {
			name = "Lego Head",
			description = ": )",
			unique_name = "legoheadhat",
			price = 800,
			model = "models/gmod_tower/legohead.mdl",
			closetrow = 2,
			slot = SLOT_HEAD,
			fixscale = true,
	},
	[28] = {
			name = "Bomberman Helmet",
			description = "Blast away your friends with this one of a kind helmet.",
			unique_name = "bomermanhat",
			price = 800,
			model = "models/gmod_tower/bombermanhelmet.mdl",
			closetrow = 3,
			slot = SLOT_HEAD,
			fixscale = true,
	},
	[29] = {
			name = "Snowboarding Goggles",
			description = "Keep your eyes protected from the perils of in-game snow.",
			unique_name = "snowgoggles",
			price = 400,
			model = "models/gmod_tower/snowboardgoggles.mdl",
			closetrow = 1,
			slot = SLOT_FACE,
			fixscale = true,
	},
	[30] = {
			name = "Pumpkin Head",
			description = "Go out and spook and scare.",
			unique_name = "pumpkinhat",
			price = 800,
			model = "models/gmod_tower/halloween_pumpkinhat.mdl",
			closetrow = 1,
			storeid = GTowerStore.HALLOWEEN,
			slot = SLOT_HEAD
	},
	[31] = {
			name = "Slasher Mask",
			description = "Jason Voorhee's favorite.",
			unique_name = "jasonmask",
			price = 1200,
			model = "models/gmod_tower/halloween_jasonmask.mdl",
			closetrow = 1,
			storeid = GTowerStore.HALLOWEEN,
			slot = SLOT_FACE
	},
	[32] = {
			name = "Jack's Topper",
			description = "Oh. How *jolly* our Christmas will be.",
			unique_name = "nightmarehat",
			price = 1400,
			model = "models/gmod_tower/halloween_nightmarehat.mdl",
			closetrow = 1,
			storeid = GTowerStore.HALLOWEEN,
			slot = SLOT_HEAD
	},
	[33] = {
			name = "GMod Top Hat",
			description = "For those dapper fellows.",
			unique_name = "gmodtophat",
			price = 1600,
			model = "models/player/items/humans/top_hat.mdl",
			closetrow = 1,
			slot = SLOT_HEAD
	},
	[34] = {
			name = "No Face",
			description = "Want some gold?",
			unique_name = "nofacemask",
			price = 1300,
			model = "models/gmod_tower/noface.mdl",
			closetrow = 2,
			slot = SLOT_FACE
	},
	[35] = {
			name = "Bat Mask",
			description = "I'm Batman",
			unique_name = "batmanmask",
			price = 1800,
			model = "models/gmod_tower/batmanmask.mdl",
			closetrow = 2,
			slot = SLOT_HEAD
	},
	[36] = {
			name = "Baseball Cap",
			description = "Hit it out of the park!",
			unique_name = "baseballcap",
			price = 1200,
			model = "models/gmod_tower/baseballcap.mdl",
			closetrow = 2,
			slot = SLOT_HEAD
	},
	[37] = {
			name = "Cap Reversed",
			description = "Be a real fashionable kinda dude man",
			unique_name = "baseballcapreveresed",
			price = 1300,
			model = "models/gmod_tower/baseballcap.mdl",
			closetrow = 2,
			slot = SLOT_HEAD
	},
	[38] = {
			name = "Team Rocket",
			description = "Surrender now, or prepare to fight!",
			unique_name = "teamrockethat",
			price = 1300,
			model = "models/gmod_tower/teamrockethat.mdl",
			closetrow = 2,
			slot = SLOT_HEAD
	},
	[39] = {
			name = "Meta Knight Mask",
			description = "Come back when you can put up a fight.",
			unique_name = "metaknightmask",
			price = 1600,
			model = "models/gmod_tower/metaknight_mask.mdl",
			closetrow = 2,
			slot = SLOT_FACE
	},
	[40] = {
			name = "Pilgrim's Hat",
			description = "Celebrate thanksgiving and fall with this hat.",
			unique_name = "pilgrimhat",
			price = 2000,
			model = "models/gmod_tower/pilgrimhat.mdl",
			closetrow = 2,
			storeid = GTowerStore.THANKSGIVING,
			slot = SLOT_HEAD
	},
	[41] = {
			name = "Rubik's Cube",
			description = "Play with your cubes, Rubik.",
			unique_name = "rubikcubehat",
			price = 2500,
			model = "models/gmod_tower/rubikscube.mdl",
			closetrow = 2,
			slot = SLOT_HEAD
	},
	[42] = {
			name = "Headphones",
			description = "Dr. Dre ain't got nothin' on these.",
			unique_name = "headphones",
			price = 4000,
			model = "models/gmod_tower/headphones.mdl",
			closetrow = 2,
			slot = SLOT_HEAD,
			dateadded = 1404371377
	},
	[43] = {
		name = "Billy Hatcher",
		description = "Saving the world one chicken egg at a time.",
		unique_name = "billyhatcher",
		price = 1300,
		model = "models/lordvipes/billyhatcherhat/billyhatcherhat.mdl",
		closetrow = 2,
		slot = SLOT_HEAD,
		dateadded = 1406026703
	},
	[44] = {
		name = "Black Mage Hat",
		description = "Urge to destroy world rising.",
		unique_name = "blackmage_hat",
		price = 666,
		model = "models/lordvipes/blackmage/blackmage_hat.mdl",
		closetrow = 2,
		slot = SLOT_HEAD,
		dateadded = 1406026703
	},
	[45] = {
		name = "Cubone Skull",
		description = "Cuubone-bone-bone",
		unique_name = "cuboneskull",
		price = 104,
		model = "models/lordvipes/cuboneskull/cuboneskull.mdl",
		closetrow = 2,
		slot = SLOT_HEAD,
		dateadded = 1406026703
	},
	[46] = {
		name = "Daft Punk - Thomas",
		description = "R O B O T  R O C K",
		unique_name = "daftpunkthomas",
		price = 18000,
		model = "models/lordvipes/daftpunk/thomas.mdl",
		closetrow = 2,
		slot = SLOT_HEAD,
		dateadded = 1406026703
	},
	[47] = {
		name = "General Pepper Hat",
		description = "Good luck!",
		unique_name = "generalpepperhat",
		price = 2200,
		model = "models/lordvipes/generalpepperhat/generalpepperhat.mdl",
		closetrow = 2,
		slot = SLOT_HEAD,
		dateadded = 1406026703
	},
	[48] = {
		name = "Keaton Mask",
		description = "You can't fool anyone with this.",
		unique_name = "keatonmask",
		price = 1200,
		model = "models/lordvipes/keatonmask/keatonmask.mdl",
		closetrow = 2,
		slot = SLOT_FACE,
		dateadded = 1406026703
	},
	[49] = {
		name = "Klonoa's Hat",
		description = "A hero's work is never done!",
		unique_name = "klonoahat",
		price = 25000,
		model = "models/lordvipes/klonoahat/klonoahat.mdl",
		closetrow = 2,
		slot = SLOT_HEAD,
		dateadded = 1406026703
	},
	[50] = {
		name = "Luigi's Cap",
		description = "Oh yeah! Who's number one now?! Luigi!",
		unique_name = "luigihat",
		price = 1999,
		model = "models/lordvipes/luigihat/luigihat.mdl",
		closetrow = 2,
		slot = SLOT_HEAD,
		dateadded = 1406026703
	},
	[51] = {
		name = "Mario's Cap",
		description = "Wahoo!",
		unique_name = "mariohat",
		price = 2000,
		model = "models/lordvipes/mariohat/mariohat.mdl",
		closetrow = 2,
		slot = SLOT_HEAD,
		dateadded = 1406026703
	},
	[52] = {
		name = "Makar Mask",
		description = "Become the sage of the Wind Temple.",
		unique_name = "makarmask",
		price = 12000,
		model = "models/lordvipes/makarmask/makarmask.mdl",
		closetrow = 2,
		slot = SLOT_FACE,
		dateadded = 1406026703
	},
	[53] = {
		name = "Peach's Crown",
		description = "Feel like a princess in a digital world.",
		unique_name = "peachcrown",
		price = 80000,
		model = "models/lordvipes/peachcrown/peachcrown.mdl",
		closetrow = 2,
		slot = SLOT_HEAD,
		dateadded = 1406026703
	},
	[54] = {
		name = "Reds's Hat",
		description = "Can you be the very best?",
		unique_name = "redshat",
		price = 151,
		model = "models/lordvipes/redshat/redshat.mdl",
		closetrow = 2,
		slot = SLOT_HEAD,
		dateadded = 1406026703
	},
	[55] = {
		name = "Servbot Head",
		description = "Master, master! It's him, that blue guy is heading this way.",
		unique_name = "servbothead",
		price = 80000,
		model = "models/lordvipes/servbothead/servbothead.mdl",
		closetrow = 2,
		slot = SLOT_HEAD,
		dateadded = 1406026703
	},
	[56] = {
		name = "Toad Hat",
		description = "I'm sorry, but your princess is in another castle.",
		unique_name = "toadhat",
		price = 5000,
		model = "models/lordvipes/toadhat/toadhat.mdl",
		closetrow = 2,
		slot = SLOT_HEAD,
		dateadded = 1406026703
	},
	[57] = {
		name = "Viewtiful Joe Helmet",
		description = "Henshin A Go-Go baby!",
		unique_name = "ViewtifulJoeHelmet",
		price = 10000,
		model = "models/lordvipes/viewtifuljoehelmet/viewtifuljoehelmet.mdl",
		closetrow = 2,
		slot = SLOT_HEAD,
		dateadded = 1406026703
	},
	[58] = {
		name = "Typical Glasses",
		description = "Got reading problems? Consider them gone!",
		unique_name = "TypicalGlasses",
		price = 110,
		model = "models/captainbigbutt/skeyler/accessories/glasses01.mdl",
		slot = SLOT_FACE,
		dateadded = 1434767690
	},
	[59] = {
		name = "Shades",
		description = "Shades a mother could only love.",
		unique_name = "Shades",
		price = 200,
		model = "models/captainbigbutt/skeyler/accessories/glasses02.mdl",
		slot = SLOT_FACE,
		dateadded = 1434767690
	},
	[60] = {
		name = "Shutter Shades",
		description = "Walk about like you're some pop star.",
		unique_name = "ShutterShades",
		price = 350,
		model = "models/captainbigbutt/skeyler/accessories/glasses03.mdl",
		slot = SLOT_FACE,
		dateadded = 1434767690
	},
	[61] = {
		name = "Round Shades",
		description = "Become one with the Matrix.",
		unique_name = "RoundShades",
		price = 250,
		model = "models/captainbigbutt/skeyler/accessories/glasses04.mdl",
		slot = SLOT_FACE,
		dateadded = 1434767690
	},
	[62] = {
		name = "Monocle",
		description = "Tip tip tally-ho!",
		unique_name = "Monocle",
		price = 350,
		model = "models/captainbigbutt/skeyler/accessories/monocle.mdl",
		slot = SLOT_FACE,
		dateadded = 1434767690
	},
	[63] = {
		name = "Mustache",
		description = "Become a true gentleman.",
		unique_name = "Mustache",
		price = 500,
		model = "models/captainbigbutt/skeyler/accessories/mustache.mdl",
		slot = SLOT_FACE,
		dateadded = 1434767690
	},
	[64] = {
		name = "Afro (alternative)",
		description = "Grab some funk. Still does not improve dance skills.",
		unique_name = "AfroAlternative",
		price = 500,
		model = "models/captainbigbutt/skeyler/hats/afro.mdl",
		slot = SLOT_HEAD,
		dateadded = 1434767690
	},
	[65] = {
		name = "Bear Beanie",
		description = "A comfy beanie that really shows your inner bear.",
		unique_name = "BearBeanie",
		price = 300,
		model = "models/captainbigbutt/skeyler/hats/bear_hat.mdl",
		closetrow = 1,
		slot = SLOT_HEAD,
		dateadded = 1434767690
	},
	[66] = {
		name = "Cat Beanie (alternative)",
		description = "A comfy beanie that really shows your inner feline.",
		unique_name = "CatBeanie",
		price = 300,
		model = "models/captainbigbutt/skeyler/hats/cat_hat.mdl",
		closetrow = 1,
		slot = SLOT_HEAD,
		dateadded = 1434767690
	},
	[67] = {
		name = "Frog Beanie",
		description = "A comfy beanie that really shows your inner frog.",
		unique_name = "FrogBeanie",
		price = 300,
		model = "models/captainbigbutt/skeyler/hats/frog_hat.mdl",
		closetrow = 1,
		slot = SLOT_HEAD,
		dateadded = 1434767690
	},
	[68] = {
		name = "Bunny Ears",
		description = "These cute bunny ears give you a fashionable look. They do not help with jumping, though.",
		unique_name = "BunnyEars",
		price = 300,
		model = "models/captainbigbutt/skeyler/hats/bunny_ears.mdl",
		closetrow = 1,
		slot = SLOT_HEAD,
		dateadded = 1434767690
	},
	[69] = {
		name = "Cats Ears (alternative)",
		description = "These cute feline ears will have you meowing all day long.",
		unique_name = "CatEarsAlternative",
		price = 300,
		model = "models/captainbigbutt/skeyler/hats/cat_ears.mdl",
		closetrow = 1,
		slot = SLOT_HEAD,
		dateadded = 1434767690,
	},
	[70] = {
		name = "Cowboy Hat",
		description = "Howdy ya'll.",
		unique_name = "CowboyHat",
		price = 400,
		model = "models/captainbigbutt/skeyler/hats/cowboyhat.mdl",
		closetrow = 1,
		slot = SLOT_HEAD,
		dateadded = 1434767690
	},
	[71] = {
		name = "Deadmau5 Head",
		description = "Batteries not included.",
		unique_name = "Deadmau5",
		price = 18000,
		model = "models/captainbigbutt/skeyler/hats/deadmau5.mdl",
		closetrow = 1,
		slot = SLOT_HEAD,
		dateadded = 1434767690
	},
	[72] = {
		name = "Fedora (alternative)",
		description = "Fashionable headwear.",
		unique_name = "FedoraAlternative",
		price = 400,
		model = "models/captainbigbutt/skeyler/hats/fedora.mdl",
		closetrow = 1,
		slot = SLOT_HEAD,
		dateadded = 1434767690
	},
	[73] = {
		name = "Cap",
		description = "The Z does not mean zebra.",
		unique_name = "HeadCap",
		price = 200,
		model = "models/captainbigbutt/skeyler/hats/zhat.mdl",
		closetrow = 1,
		slot = SLOT_HEAD,
		dateadded = 1434767690
	},
	[74] = {
		name = "Straw Hat",
		description = "Protect yourself from the sun.",
		unique_name = "Strawhat",
		price = 200,
		model = "models/captainbigbutt/skeyler/hats/strawhat.mdl",
		closetrow = 1,
		slot = SLOT_HEAD,
		dateadded = 1434767690
	},
	[75] = {
		name = "Sun Hat",
		description = "Protect yourself from the sun in style.",
		unique_name = "SunHat",
		price = 250,
		model = "models/captainbigbutt/skeyler/hats/sunhat.mdl",
		closetrow = 1,
		slot = SLOT_HEAD,
		dateadded = 1434767690
	},
	[76] = {
		name = "Maid Headband",
		description = "Does not include actual maid.",
		unique_name = "MaidHeadband",
		price = 250,
		model = "models/captainbigbutt/skeyler/hats/maid_headband.mdl",
		closetrow = 1,
		slot = SLOT_HEAD,
		dateadded = 1434767690
	},
	[77] = {
		name = "Heart Headband",
		description = "Diddly boppers with hearts.",
		unique_name = "HeartHeadband",
		price = 250,
		model = "models/captainbigbutt/skeyler/hats/heartband.mdl",
		closetrow = 1,
		slot = SLOT_HEAD,
		dateadded = 1434767690
	},
	[78] = {
		name = "Star Headband",
		description = "Diddly boppers with stars.",
		unique_name = "StarHeadband",
		price = 250,
		model = "models/captainbigbutt/skeyler/hats/starband.mdl",
		closetrow = 1,
		slot = SLOT_HEAD,
		dateadded = 1434767690
	},
	[79] = {
		name = "Santa Hat (animated)",
		description = "Christmas just wouldn't be the same.",
		unique_name = "SantaHatAnimated",
		price = 500,
		model = "models/captainbigbutt/skeyler/hats/santa.mdl",
		closetrow = 1,
		slot = SLOT_HEAD,
		storeid = GTowerStore.HOLIDAY,
		dateadded = 1434767690
	},
	[80] = {
		name = "Duck Tube",
		description = "Look that's for swimming - wait! Don't put that on your head!",
		unique_name = "DuckTube",
		price = 5000,
		model = "models/captainbigbutt/skeyler/accessories/duck_tube.mdl",
		closetrow = 1,
		slot = SLOT_HEAD,
		dateadded = 1434767690
	},
	/*[80] = {
		name = "Really Hat Top Hat",
		description = "You're actually not part of the dev team.",
		unique_name = "ReallyHatTopHat",
		price = 5000,
		model = "models/captainbigbutt/skeyler/hats/devhat.mdl",
		closetrow = 1,
		slot = SLOT_HEAD,
		storeid = GTowerStore.VIP,
		dateadded = 1434767690
	},*/
}