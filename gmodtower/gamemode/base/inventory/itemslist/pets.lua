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
	InvCategory = "pet",
	
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



GTowerItems.RegisterItem( "RubikPet", {

	Name = "Rubik Pet",
	Description = "Solve me...",
	
	Model = "models/gmod_tower/rubikscube.mdl",
	
	DrawModel = true,
	Equippable = true,
	
	UniqueInventory = true,
	UniqueEquippable = true, 
	
	EquipType = "Pet",
	InvCategory = "pet",
	
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

if not Lobby1Mode then

GTowerItems.RegisterItem( "TurtlePet", {

	Name = "Turtle Pet",
	Description = "Bringing out the shell. Also not a soup.",
	
	Model = "models/gmod_tower/plush_turtle.mdl",
	
	DrawModel = true,
	Equippable = true,
	
	StoreId = GTowerStore.PET,
	StorePrice = 20000,
	
	UniqueInventory = true,
	UniqueEquippable = true, 
	
	EquipType = "Pet",
	InvCategory = "pet",
	
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

end


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
	InvCategory = "pet",
	
	CanEntCreate = false,
	DrawName = true,
	CanRemove = true,
	Tradable = true,
	NoBank = false,
	
	EquippableEntity = true,
	RemoveOnDeath = true,
	RemoveOnNoEntsLoc = true,
	
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

GTowerItems.RegisterItem( "YoshiEggs", {
	Name = "Yoshi Eggs",
	Description = "Cute little eggs that follow you around.",
	Model = "models/map_detail/toy_yoshiegg.mdl",

	DrawModel = true,
	Equippable = true,
		
	StoreId = GTowerStore.PET,
	StorePrice = 30000,
		
	UniqueInventory = true,
	UniqueEquippable = true, 
		
	EquipType = "PetSimple",
	InvCategory = "pet",
		
	CanEntCreate = false,
	DrawName = true,
	CanRemove = true,
	Tradable = true,
	NoBank = false,
		
	EquippableEntity = true,
	RemoveOnDeath = true,
	RemoveOnNoEntsLoc = true,

	CreateEquipEntity = function( self )
			
		local pet = ents.Create( "gmt_wearable_eggs" )
			
		if IsValid( pet ) then
			pet:SetOwner( self.Ply )
			pet:SetParent( self.Ply )
			pet:SetPos( self.Ply:GetPos() )
			pet:Spawn()
		end
			
		return pet
			
	end,
} )

RegisterItem("fishbowl",{
	Name = "Fish Bowl",
	Description = "A nice little goldfish pet.",
	ClassName = "gmt_item_fishbowl",
	Model = "models/map_detail/toystore_fishbowl.mdl",
	DrawModel = true,
	StorePrice = 2500,
	StoreId = GTowerStore.PET,
})