-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local dState = TS.import(script, game:GetService("ReplicatedStorage"), "Imports", "classes", "State").dState
local dCircularCooldown = TS.import(script, game:GetService("ReplicatedStorage"), "Imports", "classes", "CircularCooldown").dCircularCooldown
local dStateTable = TS.import(script, game:GetService("ReplicatedStorage"), "Imports", "classes", "StateTable").dStateTable
local dTimer = TS.import(script, game:GetService("ReplicatedStorage"), "Imports", "classes", "Timer").dTimer
local dRadialCooldown = TS.import(script, game:GetService("ReplicatedStorage"), "Imports", "classes", "RadialCooldown").dRadialCooldown
local dPanel = TS.import(script, game:GetService("ReplicatedStorage"), "Imports", "classes", "Panel").dPanel
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
			if className == "StateTable" then
				return dStateTable.new()
			end
			if className == "Timer" then
				return dTimer.new()
			end
			if className == "CircularCooldown" then
				return dCircularCooldown.new()
			end
			if className == "RadialCooldown" then
				return dRadialCooldown.new()
			end
			if className == "Panel" then
				return dPanel.new()
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
