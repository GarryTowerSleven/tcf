---------------------------------
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

util.AddNetworkString("gmt_sendnamelist")

function ENT:SpawnFunction( ply, tr )
	if ( !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 2

	local ent = ents.Create( "gmt_mailbox" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()

	return ent
end

function ENT:Initialize()
	self.Entity:SetModel( self.Model )
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:DrawShadow(true)

	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
	end


end

function ENT:Use( ply )

	if IsPlayer( ply ) then
		self:StartUmsg( ply )
		self:EndUmsg()
	end



end

concommand.Add("gmt_copysuggestions",function(ply)

	if !ply:IsAdmin() then return end

	Database.Query( "SELECT * FROM `gm_name_suggestions`;", function( res, status, err )
		
		if status != QUERY_SUCCESS then
			return
		end

		local names = {}
		for _, v in ipairs( res ) do
			table.insert( names, v.name .. ": " .. v.suggestion )
		end

		net.Start("gmt_sendnamelist")
			net.WriteTable(names)
		net.Send(ply)

	end )

end)

concommand.Add( "gmt_namesuggestion", function( ply, cmd, args, str )

	if true then return end

	local Message = str

	if !Message || string.len( Message ) <= 2 then
		return
	end

	if ply.NoNameChange then
		ply:SendLua([[
			local m = Msg2("You've already made a suggestion.")
			m:SetIcon("cancel")
			m:SetColor(Color(0, 115, 207))
		]])
		return
	end

	Database.Query( "SELECT * FROM `gm_name_suggestions` WHERE `player` = '" .. Database.Escape( ply:DatabaseID() ) .. "'", function( res, status, err )
	
		if status != QUERY_SUCCESS then
			return
		end

		if table.Count( res ) > 0 then

			ply:SendLua([[
				local m = Msg2("You've already made a suggestion.")
				m:SetIcon("cancel")
				m:SetColor(Color(0, 115, 207))
			]])

			ply.NoNameChange = true

		end

	end )

	if ply.NoNameChange then return end

	local EscapedName = Database.Escape( ply:Name() )
	local EscapedMessage = Database.Escape( Message )

	local data = {
		player = ply:DatabaseID(),
		name = Database.Escape( ply:Name(), true ),
		suggestion = Database.Escape( Message, true ),
	}

	Database.Query( "INSERT INTO `gm_name_suggestions` " .. Database.CreateInsertQuery( data ) .. ";", function( res, status, err )
	
		if status != QUERY_SUCCESS then
			return
		end

		if not IsValid( ply ) then return end

		ply:SendLua([[
			local m = Msg2("Thank you for your suggestion.")
			m:SetIcon("heart")
			m:SetColor(Color(0, 115, 207))
		]])

		ply.NoNameChange = true
		ply:SendLua([[surface.PlaySound("vo/npc/female01/vanswer0]]..math.random(6,9)..[[.wav")]])

	end )


end )
