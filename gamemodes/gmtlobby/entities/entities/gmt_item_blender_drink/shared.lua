if SERVER then
	AddCSLuaFile("shared.lua")
end

ENT.Type			= "anim"
ENT.Base			= "base_anim"
ENT.Model			= Model( "models/sunabouzu/juice_cup.mdl" )
ENT.DrinkSounds		= { Sound( "GModTower/lobby/blender/drink01.wav" ),
						Sound( "GModTower/lobby/blender/drink02.wav" ),
						Sound( "GModTower/lobby/blender/drink03.wav" ) }

if CLIENT then return end

ENT.Used			= false
ENT.Drink			= nil
ENT.Player			= nil
ENT.DelayTime		= nil
ENT.EffectTime		= 0

ENT.EffectStart		= nil
ENT.EffectThink		= nil
ENT.EffectEnd		= nil

function ENT:Initialize()

	self:SetModel( self.Model )

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self:SetUseType( SIMPLE_USE )

	self.FreezeTime = CurTime() + 4

end

function ENT:SetDrink( drink )

	self:SetColor( drink.Color )
	
	self.EffectStart = drink.Start or nil
	self.EffectThink = drink.Think or nil
	self.EffectEnd = drink.End or nil

	self.Drink = drink

end

function ENT:Use( ply )

	if ( self.Used /*|| !ply:HasWatchEquipped()*/ ) then return end
	
	// used drink
	self.Used = true

	// player drink anim
	//ply:GetActiveWeapon():Drink()

	// store reference to player
	self.Player = ply
	
	if ( !self.Drink ) then return end

	if self.Drink.Flavor != nil then
		ply:ChatPrint( self.Drink.Flavor )
	end

	ply:EmitSound( table.Random( self.DrinkSounds ), 80, 100 )

	self.DelayTime = CurTime() + 1.5
	self.EffectTime = CurTime() + ( self.Drink.Time or 0 )

	// remove from visibility
	self:SetNoDraw( true )
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	
	local phys = self:GetPhysicsObject()
	if IsValid( phys ) then
		phys:EnableMotion( false )
	end

end

function ENT:Think()

	if self.FreezeTime < CurTime() then
		local phys = self:GetPhysicsObject()
		if IsValid( phys ) then
			phys:EnableMotion( false )
		end
	end

	if ( !self.Player || !IsValid( self.Player ) || !self.Drink ) then return end

	if Dueling.IsDueling( self.Player ) then 
		if ( self.EffectEnd ) then
			if ( self.Drink.Name == "Deathwish" ) then
				PostEvent( self.Player, "pspawn" )
			else
				self.EffectEnd ( self.Player )
				self.Player:UnDrunk()
			end
			self.Player:SetModel("models/player/normal.mdl")
		end
		self.Player = nil
		self:Remove()
	return end

	if self.Player:GetNWBool( "InLimbo" ) then 
		if ( self.EffectEnd ) then
			if ( self.Drink.Name == "Deathwish" ) then
				PostEvent( self.Player, "pspawn" )
			else
				self.EffectEnd ( self.Player )
				self.Player:UnDrunk()
			end
				
			GAMEMODE:SetPlayerSpeed( self.Player, 100, 100 )
			self.Player:SetModel("models/player/group01/male_01.mdl")
		end
		self.Player = nil
		self:Remove()
	return end

	if !self.Player:Alive() then -- prevent effects from persisting/cropping up after death
		if ( self.EffectEnd ) then
			if ( self.Drink.Name == "Deathwish" ) then
				PostEvent( self.Player, "pspawn" )
			else
				self.EffectEnd ( self.Player )
				self.Player:UnDrunk()
			end
		end
		self.Player = nil
		self:Remove()
	return end
	
	if ( self.DelayTime && self.DelayTime < CurTime() ) then
		self.DelayTime = nil

		if ( self.EffectStart ) then
			self.EffectStart( self.Player )
		end
		return
	end

	if ( self.EffectTime < CurTime() ) then
		if ( self.EffectEnd ) then
			self.EffectEnd( self.Player )
		end

		self:Remove()
		return
	end
	
	if ( self.EffectThink ) then
		self.EffectThink( self.Player )
	end

end

function ENT:CanUse( ply )
	return true, "DRINK"
end