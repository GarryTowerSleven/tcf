---------------------------------
GM.Name     = "GMod Tower"
GM.Author   = "GTower Team"
GM.Email    = ""
GM.Website  = ""
GM.ContentPrefix = "../addons/gmodtower/"
GM.DownloadsEnabled = false

//=====================================================
function IsLobby()
	return ( engine.ActiveGamemode() == "gmtlobby" )
end

function IsHalloweenMap()
	return false
end

function IsChristmasMap()
	return false
end

function IsHolidayMap()
	return ( IsHalloweenMap() || IsChristmasMap() )
end

IsLobby = IsLobby()

if CLIENT then
	CreateConVar( "gmt_voice_enable", 1, { FCVAR_USERINFO, FCVAR_ARCHIVE } )
else
	hook.Add( "PlayerCanHearPlayersVoice", "Maximum Range", function( listener, talker )
		if !tobool(listener:GetInfoNum( "gmt_voice_enable", 1 )) then return false end
	end )
end

//=====================================================

GM.WebsiteUrl = "http://www.gmtower.org/apps/"

function GtowerAddResourceDirectory(Directory, Types)

	for k,v in pairs(file.Find(GM.ContentPrefix.."/"..Directory.."/*", "GAME")) do

		local File = Directory.."/"..v

		if v != "_svn" && v != ".svn" then

			if file.IsDir(GM.ContentPrefix.."/"..File) then
				GtowerAddResourceDirectory(File, Types)
			else
				local ext = string.GetExtensionFromFileName(v)

				if table.HasValue(Types, ext) then
					resource.AddFile(File)
				end
			end

		end

	end

end

if(SERVER && GM.DownloadsEnabled) then
	GtowerAddResourceDirectory("maps", {"bsp"})
	GtowerAddResourceDirectory("materials", {"vmt", "vtf"})
	GtowerAddResourceDirectory("models", {"mdl", "vtx", "phy", "vvd"})
	GtowerAddResourceDirectory("particles", {"pcf"})
	GtowerAddResourceDirectory("sound", {"wav", "mp3"})
end

function GtowerPrecacheModel(Model)
	if !Model then return end

	if !util.IsValidModel(Model) then
		--print("GtowerPrecacheModel: Invalid Model!", Model)
		--debug.Trace()
		return
	end

	util.PrecacheModel(Model)
end

function ents.FindByBase( base )

	local tbl = {}

	for _, ent in pairs( ents.GetAll() ) do

		if ent.Base == base then
			table.insert( tbl, ent )
		end

	end

	return tbl

end

function GtowerPrecacheModelTable(Table)
	for k,v in pairs(Table) do
		GtowerPrecacheModel(v)
	end
end

function GtowerPrecacheSound(Sound)
	if !Sound then return end
	if type(Sound) == "table" then
		GtowerPrecacheSoundTable(Sound)
		/*debug.Trace()
		ErrorNoHalt("Tried to precache a sound but it was a table")*/
	else
		util.PrecacheSound(Sound)
	end
end

function GtowerPrecacheSoundTable(Table)
	if type(Table) != "table" then
		debug.Trace()
		ErrorNoHalt("Tried to precache a sound table but it wasn't a table")
	end

	for k,v in pairs(Table) do
		GtowerPrecacheSound(v)
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