local EntityMeta = FindMetaTable("Entity")
local MessageName = "EntMsg"
local SavedMessages = {}

module("EntityMessages", package.seeall )

if SERVER then

	function EntityMeta:StartUmsg( um )

		umsg.Start( MessageName, um )
		umsg.Entity( self )

	end
	
	function EntityMeta:EndUmsg()	
		umsg.End()
	end

else

	usermessage.Hook( MessageName, function( um )

		local Ent = um:ReadEntity()
		
		if !IsValid( Ent ) then
			return
		end
		
		if type( Ent.ReceiveUmsg ) == "function" then
			Ent:ReceiveUmsg( um )
		end
	
	end )

end