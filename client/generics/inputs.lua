--!nocheck


-- Services
local _USERINPUTSERVICE = game:GetService("UserInputService")
local _GUISERVICE = game:GetService("GuiService")


-- Libraries


-- Upvalues


-- Constants


-- Variables


-- Module
local inputs = {}


--[[ DISCLAIMER: These functions are CLIENT-ONLY.
     Any attempt to use them outside of the client will error. ]]

--[[ Functions: 

	inputs.getMousePosition()
	inputs.getPlatform()
	inputs.isNumberKey(input)

]]


--[[ inputs.getMousePosition()
	PARAMETERS: 
	- nil.

	RETURNS:
	- <number> x: The mouse's current X position.
	- <number> y: The mouse's current Y position.

	Returns the mouse's current position. ]] 
function inputs.getMousePosition(): (number, number)
	return _USERINPUTSERVICE:GetMouseLocation().X, _USERINPUTSERVICE:GetMouseLocation().Y
end


--[[ inputs.getPlatform()
	PARAMETERS: 
	- nil.

	RETURNS:
	- <string> platform: The platform of the current device. Returns either "Console", "PC", "Tablet", or "Mobile".

	Gets the platform of the current player's device. ]] 
function inputs.getPlatform(): string
	if _GUISERVICE:IsTenFootInterface() == true then
		return "Console"
	elseif _USERINPUTSERVICE.TouchEnabled == true and _USERINPUTSERVICE.MouseEnabled == false then
		return if workspace.CurrentCamera.ViewportSize.Y > 600 then "Tablet" else "Mobile"
	else
		return "PC"
	end
end


--[[ inputs.isNumberKey(inputs)
	PARAMETERS: 
	- <InputObject> inputs: The InputObject.

	RETURNS:
	- <boolean> is: Whether the input object is a boolean or not.
	
	FOOTNOTES:
	- This is most effective when used in an InputBegan/Changed/Ended event.

	Returns whether the inputs is a number key or not. ]] 
function inputs.isNumberKey(inputs: InputObject): boolean
	return 
		inputs.KeyCode == Enum.KeyCode.One or
		inputs.KeyCode == Enum.KeyCode.Two or
		inputs.KeyCode == Enum.KeyCode.Three or
		inputs.KeyCode == Enum.KeyCode.Four or
		inputs.KeyCode == Enum.KeyCode.Five or
		inputs.KeyCode == Enum.KeyCode.Six or
		inputs.KeyCode == Enum.KeyCode.Seven or
		inputs.KeyCode == Enum.KeyCode.Eight or
		inputs.KeyCode == Enum.KeyCode.Nine or
		inputs.KeyCode == Enum.KeyCode.Zero
end


return inputs