interface playersettings {
	getBlockedUsers: () => Player[];
	promptBlockPlayer: (player: Player) => undefined;
	promptUnblockPlayer: (player: Player) => undefined;
	promptFriendPlayer: (player: Player) => undefined;
	promptUnfriendPlayer: (player: Player) => undefined;
	bindToPlayerBlockedEvent: (fn: () => undefined) => RBXScriptConnection;
	bindToPlayerUnblockedEvent: (fn: () => undefined) => RBXScriptConnection;
	bindToPlayerMutedEvent: (fn: () => undefined) => RBXScriptConnection;
	bindToPlayerUnmutedEvent: (fn: () => undefined) => RBXScriptConnection;
	bindToPlayerFriendedEvent: (fn: () => undefined) => RBXScriptConnection;
	bindToPlayerUnfriendedEvent: (fn: () => undefined) => RBXScriptConnection;
}

declare const playersettings: playersettings;

export = playersettings;
