-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local BaseApexObject = TS.import(script, game:GetService("ReplicatedStorage"), "Imports", "internals", "BaseApexObject").BaseApexObject
local dState
do
	local super = BaseApexObject
	dState = setmetatable({}, {
		__tostring = function()
			return "dState"
		end,
		__index = super,
	})
	dState.__index = dState
	function dState.new(...)
		local self = setmetatable({}, dState)
		return self:constructor(...) or self
	end
	function dState:constructor()
		super.constructor(self, "State")
		self._Callbacks = {}
		self.Value = 0
	end
	function dState:Get()
		return self.Value
	end
	function dState:Set(a)
		if a == self.Value then
			return nil
		end
		local prev = self.Value
		self.Value = a
		for _, callback in pairs(self._Callbacks) do
			callback(prev, self.Value)
		end
	end
	function dState:Update(fn)
		local prev = self.Value
		self.Value = fn(self.Value)
		for _, callback in pairs(self._Callbacks) do
			callback(prev, self.Value)
		end
	end
	function dState:BindOnChange(name, callback)
		self._Callbacks[name] = callback
	end
	function dState:UnbindOnChange(name)
		self._Callbacks[name] = nil
	end
end
return {
	dState = dState,
}
