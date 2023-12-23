AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

local buying = {
	"gmodtower/merchant/buying.wav",
	"gmodtower/merchant/selection.wav",
	"GModTower/stores/merchant/sale2.wav"
}

function ENT:Use( ply )

	GTowerStore:OpenStore( ply, GTowerStore.MERCHANT )

	self:EmitSound( table.Random( buying ), 60, 100, 1, CHAN_VOICE )

end

function ENT:Think()

	self.BaseClass.Think( self )

	self.VisiblePlayers = self.VisiblePlayers or {}
	self.LastWelcome = self.LastWelcome or 0
	self.LastGoodbye = self.LastGoodbye or 0
	self.LastBuy = self.LastBuy or 0

	local pos = self:GetPos() + Vector( 0, 0, 64 )

	for _, ply in ipairs( player.GetAll() ) do
		
		local v = util.QuickTrace( pos, ply:WorldSpaceCenter() - pos, self ).Entity == ply

		if self.VisiblePlayers[ply] != v then

			local state = !self.VisiblePlayers[ply] && 1 || 2

			if state == 1 then

				if self.LastWelcome < CurTime() then

					self:EmitSound( "gmodtower/merchant/welcome.wav", 70, 100, 1, CHAN_VOICE )
					self.LastWelcome = CurTime() + 10

				end

			elseif state == 2 then

				if self.LastGoodbye < CurTime() && self.LastWelcome - 9 < CurTime() then

					self:EmitSound("GModTower/stores/merchant/close.wav", 70, 100, 0.75, CHAN_VOICE )
					self.LastGoodbye = CurTime() + 10

				end

			end

			self.VisiblePlayers[ply] = v

		end

	end

end