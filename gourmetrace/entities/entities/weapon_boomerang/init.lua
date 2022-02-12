AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:CustomInit()

	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:EnableGravity(false)
		phys:SetVelocity(self.Owner:GetForward()*750)
		self:SetLocalAngularVelocity( Angle(1200,0,0) )
	end

	self:SetPos(self:GetPos() + Vector(0,0,20))
	self:SetAngles(self:GetAngles() + Angle(0,180,0))

	self:SetVelocity(Vector(200,0,0))

	timer.Simple( 2,function()
		if IsValid( self ) then
			self:SetTrigger( false )
			self:SetModelScale( 0, 0.25 )
			timer.Simple( 0.25, function()
				self:Remove()
			end )
		end
	end )

end

function ENT:CustomTouch( ply )

	ply:SetVelocity(Vector(0,0,255))
	self:SetTrigger(false)
	self:SetModelScale(0,0.25)
	self.ExpireTime = CurTime() + 0.25

end
