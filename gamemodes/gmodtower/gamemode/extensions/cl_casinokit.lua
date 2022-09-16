if !IsLobby then return end

CasinoKit = {}
    
local folder = "casinokit/res"

local loaded = {}
local loading = {}
local function LoadUrl(url, cb, smooth)
	if loaded[url] then
		if cb then cb(loaded[url]) end
		return loaded[url]
	end

	local png_opts = {"noclamp", "mips"}
	if smooth then table.insert(png_opts, "smooth") end
	png_opts = table.concat(png_opts, " ")

	local path = folder .. "/" .. string.format("%08x", util.CRC(url)) .. ".png"
	file.CreateDir(folder)

	if file.Exists(path, "DATA") then
		loaded[url] = Material("../data/" .. path, png_opts)
		if cb then cb(loaded[url]) end
		return loaded[url]
	end

	if loading[url] then
		return
	end

	loading[url] = true
	http.Fetch(url, function(data)
		file.Write(path, data)
		loaded[url] = Material("../data/" .. path, png_opts)
		if cb then cb(loaded[url]) end
	end)
end

-- Materials fetched during lua init don't load properly

local q = {}
CasinoKit.getRemoteMaterial = function(url, cb, smooth)
	table.insert(q, {url, cb, smooth})
end

hook.Add("HUDPaint", "CasinoKit_DeferredRemoteMatFetcher", function()
	CasinoKit.getRemoteMaterial = LoadUrl
	for k,v in pairs(q) do
		CasinoKit.getRemoteMaterial(v[1], v[2], v[3])
	end
	q = nil
	hook.Remove("HUDPaint", "CasinoKit_DeferredRemoteMatFetcher")
end)