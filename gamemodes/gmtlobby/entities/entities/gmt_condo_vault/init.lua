
-----------------------------------------------------
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

ENT.OpenSound = Sound( "gmodtower/lobby/condo/vault_open.wav" )
ENT.CloseSound = Sound( "gmodtower/lobby/condo/vault_close.wav" )

util.AddNetworkString("gmt_close_vault")

net.Receive("gmt_close_vault",function( len, ply )
  for k,v in pairs(ents.FindByClass("gmt_condo_vault")) do
    if v.LastPlayer == ply then
      v:CloseVault()
      return
    end
  end
end)

function ENT:Initialize()
    self:SetModel( self.Model )
    self:SetSolid( SOLID_BBOX )
    self:DrawShadow( false )
    self:SetUseType( SIMPLE_USE )
    self.LastUse = 0.0
    self.LastPlayer = NULL
end

function ENT:IsOpen()
  return self:GetNWBool( "Open" )
end

function ENT:OpenVault()
  self:SetNWBool( "Open", true )
  self:EmitSound( self.OpenSound, 60 )
end

function ENT:CloseVault()
  self:SetNWBool( "Open", false )
  self:EmitSound( self.CloseSound, 60 )
end

function ENT:Use(ply)
  --local Room = GTowerRooms.Get( self.RoomId )

  if !ply:IsPlayer() then return end

  if self.LastUse > CurTime() then
    return
  end

  if !self:GetNWBool( "Open" ) then
    self.LastUse = CurTime() + 0.5
    self.LastPlayer = ply
    GTowerItems:OpenBank( ply )
    self:OpenVault()
  end
end
