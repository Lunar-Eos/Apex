-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local BaseApexObject = TS.import(script, game:GetService("ReplicatedStorage"), "Imports", "internals", "BaseApexObject").BaseApexObject
local StateTable
do
	local super = BaseApexObject
	StateTable = setmetatable({}, {
		__tostring = function()
			return "StateTable"
		end,
		__index = super,
	})
	StateTable.__index = StateTable
	function StateTable.new(...)
		local self = setmetatable({}, StateTable)
		return self:constructor(...) or self
	end
	function StateTable:constructor(val)
		super.constructor(self, "StateTable")
		self._Callbacks = {}
		self.Value = val
	end
	function StateTable:fireCallbacks(a, b)
		for _, callback in pairs(self._Callbacks) do
			callback(a, b)
		end
	end
	function StateTable:Get(key)
		return self.Value[key]
	end
	function StateTable:Set(key, a)
		if a == self.Value[key] then
			return nil
		end
		local prev = self.Value[key]
		self.Value[key] = a
		self:fireCallbacks(prev, self.Value[key])
	end
	function StateTable:Update(key, fn)
		local prev = self.Value[key]
		self.Value[key] = fn(self.Value[key])
		self:fireCallbacks(prev, self.Value[key])
	end
	function StateTable:BindOnChange(name, callback)
		self._Callbacks[name] = callback
	end
	function StateTable:UnbindOnChange(name)
		self._Callbacks[name] = nil
	end
end
return {
	StateTable = StateTable,
}
