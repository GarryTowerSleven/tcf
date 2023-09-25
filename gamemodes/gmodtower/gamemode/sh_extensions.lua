---------------------------------
local ExtensionList = {}

local DeletedExtensions = {
	["furryfinder.lua"] = true
}

local files, folders = file.Find("gmodtower/gamemode/extensions/*", "LUA")

MsgC( color_green, "\n[Extensions] Loading Extensions...\n")

for k, v in pairs(files) do
	if DeletedExtensions[v] then continue end
	ExtensionList[k] = v

	//MsgC( color_green, "[Extensions] Loaded: " .. v .. " \n")
	MsgC( color_green, "Loading: " .. v .. "\n")
end

MsgC( color_green, "\n")

local function LoadExtensions( base )

	for _, v in pairs( ExtensionList ) do

		local Prefix = string.sub( v, 0, 3 )
		local IsServer = Prefix == "sv_"
		local IsClient = Prefix == "cl_"
		local Both = IsServer == false && IsClient == false
		local File = base .. "extensions/".. v

		if SERVER && (IsClient || Both) then
			AddCSLuaFile( File )
		end

		if Both || (SERVER && IsServer) || (CLIENT && IsClient) then
			include( File )
		end

	end

end

//Load it now, empty folder, since it is relative
LoadExtensions( "" )

function ReloadExtensions()
	//Load it relative to the lua base folder
	LoadExtensions( string.sub( GM.Folder, 11 )  .. "/gamemode/" )
end

if SERVER then
	concommand.Add("gmt_reloadexts", function( ply )

		if !ply:IsAdmin() then
			return
		end

		if game.SinglePlayer() || !game.IsDedicated() then
			ply:SendLua("ReloadExtensions()")
		end

		ReloadExtensions()

	end )
end
