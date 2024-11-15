---------------------------------
ENT.Type 			= "anim"

ENT.Model			= Model(  "models/gmod_tower/casino/spinner_base.mdl" )
ENT.ModelSpinner	= Model(  "models/gmod_tower/casino/spinner_wheel.mdl" )
ENT.ModelPaddle		= Model(  "models/gmod_tower/casino/spinner_paddle.mdl" )

ENT.SoundClicker	= Sound( "GModTower/casino/spinner_click.wav" )

ENT.Cost = 100
ENT.NumNotches = 16
ENT.PaddleLength = 6.5
ENT.NotchSize = math.deg( (2*math.pi) ) / ENT.NumNotches
ENT.SpinDuration = 10
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

	{"Absolutely Nothing", 4},
	{"StarFox Trophy", 5000, "trophy_starfox"},
	{"Slappers", 750, "slappers"},
	{"iMac", 499, "imac"},
	{"1 GMC", 10},
	--{"Playable Piano", 18, "instrument_piano"},
	{"Playable Piano", 499, "piano"},
	{"500 GMC", 10},
	{"Sunabouzu Shrine", 2500, "sunshrine"},
	{"Hula Doll", 4, "huladoll"},
	{"Rave Ball", 599, "rave_ball"},
	{"1500 GMC", 50},
	{"Five Catsacks", 7, "mysterycatsack", 5},
	{"100 GMC", 3},
	{"Random Holiday Item", 99, {
		"sack_plushie",
		"snowman",
		"candycane",
		"stocking",
		"christmastree",
		"christmastreesimple",
		"turkeydinnerthanks",
		"scarytoyhouse",
		"gravestone",
		"candybucket",
		"cauldron",
		"toyspider",
		"toytraincart"
	} },
	{"Fireworks", 2, {
		"fwork_blossom",
		"fwork_fountain",
		"fwork_multi",
		"fwork_palm",
		"fwork_ring",
		"fwork_rocket",
		"fwork_spinner",
		"fwork_spinrocket",
		"fwork_wine",
		"fwork_screamer",
		"fwork_ufo",
		"fwork_firefly"
	} },
	{"Backpack", 40, "backpack"},
}

ENT.GMCPayouts = {
	[5] = 1,
	[7] = 500,
	[11] = 1500,
	[13] = 100,
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
