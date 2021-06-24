---------------------------------
ENT.Type 			= "anim"

ENT.Model			= Model(  "models/gmod_tower/casino/spinner_base.mdl" )
ENT.ModelSpinner	= Model(  "models/gmod_tower/casino/halloween_spinner.mdl" )
ENT.ModelPaddle		= Model(  "models/gmod_tower/casino/spinner_paddle.mdl" )

ENT.SoundClicker1	= Sound( "misc/halloween/spelltick_01.wav" )
ENT.SoundClicker2	= Sound( "misc/halloween/spelltick_02.wav" )
ENT.SoundSet	= Sound( "misc/halloween/spelltick_set.wav" )

ENT.LoseSound = Sound("ui/halloween_boss_chosen_it.wav")

ENT.Cost = 100
ENT.NumNotches = 16
ENT.PaddleLength = 6.5
ENT.NotchSize = math.deg( (2*math.pi) ) / ENT.NumNotches
ENT.SpinDuration = 5
ENT.ExtraSettleTime = 20
ENT.SPIN = {
	IDLE = 0,
	STARTING = 4,
	SLOWING = 2,
}

ENT.OddsEqualize = 10 --Increase uniformity in odds calculations

ENT.SLOTS = {

	--{<name>, <odds>}
	--odds: how many re-rolls it takes to land on this item
	{"Absolutely Nothing", 5},
	{"Lose 100 GMC", 9},
	{"Random Pumpkin", 12, {
		"hwpumpkin1",
		"hwpumpkin2",
		"hwpumpkin3",
		"hwpumpkin4"
	} },
	{"Flamin' Skulls", 15, "gmt_skulls"},
	{"Spider Player Model", 16, "HalloweenSpider"},
	{"Flask Potion", 6, "flaskpotion"},
	{"Zombie Cutout", 8, "cardboardzombie"},
	{"Lose 500 GMC", 10},
	{"10 Candy Buckets", 11},
	{"Batter", 18, "gmt_bat"},
	{"Golden Cleaver", 14, "gmt_cleaver"},
	{"Coffin", 7, "coffin"},
	{"Horseless Headless Horsemann", 17, "mdl_hatman"},
	{"Scarecrow", 6, "scarecrow"},
	{"Spookboy", 4, "spookboyplush"},
	{"Lose 666 GMC", 13},
}

ENT.GMCPayouts = {
	[2] = -100,
	[8] = -500,
	[16] = -666
}

function ENT:SetupDataTables()

	self:NetworkVar( "Float", 0, "SpinTime" )
	self:NetworkVar( "Int", 0, "State" )
	self:NetworkVar( "Int", 1, "Target" )
	self:NetworkVar( "Entity", 1, "User" )

end

function ENT:CanUse( ply )

	if IsValid( ply._Spinning ) then return false end
	if self:GetState() == self.SPIN.IDLE then
		return true, "SPIN"
	end

end
