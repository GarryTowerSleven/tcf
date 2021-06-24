
-----------------------------------------------------
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
    self:SetModel( self.Model )
    self:SetSolid( SOLID_NONE )
    self:DrawShadow( false )
end

function ENT:Think()
    if self:GetNWInt("condoID") == 0 then
      local loc = GTowerLocation:FindPlacePos( self:GetPos() )
      self:SetNWInt( "condoID", loc-1 )
    end

    if GtowerRooms.Get(self:GetNWInt("condoID")) then
      local ply = GtowerRooms.Get(self:GetNWInt("condoID")).Owner
      if IsValid(ply) then
        self:SetSkin(ply:GetInfoNum("gmt_condoblinds","1"))
      end
    end

    self:NextThink( CurTime() + 1 )

end
