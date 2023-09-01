AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

ENT.PointValue = 0

function ENT:Initialize()
	if !self.PointValue || self.PointValue == 0 then
		self.PointValue = 1
	end

	if self.PointValue == 5 then
		self:SetModel(self.ModelExtra)
	else
		self:SetModel(self.Model)
	end

	self.Entity:SetSolid(SOLID_BBOX)

	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self.Entity:SetCollisionBounds( Vector( -25, -25, -25 ), Vector( 25, 25, 30 )  )
	self.Entity:SetTrigger( true )
	local phys = self.Entity:GetPhysicsObject()
	if(phys and phys:IsValid()) then
		phys:EnableMotion(false)
	end
end

function ENT:Touch(ent)
	if ent:GetClass() != "player_ball" || ent:GetOwner():GetNWBool("FoundSecret") then return end

	ent:GetOwner():SetNWBool("FoundSecret",true)

	ent:GetOwner():AddFrags(self.PointValue)

	ent:GetOwner():EmitSound( self.EatSound )
	local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() + Vector( 0, 0, 20 ) )
	util.Effect( "bananaeatsecret", effectdata, true, true )

	GAMEMODE:ColorNotifyAll( string.SafeChatName(ent:GetOwner():Name()).." has found the secret banana!" )

	local ply = ent:GetOwner()

	if game.GetMap() == "gmt_ballracer_facile02" then
		ply:AddAchievement( ACHIEVEMENTS.BRSECRETFACILE, 1 )
	elseif game.GetMap() == "gmt_ballracer_grassworld01" then
		ply:AddAchievement( ACHIEVEMENTS.BRSECRETGRASSWORLD, 1 )
	elseif game.GetMap() == "gmt_ballracer_iceworld03" then
		ply:AddAchievement( ACHIEVEMENTS.BRSECRETICEWORLD, 1 )
	elseif game.GetMap() == "gmt_ballracer_khromidro02" then
		ply:AddAchievement( ACHIEVEMENTS.BRSECRETKHROMIDRO, 1 )
	elseif game.GetMap() == "gmt_ballracer_memories02" then
		ply:AddAchievement( ACHIEVEMENTS.BRSECRETMEMORIES, 1 )
	elseif game.GetMap() == "gmt_ballracer_metalworld" then
		ply:AddAchievement( ACHIEVEMENTS.BRSECRETMETALWORLD, 1 )
	elseif game.GetMap() == "gmt_ballracer_midori02" then
		ply:AddAchievement( ACHIEVEMENTS.BRSECRETMIDORI, 1 )
	elseif game.GetMap() == "gmt_ballracer_nightball" then
		ply:AddAchievement( ACHIEVEMENTS.BRSECRETNIGHTWORLD, 1 )
	elseif game.GetMap() == "gmt_ballracer_paradise03" then
		ply:AddAchievement( ACHIEVEMENTS.BRSECRETPARADISE, 1 )
	elseif game.GetMap() == "gmt_ballracer_prism03" then
		ply:AddAchievement( ACHIEVEMENTS.BRSECRETPRISM, 1 )
	elseif game.GetMap() == "gmt_ballracer_sandworld02" then
		ply:AddAchievement( ACHIEVEMENTS.BRSECRETSANDWORLD, 1 )
	elseif game.GetMap() == "gmt_ballracer_skyworld01" then
		ply:AddAchievement( ACHIEVEMENTS.BRSECRETSKYWORLD, 1 )
	elseif game.GetMap() == "gmt_ballracer_spaceworld01" then
		ply:AddAchievement( ACHIEVEMENTS.BRSECRETSPACEWORLD, 1 )
	elseif game.GetMap() == "gmt_ballracer_summit" then
		ply:AddAchievement( ACHIEVEMENTS.BRSECRETSUMMIT, 1 )
	elseif game.GetMap() == "gmt_ballracer_waterworld02" then
		ply:AddAchievement( ACHIEVEMENTS.BRSECRETWATERWORLD, 1 )
	elseif game.GetMap() == "gmt_ballracer_flyinhigh01" then
		ply:AddAchievement( ACHIEVEMENTS.BRSECRETFLYINHIGH, 1 )
	elseif game.GetMap() == "gmt_ballracer_neonlights01" then
		ply:AddAchievement( ACHIEVEMENTS.BRSECRETNEONLIGHTS, 1 )
	elseif game.GetMap() == "gmt_ballracer_tranquil01" then
		ply:AddAchievement( ACHIEVEMENTS.BRSECRETTRANQUIL, 1 )
	end

end

function ENT:KeyValue(key, value)
	if key == "points" then
		self.PointValue = tonumber(value)
	end
end