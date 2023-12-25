---------------------------------
module( "GTowerItems", package.seeall )


GTowerItems.RegisterItem( "VirusFlame", {
	Name = "Virus Flame",
	Description = "Ignite yourself with the flame of the infected!",
	Model = "models/player/virusi.mdl",
	UniqueInventory = true,
	DrawModel = true,
	Equippable = true,
	UniqueEquippable = true,
	EquipType = "VirusFlame",
	CanEntCreate = false,
	DrawName = true,
	CanRemove = false,
	NoBank = true,
	Tradable = false,

	EquippableEntity = true,
	RemoveOnDeath = true,
	RemoveOnNoEntsLoc = true,
	CreateEquipEntity = function( self )

		local VirusFlame = ents.Create( "gmt_virusflame" )

		if IsValid( VirusFlame ) then
			VirusFlame:SetOwner( self.Ply )
			VirusFlame:SetParent( self.Ply )
			VirusFlame:Spawn()
			VirusFlame:SetupFlame( self.Ply )
			self.Ply:EmitSound( "ambient/fire/ignite.wav", 30, math.random( 170, 200 ) )
		end

		return VirusFlame

	end
} )

GTowerItems.RegisterItem( "GolfBall", {
	Name = "Golf Ball",
	Description = "Ever wanted to just play golf on the go?",
	Model = "models/sunabouzu/golf_ball.mdl",
	MoveSound = Sound( "GModTower/minigolf/effects/hit.wav" ),
	UniqueInventory = true,
	DrawModel = true,
	Equippable = true,
	UniqueEquippable = true,
	EquipType = "BallRaceBall",
	CanEntCreate = false,
	DrawName = true,
	CanRemove = false,
	NoBank = true,
	Tradable = false,

	EquippableEntity = true,
	RemoveOnDeath = true,
	RemoveOnNoEntsLoc = true,
	OnlyEquippable = true,
	CreateEquipEntity = function( self )

		local BallRaceBall = ents.Create( "gmt_golfball" )

		if IsValid( BallRaceBall ) then
			BallRaceBall:SetOwner( self.Ply )
			BallRaceBall:SetPos( self.Ply:GetPos() + Vector( 0, 0, 48 ) )
			BallRaceBall:Spawn()
		end

		return BallRaceBall

	end
} )

GTowerItems.RegisterItem( "VirusRadar", {
	Name = "Radar",
	Description = "Equip this to activate the radar display.",
	Model = "",
	UniqueInventory = true,
	DrawModel = false,
	Equippable = true,
	UniqueEquippable = true,
	EquipType = "HUD",
	CanEntCreate = false,
	DrawName = true,
	CanRemove = false,
	NoBank = true,
	Tradable = false,
	OnEquip = function( self, locationchange )

		--if ClientSettings and not locationchange then
			self.Ply:SetNWBool("VirusRadar",true)
		--end

	end,

	OnUnEquip = function( self )

		--if ClientSettings then
			self.Ply:SetNWBool("VirusRadar",false)
		--end
	end

} )

GTowerItems.RegisterItem( "BallRaceBall", {
	Name = "Ball Race Orb",
	Description = "Step into the ball and get rolling.",
	Model = "models/gmod_tower/ball.mdl",
	MoveSound = Sound( "GModTower/balls/BallRoll.wav" ),
	UniqueInventory = true,
	DrawModel = true,
	Equippable = true,
	UniqueEquippable = true,
	EquipType = "BallRaceBall",
	CanEntCreate = false,
	DrawName = true,
	CanRemove = false,
	NoBank = true,
	Tradable = false,

	EquippableEntity = true,
	RemoveOnDeath = true,
	RemoveOnNoEntsLoc = true,
	OnlyEquippable = true,
	CreateEquipEntity = function( self )

		local BallRaceBall = ents.Create( "gmt_wearable_ballrace" )

		if IsValid( BallRaceBall ) then
			BallRaceBall:SetOwner( self.Ply )
			self.Ply:SetDriving( BallRaceBall )
			BallRaceBall:SetPos( self.Ply:GetPos() + Vector( 0, 0, 48 ) )
			BallRaceBall:Spawn()
			self.Ply:EmitSound( "GModTower/balls/TubePop.wav", 30, math.random( 170, 200 ) )
		end

		return BallRaceBall

	end
} )

GTowerItems.RegisterItem( "VirusAdrenaline", {
	Name = "Adrenaline",
	Description = "Stab this into your boss's wife to prevent her from dying of drug overdose.",
	Model = "models/weapons/w_vir_adrenaline.mdl",
	MoveSound = Sound( "GModTower/virus/weapons/Adrenaline/deploy.wav" ),
	ClassName = "gmt_adrenaline",
	UniqueInventory = true,
	DrawModel = true,
	Equippable = true,
	CanEntCreate = false,
	DrawName = true,
	CanRemove = false,
	EquipType = "Weapon",
	Equippable = true,
	WeaponSafe = true,
	NoBank = true,
	Tradable = false,

	IsWeapon = function( self )
		return true
	end
} )

GTowerItems.RegisterItem( "KirbyHammer", {
	Name = "Gourmet Race Hammer",
	Description = "Double jump, run faster, and hammer away!",
	Model = "models/bumpy/kirby_hammer.mdl",
	MoveSound = Sound( "GModTower/gourmetrace/actions/hammer1.wav" ),
	ClassName = "gmt_kirby_hammer",
	UniqueInventory = true,
	DrawModel = true,
	Equippable = true,
	CanEntCreate = false,
	DrawName = true,
	CanRemove = false,
	EquipType = "Weapon",
	Equippable = true,
	WeaponSafe = true,
	NoBank = true,
	Tradable = false,
	IsWeapon = function( self )
		return true
	end
} )

GTowerItems.RegisterItem( "TakeOnBall", {
	Name = "Take On Me",
	Description = "Increase your speed and become '80s pop!",
	Model = "models/gmod_tower/takeonball.mdl",
	UniqueInventory = true,
	DrawModel = true,
	Equippable = true,
	UniqueEquippable = true,
	EquipType = "TakeOnBall",
	CanEntCreate = false,
	DrawName = true,
	CanRemove = false,
	NoBank = true,
	CanUse = true,
	Tradable = false,
	UseDesc = "Toggle Material",

	EquippableEntity = true,
	RemoveOnDeath = true,
	RemoveOnTheater = true,
	RemoveOnNarnia = true,
	OverrideOnlyEquippable = true,
	CreateEquipEntity = function( self )

		local TakeOn = ents.Create( "gmt_takeonme" )

		if IsValid( TakeOn ) then
			TakeOn:SetOwner( self.Ply )
			TakeOn:SetParent( self.Ply )
			TakeOn:Spawn()
			TakeOn:SetTakeOn( self.Ply )
			self.Ply:EmitSound( "GModTower/balls/TubePop.wav", 30, math.random( 170, 200 ) )
		end

		return TakeOn

	end,

	OnUse = function( self )

		if IsValid( self.Ply ) && self.Ply:IsPlayer() && IsValid( self.Ply.TakeOn ) then
			self.Ply.TakeOn:ToggleMaterial()
		end

		return self

	end
} )

GTowerItems.RegisterItem( "JumpShoes", {
	Name = "Jump Shoes",
	Description = "Jump up way high with these special shoes! (crouch jumping makes you go even higher)",
	Model = "models/props_junk/shoe001a.mdl",
	UniqueInventory = true,
	DrawModel = true,
	Equippable = true,
	UniqueEquippable = true,
	EquipType = "TakeOnBall",
	CanEntCreate = false,
	DrawName = true,
	Tradable = true,

	StoreId = 22,
	StorePrice = 10000,
	NewItem = true,

	EquippableEntity = true,
	RemoveOnDeath = true,
	RemoveOnNoEntsLoc = true,
	OverrideOnlyEquippable = false,
	CreateEquipEntity = function( self )

		local Shoes = ents.Create( "gmt_jumpshoes" )

		if IsValid( Shoes ) then
			Shoes:SetOwner( self.Ply )
			Shoes:SetParent( self.Ply )
			Shoes:Spawn()
			Shoes:SetShoeOwner( self.Ply )
			self.Ply:EmitSound( "GModTower/balls/TubePop.wav", 30, math.random( 170, 200 ) )
		end

		return Shoes

	end
} )

GTowerItems.RegisterItem( "StealthBox", {
	Name = "Stealth Box",
	Description = "Sneak around the lobby.",
	Model = "models/gmod_tower/stealth box/box.mdl",
	MoveSound = Sound( "physics/cardboard/cardboard_box_break3.wav" ),
	UniqueInventory = true,
	DrawModel = true,
	Equippable = true,
	UniqueEquippable = true,
	EquipType = "StealthBox",
	CanEntCreate = false,
	DrawName = true,
	CanRemove = false,
	NoBank = true,
	Tradable = false,

	EquippableEntity = true,
	RemoveOnDeath = true,
	RemoveOnNoEntsLoc = true,
	CreateEquipEntity = function( self )

		local StealthBox = ents.Create( "gmt_stealthbox" )

		if IsValid( StealthBox ) then
			StealthBox:SetOwner( self.Ply )
			StealthBox:SetParent( self.Ply )
			StealthBox:Spawn()
			StealthBox:SetBoxHolder( self.Ply )

			self.Ply:EmitSound( "physics/cardboard/cardboard_box_break1.wav", 30, math.random( 170, 200 ) )
		end

		return StealthBox

	end
} )

GTowerItems.RegisterItem( "JumperShotty", {
	Name = "Jumper Super Shotty",
	Description = "Fly around the lobby with this shotgun full of highly propelled blanks! Don't ask us about the physics of this, we're not quite sure how it works ourselves.",
	Model = "models/weapons/w_pvp_supershoty.mdl",
	ClassName = "gmt_supershotty",
	UniqueInventory = true,
	DrawModel = true,
	Equippable = true,
	CanEntCreate = false,
	DrawName = true,
	CanRemove = false,
	EquipType = "Weapon",
	Equippable = true,
	WeaponSafe = true,
	NoBank = true,
	Tradable = false,

	IsWeapon = function( self )
		return true
	end

} )

GTowerItems.RegisterItem( "Bumper", {
	Name = "Bumper",
	Description = "Place a bumper from Ball Race anywhere you'd like.",
	Model = "models/gmod_tower/bumper.mdl",
	MoveSound = Sound( "GModTower/balls/bumper.wav" ),
	ClassName = "gmt_bumper",
	UniqueInventory = true,
	DrawModel = true,
	CanEntCreate = true,
	DrawName = true,
	CanRemove = false,
	--BankAdminOnly = true,
	Tradable = false,
} )

GTowerItems.RegisterItem( "UCHGhost", {
	Name = "Ghost",
	Description = "You could have been the life of the party, if you weren't already dead.",
	Model = "models/UCH/mghost.mdl",
	MoveSound = Sound( "UCH/pigs/die.wav" ),
	UniqueInventory = true,
	DrawModel = true,
	Equippable = true,
	UniqueEquippable = true,
	EquipType = "Model",
	CanEntCreate = false,
	DrawName = true,
	CanRemove = false,
	NoBank = true,
	Tradable = false,
	OnEquip = function( self )
		if UCHAnim && SERVER then
			UCHAnim.SetupPlayer( self.Ply, UCHAnim.TYPE_GHOST )
		end
	end,

	OnUnEquip = function( self )
		if UCHAnim && SERVER then
			UCHAnim.ClearPlayer( self.Ply )
		end
	end

})

GTowerItems.RegisterItem( "UCHPig", {
	Name = "Pigmask",
	Description = "Suiciding does not cause a Bag of Pork Chops to drop.",
	Model = "models/UCH/pigmask.mdl",
	MoveSound = Sound( "UCH/pigs/snort1.wav" ),
	UniqueInventory = true,
	DrawModel = true,
	Equippable = true,
	UniqueEquippable = true,
	EquipType = "Model",
	CanEntCreate = false,
	DrawName = true,
	CanRemove = false,
	NoBank = true,
	Tradable = false,
	StoreId = GTowerStore.PLAYERMODEL,
	StorePrice = 0,

	OnEquip = function( self )
		if UCHAnim && SERVER then
			UCHAnim.SetupPlayer( self.Ply, UCHAnim.TYPE_PIG )
		end
	end,

	OnUnEquip = function( self )
		if UCHAnim && SERVER then
			UCHAnim.ClearPlayer( self.Ply )
		end
	end,

	ExtraMenuItems = function ( item, menu )
		local ranks = {
			"Ensign", "Captain", "Major", "Colonel"
		}

		local ranks2 = {
			["Ensign"] = 0,
			["Captain"] = 1,
			["Major"] = 2,
			["Colonel"] = 3
		}

		local current = GetConVar( "gmt_uch_skin" ):GetInt() || 0

		table.insert( menu, {
			[ "Name" ] = "Set Rank",
			[ "function" ] = function()
				Derma_StringRequest(
					"Pigmask Rank",
					"Please enter a rank.\n - Ensign - Captain - Major - Colonel -",
					ranks[current] || "",
					function(text) text = ( ranks2[text] || text ) GetConVar( "gmt_uch_skin" ):SetInt( tonumber(text) ) end
				)
			end
		} )
	end

})

GTowerItems.RegisterItem( "HalloweenSpider", {
	Name = "Spider",
	Description = "Making webs not included.",
	Model = "models/npc/spider_regular/npc_spider_regular.mdl",
	MoveSound = Sound( "gmodtower/zom/creatures/spider/taunt1.wav" ),
	DrawModel = true,
	Equippable = true,
	UniqueEquippable = true,
	EquipType = "Model",
	CanEntCreate = false,
	DrawName = true,
	StorePrice = 250,
	OnEquip = function( self )
		if SERVER then
			self.Ply.BeforeSpider = self.Ply:GetModel()
			self.Ply:SetModel( "models/npc/spider_regular/npc_spider_regular.mdl" )
			self.Ply:SetSkin( 0 )
		end
	end,
	OnUnEquip = function( self )
		if SERVER then
			self.Ply:SetModel( self.Ply.BeforeSpider )
		end
	end
} )

GTowerItems.RegisterItem( "HelicopterPet", {

	Name = "Helicopter Companion",
	Description = "Introducing your pint-sized sky explorer, the Small Helicopter, always buzzing nearby, ready for aerial adventures.",
	
	Model = "models/bfv/bfvhuey.mdl",
	
	DrawModel = true,
	Equippable = true,
	
	UniqueInventory = true,
	UniqueEquippable = true, 
	
	EquipType = "Pet",
	InvCategory = "pet",
	
	CanEntCreate = false,
	DrawName = true,
	CanRemove = false,
	Tradable = false,
	NoBank = true,
	
	EquippableEntity = true,
	RemoveOnDeath = true,
	RemoveOnNoEntsLoc = true,
	
	CreateEquipEntity = function( self )
		
		local pet = ents.Create( "gmt_pet_helicopter" )
		
		if IsValid( pet ) then
		
			self.Ply.Pet = pet

			pet:SetOwner( self.Ply )
			pet:Spawn()
			
		end
		
		return pet
		
	end,

} )