--!nocheck


-- TODO:
-- There's notable typechecking bugs in the engine.
-- This object's typechecking will be disabled until the bugs are resolved.


-- Services
local _REPLICATEDSTORAGE = game:GetService("ReplicatedStorage")


-- Libraries
local ClientLibrary = _REPLICATEDSTORAGE.ClientLibrary

local Enums = require(ClientLibrary.Enums)
local mathv = require(ClientLibrary.Generics.mathv)


-- Upvalues


-- Constants


-- References


-- Variables


-- Functions


-- Module
local Spritesheet = {}
Spritesheet.__index = Spritesheet


-- Types
export type Spritesheet = typeof(setmetatable({} :: {
	_SpritesPerRow: number,
	_SpritesPerColumn: number,
	
	CurrentSprite: number,
	TotalSprites: number?,

	Object: ImageLabel | ImageButton,

	Size: Vector2,
	SpriteSize: Vector2,
	DirectionX: Enums.SpritesheetDirectionX?,
	DirectionY: Enums.SpritesheetDirectionY?,
}, Spritesheet))


--[[ Constructors: 

	Spritesheet.new(image, spritesheetSize, spriteSize, totalSprites, directionX, directionY)
	
]]


--[[ Functions: 

	Spritesheet:Next(step)
	Spritesheet:Previous(step)
	Spritesheet:First()
	Spritesheet:Last()
	Spritesheet:Random()
	Spritesheet:To()
	Spritesheet:Destroy()
	
]]


--[[ Spritesheet.new(image, spritesheetSize, spriteSize, totalSprites, directionX, directionY)
	PARAMETERS: 
	- <ImageLabel | ImageButton> image: The ImageLabel or ImageButton object.
	- <Vector2> spritesheetSize: The size of the entire spritesheet.
	- <Vector2?> spriteSize: The size of the individual sprites. Defaults to image.ImageRectSize.
	- <number?> totalSprites: The number of sprites in the spritesheet. Defaults to spritesheetSize * totalSprites.
	- <Enums.SpritesheetDirectionX> directionX: The horizontal direction to traverse the spritesheet. Defaults to SpritesheetDirectionX.LeftToRight.
	- <Enums.SpritesheetDirectionY> directionY: The vertical direction to traverse the spritesheet. Defaults to SpritesheetDirectionY.TopToBottom.

	RETURNS:
	- <Spritesheet> Spritesheet: The resulting Spritesheet object.
	
	FOOTNOTES:
	- Spritesheets whose size exceed 1024x1024 may suffer a loss in visual quality.
	- If totalSprites is nil, it defaults to spritesheetSize / spriteSize, implying that the spritesheet is entirely occupied with sprites.
	- TotalSprites is zero-based, meaning it starts counting from zero.

	CONSTRUCTOR - Instantiates a new Spritesheet object that allows you to create and interact with spritesheets. ]] 
function Spritesheet.new(image: ImageLabel | ImageButton, spritesheetSize: Vector2, spriteSize: Vector2?, totalSprites: number?, directionX: Enums.SpritesheetDirectionX?, directionY: Enums.SpritesheetDirectionY?): Spritesheet
	-- First fill in missing values.
	local spriteSize = spriteSize or image.ImageRectSize
	local totalSprites = totalSprites or math.floor(spritesheetSize.X / spriteSize.X) * math.floor(spritesheetSize.Y / spriteSize.Y)
	local directionX = directionX or Enums.SpritesheetDirectionX.LeftToRight
	local directionY = directionY or Enums.SpritesheetDirectionY.TopToBottom
	
	-- Then initialize the table.
	local t = {
		_ChangedCallback = function() end,
		
		_SpritesPerRow = math.floor(spritesheetSize.X / spriteSize.X),
		_SpritesPerColumn = math.floor(spritesheetSize.Y / spriteSize.Y),
		
		CurrentSprite = 0,
		TotalSprites = totalSprites,
		
		Object = image,

		Size = spritesheetSize,
		SpriteSize = spriteSize,
		DirectionX = directionX,
		DirectionY = directionY,
	}
	
	-- Then hydrate the UI.
	t.Object.ImageRectSize = spriteSize
	t.Object:SetAttribute("CurrentSprite", 0)
	
	-- Finally return the object.
	return setmetatable(t, Spritesheet)
end


--[[ Spritesheet:Next(step)
	PARAMETERS:
	- <number?> step: How many sprites to advance to. Defaults to 1, meaning the spritesheet will display the next sprite in line.

	RETURNS:
	- nil.
	
	FOOTNOTES:
	- This method overflows; attempting to advance to a sprite beyond the total sprite count will cause it to revert to the first sprite.

	Displays the next sprite. If step is not provided, instead displays the next sprite in line. ]] 
function Spritesheet:Next(step: number?)
	-- First initialize variables and guard clauses.
	local step = step or 1
	local x, y = 0, 0
	
	-- Then update values.
	self.CurrentSprite = mathv.circularclamp(self.CurrentSprite + step, 0, self.TotalSprites - 1) 
	x, y = self.CurrentSprite % self._SpritesPerRow, math.floor(self.CurrentSprite / self._SpritesPerRow)
	
	-- Then update the image object.
	self.Object.ImageRectOffset = self.Object.ImageRectSize * Vector2.new(x, y)
	self.Object:SetAttribute("CurrentSprite", self.CurrentSprite)
end


--[[ Spritesheet:Previous(step)
	PARAMETERS:
	- <number?> step: How many sprites to revert to. Defaults to 1, meaning the spritesheet will display the previous sprite in line.

	RETURNS:
	- nil.
	
	FOOTNOTES:
	- This method overflows; attempting to revert to a sprite beyond 0 will cause it to advance to the last sprite.

	Displays the previous sprite. If step is not provided, instead displays the previous sprite in line. ]] 
function Spritesheet:Previous(step: number?)
	-- First initialize variables and guard clauses.
	local step = step or 1
	local x, y = 0, 0

	-- Then update values.
	self.CurrentSprite = mathv.circularclamp(self.CurrentSprite - step, 0, self.TotalSprites - 1) 
	x, y = self.CurrentSprite % self._SpritesPerRow, math.floor(self.CurrentSprite / self._SpritesPerRow)

	-- Then update the image object.
	self.Object.ImageRectOffset = self.Object.ImageRectSize * Vector2.new(x, y)
	self.Object:SetAttribute("CurrentSprite", self.CurrentSprite)
end


--[[ Spritesheet:First()
	PARAMETERS:
	- nil.

	RETURNS:
	- nil.

	Displays the first sprite. ]] 
function Spritesheet:First()
	if self.Object.ImageRectOffset == Vector2.new(0, 0) then return end
	
	self.Object.ImageRectOffset = Vector2.new(0, 0)
	self.CurrentSprite = 0
	self.Object:SetAttribute("CurrentSprite", self.CurrentSprite)
end


--[[ Spritesheet:Last()
	PARAMETERS:
	- nil.

	RETURNS:
	- nil.

	Displays the last sprite. ]] 
function Spritesheet:Last()
	local x, y = (self._SpritesPerRow - 1) * self.SpriteSize.X, (self._SpritesPerColumn - 1) * self.SpriteSize.Y
	
	if self.Object.ImageRectOffset == Vector2.new(x, y) then return end
	
	self.Object.ImageRectOffset = Vector2.new(x, y)
	self.CurrentSprite = self.TotalSprites
	self.Object:SetAttribute("CurrentSprite", self.CurrentSprite)
end


--[[ Spritesheet:Random(seed)
	PARAMETERS:
	- <number?> seed: The seed for randomness. Defaults to nil.

	RETURNS:
	- nil.

	Displays a random sprite. Optionally specify a seed for randomness. ]] 
function Spritesheet:Random(seed: number?)
	local rnd = Random.new(seed):NextInteger(0, (self.TotalSprites - 1))
	local x, y = rnd % self._SpritesPerRow, math.floor(rnd / self._SpritesPerRow)
	
	self.Object.ImageRectOffset = Vector2.new(x * self.SpriteSize.X, y * self.SpriteSize.Y)
	self.CurrentSprite = rnd 
	self.Object:SetAttribute("CurrentSprite", rnd)
end


--[[ Spritesheet:To(count)
	PARAMETERS:
	- <number> count: The sprite index to display.

	RETURNS:
	- nil.

	Displays the specified sprite. ]] 
function Spritesheet:To(count: number)
	-- Guard clauses
	if count < 0 then error("Attempt to display a sprite with a negative index.") end	
	if count > self.TotalSprites - 1 then warn("Attempt to display a sprite beyond the bounds of the spritesheet.") end
	if count == self.CurrentSprite then return end
	
	local x, y = count % self._SpritesPerRow, math.floor(count / self._SpritesPerColumn)
	
	self.Object.ImageRectOffset = Vector2.new(x * self.SpriteSize.X, y * self.SpriteSize.Y)
	self.CurrentSprite = count
	self.Object:SetAttribute("CurrentSprite", count)
end


--[[ Spritesheet:BindToSpriteChanged(callback)
	PARAMETERS:
	- <function> callback: The callback function that is invoked anytime the sprite is changed.

	RETURNS:
	- nil.

	Binds a function to when the sprite has changed. ]] 
function Spritesheet:BindToSpriteChanged(callback: () -> ())
	self._ChangedCallback = self.Object:GetAttributeChangedSignal("CurrentSprite"):Connect(callback)
end


--[[ Spritesheet:Destroy(all)
	PARAMETERS:
	- <boolean?> all: Whether to also destroy the image object or not. Defaults to false.

	RETURNS:
	- nil.

	Destroys the Spritesheet object. Optionally also destroy the ImageObject. ]] 
function Spritesheet:Destroy(all: boolean?)
	local all = all or false
	
	self.Object:SetAttribute("CurrentSprite", nil)
	self._ChangedCallback:Disconnect()
	if all == true then self.Object:Destroy() end
end


return Spritesheet