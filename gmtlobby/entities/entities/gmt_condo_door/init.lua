
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.OpenSound = Sound("doors/door1_move.wav")
ENT.CloseSound = Sound("doors/door_wood_close1.wav")
ENT.LockedSound = Sound("doors/latchlocked2.wav")

function ENT:KeyValue( key, value )
    if key == "model" then
      self.Model = value
    end

    if key == "condoid" then
      self:SetNWInt( "CondoID", tonumber( value ) )
    end

    if key == "condodoortype" then
      self:SetNWInt( "CondoDoorType", tonumber( value ) )
    end

end

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetSolid(SOLID_VPHYSICS)
    self:DrawShadow(false)
    self:SetUseType(SIMPLE_USE)
end

local bells = {
  "standard1",
  "standard2",

  "ambient1",

  "happy1",
  "happy2",

  "spooky1",
  "spooky2",
  "spooky3",

  "disco1",
  "disco2",
  "disco3",

  "french1",
  "french2",
  "french3",

  "jazzy1",
  "jazzy2",
  "jazzy3",

  "funky1",
  "funky2",
  "funky3",
  "funky4",

  "robot1",
  "robot2",

  "vocoder1",
  "vocoder2"
}

function ENT:Use( ply )
  if ply.UsingDoor then return end

  self.TeleportEnt = NULL

  for k,v in pairs(ents.FindByClass("gmt_condo_door")) do
    if self:GetCondoDoorType() == 1 then
      if Location.Find(v:GetPos()) == self:GetCondoID() then
        self.TeleportEnt = v
      end
    else
      if Location.Find(self:GetPos()) == v:GetCondoID() then
        self.TeleportEnt = v
      end
    end
  end

  if !IsValid(self.TeleportEnt) then return end

  local owner

  if self:GetCondoDoorType() == 1 then

    for k,v in pairs(player.GetAll()) do
      if !v.GRoom then continue end
      if v.GRoomId == self:GetCondoID() then
        owner = v
      end
    end

  if !owner then
    self:EmitSound(self.LockedSound,80)
    return
  end

  if owner.RoomBans and table.HasValue( owner.RoomBans, ply ) then
    ply:Msg2("You have been banned from this Condo.")
    self:EmitSound(self.LockedSound,80)
    return
  end

  if owner.GRoomLock && ply != owner && !IsFriendsWith( owner, ply ) then

    self:EmitSound(self.LockedSound,80)
    if CurTime() < (ply.RingDelay or 0) then return end
    ply.RingDelay = CurTime() + 5
    self:EmitSound( Sound("GModTower/lobby/condo/doorbells/" .. bells[owner:GetInfoNum( "gmt_condodoorbell", 1 )]) .. ".wav", 80 )
    if (owner:Location()) == self:GetCondoID() then
      owner:EmitSound( Sound("GModTower/lobby/condo/doorbells/" .. bells[owner:GetInfoNum( "gmt_condodoorbell", 1 )]) .. ".wav" )
    end

    return
  end

  end

  ply.UsingDoor = true
  ply:Freeze(true)

  net.Start("LoadingDoor")
  net.WriteEntity(self)
  net.Send(ply)

  self:EmitSound(self.OpenSound,80)

  local OpenSeq = self:LookupSequence("open")
  local CloseSeq = self:LookupSequence("close")

  self:ResetSequence(OpenSeq)

  timer.Simple( (self.DelayTime + self.WaitTime) ,function()
    ply.UsingDoor = false
    ply:Freeze(false)
    ply:EmitSound(self.CloseSound,80)
    self:ResetSequence(CloseSeq)

    if ( ply.BallRaceBall && IsValid(ply.BallRaceBall) ) then
      ply.BallRaceBall:SetAngles(self.TeleportEnt:GetAngles())
      ply:SetEyeAngles(self.TeleportEnt:GetAngles())
      ply.BallRaceBall:SetPos( self.TeleportEnt:GetPos() + Vector(0,0,35) )
    else
      ply:SetEyeAngles(self.TeleportEnt:GetAngles())
      ply.DesiredPosition = self.TeleportEnt:GetPos() + (self.TeleportEnt:GetForward()*50)
    end
  end)
end
