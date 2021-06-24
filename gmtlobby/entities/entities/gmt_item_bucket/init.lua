AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_BBOX)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
	self:SetUseType(SIMPLE_USE)
	self.Timed = true
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
end

function ENT:Use(ply, caller)

	SafeCall( self.GivePresent, self, ply )

end

function ENT:TimedPickup(bool)

	self.Timed = bool

end

function ENT:GivePresent(ply)

	if !IsValid(ply) or !ply:IsPlayer() then return end

	if !IsValid(ply:GetActiveWeapon()) || ply:GetActiveWeapon():GetClass() != "gmt_tracker" then return end

	if self.Timed then
		if ply.NextBucket and ply.NextBucket > CurTime() then
			--ply:Msg2("You have taken a candy bucket already. Wait " .. math.ceil(ply.NextBucket - CurTime()) .. " seconds")
			return
		else
			ply.NextBucket = CurTime() + 5
			ply:SetNWFloat( "NextBucket", CurTime() + 5 )
		end
	end

  self:EmitSound( self.SoundOpen, 80, math.random(80,125) )
	self:EmitSound( self.SoundCollect, 90, 100 )

	ply.Candy = (ply.Candy or 0) + 1
	ply:SetNWInt( "Candy", ply.Candy )

	ply:AddAchivement( ACHIVEMENTS.HALLOWEENBUCKET, 1 )

	if #ents.FindByClass("gmt_item_bucket") == 1 then
		for k,v in pairs(player.GetAll()) do
			v:SendLua([[GTowerChat.Chat:AddText("All candy buckets have been collected.", Color(255, 140, 0, 255))]])
		end
	end

	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetOrigin( vPoint )
	util.Effect( "sweetspickup", effectdata, true, true )

	self:Remove()
end
