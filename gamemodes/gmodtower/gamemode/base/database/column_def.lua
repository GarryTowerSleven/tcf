hook.Add( "DatabaseColumns", "BasicColumns", function()

    /*
        Global Basics
    */
    Database.Columns.Add( "money", {
        default = function( ply )
            ply:SetMoney( 0 )
        end,

        set = function( ply, val )
            ply:SetMoney( tonumber( val ) or 0 )
        end,
        get = function( ply )
            return math.Clamp( ply:Money(), 0, 2147483647 )
        end,
    } )

    Database.Columns.Add( "name", {
        get = function( ply )
            return ply:Nick()
        end,

        escape = true,
    } )

    Database.Columns.Add( "ip", {
        get = function( ply )
            return ply:DatabaseIP()
        end,
    } )

    Database.Columns.Add( "LastOnline", {
        get = function( ply )
            return os.time()
        end,
    } )

    Database.Columns.Add( "time", {
        default = function( ply )
            ply._PlayTime = 0
        end,

        set = function( ply, val )
            ply._PlayTime = tonumber( val ) or 0
        end,
        get = function( ply )
            return math.floor( ply._PlayTime + ply:TimeConnected() )
        end,
    } )

    /*
        Ballrace
    */
    Database.Columns.Add( "ball", {
        default = function( ply )
            if isfunction( SetBallId ) then
                SetBallId( ply, 1 ) 
            end
        end,

        set = function( ply, val )
            ply._PlyChoosenBall = val
        end,
        get = function( ply )
            return tonumber( ply._PlyChoosenBall ) or 1
        end,
    } )

    /*
        Hats
    */
    if Hats then
       
        Database.Columns.Add( "hat", {
            default = function( ply )
                Hats.SetWearable( ply, 0, Hats.SLOT_HEAD )
            end,
    
            set = function( ply, val )
                Hats.SetWearable( ply, tonumber( val ), Hats.SLOT_HEAD )
            end,
            get = function( ply )
                local slot1, _ = Hats.GetWearables( ply )

                return slot1 or 0
            end,
        } )
       
        Database.Columns.Add( "faceHat", {
            default = function( ply )
                Hats.SetWearable( ply, 0, Hats.SLOT_FACE )
            end,
    
            set = function( ply, val )
                Hats.SetWearable( ply, tonumber( val ), Hats.SLOT_FACE )
            end,
            get = function( ply )
                local _, slot2 = Hats.GetWearables( ply )

                return slot2 or 0
            end,
        } )
        
    end

    /*
        Inventory
    */
    if GTowerItems then

        Database.Columns.Add( "inventory", {
            default = function( ply )
                ply:LoadInventoryData( 0x0, 1 )
            end,
    
            set = function( ply, val )
                ply:LoadInventoryData( tostring( val ), 1 )
            end,
            get = function( ply )
                return ply:GetInventoryData( 1 )
            end,

            hex = true,
        } )

        Database.Columns.Add( "MaxItems", {
            default = function( ply )
                ply:SetMaxItems( GTowerItems.DefaultInvCount )
            end,
    
            set = function( ply, val )
                ply:SetMaxItems( tonumber( val ), true )
            end,
            get = function( ply )
                return ply:MaxItems()
            end,
        } )

        Database.Columns.Add( "bank", {
            default = function( ply )
                ply:LoadInventoryData( 0x0, 2 )
            end,
    
            set = function( ply, val )
                ply:LoadInventoryData( val, 2 )
            end,
            get = function( ply )
                return ply:GetInventoryData( 2 )
            end,

            hex = true,
        } )
       
        Database.Columns.Add( "BankLimit", {
            default = function( ply )
                ply:SetMaxBank( GTowerItems.DefaultBankCount )
            end,
    
            set = function( ply, val )
                ply:SetMaxBank( tonumber( val ), true )
            end,
            get = function( ply )
                return ply:BankLimit()
            end,
        } )
        
    end

    /*
        Store Related
    */
    if GTowerStore then

        Database.Columns.Add( "levels", {
            default = function( ply )
                GTowerStore:DefaultValue( ply )
            end,
    
            set = function( ply, val )
                GTowerStore:UpdateInventoryData( ply, val )
            end,
            get = function( ply )
                return GTowerStore:GetPlayerData( ply )
            end,

            hex = true,
        } )
        
    end

    if PVPBattle then

        Database.Columns.Add( "pvpweapons", {
            get = function( ply )
                return PVPBattle.Serialize( ply:GetPVPLoadout() )
            end,

            escape = true,
        } )

    end

    /*
        Achievements
    */
    if GTowerAchievements then

        Database.Columns.Add( "achivement", {
            default = function( ply )
                GTowerAchievements:Load( ply, 0x0 )
            end,
    
            set = function( ply, val )
                GTowerAchievements:Load( ply, val )
            end,
            get = function( ply )
                return GTowerAchievements:GetData( ply )
            end,

            hex = true,
        } )

    end

    /*
        Casino
    */
    if Cards then

        Database.Columns.Add( "chips", {
            default = function( ply )
                ply:SetPokerChips( 0 )
            end,
    
            set = function( ply, val )
                ply:SetPokerChips( tonumber( val ) or 0 )
            end,
            get = function( ply )
                return math.Clamp( ply:PokerChips(), 0, 2147483647 )
            end,
        } )

    end

    /*
        ClientSettings
    */
    if ClientSettings then

        Database.Columns.Add( "clisettings", {
            default = function( ply )
                ClientSettings:ResetValues( ply )
            end,
    
            set = function( ply, val )
                ClientSettings:LoadSQLSave( ply, val )
            end,
            get = function( ply )
                return ClientSettings:GetSQLSave( ply )
            end,

            hex = true,
        } )

    end

    /*
        Rooms
    */
    if GTowerRooms then
        
        Database.Columns.Add( "roomdata", {
            default = function( ply )
                ply._RoomSaveData = nil
            end,
    
            set = function( ply, val )
                Suite.SQLLoadData( ply, val )
            end,
            get = function( ply )
                local room = ply:GetRoom()

                if room then
                    return room:GetSQLSave()
                end
            end,

            // unimportant = true,
            hex = true,
        } )

    end

    /*
        Tetris
    */
    if tetrishighscore then

        Database.Columns.Add( "tetrisscore", {
            default = function( ply )
                tetrishighscore.Set( ply, 0 )
            end,
    
            set = function( ply, val )
                tetrishighscore.Set( ply, tonumber( val ) )
            end,
            get = function( ply )
                return tetrishighscore.Get( ply )
            end,
        } )

    end

end )