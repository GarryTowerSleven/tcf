AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.TriviaInstance = nil
ENT.Podiums = {}

ENT.QuestionData = nil

function ENT:Initialize()
	self:SetModel( "models/props_combine/breendesk.mdl" )

	self:PhysicsInit( SOLID_NONE )
	self:SetNoDraw( true )

	self:SetupTrivia()
	// self:SpawnPodiums()
end

function ENT:GetRecipients()
	return Location.GetPlayersInLocation( self:Location() )
end

function ENT:SetupTrivia()
	self.TriviaInstance = trivia.New()

	self.TriviaInstance:setConfig( "question_count", self.QuestionCount )

	self.TriviaInstance:onEvent("token", 
		function( token )
			self:OnToken( token )
		end )

	self.TriviaInstance:onEvent("questions", 
		function( data )
			self:OnQuestions( data )
		end )
end

function ENT:AddPodium( ent )
	ent:SetController( self )
	ent.Controller = self

	ent:SetID( table.Count( self:GetPodiums() ) + 1 )
	table.insert( self.Podiums, ent )

	self:SortPodiums()
end

function ENT:SpawnPodiums()
	for i = 1, self.PlayerCount do
		local ent = ents.Create( self.ChildClass )
		ent:SetAngles( self:GetAngles() + Angle( 25, 0, 0 ) )
		ent:SetPos( self:GetPos() + ( (self:GetForward() * 80) * ((i%2 != 0) and i or i-1) ) + (self:GetForward() * 50) + ( (self:GetRight() * 150) * (i%2) ) - (self:GetRight() * 75) )

		ent:DropToFloor()
		ent:SetPos( ent:GetPos() + (ent:GetUp() * -10) )

		ent:Spawn()
		self:AddPodium( ent )
	end
end

function ENT:OnToken( token )
	if ( not token or token == "" ) then
		self:ThrowError( trivia.ERROR_TOKEN )
		return
	end

	self.TriviaInstance:getQuestions()
end

function ENT:OnQuestions( questions )
	if ( not questions or table.IsEmpty( questions ) ) then
		self:ThrowError( trivia.ERROR_QUESTION )
		return
	end

	self.QuestionData = questions

	for k, v in ipairs( self.QuestionData ) do
		local choices = {}

		if ( v.type == "boolean" ) then
			choices = { "True", "False" }
		else
			table.Add( choices, v.incorrect_answers )
			table.insert( choices, v.correct_answer )

			table.Shuffle( choices )
		end

		self.QuestionData[k].choices = choices
	end
	
	self:SetLoading( false )

	self:StartRound()
end

function ENT:SetTimer( time )
	self:SetStartTime( CurTime() )
	self:SetTime( CurTime() + time )
end

function ENT:NextQuestion()
	self:SetQuestion( self:GetQuestion() + 1 )
end

function ENT:StartGame()
	self:SetLoading( true )
	self.TriviaInstance:refreshToken()
end

function ENT:GetQuestionInfo( num )
	return self.QuestionData[ num or self:GetQuestion() ]
end

function ENT:GetChoice( num )
	return self:GetQuestionInfo().choices[num]
end

function ENT:GetAnswer()
	return self:GetQuestionInfo().correct_answer
end

function ENT:ThrowError( code )
	trivia.log.error( "%s has failed! Code: %s", tostring( self ), code )

	self:EndGame()
	self:SetLoading( false )

	self:SetErrorTime( CurTime() + self.ErrorTimeout )
	self:SetErrorCode( code or 0 )
	self:SetError( true )
end

function ENT:ClearError()
	self:SetError( false )
	self:SetErrorCode( 0 )
	self:SetErrorTime( 0 )
end

function ENT:StartRound()
	self:NextQuestion()

	self:SetState( trivia.STATE_PLAY )
	self:SetTimer( self.RoundTime )

	self:ResetPodiums()

	self:NetworkRound()
end

function ENT:ResetPodiums()
	for _, v in ipairs( self:GetPodiums() ) do
		v:Clear()
	end
end

function ENT:NetworkRound( ply )
	local q = self:GetQuestionInfo()

	net.Start( "trivia.Round" )
		net.WriteEntity( self )

		net.WriteString( q.question )
		net.WriteString( q.category )
		net.WriteString( q.difficulty )

		local choices = q.choices

		net.WriteUInt( table.Count( choices ), 3 )

		for k, v in pairs( choices ) do
			net.WriteUInt( k, 3 )
			net.WriteString( v )
		end
	net.Send( ply or self:GetRecipients() )
end

function ENT:StartIntermission()
	self:CheckAnswers()

	self:SetState( trivia.STATE_INTERMISSION )
	self:SetTimer( self.IntermissionTime )

	self:NetworkIntermission()
end

function ENT:NetworkIntermission( ply )
	net.Start( "trivia.Intermission" )
		net.WriteEntity( self )

		local q = self:GetQuestionInfo()

		net.WriteUInt( table.KeyFromValue( q.choices, q.correct_answer ) or 0, 3 )
	net.Send( ply or self:GetRecipients() )
end

/*function ENT:NetworkPodiums( ply )
	local podiums = self:GetPodiums()

	net.Start( "trivia.Podiums" )
		net.WriteEntity( self )

		net.WriteUInt( table.Count( podiums ), 6 )

		for _, v in ipairs( podiums ) do
			net.WriteEntity( v )
		end
	net.Send( ply )
end*/

function ENT:NetworkCurrent( ply )
	if ( self:GetState() == trivia.STATE_PLAY or self:GetState() == trivia.STATE_INTERMISSION ) then
		self:NetworkRound( ply )
	end

	if ( self:GetState() == trivia.STATE_INTERMISSION ) then
		self:NetworkIntermission( ply )
	end
end

function ENT:EndGame()
	if ( self:GetState() == trivia.STATE_IDLE ) then return end

	for _, v in ipairs( self:GetPodiums() ) do
		v:RemoveContestant()
		v:Clear( true )
	end

	self:SetState( trivia.STATE_IDLE )
	self:SetTime( 0 )
	self:SetQuestion( 0 )

	self.QuestionData = nil
end

function ENT:CheckAnswered()
	local podiumns = self:GetActivePodiums()
	
	local allSelected = true

	for _, v in ipairs( podiumns ) do
		if ( not v:GetAnswered() ) then
			allSelected = false
			break
		end
	end

	if ( allSelected ) then
		self:SetTimer( 0 )
	end
end

ENT.PointBonus = {
	[trivia.DIFFICULTY_EASY] = 0.5,
	[trivia.DIFFICULTY_MEDIUM] = 1.0,
	[trivia.DIFFICULTY_HARD] = 1.5,
}

function ENT:CalculatePoints( timeRemaining, difficulty )
	local multiplier = self.PointBonus[ difficulty ] or 1

	local timeLeft = self.RoundTime - timeRemaining

	local ratio = timeLeft < self.SafeZone and 1 or timeRemaining / (self.RoundTime - self.SafeZone)
	ratio = math.Clamp( ratio, 0.5, 1 )

	local points = math.floor( ( (self.BasePoints * multiplier) * ratio ) / 5 ) * 5

	return points
end

function ENT:CheckAnswers()
	local podiums = self:GetActivePodiums()
	local q = self:GetQuestionInfo()

	for _, v in ipairs( podiums ) do
		//trivia.log.info( "self:CheckAnswers %s %s", self, v:GetPlayer() )
		
		if ( not v:GetAnswered() ) then			
			local choice = table.Random( q.incorrect_answers )

			v:MakeChoice( table.KeyFromValue( q.choices, choice ) or 1 )
		end

		v:SetChoice( v.Choice )
		
		if ( v:IsCorrect() ) then
			v:GivePoints( self:CalculatePoints( v.ChoiceTimeLeft, q.difficulty ) )
			v:SetCorrect( true )
			v:SetNumCorrect( v:GetNumCorrect() + 1 )
			//v:SetStreak( v:GetStreak() + 1 )
		//else
			//v:SetStreak( 0 )
		end
	end
end

function ENT:StartEnd()
	self:SetState( trivia.STATE_END )
	self:SetTimer( self.EndTime )

	self:Payout()
end

function ENT:Payout()
	local winner = self:GetWinner()
	for _, v in ipairs( self:GetActivePodiums() ) do
		if ( v:GetPoints() < 5 ) then
			v:GetPlayer():SetAchievement( ACHIEVEMENTS.TRIVIADUNCE, 1 )
			continue 
		end

		local gmc = math.floor( v:GetPoints() / 5 )

		if ( v:GetNumCorrect() == self.QuestionCount ) then
			v:GetPlayer():SetAchievement( ACHIEVEMENTS.TRIVIABRAINIAC, 1 )
		end
		
		if ( v == winner ) then
			gmc = gmc + 100

			local sfx = EffectData()
			sfx:SetOrigin( v:GetPlayer():GetPos() + Vector( 0, 0, 50 ) )

			util.Effect( "confetti", sfx, true, true )

			v:GetPlayer():EmitSound( self.WinSound, 60 )
			v:GetPlayer():AddAchievement( ACHIEVEMENTS.TRIVIAREALLY, 1 )
		end

		v:GetPlayer():GiveMoney( gmc )
	end
end

function ENT:Think()
	if ( self:GetError() and self:GetErrorTime() > 0 ) then
		if ( self:GetErrorTime() < CurTime() ) then
			self:ClearError()
		end

		return
	end

	local count = self:ContestentCount()
	self:SetPlayerCount( count )

	//trivia.log.info( "STATE=%s; LOADING=%s; TIME=%s; PLYCOUNT=%s; QUESTION=%s;", self:GetState(), self:GetLoading(), math.floor( self:GetTime() - CurTime() ), count, self:GetQuestion() )
	//trivia.log.info( "STATE=%s; TIME=%s;", self:GetState(), math.floor( self:GetTime() - CurTime() ) )

	if ( count <= 0 ) then
		self:EndGame()
	end

	if ( self:GetLoading() ) then
		return
	end

	if ( self:GetState() == trivia.STATE_IDLE ) then
		if ( self:PlayersNeeded() <= 0 ) then
			self:SetState( trivia.STATE_WAITING )
			self:SetTimer( self.WaitingTime )
		end

		return
	end

	if ( self:GetState() == trivia.STATE_WAITING ) then
		if ( self:PlayersNeeded() > 0 ) then
			self:SetState( trivia.STATE_IDLE )
		end

		if ( self:NoTime() ) then
			self:StartGame()
		end
	end

	if ( self:GetState() == trivia.STATE_PLAY ) then
		if ( self:NoTime() ) then
			self:StartIntermission()
		end
	end

	if ( self:GetState() == trivia.STATE_INTERMISSION ) then
		if ( self:NoTime() ) then
			if ( self:GetQuestion() < self.QuestionCount ) then
				self:StartRound()
			else
				self:StartEnd()
			end
		end
	end

	if ( self:GetState() == trivia.STATE_END ) then
		if ( self:NoTime() ) then
			self:EndGame()
		end
	end
end

function ENT:OnRemove()
	self.TriviaInstance = nil

	for _, v in ipairs( self:GetPodiums() ) do
		v:Remove()
	end
end

hook.Add( "Location", "NetworkTrivia", function( ply, loc, lastloc )
	if ( Location.GetGroup( loc ) == Location.GetGroup( lastloc ) ) then return end

	local trivias = ents.FindByClass( "gmt_trivia_base" )

	for _, v in ipairs( trivias ) do
		if ( v:LocationGroup() != Location.GetGroup( loc ) ) then return end

		v:NetworkCurrent( ply )
	end
end )

hook.Add( "Location", "TriviaKick", function( ply, loc, lastloc )
	local p = ply:GetNet( "TriviaPodium" )

	if ( IsValid( p ) ) then
		if ( p:Location() != loc ) then
			p:RemoveContestant()
			ply:Msg2( "You've been removed from Trivia for moving too far from your podium." )
		end
	end
end )

hook.Add( "PlayerThink", "TriviaKick", function( ply )
	local p = ply:GetNet( "TriviaPodium" )

	if ( IsValid( p ) ) then
		if ( not ply:Alive() ) then
			p:RemoveContestant()
			// ply:Msg2( "You've been removed from Trivia." )
		end
	end
end )

util.AddNetworkString( "trivia.Podiums" )

util.AddNetworkString( "trivia.Round" )
util.AddNetworkString( "trivia.Intermission" )
util.AddNetworkString( "trivia.End" )

util.AddNetworkString( "trivia.Join" )
util.AddNetworkString( "trivia.Leave" )
util.AddNetworkString( "trivia.Choice" )