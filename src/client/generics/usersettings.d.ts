interface usersettings {
	getCameraMovementMode: () => Enum.ComputerCameraMovementMode;
	getMovementMode: () => Enum.ComputerMovementMode;
	getMouseLockMode: () => Enum.ControlMode;
	getMouseSensitivity: () => number;
	getGraphicsLevel: () => Enum.SavedQualitySetting;
	getFullScreen: () => boolean;
	getLocalRegion: () => LuaTuple<[string, string]>;
	getCameraYInvertValue: () => number;
	toggleCameraYInvertMenu: () => undefined;
	bindToFullScreenChanged: (fn: (wasFullscreen: boolean) => undefined) => RBXScriptConnection;
	bindToGraphicsChanged: (fn: (newLevel: Enum.SavedQualitySetting) => undefined) => RBXScriptConnection;
}

declare const usersettings: usersettings;

export = usersettings;
