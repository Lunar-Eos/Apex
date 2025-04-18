--!strict


-- Services


-- Libraries


-- Upvalues


-- Constants


-- Variables


-- Functions


-- Module
local TextFormatterOptions = {}


--[[ Functions: 

	TextFormatterOptions.new()

]]


--[[ TextFormatterOptions.new()
	PARAMETERS: 
	- nil.

	RETURNS:
	- <TextFormatterOptions> options: The resulting TextFormatterOptions object. 

	CONSTRUCTOR - Instantiates a new TextFormatterOptions object. Does nothing on its own, but can be used to customize TextFormatter objects. ]] 
function TextFormatterOptions.new(): TextFormatterOptions
	return {
		Font = Font.new("rbxasset://fonts/families/Arial.json"),
		
		TextColor3 = Color3.new(1, 1, 1),
		TextTransparency = 0,
		TextDirection = Enum.TextDirection.LeftToRight,
		TextSize = 24,
		
		TextStrokeColor3 = Color3.new(0, 0, 0),
		TextStrokeTransparency = 1,
		
		TextXAlignment = Enum.HorizontalAlignment.Left,
		TextYAlignment = Enum.VerticalAlignment.Center,
		TextPaddingLeft = UDim.new(0, 0),
		TextPaddingRight = UDim.new(0, 0),
		TextPaddingTop = UDim.new(0, 0),
		TextPaddingBottom = UDim.new(0, 0),
		
		LineHeight = 24,
		BreakHeight = 48,
		
		FlexBehavior = Enum.UIFlexAlignment.None,
		
		LabelBackgroundColor3 = Color3.new(0, 0, 0),
		LabelBackgroundTransparency = 0,
		LabelStrokeColor3 = Color3.new(0, 0, 0),
		LabelStrokeSize = 1,
		LabelStrokeMode = Enum.BorderMode.Outline,
	}
end


-- Types
export type TextFormatterOptions = {
	Font: Font,

	TextColor3: Color3,
	TextTransparency: number,
	TextDirection: Enum.TextDirection,
	TextSize: number,
	
	TextStrokeColor3: Color3,
	TextStrokeTransparency: number,
	
	TextXAlignment: Enum.HorizontalAlignment,
	TextYAlignment: Enum.VerticalAlignment,
	TextPaddingLeft: UDim,
	TextPaddingRight: UDim,
	TextPaddingTop: UDim,
	TextPaddingBottom: UDim,
	
	LineHeight: number,
	BreakHeight: number,
	
	FlexBehavior: Enum.UIFlexAlignment,

	LabelBackgroundColor3: Color3,
	LabelBackgroundTransparency: number,
	LabelStrokeColor3: Color3,
	LabelStrokeSize: number,
	LabelStrokeMode: Enum.BorderMode,
}


return TextFormatterOptions