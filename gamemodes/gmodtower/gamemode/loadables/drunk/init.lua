AddCSLuaFile( "cl_init.lua")
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

local meta = FindMetaTable( "Player" )

if !meta then
	return
end

function meta:CanDrink( num )
	return true
end

function meta:Drink(balamt)
	if !self:Alive() then return end
	
	local balamt = balamt or 10

	if self:GetNet( "BAL" ) + balamt > 100 && IsLobby then
		self:Kill()
		self:ChatPrint("You died from alcohol poisoning.")
		self:AddAchievement( ACHIEVEMENTS.BORNTOFAIL, 1 )

		return
	end

    self:SetNet( "BAL", math.Clamp( self:GetNet( "BAL" ) + balamt, 0, 100 ) )
	self.NextSoberTime = CurTime() + 10
	self.NextHiccupTime = CurTime() + 5
	self:SetDSP( self:GetNet( "BAL" ) * .2 )

	if !self._DrunkStartTime then
		self._DrunkStartTime = CurTime()
	end
end

function meta:UnDrunk()
	self:SetNet( "BAL", 0 )
	self._DrunkStartTime = nil
	self:SetDSP(1)
end

function meta:DrunkThink()
	if CurTime() > self.NextSoberTime then

		if self._DrunkStartTime && !self:Achived( ACHIEVEMENTS.DRUNKENBASTARD ) then
			local Time = CurTime() - self._DrunkStartTime

			if Time > self:GetAchievement( ACHIEVEMENTS.DRUNKENBASTARD ) then
				self:SetAchievement( ACHIEVEMENTS.DRUNKENBASTARD, Time )
			end
		end

		self:SetNet( "BAL", math.Clamp(self:GetNet( "BAL" ) - 1, 0, 100) )

		if self:GetNet( "BAL" ) == 0 then
			self:UnDrunk()
			return
		end

		self.NextSoberTime = CurTime() + 10
	end

	if self:Alive() && CurTime() > self.NextHiccupTime && IsLobby then
		self.NextHiccupTime = CurTime() + 5;

		if math.random( 1, 100 ) <= ( self:GetNet("BAL") * 0.65 ) then
			self:Hiccup()
		elseif math.random( 1, 100 ) <= ( self:GetNet("BAL") * 0.35 ) then
			self:Puke()
		end
	end
end

hook.Add( "PlayerThink", "PlayerDrunkThink", function(ply)
    local bal = ply:GetNet("BAL")
	if bal && bal > 0 then
		ply:DrunkThink()
	end
end )

hook.Add( "PlayerDeath", "DrunkRemove", function( ply )
	ply:UnDrunk()
end )

function meta:Puke()
	self:ViewPunch(Angle(20, 0, 0))

	local edata = EffectData()
	edata:SetOrigin(self:EyePos())
	edata:SetEntity(self)

	util.Effect("puke", edata, true, true)
end

function meta:Hiccup()
	self:ViewPunch(Angle(-1, 0, 0))

	local edata = EffectData()
	edata:SetOrigin(self:EyePos())
	edata:SetEntity(self)

	util.Effect("hiccup", edata, true, true)
end