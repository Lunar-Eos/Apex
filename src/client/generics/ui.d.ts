interface ui {
	getEnabledCoreGuis: () => { [key: string]: boolean };
	enableCoreGuis: (...coreguis: Enum.CoreGuiType[]) => undefined;
	disableCoreGuis: (...coreguis: Enum.CoreGuiType[]) => undefined;
	onlyEnableCoreGuis: (...coreguis: Enum.CoreGuiType[]) => undefined;
	sendRobloxTextNotification: (title: string, message: string, icon: string | undefined) => undefined;
	forceToggleConsole: (enabled: boolean) => undefined;
	stopForceConsole: () => undefined;
	toggleBadgeNotifications: (enabled: boolean, tries: number | undefined) => undefined;
	toggleResetButton: (enabled: boolean, tries: number | undefined) => undefined;
	toggleTopBar: (enabled: boolean, tries: number | undefined) => undefined;
	toggleAvatarContextMenu: (
		enabled: boolean,
		unequipTools: boolean | undefined,
		humanoid: Humanoid | undefined,
	) => undefined;
	changePlayerOnAvatarContextMenu: (player: Player | undefined) => undefined;
	addOptionToAvatarContextMenu: (option: Enum.AvatarContextMenuOption) => undefined;
	addCustomOptionToAvatarContextMenu: (name: string, fn: () => undefined) => BindableEvent;
	removeOptionFromAvatarContextMenu: (option: Enum.AvatarContextMenuOption) => undefined;
	removeCustomOptionFromAvatarContextMenu: (option: string) => undefined;
	customizeAvatarContextMenuBackground: (
		color: Color3,
		transparency: number,
		image: string | undefined,
		imageTransparency: number | undefined,
		imageScaleType: Enum.ScaleType | undefined,
		imageSliceCenter: Rect | undefined,
	) => undefined;
	customizeAvatarContextMenuNameTag: (tagColor: Color3, underlineColor: Color3) => undefined;
	customizeAvatarContextMenuButtonFrame: (color: Color3, transparency: number) => undefined;
	customizeAvatarContextMenuButton: (
		color: Color3,
		transparency: number,
		hoverColor: Color3,
		hoverTransparency: number,
		underlineColor: Color3,
		image: string | undefined,
		imageScaleType: Enum.ScaleType | undefined,
		imageSliceCenter: Rect | undefined,
	) => undefined;
	customizeAvatarContextMenuText: (font: Enum.Font, color: Color3, scale: number) => undefined;
	customizeAvatarContextMenuIcons: (close: string, scrollLeft: string, scrollRight: string) => undefined;
	customizeAvatarContextMenuIndicator: (part: MeshPart) => undefined;
	customizeAvatarContextMenuSizeAndPosition: (
		size: number,
		minSize: Vector2,
		maxSize: Vector2,
		aspectRatio: number,
		anchorPoint: Vector2,
		onScreenPos: UDim2,
		offScreenPos: UDim2,
	) => undefined;
	customizeAvatarContextMenuByTable: (t: { [key: string]: unknown }) => undefined;
	bindToWindowGainedFocus: (fn: () => undefined) => RBXScriptConnection;
	bindToWindowLostFocus: (fn: () => undefined) => RBXScriptConnection;
	bindToAnyMenuToggled: (fn: (open: boolean) => undefined) => RBXScriptConnection;
	bindToResetButtonActivated: (fn: () => undefined) => BindableEvent;
}

declare const ui: ui;

export = ui;
