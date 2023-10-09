AddCSLuaFile()

ENT.Base		= "base_anim"
ENT.Type		= "anim"
ENT.PrintName	= "Cauldron"

ENT.Model 			= Model( "models/gmod_tower/halloween_cauldron.mdl" )

ENT.SoundRedeem 	= Sound( "misc/halloween/gotohell.wav" )

function ENT:Initialize()

	self:SetModel( self.Model )
	self:PhysicsInit( SOLID_VPHYSICS )

	local phys = self:GetPhysicsObject()
	if IsValid( phys ) then
		phys:EnableMotion( false )
	end

	if SERVER then
		self:SetUseType(SIMPLE_USE)
	end

end

function ENT:CanUse( ply )

	local candy = ply:GetNet( "Candy", 0 )

	if candy > 0 then
		return true, "REDEEM ( " .. tostring( candy ) .. " BUCKETS LEFT )"
	else
		return false, "FIND MORE CANDY!"
	end
	
end

if CLIENT then return end

function ENT:Use( ply )

	if IsValid( ply ) && ply:IsPlayer() then
		if !ply._CandyThrowNext then
			ply._CandyThrowNext = 0
		end

		if ply._CandyThrowNext < CurTime() then
			ply._CandyThrowNext = CurTime() + 1.5 // ( 60 * 2 )

			self:TakeCandy( ply )
		end

	end

end

function ENT:TakeCandy( ply )

	if ply:GetNet( "Candy", 0 ) <= 0 then return end

	ply:SetNet( "Candy", ply:GetNet( "Candy" ) - 1 )

	self:EmitSound( self.SoundRedeem, 80, math.random( 80, 120 ) )

	// Candy gooo
	CreateModelBezier( {
		pos = util.GetCenterPos( ply ),
		goal_entity = self,

		model = "models/gmod_tower/halloween_candybucket.mdl",
		count = 1,
				
		approach = 0.5,
		duration = 2.0,
		random_position = 0,
		spin = 0,

		begin = true,
	} )

	// Create random item/money
	math.randomseed( os.time() )

	local rnd = math.Rand(0, 1)

	local pumpkins = {
		ITEMS.suite_pumpkin,
		ITEMS.suite_pumpkin_squashed,
		ITEMS.suite_pumpkin_stout,
		ITEMS.suite_pumpkin_tall,
		ITEMS.suite_pumpkin_deformed
	}
	
	if rnd <= .001 then
		self:GiveItem( ply, ITEMS.piano)
	elseif rnd <= .01 then
		self:GiveItem( ply, ITEMS.nesguitar)
	elseif rnd <= .05 then
		self:GiveItem( ply, ITEMS.toytraincart)
	elseif rnd <= .1 then
		self:GiveItem( ply, ITEMS.scarytoyhouse)
	elseif rnd <= .2 then
		self:GiveItem( ply, ITEMS.gravestone)
	elseif rnd <= .25 then
		self:GiveItem( ply, ITEMS.cauldron)
	elseif rnd <= .3 then
		self:GiveItem( ply, ITEMS.mysterycatsack)
	elseif rnd <= .35 then
		self:GiveItem( ply, ITEMS.toyspider)
	elseif rnd <= .5 then
		self:GiveItem( ply, table.Random(pumpkins) )
	else
		ply:AddMoney( math.random( 10, 100 ) )
	end

	//ply:Msg2( "You can throw another candy into the cauldron in 2 minutes." )

end

local phrases = {
	"How mysterious~",
	"What an interesting conundrum!",
	"Hmm... wonder why?",
	"...Again?",
	"Time to use it!",
	"Science!",
	"It's an astronomical coincidence!",
	"How lame.",
	"Spooky!"
}

function ENT:GiveItem( ply, item )

	// Give them a random item!!
	local ItemID = GTowerItems:Get( item )
	
	if !ItemID || !GTowerItems:NewItemSlot( ply ):Allow( ItemID, true ) then
		ply:Msg2( "You didn't get anything. How sad!" )
		return
	end

	local succ = ply:InvGiveItem( item, nil, true )
	
	if not succ then
		ply:Msg2( "You got a " .. ItemID.Name .. ", but your inventory is full, you have been given the price of the item." )
		ply:GiveMoney( ItemID.StorePrice or 100 )
	else
		// Item gooo
		CreateModelBezier( {
			pos = util.GetCenterPos( self ),
			goal_entity = ply,
	
			model = ItemID.Model,
			count = 1,
					
			approach = 0.5,
			duration = 2.0,
			random_position = 0,
			spin = 0,
	
			begin = true,
		} )
		
		local name = ItemID.Name
		local phrase = phrases[math.random( 0, #phrases )]

		if ( name && phrase ) then
			ply:Msg2( "You got a " .. name .. "! " .. phrase )
		end
	end

end