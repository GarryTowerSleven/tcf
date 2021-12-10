module( "GTowerItems", package.seeall )

RegisterItem( "DuelMain", {
	Name = "Duel - Magnums",
	Description = "Duel a single player on the server for GMC or for fun. One time use.",
	Model = "models/weapons/w_357.mdl",
	UniqueInventory = false,

	DrawModel = true,
	Equippable = false,
	CanEntCreate = false,
	CanRemove = true,
	DrawName = true,
	--Tradable = true,
	--InvCategory = "duel",

	StoreId = GTowerStore.DUEL,
	StorePrice = 150,

	WeaponClass = "weapon_357",
	WeaponName = "Magnums",
	ExtraMenuItems = function( item, menu, slot )

		table.insert( menu,
		{
			[ "Name" ] = "Duel A Player",
			[ "function" ] = function(ply)

				--[[Derma_DuelRequest(
					item.Name,
					"Select the player you want to duel and the max bet amount.",
					0,
					function( ply, amount )

						if IsValid( ply ) then
							RunConsoleCommand( "gmt_duelinvite", LocalPlayer():EntIndex(), ply:EntIndex(), item.WeaponClass, amount, item.WeaponName, item.MysqlId )
						end

					end,
					nil,
					"INVITE TO DUEL",
					"CANCEL"
				)]]

				ply:Msg2( "Dueling is currently disabled!" )

			end
		} )

	end,
} )

RegisterItem( "DuelSword", {
	Base = "DuelMain",
	Name = "Duel - Swords",
	Model = "models/weapons/w_pvp_swd.mdl",
	StorePrice = 180,
	WeaponClass = "weapon_sword",
	WeaponName = "Swords",
} )

RegisterItem( "DuelShotgun", {
	Base = "DuelMain",
	Name = "Duel - Shotguns",
	Model = "models/weapons/w_shotspas12z.mdl",
	StorePrice = 180,
	WeaponClass = "weapon_spas12",
	WeaponName = "Shotguns",
} )

RegisterItem( "DuelAkimbo", {
	Base = "DuelMain",
	Name = "Duel - Akimbos",
	Model = "models/weapons/w_pvp_akimbo.mdl",
	StorePrice = 180,
	WeaponClass = "weapon_akimbo",
	WeaponName = "Akimbo",
} )

RegisterItem( "DuelRPG", {
	Base = "DuelMain",
	Name = "Duel - Rockets",
	Model = "models/weapons/w_rocket_launcher.mdl",
	StorePrice = 250,
	WeaponClass = "weapon_rpg",
	WeaponName = "RPGs",
} )

RegisterItem( "DuelSMG", {
	Base = "DuelMain",
	Name = "Duel - Sub-Machine Guns",
	Model = "models/weapons/w_smg1.mdl",
	StorePrice = 150,
	WeaponClass = "weapon_smg1",
	WeaponName = "SMGs",
} )

RegisterItem( "DuelFists", {
	Base = "DuelMain",
	Name = "Duel - Fists",
	Model = "models/weapons/w_pvp_ire.mdl",
	StorePrice = 180,
	WeaponClass = "weapon_rage",
	WeaponName = "Fists",
} )

RegisterItem( "DuelSniper", {
	Base = "DuelMain",
	Name = "Duel - Snipers",
	Model = "models/weapons/w_pvp_as50.mdl",
	StorePrice = 200,
	WeaponClass = "weapon_sniper",
	WeaponName = "Snipers",
} )

RegisterItem( "DuelChainsaw", {
	Base = "DuelMain",
	Name = "Duel - Chainsaws",
	Model = "models/weapons/w_pvp_chainsaw.mdl",
	StorePrice = 200,
	WeaponClass = "weapon_chainsaw",
	WeaponName = "Chainsaws",
} )

RegisterItem( "DuelNES", {
	Base = "DuelMain",
	Name = "Duel - NES Zapper",
	Model = "models/weapons/w_pvp_neslg.mdl",
	StorePrice = 250,
	WeaponClass = "weapon_neszapper",
	WeaponName = "NES Zapper",
} )

RegisterItem( "DuelXM8", {
	Base = "DuelMain",
	Name = "Duel - XM8",
	Model = "models/weapons/w_pvp_xm8.mdl",
	StorePrice = 250,
	WeaponClass = "weapon_xm8",
	WeaponName = "XM8",
} )

RegisterItem( "DuelM1Garand", {
	Base = "DuelMain",
	Name = "Duel - M1 Garand",
	Model = "models/weapons/w_pvp_m1.mdl",
	StorePrice = 200,
	WeaponClass = "weapon_m1grand",
	WeaponName = "M1 Garand",
} )

RegisterItem( "DuelRagingBull", {
	Base = "DuelMain",
	Name = "Duel - Raging Bull",
	Model = "models/weapons/w_pvp_ragingb.mdl",
	StorePrice = 250,
	WeaponClass = "weapon_ragingbull",
	WeaponName = "Raging Bull",
} )

RegisterItem( "DuelCrossbow", {
	Base = "DuelMain",
	Name = "Duel - Crossbow",
	Model = "models/weapons/w_crossbow.mdl",
	StorePrice = 200,
	WeaponClass = "weapon_crossbow",
	WeaponName = "Crossbow",
} )

RegisterItem( "Duel357", {
	Base = "DuelMain",
	Name = "Duel - .357",
	Model = "models/weapons/w_357.mdl",
	StorePrice = 200,
	WeaponClass = "weapon_357",
	WeaponName = ".357",
} )

RegisterItem( "DuelFistsGiant", {
	Base = "DuelMain",
	Name = "GIANT Duel - Fist",
	Model = "models/weapons/w_pvp_ire.mdl",
	StorePrice = 800,
	WeaponClass = "weapon_giant_fist",
	WeaponName = "GIANT FISTS",
} )

RegisterItem( "Duel9mm", {
	Base = "DuelMain",
	Name = "Duel - 9mm",
	Model = "models/weapons/w_vir_9mm1.mdl",
	StorePrice = 200,
	WeaponClass = "weapon_9mm",
	WeaponName = "9mm",
} )

RegisterItem( "DuelDoubleBarrel", {
	Base = "DuelMain",
	Name = "Duel - Double Barrel",
	Model = "models/weapons/w_vir_doubleb.mdl",
	StorePrice = 250,
	WeaponClass = "weapon_doublebarrel",
	WeaponName = "Double Barrel",
} )

RegisterItem( "DuelFlak", {
	Base = "DuelMain",
	Name = "Duel - Flak Handgun",
	Model = "models/weapons/w_vir_flakhg.mdl",
	StorePrice = 800,
	WeaponClass = "weapon_flakhandgun",
	WeaponName = "Flak",
} )

RegisterItem( "DuelPlasma", {
	Base = "DuelMain",
	Name = "Duel - Plasma Autorifle",
	Model = "models/weapons/w_vir_par.mdl",
	StorePrice = 250,
	WeaponClass = "weapon_plasmaautorifle",
	WeaponName = "Plasma Autorifle",
} )

RegisterItem( "DuelRCP120", {
	Base = "DuelMain",
	Name = "Duel - RCP120",
	Model = "models/weapons/w_rcp120.mdl",
	StorePrice = 250,
	WeaponClass = "weapon_rcp120",
	WeaponName = "RCP120",
} )

RegisterItem( "DuelSciFi", {
	Base = "DuelMain",
	Name = "Duel - Sci-Fi Handgun",
	Model = "models/weapons/w_vir_scifihg.mdl",
	StorePrice = 250,
	WeaponClass = "weapon_scifihandgun",
	WeaponName = "Sci-Fi Handgun",
} )

RegisterItem( "DuelSilencers", {
	Base = "DuelMain",
	Name = "Duel - Dual Silencers",
	Model = "models/weapons/w_vir_dsilen.mdl",
	StorePrice = 200,
	WeaponClass = "weapon_silencers",
	WeaponName = "Dual Silencers",
} )

RegisterItem( "DuelSniperV", {
	Base = "DuelMain",
	Name = "Duel - Scope Enhanced Sniper Rifle",
	Model = "models/weapons/w_pvp_as50.mdl",
	StorePrice = 200,
	WeaponClass = "weapon_sniperrifle",
	WeaponName = "Scope Enhanced Sniper Rifle",
} )

RegisterItem( "DuelSonicShotgun", {
	Base = "DuelMain",
	Name = "Duel - Sonic Shotgun",
	Model = "models/weapons/w_vir_scattergun.mdl",
	StorePrice = 250,
	WeaponClass = "weapon_sonicshotgun",
	WeaponName = "Sonic Shotgun",
} )

RegisterItem( "DuelTommygun", {
	Base = "DuelMain",
	Name = "Duel - Tommygun",
	Model = "models/weapons/w_pvp_tom.mdl",
	StorePrice = 250,
	WeaponClass = "weapon_tommygun",
	WeaponName = "Tommygun",
} )