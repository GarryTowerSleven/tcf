function SendMapMessage( str )

    if ( not str ) then return end

    net.Start( "MapMessage" )
	    net.WriteString( str )
    net.Broadcast()

end

util.AddNetworkString( "MapMessage" )