-- Compiled with roblox-ts v3.0.0
local TextFormatterOptions
do
	TextFormatterOptions = setmetatable({}, {
		__tostring = function()
			return "TextFormatterOptions"
		end,
	})
	TextFormatterOptions.__index = TextFormatterOptions
	function TextFormatterOptions.new(...)
		local self = setmetatable({}, TextFormatterOptions)
		return self:constructor(...) or self
	end
	function TextFormatterOptions:constructor()
		self.Font = Font.new("rbxasset://fonts/families/Arial.json")
		self.TextColor3 = Color3.new(1, 1, 1)
		self.TextTransparency = 0
		self.TextDirection = Enum.TextDirection.LeftToRight
		self.TextSize = 24
		self.TextStrokeColor3 = Color3.new(0, 0, 0)
		self.TextStrokeTransparency = 1
		self.TextXAlignment = Enum.HorizontalAlignment.Left
		self.TextYAlignment = Enum.VerticalAlignment.Center
		self.TextPaddingLeft = UDim.new(0, 0)
		self.TextPaddingRight = UDim.new(0, 0)
		self.TextPaddingTop = UDim.new(0, 0)
		self.TextPaddingBottom = UDim.new(0, 0)
		self.LineHeight = 24
		self.BreakHeight = 48
		self.FlexBehavior = Enum.UIFlexAlignment.None
		self.LabelBackgroundColor3 = Color3.new(0, 0, 0)
		self.LabelBackgroundTransparency = 0
		self.LabelStrokeColor3 = Color3.new(0, 0, 0)
		self.LabelStrokeSize = 1
		self.LabelStrokeMode = Enum.BorderMode.Outline
	end
end
return {
	TextFormatterOptions = TextFormatterOptions,
}
