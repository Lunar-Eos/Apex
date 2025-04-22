--!strict


-- Services
local _RUNSERVICE = game:GetService("RunService")


-- Libraries


-- Upvalues


-- Constants


-- Variables


-- Module
local runservice = {
	SteppedBinds = {},
	HeartbeatBinds = {},
	PreAnimationBinds = {},
	PreRenderBinds = {},
	PreSimulationBinds = {},
	PostSimulationBinds = {},
}


--[[ Functions: 

	runservice.bindToStepped(name, fn)
	runservice.bindToHeartbeat(name, fn)
	runservice.bindToPreAnimation(name, fn)
	runservice.bindToPreRender(name, fn)
	runservice.bindToPreSimulation(name, fn)
	runservice.bindToPostSimulation(name, fn)
	runservice.unbindFromStepped(name)
	runservice.unbindFromHeartbeat(name)
	runservice.unbindFromPreAnimation(name)
	runservice.unbindFromPreRender(name)
	runservice.unbindFromPreSimulation(name)
	runservice.unbindFromPostSimulation(name)

]]


--[[ runservice.bindToStepped(name, fn)
	PARAMETERS: 
	- <string> name: The name referring to the bound connection. Can be used to disconnect the event later.
	- <function> fn: The function per Stepped event fire.

	RETURNS:
	- nil.

	Binds a given function to the stepped event that fires every frame, prior to physics sim. ]] 
function runservice.bindToStepped(name: string, fn: (t: number, delta: number) -> any?)
	if runservice.SteppedBinds[name] ~= nil then warn(`A function of the name {name} is already bound to Stepped. This call will override that existing function.`) end
	
	runservice.SteppedBinds[name] = _RUNSERVICE.Stepped:Connect(fn)
end


--[[ runservice.bindToHeartbeat(name, fn)
	PARAMETERS: 
	- <string> name: The name referring to the bound connection. Can be used to disconnect the event later.
	- <function> fn: The function per Heartbeat event fire.

	RETURNS:
	- nil.

	Binds a given function to the heartbeat event that fires every frame, after physics sim. ]] 
function runservice.bindToHeartbeat(name: string, fn: (t: number, delta: number) -> any?)
	if runservice.HeartbeatBinds[name] ~= nil then warn(`A function of the name {name} is already bound to Heartbeat. This call will override that existing function.`) end
	
	runservice.HeartbeatBinds[name] = _RUNSERVICE.Stepped:Connect(fn)
end


--[[ runservice.bindToPreAnimation(name, fn)
	PARAMETERS: 
	- <string> name: The name referring to the bound connection. Can be used to disconnect the event later.
	- <function> fn: The function per PreAnimation event fire.

	RETURNS:
	- nil.

	Binds a given function to the preanimation event that fires every frame, prior to physics sim, but after rendering. ]] 
function runservice.bindToPreAnimation(name: string, fn: (t: number, delta: number) -> any?)
	if runservice.PreAnimationBinds[name] ~= nil then warn(`A function of the name {name} is already bound to PreAnimation. This call will override that existing function.`) end

	runservice.PreAnimationBinds[name] = _RUNSERVICE.Stepped:Connect(fn)
end


--[[ runservice.bindToPreRender(name, fn)
	PARAMETERS: 
	- <string> name: The name referring to the bound connection. Can be used to disconnect the event later.
	- <function> fn: The function per PreRender event fire.

	RETURNS:
	- nil.

	Binds a given function to the prerender event that fires every frame, prior to rendering. ]] 
function runservice.bindToPreRender(name: string, fn: (t: number, delta: number) -> any?)
	if runservice.PreRenderBinds[name] ~= nil then warn(`A function of the name {name} is already bound to PreRender. This call will override that existing function.`) end

	runservice.PreRenderBinds[name] = _RUNSERVICE.Stepped:Connect(fn)
end


--[[ runservice.bindToPreSimulation(name, fn)
	PARAMETERS: 
	- <string> name: The name referring to the bound connection. Can be used to disconnect the event later.
	- <function> fn: The function per PreSimulation event fire.

	RETURNS:
	- nil.

	Binds a given function to the presimulation event that fires every frame, prior to physics sim. ]] 
function runservice.bindToPreSimulation(name: string, fn: (t: number, delta: number) -> any?)
	if runservice.PreSimulationBinds[name] ~= nil then warn(`A function of the name {name} is already bound to PreSimulation. This call will override that existing function.`) end

	runservice.PreSimulationBinds[name] = _RUNSERVICE.Stepped:Connect(fn)
end


--[[ runservice.bindToPostSimulation(name, fn)
	PARAMETERS: 
	- <string> name: The name referring to the bound connection. Can be used to disconnect the event later.
	- <function> fn: The function per PostSimulation event fire.

	RETURNS:
	- nil.

	Binds a given function to the postsimulation event that fires every frame, after physics sim. ]] 
function runservice.bindToPostSimulation(name: string, fn: (t: number, delta: number) -> any?)
	if runservice.PostSimulationBinds[name] ~= nil then warn(`A function of the name {name} is already bound to PostSimulation. This call will override that existing function.`) end

	runservice.PostSimulationBinds[name] = _RUNSERVICE.Stepped:Connect(fn)
end


--[[ runservice.unbindFromStepped(name, fn)
	PARAMETERS: 
	- <string> name: The name referring to the bound connection.

	RETURNS:
	- nil.

	Unbinds a named function from the stepped event. ]] 
function runservice.unbindFromStepped(name: string)
	if runservice.SteppedBinds[name] == nil then 
		warn(`No such function of the name {name} was bound to Stepped. This call is ignored.`) 
		return 
	end

	runservice.SteppedBinds[name]:Disconnect()
	runservice.SteppedBinds[name] = nil
end


--[[ runservice.unbindFromHeartbeat(name, fn)
	PARAMETERS: 
	- <string> name: The name referring to the bound connection.

	RETURNS:
	- nil.

	Unbinds a named function from the heartbeat event. ]] 
function runservice.unbindFromHeartbeat(name: string)
	if runservice.HeartbeatBinds[name] == nil then 
		warn(`No such function of the name {name} was bound to Heartbeat. This call is ignored.`) 
		return 
	end

	runservice.HeartbeatBinds[name]:Disconnect()
	runservice.HeartbeatBinds[name] = nil
end


--[[ runservice.unbindFromPreAnimation(name, fn)
	PARAMETERS: 
	- <string> name: The name referring to the bound connection.

	RETURNS:
	- nil.

	Unbinds a named function from the preanimation event. ]]
function runservice.unbindFromPreAnimation(name: string)
	if runservice.PreAnimationBinds[name] == nil then 
		warn(`No such function of the name {name} was bound to PreAnimation. This call is ignored.`) 
		return 
	end

	runservice.PreAnimationBinds[name]:Disconnect()
	runservice.PreAnimationBinds[name] = nil
end


--[[ runservice.unbindFromPreRender(name, fn)
	PARAMETERS: 
	- <string> name: The name referring to the bound connection.

	RETURNS:
	- nil.

	Unbinds a named function from the prerender event. ]]
function runservice.unbindFromPreRender(name: string)
	if runservice.PreRenderBinds[name] == nil then 
		warn(`No such function of the name {name} was bound to PreRender. This call is ignored.`) 
		return 
	end

	runservice.PreRenderBinds[name]:Disconnect()
	runservice.PreRenderBinds[name] = nil
end


--[[ runservice.unbindFromPreSimulation(name, fn)
	PARAMETERS: 
	- <string> name: The name referring to the bound connection.

	RETURNS:
	- nil.

	Unbinds a named function from the presimulation event. ]]
function runservice.unbindFromPreSimulation(name: string)
	if runservice.PreSimulationBinds[name] == nil then 
		warn(`No such function of the name {name} was bound to PreSimulation. This call is ignored.`) 
		return 
	end

	runservice.PreSimulationBinds[name]:Disconnect()
	runservice.PreSimulationBinds[name] = nil
end


--[[ runservice.unbindFromPostSimulation(name, fn)
	PARAMETERS: 
	- <string> name: The name referring to the bound connection.

	RETURNS:
	- nil.

	Unbinds a named function from the postsimulation event. ]]
function runservice.unbindFromPostSimulation(name: string)
	if runservice.PostSimulationBinds[name] == nil then 
		warn(`No such function of the name {name} was bound to PostSimulation. This call is ignored.`) 
		return 
	end

	runservice.PostSimulationBinds[name]:Disconnect()
	runservice.PostSimulationBinds[name] = nil
end


return runservice