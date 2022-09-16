
-----------------------------------------------------
AddCSLuaFile("shared.lua")



ENT.Base		= "base_anim"

ENT.Type		= "anim"

ENT.PrintName	= "Cauldron"



ENT.Model		= Model("models/props_halloween/cauldron_fine.mdl")

ENT.Sound		= Sound("gmodtower/inventory/use_cauldron.wav")

game.AddParticles( "particles/cauldron_fx.pcf")

PrecacheParticleSystem( "cauldron_embers" )
PrecacheParticleSystem( "cauldron_embers_2" )
PrecacheParticleSystem( "cauldron_bubbles_explode" )
PrecacheParticleSystem( "cauldron_rays" )
PrecacheParticleSystem( "cauldron_flash" )
PrecacheParticleSystem( "cauldron_pop" )
PrecacheParticleSystem( "cauldron_smoke_explode" )
PrecacheParticleSystem( "cauldron_rumble" )
PrecacheParticleSystem( "cauldron_drips" )
PrecacheParticleSystem( "cauldron_bubbles_float" )
PrecacheParticleSystem( "cauldron_bubbles" )

function ENT:CanUse( ply )

	local candy = ply:GetNWInt( "Candy" )

	if (candy or 0) > 0 then
		return true, "REDEEM ( "..tostring(candy).." BUCKETS LEFT )"
	else
		return false, "FIND MORE CANDY FIRST"
	end
end

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


net.Receive("cauldron_fx",function()
	local self = net.ReadEntity()
	if !IsValid(self) then return end
	ParticleEffect( "cauldron_embers", self:GetPos() + self:GetUp() * 110, Angle( 0, 0, 0 ) )
	ParticleEffect( "cauldron_embers_2", self:GetPos() + self:GetUp() * 110, Angle( 0, 0, 0 ) )
	ParticleEffect( "cauldron_bubbles_explode", self:GetPos() + self:GetUp() * 110, Angle( 0, 0, 0 ) )
	ParticleEffect( "cauldron_rays", self:GetPos() + self:GetUp() * 110, Angle( 0, 0, 0 ) )
	ParticleEffect( "cauldron_flash", self:GetPos() + self:GetUp() * 110, Angle( 0, 0, 0 ) )
	ParticleEffect( "cauldron_pop", self:GetPos() + self:GetUp() * 110, Angle( 0, 0, 0 ) )
	ParticleEffect( "cauldron_smoke_explode", self:GetPos() + self:GetUp() * 110, Angle( 0, 0, 0 ) )
	ParticleEffect( "cauldron_rumble", self:GetPos() + self:GetUp() * 110, Angle( 0, 0, 0 ) )
	ParticleEffect( "cauldron_drips", self:GetPos() + self:GetUp() * 110, Angle( 0, 0, 0 ) )
end)

if CLIENT then return end


function ENT:Think()
	self:Bubbles2()
	self:Bubbles()
end

function ENT:Bubbles2()
	if (self.NextBubble2 or 0) > CurTime() then return end
	self.NextBubble2 = CurTime() + 0.5
  ParticleEffect( "cauldron_bubbles_float", self:GetPos() + self:GetUp() * 110, Angle( 0, 0, 0 ) )
end

function ENT:Bubbles()
	if (self.NextBubble or 0) > CurTime() then return end
	self.NextBubble = CurTime() + 2
  ParticleEffect( "cauldron_bubbles", self:GetPos() + self:GetUp() * 110, Angle( 0, 0, 0 ) )
end

util.AddNetworkString("cauldron_fx")

function ENT:DoEffects()

	net.Start("cauldron_fx")
	net.WriteEntity(self)
	net.Broadcast()

end

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


	if !ply.Candy then ply.Candy = 0 end

	if ply.Candy <= 0 then return end


	self:EmitSound( self.Sound, 80, math.random(80,120) )

	self:DoEffects()

	--ply:SendLua([[surface.PlaySound("misc/halloween/gotohell.wav")]])

	self:EmitSound( "misc/halloween/gotohell.wav", 70, math.random(90,110) )

	ply.Candy = ply.Candy - 1

	ply:SetNWInt( "Candy", ply.Candy )


	// Candy gooo

	local ent = ents.Create("gmt_model_bezier")

	if IsValid( ent ) then

		ent:SetPos( ply:GetPos() + Vector( 0, 0, 64 ) )

		ent.ModelString = "models/gmod_tower/halloween_candybucket.mdl"

		ent.GoalEntity = self

		ent.RandPosAmount = 0

		ent:Spawn()

		ent:Activate()

		ent:Begin()

	end



	// Create random item/money

	math.randomseed( os.time() )



	local rnd = math.Rand(0, 1)



	if rnd <= .001 then
		self:GiveItem( ply, ITEMS.HalloweenSpider)
	elseif rnd <= .025 then
		self:GiveItem( ply, ITEMS.gmt_bat)
	elseif rnd <= .05 then
		self:GiveItem( ply, ITEMS.mdl_hatman)
	elseif rnd <= .1 then

		self:GiveItem( ply, ITEMS.gmt_skulls)

	elseif rnd <= .2 then

		self:GiveItem( ply, ITEMS.gmt_cleaver)

	elseif rnd <= .5 then

		self:GiveItem( ply, ITEMS.toytraincart)

	elseif rnd <= .6 then

		self:GiveItem( ply, ITEMS.spookboyplush)

	elseif rnd <= .7 then

		self:GiveItem( ply, ITEMS.gravestone)

	elseif rnd <= .8 then

		self:GiveItem( ply, ITEMS.mysterycatsack)

	elseif rnd <= .9 then

		self:GiveItem( ply, ITEMS.cauldron)

	elseif rnd <= 1 then

		self:GiveItem( ply, ITEMS.toyspider)

	else

		ply:AddMoney( math.random( 12, 35 ) )

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



	// Item gooo

	local ent = ents.Create("gmt_model_bezier")

	if IsValid( ent ) then

		ent:SetPos( self:GetPos() + Vector( 0, 0, 50 ) )

		ent.ModelString = ItemID.Model

		ent.GoalEntity = ply

		ent.RandPosAmount = 0

		ent:Spawn()

		ent:Activate()

		ent:Begin()

	end



	ply:InvGiveItem( item )



	local name = ItemID.Name

	local phrase = phrases[math.random( 0, #phrases )]



	if ( name && phrase ) then

		ply:Msg2( "You got a " .. name .. "! " .. phrase )

	end



end
