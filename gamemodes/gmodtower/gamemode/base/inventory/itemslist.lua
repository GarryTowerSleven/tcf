---------------------------------
module( "GTowerItems", package.seeall )

AddCSLuaFile( "itemslist/trophies.lua" )
AddCSLuaFile( "itemslist/models.lua" )
AddCSLuaFile( "itemslist/construction.lua" )
AddCSLuaFile( "itemslist/duel.lua" )
AddCSLuaFile( "itemslist/fireworks.lua" )
AddCSLuaFile( "itemslist/milestones.lua" )
AddCSLuaFile( "itemslist/pets.lua" )
AddCSLuaFile( "itemslist/posters.lua" )
AddCSLuaFile( "itemslist/food.lua" )
AddCSLuaFile( "itemslist/bonemods.lua" )
AddCSLuaFile( "itemslist/toys.lua" )
AddCSLuaFile( "itemslist/holiday.lua" )
AddCSLuaFile( "itemslist/specialfurniture.lua" )

include( "itemslist/trophies.lua" )
include( "itemslist/milestones.lua" )
include( "itemslist/construction.lua" )
include( "itemslist/duel.lua" )
include( "itemslist/fireworks.lua" )
include( "itemslist/pets.lua" )
include( "itemslist/models.lua" )
include( "itemslist/posters.lua" )
include( "itemslist/food.lua" )
include( "itemslist/bonemods.lua" )
include( "itemslist/toys.lua" )
include( "itemslist/holiday.lua" )
include( "itemslist/specialfurniture.lua" )

RegisterItem( "gmt_texthat", {
	Name = "Text Hat",
	Description = "A customizable text hat. Wear your words.",
	Model = "models/gmod_tower/fedorahat.mdl",
	UniqueInventory = true,
	UniqueEquippable = true,

	DrawModel = true,
	Equippable = true,
	EquipType = "TextHat",
	ClassName = "gmt_wearable_texthat",

	CanEntCreate = false,
	CanRemove = true,
	DrawName = true,
	Tradable = true,

	StoreId = GTowerStore.MERCHANT,
	StorePrice = 30000,

	RemoveOnDeath = true,
	RemoveOnNoEntsLoc = true,

	ExtraMenuItems = function ( item, menu )

		table.insert( menu, {
			[ "Name" ] = "Set Height Offset",
			[ "function" ] = function()

				local curHeight = LocalPlayer():GetInfoNum( "gmt_hatheight", 0 ) or 0

				Derma_SliderRequest(
					"Hat Height",
					"Please enter the height you wish the text to float above your head.",
					curHeight,
					-50, 50,
					0,
					function ( val ) RunConsoleCommand( "gmt_hatheight", val ) end
				)

			end
		} )

		table.insert( menu, {
			[ "Name" ] = "Set Text",
			[ "function" ] = function()

				local curText = LocalPlayer():GetInfo( "gmt_hattext" ) or ""

				Derma_StringRequest(
					"Hat Text",
					"Please enter the text you would like to float above your head.",
					curText,
					function ( text )
						if string.find(text, "#") then
							text = string.gsub(text, "#", "")
						end
						RunConsoleCommand( "gmt_hattext", text )
					end
				)

			end
		} )

	end,

	EquippableEntity = true,
	OverrideOnlyEquippable = true,
	CreateEquipEntity = function( self )

		local hatEnt = ents.Create( "gmt_wearable_texthat" )

		if IsValid( hatEnt ) then
			hatEnt.IsActiveEquippable = true
			hatEnt:SetPos( self.Ply:GetPos() )
			hatEnt:SetOwner( self.Ply )
			hatEnt:SetParent( self.Ply )
			hatEnt.Owner = self.Ply

			hatEnt:Spawn()
		end

		return hatEnt

	end
} )

RegisterItem( "birthday_head", {
	Name = "Birthday Message",
	Description = "A celebrative birthday message!",
	Model = "",
	UniqueInventory = true,
	DrawModel = false,
	Equippable = true,
	EquipType = "BirthdayHead",
	CanEntCreate = false,
	DrawName = true,
	BankAdminOnly = true,
	Tradable = false,
	
	EquippableEntity = true,
	OverrideOnlyEquippable = true,
	CreateEquipEntity = function( self )

		local BirthdayHead = ents.Create( "gmt_birthday_head" )

		if IsValid( BirthdayHead ) then
			BirthdayHead:SetPly( self.Ply )
			BirthdayHead:Spawn()
		end

		return BirthdayHead

	end

} )

RegisterItem("rave_ball",{
	Name = "Rave Ball",
	Description = "Get your rave on with this musical orb. Splashes colorful bursts, and unlike the disco ball, can give people seizures (use responsively).",
	Model = "models/gmod_tower/discoball.mdl",
	ClassName = "gmt_visualizer_raveball",
	UniqueInventory = true,
	EnablePhyiscs = true,
	DrawModel = true,
	StoreId = GTowerStore.MUSIC,
	StorePrice = 30000,
})

RegisterItem("disco_ball",{
	Name = "Disco Ball",
	Description = "A colorful disco ball that plays music. Comes with lasers.",
	Model = "models/gmod_tower/discoball.mdl",
	ClassName = "gmt_visualizer_disco",
	UniqueInventory = true,
	EnablePhyiscs = true,
	DrawModel = true,
	StoreId = GTowerStore.MUSIC,
	StorePrice = 4000,
})

RegisterItem("bar01",{
	Name = "Bar Table",
	Description = "A table, stolen from a bar.",
	Model = "models/props/cs_militia/bar01.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 400,
	MoveSound = "furniture2"
})

RegisterItem("barstool",{
	Name = "Bar Stool",
	Description = "Sit up high, just like at a bar.",
	Model = "models/props/cs_militia/barstool01.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 65,
	MoveSound = "furniture"
})

RegisterItem("chair01a",{
	Name = "Bar Chair",
	Description = "A chair from the bar.",
	Model = "models/props_interiors/furniture_chair01a.mdl",
	UniqueInventory = false,
	DrawModel = true,
	MoveSound = "furniture"
})

RegisterItem("black_sofa",{
	Name = "Black Sofa",
	Description = "A large, black, expensive sofa for your guests.",
	Model = "models/gmod_tower/css_couch.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 400,
	MoveSound = "furniture3"
})

RegisterItem("bookshelf3",{
	Name = "Book Shelf",
	Description = "A shelf with books on it.",
	Model = "models/props/cs_office/bookshelf3.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 100,
	MoveSound = "furniture2"
})

RegisterItem("breenglobe",{
	Name = "Globe",
	Description = "Look at the earth and study its geography.",
	Model = "models/props_combine/breenglobe.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SOUVENIR,
	StorePrice = 5,
})

RegisterItem("cabinet",{
	Name = "Letter Box Cabinet",
	Description = "Used to store mail with.",
	Model = "models/props_lab/partsbin01.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SOUVENIR,
	StorePrice = 35,
})

RegisterItem("cabitnetdarw",{
	Name = "Cabinet",
	Description = "A nice piece of furniture to keep your suite looking good.",
	Model = "models/props_interiors/furniture_cabinetdrawer02a.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 185,
	MoveSound = "furniture3"
})

RegisterItem("chair1",{
	Name = "Chair",
	Description = "A homely chair to sit on.",
	Model = "models/props_c17/furniturechair001a.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 90,
	MoveSound = "wood"
})

RegisterItem("chairantique",{
	Name = "Antique Chair",
	Description = "An old chair that can really add some class to your suite.",
	Model = "models/props/de_inferno/chairantique.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 95,
	MoveSound = "wood"
})

RegisterItem("chairrstool",{
	Name = "Metal Stool",
	Description = "Cold and uncomfortable - but useful.",
	Model = "models/props_c17/chair_stool01a.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 55,
	MoveSound = "furniture"
})

RegisterItem("clipboard",{
	Name = "Clipboard",
	Description = "Manage your company.",
	Model = "models/props_lab/clipboard.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SOUVENIR,
	StorePrice = 5,
})

RegisterItem("clock",{
	Name = "Clock",
	Description = "A broken clock.",
	Model = "models/props_combine/breenclock.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SOUVENIR,
	StorePrice = 5,
})

RegisterItem("coffee_mug3",{
	Name = "Coffee Mug",
	Description = "A coffee mug that's just for looks.",
	Model = "models/props/cs_office/coffee_mug3.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SOUVENIR,
	StorePrice = 10,
	MoveSound = "glass"
})

RegisterItem("computer",{
	Name = "Desktop Computer",
	Description = "Another computer because you need more power.",
	Model = "models/props/cs_office/computer_case.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.ELECTRONIC,
	StorePrice = 500,
})

RegisterItem("computer_display",{
	Name = "Monitor w/ Keyboard",
	Description = "This monitor comes with a keyboard and a mouse.",
	Model = "models/props/cs_office/computer.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.ELECTRONIC,
	StorePrice = 150,
})

RegisterItem("computer_monitor",{
	Name = "Monitor",
	Description = "Another monitor for your computer.",
	Model = "models/props/cs_office/computer_monitor.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.ELECTRONIC,
	StorePrice = 130,
})

RegisterItem("couch",{
	Name = "Couch",
	Description = "A couch that's both comfortable and stylish.",
	Model = "models/props/cs_militia/couch.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 200,
	MoveSound = "furniture3"
})

RegisterItem("deckchair",{
	Name = "Deck Chair",
	Description = "A comfy and affordable deck chair.",
	Model = "models/deckchair.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 85,
	MoveSound = "wood"
})

RegisterItem("deskchair",{
	Name = "Suite Desk Chair",
	Description = "Sit in this fancy desk chair.",
	Model = "models/props/cs_office/chair_office.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 85,
	MoveSound = "furniture"
})

RegisterItem("file_box",{
	Name = "Filing Box",
	Description = "A box to store all your files in.",
	Model = "models/props/cs_office/file_box.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SOUVENIR,
	StorePrice = 35,
	MoveSound = "paper",
	UseSound = "use_paperstack.wav",
})

RegisterItem("fire_extinguisher",{
	Name = "Fire Extinguisher",
	Description = "Put out fires with this.",
	Model = "models/props/cs_office/fire_extinguisher.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SOUVENIR,
	StorePrice = 35,
	UseSound = "use_fireextinguisher.wav",
})

RegisterItem("frame",{
	Name = "Picture Frame",
	Description = "Remember Alyx's family with this picture.",
	Model = "models/props_lab/frame002a.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SOUVENIR,
	StorePrice = 5,
})

RegisterItem("furnituredrawer001a",{
	Name = "Dresser",
	Description = "A simple dresser to hold clothes.",
	Model = "models/props_c17/furnituredrawer001a.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 40,
	MoveSound = "furniture"
})

RegisterItem("furnituredrawer002a",{
	Name = "End Table",
	Description = "An end table, with a drawer in it.",
	Model = "models/props_c17/furnituredrawer002a.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 35,
	MoveSound = "furniture"
})

RegisterItem("furnituredrawer003a",{
	Name = "Drawer Tower",
	Description = "A tower of drawers to store items in.",
	Model = "models/props_c17/furnituredrawer003a.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 20,
	MoveSound = "furniture"
})

RegisterItem("furnituredresser001a",{
	Name = "Wardrobe",
	Description = "A wardrobe to keep your clothes together in Narnia.",
	Model = "models/props_c17/furnituredresser001a.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 45,
	MoveSound = "furniture2"
})

RegisterItem("furnituretable001a",{
	Name = "Round Table",
	Description = "A small round table to place things on.",
	Model = "models/props_c17/furnituretable001a.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 70,
	MoveSound = "furniture2"
})

RegisterItem("furnituretable002a",{
	Name = "Square Table",
	Description = "A square table to place your things on.",
	Model = "models/props_c17/furnituretable002a.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 40,
	MoveSound = "furniture2"
})

RegisterItem("furniture_couch02a",{
	Name = "Armchair",
	Description = "Sit in this chair and enjoy the fire.",
	Model = "models/props/de_inferno/furniture_couch02a.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 250,
	MoveSound = "furniture3"
})

RegisterItem("furniture_shelf01a",{
	Name = "Shelf",
	Description = "Place trophies or other items on this nice shelf.",
	Model = "models/props/cs_militia/furniture_shelf01a.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 115,
	MoveSound = "furniture3"
})

RegisterItem("gmtdesk",{
	Name = "Computer Desk",
	Description = "Place your computer and other things on this desk.",
	Model = "models/gmod_tower/gmtdesk.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 450,
})

RegisterItem("gun_cabinet",{
	Name = "Gun Cabinet",
	Description = "A display cabinet filled with authentic shotguns.",
	Model = "models/props/cs_militia/gun_cabinet.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 500,
	MoveSound = "wood"
})

RegisterItem("jar01a",{
	Name = "Jar",
	Description = "A collectible jar filled with imagination.",
	Model = "models/props_lab/jar01a.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SOUVENIR,
	StorePrice = 5,
})

RegisterItem("microwave",{
	Name = "Microwave",
	Description = "Cook things to perfection in minutes.",
	Model = "models/props/cs_office/microwave.mdl",
	UseSound = "use_microwave.wav",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.ELECTRONIC,
	StorePrice = 100,
})

RegisterItem("oldmicrowave",{
	Name = "Old Microwave",
	Description = "Old, but still usable.",
	Model = "models/props/cs_militia/microwave01.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.ELECTRONIC,
	StorePrice = 80,
})

RegisterItem("patiochair01",{
	Name = "Patio Chair",
	Description = "A comfy patio chair.",
	Model = "models/props/de_tides/patio_chair.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 135,
})

RegisterItem("patiochair02",{
	Name = "Metal Chair",
	Description = "An outdoor metal chair.",
	Model = "models/props/de_tides/patio_chair2.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 100,
})

RegisterItem("phone",{
	Name = "Phone",
	Description = "A phone to keep you in contact with the world.",
	Model = "models/props/cs_office/phone.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.ELECTRONIC,
	StorePrice = 20,
	UseSound = "use_phone.wav",
})

RegisterItem("plant1",{
	Name = "Office Plant",
	Description = "A tall plant that fits any place.",
	Model = "models/props/cs_office/plant01.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SOUVENIR,
	StorePrice = 30,
})

RegisterItem("bball",{
	Name = "Beach Ball",
	Description = "We stole this from the pool, don't tell anyone!",
	Model = "models/gmod_tower/beachball.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.TOY,
	StorePrice = 500,
	ClassName = "gmt_beachball",
})

RegisterItem("pot01a",{
	Name = "Tea Kettle",
	Description = "Brew tea with this pot.",
	Model = "models/props_interiors/pot01a.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SOUVENIR,
	StorePrice = 5,
})

RegisterItem("pot02a",{
	Name = "Pot",
	Description = "Used to cook food.",
	Model = "models/props_interiors/pot02a.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SOUVENIR,
	StorePrice = 5,
})

RegisterItem("potted_plant1",{
	Name = "Potted Plant - Red",
	Description = "A plant with red flowers.",
	Model = "models/props/de_inferno/potted_plant2.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SOUVENIR,
	StorePrice = 10,
})

RegisterItem("potted_plant2",{
	Name = "Potted Plant - Purple",
	Description = "A plant with purple flowers.",
	Model = "models/props/de_inferno/potted_plant1.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SOUVENIR,
	StorePrice = 10,
})

RegisterItem("pottery02",{
	Name = "Round Pot",
	Description = "A squat, round pot.",
	Model = "models/props_c17/pottery02a.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SOUVENIR,
	StorePrice = 5,
})

RegisterItem("pottery03",{
	Name = "Flat Pot",
	Description = "A flat pot for plants.",
	Model = "models/props_c17/pottery03a.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SOUVENIR,
	StorePrice = 5,
})

RegisterItem("pottery04",{
	Name = "Vase",
	Description = "Holds all your flowers.",
	Model = "models/props_c17/pottery04a.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SOUVENIR,
	StorePrice = 5,
})

RegisterItem("pottery06",{
	Name = "Fancy Pot",
	Description = "A pot with a nifty design.",
	Model = "models/props_c17/pottery06a.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SOUVENIR,
	StorePrice = 5,
})

RegisterItem("pottery07",{
	Name = "Large Vase",
	Description = "Hold your larger flowers in this.",
	Model = "models/props_c17/pottery07a.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SOUVENIR,
	StorePrice = 5,
})

RegisterItem("pottery09",{
	Name = "Copper Pot",
	Description = "Not really made of copper.",
	Model = "models/props_c17/pottery09a.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SOUVENIR,
	StorePrice = 5,
})

RegisterItem("radio",{
	Name = "Radio",
	Description = "Visualize your music and chill out.",
	Model = "models/props/cs_office/radio.mdl",
	ClassName = "gmt_visualizer_radio",
	DrawModel = true,
	StoreId = GTowerStore.ELECTRONIC,
	StorePrice = 150,
	InvCategory = "7", // electronics
})

RegisterItem("remotecontrol",{
	Name = "Remote Control",
	Description = "A simple remote.",
	Model = "models/props/cs_office/projector_remote.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.ELECTRONIC,
	StorePrice = 15,
})

RegisterItem("restauranttable",{
	Name = "Restaurant Table",
	Description = "A fancy table used mostly in restaurants.",
	Model = "models/props/de_tides/restaurant_table.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 145,
})

RegisterItem("sidetable",{
	Name = "Bedside Table",
	Description = "A table to put next to your bed.",
	Model = "models/gmod_tower/bedsidetable.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 70,
	MoveSound = "furniture"
})

RegisterItem("sofa",{
	Name = "Sofa",
	Description = "A large, expensive sofa for your guests.",
	Model = "models/props/cs_office/sofa.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 350,
	MoveSound = "furniture3"
})

RegisterItem("sofachair",{
	Name = "Sofa Chair",
	Description = "Comfy and large - perfect for relaxing in.",
	Model = "models/props/cs_office/sofa_chair.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 175,
	MoveSound = "furniture"
})

RegisterItem("suitecouch",{
	Name = "Suite Sofa",
	Description = "Sit down on a comfy couch.",
	Model = "models/gmod_tower/suitecouch.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 300,
	MoveSound = "furniture3"
})

RegisterItem("suiteshelf",{
	Name = "Suite Shelf",
	Description = "Place tons of items on these shelves.",
	Model = "models/gmod_tower/suiteshelf.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 320,
	MoveSound = "furniture"
})

RegisterItem("suitespeaker",{
	Name = "Small Speaker",
	Description = "A tall speaker that makes you look richer.",
	Model = "models/gmod_tower/suitspeaker.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.ELECTRONIC,
	StorePrice = 30,
})

RegisterItem("suitetable",{
	Name = "Suite Table",
	Description = "A well-crafted table for your stuff.",
	Model = "models/gmod_tower/suitetable.mdl",
	ClassName = "gmt_room_table",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 200,
	MoveSound = "furniture2"
})

RegisterItem("tablecoffe",{
	Name = "Coffee Table",
	Description = "Place your coffee on this nice table.",
	Model = "models/props/de_inferno/tablecoffee.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 150,
	MoveSound = "furniture"
})

RegisterItem("table_shed",{
	Name = "Wooden Shed Table",
	Description = "A very large durable table.",
	Model = "models/props/cs_militia/table_shed.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 95,
	MoveSound = "furniture2"
})

RegisterItem("toothbrushset01",{
	Name = "Toothbrush Set",
	Description = "Keep your toothbrushes in one set.",
	Model = "models/props/cs_militia/toothbrushset01.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SOUVENIR,
	StorePrice = 5,
})

RegisterItem("tv",{
	Name = "TV",
	Description = "Watch YouTube and other videos.",
	Model = "models/gmod_tower/suitetv.mdl",
	ClassName = "gmt_room_tv",
	UniqueInventory = true,
	DrawModel = true,
	StoreId = GTowerStore.ELECTRONIC,
	StorePrice = 150,
	InvCategory = "7", // electronics
})

RegisterItem("tvcabinet",{
	Name = "TV Cabinet",
	Description = "Organize your entertainment with this TV cabinet.",
	Model = "models/gmod_tower/gt_woodcabinet01.mdl",
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 500,
	MoveSound = "furniture3"
})

RegisterItem("tv_large",{
	Name = "Bigscreen TV",
	Description = "Watch YouTube and other videos on a larger screen.",
	Model = "models/gmod_tower/suitetv_large.mdl",
	ClassName = "mediaplayer_tv",
	UniqueInventory = true,
	DrawModel = true,
	StoreId = GTowerStore.ELECTRONIC,
	StorePrice = 3150,
})

RegisterItem("wood_table",{
	Name = "Small Wood Table",
	Description = "A small, but durable wood table.",
	Model = "models/props/cs_militia/wood_table.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 75,
	MoveSound = "wood"
})

RegisterItem("theater_seat",{
	Name = "Theater Seat",
	Description = "A must-have for all home theaters.",
	Model = "models/props_trainstation/traincar_seats001.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 250,
})

RegisterItem("picnic_table",{
	Name = "Picnic Table",
	Description = "Set up a picnic or host an event with this table.",
	Model = "models/gmod_tower/patio_table.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 150,
	MoveSound = "wood"
})

RegisterItem("plazabooth",{
	Name = "Food Court Booth",
	Description = "The food court booth, just for you!",
	Model = "models/gmod_tower/plazabooth.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 400,
	MoveSound = "furniture"
})

RegisterItem("plazaboothstore",{
	Name = "Food Court Table",
	Description = "The food court table, ripped right off the ground.",
	Model = "models/gmod_tower/courttable.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 150,
})

RegisterItem("pianostool",{
	Name = "Piano Stool",
	Description = "Sit on this and play your piano in style.",
	Model = "models/fishy/furniture/piano_seat.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.MUSIC,
	StorePrice = 150,
})

RegisterItem("coffeetable",{
	Name = "Modern Coffee Table",
	Description = "A nice coffee table for your drinks.",
	Model = "models/gmod_tower/coffeetable.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 800,
})

RegisterItem("comfychair",{
	Name = "Comfy Chair",
	Description = "A soft comfy chair.",
	Model = "models/gmod_tower/comfychair.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 500,
})

RegisterItem("kitchentable",{
	Name = "Kitchen Counter",
	Description = "A kitchen counter, for cooking.",
	Model = "models/gmod_tower/kitchentable.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 1500,
})

RegisterItem("medchair",{
	Name = "Modern Desk Chair",
	Description = "A modern chair for your desk.",
	Model = "models/gmod_tower/medchair.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 400,
})

RegisterItem("meddesk",{
	Name = "Modern Desk",
	Description = "A large modern desk.",
	Model = "models/gmod_tower/meddesk.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 1000,
})

RegisterItem("meddeskcor",{
	Name = "Fancy Desk Corner",
	Description = "A large fancy desk corner.",
	Model = "models/gmod_tower/meddeskcor.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 400,
})

// These don't work because of their offsets
/*RegisterItem("artasian",{
	Name = "Asian Wall Scroll",
	Description = "Add an eastern touch to your condo.",
	Model = "models/sims/gm_artasian.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 650,
	
	Manipulator = function( ang, pos, normal )
		ang:RotateAroundAxis( ang:Right(), 270 )
		ang:RotateAroundAxis( ang:Up(), 180 )
		ang:RotateAroundAxis( ang:Forward(), 180 )
		pos = pos - ( normal * 1.2 )
		return pos
	end,
})

RegisterItem("artbridge",{
	Name = "Bridge Painting",
	Description = "A lovely painting of a bridge.",
	Model = "models/sims/gm_artbridge.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 500,
})

RegisterItem("artmodern",{
	Name = "Modern Art",
	Description = "An expressive piece of art that brings out the art scholar in everyone.",
	Model = "models/sims/gm_artmodern.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 500,
})

RegisterItem("artplane",{
	Name = "Plane Painting",
	Description = "It's got a plane on it.",
	Model = "models/sims/gm_artplane.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 500,
})*/

RegisterItem("simsbookcase",{
	Name = "Bookcase",
	Description = "Become a thespian with all these books.",
	Model = "models/sims/gm_bookcase.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 750,
})

RegisterItem("typewriter",{
	Name = "Typewriter",
	Description = "The incessant clacking is enough to drive any man insane. That's why I became a private eye.",
	Model = "models/sunabouzu/typewriter.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.ELECTRONIC,
	StorePrice = 1500,
	UseSound = "use_typewriter.wav",
})

RegisterItem("book1",{
	Name = "1984",
	Description = "Think GMT is an Orwellian society? Don't know what that means? Read 1984, then.",
	Model = "models/sunabouzu/book_single1.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SOUVENIR,
	StorePrice = 250,
	MoveSound = "paper",
})

RegisterItem("book2",{
	Name = "Coverless Book",
	Description = "A red coverless book, ready to be filled with writings of burning passion.",
	Model = "models/sunabouzu/book_single1.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SOUVENIR,
	StorePrice = 250,
	ModelSkinId = 1,
	MoveSound = "paper",
})

RegisterItem("book3",{
	Name = "Coverless Book",
	Description = "A blue coverless book, ready to be filled with... tears?",
	Model = "models/sunabouzu/book_single1.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SOUVENIR,
	StorePrice = 250,
	ModelSkinId = 3,
	MoveSound = "paper",
})

RegisterItem("reallyoldphone",{
	Name = "Older Phone",
	Description = "Stuck in the past? Prove it with this ancient phone.",
	Model = "models/sunabouzu/old_phone.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.ELECTRONIC,
	StorePrice = 400,
	UseSound = "use_oldphone.wav",
})

RegisterItem("modernchair",{
	Name = "Modern Chair",
	Description = "Truly a piece of modern art. Too bad it's mostly used as a butt rest.",
	Model = "models/sunabouzu/lobby_chair.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 750,
})

RegisterItem("bigspeaker",{
	Name = "Big Speaker",
	Description = "Increase the effectiveness of your sound system tenfold.",
	Model = "models/sunabouzu/speaker.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.ELECTRONIC,
	StorePrice = 1000,
})

RegisterItem("filingcabinetwithbooze",{
	Name = "Filing Cabinet",
	Description = "These are the only things that ever need to be filed anyway.",
	Model = "models/sunabouzu/noir_cabinet.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 1000,
})

RegisterItem("paperpile",{
	Name = "Pile of Papers",
	Description = "You should really keep your desk cleaner, you know. What's this, case notes?",
	Model = "models/sunabouzu/paper_stack.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SOUVENIR,
	StorePrice = 150,
	MoveSound = "paper",
	UseSound = "use_paperstack.wav",
})

RegisterItem("compositionnotebook",{
	Name = "Notebook",
	Description = "Well, maybe there's something useful written in it related to smoothies. Then again, maybe it's just amusing drawings.",
	Model = "models/sunabouzu/notebook_elev.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.FOOD,
	StorePrice = 400,
})

RegisterItem("shotglass",{
	Name = "Shot Glass",
	Description = "All the good hard-boiled detectives have at least one shot glass, so why don't you?",
	Model = "models/sunabouzu/shot_glass.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SOUVENIR,
	StorePrice = 25,
})

RegisterItem("metalshelving",{
	Name = "Metal Shelving",
	Description = "It does everything all those other, lesser shelves do, but it's made of metal!",
	Model = "models/sunabouzu/metal_shelf.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 400,
})

RegisterItem("sunendtable",{
	Name = "End Table",
	Description = "Unsurprisingly, it's an end table. It's secret ambition is to become a coffee table.",
	Model = "models/sunabouzu/end_table.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 300,
})

/*RegisterItem("mansionwalllight",{
	Name = "Wall Light",
	Description = "Lights: now wall-mounted!",
	Model = "models/sunabouzu/mansion_wall_light.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.ELECTRONIC,
	StorePrice = 750,
})*/

RegisterItem("mansionpillar",{
	Name = "Pillar",
	Description = "Give your suite that whole 'this place is really 100 years old' look.",
	Model = "models/sunabouzu/mansion_pillar.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 1000,
})
--[[
RegisterItem("mansioncurtains",{
	Name = "Curtains",
	Description = "Keep the harsh sun away from your pale skin with these lovely curtains.",
	Model = "models/sunabouzu/mansion_curtains.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId =GTowerStore.SUITE,
	StorePrice = 475,
})]]

/*RegisterItem("floater",{
	Name = "Inner Tube",
	Description = "Throw it in the GMT pool and have fun!",
	Model = "models/sunabouzu/floater.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.MERCHANT,
	StorePrice = 1500,
})*/

RegisterItem("me2_illusive",{
	Name = "Desk Chair",
	Description = "This desk chair is so futuristic that it transcends comfortable back down to extremely uncomfortable.",
	Model = "models/haxxer/me2_props/illusive_chair.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 800,
	MoveSound = "furniture2",
})

RegisterItem("me2_reclining",{
	Name = "Reclining Chair",
	Description = "If it breaks, there's a money back guarantee.* *Money back guarantee does not give you money back.",
	Model = "models/haxxer/me2_props/reclining_chair.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 1200,
	MoveSound = "furniture2",
})

RegisterItem("turntable",{
	Name = "Turntable",
	Description = "Plug this into your Macbook Pro and you'll be a regular Skrillex.",
	Model = "models/props_vtmb/turntable.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.MUSIC,
	StorePrice = 1500,
	MoveSound = "furniture",
	UseSound = "use_scratch.wav"
})

RegisterItem("grain",{
	Name = "Grain Sack",
	Description = "A sack full of grain.",
	Model = "models/props_granary/grain_sack.mdl",
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 500,
	MoveSound = "cloth"
})
RegisterItem("bushsmall",{
	Name = "Small Bush",
	Description = "A small bush to decorate your garden with, or home!",
	Model = "models/garden/gardenbush2.mdl",
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 250,
})
RegisterItem("bushbig",{
	Name = "Big Bush",
	Description = "A bigger version of that other bush, for even better gardens.",
	Model = "models/garden/gardenbush.mdl",
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 350,
})
RegisterItem("bushred",{
	Name = "Small Red Bush",
	Description = "A red bush to put in your garden.",
	Model = "models/gmod_tower/plant/largebush01.mdl",
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 150,
})
RegisterItem("ferns",{
	Name = "Ferns",
	Description = "Nice ferns for in your garden.",
	Model = "models/hessi/palme.mdl",
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 175,
})
RegisterItem("wildbush",{
	Name = "Wild Bush",
	Description = "Collected from Narnia, this wild bush will sure make your garden look interesting.",
	Model = "models/props/de_inferno/largebush02.mdl",
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 175,
})
RegisterItem("lavenderbushes",{
	Name = "Lavender Bush",
	Description = "A nice lavender bush. Will surely make your suite smell great!",
	Model = "models/props/de_inferno/largebush03.mdl",
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 200,
	
})
RegisterItem("rosebush",{
	Name = "Rose Bush",
	Description = "Nice red roses packed in a bush.",
	Model = "models/props/de_inferno/largebush04.mdl",
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 210,
	
})
RegisterItem("hydrabush",{
	Name = "Big Hydrangea Bush",
	Description = "A big hydrangea bush.",
	Model = "models/props/de_inferno/largebush05.mdl",
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 375,
	
})
RegisterItem("fallentree",{
	Name = "Fallen Tree Trunk",
	Description = "A fallen over tree trunk.",
	Model = "models/props_foliage/fallentree01.mdl",
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 750,
	
})
RegisterItem("treestump",{
	Name = "Tree Stump",
	Description = "This was once a tree...",
	Model = "models/props_foliage/tree_stump01.mdl",
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 375,
	
})
RegisterItem("bigrock",{
	Name = "Big Rock",
	Description = "A big rock to place in your garden.",
	Model = "models/props_nature/rock_worn001.mdl",
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 250,
	
})
RegisterItem("rockpile",{
	Name = "Rock Pile",
	Description = "A pile of rocks, nice to decorate your garden with.",
	Model = "models/props_nature/rock_worn_cluster002.mdl",
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 175,
	
})
RegisterItem("ggnome",{
	Name = "Garden Gnome",
	Description = "A mysterious object recovered from outer space.",
	Model = "models/props_junk/gnome.mdl",
	DrawModel = true,
	StoreId = GTowerStore.SOUVENIR,
	StorePrice = 1000,
	
})

RegisterItem("leatherarmchair",{
	Name = "Leather Armchair",
	Description = "No* cows were harmed in the making of this chair. *Lots of",
	Model = "models/props_vtmb/armchair.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 700,
	MoveSound = "furniture2",
})

RegisterItem("leathersofa",{
	Name = "Leather Sofa",
	Description = "Triple the Leather Armchair fun! Wow!",
	Model = "models/props_vtmb/sofa.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 1700,
	MoveSound = "furniture3",
})

RegisterItem("chairfancyhotel",{
	Name = "Hotel Chair",
	Description = "We stole this chair from a hotel just for you. Don't tell anybody.",
	Model = "models/props_vtmb/chairfancyhotel.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 1100,
	MoveSound = "furniture",
})

RegisterItem("brownarmchair",{
	Name = "Brown Armchair",
	Description = "Only has one cushion, and it makes a really awful cushion fort.",
	Model = "models/splayn/rp/lr/chair.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 800,
	MoveSound = "furniture2",
})
RegisterItem("autopiano",{
	Name = "Piano",
	Description = "Autoplay well known tunes with this magical piano.",
	Model = "models/fishy/furniture/piano.mdl",
	UniqueInventory = true,
	DrawModel = true,
	StoreId = 27,
	StorePrice = 8000,
	ClassName = "gmt_item_piano",
})
RegisterItem("drumset",{
	Name = "Drum Set",
	Description = "Start your own band with this working drumset!",
	Model = "models/map_detail/music_drumset.mdl",
	UniqueInventory = false,
	DrawModel = true,
	ClassName = "gmt_instrument_drums",
	
	StoreId = 27,
	StorePrice = 10000,
})
RegisterItem("woodgametable",{
	Name = "Wooden Table",
	Description = "A wooden multipurpose table.",
	Model = "models/gmod_tower/gametable.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 1000,
	MoveSound = "furniture2",
	DateAdded = 1399291083,
})

RegisterItem("brownsofa",{
	Name = "Brown Sofa",
	Description = "Comes with three cushions, for a fort that's way better than the Brown Armchair one.",
	Model = "models/splayn/rp/lr/couch.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 2000,
	MoveSound = "furniture3",
})

RegisterItem("wooddeskwow",{
	Name = "Wooden Desk",
	Description = "This desk is imported directly from the Swedish furniture store, Bullseye.",
	Model = "models/splayn/rp/of/desk1.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 1300,
	MoveSound = "furniture3",
})

RegisterItem("moderncouchpt",{
	Name = "Modern Couch",
	Description = "Made from the finest yak hair and goose down, you'd think this would be comfortable. Unfortunately, the inside is yak hair and the outside is goose down. Also, it's modern.",
	Model = "models/pt/lobby/pt_couch.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 1400,
	MoveSound = "furniture3",
})

RegisterItem("toiletchair",{
	Name = "Toilet",
	Description = "For all your personal... duties.",
	Model = "models/props_c17/furnituretoilet001a.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.SUITE,
	StorePrice = 1000,
	UseSound = "use_toilet.wav",
})

RegisterItem("haybale",{
	Name = "Hay Bale",
	Description = "A special hay bale that you can't buy!",
	Model = "models/props_gameplay/haybale.mdl",
	DrawModel = true,
	MoveSound = "cloth"
})

RegisterItem("suitetetris",{
	Name = "Blockles Machine",
	Description = "Your own personal Blockles machine!",
	Model = "models/gmod_tower/gba.mdl",
	ClassName = "gmt_tetris",
	DrawModel = true,
	UniqueInventory = false,
	Tradable = true,
	StorePrice = 40000,
})

//-----------------------------