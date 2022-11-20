
----------------------------------------------------------

util.AddNetworkString("FoodAlpha")

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
  self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )

	self:SetModelScale(self.FoodScale,0)

	self:SetTrigger(true)

	self:DrawShadow(false)

end

function ENT:StartTouch(ply)
    if ply:IsPlayer() then
			local vPoint = self:GetPos()
			local effectdata = EffectData()
			effectdata:SetOrigin( vPoint )
			util.Effect( "food_eat", effectdata, true, true )
      self:SetTrigger(false)
			timer.Simple(5,function()
				self:SetTrigger(true)
			end)
      self:EmitSound(self.PickupSound,80, math.random(100,110))
			ply:SetNWInt("Points",ply:GetNWInt("Points") + self.Points)
			net.Start("FoodAlpha")
			net.WriteEntity(self)
			net.Broadcast()
    end
end
