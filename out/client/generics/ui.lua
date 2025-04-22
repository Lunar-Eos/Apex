--!nocheck


-- TODO:
-- Roblox bug: typechecking AddAvatarContextMenuOption's 2nd argument.
-- Expected type should be { string | BindableEvent }, instead got { string }.


-- Services
local _GUISERVICE = game:GetService("GuiService")
local _STARTERGUI = game:GetService("StarterGui")
local _COREGUI = game:GetService("CoreGui")
local _USERINPUTSERVICE = game:GetService("UserInputService")
local _RUNSERVICE = game:GetService("RunService")


-- Libraries


-- Upvalues


-- Constants


-- References


-- Variables


-- Functions
local function CoreCall(method, ...)
	local count = 0
	local ok, e = false, nil
	
	repeat
		ok, e = pcall(_STARTERGUI[method], _STARTERGUI, ...)
		task.wait()
		
		count += 1
	until ok == true or count > 100

	if count > 100 then warn(e) end
end


-- Module
local ui = {
	topbaroffset = 36,
}


--[[ DISCLAIMER: These functions are CLIENT-ONLY.
     Any attempt to use them outside of the client will error. ]]

--[[ Functions: 

	ui.getEnabledCoreGuis()
	ui.enableCoreGuis(...)
	ui.disableCoreGuis(...)
	ui.onlyEnableCoreGuis(...)
	ui.sendRobloxTextNotification(title, message, icon)
	ui.forceToggleConsole(enabled)
	ui.stopForceConsole()
	ui.toggleBadgeNotifications(enabled, tries)
	ui.toggleResetButton(enabled, tries)
	ui.toggleTopBar(enabled, tries)
	ui.toggleAvatarContextMenu(enabled, unequipTools, humanoid)
	ui.changePlayerOnAvatarContextMenu(player)
	ui.addOptionToAvatarContextMenu(option)
	ui.addCustomOptionToAvatarContextMenu(name, fn)
	ui.removeOptionFromAvatarContextMenu(option)
	ui.removeCustomOptionFromAvatarContextMenu(option)
	ui.customizeAvatarContextMenuBackground(color, transparency, image, imageTransparency, imageScaleType, imageSliceCenter)
	ui.customizeAvatarContextMenuNameTag(tagColor, underlineColor)
	ui.customizeAvatarContextMenuButtonFrame(color, transparency)
	ui.customizeAvatarContextMenuButton(color, transparency, hoverColor, hoverTransparency, underlineColor, image, imageScaleType, imageSliceCenter)
	ui.customizeAvatarContextMenuText(font, color, scale)
	ui.customizeAvatarContextMenuIcons(close, scrollLeft, scrollRight)
	ui.customizeAvatarContextMenuIndicator(part)
	ui.customizeAvatarContextMenuSizeAndPosition(size, minSize, maxSize, aspectRatio, anchorPoint, onScreenPos, offScreenPos)
	ui.customizeAvatarContextMenuByTable(t)
	ui.bindToWindowGainedFocus(fn)
	ui.bindToWindowLostFocus(fn)
	ui.bindToMenuToggled(fn)
	ui.bindToResetButtonActivated(fn)
    
]]


--[[ ui.getEnabledCoreGuis()
	PARAMETERS: 
	- nil.

	RETURNS:
	- <table> allCoreGuis: A table of all CoreGuiTypes, along with whether they were enabled or not.

	Gets a list of all CoreGuis and whether they are enabled or not. ]] 
function ui.getEnabledCoreGuis(): {[string]: boolean}
	local t = {}
	
	for _, v in Enum.CoreGuiType:GetEnumItems() do
		t[v.Name] = CoreCall("GetCoreGuiEnabled", v)
	end
	
	return t
end


--[[ ui.enableCoreGuis(...)
	PARAMETERS: 
	- <Enum.CoreGuiTypes> ...: The Enum.CoreGuiTypes to enable. Can provide as many as needed.

	RETURNS:
	- nil.

	Enables the given Enum.CoreGuiTypes. Accepts more than one Enum.CoreGuiType. ]] 
function ui.enableCoreGuis(...: Enum.CoreGuiType)
	for _, v in {...} do
		CoreCall("SetCoreGuiEnabled", v, true)
	end
end


--[[ ui.disableCoreGuis(...)
	PARAMETERS: 
	- <Enum.CoreGuiTypes> ...: The Enum.CoreGuiTypes to disable. Can provide as many as needed.

	RETURNS:
	- nil.

	Disables the given Enum.CoreGuiTypes. Accepts more than one Enum.CoreGuiType. ]] 
function ui.disableCoreGuis(...: Enum.CoreGuiType)
	for _, v in {...} do
		CoreCall("SetCoreGuiEnabled", v, false)
	end
end


--[[ ui.onlyEnableCoreGuis(...)
	PARAMETERS: 
	- <Enum.CoreGuiTypes> ...: The Enum.CoreGuiTypes to enable. Can provide as many as needed.

	RETURNS:
	- nil.

	Only enables the given Enum.CoreGuiTypes, while disabling the others. Accepts more than one Enum.CoreGuiType. ]] 
function ui.onlyEnableCoreGuis(...: Enum.CoreGuiType)
	for _, v in Enum.CoreGuiType:GetEnumItems() do
		CoreCall("SetCoreGuiEnabled", v, false)
	end

	for _, v in {...} do
		CoreCall("SetCoreGuiEnabled", v, true)
	end
end


--[[ ui.sendRobloxTextNotification(title, message, icon)
	PARAMETERS: 
	- <string> title: The title for the notification.
	- <string> message: The contents for the notification.
	- <string> icon: The image for the notification. Accepts rbxasset URLs.

	RETURNS:
	- nil.

	Sends a ROBLOX styled notification to the user. Must be called in a LocalScript. ]] 
function ui.sendRobloxTextNotification(title: string, message: string, icon: string?)
	if title == nil then error("ui.sendRobloxTextNotification - title is nil or invalid!") end
	if message == nil then error("ui.sendRobloxTextNotification - message is nil or invalid!") end
	
	CoreCall("SetCore", "SendNotification", {
		Title = title,
		Text = message,
		Icon = icon or "rbxasset://0"
	})
end


--[[ ui.forceToggleConsole(enabled)
	PARAMETERS: 
	- <boolean>: enabled: Whether to enable hiding the console or not.

	RETURNS:
	- nil.

	Forcibly toggles the console. ]] 
function ui.forceToggleConsole(enabled: boolean)
	_RUNSERVICE:BindToRenderStep("TOGGLE_DEVCONSOLE", 1, function()
		CoreCall("SetCore", "DevConsoleVisible", enabled)
	end)
end


--[[ ui.stopForceConsole()
	PARAMETERS: 
	- nil.

	RETURNS:
	- nil.

	Stops force-toggling the console from ui.forceToggleConsole. ]] 
function ui.stopForceConsole()	
	_RUNSERVICE:UnbindFromRenderStep("TOGGLE_DEVCONSOLE")
end


--[[ ui.toggleBadgeNotifications(enabled, tries)
	PARAMETERS: 
	- <boolean> enabled: Whether to enable it or not.
	- <number> tries: The amount of times to attempt disabling the GUI. Defaults to 10.

	RETURNS:
	- nil.

	Toggles the badge notifications by ROBLOX. ]] 
function ui.toggleBadgeNotifications(enabled: boolean, tries: number?)
	local retry = 0

	local success = false
	repeat 
		success = pcall(function()
			retry += 1
			
			CoreCall("SetCore", "BadgesNotificationsActive", enabled)
		end)
	until success == true or retry > (tries or 10)
end


--[[ ui.toggleResetButton(enabled, tries)
	PARAMETERS: 
	- <boolean> enabled: Whether to enable it or not.
	- <number> tries: The amount of times to attempt disabling the GUI. Defaults to 10.

	RETURNS:
	- nil.

Toggles the reset button in the ROBLOX menu. ]] 
function ui.toggleResetButton(enabled: boolean, tries: number?)
	local retry = 0
	
	local success = false
	repeat 
		success = pcall(function()
			retry += 1
			
			CoreCall("SetCore", "ResetButtonCallback", enabled)
		end)
	until success == true or retry > (tries or 10)
end


--[[ ui.toggleTopBar(enabled, tries)
	PARAMETERS: 
	- <boolean> enabled: Whether to enable it or not.
	- <number> tries: The amount of times to attempt disabling the GUI. Defaults to 10.

	RETURNS:
	- nil.

	Toggles the top bar by ROBLOX. Disabling it also disables CoreGuis including chat, inventory and playerlist. ]] 
function ui.toggleTopBar(enabled: boolean, tries: number?)
	local retry = 0

	local success = false
	repeat 
		success = pcall(function()
			retry += 1
			
			CoreCall("SetCore", "ResetButtonCallback", enabled)
		end)
	until success == true or retry > (tries or 10)
end


--[[ ui.toggleAvatarContextMenu(enabled, unequipTools, humanoid)
	PARAMETERS: 
	- <boolean> enabled: Whether to enable it or not.
	- <boolean> unequipTools: Whether to unequip all tools before activation or not. Defaults to false.
	- <Humanoid> humanoid: The humanoid to disable all tools for. Defaults to nil.

	RETURNS:
	- nil.

	FOOTNOTES:
	- To prevent player interaction with equipped tools, make sure unequipTools is set to true, and to provide their Humanoid instance.

	Toggles the avatar context menu by ROBLOX. Can also force the humanoid to unequip all tools for the menu to work. ]] 
function ui.toggleAvatarContextMenu(enabled: boolean, unequipTools: boolean?, humanoid: Humanoid?)
	if unequipTools == true and humanoid ~= nil then humanoid:UnequipTools() end
	
	CoreCall("SetCore", "AvatarContextMenuEnabled", enabled)
end


--[[ ui.changePlayerOnAvatarContextMenu(player)
	PARAMETERS: 
	- <Player?> player: The player to display in the menu. Can also be nil, in which case the menu is closed.

	RETURNS:
	- nil.

	Changes the displayed player in the avatar context menu. ]] 
function ui.changePlayerOnAvatarContextMenu(player: Player?)
	CoreCall("SetCore", "AvatarContextMenuTarget", player)
end


--[[ ui.addOptionToAvatarContextMenu(option)
	PARAMETERS: 
	- <Enum.AvatarContextMenuOption> option: The option to add into the avatar context menu.

	RETURNS:
	- nil.

	Adds an already specified option to the avatar context menu. ]] 
function ui.addOptionToAvatarContextMenu(option: Enum.AvatarContextMenuOption)
	CoreCall("SetCore", "AddAvatarContextMenuOption", option)
end


--[[ ui.addCustomOptionToAvatarContextMenu(name, fn)
	PARAMETERS: 
	- <string> name: The option to add into the avatar context menu.
	- <function> fn: The function to fire when the option is activated.

	RETURNS:
	- nil.

	Adds a custom option to the avatar context menu. ]] 
function ui.addCustomOptionToAvatarContextMenu(name: string, fn: () -> ()): BindableEvent
	local event = Instance.new("BindableEvent")
	event.Event:Connect(fn)

	CoreCall("SetCore", "AddAvatarContextMenuOption", { name, event })

	return event
end


--[[ ui.removeOptionFromAvatarContextMenu(option)
	PARAMETERS: 
	- <Enum.AvatarContextMenuOption> option: The option to remove from the avatar context menu.

	RETURNS:
	- nil.

	Removes an already specified option to the avatar context menu. ]] 
function ui.removeOptionFromAvatarContextMenu(option: Enum.AvatarContextMenuOption)
	CoreCall("SetCore", "RemoveAvatarContextMenuOption", option)
end


--[[ ui.removeCustomOptionFromAvatarContextMenu(option)
	PARAMETERS: 
	- <string> option: The option to remove from the avatar context menu, by name of the custom option.

	RETURNS:
	- nil.

	Removes a custom option to the avatar context menu. ]] 
function ui.removeCustomOptionFromAvatarContextMenu(option: string)
	CoreCall("SetCore", "RemoveAvatarContextMenuOption", option)
end


--[[ ui.customizeAvatarContextMenuBackground(color, transparency, image, imageTransparency, imageScaleType, imageSliceCenter)
	PARAMETERS: 
	- <Color3> color: The color to set for the background.
	- <number> transparency: The transparency to set for the background.
	- <string?> image: The link to the image. Can be nil.
	- <number?> imageTransparency: The transparency to set for the image, if used. Can be nil.
	- <Enum.ScaleType?> imageScaleType: The scale type for the image, if used. Can be nil.
	- <Rect?> imageSliceCenter: The slice center for the image, if Enum.ScaleType.Slice is used. Can be nil.

	RETURNS:
	- nil.

	Customizes the background of the avatar context menu. ]] 
function ui.customizeAvatarContextMenuBackground(color: Color3, transparency: number, image: string?, imageTransparency: number?, imageScaleType: Enum.ScaleType?, imageSliceCenter: Rect?)
	CoreCall("SetCore", "AvatarContextMenuTheme", {
		BackgroundColor = color,
		BackgroundTransparency = transparency,
		BackgroundImage = image or "",
		BackgroundImageTransparency = imageTransparency or 0,
		BackgroundImageScaleType = imageScaleType or Enum.ScaleType.Stretch,
		BackgroundImageSliceCenter = imageSliceCenter or Rect.new(0, 0, 0, 0),
	})
end


--[[ ui.customizeAvatarContextMenuNameTag(tagColor, underlineColor)
	PARAMETERS: 
	- <Color3> tagColor: The color to set for the tags.
	- <Color3> underlineColor: The color to set for the underlines.

	RETURNS:
	- nil.

	Customizes the name tags of the avatar context menu. ]] 
function ui.customizeAvatarContextMenuNameTag(tagColor: Color3, underlineColor: Color3)
	CoreCall("SetCore", "AvatarContextMenuTheme", {
		NameTagColor = tagColor,
		NameUnderlineColor = underlineColor,
	})
end


--[[ ui.customizeAvatarContextMenuButtonFrame(color, transparency)
	PARAMETERS: 
	- <Color3> color: The color to set for the button frames.
	- <number> transparency: The transparency to set for the button frames.

	RETURNS:
	- nil.

	Customizes the button frame of the avatar context menu. ]] 
function ui.customizeAvatarContextMenuButtonFrame(color: Color3, transparency: number)
	CoreCall("SetCore", "AvatarContextMenuTheme", {
		ButtonFrameColor = color,
		ButtonFrameTransparency = transparency,
	})
end


--[[ ui.customizeAvatarContextMenuButton(color, transparency, hoverColor, hoverTransparency, underlineColor, image, imageScaleType, imageSliceCenter)
	PARAMETERS: 
	- <Color3> color: The color to set for the button.
	- <number> transparency: The transparency to set for the button.
	- <Color3> hoverColor: The color to set for the button when hovered upon.
	- <number> hoverTransparency: The transparency to set for the button when hovered upon.
	- <Color3> underlineColor: The color to set for the underlines between buttons.
	- <string?> image: The link to the image. Can be nil.
	- <Enum.ScaleType?> imageScaleType: The scale type for the image, if used. Can be nil.
	- <Rect?> imageSliceCenter: The slice center for the image, if Enum.ScaleType.Slice is used. Can be nil.

	RETURNS:
	- nil.

	Customizes the buttons of the avatar context menu. ]] 
function ui.customizeAvatarContextMenuButton(color: Color3, transparency: number, hoverColor: Color3, hoverTransparency: number, underlineColor: Color3, image: string?, imageScaleType: Enum.ScaleType?, imageSliceCenter: Rect?)
	CoreCall("SetCore", "AvatarContextMenuTheme", {
		ButtonColor = color,
		ButtonTransparency = transparency,
		ButtonHoverColor = hoverColor,
		ButtonHoverTransparency = hoverTransparency,
		ButtonUnderlineColor = underlineColor,
		ButtonImage = image or "",
		ButtonImageScaleType = imageScaleType or Enum.ScaleType.Stretch,
		ButtonImageSliceCenter = imageSliceCenter or Rect.new(0, 0, 0, 0),
	})
end


--[[ ui.customizeAvatarContextMenuText(font, color, scale)
	PARAMETERS:
	- <Enum.Font> font: The font to set for the text.
	- <Color3> color: The color to set for the text.
	- <number> scale: The scale to set for the text.

	RETURNS:
	- nil.

	Customizes the text of the avatar context menu. ]] 
function ui.customizeAvatarContextMenuText(font: Enum.Font, color: Color3, scale: number)
	CoreCall("SetCore", "AvatarContextMenuTheme", {
		Font = font,
		TextColor = color,
		TextScale = scale,
	})
end


--[[ ui.customizeAvatarContextMenuIcons(close, scrollLeft, scrollRight)
	PARAMETERS:
	- <string> close: The image link for the close button.
	- <string> scrollLeft: The image link for the left scroll bar.
	- <string> scrollRight: The image link for the right scroll bar.

	RETURNS:
	- nil.

	Customizes the icons of the avatar context menu. ]] 
function ui.customizeAvatarContextMenuIcons(close: string, scrollLeft: string, scrollRight: string)
	CoreCall("SetCore", "AvatarContextMenuTheme", {
		LeaveMenuImage = close,
		ScrollLeftImage = scrollLeft,
		ScrollRightImage = scrollRight,
	})
end


--[[ ui.customizeAvatarContextMenuIndicator(part)
	PARAMETERS:
	- <MeshPart> part: The mesh part that appears on top of the target's head when they are selected.

	RETURNS:
	- nil.

	Customizes the indicator of the avatar context menu. ]] 
function ui.customizeAvatarContextMenuIndicator(part: MeshPart)
	CoreCall("SetCore", "AvatarContextMenuTheme", {
		SelectedCharacterIndicator = part,
	})
end


--[[ ui.customizeAvatarContextMenuSizeAndPosition(size, minSize, maxSize, aspectRatio, anchorPoint, onScreenPos, offScreenPos)
	PARAMETERS:
	- <UDim2> size: The overall size of the menu.
	- <Vector2> minSize: The minimum size of the menu.
	- <Vector2> maxSize: The maximum size of the menu.
	- <number> aspectRatio: The aspect ratio of the menu.
	- <Vector2> anchorPoint: The anchor point of the menu.
	- <UDim2> onScreenPos: Where the menu tweens to when opened.
	- <UDim2> offScreenPos: Where the menu tweens to when closed.

	RETURNS:
	- nil.

	Customizes the indicator of the avatar context menu. ]] 
function ui.customizeAvatarContextMenuSizeAndPosition(size: UDim2, minSize: Vector2, maxSize: Vector2, aspectRatio: number, anchorPoint: Vector2, onScreenPos: UDim2, offScreenPos: UDim2)
	CoreCall("SetCore", "AvatarContextMenuTheme", {
		Size = size,
		MinSize = minSize,
		MaxSize = maxSize,
		AspectRatio = aspectRatio,
		AnchorPoint = anchorPoint,
		OnScreenPosition = onScreenPos,
		OffScreenPosition = offScreenPos,
	})
end


--[[ ui.customizeAvatarContextMenuByTable(t)
	PARAMETERS:
	- <table> t: A table containing all the information required to customize the menu.

	RETURNS:
	- nil.

	Customizes the avatar context menu by whatever properties were specified in the table. Only use this if you know what you are doing. ]] 
function ui.customizeAvatarContextMenuByTable(t: {[string]: any})
	CoreCall("SetCore", "AvatarContextMenuTheme", t)
end


--[[ ui.bindToWindowGainedFocus(fn)
	PARAMETERS: 
	- <function> fn: The function to bind to the event.

	RETURNS:
	- <RBXScriptConnection> cxn: The connection to the event. Useful to call for disconnects, etc.

	Binds a given function to the window gained focus event. Also returns the resulting connection. ]] 
function ui.bindToWindowGainedFocus(fn: () -> ()): RBXScriptConnection
	return _USERINPUTSERVICE.WindowFocused:Connect(fn)
end


--[[ ui.bindToWindowLostFocus(fn)
	PARAMETERS: 
	- <function> fn: The function to bind to the event.

	RETURNS:
	- <RBXScriptConnection> cxn: The connection to the event. Useful to call for disconnects, etc.

	Binds a given function to the window lost focus event. Also returns the resulting connection. ]] 
function ui.bindToWindowLostFocus(fn: () -> ()): RBXScriptConnection
	return _USERINPUTSERVICE.WindowFocusReleased:Connect(fn)
end


--[[ ui.bindToMenuToggled(fn)
	PARAMETERS: 
	- <function> fn: The callback to bind to the event. Accepts a boolean argument that returns whether the menu was opened or not.

	RETURNS:
	- <RBXScriptConnection> cxn: The connection to the event. Useful to call for disconnects, etc.

	Binds a given function to the menu closed event. Also returns the resulting connection. ]] 
function ui.bindToMenuToggled(fn: (open: boolean) -> ()): RBXScriptConnection
	return _GUISERVICE:GetPropertyChangedSignal("MenuIsOpen"):Connect(function()
				fn(_GUISERVICE.MenuIsOpen)
	end)
end


--[[ ui.bindToResetButtonActivated(fn)
	PARAMETERS: 
	- <function> fn: The function to bind to the event.

	RETURNS:
	- nil.

	Binds a given function to the reset activated event. Also returns the event object. ]] 
function ui.bindToResetButtonActivated(fn: () -> ()): BindableEvent
	local event = Instance.new("BindableEvent")
	event.Event:Connect(fn)
	
	CoreCall("SetCore", "ResetButtonCallback", event)

	return event
end


return ui