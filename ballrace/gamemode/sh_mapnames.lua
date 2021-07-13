NiceMapNames={}

NiceMapNames["gmt_ballracer_grassworld01"] = "Grass World";
NiceMapNames["gmt_ballracer_iceworld03"] = "Ice World";
NiceMapNames["gmt_ballracer_khromidro02"] = "Khromidro";
NiceMapNames["gmt_ballracer_memories02"] = "Memories";
NiceMapNames["gmt_ballracer_midori"] = "Midori";
NiceMapNames["gmt_ballracer_paradise03"] = "Paradise";
NiceMapNames["gmt_ballracer_sandworld02"] = "Sand World";
NiceMapNames["gmt_ballracer_skyworld01"] = "Sky World";

function GetNiceMapName(map)
	local map = map or game.GetMap();
	if NiceMapNames[map] then
		return NiceMapNames[map]
	else
		return map
	end
end