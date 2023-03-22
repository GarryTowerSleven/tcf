local L = GtowerLangush

L.AddLang( 1, "English")

L.AddWord( 1, "Inventory",	"Inventory")

L.AddWord( 1, "yes",	"Yes")
L.AddWord( 1, "no",		"No")
L.AddWord( 1, "upgrade",		"Buy {1}")
L.AddWord( 1, "unknown",	"Unknown")
L.AddWord( 1, "accept",	"Accept")
L.AddWord( 1, "decline",	"Decline")
L.AddWord( 1, "closeall",	"Close All")
L.AddWord( 1, "checkout",	"Checkout")
L.AddWord( 1, "cleanup",	"Clean Up")
L.AddWord( 1, "cancel",	"Cancel")

L.AddWord( 1, "bye",	"Bye")

L.AddWord( 1, "PleaseFullGtowerPack",	"omgmac")

L.AddWord( 1, "empty_bottle",		"Empty Bottle")
L.AddWord( 1, "empty_bottle_desc",		"Contains absolutely nothing.  Or does it?  You can't be sure until you break it open.")
L.AddWord( 1, "alcohol_bottle",		"Bottle of Alcohol")
L.AddWord( 1, "alcohol_bottle_desc",	"This bottle contains alcohol. Handle with care.")

L.AddWord( 1, "send_trade_request",		"Your trade request has been sent to {1}.")
L.AddWord( 1, "send_trade_recive",		"{1} wants to trade with you.")
L.AddWord( 1, "send_trade_declined",	"{1} has declined your trade.")
L.AddWord( 1, "send_trade_timeout",		"{1} did not respond to your trade.")
L.AddWord( 1, "trade_friend_accept",	"{1}'s acceptance.")

L.AddWord( 1, "send_trade_cancel",	"{1} has cancelled the trade.")
L.AddWord( 1, "trade_suceful",	"Trade successful.")

L.AddWord( 1, "trade_you_space",	"You do not have enough space in your inventory - trade failed." )
L.AddWord( 1, "trade_him_space",	"{1} does not have enough space in their inventory - trade failed.")


L.AddWord( 1, "trade_has_accepted",		"{1} accepted." )
L.AddWord( 1, "trade_hasnot_accepted" ,	"{1} has not accepted.")
L.AddWord( 1, "trade_trading_with" ,	"Trading with {1}...")
L.AddWord( 1, "trade_alredy_trading",	"{1} is currently trading." )
L.AddWord( 1, "trade_IamAlredyTrading",	"You are currently trading." )


L.AddWord( 1, "trade_denied",	"Trading is not allowed here.")
L.AddWord( 1, "not_enough_money",	"You do not have enough money.")


// === SUITE ===
L.AddWord( 1, "vacant",						"Vacant")
L.AddWord( 1, "RoomRoomsAvalible",			"Greetings, {1}. There are currently <font=GTowerbigbold>{2}</font> available suite(s).   Do you wish to check-in?")
//L.AddWord( 1, "RoomNotAvalible",			"Greetings, {1}. We're sorry, there are no available suites at this time. Do you want to be added to the waiting list? There's currently <font=GTowerbigbold>{2}</font> player(s) in the waiting list.")
L.AddWord( 1, "RoomNotAvalible",			"Greetings, {1}. We're sorry, there are no available suites at this time.")
L.AddWord( 1, "RoomNotAvalibleEnts",		"Greetings, {1}. We're sorry, there are no available suites at this time due to entity limits.")
L.AddWord( 1, "RoomWait",					"Please wait while I setup your suite.")

L.AddWord( 1, "RoomLongAway",				"You have been away from your suite for {1} minute(s). You have been checked-out.")
L.AddWord( 1, "RoomAFKAway",				"You have been checked-out of your suite for being AFK for {1} minute(s).")

L.AddWord( 1, "RoomGet",					"Thank you for staying at GMod Tower.\nI will assign you suite <font=GTowerbigbold><color=white>#{1}</color></font>.\nIf you need any assistance with your suite, please contact local administrators or moderators. Talk to me when you wish to check-out.")
L.AddWord( 1, "RoomGetSmall",				"You have been assigned to suite #{1}.")
L.AddWord( 1, "RoomDeny",					"Alright. Please come back later.")

L.AddWord( 1, "RoomReturn",					"Hello again, {1}.  Would you like to check-out?")
L.AddWord( 1, "RoomReturnYes",				"I hope you enjoyed your stay at GMod Tower. Please come back later.")
L.AddWord( 1, "RoomWaitingListAdd",			"Alright. I've added you to the waiting list. I will message you when the next available suite is ready.")
L.AddWord( 1, "RoomWaitingListAddReturn",	"Alright. You're still on the list. I will message you when the next available suite is ready.")
L.AddWord( 1, "RoomWaitingListReturn",		"Hello again, {1}. You're currently in the waiting list, position #<font=GTowerbigbold>{2}</font>. Do you wish to stay in the list? Remember, I will message you when the next available suite is ready.")
L.AddWord( 1, "RoomWaitingListReady",		"[Suite Lady] Hello, just letting you know your suite is available. Do you want to be moved up to me? I'll check you in instantly.")
L.AddWord( 1, "RoomWaitingListAdded",		"[Suite Lady] You have been added to the waiting list. Position: #{1}")
L.AddWord( 1, "RoomWaitingListWasAdded",	"[Suite Lady] You are already on the waiting list. Position: #{1}")
L.AddWord( 1, "RoomWaitingListRemoved",		"[Suite Lady] You have been removed from the waiting list.")

L.AddWord( 1, "RoomReturnNo",				"Alright. I'm glad you're enjoying your suite. Please talk to me when you wish to check-out.")
L.AddWord( 1, "RoomCleanUp",				"This will reset your suite to its original form. All items in your suite will be moved into your trunk.")
L.AddWord( 1, "RoomCleanUpConfirm",			"ARE YOU ABSOLUTELY SURE? THIS WILL COMPLETELY RESET YOUR SUITE! All items in your suite will be moved into your trunk!")
L.AddWord( 1, "RoomCleanedUp",				"Clean up completed. All items in your suite have been moved into your trunk.")
L.AddWord( 1, "RoomCleanedUpNoItems", 		"Clean up completed. However, there were no items that needed to be moved.")

L.AddWord( 1, "RoomUpgrade",				"Upgrade your suite.")
L.AddWord( 1, "RoomDoWantUpgrade",			"Do you wish to upgrade {1} to level {2}?")
L.AddWord( 1, "RoomNotEnoughMoney",			"You do not have enough money to upgrade {1}.")
L.AddWord( 1, "RoomInventoryOwnRoom",		"You are only allowed to use this in your own suite.")
L.AddWord( 1, "RoomKickPlayers",			"Kick All Guests")
L.AddWord( 1, "RoomManagePlayers",			"Manage Guests")

L.AddWord( 1, "RoomNotOwner",				"This is not your suite.")
L.AddWord( 1, "RoomItemNotOwner",			"You cannot use this item: this is not your suite.")
L.AddWord( 1, "RoomCheckedOut",				"You have been checked out of your suite.")
L.AddWord( 1, "RoomAdminDisabled",			"Admins have disabled your ability to have a suite.")
L.AddWord( 1, "RoomAdminRemoved",			"An admin has removed you from your suite.")
L.AddWord( 1, "RoomMaxEnts",				"You cannot have more than {1} items in your suite.")
L.AddWord( 1, "RoomRemovedFrom",			"You have been removed from {1}'s locked suite.")
L.AddWord( 1, "RoomRemovedPlayer",			"{1} was removed from your locked suite.")
L.AddWord( 1, "RoomBannedFrom",				"You are banned from {1}'s suite.")
L.AddWord( 1, "RoomBannedPlayer",			"{1} was removed from your suite due to being banned.")
L.AddWord( 1, "RoomKickedFrom",				"You have been kicked out of {1}'s suite.")
L.AddWord( 1, "RoomKickedPlayer",			"{1} was kicked out of your suite.")
L.AddWord( 1, "RoomBanFrom",				"You have been banned from {1}'s suite.")
L.AddWord( 1, "RoomBanPlayer",				"{1} was banned from your suite. Getting a new suite will clear this ban.")
L.AddWord( 1, "RoomClearedBans",			"Cleared all suite bans.")
L.AddWord( 1, "RoomKickedAll",				"Kicked everyone out of your suite.")

L.AddWord( 1, "RoomOwnerBroke",				"You're not the suite owner.")
L.AddWord( 1, "RoomRadioWrongID",			"This radio's suite ID is {1}. Yours is {2}.")


// === SUITE PARTY ===
L.AddWord( 1, "RoomStartParty",				"This radio's suite ID is {1}. Yours is {2}." )
L.AddWord( 1, "RoomPartyLock",				"You cannot lock your suite while you are throwing a party." )
L.AddWord( 1, "RoomPartyFailedDelay",		"You cannot throw another party for {1} minutes." )
L.AddWord( 1, "RoomPartyFailedNoSuite",		"You cannot start a party if you don't have a suite!" )
L.AddWord( 1, "RoomPartyFailedMoney",		"You cannot afford to start a party!" )
L.AddWord( 1, "RoomPartyEnd",				"You have ended your suite party." )
L.AddWord( 1, "RoomPartyEnded",				"Your suite party has ended." )
L.AddWord( 1, "RoomPartyMainMessage",		"{1} is throwing a Party in suite #{2}!" )
L.AddWord( 1, "RoomPartyActivityMessage",	"There will be {1}!" )
L.AddWord( 1, "RoomPartyDesc",				"You can start a party for {1} GMC.\n" ..
						  					"This will announce to everyone on the server and provide a teleport to your suite. Parties can last up to {2} minutes.\n\n" ..
						  					"If you leave your suite or lock your suite, the party will end.\n\n" ..
						  					"Select what will be part of your party:" )

L.AddWord( 1, "Group_menu",			"Group")
L.AddWord( 1, "Group_makeowner",		"Set as Group Leader")
L.AddWord( 1, "Group_removegroup",		"Kick from Group")
L.AddWord( 1, "Group_inviteroup",		"Invite to Group")
L.AddWord( 1, "Group_newownermakesure",	"Are you sure you want to set {1} as the group leader?")
L.AddWord( 1, "Group_younewowner",		"You are now the leader of the group.")
L.AddWord( 1, "Group_himnewowner",		"{1} is now the leader of the group.")

L.AddWord( 1, "GroupInvite",		"{1} has invited you to their group.")
L.AddWord( 1, "GroupDeny",		"{1} has denied your request.")
L.AddWord( 1, "Group_target_no_group",	"{1} is no longer in a group.")
L.AddWord( 1, "Group_full",			"The group is full.")
L.AddWord( 1, "Group_already_in_group",	"You are already in a group.")
L.AddWord( 1, "Group_he_already_in_group",	"{1} is already in a group.")
L.AddWord( 1, "Group_invite_send",		"You have asked {1} to join your group.")
L.AddWord( 1, "Group_leave",		"Leave Group")
L.AddWord( 1, "Group_leavesure",		"Are you sure you want to leave your group?")


L.AddWord( 1, "Group_setting_sizeName",		"Size of group health bars.")
L.AddWord( 1, "Group_setting_borderName",		"Distance between each group members' Name.")
L.AddWord( 1, "Group_setting_alignName",		"List group vertically.")
L.AddWord( 1, "Group_setting_positionName",		"Posistion of group list.")
L.AddWord( 1, "Group_setting_avatarsizeName",	"Group member avatar size.")
L.AddWord( 1, "Group_setting_allborderName",	"Distance from edge of screen.")


L.AddWord( 1, "gui_setting_Name",		"Health/Ammo Bar")
L.AddWord( 1, "gui_setting_ammosize",	"Ammo bar size.")
L.AddWord( 1, "gui_setting_ammox",		"Ammo horizontal offset.")
L.AddWord( 1, "gui_setting_ammoy",		"Ammo vertical offset.")
L.AddWord( 1, "gui_setting_healthx",	"Health hortizontal offset.")
L.AddWord( 1, "gui_setting_healthy",	"Health vertical offset.")
L.AddWord( 1, "gui_setting_chatwidth",	"Chat box width.")
L.AddWord( 1, "gui_setting_instant",	"Instant GUI animation transitions.")

L.AddWord( 1, "RadioTurnedOff",		"Radio Off")
L.AddWord( 1, "RadioPlaying",		"Playing")
L.AddWord( 1, "RadioLoading",		"Loading...")
L.AddWord( 1, "RadioUnsupportedFormat",	"Stream using bad format.")
L.AddWord( 1, "RadioTimeout",		"Stream timed out.")
L.AddWord( 1, "RadioBASSInitError",		"BASS initialization error; reconnect.")
L.AddWord( 1, "RadioUnknown",		"Stream gave unknown error.")

L.AddWord( 1, "JukeBoxTurnedOff",		"Jukebox Off (5 GMC per choice)")
L.AddWord( 1, "JukeBoxNotEnoughMoney",	"You cannot afford to change the jukebox.")

L.AddWord( 1, "MenuReportAdmin",	"Report to Admin")
L.AddWord( 1, "MenuInformation",	"Information")
L.AddWord( 1, "MenuTrade",		"Trade")

L.AddWord( 1, "StoreNoSlots",	"You do not have enough inventory slots.")
L.AddWord( 1, "StoreNotEnoughMoney",	"You cannot afford this item.")
L.AddWord( 1, "StorePurchased",	"You've just bought ''{1}''.")
L.AddWord( 1, "StoreConfirmUpgrade",	"Are you sure you want to upgrade the ''{1}'' for {2} GMC?")
L.AddWord( 1, "StoreConfirmPurchase",	"Are you sure you want to buy ''{1}'' for {2} GMC?")
L.AddWord( 1, "StoreUniqueOwned",			"You already own this unique item.")
L.AddWord( 1, "StoreVIPOnly",				"You must be a VIP to purchase from this store!")

L.AddWord( 1, "BankFull",	"There isn't enough space in your bank.")
L.AddWord( 1, "InventoryTooFar",	"It's too far away.")

L.AddWord( 1, "BackpackShouldEquip",	"You should equip backpack before using it.")

L.AddWord( 1, "AchievementsGot",			"Congratulations! You've just achieved: {1}.")
L.AddWord( 1, "AchievementsTrophyGot",		"You got the {1}. It has been placed in your trunk.")
L.AddWord( 1, "AchievementsTrophyFailed",	"Oops, a mistake was made. Your trophy was not given. Please rejoin the server.")

L.AddWord( 1, "MoneyEarned",	"You've earned {1} GMC.")
L.AddWord( 1, "MoneySpent",	"You've spent {1} GMC.")
L.AddWord( 1, "MoneyRefund",				"You were refunded {1} GMC because the server crashed/restarted.")

L.AddWord( 1, "GamemodeFull",	"Sorry, {1} is full.")

L.AddWord( 1, "AdminNot",	"You are not an admin!")
L.AddWord( 1, "AfkTimer",					"AFK TIMER  |  {1} SECONDS")
L.AddWord( 1, "AfkTimerMessage",			"YOU ARE AFK. YOU WILL NOT RECIEVE GMC!")
L.AddWord( 1, "AfkTimerMessageShort",		"YOU ARE AFK.")
L.AddWord( 1, "AfkKickMessage",			"{1} has automatically forfeited due to being AFK.")
L.AddWord( 1, "AfkBecome",					"{1} is now AFK.")
L.AddWord( 1, "AfkBack",					"{1} is no longer AFK.")

L.AddWord( 1, "EventMiniStart",	"Event System has started minigame: {1}.")
L.AddWord( 1, "EventMiniEnd",	"Event System has ended minigame: {1}.")
L.AddWord( 1, "EventSetSale",	"Event System has set the {1} on sale!")
L.AddWord( 1, "EventEndSale",	"Event System has ended the sale on the {1}.")
L.AddWord( 1, "EventError",		"Something is terribly wrong with event system! Tell an admin about this!")
L.AddWord( 1, "EventEndingTime", "Event will end in {1}!")
L.AddWord( 1, "EventNextEventTime", "Be ready, we have random events every half an hour!")
L.AddWord( 1, "EventNoEvent", "Sorry, there will be no event!")
L.AddWord( 1, "EventNeedMorePlayers", "Event skipped, need more players (10)!")
L.AddWord( 1, "EventAdminDisabled", "{1} has disabled the event system.")
L.AddWord( 1, "EventAdminEnabled", "{1} has enabled the event system.")
L.AddWord( 1, "EventAdminManual", "{1} has forced the event system.")

L.AddWord( 1, "AuctionStarted", "Auction started! Place a bet like this: !bet 5000")
L.AddWord( 1, "AuctionCurrentBet", "Current bet: {1} GMC by {2}")
L.AddWord( 1, "AuctionStartedItem", "New lot: {1}. Starting price: {2}. Please check if you have free space in inventory before joining.")
L.AddWord( 1, "AuctionSold", "{1} sold to {2} for {3} GMC!")
L.AddWord( 1, "AuctionEnded", "Auction ended!")
L.AddWord( 1, "AuctionNoInventorySpace", "{1} don't have space in inventory! He gets 50% of {2} price!")


// === ADMIN ===
L.AddWord( 1, "AdminMiniStart",	"{1} has started a minigame: {2}.")
L.AddWord( 1, "AdminMiniEnd",	"{1} has ended a minigame: {2}.")
L.AddWord( 1, "AdminClrDecals",	"{1} has cleared all decals.")
L.AddWord( 1, "AdminClrSounds",	"{1} has stopped all sounds.")
L.AddWord( 1, "AdminClrStreams", "{1} has removed all streams.")
L.AddWord( 1, "AdminResetEnts", "{1} has reset all the objects (excluding suites).")
L.AddWord( 1, "AdminStartStream", "{1} has started a music stream.")
L.AddWord( 1, "AdminSetSale",	"{1} has set the {2} on sale for {3}% off!")
L.AddWord( 1, "AdminEndSale",	"{1} has ended the sale on the {2}.")
L.AddWord( 1, "AdminSetSaleAll", "{1} has set EVERY STORE on sale for {2}% off!")
L.AddWord( 1, "AdminEndSaleAll", "{1} has ended the sale on EVERY STORE.")
L.AddWord( 1, "AdminRagdoll",	"{1} has ragdolled you!")
L.AddWord( 1, "AdminRagdollA",	"You've ragdolled {1}!")
L.AddWord( 1, "AdminSetMoney",	"An admin ({1}) has set your money to {2}.")
L.AddWord( 1, "AdminGiveMoney",	"{1} has {2} {3} GMC.")
//L.AddWord( 1, "AdminNot",	"You are not an admin!")


// === MINIGAMES ===
L.AddWord( 1, "MiniPlaneGameStart",	"Planes have gone wild in {1}!")
L.AddWord( 1, "MiniBattleGameStart",	"A crazy {1} has started in the {2}!")
L.AddWord( 1, "MiniStoreGameStart",	"There is a {1}% sale at the {2}!")
L.AddWord( 1, "MiniBalloonGameStart",	"Shoot all the balloons in the Central Plaza!")
L.AddWord( 1, "MiniObamaGameStart",	"The Obama cutouts are spreading in the suites! Smash them all!")
L.AddWord( 1, "MiniNoScale",	"You cannot use potions while in a minigame!")
L.AddWord( 1, "MiniNext",	"Starting next event in {1} minutes.")
L.AddWord( 1, "FunMeterStart",	"Fun meter is now activated. Have fun and raise the meter in the Lobby!")
L.AddWord( 1, "FunMeterEnd",	"Fun meter is now deactivated. Continue on your way.")


// === PLAYER MODEL ===
L.AddWord( 1, "PlayerModelUpdated",	"Your player model has been updated.")
L.AddWord( 1, "PlayerModelUpdatedLater",	"Your player model will be updated on next spawn.")


// === HATS ===
L.AddWord( 1, "HatUpdated",	"You are now wearing the {1}.")
L.AddWord( 1, "HatNone",	"You are no longer wearing a hat.")
L.AddWord( 1, "HatFaceNone",	"You are no longer wearing a face hat.")
L.AddWord( 1, "HatNotPurchased",	"You have not purchased this hat.")


// === CHAT ===
L.AddWord( 1, "ChatTooFast",	"Slow down!")
L.AddWord( 1, "ChatCommandTooFast",	"Please wait between commands.")
L.AddWord( 1, "ChatGagged",	"You have been chat gagged. Your chat was not sent on the public channel.")


// === MAP CHANGE ===
L.AddWord( 1, "AdminRestartMap",	"Restarting map for update...")
L.AddWord( 1, "AdminRestartMapSec",	"Restarting map for update in {1} seconds...")
L.AddWord( 1, "AdminChangeMap",	"Changing map to {1}...")
L.AddWord( 1, "AdminChangeMapSec",	"Changing map to {1} in {2} seconds...")
L.AddWord( 1, "AutoRestartMap",	"GMod Tower will be restarted in {1} minutes. Your items and stats will be saved.")
L.AddWord( 1, "FailedMapChange",	"You cannot change levels while there is poker or duel going. Use gmt_forcelevel to override this.")


// === GAMEMODES ===
L.AddWord( 1, "GamemodeStarting",	"{1} is about to begin with {2} players. Join?")
L.AddWord( 1, "GamemodeStartingFull",	"{1} is about to begin with {2} players, which is the maximum amount. Join the next game?")
L.AddWord( 1, "GamemodeFailedJoin",	"You were not added in last game of {1}. Stay in the queue?")
L.AddWord( 1, "GamemodeStay",	"You have opted to stay in queue for {1}")
L.AddWord( 1, "GamemodeLeave",	"You have left the queue for {1}")
L.AddWord( 1, "GamemodeFull",	"Sorry, {1} is full.")
L.AddWord( 1, "GamemodeStartingChat",	"Starting a game of {1} with {2} players!")
L.AddWord( 1, "GamemodeOffline",	"Sorry, the gamemode seems to be offline.")


// === THEATER ===
L.AddWord( 1, "TheaterWeekOld",	"Video must be at least a week old.")
L.AddWord( 1, "TheaterTooLong",	"Video is too long.")
L.AddWord( 1, "TheaterMature",	"Video has mature content.")
L.AddWord( 1, "TheaterEmbedDisabled",	"Video is embed disabled.")
L.AddWord( 1, "TheaterInvalidID",	"Invalid YouTube ID.")
L.AddWord( 1, "TheaterInvalidURL",	"Invalid YouTube URL.")
L.AddWord( 1, "TheaterVoteDelay",	"You need to wait {1} seconds to vote again.")
L.AddWord( 1, "TheaterTimelimit",	"You need to wait {1} seconds to add this video again.")
L.AddWord( 1, "TheaterAddedVideo",	"Current video added by: {1}")
L.AddWord( 1, "TheaterSkippedVideo",	"{1} changed to the next video.")

L.AddWord( 1, "TheaterEventStarted",	"Theater Event: '{1}' has started! Come by the theater to watch!")
L.AddWord( 1, "TheaterEventAd",	"Welcome, Theater Event: '{1}' is currently on.")
L.AddWord( 1, "TheaterEventAdOutside",	"Theater Event: '{1}' is currently on. Come by the theater to watch!")
L.AddWord( 1, "TheaterEventDenyVideoAdd",	"You cannot add videos as there is a Theater event.")


// === MISC ===
L.AddWord( 1, "JoinLobby",	"{1} is now in the tower.")
L.AddWord( 1, "LeaveLobby",	"{1} has left the tower.")
L.AddWord( 1, "KickLobby",	"{1} was kicked from tower by {2} for '{3}'")
L.AddWord( 1, "BanLobby",	"{1} was BANNED from tower by {2} for '{3}'")
L.AddWord( 1, "LobbyWelcome",	"Welcome back, {1}! Your profile has been loaded.")
L.AddWord( 1, "LobbyWelcomeNew",	"Welcome to GMod Tower!")
L.AddWord( 1, "KickLobbyAFK",	"{1} was kicked from tower for being AFK.")
L.AddWord( 1, "VIPGiveItem",	"Thank you for donating! You have been given 5,000 GMC and a wine gift basket! (located in your trunk)")
L.AddWord( 1, "BackpackShouldEquip",	"You should equip the backpack before trying to use it.")


// === FLOATING SIGNS ===
L.AddWord( 1, "Theater",	"Theater")


// === DUELS ===
L.AddWord( 1, "DuelRequest",	"{1} has challenged you to a duel with {2} for {3} GMC. Do you accept?" )
L.AddWord( 1, "DuelCondo",	"Duels will check you out of your suite." )
L.AddWord( 1, "DuelInvite",	"You have challenged {1} to a duel." )
L.AddWord( 1, "DuelInviteFailActive",	"You are currently awaiting a duel. You cannot duel more than once at the same time." )
L.AddWord( 1, "DuelInviteFailCurrent",	"{1} is currently in a duel already." )
L.AddWord( 1, "DuelInviteFailPoker",	"{1} is playing a game of poker. Please wait for them to finish before inviting them again." )
L.AddWord( 1, "DuelInviteFailFunds",	"{1} does not have enough GMC for this duel. Please lower the bet and try again." )
L.AddWord( 1, "DuelAcceptFailInGame",	"Please finish your game before accepting the duel." )
L.AddWord( 1, "DuelDeny",	"{1} has declined your duel challenge." )
L.AddWord( 1, "DuelActive",	"You have a duel invite pending. You may not {1}.")


// === POKER ===
L.AddWord( 1, "PokerChipEarned",	"You've gained {1} poker chips.")
L.AddWord( 1, "PokerChipSpent",	"You've lost {1} poker chips.")
L.AddWord( 1, "PokerCannotAfford",	"You cannot afford to play on this table! You need {1} chips to play. You can purchase more chips at the poker chip dealer." )
L.AddWord( 1, "PokerCannotAffordRaise",	"You cannot afford to raise that much! Either fold or call (go all in)" )
L.AddWord( 1, "PokerCannotAffordChips",	"You cannot afford that many poker chips!" )
L.AddWord( 1, "PokerCannotRejoin",	"You cannot join another poker board for {1} seconds to prevent griefing." )
L.AddWord( 1, "PokerAutoFold",	"You've automaticlly folded due to idling/not going." )
L.AddWord( 1, "PokerChipPurchase",	"You just bought {1} poker chip(s)." )
L.AddWord( 1, "PokerChipNoCash",	"You don't have any chips to cash in!" )
L.AddWord( 1, "PokerChipCashed",	"You just cashed in {1} poker chip(s)." )
L.AddWord( 1, "PokerGamemodeLeave",	"By playing poker, you have automatically left the gamemode queue you were in." )
L.AddWord( 1, "PokerPotSplit",	"Pot was split amongst all players due to winner going all in." )
L.AddWord( 1, "PokerChipWorth",	"Chips are worth {1} GMC each.\nHow many chips do you want to buy?" )
L.AddWord( 1, "PokerChipWelcome", 			"Welcome to the one stop Poker Chip shop. You need chips in order to play poker.\n\n"..
														"Be sure to cash out your chips when you're done playing by talking to me or by leaving the casino. Have fun!" )

// === SLOTS ===
L.AddWord( 1, "SlotsEjectIdle",	"You have been ejected due to idling!")
L.AddWord( 1, "SlotsEjectTime",	"You have been ejected because you've been playing for too long!")
L.AddWord( 1, "SlotsNoAfford",	"You can't afford to bet that!")
L.AddWord( 1, "SlotsLose",	"Sorry, you didn't win anything.")
L.AddWord( 1, "SlotsWin",	"You won {1} GMC!")
L.AddWord( 1, "SlotsJackpotAll",	"{1} HAS WON THE JACKPOT! A total of {2} GMC!")
L.AddWord( 1, "SlotsJackpot",	"YOU WON THE JACKPOT! YOU ARE GOD OF TOWER!")


// === VIDEO POKER ===
L.AddWord( 1, "VideoPokerNoAfford",	"[Video Poker] You cannot afford that!" )
L.AddWord( 1, "VideoPokerLose",	"[Video Poker] Sorry, you didn't win anything." )
L.AddWord( 1, "VideoPokerWin",	"[Video Poker] You won {1} credits!" )
L.AddWord( 1, "VideoPokerJackpot",	"[Video Poker] YOU WON THE JACKPOT! YOU ARE GOD OF TOWER!" )
L.AddWord( 1, "VideoPokerJackpotAll",	"[Video Poker] {1} HAS WON THE JACKPOT! A total of {2} GMC!" )
L.AddWord( 1, "VideoPokerEjectIdle",	"[Video Poker] You have been ejected due to idling!")
L.AddWord( 1, "VideoPokerEjectTooLong",	"[Video Poker] You have been ejected for playing too long!")
L.AddWord( 1, "VideoPokerProfit",	"[Video Poker] You {1} {2} GMC from your video poker session." )
L.AddWord( 1, "VideoPokerSpend",	"[Video Poker] You lost {1} credit{2}" )
L.AddWord( 1, "VideoPokerRefound",	"[Video Poker] You were given {1} GMC because the server crashed/restarted.")
L.AddWord( 1, "VideoPokerIsZero",	"[Video Poker] You can't start with zero credits!" )
L.AddWord( 1, "VideoPokerBankrupt",	"[Video Poker] You ran out of credits to spend!" )

// === ARCADE
L.AddWord( 1, "ArcadeLoseTickets",	"[Arcade] You lost {1} ticket{2}" )
L.AddWord( 1, "ArcadeGetTickets",	"[Arcade] You gained {1} ticket{2}" )
L.AddWord( 1, "ArcadeNoAfford",	"[Arcade] You can't afford to spend {1} GMC!" )
L.AddWord( 1, "ArcadeNoCredits",	"[Arcade] This game doesn't have enough credits to start a game." )

// === INVENTORY ===
L.AddWord( 1, "RandomInvGive",	"You got a {1}! {2}")
L.AddWord( 1, "RandomInvGiveGMC",	"You got {1}! {2}")
L.AddWord( 1, "RandomInvGiveFail",	"You didn't get anything. How sad!")
L.AddWord( 1, "RandomInvGiveFailUnique",	"You already have this in your inventory!")
L.AddWord( 1, "RandomInvGiveUniqueSell",	"This item is unique and you already have it. Awarding you the sell price of it.")
L.AddWord( 1, "RandomInvGiveError",	"Something went wrong! Sorry!")
L.AddWord( 1, "InventoryEquipNotAllowed",	"You cannot use the {1} while you are in the {2}.")
L.AddWord( 1, "InventoryDropNotAllowed",	"You cannot drop {1} while you are in the {2}.")
L.AddWord( 1, "InventoryMiniNotAllowed",	"You cannot use the {1} while you are in a minigame.")
L.AddWord( 1, "InventoryWallTraceFailed",	"You are too close to a wall to use your {1}.")
L.AddWord( 1, "InventoryWallTraceFailedDefaultSize",	"You are too close to a wall or ceiling to revert to default size.")
L.AddWord( 1, "InventoryFloorTraceFailed",	"You need to be on solid ground to use your {1}.")
L.AddWord( 1, "InventoryTooFar",	"It's too far away.")
L.AddWord( 1, "InventoryPlacedMax",	"You cannot drop any more items down.")
L.AddWord( 1, "InventorySendVaultSuccess",	"{1} has been moved to your trunk.")
L.AddWord( 1, "InventorySendVaultFailed",	"{1} cannot be moved to your trunk. You are out of space.")
L.AddWord( 1, "InventorySold",		"You sold the item: {1}.")
L.AddWord( 1, "InventoryDiscard",	"You discarded the item: {1}.")
L.AddWord( 1, "BankFull",			"There isn't enough space in your trunk.")


// === SETTINGS TOOL TIPS ===
L.AddWord( 1, "SetScoreHeight",	"Adjusts the height of the player boxes on the scoreboard.")
L.AddWord( 1, "SetRespectIcons",	"Displays icons representing VIP, Admin, etc. on scoreboard player cards.")
L.AddWord( 1, "SetScoreboardBlur",	"Blurs out everything but the scoreboard.")
L.AddWord( 1, "SetScoreboardBlurAmt",		"Adjusts the amount of blurring behind the scoreboard.")
L.AddWord( 1, "SetChatSounds",		"Audible tones played when a chat message appears.")
L.AddWord( 1, "SetChatLocation",	"Displays the player's location before their chat message.")
L.AddWord( 1, "SetDisplayHUD",		"Toggles the heads-up display of the gamemode.")
L.AddWord( 1, "SetDisplayBlur",	"Displays the blur that is visible across the top and bottom of your screen for a cinematic experience. Can be costly!")
L.AddWord( 1, "SetMiniGrassDist",	"Warning! This setting impacts your CPU quite a bit. We suggest not going over 1000.")
L.AddWord( 1, "SetOldAmmoDisplay",	"Enables old PVP Battle ammo display.")


// === GAMEMODE PORTS ===
L.AddWord( 1, "GamemodeGroupLeft",	"A player has left your group. Your group has been removed from the server waiting list." )
L.AddWord( 1, "GamemodeVIPOnly",	"You cannot join this beta as it for VIP players only. Please consider donating to play it early!" )
L.AddWord( 1, "GamemodeGroupNotOwner",		"You are not the group owner. Only group owners can queue into the server." )
L.AddWord( 1, "GamemodeGroupOnly",	"You need to be a in a group to join this server." )
L.AddWord( 1, "GamemodeCooldown", 	"{1} cannot be voted on because it has been played too much." )

L.AddWord( 1, "GamemodePanelNoGame",	"<font=GTowerbig><color=ltgrey>NO GAME RUNNING</color><font>" )
L.AddWord( 1, "GamemodeNoGame",	"<font=GTowerbig><color=ltgrey>NO GAME RUNNING</color><font>" )

// === CINEMA ===
L.AddWord( 1, "Volume", "Volume" )
L.AddWord( 1, "Voteskips", "Voteskips" )
L.AddWord( 1, "Loading", "Loading..." )
L.AddWord( 1, "Invalid", "[INVALID]" )
L.AddWord( 1, "NoVideoPlaying", "No video playing" )
L.AddWord( 1, "Cancel", "Cancel" )
L.AddWord( 1, "Set", "Set" )

-- Theater Announcements
-- modules/theater/cl_init.lua
-- modules/theater/sh_commands.lua
-- modules/theater/sh_theater.lua
L.AddWord( 1, "Theater_VideoRequestedBy", "Current video requested by {1}." )
L.AddWord( 1, "Theater_InvalidRequest", "Invalid video request." )
L.AddWord( 1, "Theater_AlreadyQueued", "The requested video is already in the queue." )
L.AddWord( 1, "Theater_ProcessingRequest", "Processing {1} request..." )
L.AddWord( 1, "Theater_RequestFailed", "There was a problem processing the requested video." )
L.AddWord( 1, "Theater_Voteskipped", "The current video has been voteskipped." )
L.AddWord( 1, "Theater_ForceSkipped", "{1} has forced to skip the current video." )
L.AddWord( 1, "Theater_PlayerReset", "{1} has reset the theater." )
L.AddWord( 1, "Theater_LostOwnership", "You have lost theater ownership due to leaving the theater." )
L.AddWord( 1, "Theater_NotifyOwnership", "You're now the owner of the private theater." )
L.AddWord( 1, "Theater_OwnerLockedQueue", "The owner of the theater has locked the queue." )
L.AddWord( 1, "Theater_LockedQueue", "{1} has locked the theater queue." )
L.AddWord( 1, "Theater_UnlockedQueue", "{1} has unlocked the theater queue." )
L.AddWord( 1, "Theater_OwnerUseOnly", "Only the theater owner can use that." )
L.AddWord( 1, "Theater_PublicVideoLength", "Public theater requests are limited to {1} second(s) in length." )
L.AddWord( 1, "Theater_PlayerVoteSkipped", "{1} has voted to skip ({2}/{3})." )
L.AddWord( 1, "Theater_VideoAddedToQueue", "{1} has been added to the queue." )

-- Queue
-- modules/scoreboard/cl_queue.lua
L.AddWord( 1, "Queue_Title", "QUEUE" )
L.AddWord( 1, "Request_Video", "Request Video" )
L.AddWord( 1, "Vote_Skip", "Vote Skip" )
L.AddWord( 1, "Toggle_Fullscreen", "Toggle Fullscreen" )
L.AddWord( 1, "Refresh_Theater", "Refresh Theater" )

-- Theater controls
-- modules/scoreboard/cl_admin.lua
L.AddWord( 1, "Theater_Admin", "ADMIN" )
L.AddWord( 1, "Theater_Owner", "OWNER" )
L.AddWord( 1, "Theater_Skip", "Skip" )
L.AddWord( 1, "Theater_Seek", "Seek" )
L.AddWord( 1, "Theater_Reset", "Reset" )
L.AddWord( 1, "Theater_ChangeName", "Change Name" )
L.AddWord( 1, "Theater_QueueLock", "Toggle Queue Lock" )
L.AddWord( 1, "Theater_SeekQuery", "HH:MM:SS or number of seconds (e.g. 1:30:00 or 5400)" )

-- Theater list
-- modules/scoreboard/cl_theaterlist.lua
L.AddWord( 1, "TheaterList_NowShowing", "NOW SHOWING" )

-- Request Panel
-- modules/scoreboard/cl_request.lua
L.AddWord( 1, "Request_History", "HISTORY" )
L.AddWord( 1, "Request_Clear", "Clear" )
L.AddWord( 1, "Request_DeleteTooltip", "Remove video from history" )
L.AddWord( 1, "Request_PlayCount", "%d request(s)" )
L.AddWord( 1, "Request_Url", "Request URL" )
L.AddWord( 1, "Request_Url_Tooltip", "Press to request a valid video URGtowerLangush.\nThe button will be red when the URL is valid" )

-- Scoreboard settings panel
-- modules/scoreboard/cl_settings.lua
L.AddWord( 1, "Settings_Title", "SETTINGS" )
L.AddWord( 1, "Settings_ClickActivate", "CLICK TO ACTIVATE YOUR MOUSE" )
L.AddWord( 1, "Settings_VolumeLabel", "Volume" )
L.AddWord( 1, "Settings_VolumeTooltip", "Use the +/- keys to increase/decrease volume." )
L.AddWord( 1, "Settings_HDLabel", "HD Video Playback" )
L.AddWord( 1, "Settings_HDTooltip", "Enable HD video playback for HD enabled videos." )
L.AddWord( 1, "Settings_HidePlayersLabel", "Hide Players In Theater" )
L.AddWord( 1, "Settings_HidePlayersTooltip", "Reduce player visibility inside of theaters." )
L.AddWord( 1, "Settings_MuteFocusLabel", "Mute audio while alt-tabbed" )
L.AddWord( 1, "Settings_MuteFocusTooltip", "Mute theater volume while Garry's Mod is out-of-focus (e.g. you alt-tabbed)." )
L.AddWord( 1, "Service_EmbedDisabled", "The requested video is embed disabled." )
L.AddWord( 1, "Service_PurchasableContent", "The requested video is purchasable content and can't be played." )
L.AddWord( 1, "Service_StreamOffline", "The requested stream is offline." )

-- Friending/Blocking
L.AddWord( 1, "Friends_FriendDesc", "Friends can always enter your suite locked or not. You will also get a notice when they join." )
L.AddWord( 1, "Friends_BlockedDesc", "Blocked players cannot voice or text chat with you. They also cannot enter your suite." )
L.AddWord( 1, "Friends_Friend", "You are now friends with {1}" )
L.AddWord( 1, "Friends_Unfriend", "You are no longer friends with {1}" )
L.AddWord( 1, "Friends_Block", "You have blocked {1}" )
L.AddWord( 1, "Friends_BlockAdmin", "You cannot block {1} as they are an admin/mod" )
L.AddWord( 1, "Friends_Unblock", "You have unblocked {1}" )
L.AddWord( 1, "Friends_NoRelationship", "You have no relationship with {1}" )
L.AddWord( 1, "Friends_Joined", "Your friend {1} has joined tower!" )

-- Location Notices
L.AddWord( 1, "LocationIsNil", "You will be kicked out of this unknown location in {1} seconds." )


// === LOCATIONS ===
L.AddWord( 1, "TODO", "TODO")
L.AddWord( 1, "Gamemode Ports", "Gamemode Ports" )
L.AddWord( 1, "Entertainment Plaza", "Entertainment Plaza")
L.AddWord( 1, "suite Floor", "suite Floor" )
L.AddWord( 1, "suites 1-5", "suites 1-5" )
L.AddWord( 1, "suites 6-10", "suites 6-10" )
L.AddWord( 1, "Arcade", "Arcade" )
L.AddWord( 1, "Teleporters", "Teleporters")
L.AddWord( 1, "Dev. HQ", "Dev. HQ" )
L.AddWord( 1, "Resturant", "Resturant")
L.AddWord( 1, "Ball Race", "Ball Race" )
L.AddWord( 1, "Action Genre", "Action Genre")
L.AddWord( 1, "PVP Battle", "PVP Battle" )
L.AddWord( 1, "Stealth - Coming Soon", "Stealth - Coming Soon" )
L.AddWord( 1, "Coming Soon", "Coming Soon" )
L.AddWord( 1, "GMT: Adventure", "GMT: Adventure" )
L.AddWord( 1, "Stealth", "Stealth" )
L.AddWord( 1, "Puzzle: Impossible", "Puzzle: Impossible" )
L.AddWord( 1, "Tetris", "Tetris" )
L.AddWord( 1, "Bar", "Bar" )
L.AddWord( 1, "Theatre", "Theatre" )
L.AddWord( 1, "Party suite", "Party suite" )
L.AddWord( 1, "The Gallery", "The Gallery" )
L.AddWord( 1, "Twist of the Mind", "Twist of the Mind" )
L.AddWord( 1, "Mini-Golf", "Mini-Golf" )
L.AddWord( 1, "Monotone", "Monotone" )
L.AddWord( 1, "Harvest", "Harvest")
L.AddWord( 1, "Furniture Store", "Furniture Store" )
L.AddWord( 1, "Hat Store", "Hat Store" )
L.AddWord( 1, "Souvenir Store", "Souvenir Store" )
L.AddWord( 1, "Electronic Store", "Electronic Store" )
L.AddWord( 1, "Conquest", "Conquest" )
L.AddWord( 1, "Chainsaw Battle!","Chainsaw Battle!")
L.AddWord( 1, "Blizzard Storm!", "Blizzard Storm!" )

// Custom/New language
L.AddWord( 1, "MCSkinChange",	"Your skin will be set in a few seconds.")

// TEMP
L.AddWord( 1, "ArcadeDisable", "Arcade machines are currently disabled, check back another time." )
L.AddWord( 1, "DuelsDisable", "Dueling is currently unavailable, check back another time." )
L.AddWord( 1, "DuelsDisable2", "Dueling is currently unavailable, try again another time." )
L.AddWord( 1, "PokerDisable", "Poker is currently in development, check back later!" )
L.AddWord( 1, "TriviaDisable", "Trivia is currently unavailable, check back later." )
