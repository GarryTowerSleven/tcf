---------------------------------
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize()

	if !self.Owner then return end

	self.SoundCount = 0

	local owner = self.Owner

	self:SetModel("models/player/items/all_class/pet_robro.mdl")
	self:SetMoveType(MOVETYPE_NONE)

	self:DrawShadow(false)

	if IsValid( owner ) then
		local BoneIndx = owner:LookupBone("ValveBiped.Bip01_Head1")
		local BonePos, BoneAng = owner:GetBonePosition( BoneIndx )
		local pos = BonePos + Vector(0,0,-10)
		local ang = owner:EyeAngles()
		self:SetPos(pos + owner:GetRight() * 20 )
		self:SetAngles(Angle(0,ang.y,ang.r))
		self.CurAngle = self:GetAngles()
		timer.Create("RobotSpeedCheck",1,0,function()
			if owner:GetVelocity():Length() >= 800 and !self.SpeedWait then
				self.SpeedWait = true
				self:EmitSound(Sound("ui/system_message_alert.wav"),50,125)

				timer.Simple(10,function()
					self.SpeedWait = false
				end)

			end
		end)
		timer.Create("RobotIdle",10,0,function()
			if owner:GetVelocity():Length() > 0 then
				self:EmitSound("ui/hitsound_electro"..math.random(1,3)..".wav",45,math.random(95,110))
				self.SoundCount = 0
			else
				if self.SoundCount < 3 then --only repeat this 3 times to not get annoying.
				self:SetAngles(self:GetAngles() + Angle(0,45,0))
				timer.Simple(2,function()
					self:SetAngles(self:GetAngles() + Angle(0,-90,0))
				end)
				timer.Simple(3,function()
					self:SetAngles(self.Owner:GetAngles())
					self:EmitSound(Sound("ui/cyoa_node_locked.wav"),50)
					self.SoundCount = self.SoundCount + 1
				end)
				end
			end
		end)
	end

end

function ENT:Think()

    self:SetPos(self:GetPos() + Vector(0,0,math.sin(CurTime()*4)*2))

end

function ENT:OnRemove()
    if timer.Exists("RobotIdle") then
			timer.Destroy("RobotIdle")
		end
		if timer.Exists("RobotSpeedCheck") then
			timer.Destroy("RobotSpeedCheck")
		end
		if timer.Exists("ActionCheck") then
			timer.Destroy("ActionCheck")
		end
end
