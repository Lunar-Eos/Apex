-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local BaseApexObject = TS.import(script, game:GetService("ReplicatedStorage"), "Imports", "internals", "BaseApexObject").BaseApexObject
local State = TS.import(script, game:GetService("ReplicatedStorage"), "Imports", "classes", "State").State
local Prototype
do
	local super = BaseApexObject
	Prototype = setmetatable({}, {
		__tostring = function()
			return "Prototype"
		end,
		__index = super,
	})
	Prototype.__index = Prototype
	function Prototype.new(...)
		local self = setmetatable({}, Prototype)
		return self:constructor(...) or self
	end
	function Prototype:constructor(className)
		super.constructor(self)
		repeat
			if className == "State" then
				self.ClassName = "State"
				return State.new()
			end
			do
				self.ClassName = "BaseApexObject"
				error("Attempt to create an instance of unknown class name or type.")
			end
		until true
	end
end
return {
	Prototype = Prototype,
}
