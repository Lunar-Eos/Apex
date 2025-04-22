-- Compiled with roblox-ts v3.0.0
local Spritesheet
do
	Spritesheet = setmetatable({}, {
		__tostring = function()
			return "Spritesheet"
		end,
	})
	Spritesheet.__index = Spritesheet
	function Spritesheet.new(...)
		local self = setmetatable({}, Spritesheet)
		return self:constructor(...) or self
	end
	function Spritesheet:constructor()
		self._ChangedCallback = function() end
		self._SpritesPerRow = 10
		self._SpritesPerColumn = 10
		self.CurrentSprite = 0
		self.TotalSprites = 100
		self.Object = "image"
		self.Size = Vector2.new(140, 140)
		self.SpriteSize = Vector2.new(14, 14)
		self.DirectionX = "Left"
		self.DirectionY = "Down"
	end
end
return {
	Spritesheet = Spritesheet,
}
