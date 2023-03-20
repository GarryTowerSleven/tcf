---------------------------------
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel( self.Model )
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:DrawShadow(true)

	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion( false )
	end
	
	self.HealingPlayers = {}
end

function ENT:HealingThink()
	for ply, time in pairs( self.HealingPlayers ) do
		if !IsValid( ply ) then
			self.HealingPlayers[ ply ] = nil
		elseif !ply:Alive() then
			self:WakePlayer( ply )
		elseif CurTime() > time then
			local Health = math.min( ply:Health() + 1, 100 )
			
			ply:Extinguish()
			ply:SetHealth( Health )
			ply:EmitSound( self.HealSound )
			
			if Health >= 100 then
				self:WakePlayer( ply )
			else
				self.HealingPlayers[ ply ] = CurTime() + 0.08
			end
		end
	end
	
	if table.Count( self.HealingPlayers ) == 0 then
		self.Think = EmptyFunction
	end
end
--[[
local SleepMessages = {
	"I dreamt of a dinosaur eating pizza...",
	"I dreamt I was a butterfly...",
	"I dreamt about cheese...",
	"I dreamt of eggs...",
	"I feel tired...",
	"I feel relaxed...",
	"I dreamt about the arcade...",
	"I dreamt about winning wheel of money...",
	"I couldn't get much sleep...",
	"I dreamt about delicious food...",
	"I dreamt about cake...",
	"I dreamt about being on top of the world...",
	"I dreamt about being in a computer game...",
	"I fell asleep on my phone...",
	"I fell asleep thinking about chocolate milk...",
	"I had a dream...",
	"I dreamed I could fly...",
	"I dreamed about food...",
	"I dreamed about catsacks...",
	"I dreamed about cereal...",
	"I dreamed about bacon...",
	"I dreamt about getting a cosmic catsack...", 
	"I dreamed inside of a dream...",
	"I forgot what I dreamt...",
	"I dreamed about an alien invasion...",
	"I dreamed about a sky diving paramedic...",
	"I dreamed about being a pro gamer...",
	"I stumbled into bed...",
	"I tripped and fell and I can't get up...",
	"I dreamed about laser tag...",
	"I dreamed I got 80 WPM in typing derby...",
	"I dreamed about zombies...",
	"I dreamed about being in a ball and... racing...",
	"I dreamed about being a pink dragon...",
	"I dreamed about being a knight...",
	"I dreamt I was opened and an item came out of me...",
	"I dreamed about having a big brain in trivia...",
	"I dreamt of worms in my food...",
	"I dreamt of catsack wearing a hat...",
	"I dreamt of the moon...",
	"I dreamt of telephones...",
	"I dreamed of winning millions of units...",
	"I dreamt of a new puppy...",
	"I dreamt of a new kitten...",
	"I dreamt of skeletons...",
	"I dreamt of a relaxing summer...",
	"I dreamt I was in a pool tube...",
	"I didn't dream at all... it was very painful...",
	"I had a horrible nightmare...",
	"What a horrible night for a curse...",
	"I dreamed of tower unite 5...",
	"I dreamt of sans undertale...",
	"Every night I sleep it brings me closer to...",
	"My back aches...",
	"I dreamed I was 30...",
	"I dreamed of wii sports 7...",
	"I dreamed of video games...",
	"AHHHHHH...",
	"I dreamt of a new gamer chair...",
	"I dreamt of a new keyboard...",
	"I dreamed of being a ball race e-sports champion...",
	"I dreamt of half-life 3...",
	"I dreamed of the stars and the universe...",
	"Am I dead...?",
	"I broke my leg...",
}]]

function ENT:WakePlayer( ply )
	PostEvent( ply, "sleepoff" )
	ply:Freeze( false )
	ply:DrawWorldModel( true )
	
	self.HealingPlayers[ ply ] = nil
	
	--[[if IsValid( ply ) then
		net.Start( "BedMessage" )
			net.WriteString( "" )
			net.WriteBool( false )
		net.Send( ply )
	end]]
end

function ENT:Use( ply )
	if !ply:IsPlayer() then return end

	PostEvent( ply, "sleepon" )
	ply:Freeze( true )
	ply:EmitSound( self.SleepSound )
	
	ply:UnDrunk()
	self.HealingPlayers[ ply ] = CurTime() + 4.0
	self.Think = self.HealingThink
--[[
	if IsValid( ply ) then
		net.Start( "BedMessage" )
			net.WriteString( SleepMessages[math.random(1,#SleepMessages)] )
			net.WriteBool( true )
		net.Send( ply )
	end]]
end

function ENT:OnRemove()
	for ply, time in pairs( self.HealingPlayers ) do
		self:WakePlayer( ply )
	end
end

--util.AddNetworkString( "BedMessage" )