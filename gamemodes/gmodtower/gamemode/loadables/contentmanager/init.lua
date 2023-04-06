
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include( "shared.lua" )

module( "contentmanager", package.seeall )

// precache these so clients can test
local modelsToCheck = {
	{ "CSS", {"models/props/de_cbble/cb_doorarch32.mdl","models/props/de_prodigy/ammo_can_03.mdl"} },
	{ "TF2", {"models/props_trainyard/beer_keg001.mdl","models/props_manor/banner_01.mdl"} },

	{ "GMTBase", {"models/gmt_money/fifty.mdl","models/gmod_tower/plant/largebush01.mdl"} },
	{ "GMTLobby", {"models/func_touchpanel/terminal04.mdl","models/gmod_tower/propper/bar_elev.mdl"} },
	{ "GMTLobby2", {"models/sunabouzu/elevator_roof.mdl","models/map_detail/appearance_stand.mdl"} },
	{ "GMTMinigolf", {"models/props/gmt_minigolf_moon/light_sphere.mdl","models/gmod_tower/golftriangleflag.mdl"} },
	{ "GMTPVPBattle", {"models/gmod_tower/future_doorframe.mdl","models/weapons/v_pvp_ire.mdl"} },
	{ "GMTKarts", {"models/gmt_turnright.mdl","models/gmod_tower/sourcekarts/flux.mdl"} },
	{ "GMTChimera", {"models/uch/mghost.mdl","models/uch/pigmask.mdl"} },
	{ "GMTVirus", {"models/gmod_tower/facility/gmt_facilitydoor.mdl","models/weapons/v_vir_snp.mdl"} },
	{ "GMTZombie", {"models/weapons/w_flamethro.mdl","models/zom/dog.mdl"} },
	{ "GMTBallrace", {"models/gmod_tower/ballcrate.mdl","models/props_memories/memories_levelend.mdl"} },
}

for k,v in pairs(modelsToCheck) do
	for j,c in pairs( v[2] ) do
		util.PrecacheModel(c)
	end
end