--!strict


-- Services
local _REPLICATEDSTORAGE = game:GetService("ReplicatedStorage")
local _TEXTSERVICE = game:GetService("TextService")


-- Libraries
local ClientLibrary = _REPLICATEDSTORAGE.ClientLibrary

local stringv = require(ClientLibrary.Generics.stringv)
local instance = require(ClientLibrary.Generics.instance)

local TextFormatterOptions = require(ClientLibrary.Classes.UI.TextFormatterOptions)


-- Upvalues


-- Constants
local TAGS = {
	{ `<font color="#">`, `</font>` },
	{ `<font color="rgb()">`, `</font>` },
	{ `<font size="">`, `</font>` },
	{ `<font face="">`, `</font>` },
	{ `<font family="">`, `</font>` },
	{ `<font weight="">`, `</font>` },
	{ `<font transparency="">`, `</font>` },
	{ `<stroke="">`, `</stroke>` },
	{ `<b>`, `</b>` },
	{ `<i>`, `</i>` },
	{ `<u>`, `</u>` },
	{ `<s>`, `</s>` },
	{ `<uppercase>`, `</uppercase>` },
	{ `<uc>`, `</uc>` },
	{ `<smallcaps>`, `</smallcaps>` },
	{ `<sc>`, `</sc>` },
	{ `<queryable="">`, `</queryable>` },
	{ `<image="">`, `</image>` },
}


-- References


-- Variables


-- Functions
local function GetSpaceSizeSynchronous(options: TextFormatterOptions): number
	local PARAMS = Instance.new("GetTextBoundsParams")
	PARAMS.Text = " "
	PARAMS.Size = options.TextSize
	PARAMS.Font = options.Font

	local SPACE_SIZE = _TEXTSERVICE:GetTextBoundsAsync(PARAMS)

	repeat task.wait() until SPACE_SIZE ~= nil

	return SPACE_SIZE.X
end
local function CreateObject(isFrame: boolean, options: TextFormatterOptions, parent: Instance?): InternalTextFormatter
	local container = Instance.new(if isFrame == true then "Frame" else "ScrollingFrame")
	local containerLayout = Instance.new("UIListLayout")
	local containerPadding = Instance.new("UIPadding")
	
	container.Size = UDim2.fromOffset(200, 200)

	containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
	containerLayout.Padding = UDim.new(0, options.BreakHeight)

	containerPadding.PaddingLeft = options.TextPaddingLeft
	containerPadding.PaddingRight = options.TextPaddingRight
	containerPadding.PaddingTop = options.TextPaddingTop
	containerPadding.PaddingBottom = options.TextPaddingBottom

	containerLayout.Parent = container
	containerPadding.Parent = container
	container.Parent = parent
	
	if isFrame == false then
		container.AutomaticCanvasSize = Enum.AutomaticSize.Y
		container.CanvasSize = UDim2.fromScale(0, 0)
	end
	
	return {
		Container = container,

		RawText = "",
		Text = "",

		Options = options,
	}
end
local function CreateNewLine(object: InternalTextFormatter): Frame
	local newLine = Instance.new("Frame")
	newLine.AutomaticSize = Enum.AutomaticSize.Y
	newLine.Size = UDim2.new(1, 0, 0, 0)
	newLine.BackgroundTransparency = 1
	newLine.Name = `Newline{#instance.getChildrenWhichIsA(object.Container, "Frame") + 1}`
	
	local newLineSort = Instance.new("UIListLayout")
	newLineSort.FillDirection = Enum.FillDirection.Horizontal
	newLineSort.SortOrder = Enum.SortOrder.LayoutOrder
	newLineSort.Wraps = true
	newLineSort.Padding = UDim.new(0, GetSpaceSizeSynchronous(object.Options)) 
	
	newLineSort.Parent = newLine
	newLine.Parent = object.Container
	
	return newLine
end
local function CreateNewWord(str: string, options: TextFormatterOptions, parent: Frame): TextLabel
	local existingWords = #instance.getChildrenWhichIsA(parent, "TextLabel") + 1
	
	local newWord = Instance.new("TextLabel")
	newWord.AutomaticSize = Enum.AutomaticSize.XY
	newWord.BackgroundTransparency = 1
	newWord.Size = UDim2.new(0, 0, 0, 0)
	newWord.Name = tostring(existingWords)
	newWord.LayoutOrder = existingWords
	newWord.Text = str

	newWord.Parent = parent

	return newWord
end
local function CreateNewWords(str: string, options: TextFormatterOptions, parent: Frame)
	for _, word in string.split(str, " ") do
		CreateNewWord(word, options, parent)
	end
end



-- Module
local TextFormatter = {}
TextFormatter.__index = TextFormatter


--[[ Functions: 

	TextFormatter.new()

]]


--[[ TextFormatter.inFrame(options)
	[ MUTATIVE ]

	PARAMETERS: 
	- <TextFormatterOptions> options: The TextFormatterOptions object to modify the TextFormatter object with.

	RETURNS:
	- <TextFormatter> TextFormatter: The resulting TextFormatter object.

	CONSTRUCTOR - Instantiates a new TextFormatter object. Enables text hovering and icons in text within a Frame. ]] 
function TextFormatter.inFrame(options: TextFormatterOptions, parent: Instance?): TextFormatter
	return setmetatable(CreateObject(true, options, parent), TextFormatter)
end


--[[ TextFormatter.inScroll(options)
	[ MUTATIVE ]

	PARAMETERS: 
	- <TextFormatterOptions> options: The TextFormatterOptions object to modify the TextFormatter object with.

	RETURNS:
	- <TextFormatter> TextFormatter: The resulting TextFormatter object.

	CONSTRUCTOR - Instantiates a new TextFormatter object. Enables text hovering and icons in text within a ScrollingFrame. ]] 
function TextFormatter.inScroll(options: TextFormatterOptions, parent: Instance?): TextFormatter
	return setmetatable(CreateObject(false, options, parent), TextFormatter)
end


--[[ TextFormatter:SetText(text)
	[ YIELDING ]

	PARAMETERS: 
	- <string> text: The text to change into.

	RETURNS:	
	- nil.

	FOOTNOTES:
	- This is the recommended method to change text, as it also recalculates the bounds of the container.

	Changes the text within the TextFormatter object. ]] 
function TextFormatter:SetText(text: string)
	local self: TextFormatter = self
	
	-- Guard clause to detect if the text is empty. If so, clears the container's children and skips execution.
	do
		if text == "" then
			for _, child in instance.getChildrenWhichIsA(self.Container, "Frame") do child:Destroy() end

			return 
		end
	end
	
	-- Insert raw text.
	do
		local rawText = text
		rawText = string.gsub(text, "&lt;", "<")
		rawText = string.gsub(text, "&gt;", ">")
		rawText = string.gsub(text, "&quot;", '"')
		rawText = string.gsub(text, "&apos;", "'")
		rawText = string.gsub(text, "&amp;", "&")
		rawText = string.gsub(text, "%b<>", "")
		
		self.RawText = rawText
	end
	
	-- Create words.
	do
		local newLine = CreateNewLine(self)
		for _, word in string.split(text, " ") do CreateNewWord(word, self.Options, newLine) end
	end

	--local newLine = CreateNewLine(self)
end



function TextFormatter:TestSetText(text: string)
	local self: TextFormatter = self

	-- Guard clause to detect if the text is empty. If so, clears the container's children and skips execution.
	do
		if text == "" then
			for _, child in instance.getChildrenWhichIsA(self.Container, "Frame") do child:Destroy() end

			return 
		end
	end

	local rawText = text
	local currentLine = CreateNewLine(self)
	local startIndex: number = 1
	local finishIndex: number = #rawText
	local currentString = ""
	
	-- Process into raw text.
	do
		rawText = string.gsub(rawText, "&lt;", "<")
		rawText = string.gsub(rawText, "&gt;", ">")
		rawText = string.gsub(rawText, "&quot;", '"')
		rawText = string.gsub(rawText, "&apos;", "'")
		rawText = string.gsub(rawText, "&amp;", "&")

		self.RawText = rawText
	end
	
	-- Process into TextLabels.
	do
		-- For the start part of string, where there are richtext tags left.
		for start, caught, finish in string.gmatch(rawText, "()(%b<>)()") do
			local start: number = start - 1
			local finish: number = finish :: number
			
			finishIndex = start
			currentString = string.sub(rawText, startIndex, finishIndex)
			startIndex = finish
			
			CreateNewWords(currentString, self.Options, currentLine)
			
			-- If breakline, start new line.
			if caught == "<br/>" then currentLine = CreateNewLine(self) continue end
		end
		
		-- For the end part of string, where there are NO richtext tags left.
		currentString = string.sub(rawText, startIndex, #rawText)
		CreateNewWords(currentString, self.Options, currentLine)
	end
	
	for i = 20, 1, -0.1 do
		print(i)
	end
end





















--[[ TextFormatter:Iterate(callback)
	PARAMETERS:
	- <function> callback: The function that fires anytime a match is found within the text body. Returns an argument of the TextLabel containing that text.

	RETURNS:	
	- nil.

	Iterates through the text body, returning every traversed TextLabel, and firing the attached callback. ]] 
function TextFormatter:Iterate(callback: (TextLabel) -> ())
	
end


-- Types
type TextFormatterOptions = TextFormatterOptions.TextFormatterOptions
type InternalTextFormatter = { 
	Container: Frame | ScrollingFrame,
	
	RawText: string,
	Text: string,

	Options: TextFormatterOptions,
}

export type TextFormatter = typeof(setmetatable({} :: InternalTextFormatter, TextFormatter))


return TextFormatter