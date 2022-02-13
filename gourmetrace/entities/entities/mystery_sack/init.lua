util.AddNetworkString("DoSpark")

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize()

	self:SetModel(self.Model)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )

	self:SetTrigger(true)

	self:DrawShadow(false)

end

local itemsNice = { // Nice names

	"weapon_boomerang", "A BOOMERANG",
	"weapon_frost", "FREEZY",
	"weapon_bomb", "A BOMB",
	"weapon_spike", "SPIKES",
	"warpstar", "THE WARPSTAR",

}

local items = { // Items you can always get

	"weapon_boomerang",
	"weapon_frost",
	"weapon_bomb",
	"weapon_spike",
	"warpstar"

}

local itemsFirst = { // Items you can get while in first

	"weapon_frost",
	"weapon_bomb",
	"weapon_spike"

}

function ENT:StartTouch(ply)

    if ply:IsPlayer() then
		local item = nil

		if GetFirst() == ply then
			item = table.Random(itemsFirst)
		else
			item = table.Random(items)
		end

		if ply:GetNet( "Powerup" ) == "" then
			ply:EmitSound( "gmodtower/gourmetrace/actions/sack_get.wav", 80 )

			net.Start("DoSpark")
				net.WriteEntity(self)
			net.Broadcast()

			net.Start("PowerupGet")
				net.WriteEntity(ply)
				net.WriteString(table.FindNext(itemsNice,item))
			net.Broadcast()

			ply:SetNet( "Powerup", item )

			self:SetTrigger(false)

			timer.Simple( self.RespawnTime,function()
				self:SetTrigger( true )
			end )
		end

		self:EmitSound(self.PickupSound,80, math.random(120,150))
    end

end

function GetFirst()

	local distances = {}

	for _,ent in pairs(ents.GetAll()) do
		if ent:GetClass() == "finish_flag" then

			for _,v in pairs(player.GetAll()) do
				if v:Team() == TEAM_FINISHED then return end
				table.insert(distances,(v:GetPos():Distance(ent:GetPos())))
				v.Dist = (v:GetPos():Distance(ent:GetPos()))
			end

		end
	end

	table.sort( distances, function(a,b) return a < b end )

	for k,ply in pairs(player.GetAll()) do
		if ply.Dist == distances[1] then
			return ply
		end
	end

end
