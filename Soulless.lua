--[[
	Split
		@TODO: Put this in another file somehow?
--]]
function split(pString, pPattern)
	local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
	local fpat = "(.-)" .. pPattern
	local last_end = 1
	local s, e, cap = pString:find(fpat, 1)
	while s do
		if s ~= 1 or cap ~= "" then
			table.insert(Table,cap)
		end
		
		last_end = e+1
		s, e, cap = pString:find(fpat, last_end)
	end
	
	if last_end <= #pString then
		cap = pString:sub(last_end)
		table.insert(Table, cap)
	end
	
	return Table
end


--[[
	contains
		@TODO: Put this in another file somehow? 
--]]
function contains(table, element)
	for _, value in pairs(table) do
		if value == element then
			return true
		end
	end
	
	return false
end


--[[
	deepcopy
		@TODO: Put this in another file somehow?
--]]
function deepcopy(orig)
	local orig_type = type(orig)
	local copy
	
	if orig_type == 'table' then
		copy = {}
		
		for orig_key, orig_value in next, orig, nil do
			copy[deepcopy(orig_key)] = deepcopy(orig_value)
		end
		
		setmetatable(copy, deepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	
	return copy
end


--[[ 
	SoundsDictionary
--]]
local SND_NAMES = 1
local SND_PATH = 2
local SoundsDictionary = {
	alright 			= { {"alright"}, 						"Interface\\Addons\\Soulless\\Sounds\\alright.ogg"},
	ants				= { {"ants"},							"Interface\\Addons\\Soulless\\Sounds\\ants.ogg"},
	bitchsundance		= { {"bitchsundance", "bns"},			"Interface\\Addons\\Soulless\\Sounds\\bitchsundance.ogg"},
	canthavenicethings	= { {"canthavenicethings", "chnt"},		"Interface\\Addons\\Soulless\\Sounds\\canthavenicethings.ogg"},
	crickets 			= { {"cricket", "crickets"}, 			"Interface\\Addons\\Soulless\\Sounds\\crickets.mp3"},
	dirtybird			= { {"dirtybird", "db"},				"Interface\\Addons\\Soulless\\Sounds\\dirtybird.ogg"},
	dontstopbelieving	= { {"dontstopbelieving", "dsb"}, 		"Interface\\Addons\\Soulless\\Sounds\\dontstopbelieving.mp3"},
	entirelytoogay		= { {"entirelytoogay", "toogay"},		"Interface\\Addons\\Soulless\\Sounds\\entirelytoogay.ogg"},
	epicfail			= { {"epicfail", "ef"},					"Interface\\Addons\\Soulless\\Sounds\\epicfail.ogg"},
	finishhim			= { {"finishhim", "fm"},				"Interface\\Addons\\Soulless\\Sounds\\finishhim.mp3"},
	gameoverman			= { {"gameoverman", "gom"},				"Interface\\Addons\\Soulless\\Sounds\\gameoverman.ogg"},
	getoverhere			= { {"getoverhere", "comehere"},		"Interface\\Addons\\Soulless\\Sounds\\getoverhere.ogg"},
	giggity				= { {"giggity"},						"Interface\\Addons\\Soulless\\Sounds\\giggity.ogg"},
	haybuddy			= { {"haybuddy", "haybudday", "hb"},	"Interface\\Addons\\Soulless\\Sounds\\haybudday.ogg"},
	kaboom				= { {"kaboom"},							"Interface\\Addons\\Soulless\\Sounds\\kaboom.mp3"},
	mariogameover		= { {"mariogameover", "gameover"},		"Interface\\Addons\\Soulless\\Sounds\\mariogameover.mp3"},
	neigh				= { {"neigh"},					"Interface\\Addons\\Soulless\\Sounds\\neigh.mp3"},
	nelsonhaha			= { {"nelsonhaha", "haha"},				"Interface\\Addons\\Soulless\\Sounds\\nelsonhaha.mp3"},
	nope				= { {"nope", "no"},						"Interface\\Addons\\Soulless\\Sounds\\nope.ogg"},
	ohyeah				= { {"ohyea", "ohyeah"},				"Interface\\Addons\\Soulless\\Sounds\\ohyeah.ogg"},
	pieceofcandy		= { {"pieceofcandy", "candy"},			"Interface\\Addons\\Soulless\\Sounds\\pieceofcandy.ogg"},
	priceisrightfail	= { {"priceisrightfail", "fail"},		"Interface\\Addons\\Soulless\\Sounds\\priceisrightfail.mp3"},
	saywhat				= { {"saywhat", "sw"},					"Interface\\Addons\\Soulless\\Sounds\\saywhat.mp3"},
	silenceikillyou		= { {"silenceikillyou", "silence"}, 	"Interface\\Addons\\Soulless\\Sounds\\silenceikillyou.mp3"},
	sneezeglitter		= { {"sneezeglitter", "sg"},			"Interface\\Addons\\Soulless\\Sounds\\sneezeglitter.ogg"},
	surroundedbyidiots	= { {"surrounded", "idiots"},			"Interface\\Addons\\Soulless\\Sounds\\surroundedbyidiots.ogg"},
	wordup				= { {"wordup", "wu"},					"Interface\\Addons\\Soulless\\Sounds\\wordup.ogg"},
	youguysarenubs		= { {"youguysarenubs", "nubs"},			"Interface\\Addons\\Soulless\\Sounds\\youguysarenubs.ogg"}
}


SLASH_SOULLESS1, SLASH_SOULLESS2, SLASH_SOULLESS3, SLASH_SOULLESS4 = "/soulless", "/souless", "/soul", "/sl"
function CommandHandler(msg, editbox)
	--Route everything through HandleMessageAddon
	HandleMessageAddon("SOULLESS", msg, "SELF", "player")
end


--[[
	OnLoad
		Regiter all events, the addon message prefix,
		and set up the Slash Command Handler
--]]
function Soulless_OnLoad(self)
	self:RegisterEvent("READY_CHECK")
	self:RegisterEvent("READY_CHECK_CONFIRM")
	self:RegisterEvent("CHAT_MSG_ADDON")
	self:RegisterEvent("ADDON_LOADED")
	
	local success = RegisterAddonMessagePrefix("SOULLESS")
	if not success then
		print("Failed to register addon prefix!")
	end
	
	SlashCmdList["SOULLESS"] = CommandHandler
end


--[[
	OnEvent
		Handle every event that we've registered
--]]
function Soulless_OnEvent(self, event, ...)
	if (event == "READY_CHECK") then
		HandleShowReadyCheckFrame()
	elseif (event == "READY_CHECK_CONFIRM") then
		HandleConfirmReadyCheck(...)
	elseif (event == "CHAT_MSG_ADDON") then
		HandleMessageAddon(...)
	elseif (event == "ADDON_LOADED") then
		if FollowMeEnabled == nil then
			FollowMeEnabled = false
		end
	end
end


--[[
	HandleShowReadyCheckFrame
		Modify the "No" button on readycheck to say "NEIGH!"
--]]
function HandleShowReadyCheckFrame()
	ReadyCheckFrameNoButton:SetText("NEIGH!")
end


--[[
	HandleConfirmReadyCheck
		On a bad response, plays the "neigh" sound
		
		@param id: UnitID of player
		@param response: true if the player (id) clicked ready, false otherwise
--]]
function HandleConfirmReadyCheck(id, response)
	if response == false then
		Communicate("PLAYSOUND neigh", UnitName("player"))
	end
end


--[[
	HandleMessageAddon
		Handles all messages.  If the channel is "SELF", it indicates
		that the message came from a slash/chat command
		
		@param prefix:		Label for the message.  Should be "SOULLESS"
		@param message:		The message given.
		@param channel:		The channel the message was broadcast to
		@param sender:		The originator of the message
--]]
function HandleMessageAddon(prefix, message, channel, sender)
	if prefix ~= "SOULLESS" then
		return
	end
	
	if channel == "SELF" then
		DoSelfMessage(message)
	else
		DoIncommingMessage(message, sender, channel)
	end
end


--[[
	PrintHelpText
		Prints usage text
--]]
function PrintHelpText()
	print("Usage: ")
	print("    /soulless COMMAND [...]")
	print("    /sl COMMAND [...]")
	print("    ")
	print("Commands:")
	print("    listsounds - Lists all available sounds")
	print("    playsound SoundName [destination] - Plays the given sound")
	print("    followme - Orders target to follow")
	print("    enablefollowme - Enabled follow me functionality")
	print("    disablefollowme - Disables follow me functionality")
end


--[[
	ChannelValid
		Returns true if the channel is valid, false otherwise
]]
local ChannelTable = { "PARTY", "RAID", "OFFICER", "GUILD", "BATTLEGROUND" }
function SupportedChannel(channel)
	if channel ~= nil then
		if contains(ChannelTable, channel) then
			return true
		else
			return false
		end
	else
		return false
	end
end


--[[
	Communicate
		Communicates with other addons
--]]
function Communicate(message, recipient)
	if recipient ~= nil then
		recipient = string.upper(recipient)
		if SupportedChannel(recipient) then
			SendAddonMessage("SOULLESS", message, recipient)
		else
			SendAddonMessage("SOULLESS", message, "WHISPER", recipient)
		end
		return true
	else
		return false
	end
end


--[[
	DoSendDebugPing
		Sends a DebugPing message to the recipient(s)
--]]
function DoSendDebugPing(recipient, ...)
	return Communicate("DEBUGPING", recipient)
end

--[[
	DoListSounds
		Lists all the sounds available
--]]
function DoListSounds(...)
	print("Available Sounds:")
	local num = 1
	for key, SoundEntry in pairs(SoundsDictionary) do
		local soundName = "   " .. tostring(num) .. ": "
		for i, name in ipairs(SoundEntry[SND_NAMES]) do
			soundName = soundName .. name .. " "
		end
		print(soundName)
		num = num + 1
	end
	return true
end

--[[
	DoSendPlaySound
		Sends a PlaySound message to the recipient(s)
--]]
function DoSendPlaySound(soundname, recipient, ...)
	if recipient == nil then
		if IsInRaid() then
			recipient = "RAID"
		elseif IsInGroup() then
			recipient = "PARTY"
		elseif UnitIsPlayer("target") then
			recipient = UnitName("target")
		else
			recipient = UnitName("player") -- Fallback to whispering to self
		end
	end
	
	if soundname == nil then
		print("No soundname specified")
		return false
	end
	
	for key, SoundEntry in pairs(SoundsDictionary) do
		soundname = string.lower(soundname)
		if contains(SoundEntry[SND_NAMES], soundname) then
			return Communicate("PLAYSOUND " .. soundname, recipient)
		end
	end
	
	print("Invalid sound name")
	return false
end

--[[
	DoSendFollowMe
		Sends FollowMe message to the recipient(s)
--]]
function DoSendFollowMe(recipient, ...)
	if recipient == nil then
		if UnitIsPlayer("target") then
			recipient = UnitName("target")
		end
	end

	return Communicate("FOLLOWME", recipient)
end


--[[
	DoRecvDebugPing
		Handles receiving a ping.  Should send a pong back.
--]]
function DoRecvDebugPing(sender, ...)
	return Communicate("DEBUGPONG", sender)
end


--[[
	DoRecvDebugPong
		Merely prints out who it received a pong from
--]]
function DoRecvDebugPong(sender, ...)
	print("Received pong from: " .. sender)
	return true
end


--[[
	DoRecvPlaySound
		Plays the sound received
--]]
function DoRecvPlaySound(soundname, sender, ...)
	for key, SoundEntry in pairs(SoundsDictionary) do
		if contains(SoundEntry[SND_NAMES], soundname) then
			local soundPath = SoundEntry[SND_PATH]
			PlaySoundFile(soundPath)
			break
		end
	end
	
	-- Always return true.  Client may not have updated audio
	return true
end


--[[
	DoRecvFollowMe
		Follows the sender upon receiving the message
--]]
function DoRecvFollowMe(sender, ...)
	if FollowMeEnabled == true then
		FollowUnit(sender, false)
		return true
	end
end

--[[
	DoEnableFollowMe
		Enables the follow me command
--]]
function DoEnableFollowMe(...)
	if FollowMeEnabled == true then
		print("Already enabled")
	end
	FollowMeEnabled = true
	return true
end

--[[
	DoDisableFollowMe
		Disables the follow me command
--]]
function DoDisableFollowMe(...)
	if FollowMeEnabled == false then
		print("Already disabled")
	end
	FollowMeEnabled = false
	return true
end

--[[
	DoNothing
		Dummy function.
--]]
function DoNothing(...)
	return false
end


--[[
	CommandTable
--]]
local CMD_NAMES 			= 1
local CMD_SEND_FUNCTION		= 2
local CMD_RECV_FUNCTION		= 3
local CommandDictionary = {
	debugping 		= { {"DEBUGPING", "DP", "PING"}, 						DoSendDebugPing,	DoRecvDebugPing	},
	debugpong		= { {"DEBUGPONG", "PONG"},								DoNothing,			DoRecvDebugPong	},
	listsounds 		= { {"LISTSOUNDS", "LS", "LIST", "SOUNDS"}, 			DoListSounds,		DoNothing		},
	playsound		= { {"PLAYSOUND", "PS", "PLAY"},						DoSendPlaySound,	DoRecvPlaySound	},
	followme		= { {"FOLLOWME", "FM", "FOLLOW", "F"},					DoSendFollowMe,		DoRecvFollowMe	},
	enablefollowme	= { {"ENABLEFM", "ENABLEFOLLOWME", "ENABLEFOLLOW"},		DoEnableFollowMe,	DoNothing		},
	disablefollowme	= { {"DISABLEFM", "DISABLEFOLLOWME", "DISABLEFOLLOW"},	DoDisableFollowMe,	DoNothing		}
}

--[[
	DoSelfMessage
		Does work based on the message given.  DoSelfMessage is
		only called via a chat/slash command
		
		Definitions:
			CHANNEL => PARTY, RAID, GUILD, BATTLEGROUND, OFFICER
				Channel can also be the name of a player
					
			[] => Optional parameter.  Default varies.
		
		Supported Commands:
			DEBUGPING CHANNEL		@TODO: Make this optional?  (Target)
			DP
			
			LISTSOUNDS
			LS
			
			PLAYSOUND SOUNDNAME [CHANNEL]
			PS
			
			FOLLOWME CHANNEL		@TODO: Make this optional? (Target)
			FM
--]]
function DoSelfMessage(message)
	local tokens = split(message, " ")
	
	if #tokens > 0 then
		local command = string.upper(tokens[1])
		
		local foundCommand = false
		for cmdKey, cmdTable in pairs(CommandDictionary) do
			if contains(cmdTable[CMD_NAMES], command) then
				foundCommand = true
				local func = cmdTable[CMD_SEND_FUNCTION]
				local success = func(tokens[2], tokens[3], tokens[4], tokens[5], tokens[6])
				if not success then
					print("Command failed")
				end
				break
			end
		end
		
		if not foundCommand then
			PrintHelpText()
		end
	else
		PrintHelpText()
	end
end


--[[
	DoIncommingMessage
		Does work for an incoming message
		
		@param message:		The message
		@param sender:		The originator of the message
		@param channel:		The intended recipient of the message
--]]
function DoIncommingMessage(message, sender, channel)
	--print("Received message:")
	--print("    Message: " .. message)
	--print("    Sender:  " .. sender)
	--print("    Channel: " .. channel)
	
	local tokens = split(message, " ")
	table.insert(tokens, sender)
	
	if #tokens > 0 then
		local command = string.upper(tokens[1])
		local foundCommand = false
		for cmdKey, cmdTable in pairs(CommandDictionary) do
			if contains(cmdTable[CMD_NAMES], command) then
				foundCommand = true
				local func = cmdTable[CMD_RECV_FUNCTION]
				local success = func(tokens[2], tokens[3], tokens[4], tokens[5], tokens[6])
				if not success then
					print("Failed to execute incomming message")
				end
				break
			end
		end
	else
		print("Received empty response")
	end
end