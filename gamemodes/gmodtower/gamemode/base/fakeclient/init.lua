
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString( "FakeClient" )
util.AddNetworkString( "FakeClientRequest" )

fakeClients = {}

net.Receive( "FakeClientRequest", function( len, ply )

  net.Start( "FakeClient" )
    net.WriteTable( fakeClients )
  net.Send( ply )

end)

gameevent.Listen( "player_connect" )
hook.Add( "player_connect", "ConnectFakeClient", function( data )
	table.insert( fakeClients, data )
end )

gameevent.Listen( "player_disconnect" )
hook.Add( "player_disconnect", "DisconnectFakeClient", function( data )
	for k, v in pairs( fakeClients ) do
    if v.userid == data.userid then
      table.RemoveByValue( fakeClients, v )
    end
  end
end )

hook.Add( "PlayerInitialSpawn", "RemoveFakeClient", function( ply )
  local userid = ply:UserID()
  for k, v in pairs( fakeClients ) do
    if v.userid == userid then
      table.RemoveByValue( fakeClients, v )
    end
  end
end)
