
-----------------------------------------------------
include("shared.lua")

local ElevatorDing = Sound("GModTower/lobby/elevator/elevator_bell.wav")
local DoorClose = Sound("GModTower/lobby/elevator/elevator_doorclose.wav")
local DoorOpen = Sound("GModTower/lobby/elevator/elevator_dooropen.wav")
local ElevatorRide = Sound("GModTower/lobby/elevator/elevator_ride.wav")
local ElevatorStop = Sound("GModTower/lobby/elevator/elevator_arrive.wav")

function ENT:Initialize()
	self:GenerateBounds()
end

function ENT:DrawDebug()
	self:GenerateBounds()
	render.SetColorMaterialIgnoreZ()
	render.SetColorModulation(1,1,1)

	local bounds = self.Bounds[self.BOUNDSTYPE.ALL]
	render.DrawBox(self:GetPos(), self:GetAngles(), bounds.min, bounds.max, Color(255,255,255), true)
	local bounds = self.Bounds[self.BOUNDSTYPE.ACTIVATE]
	render.DrawBox(self:GetPos(), self:GetAngles(), bounds.min, bounds.max, Color(0,255,255), true)


	local bounds = self.Bounds[self.BOUNDSTYPE.ALL]
	for _, v in pairs(ents.FindInBox(bounds.min + self:GetPos(), bounds.max + self:GetPos())) do
		--if not v:IsPlayer() then continue end

		local pos = v:GetPos() - self:GetPos()
		pos:Rotate(-self:GetAngles())
		render.DrawSphere(self:GetPos() + pos, 5, 15, 15, Color(255,0,0))

	end

end

function ENT:GetDoorState()
	return self:GetNWBool("DoorState")
end

function ENT:Think()

	self:CheckModel()

	local nwState = self:GetDoorState()
	if self.CurrentDoorState ~= nwState then
		self.CurrentDoorState = nwState

		-- Play the door close/open sound
		local snd = nwState and DoorOpen or DoorClose
		self:EmitSound(snd)

		-- Do some stuff
		self.DoorModel:SetSequence( nwState and "open" or "close" )
		self.DoorModel:ResetSequenceInfo()
		self.DoorModel:SetCycle(0)
	end
	self:AnimationSoundSync()
	self.DoorModel:FrameAdvance(FrameTime())

end

-- Play sounds at certain queues within the animation
function ENT:AnimationSoundSync()
	local frame = self.DoorModel:GetCycle()
	local curSequence = self.DoorModel:GetSequenceName(self.DoorModel:GetSequence())

	self.IsMoving = frame == 1 and curSequence == "close"
	if not self.MoveSound and self.IsMoving then
		self.MoveSound = CreateSound(self, ElevatorRide)
		self.MoveSound:PlayEx(100,100)
	end

	-- If we're moving, play the move sound, else stop it
	if not self.IsMoving and self.MoveSound then
		self.MoveSound:Stop()
		self.MoveSound = nil
	end


end

function ENT:Remove()
	if IsValid(self.DoorModel) then
		self.DoorModel:Remove()
	end
end

function ENT:CheckModel()
	self.DoorModel = self.DoorModel or ClientsideModel(self.Model)

	local newOrigin = self.DoorOffset *1.0
	newOrigin:Rotate(self:GetAngles())
	newOrigin = self:GetPos() + newOrigin
	self.DoorModel:SetPos(newOrigin)
	self.DoorModel:SetAngles(self:GetAngles())
	self.DoorModel:SetPlaybackRate(2)
end

net.Receive("gmt_elevator_sound", function(len)
	local entIndex = len > 0 and net.ReadUInt(16) or -1
	local elev = Entity(entIndex)

	-- If they didn't send an entity index, play surface
	if entIndex == -1 then
		surface.PlaySound(ElevatorDing)
		surface.PlaySound(ElevatorStop)

	-- But if the entity they sent was valid, play from location
	elseif IsValid(elev) then
		elev:EmitSound(ElevatorDing)
		elev:EmitSound(ElevatorStop)
	end
end )
