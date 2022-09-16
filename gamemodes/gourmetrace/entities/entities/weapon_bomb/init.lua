AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:CustomInit()

	self:SetPos( self:GetPos() + Vector(0,0,5) )
	self:SetAngles( self:GetAngles() + Angle(0,180,0) )

end

function ENT:CustomTouch( ply )

	ply:SetVelocity(Vector(-1250,0,280))
	self:SetTrigger(false)
	self:SetModelScale(0,0.25)

	local explode = ents.Create( "env_explosion" )
	explode:SetPos( self:GetPos() )
	explode:Spawn()
	explode:SetKeyValue( "iMagnitude", "0" )
	explode:Fire( "Explode", 0, 0 )
	--explode:EmitSound( "weapon_AWP.Single", 400, 400 )
	self.ExpireTime = CurTime() + 0.25

end
