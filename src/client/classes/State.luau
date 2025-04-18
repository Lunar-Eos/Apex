-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local BaseApexObject = TS.import(script, game:GetService("ReplicatedStorage"), "Imports", "internals", "BaseApexObject").BaseApexObject
local State
do
	local super = BaseApexObject
	State = setmetatable({}, {
		__tostring = function()
			return "State"
		end,
		__index = super,
	})
	State.__index = State
	function State.new(...)
		local self = setmetatable({}, State)
		return self:constructor(...) or self
	end
	function State:constructor(val)
		super.constructor(self, "State")
		self._Callbacks = {}
		self.Value = val
	end
	function State:fireCallbacks(a, b)
		for _, callback in pairs(self._Callbacks) do
			callback(a, b)
		end
	end
	function State:Get()
		return self.Value
	end
	function State:Set(a)
		if a == self.Value then
			return nil
		end
		local prev = self.Value
		self.Value = a
		self:fireCallbacks(prev, self.Value)
	end
	function State:Update(fn)
		local prev = self.Value
		self.Value = fn(self.Value)
		self:fireCallbacks(prev, self.Value)
	end
	function State:BindOnChange(name, callback)
		self._Callbacks[name] = callback
	end
	function State:UnbindOnChange(name)
		self._Callbacks[name] = nil
	end
end
return {
	State = State,
}
