local meta = FindMetaTable( "Player" )
if (!meta) then
    Msg("ALERT! Could not hook Player Meta Table\n")
    return
end

function meta:SQLId()
	return self:AccountID()
end

function meta:ApplyData( data )
	if ( data.achivement == nil or data.achivement == "" ) then
		self._NewPlayer = true
	end

	if ( data.money ) then
		self:SetMoney( data.money )
	end

	timer.Simple( 0, function()
		if ( data.hat ) then
			Hats.SetWearable( self, data.hat, Hats.SLOT_HEAD )
		end
		
		if ( data.faceHat ) then
			Hats.SetWearable( self, data.faceHat, Hats.SLOT_FACE )
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

	if ( data.pvpweapons ) then
		PVPBattle.Load( self, data.pvpweapons )
	else
		PVPBattle.Load( self, "" )
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

	self._DataApplied = true
	hook.Run( "PlayerSQLApplied", self )
end
