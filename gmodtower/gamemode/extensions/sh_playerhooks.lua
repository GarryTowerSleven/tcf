local netStringName = "gmt_playerhook_initpost"
local validEntityPollTimeout = 30 -- Time out in 30 seconds if the entity doesn't become valid

if SERVER then
	util.AddNetworkString(netStringName)

	local function ClientCreated( ply )

		-- Call the hook on the server to inform a client is initialized
		hook.Call( "PlayerSpawnClient", GAMEMODE, ply )

		-- Send it back to all the clients so we can do a hook THANG
		net.Start(netStringName)
			net.WriteInt(ply:EntIndex(), 10)
		net.Broadcast()
	end

	-- Receiving from this means
	net.Receive(netStringName, function(len, ply)
		ClientCreated(ply)
	end )

	-- Quick fix for bots
	hook.Add("PlayerInitialSpawn", "GMTBotPlayerCreated", function(ply)
		if not ply:IsBot() then return end

		ClientCreated(ply)
	end )
end 

if CLIENT then

	-- Called when our world is ready, we're loaded and dandy
	hook.Add("InitPostEntity", "GMTPlayerCreated", function()
		net.Start(netStringName)
		net.SendToServer()
	end )

	local function ClientCreated( ply )
		hook.Call( "PlayerSpawnClient", GAMEMODE, ply )
	end

	-- We actually recieve the player before they are even valid
	-- Hold a queue that we poll until they are valid
	local ReceiveQueue = {}
	net.Receive(netStringName, function()	
		local entindex = net.ReadInt(10)
		local ply = Entity(entindex)

		if not IsValid(ply) then 
			table.insert(ReceiveQueue, {Index = entindex, StartTime = RealTime()})
			return 
		end 

		-- Now call the hook for the clients in the house
		ClientCreated( ply )
	end )

	-- Just poll for when (if) they become valid
	hook.Add("Think", "GMTPlayerSpawnClientPoll", function()
		for k, v in pairs( ReceiveQueue ) do
			local ply = Entity(v.Index)

			-- A player has finally become valid, run the hook
			if IsValid(ply) then
				ClientCreated( ply )
				ReceiveQueue[k] = nil 
			end

			-- If we've waited long enough and they're still a no-show, don't bother
			if RealTime() - v.StartTime > validEntityPollTimeout then
				ReceiveQueue[k] = nil 
			end
		end
	end )
end