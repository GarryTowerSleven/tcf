---------------------------------
local _G = _G
local pairs = pairs
local type = type
local table = table
local IsValid = IsValid
local CurTime = CurTime
local hook = hook
local SafeCall = SafeCall
local GTowerItems = GTowerItems
local GTowerRooms = GTowerRooms

module("Suite")

function RemovePlayer( ply )

	if !IsValid(ply) then return end

	if ply:InVehicle() then //Do not let player be teleported in a seat!
		ply:ExitVehicle()
	end

	//Reset him, and go back to spawn point
	local teleporters = {}
	
	for k,v in pairs(ents.FindByClass("gmt_teleporter")) do
		if v:Location() == Location.SUITETELEPORTERS then table.insert( teleporters, v ) end
	end
	
	local tp = table.Random( teleporters )
	
	if IsValid(ply.BallRaceBall) then ply.BallRaceBall:SetPos(tp:GetPos() + Vector(0,0,5) + (tp:GetForward()*25)) end
	if IsValid(ply.GolfBall) then ply.GolfBall:SetPos(tp:GetPos() + Vector(0,0,5) + (tp:GetForward()*25)) end
	
	//ply.DesiredPosition = (tp:GetPos() + Vector(0,0,5) + (tp:GetForward()*25))
	ply:SetPos( tp:GetPos() + Vector(0,0,5) + (tp:GetForward()*25) )

	ply:ResetEquipmentAfterVehicle()

end

function SaveDefault( self )

	for _, ent in pairs ( self:EntsInRoom() ) do

		local SaveData = self:InventorySave( ent )

		if SaveData then
			table.insert( self.StartEnts, SaveData )
		end

	end

end

function LoadDefault( self )

	local AlreadySpawned = {}
	self.Owner._RoomSaveData = {}

	for _, v in pairs( _G.GTowerRooms.DefaultItems ) do

		for k, v1 in pairs( self.StartEnts ) do

			if v1.InvItem == _G.ITEMS[ v ] and not table.HasValue( AlreadySpawned, k ) then

				table.insert( AlreadySpawned, k )
				table.insert( self.Owner._RoomSaveData, v1 )

			end

		end

	end

end

function Cleanup( self )

    for _, v in pairs ( self:EntsInRoom() ) do
		if v:IsPlayer() && v:Alive() then
			RemovePlayer( v )

        elseif GTowerItems:FindByEntity( v ) then

            v:Remove()

        end

		if type( v.RoomUnload ) == "function" then
			SafeCall( v.RoomUnload, v, RoomId )
		end
    end

	self.ToAdd = {}

	if IsValid( self.Owner ) then
		self.Owner.GRoom = nil
		--for k,v in pairs(player.GetAll()) do v:SendLua([[ents.GetByIndex( ]]..self.Owner:EntIndex()..[[.GRoomId = 0)]]) end
		self.Owner.GRoomId = 0
    end

    self.Owner = nil
	self.LastActive = CurTime()

	hook.Call("RoomUnLoaded", GAMEMODE, self )

end

function Load( self, ply )

	self:Cleanup()

	self.Owner = ply
	self.LoadedTime = CurTime()
	self.SafeToSave = false
	ply.GRoom = self
	ply.GRoomId = self.Id
	--for k,v in pairs(player.GetAll()) do v:SendLua([[ents.GetByIndex( ]]..self.Owner:EntIndex()..[[.GRoomId = ]]..self.Id..[[)]]) end

	if ply._RoomSaveData == nil then
		self:LoadDefault()
	end

	for _, v in pairs( ply._RoomSaveData ) do

		local Pos = self.RefEnt:LocalToWorld( v.pos )
		local Ang = self.RefEnt:LocalToWorldAngles( v.ang )

		table.insert( self.ToAdd,  {
			["pos"] = Pos,
			["ang"] = Ang,
			["InvItem"] = v.InvItem
		} )

	end

	self:HookEntCreate()

	hook.Call("RoomLoaded", GAMEMODE, ply, self )

	self:CallOnEnts( 'OnRoomLoaded', ply )
	self:CallOnEnts( 'CheckLevel', ply )

end

function ClearAllMusic( mp )
	if IsValid(mp) then
		local media = mp:GetMediaPlayer():GetMedia()
		if media then
			mp:GetMediaPlayer():NextMedia()

			print("SKIP")

			timer.Simple(0.1,function()
				ClearAllMusic(mp)
			end)

		end
	end
end

function Finish( self )

	AdminNotif.SendStaff( self.Owner:NickID() .. " has checked out of suite #" .. self.Id .. ".", nil, "GRAY", 3 )

	self.Owner._LastRoomExit = CurTime()

	if self.Owner.SQL then
		self.Owner.SQL:Update( false, true )
	end

	self.Owner:SetNWInt( "RoomID", 0 )

	local panel = GTowerRooms:GetPanel( self.Id )
	if panel then
		panel:SetText( "" )
	end

	self:Cleanup()

end