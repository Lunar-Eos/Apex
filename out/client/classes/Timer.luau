-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local RunService = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService
local BaseApexObject = TS.import(script, game:GetService("ReplicatedStorage"), "Imports", "internals", "BaseApexObject").BaseApexObject
local dTimer
do
	local super = BaseApexObject
	dTimer = setmetatable({}, {
		__tostring = function()
			return "dTimer"
		end,
		__index = super,
	})
	dTimer.__index = dTimer
	function dTimer.new(...)
		local self = setmetatable({}, dTimer)
		return self:constructor(...) or self
	end
	function dTimer:constructor()
		super.constructor(self, "Timer")
		self._CountThread = nil
		self._ChangeFunction = function() end
		self._EndFunction = function() end
		self._InterruptFunction = function() end
		self._SecondsLeft = 0
		self.TimeScale = 1
		self.Seconds = 0
	end
	function dTimer:CompareTimes(object)
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
	function dTimer:Start()
		self._SecondsLeft = self.Seconds
		self._CountThread = RunService.Heartbeat:Connect(self:CompareTimes(self))
	end
	function dTimer:Resume()
		self._CountThread = RunService.Heartbeat:Connect(self:CompareTimes(self))
	end
	function dTimer:Pause()
		self._InterruptFunction();
		(self._CountThread):Disconnect()
	end
	function dTimer:Stop()
		self._InterruptFunction();
		(self._CountThread):Disconnect()
		self._SecondsLeft = self.Seconds
	end
	function dTimer:GetRemaining()
		return self._SecondsLeft
	end
	function dTimer:BindToChanged(callback)
		self._ChangeFunction = callback
	end
	function dTimer:BindToCompleted(callback)
		self._EndFunction = callback
	end
	function dTimer:BindToInterrupted(callback)
		self._InterruptFunction = callback
	end
end
return {
	dTimer = dTimer,
}
