-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local BaseApexObject = TS.import(script, game:GetService("ReplicatedStorage"), "Imports", "internals", "BaseApexObject").BaseApexObject
local dStateTable
do
	local super = BaseApexObject
	dStateTable = setmetatable({}, {
		__tostring = function()
			return "dStateTable"
		end,
		__index = super,
	})
	dStateTable.__index = dStateTable
	function dStateTable.new(...)
		local self = setmetatable({}, dStateTable)
		return self:constructor(...) or self
	end
	function dStateTable:constructor()
		super.constructor(self, "StateTable")
		self._Callbacks = {}
		self.Value = {}
	end
	function dStateTable:Get(key)
		return self.Value[key]
	end
	function dStateTable:Set(key, a)
		if a == self.Value[key] then
			return nil
		end
		local prev = self.Value[key]
		self.Value[key] = a
		for _, callback in pairs(self._Callbacks) do
			callback(prev, self.Value[key])
		end
	end
	function dStateTable:Update(key, fn)
		local prev = self.Value[key]
		self.Value[key] = fn(self.Value[key])
		for _, callback in pairs(self._Callbacks) do
			callback(prev, self.Value[key])
		end
	end
	function dStateTable:BindOnChange(name, callback)
		self._Callbacks[name] = callback
	end
	function dStateTable:UnbindOnChange(name)
		self._Callbacks[name] = nil
	end
end
return {
	dStateTable = dStateTable,
}
