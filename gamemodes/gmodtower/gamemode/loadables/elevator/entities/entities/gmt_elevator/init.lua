
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

ENT.LastState = nil
ENT.WaitTime = 0
ENT.InProgress = false
ENT.Halt = false

ENT.Targets = {
  { Vector(7960, 504, -608),    Vector(-1766, 1590, 14983)  }, -- Tower Lobby, Top Left.
  { Vector(7960, -504, -608),   Vector(-1766, 966, 14983)   }, -- Tower Lobby, Top Right.
  { Vector(7448, 504, -608),    Vector(-2278, 1591, 14983)  }, -- Tower Lobby, Bottom Left.
  { Vector(7448, -503, -608),   Vector(-2278, 967, 14983)   }, -- Tower Lobby, Bottom Right.
  { Vector(-1766, 1590, 14983), Vector(7960, 504, -608)     }, -- Tower Condo Lobby, Top Left.
  { Vector(-1766, 966, 14983),  Vector(7960, -504, -608)    }, -- Tower Condo Lobby, Top Right.
  { Vector(-2278, 1591, 14983), Vector(7448, 504, -608)     }, -- Tower Condo Lobby, Bottom Left.
  { Vector(-2278, 967, 14983),  Vector(7448, -503, -608)    }  -- Tower Condo Lobby, Bottom Right.
}

util.AddNetworkString("gmt_elevator_sound")

function ENT:OpenDoors()
  self:SetNWBool( "DoorState", true )
end

function ENT:CloseDoors()
  self:SetNWBool( "DoorState", false )
end

function ENT:OpenTargetDoors()
  self.TargetElev:SetNWBool( "DoorState", true )
end

function ENT:CloseTargetDoors()
  self.TargetElev:SetNWBool( "DoorState", false )
end

function ENT:PlayersToTarget( ent )
  if ( !IsValid( ent ) || !IsValid( self.TargetElev ) ) then return end

  local IsInElev = false

  activebounds = self.Bounds[self.BOUNDSTYPE.ACTIVATE]

  for _, v in pairs(ents.FindInBox(activebounds.min + self:GetPos(), activebounds.max + self:GetPos())) do
    if not v:IsPlayer() then continue end
    if ent == v then IsInElev = true end
  end

  if !IsInElev then return end

  // Gather position data
  local pos = ent:GetPos()
  local old = self:GetPos()
  local new = self.TargetElev:GetPos()

  // Offset position
  local offset = pos - old
  local vec = new + offset

  // NO LEAVING, EVER
  if ( !pos:WithinDistance(old, self.RoomWidth) ) then
    vec = new
  end
  ent.DesiredPosition = vec // required hack due to SetPos sometimes failing

end

/**
 * Hooks into move to set the origin of the player (hack to fix broken SetPos)
*/
hook.Add( "Move", "MoveElevator", function( ply, move )
	if ply.DesiredPosition != nil then
		ply.OldVel = ply:GetVelocity()
		move:SetOrigin( ply.DesiredPosition )
		ply:SetLocalVelocity( ply.OldVel )
		ply.OldVel = nil
		ply.DesiredPosition = nil
	end
end )

function ENT:Think()

  if !self.TargetElev then
    for k,v in pairs(self.Targets) do
      if self:GetPos() == v[1] then
        for _,target in pairs(ents.FindByClass("gmt_elevator")) do
          if target:GetPos() == v[2] then
            self.TargetElev = target
          end
        end
      end
    end

    if !self.TargetElev then
      ErrorNoHalt( "Couldn't find target elevator for entity " .. tostring(self) .. "\n" )
      self:Remove()
    end

  end

  if !self.DoorCollideEnt then
    for k,v in pairs(ents.FindInSphere(self:GetPos(),256)) do
      if v:GetClass() == "func_wall_toggle" then
        self.DoorCollideEnt = v
        return
      end
    end
  end

  if !IsValid( self.DoorCollideEnt ) then return end

  local state = self:GetNWBool("DoorState")

  local activebounds = self.Bounds[self.BOUNDSTYPE.ACTIVATE]
  local bounds = self.Bounds[self.BOUNDSTYPE.ALL]

  local PlayersInElev = false
  local MovingPlayers = {}

  for _, v in pairs(ents.FindInBox(activebounds.min + self:GetPos(), activebounds.max + self:GetPos())) do
		if not v:IsPlayer() then continue end
    table.insert( MovingPlayers, v )
    PlayersInElev = true
	end

  if (PlayersInElev && !self.Halt) then
    --self:CloseDoors()
  else
    self.WaitTime = CurTime() + self.ActivateDelayTime
    if !self.Halt then self:OpenDoors() end
  end

  if self.LastState == nil then
    self.DoorCollideEnt:Fire("toggle")
    self.LastState = state
  end

  if (self.LastState != state) then
    self.DoorCollideEnt:Fire("toggle")
    self.LastState = state
  end

  if ( CurTime() > self.WaitTime && PlayersInElev && !self.Halt ) then
    if self.InProgress then return end
    self.InProgress = true
    self:CloseDoors()
    self.TargetElev.Halt = true
    self:CloseTargetDoors()
    timer.Simple(self.DoorMoveTime + 2,function()
      self.TargetElev.Halt = true

      for k,v in pairs(MovingPlayers) do
        self:PlayersToTarget(v)
      end

      timer.Simple(1,function()
        self:OpenTargetDoors()
        net.Start( "gmt_elevator_sound" )
          net.WriteUInt( self.TargetElev:EntIndex(), 16 )
        net.Broadcast()
      end)

      timer.Simple(7.5,function()
        self.TargetElev.Halt = false
      end)
    end)
  else
    self.InProgress = false
  end

end
