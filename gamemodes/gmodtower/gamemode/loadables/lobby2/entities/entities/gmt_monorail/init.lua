
include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

ENT.LastThink = 0

ENT.StationWaitTime = 15

ENT.SpeechPositions = {
  [5]   = "welcome1",
  [51]  = "theatre",
  [106] = "arcade",
  [150] = "boardwalk",
  [176] = "stores",
  [196] = "gamemodes",
  [240] = "tower",
}

ENT.SpeechOrigin = Vector(-896, 2240, -89)

ENT.DoorsOpen = false

ENT.ArriveSound = Sound("gmodtower/lobby/condo/doorbells/standard2.wav")
ENT.LeaveSound = Sound("gmodtower/lobby/condo/doorbells/standard1.wav")

ENT.EngineSoundPath = Sound("gmodtower/lobby/monorail/engine.wav")

ENT.DoorSound = Sound("doors/heavy_metal_move1.wav")

ENT.Arriving = false

ENT.Wagons = {}

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetSolid(SOLID_VPHYSICS)

    for i=1, self.CarCount do
      self.Wagons[i] = ents.Create("prop_dynamic")
      self.Wagons[i]:SetModel(self.Model)
    end

end

function ENT:CheckSpeech(num)
  local curPos = num - 1

  if self.SpeechPositions[num] && self.CurSpeech != self.SpeechPositions[num] then
    self.CurSpeech = self.SpeechPositions[num]

    local name = self.CurSpeech

    if name == "welcome" then
      name = name .. tostring( math.random(1,2) )
    end
    local path = "gmodtower/lobby/tour/" .. self.CurSpeech .. ".mp3"

    for k,v in pairs( player.GetAll() ) do
      if v:GetNWBool("inMonorail") then
        v:SendLua([[surface.PlaySound("]] .. path .. [[")]])
      end
    end

  end

end

function ENT:LerpAcceleration()
  if self.TargetAcceleration != self.Acceleration then
    self.Acceleration = Lerp(FrameTime(), self.Acceleration, self.TargetAcceleration)
  end
end

function ENT:OpenDoors()

  self.DoorsOpen = true

  self:EmitSound( self.ArriveSound, 80, 100 )

  timer.Simple( 1, function()

    self:EmitSound( self.DoorSound, 80, 100 )

    self.Sequence = self:LookupSequence( "doors_open" )

    self:SetPlaybackRate( 1.0 )
    self:ResetSequence( self.Sequence )
    self:SetCycle( 0 )
  end)
end

function ENT:CloseDoors()

  self.DoorsOpen = false

  self:EmitSound( self.LeaveSound, 80, 100 )

  timer.Simple( 1, function()

    self:EmitSound( self.DoorSound, 80, 100 )

    self.Sequence = self:LookupSequence( "doors_close" )

    self:SetPlaybackRate( 1.0 )
    self:ResetSequence( self.Sequence )
    self:SetCycle( 0 )
  end)
end

function ENT:Think()

  if !self.Curve then return end

  self.RunTime = self.RunTime + (FrameTime() * (self.Acceleration))

  if !self.EngineSound then
    self.EngineSound = CreateSound( self, self.EngineSoundPath )
  end

  self.EngineSound:Play()
  self.EngineSound:ChangeVolume(.3)
  self.EngineSound:ChangePitch( ((self.Acceleration or 1) + 1) * 100 - 80 )

  if !self.FrontPiece then
    self.FrontPiece = ents.Create("prop_dynamic")
    self.FrontPiece:SetModel(self.ModelFront)
  end

	local pos, ang, num, speed = self:GetPosAngle()
	
  local frontpos, frontang, frontnum = self:GetPosAngle(200)

  if speed != self.TargetAcceleration && !self.Arriving then
    self.TargetAcceleration = speed
  end

  if self.Acceleration < 0.02 && speed == 0 && !self.Arriving then
    self.Arriving = true
    self:OpenDoors()

    timer.Simple(self.StationWaitTime, function()
      self:CloseDoors()

      timer.Simple(1, function()
        self.TargetAcceleration = .5
        SetGlobalInt( "MonorailLeaveTime", CurTime() )
      end)

    end)
  end

  if speed != 0 && self.Arriving then
    self.Arriving = false
  end

  self:CheckSpeech(num)
  self:LerpAcceleration()

  self:SetPos(pos)
  self:SetAngles(ang)

  if IsValid(self.FrontPiece) then
    self.FrontPiece:SetPos(frontpos)
  	self.FrontPiece:SetAngles(frontang)
  end

  for k,v in pairs(self.Wagons) do
    local pos, ang, num = self:GetPosAngle(k*-400, k)
    v:SetPos(pos)
    v:SetAngles(ang)
  end

	self:SetMoveType(MOVETYPE_NONE)

  self:FrameAdvance( CurTime() )
	self:NextThink( CurTime() )
	return true
end

function ENT:OnRemove()
    for k,v in pairs(self.Wagons) do
      v:Remove()
    end

    if IsValid(self.FrontPiece) then
      self.FrontPiece:Remove()
    end
end

hook.Add("PlayerDeath", "MonorailDeath", function(ply)
  if ply:GetNWBool("inMonorail") then
    ply:SetNWBool( "inMonorail", false )
  end
end)

hook.Add("SetupPlayerVisibility", "MonorailRender", function(pPlayer, pViewEntity)

  if !pPlayer:GetNWBool("inMonorail") then return end

  local Monorail = ents.FindByClass("gmt_monorail")[1]

	if IsValid(Monorail) then
		AddOriginToPVS( Monorail:GetPos() + Vector(0,0,25) )
	end
end)
