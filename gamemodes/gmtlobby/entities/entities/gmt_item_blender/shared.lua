ENT.Type			= "anim"
ENT.Base			= "base_anim"
ENT.PrintName	   	= "Blender"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false
ENT.Model			= Model( "models/sunabouzu/fancy_blender.mdl" )
ENT.LoadRoom 		= true

ENT.SoundBlend		= clsound.Register( "GModTower/lobby/blender/drink_blend.wav" )
ENT.SoundSpit		= clsound.Register( "GModTower/lobby/blender/drink_spit.wav" )

ENT.BlendDelay		= 4 // how long should we blend for?
ENT.BlendTime		= nil

ENT.SpitAnimDelay	= 1 // delay to for animation spit
ENT.SpitDelay		= 1.43 // delay actually spit out the drink

ENT.PackDelayTime	= .5 // delay between ingredients getting packed
ENT.PackDelay		= nil

ENT.Ingredients 	= {}
ENT.Drink			= nil // drink to be produced
ENT.Bartender		= nil // who mixed the drink?
ENT.IsBlending		= false
ENT.ShouldSpin		= false

// INGREDIENT IDS
local APPLE			= 1
local STRAWBERRY	= 2
local WATERMELON	= 3
local BANANA		= 4
local ORANGE		= 5
local GLASS			= 6
local PLASTIC		= 7
local BONE			= 8

// Models of the inventory items
local IngredientsModels = { 
	[APPLE]			= Model("models/sunabouzu/fruit/apple.mdl"),
	[STRAWBERRY]	= Model("models/sunabouzu/fruit/strawberry.mdl"),
	[WATERMELON]	= Model("models/props_junk/watermelon01_chunk01b.mdl"),
	[BANANA]		= Model("models/props/cs_italy/bananna.mdl"),
	[ORANGE]		= Model("models/props/cs_italy/orange.mdl"),
	[GLASS]			= Model("models/props_junk/glassjug01.mdl"),
	[PLASTIC]		= Model("models/props_junk/garbage_plasticbottle002a.mdl"),
	[BONE]			= Model("models/gibs/hgibs.mdl"),
}

// Unique names of inventory items that are valid
local ValidIngredients = { 
	[APPLE]			= "ingredient_apple",
	[STRAWBERRY]	= "ingredient_straw",
	[WATERMELON]	= "ingredient_watermel",
	[BANANA]		= "ingredient_banana",
	[ORANGE]		= "ingredient_orange",
	[GLASS]			= "ingredient_glass",
	[PLASTIC]		= "ingredient_plastic",
	[BONE]			= "ingredient_bone",
}

local function ValidIngredient( ent )

	if !IsValid( ent ) then return false end

	for id, item in pairs( ValidIngredients ) do

		if ent:IsItem( item ) then
			return id
		end

	end

	return false

end

//Precache the particle system
game.AddParticles("particles/elevator_particles.pcf")

PrecacheParticleSystem( "juice_red" )
PrecacheParticleSystem( "juice_blue" )
PrecacheParticleSystem( "juice_green" )
PrecacheParticleSystem( "juice_orange" )



local DrinkCombos = {
	{ 
		Name = "Morning Fruit Shake", 
		Flavor = "Mmmm.. So refreshing!",
		Ingredient1 = APPLE, 
		Ingredient2 = STRAWBERRY,
		Color = Color( 159, 209, 31 ),
		Price = 125,
		Time = 3,
		Start = function( ply )
			if !IsValid( ply ) then return end
			ply:SetHealth( ply:GetMaxHealth() )
			ply:Freeze( false )
			ply:UnDrunk()
		end,
	},
	{
		Name = "Mid-Afternoon Fruit Shake",
		Flavor = "Huh.. things look.. fruity?",
		Ingredient1 = WATERMELON,
		Ingredient2 = STRAWBERRY,
		Color = Color( 209, 73, 31 ),
		Price = 100,
		Time = 60,
		Start = function( ply )
			if !IsValid( ply ) then return end
			ply:SetHealth( math.min( ply:Health() + 30, ply:GetMaxHealth() ) )
			PostEvent( ply, "pcolored_on" )
		end,
		End = function( ply )
			if !IsValid( ply ) then return end
			PostEvent( ply, "pcolored_off" )
		end
	},
	{ 
		Name = "Midnight Fruit Shake", 
		Flavor = "Wow, this stuff sure can make you sleepy...",
		Ingredient1 = APPLE,
		Ingredient2 = WATERMELON,
		Color = Color( 205, 55, 15 ),
		Price = 100,
		Time = 60,
		Start = function( ply )
			if !IsValid( ply ) then return end
			ply:SetHealth( math.min( ply:Health() + 30, ply:GetMaxHealth() ) )
			PostEvent( ply, "psleepy_on" )
		end,
		End = function( ply )
			if !IsValid( ply ) then return end
			PostEvent( ply, "psleepy_off" )
		end			
	},
	{ 
		Name = "Midnight Tang Fruit Shake",
		Flavor = "Wow, this stuff sure can make you sleepy.. but it also tastes pretty good!",
		Ingredient1 = ORANGE,
		Ingredient2 = WATERMELON,
		Color = Color( 235, 115, 60 ),
		Price = 100,
		Time = 30,
		Start = function( ply )
			if !IsValid( ply ) then return end
			ply:SetHealth( math.min( ply:Health() + 45, ply:GetMaxHealth() ) )
			PostEvent( ply, "psleepy_on" )
		end,
		End = function( ply )
			if !IsValid( ply ) then return end
			PostEvent( ply, "psleepy_off" )
		end
	},
	{ 
		Name = "Extra Pulpy Orange Juice",
		Flavor = "I can feel my tooth enamel corroding.",
		Ingredient1 = ORANGE,
		Ingredient2 = ORANGE,
		Color = Color( 245, 175, 65 ),
		Price = 75,
		Time = 3,
		Start = function( ply )
			if !IsValid( ply ) then return end
			ply:SetHealth( math.min( ply:Health() + 30, ply:GetMaxHealth() ) )
			ply:Freeze( false )
		end,
	},
	{ 
		Name = "Man's Orange Juice",
		Flavor = "Ough!.. What a way to start the evening.",
		Ingredient1 = GLASS,
		Ingredient2 = ORANGE,
		Color = Color( 122, 78, 20 ),
		Price = 75,
		Time = 3,
		Start = function( ply )
			if !IsValid( ply ) or !ply:CanDrink( 25 ) then return end
			ply:ViewPunch(Angle(2, math.random(-1, 1), 0))
			ply:Drink( 25 )
		end,
	},
	{ 
		Name = "Dangerously Hard Cider",
		Flavor = "Does this still keep the doctor away?",
		Ingredient1 = GLASS,
		Ingredient2 = APPLE,
		Color = Color( 85, 35, 35 ),
		Price = 75,
		Time = 3,
		Start = function( ply )
			if !IsValid( ply ) or !ply:CanDrink( 20 ) then return end
			ply:ViewPunch(Angle(2, math.random(-1, 1), 0))
			ply:Drink( 20 )
		end,
	},
	{ 
		Name = "Deathwish",
		Flavor = "Oh no...",
		Ingredient1 = PLASTIC,
		Ingredient2 = GLASS,
		Color = Color( 30, 30, 30 ),
		Price = 50,
		Time = 3,
		Start = function( ply )
			if !IsValid( ply ) then return end
			PostEvent( ply, "pdeath" )
			ply:SetDSP( 35, true )
		end,
		End = function( ply )
			if !IsValid( ply ) then return end
			ply:Kill()  
			PostEvent( ply, "pspawn" )
		end,
	},
	{ 
		Name = "Strawberry Banana Shake Boost",
		Flavor = "Did everything just start to slow down?",
		Ingredient1 = STRAWBERRY,
		Ingredient2 = BANANA,
		Color = Color( 230, 140, 160 ),
		Price = 150,
		Time = 300,
		Start = function( ply )
			if !IsValid( ply ) then return end
			ply:SetHealth( math.min( ply:Health() + 30, ply:GetMaxHealth() ) )
			GAMEMODE:SetPlayerSpeed( ply, 360, 640 )
			PostEvent( ply, "pspeed_on" )
		end,
		End = function( ply )
			if !IsValid( ply ) then return end
			ply:ResetSpeeds()
			PostEvent( ply, "pspeed_off" )
		end,
	},
	{
		Name = "One Too Many",
		Flavor = "That is one strong drink.. *hic*",
		Ingredient1 = GLASS,
		Ingredient2 = GLASS,
		Color = Color( 98, 56, 38 ),
		Price = 100,
		Time = 30,
		Start = function( ply )
			if !IsValid( ply ) or !ply:CanDrink( 20 ) then return end
			ply:ViewPunch(Angle(2, math.random(-1, 1), 0))
			ply:Drink( 20 )
		end,
		End = function( ply )
			if !IsValid( ply ) or !ply:CanDrink( 30 ) then return end
			ply:ViewPunch(Angle(4, math.random(-2, 2), 0))
			ply:Drink( 30 )
		end
	},
	{
		Name = "Slow Down",
		Flavor = "This tastes.. Alright?.. Wait a second...",
		Ingredient1 = PLASTIC,
		Ingredient2 = WATERMELON,
		Color = Color( 155, 155, 155 ),
		Price = 100,
		Time = 45,
		Start = function( ply )
			if !IsValid( ply ) then return end
			PostEvent( ply, "ptime_on" )
			GAMEMODE:SetPlayerSpeed( ply, 50, 50 )
			ply:SetDSP( 31 )
		end,
		End = function( ply )
			if !IsValid( ply ) then return end
			PostEvent( ply, "ptime_off" )
			ply:ResetSpeeds()
			ply:SetDSP( 0 )
		end			
	},
	{
		Name = "Bone Meal",
		Flavor = "This might be too much calcium for today.",
		Ingredient1 = BONE,
		Ingredient2 = BONE,
		Color = Color( 255, 255, 255 ),
		Price = 250,
		Time = 300,
		Start = function( ply )
			if !IsValid( ply ) then return end
			ply:Ignite(.25, 0)
			ply:SetHealth( ply:Health() + 1 )
			ply:SetModel( "models/player/skeleton.mdl" )
			ply:SetNWBool("ForceModel", true)
			PostEvent( ply, "pbone_on" )
		end,
		End = function( ply )
			if !IsValid( ply ) then return end
			PostEvent( ply, "pbone_off" )
			ply:SetNWBool("ForceModel", false)
			ply:ConCommand( "gmt_updateplayermodel" )
		end			
	},
}

/*for _, s in ipairs(DrinkCombos) do
	
	GTowerItems.RegisterItem("shake_" .. s.Name,{
		Name = s.Name,
		Description = "A delicious smoothie.",
		Model = "models/sunabouzu/juice_cup.mdl",
		DrawModel = true,
		InvCategory = "food",
		StoreId = GTowerStore.FOOD,
		StorePrice = s.Price,
		DrawName = true,
		ModelColor = s.Color or Color( 159, 209, 31, 255 ),
		CanUse = true,
		AllowAnywhereDrop = true,

		OnUse = function(self)
			if IsValid( self.Ply ) && self.Ply:IsPlayer() then
				local ent = ents.Create( "gmt_item_blender_drink" )

				ent:SetPos(self.Ply:GetPos())
				ent:Spawn()

				ent:SetDrink( s or self.Drink )
				ent.Item = true
				ent:Use(self.Ply)
				return nil
			end

			return self
		end
	})
end*/

if SERVER then
	
	AddCSLuaFile( "shared.lua" )
	
	function ENT:Initialize()

		self:SetModel( self.Model )
		//self:SetAngles( Angle( 0, 180, 0 ) )
		
        self:PhysicsInit( SOLID_VPHYSICS )		
		self:SetUseType( SIMPLE_USE ) // Or else it'll go WOBLBLBLBLBLBLBLBL
		
		local phys = self:GetPhysicsObject()
		if IsValid( phys ) then
			phys:EnableMotion( false )
		end

	end

	function ENT:Use( ply )

        if !IsValid( ply ) || !ply:IsPlayer() then return end

		if self.IsBlending then return end

		local Room = GTowerRooms:Get( self.RoomId )
		if (Room and ply != Room.Owner) && !ply:IsAdmin() then return end

		if #self.Ingredients < 2 then
			ply:Msg2( "Place two ingredients in before trying to blend." )
			return
		end

		self.Bartender = ply 
		
		self:StartBlend()

	end
	
	function ENT:StartBlend()

		//Msg("STARTING BLENDER\n")
		self.ShouldSpin = true
		self.IsBlending = true
		self.BlendTime = CurTime() + self.BlendDelay

		self.Drink = GetDrink( self.Ingredients[1], self.Ingredients[2] )
		
		self:EmitSoundInLocation( self.SoundBlend, 80, 100 )

		umsg.Start( "SetBlender", self:GetLocationRP() )
			umsg.Entity( self )
			umsg.Bool( true )
		umsg.End()
	
	end
	
	function ENT:EndBlend()
	
		self.BlendTime = nil
		self:StartSpitDrink()
	
	end

	function ENT:Think()

		if !self.IsBlending then

			if #self.Ingredients != 2 || !self.PackDelay || self.PackDelay < CurTime() then

				for _, ent in pairs( ents.FindInSphere( self:GetPos(), 32 ) ) do
					self:Pack( ent )
				end

				self.PackDelay = CurTime() + 0.25

			end

			return

		end

		if ( self.BlendTime && self.BlendTime < CurTime() ) then
			self:EndBlend()
		end

	end
	
	function ENT:Pack( hitEnt )

		if #self.Ingredients > 1 then return end

		local ingredient = ValidIngredient( hitEnt )
		if ( !ingredient || ingredient == -1 ) then return end
		
		//Msg( "Valid ingredient: "..tostring( hitEnt:GetModel() ).."\n" )
		self:AddIngredient( hitEnt, ingredient )
		
		umsg.Start( "BlenderInsert", self:GetLocationRP() )
			umsg.Entity( self )
			umsg.Char( self.Ingredients[1] or -1 )
			umsg.Char( self.Ingredients[2] or -1 )
		umsg.End()
		
		self:EmitSoundInLocation( self.SoundSpit, 80, 180 )

		if ( #self.Ingredients > 1 ) then
			umsg.Start( "BlenderSprite", self:GetLocationRP() )
				umsg.Entity( self )
				umsg.Bool( true )
				umsg.Char( 64 )
				umsg.Char( 255 )
				umsg.Char( 64 )
			umsg.End()
		end

	end
	
	function ENT:AddIngredient( ent, id )
	
		table.insert( self.Ingredients, id )
		ent:Remove()

	end
	
	function GetDrink( ingredient1, ingredient2 )

		for _, drink in pairs( DrinkCombos ) do

			local ing1 = drink.Ingredient1
			local ing2 = drink.Ingredient2
			
			if ( ( ing1 == ingredient1 && ing2 == ingredient2 ) || ( ing1 == ingredient2 && ing2 == ingredient1 ) ) then
				return drink
			end
		end

		return nil

	end
	
	function ENT:StartSpitDrink()

		// Send animation
		timer.Simple( self.SpitAnimDelay, function()

			if ( !IsValid( self ) ) then return end

			if ( self.Drink ) then
				umsg.Start( "SpitBlender", self:GetLocationRP() )
					umsg.Entity( self )
				umsg.End()
			end

		end )

		// Actually spit out 
		timer.Simple( self.SpitDelay, function()
		
			if ( !IsValid( self ) ) then return end

			self:EndSpitDrink()
			self:ResetVars()

		end )

	end
	
	function ENT:EndSpitDrink()
	
		umsg.Start( "BlenderSprite", self:GetLocationRP() )
			umsg.Entity( self )
			umsg.Bool( true )
			umsg.Char( 255 )
			umsg.Char( 0 )
			umsg.Char( 0 )
		umsg.End()
		
		umsg.Start( "BlenderInsert", self:GetLocationRP() )
			umsg.Entity( self )
			umsg.Char( -1 )
			umsg.Char( -1 )
		umsg.End()

		if ( self.Drink ) then
			
			//print( "Spitting out drink: " .. tostring( self.Drink.Name ) )
	
			self:EmitSoundInLocation( self.SoundSpit, 80, 100 )
			
			local ent = ents.Create( "gmt_item_blender_drink" )
				local attID = self:LookupAttachment( "juice.point" )
				local attPos = self:GetAttachment( attID )
				ent:SetPos( attPos.Pos )
			ent:Spawn()

			ent:SetDrink( self.Drink )

			local phys = ent:GetPhysicsObject()
			if IsValid(phys) then
				phys:ApplyForceCenter( Vector( math.random( -40, 40 ), math.random( -40, 40 ), 140 ) )
			end
			
			self.Bartender:Msg2( "Nice! You blended a \"" .. self.Drink.Name .. "\"!" )
			
			self.Bartender:AddAchievement( ACHIEVEMENTS.SUITEBARTENDER, 1 )
			
		return end
		
		self.Bartender:Msg2( "These two ingredients don't blend together..." )
	end
	
	function ENT:ResetVars()

		self.BlendTime = nil

		table.Empty( self.Ingredients )
		self.Ingredients = {}

		self.Drink = nil
		self.IsBlending = false

		umsg.Start( "SetBlender", self:GetLocationRP() )
			umsg.Entity( self )
			umsg.Bool( false )
		umsg.End()

	end

else //CLIENT

	
	local AttachSpit	= "juice.point"
	local AttachLight	= "light.point"
	local AttachFruit	= "fruit.point"
	local SpriteMat		= Material( "effects/softglow" )

	local Particles		= {
							"juice_red",
							"juice_blue",
							"juice_green",
							"juice_orange",
	}

	ENT.RenderGroup 	= RENDERGROUP_TRANSLUCENT
	ENT.DrawSprite		= true
	ENT.Color			= Color( 255, 0, 0 )
	
	ENT.Model1			= nil
	ENT.Model2			= nil

	function ENT:Draw()

		self:FrameAdvance( FrameTime() )
		self:DrawModel()
		
		if ( self:GetSequence() == self:LookupSequence( "spit" ) && self:GetCycle() > 25 ) then //Loop prevention to keep it from spitting
			self:SetSequence( self:LookupSequence( "idle" ) )
		end
		
		if ( self.ShouldSpin ) then
			self.IngredientSpin = ( self.IngredientSpin or 0 ) - 5
			if self.IngredientSpin == -180 then
				self.IngredientSpin = 180
			end
		end
		
		//Make the fruit shake with the blender	
		if IsValid( self.Model1 ) && IsValid( self.Model2 ) then
			local attID = self:LookupAttachment( AttachFruit )
			local attPos = self:GetAttachment( attID )
			
			self.Model1:SetPos( attPos.Pos )
			self.Model1:SetAngles( attPos.Ang - Angle( 0, self.IngredientSpin, 90) ) //Offset from the blender angles
			
			local normal = attPos.Ang:Right()
			self.Model2:SetPos( attPos.Pos - (normal * 5 ) ) //Move the second prop upwards from the origin
			self.Model2:SetAngles( attPos.Ang - Angle( 0, self.IngredientSpin, 90) )
		end

		if ( self.DrawSprite ) then
			render.SetMaterial( SpriteMat )
			
			local attID = self:LookupAttachment( AttachLight )
			local attPos = self:GetAttachment( attID )
			if attPos then
				render.DrawSprite( attPos.Pos + ( self:GetForward() ), 5, 5, self.Color )
			end
		end

	end

	function ENT:Initialize()

		local sequence = self:LookupSequence( "idle" )
		self:SetSequence( sequence )
		self:SetPlaybackRate( 1.0 )

	end
	
	usermessage.Hook( "SetBlender", function( um )
	
		local blender = um:ReadEntity()
		if ( !IsValid( blender ) ) then return end

		local bool = um:ReadBool()
		blender.IsBlending = bool
		blender.ShouldSpin = bool
		
		if ( bool ) then

			local sequence = blender:LookupSequence( "jive" )
			blender:ResetSequence( sequence )

			blender.DrawSprite = true
			blender.Color = Color( 0, 255, 0 )

			local attID = blender:LookupAttachment( AttachSpit )
			local attPos = blender:GetAttachment( attID )
			ParticleEffect( Particles[ math.random( 1, #Particles ) ], attPos.Pos, attPos.Ang + Angle( 0, 0, -90 ), blender )
			
		else
		
			local sequence = blender:LookupSequence("idle")
			blender:SetSequence( sequence )

			blender.DrawSprite = true
			blender.Color = Color( 255, 0, 0 )
			blender:StopParticles()

		end

	end )

	usermessage.Hook( "SpitBlender", function( um )

		local blender = um:ReadEntity()
		if ( !IsValid( blender ) ) then return end
		
		local sequence = blender:LookupSequence( "spit" )
		blender:ResetSequence( sequence )
		blender.ShouldSpin = false
		blender.DrawSprite = true
		blender.Color = Color( 255, 255, 0 )
		
		blender:StopParticles()

	end )
	
	usermessage.Hook( "BlenderSprite", function( um )

		local blender = um:ReadEntity()
		if ( !IsValid( blender ) ) then return end

		blender.DrawSprite = um:ReadBool()
		if ( !blender.DrawSprite ) then return end

		local r = um:ReadChar()
		local g = um:ReadChar()
		local b = um:ReadChar()
		
		blender.Color = Color( r, g, b )
	
	end )

	usermessage.Hook( "BlenderInsert", function( um )

		local blender = um:ReadEntity()
		if ( !IsValid( blender ) ) then return end

		local mdl1 = um:ReadChar() or -1
		local mdl2 = um:ReadChar() or -1
		
		local attID = blender:LookupAttachment( AttachFruit )
		local attPos = blender:GetAttachment( attID )

		if ( mdl1 != -1 ) then		
			if ( IsValid( blender.Model1 ) ) then
				blender.Model1:Remove()
			end
			
			blender.Model1 = ClientsideModel( IngredientsModels[ mdl1 ] )
			blender.Model1:SetModelScale( .75, 0 )
			blender.Model1:SetPos( attPos.Pos )
		else
			if ( IsValid( blender.Model1 ) ) then
				blender.Model1:Remove()
			end
		end

		if ( mdl2 != -1 ) then		
			if ( IsValid( blender.Model2 ) ) then
				blender.Model2:Remove()
			end

			blender.Model2 = ClientsideModel( IngredientsModels[ mdl2 ] )
			blender.Model2:SetModelScale( .75, 0 )
			blender.Model2:SetPos( attPos.Pos + Vector( 0, 0, 5 ) )
		else		
			if ( IsValid( blender.Model2 ) ) then
				blender.Model2:Remove()
			end
		end
		
	end )

	function ENT:CanUse( ply )
		if IsValid( self.Model1 ) and IsValid( self.Model2 ) then
			return true, "BLEND"
		else
			return false, "PLACE AT LEAST TWO FOOD ITEMS IN"
		end
	end
	
	function ENT:Think() end
	function ENT:OnRemove()

		if IsValid( self.Model1 ) then
			self.Model1:Remove()
		end

		if IsValid( self.Model2 ) then
			self.Model2:Remove()
		end

	end

end