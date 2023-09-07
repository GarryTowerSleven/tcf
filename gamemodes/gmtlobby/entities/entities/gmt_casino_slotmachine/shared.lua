ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName		= "Slot Machine"
ENT.Author			= "PixelTail Games & Sam"
ENT.Contact			= ""
ENT.Purpose			= "GMT"
ENT.Instructions	= ""
ENT.Spawnable		= false
ENT.AdminSpawnable	= false
ENT.AutomaticFrameAdvance = true

ENT.Model			= Model( "models/gmod_tower/casino/slotmachine.mdl")
ENT.LightModel		= Model( "models/props/de_nuke/emergency_lighta.mdl" )
//ENT.ChairModel		= Model( "models/props_c17/chair_stool01a.mdl")
ENT.ChairModel		= Model( "models/gmod_tower/aigik/casino_stool.mdl" )
ENT.IconPitches = {
	[1] = -180,	// Bell
	[2] = -120,	// Community Logo
	[3] = -60,	// Lemon
	[4] = 0,	// Strawberry
	[5] = 60,	// Watermelon
	[6] = 120	// Cherry
}

// Need to move these elsewhere?
Casino = {}
Casino.SlotSpinTime = { 0.8, 1.6, 2.4 }
Casino.SlotsLocalBet = 10
Casino.SlotsMinBet = 10
Casino.SlotsMaxBet = 1000
//Casino.SlotGameSound = Sound( /* NEED A SOUND HERE */ )
Casino.SlotSelectSound = Sound( "buttons/lightswitch2.wav" )
Casino.SlotPullSound = clsound.Register( "gmodtower/casino/slots/slotpull.wav" )
Casino.SlotWinSound = clsound.Register( "gmodtower/casino/slots/winner.wav" )
Casino.SlotSpinSound = clsound.Register( "gmodtower/casino/slots/spin_loop1.wav" )
Casino.SlotJackpotSound = clsound.Register( "gmodtower/casino/slots/you_win_forever.mp3" )

function ENT:SetupDataTables()
	// self:NetworkVar("Int", 0, "Jackpot")
	self:NetworkVar( "String", 0, "LastPlayerName" )
	self:NetworkVar( "Float", 0, "LastPlayerTime" )
end

local potsizes = { 8000, 5000, 2500, 2000, 1500 }
function ENT:GetRandomPotSize()
	return table.Random( potsizes )
end

function getRand()
	return math.random( 1, 6 )
end

/*---------------------------------------------------------
	Jackpot
---------------------------------------------------------*/

globalnet.Register( "Int", "SlotsJackpot", {
    default = 500,
} )

function ENT:SaveJackpot( amount, update )
	self:SetJackpot( amount )

	if SERVER and update then
		self:UpdateToSQL()
	end
end

function ENT:SetJackpot( amount )
	globalnet.SetNet( "SlotsJackpot", amount )
end

function ENT:GetJackpot()
	return globalnet.GetNet( "SlotsJackpot" )
end

function ENT:SetLastPlayer( ply )
	if SERVER then
		if IsValid( ply ) then
			self.LastPlayerSteamID = ply:SteamID()
			self:SetLastPlayerName( ply:Name() )
			self:SetLastPlayerTime( CurTime() + ( 2 * 60 ) )
		else
			self.LastPlayerSteamID = nil
			self:SetLastPlayerName( "" )
			self:SetLastPlayerTime( 0 )
		end
	end
end

function ENT:IsLastPlayer( ply )
	if not self.LastPlayerSteamID then return true end
	return self.LastPlayerSteamID == ply:SteamID()
end

function ENT:HasLastPlayer()
	return self.LastPlayerSteamID
end

/*
	Use
*/

function ENT:CanUse( ply )
	return true, "PLAY"
end