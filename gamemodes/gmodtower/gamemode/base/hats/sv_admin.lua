module( "HatAdmin", package.seeall )

function Send( ply, modelname, hatid )

    if not Hats.Admin( ply ) then return end

    local item = Hats.GetItem( tonumber( hatid ) )
    if not item then return end

    local data = Hats.Get( item.unique_Name, modelname )
    if not data then
        data = Hats.DefaultValue
    end

    net.Start( "HatAdm" )
        net.WriteUInt( hatid, 8 )
        net.WriteString( modelname )

        net.WriteFloat( data[1] )
        net.WriteFloat( data[2] )
        net.WriteFloat( data[3] )

        net.WriteFloat( data[4] )
        net.WriteFloat( data[5] )
        net.WriteFloat( data[6] )

        net.WriteFloat( data[7] or 1 )

        net.WriteUInt( data[8] or 1, 8 )
    net.Send( ply )

end

util.AddNetworkString( "HatAdm" )

concommand.Add( "gmt_hat_gethat", function( ply, _, args )
    
    if not Hats.Admin( ply ) then return end
    if not args[1] or not args[2] then return end

    Send( ply, args[1], args[2] )

end )

function Update( len, ply )

    if not Hats.Admin( ply ) then return end

    local HatID = net.ReadUInt( 8 )
	local ModelName = string.lower( net.ReadString() )

	local z = net.ReadFloat()
	local y = net.ReadFloat()
	local x = net.ReadFloat()

	local ap = net.ReadFloat()
	local ay = net.ReadFloat()
	local ar = net.ReadFloat()

	local sc = net.ReadFloat()

	local at = net.ReadUInt( 8 )

    local item = Hats.GetItem( HatID )
    if not item or not item.unique_Name then return end

    ply:Msg2( "Sending request to server..." )
    LogPrint( Format( "Request recevied from %s, updating...", ply:Nick() ), nil, "HatsAdmin" )

    local db = SQL.getDB()

    // this has to be like this until we refactor sql
    local q = db:prepare("DELETE FROM gm_hats WHERE id = ? AND plymodel = ?")
    q:setNumber( 1, HatID )
    q:setString( 2, ModelName )

    function q:onSuccess()
        
        local q2 = db:prepare("INSERT INTO gm_hats (id, plymodel, hat, vx, vy, vz, ap, ay, ar, scale) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);")
        q2:setNumber( 1, HatID )
        q2:setString( 2, ModelName )
        q2:setString( 3, string.lower( item.unique_Name ) )

        q2:setString( 4, tostring( x ) )
        q2:setString( 5, tostring( y ) )
        q2:setString( 6, tostring( z ) )

        q2:setString( 7, tostring( ap ) )
        q2:setString( 8, tostring( ay ) )
        q2:setString( 9, tostring( ar ) )

        q2:setString( 10, tostring( sc ) )

        function q2:onSuccess()
            ply:Msg2( Format( "Successfully updated hat \"%s\" for model \"%s\".", item.unique_Name, ModelName ) )
            LogPrint( Format( "Successfully updated hat \"%s\" for model \"%s\".", item.unique_Name, ModelName ), nil, "HatsAdmin" )
        
            if not Hats.Data[ ModelName ] then
                Hats.Data[ ModelName ] = {}
            end

            Hats.Data[ ModelName ][ string.lower( item.unique_Name ) ] = {
                x, y, z,
                ap, ay, ar,
                sc,
                at,
            }
        end

        function q2:onError(err)
            ply:Msg2( "Failed to update hat! Check server console." )
            LogPrint( Format( "Failed to update hat \"%s\" for model \"%s\": %s", item.unique_Name, ModelName, err ), color_red, "HatsAdmin" )
        end

        q2:start()

    end

    function q:onError(err)
        ply:Msg2( "Failed to delete hat! Check server console." )
        LogPrint( Format( "Failed to delete hat \"%s\" for model \"%s\": %s", item.unique_Name, ModelName, err ), color_red, "HatsAdmin" )
    end

    q:start()

end

net.Receive( "HatAdm", Update )

concommand.Add( "gmt_admsethatpos", function( ply, _, args )

    if not Hats.Admin( ply ) then return end
    if not args or not table.Count( args ) == 10 then return end

    Update( ply, args )

end )