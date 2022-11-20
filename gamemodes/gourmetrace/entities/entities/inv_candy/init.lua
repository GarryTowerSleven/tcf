
----------------------------------------------------------

util.AddNetworkString("FoodAlpha")

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

sound.Add( {
	name = "Invincibility",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 100,
	pitch = 100,
	sound = "gmodtower/gourmetrace/music/invincibility.wav"
} )

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_BBOX)
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
			timer.Simple(16,function()
				self:SetTrigger(true)
			end)
      self:EmitSound(self.PickupSound,80, math.random(100,110))
			GAMEMODE:SetMusic( MUSIC_NONE, ply)
			ply:SetNWInt("Points",ply:GetNWInt("Points") + self.Points)
			net.Start("FoodAlpha")
			net.WriteEntity(self)
			net.Broadcast()

			ply:SetNWBool("Invincible",true)
			ply:EmitSound("Invincibility")

			ply:AddAchievement(ACHIEVEMENTS.GRUNTOUCHABLE,1)

			timer.Create("FlashyShit"..ply:EntIndex(),0.1,160,function()
				if IsValid(ply) and ply:GetNWBool("Invincible") then
					if ply:GetMaterial() == "models/props/surf_lt_unicorn/pure_white_nocull" then
						ply:SetMaterial("",true)
					else
						ply:SetMaterial("models/props/surf_lt_unicorn/pure_white_nocull",true)
						local vPoint = ply:GetPos() + Vector(0,0,25)
						local effectdata = EffectData()
						effectdata:SetOrigin( vPoint )
						util.Effect( "stars", effectdata )
					end
				end
			end)

			timer.Simple(16,function()
				if IsValid(ply) and ply:GetNWBool("Invincible") then
					ply:SetNWBool("Invincible",false)
					ply:StopSound("Invincibility")
					ply:SetMaterial("",true)
				end
			end)

    end
end
