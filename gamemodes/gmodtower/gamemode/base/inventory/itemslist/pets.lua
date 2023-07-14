module( "GTowerItems", package.seeall )


GTowerItems.RegisterItem( "MelonPet", {

	Name = "Melon Pet",
	Description = "A joyful melon pet!",
	
	Model = "models/props_junk/watermelon01.mdl",
	MoveSound = Sound( "physics/flesh/flesh_squishy_impact_hard2.wav" ),
	
	DrawModel = true,
	Equippable = true,
	
	UniqueInventory = true,
	UniqueEquippable = true, 
	
	EquipType = "Pet",
	
	CanEntCreate = false,
	DrawName = true,
	CanRemove = true,
	Tradable = true,
	
	StoreId = GTowerStore.PET,
	StorePrice = 15000,
	
	EquippableEntity = true,
	RemoveOnDeath = true,
	RemoveOnNoEntsLoc = true,
	
	ExtraMenuItems = function ( item, menu )
		
		table.insert( menu, {
			[ "Name" ] = "Give Name",
			[ "function" ] = function()
			
				local curText = LocalPlayer():GetInfo( "gmt_petname" ) or ""
				
				Derma_StringRequest(
					"Pet Name",
					"Please enter the name of your cute pet!",
					curText,
					function ( text ) RunConsoleCommand( "gmt_petname", text ) end
				)
				
			end
		} )
		
	end,
	
	CreateEquipEntity = function( self )
		
		local pet = ents.Create( "gmt_pet" )
		
		if IsValid( pet ) then
		
			self.Ply.Pet = pet
			
			pet:Teleport( self.Ply )
			pet:SetOwner( self.Ply )
			pet:Spawn()
			
		end
		
		return pet
		
	end	
} )

GTowerItems.RegisterItem( "SaturnPet", {

	Name = "Mr. Saturn Pet",
	Description = "Am happy. Am in trouble. No, wait. Am happy.",

	Model = "models/uch/saturn.mdl",

	DrawModel = true,
	Equippable = true,

	UniqueInventory = true,
	UniqueEquippable = false,

	EquipType = "Pet",

	CanEntCreate = false,
	DrawName = true,
	CanRemove = true,
	Tradable = true,

	StoreId = GTowerStore.PET,
	StorePrice = 30000,

	EquippableEntity = true,
	RemoveOnDeath = true,
	RemoveOnNoEntsLoc = true,

	ExtraMenuItems = function (item, menu)
		table.insert(menu, {
			["Name"] = "Give Name",
			["function"] = function()
				local curText = LocalPlayer():GetInfo("gmt_petname_saturn") or ""

				Derma_StringRequest(
					"Pet Name",
					"Please enter the name of your cute pet!",
					curText,
					function (text) RunConsoleCommand("gmt_petname_saturn",text) end
				)
			end
		})
	end,

	CreateEquipEntity = function( self )

		local pet = ents.Create( "gmt_mrsaturn" )

		if IsValid( pet ) then

			self.Ply.Pet = pet

			pet:SetPos( self.Ply:GetPos() )
			pet:SetOwner( self.Ply )
			pet:Spawn()

		end

		return pet

	end
} )

GTowerItems.RegisterItem( "RubikPet", {

	Name = "Rubik Pet",
	Description = "Solve me...",
	
	Model = "models/gmod_tower/rubikscube.mdl",
	
	DrawModel = true,
	Equippable = true,
	
	UniqueInventory = true,
	UniqueEquippable = true, 
	
	EquipType = "Pet",
	
	CanEntCreate = false,
	DrawName = true,
	CanRemove = true,
	Tradable = true,
	
	StoreId = GTowerStore.PET,
	StorePrice = 12000,
	
	EquippableEntity = true,
	RemoveOnDeath = true,
	RemoveOnNoEntsLoc = true,
	
	ExtraMenuItems = function ( item, menu )
		
		table.insert( menu, {
			[ "Name" ] = "Give Name",
			[ "function" ] = function()
			
				local curText = LocalPlayer():GetInfo( "gmt_petname" ) or ""
				
				Derma_StringRequest(
					"Pet Name",
					"Please enter the name of your cute pet!",
					curText,
					function ( text ) RunConsoleCommand( "gmt_petname", text ) end
				)
				
			end
		} )
		
	end,
	
	CreateEquipEntity = function( self )
		
		local pet = ents.Create( "gmt_pet_rubikcube" )
		
		if IsValid( pet ) then
		
			self.Ply.Pet = pet
			
			pet:Teleport( self.Ply )
			pet:SetOwner( self.Ply )
			pet:Spawn()
			
		end
		
		return pet
		
	end	
} )

GTowerItems.RegisterItem( "BalloonicornPet", {

	Name = "Balloonicorn Pet",
	Description = "Oh my goodness! Is it Balloonicorn? The Mayor of Pyroland? Don't be ridiculous, we're talking about an inflatable unicorn. He's the Municipal Ombudsman.",
	
	Model = "models/player/items/all_class/pet_balloonicorn.mdl",
	
	DrawModel = true,
	Equippable = true,
	
	StoreId = GTowerStore.PET,
	StorePrice = 22000,
	
	UniqueInventory = true,
	UniqueEquippable = true, 
	
	EquipType = "Pet",
	
	CanEntCreate = false,
	DrawName = true,
	CanRemove = true,
	Tradable = true,
	NoBank = false,
	
	EquippableEntity = true,
	RemoveOnDeath = true,
	RemoveOnNoEntsLoc = true,
	
	ExtraMenuItems = function ( item, menu )
		
		table.insert( menu, {
			[ "Name" ] = "Give Name",
			[ "function" ] = function()
			
				local curText = LocalPlayer():GetInfo( "gmt_petname_bcorn" ) or ""
				
				Derma_StringRequest(
					"Pet Name",
					"Please enter the name of your cute pet!",
					curText,
					function ( text ) RunConsoleCommand( "gmt_petname_bcorn", text ) end
				)
				
			end
		} )
		
	end,
	
	CreateEquipEntity = function( self )
		
		local pet = ents.Create( "gmt_pet_balloonicorn" )
		
		if IsValid( pet ) then
		
			self.Ply.Pet = pet

			pet:SetOwner( self.Ply )
			pet:Spawn()
			
		end
		
		return pet
		
	end,

} )

GTowerItems.RegisterItem( "TurtlePet", {

	Name = "Turtle Pet",
	Description = "Who would have thought that not only do turtles live for 100 years, but they also float...",
	
	Model = "models/props/de_tides/vending_turtle.mdl",
	
	DrawModel = true,
	Equippable = true,
	
	StoreId = GTowerStore.PET,
	StorePrice = 20000,
	
	UniqueInventory = true,
	UniqueEquippable = true, 
	NewItem = true,
	
	EquipType = "Pet",
	
	CanEntCreate = false,
	DrawName = true,
	CanRemove = true,
	Tradable = true,
	NoBank = false,
	
	EquippableEntity = true,
	RemoveOnDeath = true,
	RemoveOnNoEntsLoc = true,
	
	ExtraMenuItems = function ( item, menu )
		
		table.insert( menu, {
			[ "Name" ] = "Give Name",
			[ "function" ] = function()
			
				local curText = LocalPlayer():GetInfo( "gmt_petname_turtle" ) or ""
				
				Derma_StringRequest(
					"Pet Name",
					"Please enter the name of your cute pet!",
					curText,
					function ( text ) RunConsoleCommand( "gmt_petname_turtle", text ) end
				)
				
			end
		} )
		
	end,
	
	CreateEquipEntity = function( self )
		
		local pet = ents.Create( "gmt_pet_turtle" )
		
		if IsValid( pet ) then
		
			self.Ply.Pet = pet

			pet:SetOwner( self.Ply )
			pet:Spawn()
			
		end
		
		return pet
		
	end,

} )

// THIS IS A MILESTONE
GTowerItems.RegisterItem( "ChimeraPet", {

	Name = "Chimera Pet",
	Description = "Don't worry, this miniaturized Chimera has been trained... mostly. Press R to roar.",
	
	Model = "models/UCH/uchimeraGM.mdl",
	MoveSound = Sound( "UCH/chimera/step.wav" ),
	
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
	
	ExtraMenuItems = function ( item, menu )
		
		table.insert( menu, {
			[ "Name" ] = "Give Name",
			[ "function" ] = function()
			
				local curText = LocalPlayer():GetInfo( "gmt_petname_chimera" ) or ""
				
				Derma_StringRequest(
					"Pet Name",
					"Please enter the name of your cute pet!",
					curText,
					function ( text ) RunConsoleCommand( "gmt_petname_chimera", text ) end
				)
				
			end
		} )
		
	end,
	
	CreateEquipEntity = function( self )
		
		local pet = ents.Create( "gmt_pet_chimera" )
		
		if IsValid( pet ) then
		
			self.Ply.Pet = pet

			pet:SetOwner( self.Ply )
			pet:Spawn()
			
		end
		
		return pet
		
	end,

} )

/*GTowerItems.RegisterItem( "RobotPet", {

	Name = "Robot Pet",
	Description = "Your personal robot assistant!",

	Model = "models/player/items/all_class/pet_robro.mdl",

	DrawModel = true,
	Equippable = true,

	UniqueInventory = false,
	UniqueEquippable = false,

	EquipType = "Pet",

	CanEntCreate = false,
	DrawName = true,
	CanRemove = true,
	Tradable = true,

	NewItem = true,

	StoreId = 26,
	StorePrice = 75000,

	EquippableEntity = true,
	RemoveOnDeath = true,
	RemoveOnNoEntsLoc = true,

	CreateEquipEntity = function( self )

		local pet = ents.Create( "gmt_robot" )

		if IsValid( pet ) then
			pet:SetOwner( self.Ply )
			pet:SetParent( self.Ply )
			pet:Spawn()
		end

		return pet

	end
} )*/

GTowerItems.RegisterItem( "ReinPet", {

	Name = "Reindeer Pet",
	Description = "No, this is not a Balloonicorn. We promise!",

	Model = "models/player/items/all_class/pet_reinballoonicorn.mdl",

	DrawModel = true,
	Equippable = true,

	UniqueInventory = true,
	UniqueEquippable = false,

	EquipType = "Pet",

	CanEntCreate = false,
	DrawName = true,
	CanRemove = true,
	Tradable = true,

	NewItem = true,

	StoreId = GTowerStore.HOLIDAY,
	StorePrice = 22000,

	EquippableEntity = true,
	RemoveOnDeath = true,
	RemoveOnNoEntsLoc = true,

	CreateEquipEntity = function( self )

		local pet = ents.Create( "gmt_pet_reindeer" )

		if IsValid( pet ) then
			pet:SetOwner( self.Ply )
			pet:SetParent( self.Ply )
			pet:Spawn()
		end

		return pet

	end
} )

/*GTowerItems.RegisterItem( "GhostPet", {

	Name = "Ghost Pet",
	Description = "A spooky ghost, next to your side.",

	Model = "models/player/items/all_class/hwn_pet_ghost.mdl",

	DrawModel = true,
	Equippable = true,

	UniqueInventory = true,
	UniqueEquippable = false,

	EquipType = "Pet",

	CanEntCreate = false,
	DrawName = true,
	CanRemove = true,
	Tradable = true,

	NewItem = true,

	StoreId = GTowerStore.HALLOWEEN,
	StorePrice = 25000,

	EquippableEntity = true,
	RemoveOnDeath = true,
	RemoveOnNoEntsLoc = true,

	CreateEquipEntity = function( self )

		local pet = ents.Create( "gmt_pet_ghost" )

		if IsValid( pet ) then
			pet:SetOwner( self.Ply )
			pet:SetParent( self.Ply )
			pet:Spawn()
		end

		return pet

	end
} )*/

GTowerItems.RegisterItem( "ParticleSystemVIP", {
	Name = "Particle: Beauty Cone",
	Description = "Shiny.",
	//Model = "models/gmod_tower/particleball.mdl",
	Model = "models/weapons/w_pvp_ire.mdl",
	DrawModel = false,
	Equippable = true,
	UniqueEquippable = true,
	EquipType = "Particle",
	CanEntCreate = false,
	DrawName = true,

	StoreId = GTowerStore.VIP,
	StorePrice = 30000,

	Tradable = false,
	UniqueInventory = true,

	PreviewURL = "particles/beauty-cone.webp",

	EquippableEntity = true,
	RemoveOnDeath = true,
	RemoveOnNoEntsLoc = true,
	OverrideOnlyEquippable = true,
	CreateEquipEntity = function( self )

		local particle = ents.Create( "gmt_wearable_particle_base" )

		if IsValid( particle ) then
			particle:SetOwner( self.Ply )
			particle:SetParent( self.Ply )
			particle:Spawn()
		end

		return particle

	end
} )
GTowerItems.RegisterItem( "ParticleSystemBanana", {
	Name = "Particle: Bananas",
	Description = "Express your love for bananas with this cool particle effect!",
	//Model = "models/gmod_tower/particleball.mdl",
	Model = "models/weapons/w_pvp_ire.mdl",
	DrawModel = false,
	Equippable = true,
	UniqueEquippable = true,
	EquipType = "Particle",
	CanEntCreate = false,
	DrawName = true,

	NewItem = true,

	StoreId = GTowerStore.VIP,
	StorePrice = 12500,

	Tradable = false,
	UniqueInventory = true,

	PreviewURL = "particles/bananas.webp",

	EquippableEntity = true,
	RemoveOnDeath = true,
	RemoveOnNoEntsLoc = true,
	OverrideOnlyEquippable = true,
	CreateEquipEntity = function( self )

		local particle = ents.Create( "gmt_wearable_particle_banana" )

		if IsValid( particle ) then
			particle:SetOwner( self.Ply )
			particle:SetParent( self.Ply )
			particle:Spawn()
		end

		return particle

	end
} )

GTowerItems.RegisterItem( "ParticleSystemNotes", {
	Name = "Particle: Music Notes",
	Description = "That's my jam.",
	//Model = "models/gmod_tower/particleball.mdl",
	Model = "models/weapons/w_pvp_ire.mdl",
	DrawModel = false,
	Equippable = true,
	UniqueEquippable = true,
	EquipType = "Particle",
	CanEntCreate = false,
	DrawName = true,

	NewItem = true,

	StoreId = GTowerStore.VIP,
	StorePrice = 10000,

	Tradable = false,
	UniqueInventory = true,

	PreviewURL = "particles/music-notes.webp",

	EquippableEntity = true,
	RemoveOnDeath = true,
	RemoveOnNoEntsLoc = true,
	OverrideOnlyEquippable = true,
	CreateEquipEntity = function( self )

		local particle = ents.Create( "gmt_wearable_particle_notes" )

		if IsValid( particle ) then
			particle:SetOwner( self.Ply )
			particle:SetParent( self.Ply )
			particle:Spawn()
		end

		return particle

	end
} )

GTowerItems.RegisterItem( "ParticleSystemOrbs", {
	Name = "Particle: Orbs",
	Description = "Soothing orbs that sparkle around you.",
	//Model = "models/gmod_tower/particleball.mdl",
	Model = "models/weapons/w_pvp_ire.mdl",
	DrawModel = false,
	Equippable = true,
	UniqueEquippable = true,
	EquipType = "Particle",
	CanEntCreate = false,
	DrawName = true,

	NewItem = true,

	StoreId = GTowerStore.VIP,
	StorePrice = 15000,

	Tradable = false,
	UniqueInventory = true,

	PreviewURL = "particles/orbs.webp",

	EquippableEntity = true,
	RemoveOnDeath = true,
	OverrideOnlyEquippable = true,
	RemoveOnNoEntsLoc = true,
	CreateEquipEntity = function( self )

		local particle = ents.Create( "gmt_wearable_particle_orbs" )

		if IsValid( particle ) then
			particle:SetOwner( self.Ply )
			particle:SetParent( self.Ply )
			particle:Spawn()
		end

		return particle

	end
} )