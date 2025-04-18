--!nocheck
-- ROBLOX BUG: TYPECHECKING


-- Services
local _RUNSERVICE = game:GetService("RunService")


-- Libraries


-- Upvalues


-- Constants


-- Variables


-- Functions
local function CompareTimes(object: Timer)
	return function(delta: number)
		object._ChangeFunction()

		object._SecondsLeft = math.clamp(object._SecondsLeft - (delta * object.TimeScale), 0, object.Seconds)
		if object._SecondsLeft > 0 then return end

		object._EndFunction()
		object._CountThread:Disconnect()
	end
end


-- Module
local Timer = {}
Timer.__index = Timer


--[[ Constructors: 

	Timer.new(seconds, timeScale)
	
]]


--[[ Functions: 

	Timer:Start()
	Timer:Pause()
	Timer:Stop()
	Timer:GetRemainingTime()
	Timer:BindToChanged(callback)
	Timer:BindToCompleted(callback)
	Timer:BindToInterrupted(callback)

]]


--[[ Timer.new(seconds, timeScale)
	PARAMETERS: 
	- <number> seconds: The amount of seconds to set the Timer to.
	- <number?> timeScale: How fast or slow to count down. Defaults to 1.

	RETURNS:
	- <Timer> Timer: The resulting Timer object.
	
	FOOTNOTES:
	- Setting Timer.TimeScale to 0 freezes the Timer.
	- Setting Timer.TimeScale to 1 counts the Timer down at normal speed.

	CONSTRUCTOR - Instantiates a new Timer object. Enables tracking of time and triggering of events after elapsed time. ]] 
function Timer.new(seconds: number, timeScale: number?): Timer
	local t = {
		_CountThread = nil,

		_ChangeFunction = function() end,
		_EndFunction = function() end,
		_InterruptFunction = function() end,
		
		_SecondsLeft = seconds,
		
		TimeScale = timeScale or 1,
		Seconds = seconds,
	}
	
	return setmetatable(t, Timer)
end


--[[ Timer:Start()
	PARAMETERS: 
	- nil.

	RETURNS:
	- nil.

	Begins the Timer's countdown. ]] 
function Timer:Start()
	self._SecondsLeft = self.Seconds

	self._CountThread = _RUNSERVICE.Heartbeat:Connect(CompareTimes(self))
end


--[[ Timer:Resume()
	PARAMETERS: 
	- nil.

	RETURNS:
	- nil.

	Resumes the Timer's countdown. Use this on Timers that you have recently paused. ]] 
function Timer:Resume()
	self._CountThread = _RUNSERVICE.Heartbeat:Connect(CompareTimes(self))
end


--[[ Timer:Pause()
	PARAMETERS: 
	- nil.

	RETURNS:
	- nil.

	Pauses the Timer's countdown, preserving its remaining duration. ]] 
function Timer:Pause()
	self._InterruptFunction()
	self._CountThread:Disconnect()
end


--[[ Timer:Stop()
	PARAMETERS: 
	- nil.

	RETURNS:
	- nil.

	Stops the Timer's countdown, resetting its remaining duration. ]] 
function Timer:Stop()
	self._InterruptFunction()
	self._CountThread:Disconnect()

	self._SecondsLeft = self.Seconds
end


--[[ Timer:GetRemainingTime()
	PARAMETERS: 
	- nil.

	RETURNS:
	- <number> t: The amount of seconds left in the Timer object.

	Returns the amount of seconds left within the Timer. ]] 
function Timer:GetRemainingTime()
	return self._SecondsLeft
end


--[[ Timer:BindToChanged(callback)
	PARAMETERS: 
	- <function> callback: The callback that is invoked everytime the Timer begins counting.

	RETURNS:
	- nil.

	Binds a function that gets invoked everytime the Timer counts. ]] 
function Timer:BindToChanged(callback: () -> ())
	self._ChangeFunction = callback
end


--[[ Timer:BindToCompleted(callback)
	PARAMETERS: 
	- <function> callback: The callback that is invoked when the Timer finishes.

	RETURNS:
	- nil.

	Binds a function that gets invoked when the Timer finishes. ]] 
function Timer:BindToCompleted(callback: () -> ())
	self._EndFunction = callback
end


--[[ Timer:BindToInterrupted(callback)
	PARAMETERS: 
	- <function> callback: The callback that is invoked when the Timer gets interrupted during its course.

	RETURNS:
	- nil.

	Binds a function that gets invoked when the Timer is interrupted by pausing or stopping it. ]] 
function Timer:BindToInterrupted(callback: () -> ())
	self._InterruptFunction = callback
end


-- Types
export type Timer = typeof(setmetatable({} :: {
	Seconds: number,
	TimeScale: number,
}, Timer))


return Timer