include('shared.lua')

module( "Friends", package.seeall )

CreateConVar( "gmt_notify_friendjoin", 1, { FCVAR_ARCHIVE, FCVAR_USERINFO } )


DEBUG = false
LocalFilename = "gmtower/friends.txt"
List = nil

-- Loads the local friends table, if possible
local function LoadFriends()

	local friends = file.ReadJSON( LocalFilename )

	if friends then
		List = friends
	end

	if List then
		for steamid, status in pairs(List) do

			-- Make sure you can't friend/block yourself
			if steamid == LocalPlayer():SteamID() then
				List[steamid] = 0
			end

		end
	end

	MsgN( "Loaded friends successfully." )
	SendFriendStatus()

end

hook.Add( "InitPostEntity", "LoadFriends", LoadFriends )

-- Saves the friends table to a local file for storage
function SaveFriends()

	if List then
		-- Save to local data
		file.CreateDir( "gmtower" )
		file.WriteJSON( LocalFilename, List )
	else
		-- Remove file that isn't being used
		file.Delete( LocalFilename, "DATA" )
	end

	if DEBUG then MsgN( "Friends saved." ) end

end

-- Sets the friend relationship of a player.
-- Ex. REL_FRIEND or REL_BLOCKED
function SetFriend( ply, relationship )

	if not List then List = {} end

	if DEBUG then MsgN( "Set Friend ", ply, relationship ) end

	-- Set the relationship
	ChangeRelationship( ply, List[ply:SteamID()] or 0, relationship )

	-- Update server
	SendFriendStatus()

	-- Save
	SaveFriends()

end

function ChangeRelationship( ply, oldRelationship, newRelationship )

 	-- You can't change relationship on yourself!
	if ply == LocalPlayer() then return end

	local steamid = ply:SteamID()

	-- Update on the database
	List[steamid] = newRelationship

	if oldRelationship == newRelationship then return end

	-- Display status update
	if newRelationship == REL_FRIEND then
		Msg2( T("Friends_Friend", ply:Name()) )
	end

	if newRelationship == REL_BLOCKED then

		-- Forbid players from blocking admins
		if ( ply:IsAdmin() or ply:IsModerator() ) and not ply:IsHidden() and not ply:IsSecretAdmin() then
			List[steamid] = 0
			Msg2( T("Friends_BlockAdmin", ply:Name()) )
			return
		end

		Msg2( T("Friends_Block", ply:Name()) )
	end

	if newRelationship == 0 then
		if oldRelationship == REL_FRIEND then
			Msg2( T("Friends_Unfriend", ply:Name()) )
		elseif oldRelationship == REL_BLOCKED then
			Msg2( T("Friends_Unblock", ply:Name()) )
		else
			Msg2( T("Friends_NoRelationship", ply:Name()) )
		end
	end

end

-- Sends friends relationships to the server
function SendFriendStatus()

	if not List then return end

	net.Start("FriendStatus")
		for steamid, status in pairs(List) do
			local strippedSteamId = string.gsub( steamid, "STEAM_", "" )
			net.WriteString( strippedSteamId )
		end
	net.SendToServer()

	LocalPlayer()._Friends = List

	if DEBUG then MsgN( "Update friends to server." ) end

end

hook.Add( "PlayerActionBoxPanel", "FriendActions", function( panel ) 

	-- Friend
	local cmd = panel:CreateItem()
	cmd:SetMaterial( Scoreboard.PlayerList.MATERIALS.Friend, 16, 16, 16, 16 )
	cmd:SetText( "Friend" )
	cmd.OnMousePressed = function( self )
		SetFriend( panel:GetPlayer(), Friends.REL_FRIEND )
	end
	cmd.UpdateVisible = function( self, ply )
		if ply == LocalPlayer() then
			return false
		else
			return not Friends.IsFriend( LocalPlayer(), ply )
		end
	end

	-- Unfriend
	local cmd = panel:CreateItem()
	cmd:SetMaterial( Scoreboard.PlayerList.MATERIALS.Unfriend, 16, 16, 16, 16 )
	cmd:SetText( "Unfriend" )
	cmd.OnMousePressed = function( self )
		SetFriend( panel:GetPlayer(), 0 )
	end
	cmd.UpdateVisible = function( self, ply )
		if ply == LocalPlayer() then
			return false
		else
			return Friends.IsFriend( LocalPlayer(), ply )
		end
	end

	-- Block
	local cmd = panel:CreateItem()
	cmd:SetMaterial( Scoreboard.PlayerList.MATERIALS.Block, 16, 16, 16, 16 )
	cmd:SetText( "Block" )
	cmd.OnMousePressed = function( self )
		SetFriend( panel:GetPlayer(), Friends.REL_BLOCKED )
	end
	cmd.UpdateVisible = function( self, ply )
		if ply == LocalPlayer() then
			return false
		else
			return not Friends.IsBlocked( LocalPlayer(), ply )
		end
	end

	-- Unblock
	local cmd = panel:CreateItem()
	cmd:SetMaterial( Scoreboard.PlayerList.MATERIALS.Unblock, 16, 16, 16, 16 )
	cmd:SetText( "Unblock" )
	cmd.OnMousePressed = function( self )
		SetFriend( panel:GetPlayer(), 0 )
	end
	cmd.UpdateVisible = function( self, ply )
		if ply == LocalPlayer() then
			return false
		else
			return Friends.IsBlocked( LocalPlayer(), ply )
		end
	end

end )

if IsLobby then

	hook.Add( "Think", "FriendsLobbyVisibility", function()

		--if not LocalPlayer()._Friends then return end
		/*if Dueling and Dueling.IsDueling( LocalPlayer() ) then
			for _, ply in pairs( player.GetAll() ) do
				ply:SetNoDrawAll( false )
			end
			return
		end*/

		for _, ply in pairs( player.GetAll() ) do

			-- Never display these blocked players
			if IsBlocked( LocalPlayer(), ply ) then

				ply:SetNoDrawAll( true )
				ply._WasLocalBlocked = true

			else
				-- Bring them back if they were unblocked
				if ply._WasLocalBlocked then
					ply:SetNoDrawAll( false )
					ply._WasLocalBlocked = false
				end

			end

		end

	end )

	hook.Add( "PlayerFootstep", "FriendsLobbyFootstepVisibility", function( ply )
		return ply._WasLocalBlocked
	end )

end
