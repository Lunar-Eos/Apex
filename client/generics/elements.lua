--!strict


-- Services
local _TEXTSERVICE = game:GetService("TextService")
local _CONTENTPROVIDER = game:GetService("ContentProvider")


-- Libraries


-- Upvalues


-- Constants


-- Variables


-- Functions


-- Module
local elements = {}


--[[ Functions: 

	elements.preload(...)
	elements.getTextDimensions(text, font, size, frameSize, yield)

]]


--[[ elements.preload(...)
	PARAMETERS: 
	- <GuiObject> ...: The GUIs to preload.

	RETURNS:
	- nil.

	Preloads the target GUI elements. Useful for loading in fonts, images, etc ahead of time. ]] 
function elements.preload(t: { [number]: GuiObject })
	_CONTENTPROVIDER:PreloadAsync(t, function(asset, id)
		if asset == "" then return end
		
		if id ~= Enum.AssetFetchStatus.Success then
			warn(`{asset} load status: {string.upper(id.Name)}`)
		end
	end)
end


--[[ elements.getTextDimensions(text, font, size, width, yield)
	PARAMETERS: 
	- <string> text: The text to find the length of in pixels.
	- <Font> b: The text font in question. Must be a Font object, NOT an Enum.Font.
	- <number> size: The font size.
	- <number> frameSize: The width of the frame/container that would be holding the text.
	- <boolean?> yield: Whether to yield the function. Defaults to true.

	RETURNS:
	- <Vector2> result: The amount of space in pixels.

	YIELDING - Returns the amount of space that the text would take on a screen in pixels, given the dimensions and information. ]] 
function elements.getTextDimensions(text: string, font: Font, size: number, frameSize: number, yield: boolean?): Vector2
	local params = Instance.new("GetTextBoundsParams")
	params.Text = text
	params.Font = font
	params.Width = frameSize
	params.Size = size
	
	local result = _TEXTSERVICE:GetTextBoundsAsync(params)
	if yield == true then repeat task.wait() until result ~= nil end
	
	return result
end


return elements