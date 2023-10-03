include("shared.lua")

local function UMsgT( icon, target, trans, ... )
	if ( not trans ) then return end

	net.Start( 'GMTMessageTrans' )
		net.WriteString( trans )
		net.WriteChar( select( '#', ... ) )

		for _, v in ipairs( { ... } ) do
			net.WriteString( v )
		end

		net.WriteString( icon or "" )
	if not target then
		net.Broadcast()
	else
		net.Send( target )
	end

end

function MsgT( trans, ... )

	UMsgT( nil, nil, trans, ... )

end

local meta = FindMetaTable( "Player" )

if !meta then
    Msg("ALERT! Could not hook Player Meta Table\n")
    return
end

function meta:Msg2( msg, icon, time )

	if ( not msg ) then return end

	net.Start( 'GMTMessage' )
		net.WriteString( msg )
		net.WriteString( icon or "" )
		net.WriteChar( time or 0 )
	net.Send( self )

end

function meta:MsgI( icon, trans, ... )
	UMsgT( icon, self, trans, ... )
end

function meta:MsgT( trans, ... )
	UMsgT( "", self, trans, ... )
end

util.AddNetworkString( "GMTMessage" )
util.AddNetworkString( "GMTMessageTrans" )