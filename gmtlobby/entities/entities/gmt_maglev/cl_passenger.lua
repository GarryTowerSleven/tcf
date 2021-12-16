
-----------------------------------------------------
-- If they somehow never initialize, kick them out after this many seconds

local Timeout = 720



-- Manage adding players to a queue to get transitioned into lobby

TransitioningPlayers = TransitioningPlayers or {}



local STATE_IDLE 		= 1

local STATE_ARRIVING 	= 2

local STATE_UNLOADING 	= 3

local STATE_LEAVING 	= 4



hook.Add("NetworkEntityCreated", "MaglevPlayerCreated", function(ply)

	if not ply:IsPlayer() then return end



	-- If the local player hasn't arrived yet, this entity likely already has

	if ply ~= LocalPlayer() and not LocalPlayer().ArrivedTransition then return end

	if table.HasValue(TransitioningPlayers, ply) or ply.ArrivedTransition then return end



	-- Find the closest maglev to them, and assign it to them

	local dist = math.huge

	local ent = nil

	for _, v in pairs( ents.FindByClass("gmt_maglev")) do

		local entDist = v:GetPos():Distance(ply:GetPos())

		if IsValid(v) and entDist < dist then

			ent = v

			dist = entDist

		end

	end



	-- see if we have anything to SHOW FOR IT

	if IsValid(ent) then

		ply.OwnerMaglev = ent

		--ply:SetNoDraw(true)
		--ply:SetNoDrawAll(true)


		-- Store them in a table for later

		table.insert(TransitioningPlayers, ply)

	else

		-- If not then eh

		ply.ArrivedTransition = true

	end



end)



-- Hook into when a player spawns for the first time

hook.Add("PlayerSpawnClient", "MaglevPlayerCreated", function(ply)

	if not ply:IsPlayer() then return end



	-- If they're transitioning, send the train a-comin'

	if table.HasValue(TransitioningPlayers, ply) then



		ply.ClientInitialized = true



		-- The QueueArrival function may not exist yet, if not then do so passively

		if ply.OwnerMaglev.QueueArrival then

			ply.OwnerMaglev:QueueArrival()

		else ply.OwnerMaglev.ArrivalQueued = true end



	end

end )



local function ExitTransition(ply, index)


	if LocalPlayer() == ply && !LocalPlayer().HasWelcomed then
		LocalPlayer().HasWelcomed = true
		local name = stringmod.SafeChatName( ply:Name() )

		if ply:GetNWBool("IsNewPlayer") then
			local m = Msg2( T( "LobbyWelcomeNew" ) )
			m:SetIcon("gmtsmall")
		else
			local m = Msg2( T("LobbyWelcome",name), nil, nil, "gmtsmall" )
		end

		if ply:GetNWInt("VideoPokerAmount") > 0 then
			Msg2( T("VideoPokerRefound",ply:GetNWInt("VideoPokerAmount")) )
		end

		if file.Exists("gmtower/friends.txt", "DATA") then

			local frnds = string.Explode(" ", file.Read("gmtower/friends.txt", "DATA"))
			PopulateFriendsList()

		end

		net.Start( "CLIENTBRANCH" )
			net.WriteString(BRANCH)
		net.SendToServer()

		for k,v in pairs(player.GetAll()) do
			if v:GetModel() == mcmdl then
				GetMCSkin(v)
			end
		end

		if LocalPlayer().CosmeticEquipment then

		for k,v in pairs( LocalPlayer().CosmeticEquipment ) do
			for _, hat in pairs( GTowerHats.Hats ) do
				if v:GetModel() == hat.model then
					Msg2( T("HatUpdated",hat.Name), nil, nil, "hat" )
				end
			end
		end

		end

	end

	-- Remove them from the table

	table.remove(TransitioningPlayers, index )



	-- Stop hiding them and send em on their way

	if IsValid(ply) then

		ply.ArrivedTransition = true

		--ply:SetNoDraw(false)

		--ply:SetNoDrawAll(false)


		ply.OwnerMaglev = nil


	end



end



hook.Add("Think", "MaglevArrivalThink", function(ply)

	for i=#TransitioningPlayers, 1, -1 do

		local ply = TransitioningPlayers[i]



		local maglev = IsValid(ply) and ply.OwnerMaglev or nil



		-- If something isn't valid or the train stopped, kick em out

		if not IsValid(ply) or not IsValid(maglev) then

			ExitTransition(ply, i)



			continue

		end



		-- If they hit the timeout limit then kick them out too

		if CurTime() - ply:GetCreationTime() > Timeout then

			ExitTransition(ply, i)



			continue

		end



		-- Actually kick them out because they fuckin' made it wow

		if ply.ClientInitialized and maglev.State == STATE_UNLOADING then

			ExitTransition(ply, i)



			continue

		end



		-- Make sure their transparency remains set

		--ply:SetNoDraw(true)
		--ply:SetNoDrawAll(true)


		-- If they missed their train, reschedule if they are initialized

		if maglev.State == STATE_IDLE and ply.ClientInitialized then

			maglev:QueueArrival()

		end

	end

end )

