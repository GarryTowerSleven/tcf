AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("zm_shock")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:DrawShadow(false)

	self.Combo = 0
	self.ComboEnts = {}
end

function ENT:SetShocker(ply)
	self.Shocker = ply
	self:SetParent(ply)
end

function ENT:Think()
	for k,v in ipairs(ents.FindInSphere(self:GetPos(),self.Radius)) do
		if string.StartWith( v:GetClass(), "zm_npc_" ) then
			v:TakeDamage( 25, self.Shocker )

			net.Start("zm_shock")
				net.WriteEntity(self)
				net.WriteEntity(self.Shocker)
				net.WriteEntity(v)
			net.Broadcast()

			if !table.HasValue(self.ComboEnts, v) then
				table.insert(self.ComboEnts, v)
				self.Combo = self.Combo + 1

				if self.Combo == 15 then
					self.Shocker:AddAchievement(ACHIEVEMENTS.ZMTESLA, 1)
				end
			end

		end
	end

	self:NextThink( CurTime() + 0.5 )
	return true
end
