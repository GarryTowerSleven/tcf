
-----------------------------------------------------
include('shared.lua')

module( "FakeClient", package.seeall )

fakeclients = {}

function RequestFakeClients()

	net.Start("FakeClientRequest")
	net.SendToServer()

	if DEBUG then
		MsgN( "Requesting fake clients..." )
	end

end

net.Receive( "FakeClient", function( length, ply )

	local newclients = net.ReadTable()

	// Populate player functions
	for id, data in pairs( newclients ) do
		data = New( data )
	end

	fakeclients = newclients

	if DEBUG then
		MsgN( "Got some fake clients!" )
		PrintTable( newclients )
	end

end )
