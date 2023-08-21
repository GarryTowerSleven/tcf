
include('shared.lua')
include("cl_admin.lua")

hook.Add("GTowerStoreLoad", "AddHats", function()
	for _, v in pairs( GTowerHats.Hats ) do

		if v.unique_Name then

			local NewItem = {}

			NewItem.storeid = v.storeid || GTowerHats.StoreId
			NewItem.Name = v.Name
			NewItem.description = v.description
			NewItem.prices = { v.price }
			NewItem.unique_Name = v.unique_Name
			NewItem.model = v.model
			NewItem.drawmodel = true
			NewItem.ModelSkin = v.ModelSkin

			GTowerStore:SQLInsert( NewItem )

		end

	end
end )

/*
local hatReqQueue = {}
local hatReqDelay = 0.5
local hatReqTime = 0
local hatReqMax = 15

local function RequestHats( requests )
	if !requests || #requests > hatReqMax || CurTime() < hatReqTime then return end

	// compress table to send
	//local compressed = util.TableToJSON(requests, false)
	//compressed = util.Compress(compressed)

	//if #compressed >= 65532 then
	//	MsgC(color_red, "[Hats] REQUEST TABLE TOO LARGE, " .. #compressed .. " CHARACTERS\n")
	//	return 
	//end

	net.Start( "clientHatRequest" )
		//net.WriteData( compressed )
		net.WriteTable( requests )
	net.SendToServer()
end

local function CheckHatQueue()
	if !hatReqQueue || table.Count(hatReqQueue) < 1 then return end
	if CurTime() < hatReqTime then return end

	local tosend = {}
	for i=1, math.Clamp( #hatReqQueue, 1, hatReqMax ) do
		table.insert( tosend, hatReqQueue[i] )
		table.RemoveByValue( hatReqQueue, hatReqQueue[i] )
	end

	//RequestHats( tosend )
end

hook.Add( "Think", "HatQueueThink", CheckHatQueue )

function GTowerHats:RequestTranslation( hat, model )

	if !table.HasValue( hatReqQueue, { model, hat } ) then
		table.insert( hatReqQueue, { model, hat } )
		// give a window of time before sending the request so others can populate
		hatReqTime = CurTime() + hatReqDelay
	end 

end
*/

local HatTable = {}
function GTowerHats:AddOffset( hat, model, data )
	if !HatAdmin.ValuesList[1] && HatTable[model] && HatTable[model][hat] then return end

	if !HatTable[model] then
		HatTable[model] = {}
	end

	HatTable[model][hat] = data

	if !HatAdmin.ValuesList[1] then return end
	HatAdmin.ValuesList[1]:SetValue(data[1].z)
	HatAdmin.ValuesList[2]:SetValue(data[1].y)
	HatAdmin.ValuesList[3]:SetValue(data[1].x)
	HatAdmin.ValuesList[4]:SetValue(data[2].p)
	HatAdmin.ValuesList[5]:SetValue(data[2].y)
	HatAdmin.ValuesList[6]:SetValue(data[2].r)
	HatAdmin.ValuesList[7]:SetValue(data[3])
end

net.Receive("hat_snd", function()
	local hat = net.ReadString()
	local model = net.ReadString()

	local pos = net.ReadVector()
	local ang = net.ReadAngle()
	local scale = net.ReadFloat()

	local data = { pos, ang, scale }

	GTowerHats:AddOffset( hat, model, data )
end )

function GTowerHats:RequestOffset( hat, model, skip )
	if !skip and HatTable && HatTable[model] && HatTable[model][hat] then return end

	net.Start("hat_req")
		net.WriteString(hat)
		net.WriteString(model)
		net.WriteBool(IsValid(HatAdmin.ValuesList[1]))
	net.SendToServer()
end

concommand.Add( "gmt_gethat", function( ply, cmd, args )
	if !args[1] || !args[2] then return end
	print(args[1], args[2])

	GTowerHats:RequestOffset( args[1], args[2], true )
end )

concommand.Add( "gmt_listhat", function( ply, cmd, args )
	if !args[1] || !args[2] then return end

	if HatTable && HatTable[args[2]] && HatTable[args[2]][args[1]] then
		local offset = HatTable[args[2]][args[1]]
		//print("X: " .. offset[1].x)
		//print("Y: " .. offset[1].y)
		//print("Z: " .. offset[1].z)
		//print("P: " .. offset[2].p)
		//print("Y: " .. offset[2].y)
		//print("R: " .. offset[2].r)
		//print("S: " .. offset[3])
		PrintTable({ offset[1].x, offset[1].y, offset[1].z, offset[2].p, offset[2].y, offset[2].r, offset[3] })
	end
end )

concommand.Add( "gmt_listoffsets", function( ply, cmd, args )
	PrintTable(HatTable)
end )

// these hats are stupid and dumb
GTowerHats.FixScales = {
	["3dglasseshat"] = true,
	["hathairafro"] = true,
	["androssmaskhat"] = true,
	["aviatorhat"] = true,
	["bomermanhat"] = true,
	["hatdrinkhat"] = true,
	["hatheadcrab"] = true,
	["hatkfcbucket"] = true,
	["kingboocrown"] = true,
	["hatkleinerglass"] = true,
	["legoheadhat"] = true,
	["samushat"] = true,
	["snowgoggles"] = true,
	["hatsombrero"] = true,
	["starglasseshat"] = true,
	["hatwitchhat"] = true,
}

function GTowerHats:GetTranslation( hat, model )
	GTowerHats:RequestOffset( hat, model )

	if HatTable && (!HatTable[model] || !HatTable[model][hat]) then
		model = "normal"
		GTowerHats:RequestOffset( hat, model )
	end

	if HatTable && HatTable[model] && HatTable[model][hat] then
		local offset = HatTable[model][hat]

		local t = { Vector(offset[1].z, offset[1].y, offset[1].x), Angle(offset[2].p, offset[2].y, offset[2].r), offset[3] }

		return t
	end

	return GTowerHats.DefaultValue
end

// command for stress testing hat requests, arg1 is for amount of requests
concommand.Add( "hat_stress", function( ply, cmd, args )
	local am = args[1] or 25

	//local hatCount = #GTowerHats.Hats
	//local plyCount = #GTowerModels.Models

	for i=1, am do
		local randHat = table.Random(GTowerHats.Hats).unique_Name
		while !randHat do
			randHat = table.Random(GTowerHats.Hats).unique_Name
		end
		local _, randPly = table.Random(GTowerModels.Models)
		while !randPly do
			_, randPly = table.Random(GTowerModels.Models)
		end

		GTowerHats:RequestOffset( randHat, randPly )
	end
end )