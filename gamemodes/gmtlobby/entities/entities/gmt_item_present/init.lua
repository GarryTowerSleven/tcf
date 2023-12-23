AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel( "models/gmod_tower/present2.mdl" )
	self:PhysicsInit(SOLID_BBOX)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
	self:SetUseType(SIMPLE_USE)
end

function ENT:Use(ply, caller)

	SafeCall( self.GivePresent, self, ply )

end

function ENT:TimedPickup(bool)

	self.Timed = bool

end

local items = {}

hook.Add( "LoadInventory", "Presents", function()

	items = {
		// Common
		{
			{
				ITEMS.alcohol_bottle,
				ITEMS.ingredient_bone,
				ITEMS.ingredient_orange,
				ITEMS.ingredient_banana,
				ITEMS.ingredient_apple,
				ITEMS.ingredient_glass,
				ITEMS.ingredient_straw,
				ITEMS.ingredient_watermel
			},
			4,
			true
		},

		// Uncommon
		{
			{
				ITEMS.snowman,
				ITEMS.usdollar,
				ITEMS.tv,
				ITEMS.trampoline,
				ITEMS.toyspider,
				ITEMS.stocking,
				ITEMS.sack_plushie,
				ITEMS.plush_blahaj,
				ITEMS.plush_fox,
				ITEMS.plush_penguin,
				ITEMS.obama_cutout,
				ITEMS.mysterycatsack,
				ITEMS.towertoy
			},
			15,
			false,
			30
		},

		// Rare
		{
			{
				ITEMS.autopiano,
				ITEMS.tv,
				ITEMS.wepon_357,
				ITEMS.workingclock,
				ITEMS.toytrain_small
			},
			50,
			true
		},

		// Extraordinarily Rare
		{
			{
				ITEMS.nesguitar,
				ITEMS.piano,
				ITEMS.tv_large,
				ITEMS.toytrain
			},
			100,
			true
		},

		// What?!
		{
			{
				ITEMS.imac
			},
			500,
			true
		},

		// Obama Tier!!
		{
			{
				ITEMS.obama_visualizer,
			},
			10000,
			true
		}
	}

end )

table.SortByMember( items, 2, false )

function getItem(ply)

	local item

		for try = 1, 512 do

			if !item then
	
				for _, i in ipairs( items ) do

					if item then continue end

					local roll = math.Round( util.SharedRandom( SysTime() + try * 0.01, 1, i[2] * ( 10 + ( i[3] && 0 || ply:GetRarity() + Lerp( ply:GetRarity(), -8, 0 ) ) ) ) )

					if roll >= i[2] * 10 then 	// && roll2 == i[2] then
			
						item = i[1]
	
						if istable( item ) then
	
							item = item[ math.Round( util.SharedRandom( SysTime() + #item + try * 0.01, 1, #item ) ) ]
	
						end

						ply:SetRarity( ply:GetRarity() - ( i[4] || i[2] ) * 0.01 )
			
					end
			
				end
	
			end
	
		end

		if !item then

			item = items[ math.random( #items, #items - 1 ) ][1]

			if istable( item ) then

				item = table.Random( item )

			end

		end

		return item

	

end

// for gmt devs who are addicted to rigging
concommand.Add( "SpinSlots", function( ply )

	if IsValid( ply ) then return end

	local rarity = 1

	print("-- RUNNING SIMULATION --")
	print("Presents: 10")
	print("Rarity: " .. rarity * 100 .. "%")

	local items = {}
	local loss = 0

	for i = 1, 10 do
		timer.Simple(i * 0.01, function()
			local item = getItem(
				{
					GetRarity = function() return rarity end,
					SetRarity = function(self, a) loss = rarity - a rarity = math.Clamp(a, 0, 1) end
				}
			)

			table.insert(items, {
				item, rarity, loss
			})

			if i == 10 then

				print("-- RESULTS --")

				for _, i in ipairs(items) do
					
					local name = GTowerItems:Get(i[1]).Name
					print(name .. " : " .. i[2] * 100 .. "% (Lost " .. i[3] * 100 .. "% rarity!)")

				end

				print("-- PROFIT --")

				local gmc = 0

				for _, i in ipairs(items) do
					
					local item = GTowerItems:Get(i[1])
					if !item.StorePrice then continue end
					gmc = gmc + math.floor( item.StorePrice / 2 )

				end

				print("-- " .. gmc .. "GMC --")

			end
		end)
	end
	

end )

function ENT:GivePresent(ply)

	if !IsValid(ply) or !ply:IsPlayer() then return end

	if self.Timed then
		if NextPresent[ply:SteamID()] and NextPresent[ply:SteamID()] > CurTime() then
			ply:Msg2("You have taken a present already. Wait " .. math.ceil(NextPresent[ply:SteamID()] - CurTime()) .. " seconds")
			return
		else
			NextPresent[ply:SteamID()] = CurTime() + 600
		end
	end

  	self:EmitSoundInLocation( self.SoundOpen, 80, math.random(80,125) )

	local function giveItem(item)
		local itemID = GTowerItems:Get(item)

		if !item || !itemID || !GTowerItems:NewItemSlot(ply):Allow(itemID, true) then
			ply:AddMoney(math.random(64, 256), nil, nil, nil, "Present")
			return
		end

		ply:InvGiveItem(item)
		ply:Msg2(table.Random({"Wow!", "Huh?!", "Wait..."}) .. " You " .. table.Random({"unwrapped", "opened", "unboxed"}) .. " a " .. itemID.Name .. "!")
	end

	math.randomseed(os.time())

	local item = getItem( ply )

	if item then

		giveItem( item )

	end

	self:Remove()

end
