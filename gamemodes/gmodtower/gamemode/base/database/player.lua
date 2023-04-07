local meta = FindMetaTable( "Player" )
if (!meta) then
    Msg("ALERT! Could not hook Player Meta Table\n")
    return
end

function meta:SQLId()
	if !self._GTSqlID then

		/*if !self.SteamID then
			debug.traceback()
			Error("Trying to get player steamid before player is created!")
		end

		local SteamId = self:SteamID()
		local Findings = {}

		for w in string.gmatch( SteamId , "%d+") do
			table.insert( Findings, w )
		end

		if #Findings == 3 then
			self._GTSqlID = (tonumber(Findings[3]) * 2) + tonumber(Findings[2])
		else
			if SteamId != "STEAM_ID_PENDING" && SteamId != "UNKNOWN" then
				SQLLog( 'error', "sql id could not be found (".. tostring(SteamId) ..")\n" )
			end
			return
		end*/

		self._GTSqlID = self:AccountID()

	end

	return self._GTSqlID
end

function meta:Money()
    return self:GetNet( "Money" ) or 0
end

function meta:SetMoney( amount )
	return self:SetNet( "Money", math.Clamp( tonumber( amount ), 0, 2147483647 ) )
end

function meta:AddMoney( amount, nosend, nobezier )
	function math.Fit2( val, valMin, valMax, outMin, outMax )
		return ( val - valMax ) * ( outMax - outMin ) / ( valMin - valMax ) + outMin
	end

	if amount == 0 then return end

    self:SetMoney( self:Money() + amount )

	if nosend != true then
		if amount > 0 then
			self:MsgI( "money", "MoneyEarned", string.FormatNumber( amount ) )

      local pitch = math.Clamp( math.Fit( amount, 1, 500, 90, 160 ), 90, 160 )
      self:EmitSound( "GModTower/misc/gmc_earn.wav", 50, math.ceil( pitch ) )

    if !nobezier then

      local ent = ents.Create("gmt_money_bezier")

      if IsValid( ent ) then
        ent:SetPos( self:GetPos() + Vector( 0, 0, -10 ) )
        ent.GoalEntity = self
        ent.GMC = amount
        ent.RandPosAmount = 50
        ent:Spawn()
        ent:Activate()
        ent:Begin()
      end
    end

		else
			self:MsgI( "moneylost", "MoneySpent", string.FormatNumber( -amount ))
	  local pitch = math.Clamp( math.Fit2( -amount, 1, 500, 90, 160 ), 90, 160 )
      self:EmitSound( "gmodtower/misc/gmc_lose.wav", 50, math.ceil( pitch ) )
		end
	end

end

function meta:GiveMoney( amount, nosend )
	self:AddMoney( amount, nosend )
end

function meta:Afford( price )
    return self:Money() >= price
end

function meta:IsBot()
	return IsValid(self) && self:SteamID() == "BOT"
end

function meta:ApplyData( data )
	if ( data.achivement == nil or data.achivement == "" ) then
		self:SetNWBool( "IsNewPlayer", true )
	end

	if ( data.money ) then
		self:SetMoney( data.money )
	end

	if ( data.plysize ) then
		GTowerModels.Set( self, tonumber( (data.plysize or 1) ) )
		self.OldPlayerSize = ( data.plysize or 1 )
	end

	timer.Simple( 0.0, function()
		if ( data.hat ) then
			GTowerHats.SetHat( GTowerHats, self, data.hat, 1 )
		end
		
		if ( data.faceHat ) then
			GTowerHats.SetHat( GTowerHats, self, data.faceHat, 2 )
		end
	end )


	if ( data.tetrisscore != "" ) then
		self._TetrisHighScore = data.tetrisscore
	end

	if ( data.achivement ) then
		GTowerAchievements:Load( self, tostring( data.achivement ) )
	end

	if ( data.clisettings ) then
		ClientSettings:LoadSQLSave( self, tostring( data.clisettings ) )
	end

	if ( data.inventory ) then
		self:LoadInventoryData( tostring( data.inventory ), 1 )
	end

	if ( data.bank ) then
		self:LoadInventoryData( tostring( data.bank ), 2 )
	end

	if ( data.pvpweapons != "" ) then
		PvpBattle:Load( self, data.pvpweapons )
	else
		PvpBattle:LoadDefault( self )
	end

	if ( data.levels != "" ) then
		GTowerStore:UpdateInventoryData( self, data.levels )
	else
		GTowerStore:DefaultValue( self )
	end

	if ( data.BankLimit != "" ) then
		self:SetMaxBank( data.BankLimit )
	else
		self:SetMaxBank( GTowerItems.DefaultBankCount )
	end

	hook.Run( "SQLApplied", self )
end