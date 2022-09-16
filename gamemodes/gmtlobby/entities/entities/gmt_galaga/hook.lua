---------------------------------
local EntityPlayers = {}

local function GalagaKeyDown(ply, key)
	if !IsValid(ply) then return end

	local PlyIndex = ply:EntIndex()
	local Ent = EntityPlayers[ PlyIndex ]

	if IsValid( Ent ) then

		if key == IN_USE && SysTime() > Ent.GameStart then
			Ent:EndGame()
		end

	end

end

local function GalagaRelease(ply)
	local PlyIndex = ply:EntIndex()
	local Ent = EntityPlayers[ PlyIndex ]

	if IsValid( Ent ) then
		Ent:EndGame()
	end
end

hook.Add( "KeyPress", "GalagaKeyPress", GalagaKeyDown )
hook.Add( "PlayerDisconnected", "GalagaRelease", GalagaRelease )

function ENT:AddPlayerHook()
	EntityPlayers[ self.Ply:EntIndex() ] = self
end

function ENT:RemovelayerHook()
	EntityPlayers[ self.Ply:EntIndex() ] = nil
end
