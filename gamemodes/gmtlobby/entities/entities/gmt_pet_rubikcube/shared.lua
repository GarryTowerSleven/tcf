if !Pets then
	SQLLog( 'error', "Pets module not loaded, pet entity will not load!\n" )
	return
end

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName		= "Rubiks Cube Pet"
ENT.Author			= "GMT Krew~"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Model			= "models/gmod_tower/rubikscube.mdl"

util.PrecacheModel( ENT.Model )

function ENT:SetupDataTables()
	self:NetworkVar( "String", 0, "PetName" )
	self:NetworkVar( "Int", 0, "EmotionID" )
end

Pets.Register(
	// pet name
	"rubik",

	// strings
	{
		Wink = {
			"Twist my sides~",
			"You're scrambling me!",
			"Only you can solve me.",
			"You complete me.",
			"Let's rub stickers~",
			"I only date solved cubes."
		},

		Bored = {
			"*unsolves itself*",
		},
	}
)
