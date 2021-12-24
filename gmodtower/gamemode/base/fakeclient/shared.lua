module( "FakeClient", package.seeall )

DEBUG = false

function New( data )

	data.IsLoading = true

	if SERVER then
		data.admin = table.HasValue( Admins.List, data.networkid )
	end

	// Recreate a bunch of player functions
	data.GetName = function( self ) return self.name end
	data.Name = data.GetName
	data.GetSteamID = function( self ) return self.networkid end
	data.SteamID64 = function( self ) return self.networkid end
	data.GetIP = function( self ) return self.address end
	data.IsAdmin = function( self ) return self.admin end
	data.GetRespectName = function() return "" end
	data.GetTitle = function() return "" end
	data.GetDisplayTextColor = function() return Color( 150, 150, 150, 255 ) end
	data.IsHidden = function() return false end
	data.Ping = function() return 0 end
	data.IsMuted = function() return false end
	data.SetMuted = EmptyFunction
	data.ShowProfile = EmptyFunction
	data.Team = function() return 0 end
	data.Frags = function() return 0 end
	data.Deaths = function() return 0 end
	data.Alive = function() return true end
	data.IsValid = function() return true end
	data.GetModel = function() return GTowerModels.DefaultModel end
	data.LocationName = function() return "LOADING" end
	data.EntIndex = function() return 0 end
	data.SteamID = function() return 0 end
	data.UserID = function() return 0 end
	data.IsBot = function() return false end

	return data

end
