GM.Name     = "GMod Tower"
GM.Author   = "Deluxe Team & PixelTail Games"
GM.Website  = "https://www.gmtdeluxe.org/"
GM.WebsiteUrl  = "https://www.gmodtower.org/apps/" // TODO: Change to gmtdeluxe.org

co_color = Color( 50, 255, 50 )
co_color2 = Color( 255, 50, 50 )

// This breaks things????
--DeriveGamemode("base")

GMT = true
TestingMode = CreateConVar( "gmt_testing", 0, { FCVAR_ARCHIVE, FCVAR_DONTRECORD, FCVAR_REPLICATED }, "GMT testing mode" )
EmptyFunction = function() end

function GtowerPrecacheModel(Model)
	if !Model then return end

	if !util.IsValidModel(Model) then
		--print("GtowerPrecacheModel: Invalid Model!", Model)
		--debug.Trace()
		return
	end

	util.PrecacheModel(Model)
end

function GtowerPrecacheModelTable(Table)
	for k,v in pairs(Table) do
		GtowerPrecacheModel(v)
	end
end

function EmptyFunction() end

function GM:PhysgunPickup( ply, ent )

	local tbl = hook.GetTable().GTowerPhysgunPickup

	if ply:IsAdmin() && ent:IsPlayer() then
		return true
	end

	for _, v in pairs( tbl ) do
		local b, CantMove = SafeCall( v, ply, ent )
		if b && CantMove == false then
			return false
		end
	end

	return true
end

RegisterNWTablePlayer({
	{ "BAL", 0, NWTYPE_CHAR, REPL_PLAYERONLY },

	// inventory item uses, for the hud to work properly
	{ "UsesLeft", -1, NWTYPE_CHAR, REPL_PLAYERONLY },
	{ "MaxUses", -1, NWTYPE_CHAR, REPL_PLAYERONLY },
})


local PlayerModels = player_manager.AllValidModels()

PlayerModels["american_assault"] = nil
PlayerModels["german_assault"] = nil
PlayerModels["scientist"] = nil
PlayerModels["gina"] = nil
PlayerModels["magnusson"] = nil

GtowerPrecacheModelTable(PlayerModels)

HumanGibs = {
	"models/gibs/antlion_gib_medium_2.mdl",
	"models/gibs/Antlion_gib_Large_1.mdl",
	"models/gibs/Strider_Gib4.mdl",
	"models/gibs/HGIBS.mdl",
	"models/gibs/HGIBS_rib.mdl",
	"models/gibs/HGIBS_scapula.mdl",
	"models/gibs/HGIBS_spine.mdl"
}

GtowerPrecacheModelTable(HumanGibs)