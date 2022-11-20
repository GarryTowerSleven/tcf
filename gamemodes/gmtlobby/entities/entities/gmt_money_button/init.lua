
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("cl_stencilcomposite.lua")

AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_overlay.lua")
include("shared.lua")

ENT.Players = {}

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetSolid(SOLID_VPHYSICS)
    self:InitSounds()
end

function ENT:Think()

    local Progress = (CurTime() - self:GetChargeTime())/10

    if Progress >= 1 && self:GetPressed() then
      local ply = self:GetUsePlayer()

      if IsValid(ply) then
        ply:AddMoney(1)
        ply.CanHoldBtn = false
        self:SetPressed(false)
        self:SetUsePlayer( nil )
        ply:SetNWBool("IsPressing",false)
        table.RemoveByValue(self.Players,ply)

        self:EmitSound(self.SoundScripts["release"])

        self:ResetSequence("press")
        if IsValid(self:GetNextUsePlayer()) then
          local nxtUse = self:GetNextUsePlayer()
          self:SetUsePlayer( nxtUse )
          self:SetPressed( true )
          self:SetChargeTime( CurTime() )
          self:SetChargeDuration( self.ChargeTimer )
          nxtUse:SetNWBool("IsPressing",true)
          nxtUse:SetNWFloat("ChargeTime",CurTime())
          nxtUse:SetNWBool("IsNextUser",false)
          self:SetNextUsePlayer( nil )
        end
      end

    end

    for _,ply in pairs( self.Players ) do
      if !IsValid(ply) then continue end

      if !self:TestPlayerTrace(ply) || !ply:KeyDown(IN_USE) then
        if self:GetUsePlayer() == ply then
          self:SetPressed( false )
          self:SetUsePlayer( nil )
          ply:SetNWBool("IsPressing",false)
          table.RemoveByValue(self.Players,ply)

          self:EmitSound(self.SoundScripts["release"])
          self:EmitSound(self.SoundScripts["cancel"])
          self:StopSound(self.SoundScripts["charge"])

          self:ResetSequence("press")

          if IsValid(self:GetNextUsePlayer()) then
            local nxtUse = self:GetNextUsePlayer()
            self:SetUsePlayer( nxtUse )
            self:SetPressed( true )
            self:SetChargeTime( CurTime() )
            self:SetChargeDuration( self.ChargeTimer )
            nxtUse:SetNWBool("IsPressing",true)
            nxtUse:SetNWFloat("ChargeTime",CurTime())
            nxtUse:SetNWBool("IsNextUser",false)
            self:SetNextUsePlayer( nil )
          end

        end
        continue
      end

      if IsValid(self:GetUsePlayer()) then

        if self:GetUsePlayer() != ply then
          if !IsValid(self:GetNextUsePlayer()) then
            ply:SetNWBool("IsNextUser",true)
            self:SetNextUsePlayer(ply)
          end
        end

        continue
      end

      if !ply.CanHoldBtn then continue end

      self:EmitSound(self.SoundScripts["press"])
      self:EmitSound(self.SoundScripts["charge"])

      self:ResetSequence("down")

      self:SetPressed( true )
      self:SetChargeTime( CurTime() )
      self:SetChargeDuration( self.ChargeTimer )
      self:SetUsePlayer( ply )
      ply:SetNWBool("IsPressing",true)
      ply:SetNWFloat("ChargeTime",CurTime())

    end
end

/*
self:NetworkVar( "Bool", 0, "Pressed" )			--Is the button currently pressed?
self:NetworkVar( "Float", 0, "ChargeTime" )		--When was it pressed
self:NetworkVar( "Float", 1, "ChargeDuration" )	--How long ya have to hold it
self:NetworkVar( "Entity", 0, "UsePlayer" )		--Who's pressing it
self:NetworkVar( "Entity", 1, "NextUsePlayer" )	--Who's the next in line to hold it
*/

hook.Add( "KeyPress", "MoneyBtnPress", function( ply, key )
  if key != IN_USE || !Location.Is( ply:Location(), "secret1" ) then return end

  local button = ents.FindByClass("gmt_money_button")[1]

  ply.CanHoldBtn = true

  table.insert( button.Players, ply )
end )
