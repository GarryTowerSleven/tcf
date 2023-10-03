local netStringName = "gmt_playerhook_initpost"
local validEntityPollTimeout = 30

if SERVER then
    
    util.AddNetworkString( netStringName )

    local queue = queue or {}

    local function ClientCreated( ply )

		if ply._ClientCreated then return end

        if queue[ ply ] then
            queue[ ply ] = nil
        end

		ply._ClientCreated = true

		-- Call the hook on the server to inform a client is initialized
		hook.Call( "PlayerSpawnClient", GAMEMODE, ply )

		-- Send it back to all the clients so we can do a hook THANG
		net.Start( netStringName )
			net.WriteInt( ply:EntIndex(), 10 )
		net.Broadcast()

	end

    hook.Add( "PlayerInitialSpawn", "GMTPlayerCreated", function( ply )
        if ply:IsBot() then
            ClientCreated( ply )

            return
        end

        queue[ ply ] = true
    end )

    hook.Add( "SetupMove", "GMTPlayerCreated", function( ply, _, cmd )
        if queue[ ply ] and not cmd:IsForced() then
            queue[ ply ] = nil

            ClientCreated( ply )
        end
    end )

	net.Receive( netStringName, function( len, ply )
        if queue[ ply ] then
            queue[ ply ] = nil
        end

		ClientCreated( ply )
	end )

end

if CLIENT then
    
    -- Called when our world is ready, we're loaded and dandy
	hook.Add( "InitPostEntity", "GMTPlayerCreated", function()
		net.Start( netStringName )
		net.SendToServer()
	end )

    local function ClientCreated( ply )

		if ply._ClientCreated then return end

		ply._ClientCreated = true

		hook.Call( "PlayerSpawnClient", GAMEMODE, ply )

	end

    -- We actually recieve the player before they are even valid
	-- Hold a queue that we poll until they are valid
	local ReceiveQueue = {}
	net.Receive( netStringName, function()	

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
	hook.Add( "Think", "GMTPlayerSpawnClientPoll", function()

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