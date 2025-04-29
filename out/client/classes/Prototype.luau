-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local dState = TS.import(script, game:GetService("ReplicatedStorage"), "Imports", "classes", "State").dState
local Prototype
do
	Prototype = setmetatable({}, {
		__tostring = function()
			return "Prototype"
		end,
	})
	Prototype.__index = Prototype
	function Prototype.new(...)
		local self = setmetatable({}, Prototype)
		return self:constructor(...) or self
	end
	function Prototype:constructor(className)
		repeat
			if className == "State" then
				return dState.new()
			end
			do
				error("Attempt to create an instance of unknown class name or type.")
			end
		until true
	end
end
return {
	Prototype = Prototype,
}
