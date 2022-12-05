local files, folders = file.Find("gmodtower/gamemode/base/admin/powers/*", "LUA")

local powerlist = {}

for k, v in pairs(files) do
	powerlist[k] = v
end

for _, v in pairs( powerlist ) do

    local base = string.sub( GM.Folder, 11 )  .. "/gamemode/"

    local File = base .. "base/admin/powers/".. v

    include( File )

end