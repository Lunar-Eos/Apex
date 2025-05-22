-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local BaseApexObject = TS.import(script, game:GetService("ReplicatedStorage"), "Imports", "internals", "BaseApexObject").BaseApexObject
local dPanel
do
	local super = BaseApexObject
	dPanel = setmetatable({}, {
		__tostring = function()
			return "dPanel"
		end,
		__index = super,
	})
	dPanel.__index = dPanel
	function dPanel.new(...)
		local self = setmetatable({}, dPanel)
		return self:constructor(...) or self
	end
	function dPanel:constructor()
		super.constructor(self, "Panel")
		self._Connections = {}
		self._Callbacks = {}
		self._Instructions = {}
		self._Hooks = {}
		self._Default = nil
		self.Parent = nil
	end
	function dPanel:SetParent(gui)
		local old = self.Parent
		self.Parent = gui
	end
	function dPanel:WriteInstruction(name, callback)
		if self._Instructions[name] ~= nil then
			warn(`Panel - Overwritten instruction of name {name}.`)
		end
		self._Instructions[name] = callback
	end
	function dPanel:DeleteInstruction(name)
		self._Instructions[name] = nil
	end
	function dPanel:ClearInstructions()
		for k in pairs(self._Instructions) do
			self._Instructions[k] = nil
		end
	end
	function dPanel:Connect(instance, eventName, callback)
		-- Table of connections and callbacks could be Null for new instances - initialize one first.
		local __Callbacks = self._Callbacks
		local _instance = instance
		if __Callbacks[_instance] == nil then
			local __Callbacks_1 = self._Callbacks
			local _instance_1 = instance
			__Callbacks_1[_instance_1] = {}
		end
		-- Is eventName a valid event for provided instance?
		local _arg0 = instance[eventName]
		local _arg0_1 = typeof(_arg0) == "RBXScriptSignal"
		assert(_arg0_1, "Panel - Attempt to access a non-event for the provided instance.")
		local __Callbacks_1 = self._Callbacks
		local _instance_1 = instance;
		(__Callbacks_1[_instance_1])[eventName] = callback
		local __Callbacks_2 = self._Callbacks
		local _exp = instance
		local __Callbacks_3 = self._Callbacks
		local _instance_2 = instance
		local _arg1 = __Callbacks_3[_instance_2]
		__Callbacks_2[_exp] = _arg1
	end
	function dPanel:Disconnect(instance, eventName)
		local __Connections = self._Connections
		local _instance = instance
		local connectionTable = __Connections[_instance]
		connectionTable[eventName]:Disconnect()
		connectionTable[eventName] = nil
	end
	function dPanel:Execute()
		local clearConnections = function()
			for _, events in pairs(self._Connections) do
				for _, connection in pairs(events) do
					connection:Disconnect()
				end
			end
		end
		local addConnections = function()
			for instance, events in pairs(self._Callbacks) do
				for eventName, callback in pairs(events) do
					if self._Connections[instance] == nil then
						self._Connections[instance] = {}
					end
					(self._Connections[instance])[eventName] = (instance[eventName]):Connect(callback)
				end
			end
		end
		local runInstructions = function()
			for _, instruction in pairs(self._Instructions) do
				instruction()
			end
		end
		local execute = function()
			if self._Default ~= nil then
				self._Default()
			end
			local _result = self.Parent
			if _result ~= nil then
				_result = _result.Enabled
			end
			if _result == true then
				clearConnections()
				addConnections()
				runInstructions()
			else
				clearConnections()
			end
		end
		execute()
		local _result = self.Parent
		if _result ~= nil then
			_result = _result:GetPropertyChangedSignal("Enabled"):Connect(execute)
		end
	end
	function dPanel:Default(callback)
		self._Default = callback
	end
	function dPanel:Hook(name, callback)
		self._Hooks[name] = callback
	end
	function dPanel:Unhook(name)
		self._Hooks[name] = nil
	end
	function dPanel:Fire(name, ...)
		local args = { ... }
		self._Hooks[name](unpack(args))
	end
end
return {
	dPanel = dPanel,
}
