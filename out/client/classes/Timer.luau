-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local RunService = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService
local BaseApexObject = TS.import(script, game:GetService("ReplicatedStorage"), "Imports", "internals", "BaseApexObject").BaseApexObject
local Timer
do
	local super = BaseApexObject
	Timer = setmetatable({}, {
		__tostring = function()
			return "Timer"
		end,
		__index = super,
	})
	Timer.__index = Timer
	function Timer.new(...)
		local self = setmetatable({}, Timer)
		return self:constructor(...) or self
	end
	function Timer:constructor(seconds, scale)
		super.constructor(self, "Timer")
		self._CountThread = nil
		self._ChangeFunction = function() end
		self._EndFunction = function() end
		self._InterruptFunction = function() end
		self._SecondsLeft = 0
		self.TimeScale = 1
		self.Seconds = 0
		self._SecondsLeft = seconds
		self.TimeScale = scale
		self.Seconds = seconds
	end
	function Timer:CompareTimes(object)
		return function(delta)
			object._ChangeFunction()
			object._SecondsLeft = math.clamp(object._SecondsLeft - delta * object.TimeScale, 0, object.Seconds)
			if object._SecondsLeft > 0 then
				return nil
			end
			object._EndFunction();
			(object._CountThread):Disconnect()
		end
	end
	function Timer:Start()
		self._SecondsLeft = self.Seconds
		self._CountThread = RunService.Heartbeat:Connect(self:CompareTimes(self))
	end
	function Timer:Resume()
		self._CountThread = RunService.Heartbeat:Connect(self:CompareTimes(self))
	end
	function Timer:Pause()
		self._InterruptFunction();
		(self._CountThread):Disconnect()
	end
	function Timer:Stop()
		self._InterruptFunction();
		(self._CountThread):Disconnect()
		self._SecondsLeft = self.Seconds
	end
	function Timer:GetRemaining()
		return self._SecondsLeft
	end
	function Timer:BindToChanged(callback)
		self._ChangeFunction = callback
	end
	function Timer:BindToCompleted(callback)
		self._EndFunction = callback
	end
	function Timer:BindToInterrupted(callback)
		self._InterruptFunction = callback
	end
end
return {
	Timer = Timer,
}
