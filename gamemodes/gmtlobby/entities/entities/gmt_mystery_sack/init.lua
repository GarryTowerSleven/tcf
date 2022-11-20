
----------------------------------------------------------

util.AddNetworkString("DoSpark")

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)

	self:SetTrigger(true)

	self:DrawShadow(false)

end

function ENT:Use(ply)
	if self.NO then return end

	if ply:IsPlayer() then
			ply:EmitSound("gmodtower/gourmetrace/actions/sack_get.wav",50)
			net.Start("DoSpark")
				net.WriteEntity(self)
			net.Broadcast()
			self.NO = true
			timer.Simple(self.RespawnTime,function()
				if IsValid(self) then
					self.NO = false
				end
			end)
		self:EmitSound(self.PickupSound,80, math.random(120,150))
	end
end
