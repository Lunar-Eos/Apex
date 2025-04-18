--!strict


-- Services
local _PLAYERS = game:GetService("Players")
local _STARTERGUI = game:GetService("StarterGui")
local _COREGUI = game:GetService("CoreGui")


-- Libraries


-- Upvalues


-- Constants


-- Variables


-- Module
local playersettings = {}


--[[ DISCLAIMER: These functions are CLIENT-ONLY.
     Any attempt to use them outside of the client will error. ]]

--[[ Functions: 

	playersettings.getBlockedUsers()
	playersettings.promptBlockPlayer(player)
	playersettings.promptUnblockPlayer(player)
	playersettings.promptFriendPlayer(player)
	playersettings.promptUnfriendPlayer(player)
	playersettings.bindToPlayerBlockedEvent(fn)
	playersettings.bindToPlayerUnblockedEvent(fn)
	playersettings.bindToPlayerMutedEvent(fn)
	playersettings.bindToPlayerUnmutedEvent(fn)
	playersettings.bindToPlayerFriendedEvent(fn)
	playersettings.bindToPlayerUnfriendedEvent(fn)
    
]]


--[[ playersettings.getBlockedUsers()
	PARAMETERS: 
	- nil.

	RETURNS:
	- <table> allBlockedUsers: A table of all blocked users by the local player.

	Returns a table of players blocked by the local player. ]] 
function playersettings.getBlockedUsers(): { [number]: Player }
	local t = {}
	for _, b in _STARTERGUI:GetCore("GetBlockedUserIds") do
		table.insert(t, _PLAYERS:GetPlayerByUserId(b))
	end
	return t
end


--[[ playersettings.promptBlockPlayer(player)
	PARAMETERS: 
	- <Player> player: The player to block.

	RETURNS:
	- nil.

	Triggers a prompt to block the player. ]] 
function playersettings.promptBlockPlayer(player: Player)
	_STARTERGUI:SetCore("promptBlockPlayer", player)
end


--[[ playersettings.promptUnblockPlayer(player)
	PARAMETERS: 
	- <Player> player: The player to unblock.

	RETURNS:
	- nil.

	Triggers a prompt to unblock the player. ]] 
function playersettings.promptUnblockPlayer(player: Player)
	_STARTERGUI:SetCore("promptUnblockPlayer", player)
end


--[[ playersettings.promptFriendPlayer(player)
	PARAMETERS: 
	- <Player> player: The player to friend.

	RETURNS:
	- nil.

	Triggers a prompt to friend the player. ]] 
function playersettings.promptFriendPlayer(player: Player)
	_STARTERGUI:SetCore("PromptSendFriendRequest", player)
end


--[[ playersettings.promptUnfriendPlayer(player)
	PARAMETERS: 
	- <Player> player: The player to unfriend.

	RETURNS:
	- nil.

	Triggers a prompt to unfriend the player. ]] 
function playersettings.promptUnfriendPlayer(player: Player)
	_STARTERGUI:SetCore("PromptUnfriend", player)
end


--[[ playersettings.bindToPlayerBlockedEvent(fn)
	PARAMETERS: 
	- <Function()> fn: The function to bind to the event.

	RETURNS:
	- <RBXScriptConnection> cxn: The connection to the event. Useful to call for disconnects, etc.

	Binds a given function to the player blocked event. Also returns the resulting connection. ]] 
function playersettings.bindToPlayerBlockedEvent(fn: () -> ()): RBXScriptConnection
	return _STARTERGUI:GetCore("PlayerBlockedEvent").Event:Connect(fn)
end


--[[ playersettings.bindToPlayerUnblockedEvent(fn)
	PARAMETERS: 
	- <Function()> fn: The function to bind to the event.

	RETURNS:
	- <RBXScriptConnection> cxn: The connection to the event. Useful to call for disconnects, etc.

	Binds a given function to the player unblocked event. Also returns the resulting connection. ]] 
function playersettings.bindToPlayerUnblockedEvent(fn: () -> ()): RBXScriptConnection
	return _STARTERGUI:GetCore("PlayerUnblockedEvent").Event:Connect(fn)
end


--[[ playersettings.bindToPlayerMutedEvent(fn)
	PARAMETERS: 
	- <Function()> fn: The function to bind to the event.

	RETURNS:
	- <RBXScriptConnection> cxn: The connection to the event. Useful to call for disconnects, etc.

	Binds a given function to the player muted event. Also returns the resulting connection. ]] 
function playersettings.bindToPlayerMutedEvent(fn: () -> ()): RBXScriptConnection
	return _STARTERGUI:GetCore("PlayerMutedEvent").Event:Connect(fn)
end


--[[ playersettings.bindToPlayerUnmutedEvent(fn)
	PARAMETERS: 
	- <Function()> fn: The function to bind to the event.

	RETURNS:
	- <RBXScriptConnection> cxn: The connection to the event. Useful to call for disconnects, etc.

	Binds a given function to the player unmuted event. Also returns the resulting connection. ]] 
function playersettings.bindToPlayerUnmutedEvent(fn: () -> ()): RBXScriptConnection
	return _STARTERGUI:GetCore("PlayerUnmutedEvent").Event:Connect(fn)
end


--[[ playersettings.bindToPlayerFriendedEvent(fn)
	PARAMETERS: 
	- <Function()> fn: The function to bind to the event.

	RETURNS:
	- <RBXScriptConnection> cxn: The connection to the event. Useful to call for disconnects, etc.

	Binds a given function to the player friended event. Also returns the resulting connection. ]] 
function playersettings.bindToPlayerFriendedEvent(fn: () -> ()): RBXScriptConnection
	return _STARTERGUI:GetCore("PlayerFriendedEvent").Event:Connect(fn)
end


--[[ playersettings.bindToPlayerUnfriendedEvent(fn)
	PARAMETERS: 
	- <Function()> fn: The function to bind to the event.

	RETURNS:
	- <RBXScriptConnection> cxn: The connection to the event. Useful to call for disconnects, etc.

	Binds a given function to the player unfriended event. Also returns the resulting connection. ]] 
function playersettings.bindToPlayerUnfriendedEvent(fn: () -> ()): RBXScriptConnection
	return _STARTERGUI:GetCore("PlayerUnfriendedEvent").Event:Connect(fn)
end


return playersettings