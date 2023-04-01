include("shared.lua")

net.Receive( 'GMTMessage', function( len, ply )

	if GTowerMessages then
		local msg = net.ReadString()
		local icon = net.ReadString()
		local time = net.ReadChar()
		if time == 0 then time = nil end

		Msg2( msg, time, nil, icon )
	end

end )

net.Receive( 'GMTMessageTrans', function( len, ply )

	if GTowerMessages then

		local Name = net.ReadString()
		local Count = net.ReadChar()
		local Values = {}

		for i=1, Count do
			table.insert( Values, net.ReadString() )
		end

		local icon = net.ReadString()

		Msg2( T( Name, unpack( Values ) ), nil, nil, icon )

	end
	
end )