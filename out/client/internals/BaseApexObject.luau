-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Object = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "object-utils")
local dState = TS.import(script, game:GetService("ReplicatedStorage"), "Imports", "classes", "State").dState
local BaseApexObject
do
	BaseApexObject = setmetatable({}, {
		__tostring = function()
			return "BaseApexObject"
		end,
	})
	BaseApexObject.__index = BaseApexObject
	function BaseApexObject.new(...)
		local self = setmetatable({}, BaseApexObject)
		return self:constructor(...) or self
	end
	function BaseApexObject:constructor(className)
		repeat
			if className == "State" then
				local object = dState.new()
				self.ClassName = "Test"
				return Object.assign(self, object)
			end
			do
				self.ClassName = "BaseApexObject"
				error("Attempt to create an instance of unknown class name or type.")
			end
		until true
	end
	function BaseApexObject:Destroy()
		for k, v in pairs(self) do
			local _arg0 = self[k]
			local t = typeof(_arg0)
			if t == "RBXScriptConnection" then
				v:Disconnect()
			elseif t == "Instance" then
				v:Destroy()
			end
			self[k] = nil
		end
	end
end
return {
	BaseApexObject = BaseApexObject,
}
