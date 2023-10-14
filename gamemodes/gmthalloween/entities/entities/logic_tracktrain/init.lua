ENT.Base = "base_point"
ENT.Type = "point"

ENT.Carts = {}

function ENT:Initialize()

    self:SetupCarts()

    timer.Simple( 5, function()
    
        for k, v in ipairs( self:GetCarts() ) do
        
            print( k, v, v.Seats )
            PrintTable( v.Seats )
    
        end

    end )

end

function ENT:TrainNumber( train )
    return tonumber( ( train:GetName() or "" ):sub( -1 ) ) or 1
end

function ENT:FindCarts()

    local carts = {}

    for _, v in ipairs( ents.FindByClass( "func_tracktrain" ) ) do
        if string.StartsWith( v:GetName(), "hr_tracktrain" ) then
            table.insert( carts, v )
        end
    end

    table.sort( carts, function( a, b )
        return self:TrainNumber( a ) < self:TrainNumber( b )
    end )

    return carts

end

function ENT:SetupCarts()

    local carts = self:FindCarts()

    for k, v in ipairs( carts ) do

        self.Carts[ k ] = v

        /*self.Carts[ k ] = {
            active = false,

            entity = v,
            seats = {},
        }*/
        
    end

end

function ENT:GetCarts()
    return self.Carts
end

function ENT:GetAvailableCart()

end

function ENT:StartRide()

    local carts = self:GetCarts()

    for _, v in ipairs( carts ) do
        self:Input( "StartForward", v, self )
    end

end

function ENT:AcceptInput( name, activator, caller, data )

    print( name, activator, caller, data )

    if name == "StartForward" then

        /*local trains = self:GetTrains()

        for _, v in ipairs( trains ) do

            v:Input( "StartForward", self, self )

        end*/

        print( activator, self:TrainNumber( activator ) )
        activator:Input( "StartForward", self, self )
        
    elseif name == "Stop" then

        activator:Input( "Stop", self, self )
        
    elseif name == "TeleportToPathTrack" then
        
        activator:Input( "TeleportToPathTrack", self, self, data )

    end

end

function ENT:KeyValue( key, value )

    if key == "targetname" then
        self:SetName( value )
    end

end