--!nocheck


-- Services
local _PLAYERS = game:GetService("Players")


-- Libraries


-- Upvalues


-- Constants


-- Variables


-- Functions


-- Module
local remotes = {}


--[[ Functions: 

	remotes.fireTo(remote, players, ...)
	remotes.fireAllBut(remote, players, ...)
 
]]


--[[ remotes.fireTo(remote, players, ...)
	PARAMETERS: 
	- <RemoteEvent | UnreliableRemoteEvent> remote: The RemoteEvent to fire. Also accepts UnreliableRemoteEvents.
	- <array> players: An array of players to fire the Remote to.
	- <any> ...: The arguments to send through the Remote.

	RETURNS:
	- nil.

	Fires a given remote to all listed clients. ]] 
function remotes.fireTo(remote: RemoteEvent | UnreliableRemoteEvent, players: {[number]: Player}, ...: any?)
	for _, player in players do
		remote:FireClient(player, ...)
	end
end


--[[ remotes.fireAllBut(remote, players, ...)
	PARAMETERS: 
	- <RemoteEvent | UnreliableRemoteEvent> remote: The RemoteEvent to fire. Also accepts UnreliableRemoteEvents.
	- <array> players: An array of players to ignore.
	- <any> ...: The arguments to send through the Remote.

	RETURNS:
	- nil.

	Fires a given remote to all clients, excluding the listed ones. ]] 
function remotes.fireAllBut(remote: RemoteEvent | UnreliableRemoteEvent, players: {[number]: Player}, ...: any?)
	for _, player in _PLAYERS:GetPlayers() do
		if table.find(players, player) ~= nil then continue end
		
		remote:FireClient(player, ...)
	end
end


return remotes